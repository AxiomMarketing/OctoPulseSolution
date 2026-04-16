# Cost Monitoring — Anthropic API

Script de monitoring quotidien des coûts API Anthropic avec alerte Telegram.

## Fichiers

- `~/octopulse/kairos/cost-monitor.py` — script principal
- `~/.config/systemd/user/cost-monitor.service` — service oneshot
- `~/.config/systemd/user/cost-monitor.timer` — timer quotidien 09:00

## Configuration

| Variable env | Défaut | Rôle |
|---|---|---|
| `COST_DAILY_ALERT_USD` | `20` | Seuil USD/24h déclenchant l'alerte |

## Comportement

- Exécuté chaque jour à 09:00 UTC+4 via systemd timer
- Parse les logs KAIROS (`~/logs/kairos/runs/*.jsonl`) des 24h glissantes
- Compte les runs, estime les tokens (5 000 tokens/run par défaut)
- Enregistre une entrée JSONL dans `~/logs/kairos/cost-monitor.jsonl`
- Si `estimated_usd > COST_DAILY_ALERT_USD` : notification Telegram (priority=high) vers chat 7234705861 (Marty)

## Méthodologie estimation

- **5 000 tokens par run KAIROS** (estimation conservatrice MVP)
- **Prix moyen $45/1M tokens** (Opus 4.6, 50% input / 50% output, avril 2026)
- Formula : `runs_24h × 5000 / 1_000_000 × 45 = estimated_usd`

## Limites MVP

- Pas d'accès à l'API Anthropic usage réelle (requires admin API + org key)
- Estimation grossière basée uniquement sur les runs KAIROS loggés
- Les sessions Claude Code interactives ne sont pas comptées

## TODO v2

- Intégrer `GET /v1/organizations/usage` (Anthropic admin API) quand clé admin dispo
- Affiner estimate tokens par run en parsant les usage logs Claude Code (`~/.claude/logs/`)

## Commandes utiles

```bash
# Test manuel
~/octopulse/kairos/venv/bin/python3 ~/octopulse/kairos/cost-monitor.py

# Test avec seuil bas (force alerte)
COST_DAILY_ALERT_USD=0.01 ~/octopulse/kairos/venv/bin/python3 ~/octopulse/kairos/cost-monitor.py

# Voir le timer
systemctl --user list-timers | grep cost

# Logs
tail -f ~/logs/kairos/cost-monitor.jsonl
```
