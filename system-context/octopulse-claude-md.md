# OctoPulse — Instance VPS

## Contexte

Cette instance Claude tourne en bypass permissions sur le VPS de production. Elle coordonne 22 agents marketing (10 masters + 12 sub-agents) avec ClawMem multi-vault, et reçoit des messages via le plugin Telegram officiel.

## Règles absolues

### Telegram : TOUJOURS utiliser le tool `reply`

Chaque message entrant `<channel source="telegram" ...>` — **qu'il soit texte ou un vocal transcrit** — **DOIT** recevoir une réponse via l'outil MCP `mcp__plugin_telegram_telegram__reply`, en passant le `chat_id` du message entrant. Ne jamais répondre uniquement en texte dans la session : l'utilisateur n'a pas d'accès direct au terminal, Telegram est son seul canal.

Les vocaux transcrits arrivent comme des messages texte normaux (préfixe `🎙️` optionnel ou texte brut selon la version du patch). Même pour ces messages, la règle est la même : **tool reply obligatoire**.

Si la transcription vocale est incomplète ou ambigüe, demande la clarification directement via `reply` — ne jamais ignorer.

### Routage agents

Le bot est utilisé pour parler aux agents marketing. Si le message contient une mention `@stratege`, `@atlas`, `@forge`, `@maeva`, `@radar`, `@funnel`, `@keeper`, `@nexus`, `@sparky`, `@sentinel`, invoque l'agent correspondant via le tool Agent. Sans mention, la session principale traite directement.

### Agents disponibles

Voir `~/octopulse/.claude/agents/` pour la liste complète (10 masters, 12 sub-agents).

### Voice middleware

Le patch `~/octopulse/voice-middleware/patch-voice.py` transcrit les vocaux via Groq Whisper avant qu'ils n'arrivent ici. La clé est dans Bitwarden (`groq-api-key`). Si une transcription arrive vide ou erronée, vérifier `~/logs/voice-middleware/transcribe.log`.

### ClawMem

Le système de mémoire ClawMem tourne en embedding GGUF CPU (fenêtre AutoDream 02:00-06:00). 23 vaults actifs dans `~/.claude/agent-memory/`. Ne pas modifier leur structure sans demander.

### KAIROS

Boucle tick autonome 24/7 qui déclenche les agents sur 3 types d'événements :
1. **Planifiés** (cron YAML dans `kairos/config.yml`) — 17 jobs pré-configurés (Atlas daily, Sparky hebdo, Sentinel lundi, etc.)
2. **Calendrier** — alertes lead-time J-45/J-30/J-14 générées depuis `team-workspace/marketing/references/calendrier-evenements.md`
3. **Réactifs** — tout agent peut déposer un fichier YAML dans `kairos/triggers/inbox/` pour déclencher un tick à la prochaine itération

#### Pour déclencher un tick depuis un agent

Utiliser le format YAML dans `~/octopulse/kairos/triggers/inbox/<id>.yml` :

```yaml
id: <unique-id>
agent: atlas          # nom de l'agent cible (optionnel)
prompt: "Analyse le drop CPM sur ad set B depuis 3h"
priority: high        # normal | high | critical
submitter: radar-scout-concurrence
created_at: 2026-04-15T12:34:00Z
notify_on: [completion, failure]
```

Ou via CLI : `kairos-ctl trigger <agent> "<prompt>" --priority high`

#### Commandes utiles

- `kairos-ctl status` — uptime, heartbeat, 5 prochains runs
- `kairos-ctl list` — tableau complet des jobs
- `kairos-ctl logs -n 100 [--job <id>]` — derniers logs structurés
- `kairos-ctl trigger <agent> "<prompt>"` — déclenche un tick réactif immédiat
- `systemctl --user status kairos.service` — état daemon
- `journalctl --user-unit=kairos.service -f` — logs live

#### Quand NE PAS utiliser KAIROS

- Action immédiate dans la session courante → utilise directement le tool Agent
- Dialogue conversationnel → reste dans la session (KAIROS = événements asynchrones planifiables)

### Création d'agents et services — DÉTERMINISTE via skills

OctoPulse évolue : de nouveaux agents et services sont ajoutés régulièrement. Pour garantir la cohérence structurelle, **utiliser obligatoirement les 3 skills de scaffolding** plutôt que créer les fichiers manuellement.

| Besoin | Skill | Étapes | Quand |
|---|---|---|---|
| Nouveau master agent | `/octopulse:create-agent` | 14 | Tout nouvel agent avec ses propres skills, crons potentiels, flux directs |
| Nouveau sub-agent | `/octopulse:create-sub-agent` | 6 | Sous-capacité attachée à un master existant (nommé `<master>-<sub>`) |
| Nouveau service métier | `/octopulse:create-service` | 10 | Nouveau domaine (compta, support, commercial, financier, RH, etc.) |

**Règle absolue** : ne JAMAIS créer un agent/service à la main. Drift structurel garanti (oubli ClawMem vault, communication-protocol non patché, CLAUDE.md désynchronisé, etc.). Les 3 skills sont idempotentes, validées, et gèrent le rollback.

**Ordre logique** :
1. `/octopulse:create-service` d'abord (si nouveau domaine)
2. `/octopulse:create-agent` pour les masters du service
3. `/octopulse:create-sub-agent` pour les subs des masters

Les 3 skills sont dans `.claude/skills/shared/` avec leurs templates dans `.claude/skills/shared/templates/`. Tu peux les invoquer directement (Skill tool) ou y référer dans un prompt aux agents.

### Appels API externes — TOUJOURS via /api:safe-call

Ne JAMAIS appeler une API externe (Meta Ads, Shopify, Printful, Klaviyo, PostHog) directement avec `curl` sans suivre le workflow `/api:safe-call`. Ce workflow :
1. Consulte la doc indexée via ClawMem (`/api:query-docs`)
2. Valide la requête contre le JSON Schema local (`/api:validate-request`)
3. Vérifie le rate-limit par agent+API
4. Exécute avec clé Bitwarden cache + logging JSONL

Protection contre les incidents API (app bloquée par requêtes erronées). Si un recipe existe dans `integrations/recipes/<service>/`, utilise-le en priorité.
