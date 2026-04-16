---
name: kairos:delegate
description: Workflow progressif 7 étapes pour qu'un agent délègue une action asynchrone à KAIROS via dépôt d'un trigger YAML. Valide que KAIROS est le bon outil (decision tree), collecte inputs, applique matrices priority/notify_on, vérifie règles CC Sparky + anti-abus, génère et dépose le YAML, notifie Sparky si cross-domaine. À utiliser quand une action doit se faire "plus tard", "en parallèle", "cross-agent non-bloquant".
argument-hint: <inputs ou prompt guided>
---

<objective>
Permettre à n'importe quel agent OctoPulse de programmer une action asynchrone via KAIROS, en respectant toutes les conventions (format YAML canonique, priority/notify_on corrects, CC Sparky pour cross-domaine, anti-abus). Workflow déterministe pour éviter les déviations.
</objective>

<when_to_use>
**Use when:**
- Action qu'un AUTRE agent doit faire, non-bloquante pour toi → priority=high
- Action à différer (heures ou jours) → priority=normal
- Réponse à un événement business (anomalie, alerte, urgence) → priority=critical

**DON'T use for:**
- Action immédiate que tu fais toi-même → reste dans la session courante
- Action synchrone d'un autre agent dont tu as besoin du résultat maintenant → tool Agent direct
- Action récurrente → demande à Sparky d'ajouter un cron dans `kairos/config.yml`
- Événement calendaire futur connu → édite `calendrier-evenements.md` (KAIROS génère lead-times)
</when_to_use>

<parameters>
## Inputs requis

| Variable | Description |
|----------|-------------|
| `caller_agent` | Qui invoque le skill (toi = l'agent qui délègue) |
| `target_agent` | Nom de l'agent cible (master ou sub valide) |
| `prompt` | Instruction claire auto-contenue — l'agent cible ne verra que ça |
| `priority` | `normal` \| `high` \| `critical` |

## Inputs optionnels

| Variable | Défaut | Description |
|----------|--------|-------------|
| `notify_on` | Selon priority | `[failure]` (normal) \| `[completion,failure]` (high) \| `[completion,failure,critical_alert]` (critical) |
| `scheduled_for` | null | ISO 8601 UTC si différé (sinon prochain tick ≤60s) |
| `auto_mode` | true | Skip confirmations (défaut pour invocations agent-to-agent) |
</parameters>

<state_variables>

| Variable | Set by | Usage |
|----------|--------|-------|
| `{caller_agent}` | step-00 | Qui invoque |
| `{target_agent}` | step-02 | Validé regex + existence |
| `{prompt}` | step-02 | Non-vide + sanitized |
| `{priority}` | step-03 | Matrice appliquée |
| `{notify_on}` | step-03 | Liste computed |
| `{trigger_id}` | step-02 | `{caller}-{YYYYMMDD-HHMMSS}-{slug}` |
| `{cc_sparky_required}` | step-04 | Computed selon flux direct ou pas |
| `{yaml_path}` | step-05 | Path du fichier déposé |
| `{auto_mode}` | step-00 | Mode autonome |
| `{validation_result}` | step-01 | `proceed` \| `abort_with_guidance` |
</state_variables>

<entry_point>
**FIRST ACTION:** Load `steps/step-00-init.md`
</entry_point>

<step_files>

| Step | File | Purpose | Conditional |
|------|------|---------|-------------|
| 00 | `steps/step-00-init.md` | Parse inputs caller, init state JSON | — |
| 01 | `steps/step-01-validate-need.md` | Decision tree KAIROS ou redirige vers bon outil | Abort si pas KAIROS |
| 02 | `steps/step-02-collect-inputs.md` | Valide target_agent regex, prompt non-vide, génère trigger_id | — |
| 03 | `steps/step-03-choose-priority.md` | Applique matrice priority + notify_on défaut | — |
| 04 | `steps/step-04-check-rules.md` | CC Sparky si cross-domaine + anti-abus checks | — |
| 05 | `steps/step-05-write-yaml.md` | Génère YAML + écrit dans triggers/inbox/ VPS | — |
| 06 | `steps/step-06-cc-sparky.md` | SendMessage Sparky résumant l'action | Si cc_sparky_required |
| 07 | `steps/step-07-confirm.md` | Affiche confirmation au caller + cleanup state | — |
| 99 | `steps/step-99-rollback.md` | Rm fichier YAML si écrit puis échec downstream | On failure |

</step_files>

<execution_rules>
- **Load one step at a time** (progressive)
- **Persist state** dans `/tmp/kairos-delegate-state-{caller}-{timestamp}.json`
- **Abort gracieusement** à step-01 si KAIROS pas approprié
- **Rollback step-99** si step-05 a réussi puis step-06 échoue
- **Idempotence** : si `trigger_id` déjà existe dans inbox, skip (probable re-invocation)
</execution_rules>

<targets>
- **Inbox VPS** : `~/octopulse/kairos/triggers/inbox/`
- **KAIROS daemon** : tick toutes les 60s, consomme le fichier
- **Log caller** : `~/logs/kairos/delegate.jsonl` (optionnel mais recommandé)
- **Sparky CC** : via SendMessage si cross-domaine
</targets>

<references>
- 7 flux directs autorisés (pas de CC Sparky) : voir `shared/communication-protocol.md`
- Anti-abus : max 10 triggers/jour/agent (Sentinel Pattern 4.9), pas de self-trigger (4.1), pas de secrets en clair
- Format YAML canonique : id/agent/prompt/priority/submitter/created_at/notify_on/cc_sparky/scheduled_for
</references>
