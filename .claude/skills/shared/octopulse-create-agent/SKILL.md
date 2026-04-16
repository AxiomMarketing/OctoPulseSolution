---
name: octopulse:create-agent
description: Crée un nouvel agent master OctoPulse avec workflow progressif 10 étapes (validation, génération .md, skills squelettes, bootstrap ClawMem vault, patches communication-protocol + KAIROS + CLAUDE.md, chaînage sub-agents, sync VPS/Mac, validation). Utiliser pour ajouter un agent à n'importe quel service métier (marketing, comptabilité, support, etc.). Garantit la cohérence structurelle cross-services. Rollback structuré si échec.
argument-hint: <inputs YAML ou via prompt guided>
---

<objective>
Générer un agent master OctoPulse respectant intégralement la structure standard (agent.md + skills + vault + protocole + KAIROS + doc). Toute création manuelle d'agent est interdite (drift garanti) — utiliser ce skill.
</objective>

<when_to_use>
**Use when:**
- Ajouter un nouveau master agent à OctoPulse (n'importe quel service)
- Scaler un service avec de nouveaux agents spécialisés
- Répliquer un pattern existant (ex: cloner forge.md pour un autre service)

**Don't use for:**
- Sub-agents → utiliser `/octopulse:create-sub-agent`
- Bootstrap d'un nouveau service métier → utiliser `/octopulse:create-service` d'abord
- Édition d'un agent existant (modifier le .md directement)
</when_to_use>

<parameters>
## Inputs requis

| Variable | Type | Description |
|----------|------|-------------|
| `name` | string | Kebab-case regex `^[a-z][a-z0-9-]{2,31}$`, unique dans `.claude/agents/` |
| `service` | string | Nom service métier (marketing, comptabilite, support-client, commercial, financier, ...) |
| `model` | enum | `claude-sonnet-4-6` \| `claude-opus-4-6` \| `claude-haiku-4-5-20251001` |
| `effort` | enum | `low` \| `medium` \| `high` (si opus) |
| `description_short` | string | 1 phrase pour le frontmatter |
| `role_long` | string | Paragraphe "Tu es X, qui fait Y, pour Z" |
| `skills_initial` | array | Liste `{name, description}` — squelettes à créer |

## Inputs optionnels

| Variable | Type | Description |
|----------|------|-------------|
| `sub_agents` | array | Liste `{name, description, model}` — enchaîne create-sub-agent |
| `crons` | array | Liste `{id, cron, prompt, priority}` — ajoute dans KAIROS config |
| `direct_flows` | array | Liste `{direction: 'in'\|'out', peer, message_type}` |
| `auto_mode` | boolean | Skip confirmations (défaut: true) |
</parameters>

<state_variables>
Variables persistées entre les steps (en mémoire + `/tmp/octopulse-create-agent-state.json` pour rollback) :

| Variable | Set by | Usage |
|----------|--------|-------|
| `{name}` | step-00 | Nom de l'agent à créer |
| `{service}` | step-00 | Service métier cible |
| `{model}`, `{effort}` | step-00 | Modèle Claude |
| `{description_short}`, `{role_long}` | step-00 | Pour substitution template |
| `{skills_initial}` | step-00 | Skills à créer |
| `{sub_agents}`, `{crons}`, `{direct_flows}` | step-00 | Optionnels |
| `{tools_list}` | step-00 | Liste tools (défaut : Read, Write, Edit, Bash, Grep, Glob) |
| `{auto_mode}` | step-00 | Mode autonome |
| `{created_files}` | accumulé | Liste fichiers créés — utilisé par rollback |
| `{patched_files}` | accumulé | Liste fichiers patchés avec backup — utilisé par rollback |
| `{clawmem_collections}` | accumulé | Collections ClawMem créées — utilisé par rollback |
</state_variables>

<entry_point>
**FIRST ACTION:** Load `steps/step-00-init.md`
</entry_point>

<step_files>

| Step | File | Purpose | Conditional |
|------|------|---------|-------------|
| 00 | `steps/step-00-init.md` | Parse inputs, validate regex + unicity, init state JSON | — |
| 01 | `steps/step-01-generate-agent-md.md` | Read template, substitute vars, write `.claude/agents/{name}.md` | — |
| 02 | `steps/step-02-create-skills.md` | Create skills folder + squelettes par skill_initial | — |
| 03 | `steps/step-03-bootstrap-vault.md` | mkdir agent-memory + clawmem collection add + marker | — |
| 04 | `steps/step-04-patch-communication.md` | Append ligne dans communication-protocol.md | Si `direct_flows` |
| 05 | `steps/step-05-patch-kairos.md` | Append jobs dans kairos/config.yml + restart service | Si `crons` |
| 06 | `steps/step-06-chain-subs.md` | Invoker `/octopulse:create-sub-agent` pour chaque sub | Si `sub_agents` |
| 07 | `steps/step-07-patch-claude-md.md` | Ajouter ligne section "Agents disponibles" | — |
| 08 | `steps/step-08-sync-mirror.md` | scp VPS → Mac miroir pour tous les fichiers | — |
| 09 | `steps/step-09-validate.md` | `clawmem doctor` + `kairos-ctl list` + frontmatter parse | — |
| 10 | `steps/step-10-summary.md` | Output résumé + checklist prochaines étapes utilisateur | — |
| 99 | `steps/step-99-rollback.md` | Undo based on state JSON (créé/patché/clawmem) | On failure |

</step_files>

<execution_rules>
- **Load one step at a time** (progressive loading — pas tout charger d'un coup)
- **ULTRA THINK** avant validation finale (step-09)
- **Persist state** dans `/tmp/octopulse-create-agent-state.json` après chaque step
- **Follow next_step directive** à la fin de chaque step
- **Rollback on failure** : load `step-99-rollback.md`, utiliser state JSON pour undo
- **Idempotent** : ré-exécuter le skill avec les mêmes inputs = skip gracefully (agent déjà existe)
</execution_rules>

<targets>
- **VPS** : `octopulse@204.168.209.232` (déploiement principal)
- **Mac miroir** : `/Users/admin/octopulse/` (sync via step-08)
- **ClawMem** : via `~/bin/bw-ensure-unlock.sh` + `clawmem` CLI sur VPS
- **KAIROS** : `~/octopulse/kairos/config.yml` + `systemctl --user restart kairos.service`
</targets>
