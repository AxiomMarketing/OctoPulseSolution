# KAIROS — Autonomous Tick Loop Daemon

KAIROS is a 24/7 Python daemon that drives the OctoPulse multi-agent marketing system on a scheduled, calendar-aware, and reactive basis.

## 1. Vue d'ensemble

KAIROS écoute en continu (tick toutes les 60 s) et déclenche les agents Claude sur 3 types d'événements : jobs cron planifiés en YAML, alertes lead-time calendar, et triggers réactifs déposés par d'autres agents.

```
┌─────────────────────────────────────────────────────────┐
│                      kairos.py                          │
│              (daemon asyncio 24/7)                      │
└───────────┬──────────────┬──────────────────────────────┘
            │              │                  │
    ┌───────▼──────┐ ┌─────▼──────┐ ┌────────▼───────┐
    │  scheduler   │ │ calendar   │ │   reactive     │
    │  (cron YAML) │ │ _engine    │ │  (file watcher)│
    │  17 jobs     │ │ J-45/30/14 │ │  inbox/ watch  │
    └───────┬──────┘ └─────┬──────┘ └────────┬───────┘
            │              │                  │
    ┌───────▼──────────────▼──────────────────▼───────┐
    │              claude_runner.py                    │
    │         (subprocess claude -p wrapper)           │
    └───────────────────────┬──────────────────────────┘
                            │
            ┌───────────────▼───────────────┐
            │      telegram_notifier.py     │
            │   (alertes + heartbeat msgs)  │
            └───────────────────────────────┘
```

## 2. Installation

### Prérequis

- Python 3.10+
- `claude` CLI disponible dans PATH avec `--dangerously-skip-permissions`
- Dépendances : `croniter`, `pyyaml`, `httpx`

### Étapes

```bash
# Sur VPS en tant qu'octopulse
cd ~/octopulse/kairos
./install.sh          # crée le venv, installe les dépendances, déploie le .service

# Activer le linger (daemon survit à la déconnexion SSH)
sudo loginctl enable-linger octopulse

# Démarrer le service
systemctl --user start kairos.service
systemctl --user enable kairos.service   # démarrage auto au boot

# Vérifier
systemctl --user status kairos.service
kairos-ctl status
```

### install.sh est idempotent

Re-exécuter `./install.sh` est sans danger : il recrée le venv proprement et recharge le .service sans casser la config existante.

## 3. Configuration

### Structure de config.yml

| Section | Champs clés | Description |
|---------|-------------|-------------|
| `kairos` | `tick_interval`, `log_level`, `log_dir` | Comportement global du daemon |
| `claude` | `binary`, `timeout`, `flags` | Chemin CLI + flags (`--dangerously-skip-permissions`) |
| `jobs` | `id`, `cron`, `agent`, `prompt`, `enabled`, `notify` | Liste des jobs planifiés |
| `calendar` | `source_file`, `lead_times`, `state_file` | Lecture calendrier + fenêtres J-45/J-30/J-14 |
| `reactive` | `inbox_dir`, `processed_dir`, `invalid_dir`, `poll_interval` | Répertoires triggers réactifs |

### Champs d'un job

```yaml
jobs:
  - id: atlas-daily-brief           # identifiant unique (utilisé dans les logs)
    cron: "0 7 * * *"               # expression cron standard
    agent: atlas                     # nom de l'agent cible
    prompt: "Génère le brief..."    # prompt envoyé via claude -p
    enabled: true                    # false = désactivé sans supprimer
    notify: true                     # envoie une notification Telegram
    timeout: 900                     # timeout en secondes (défaut: 900)
```

Voir `config.example.yml` pour le template annoté complet avec tous les champs disponibles.

## 4. Usage quotidien

### Commandes kairos-ctl

| Commande | Description |
|----------|-------------|
| `kairos-ctl status` | Uptime, heartbeat, 5 prochains runs |
| `kairos-ctl list` | Tableau complet de tous les jobs (id, cron, next_run, enabled) |
| `kairos-ctl enable <id>` | Active un job désactivé |
| `kairos-ctl disable <id>` | Désactive un job sans le supprimer |
| `kairos-ctl logs -n 100` | 100 dernières lignes de logs structurés |
| `kairos-ctl logs --job <id>` | Logs filtrés pour un job spécifique |
| `kairos-ctl trigger <agent> "<prompt>"` | Déclenche un tick réactif immédiat |
| `kairos-ctl trigger <agent> "<prompt>" --priority high` | Tick réactif haute priorité |
| `kairos-ctl reload` | Recharge config.yml sans redémarrer le daemon |
| `kairos-ctl dry-run <id>` | Simule l'exécution d'un job sans l'exécuter |

### Exemples

```bash
# Voir l'état global
kairos-ctl status

# Lister les jobs et voir quand ils tournent ensuite
kairos-ctl list

# Déclencher un job réactif manuellement
kairos-ctl trigger atlas "Analyse le drop CPM sur ad set B depuis 3h" --priority high

# Suivre les logs en temps réel
journalctl --user-unit=kairos.service -f

# Désactiver temporairement un job
kairos-ctl disable sparky-weekly-report
```

### Déposer un trigger réactif (format YAML)

Un agent peut déclencher un tick en déposant un fichier dans `~/octopulse/kairos/triggers/inbox/` :

```yaml
id: <unique-id>
agent: atlas          # nom de l'agent cible (optionnel)
prompt: "Analyse le drop CPM sur ad set B depuis 3h"
priority: high        # normal | high | critical
submitter: radar-scout-concurrence
created_at: 2026-04-15T12:34:00Z
notify_on: [completion, failure]
```

## 5. Architecture

### Modules

```
kairos.py               ← entrypoint daemon (asyncio event loop)
├── scheduler.py        ← évalue les crons, décide quels jobs sont dus
├── calendar_engine.py  ← parse calendrier-evenements.md, calcule lead-times
├── reactive.py         ← surveille triggers/inbox/, valide et dispatch
├── claude_runner.py    ← lance subprocess "claude -p <prompt>", capture stdout/stderr
└── telegram_notifier.py← envoie notifications via Telegram Bot API (httpx direct)
```

### Flot d'un tick

```
Tick (toutes les 60 s)
  │
  ├── scheduler.check_due()
  │     → liste des jobs dont next_run <= now
  │     → pour chaque job : claude_runner.run(agent, prompt)
  │
  ├── calendar_engine.check_windows()
  │     → parse calendrier-evenements.md
  │     → fenêtres J-45/J-30/J-14 non encore fired
  │     → pour chaque fenêtre : claude_runner.run(agent, prompt_template)
  │
  ├── reactive.drain_inbox()
  │     → liste des fichiers YAML dans triggers/inbox/
  │     → valide le schéma, dispatch claude_runner.run()
  │     → déplace vers processed/ ou invalid/
  │
  └── telegram_notifier.heartbeat()
        → met à jour le fichier heartbeat
        → envoie alertes si failures
```

### Persistence

- `kairos/heartbeat` — mtime mis à jour à chaque tick (health check externe)
- `kairos/calendar_state.json` — garde trace des fenêtres calendar déjà déclenchées
- `kairos/logs/` — logs structurés JSONL par jour

## 6. Troubleshooting

| Symptôme | Diagnostic | Solution |
|----------|------------|----------|
| Daemon ne démarre pas | `journalctl --user-unit=kairos.service -n 50` | Vérifier les erreurs Python au démarrage (souvent config.yml invalide ou venv cassé) |
| Heartbeat manquant (>5 min) | `systemctl --user status kairos.service` + `kairos-ctl logs -n 20` | Redémarrer le service : `systemctl --user restart kairos.service` |
| Job jamais déclenché | `kairos-ctl list` → colonne `enabled` et `next_run` | Vérifier `enabled: true` dans config.yml, valider la syntaxe cron avec `kairos-ctl dry-run <id>` |
| `claude -p` bloque indéfiniment | Logs montrent timeout 900 s puis kill | Vérifier que `--dangerously-skip-permissions` est dans les flags ; réduire la complexité du prompt |
| Telegram silencieux | `cat ~/logs/kairos/telegram.jsonl` | Vérifier throttle 5 messages/min ; contrôler `TELEGRAM_BOT_TOKEN` + `TELEGRAM_CHAT_ID` dans l'env |
| Venv cassé / import errors | `python -m kairos --version` échoue | Re-run `./install.sh` (idempotent, recrée le venv proprement) |

### Commandes de diagnostic rapide

```bash
# État complet du service
systemctl --user status kairos.service

# Logs live
journalctl --user-unit=kairos.service -f

# Vérifier le heartbeat (alerte si >5 min)
find ~/octopulse/kairos/heartbeat -mmin +5

# Inspecter les logs Telegram
cat ~/logs/kairos/telegram.jsonl | tail -20

# Tester la config sans redémarrer
kairos-ctl dry-run atlas-daily-brief
```
