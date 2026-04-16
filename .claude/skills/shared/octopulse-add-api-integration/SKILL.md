---
name: "octopulse:add-api-integration"
description: "Ajouter une nouvelle API au système d'intégrations OctoPulse. Workflow 6 étapes : collecter inputs, ajouter à registry.yml, créer dirs, fetch doc initiale, bootstrap ClawMem collection, smoke test vsearch. Utiliser quand un nouveau service externe doit être accessible aux agents."
argument-hint: "<inputs YAML ou via prompt guided>"
---

<objective>
Provisionner une nouvelle API dans le système d'intégrations OctoPulse de façon structurée et idempotente : création des répertoires, entrée registry.yml, documentation initiale, indexation ClawMem, validation smoke test. Garantit que l'API sera disponible via /api:query-docs et re-indexée chaque nuit par KAIROS.
</objective>

<when_to_use>
**Use when:**
- Ajouter une nouvelle API externe accessible aux agents (Stripe, Notion, Slack, etc.)
- Connecter un service SaaS avec authentification via Bitwarden
- Bootstrapper la documentation et l'indexation d'une API pour la première fois

**Don't use for:**
- Mise à jour de documentation d'une API existante → le timer nightly docs-refresh (02:30) s'en charge
- Modifier les credentials Bitwarden → directement dans le vault Bitwarden
- Créer des schemas JSON d'endpoints → éditer manuellement `schemas/<name>/` après provisioning
</when_to_use>

<parameters>
## Inputs requis

| Variable | Type | Description | Exemple |
|----------|------|-------------|---------|
| `name` | string | Kebab-case identifiant, unique dans registry.yml | `stripe` |
| `display_name` | string | Nom affiché pour les agents | `Stripe Payments` |
| `docs_url` | string | URL de la documentation officielle | `https://stripe.com/docs/api` |
| `bw_item` | string | Nom de l'item Bitwarden contenant la clé API | `stripe-api-key` |
| `auth_header` | string | Format du header d'authentification | `Authorization: Bearer {{TOKEN}}` |
| `base_api_url` | string | URL racine de l'API | `https://api.stripe.com/v1` |

## Inputs optionnels

| Variable | Type | Défaut | Description |
|----------|------|--------|-------------|
| `openapi_spec` | string | null | URL du spec OpenAPI si disponible |
| `rate_limits_per_hour` | int | 100 | Limite par heure |
| `fetch_schedule` | string | `nightly` | `nightly` ou `skip_use_mcp` |
| `auto_mode` | boolean | true | Skip confirmations interactives |
</parameters>

<state_variables>
Variables persistées dans `/tmp/octopulse-add-api-state-{name}.json` :

| Variable | Set by | Usage |
|----------|--------|-------|
| `{name}` | step-00 | Identifiant kebab-case de l'API |
| `{display_name}` | step-00 | Nom affiché |
| `{docs_url}` | step-00 | URL documentation |
| `{bw_item}` | step-00 | Item Bitwarden |
| `{auth_header}` | step-00 | Header auth format |
| `{base_api_url}` | step-00 | URL racine API |
| `{openapi_spec}` | step-00 | URL spec OpenAPI ou null |
| `{rate_limits_per_hour}` | step-00 | Limite API/heure |
| `{fetch_schedule}` | step-00 | Stratégie de fetch nightly |
| `{auto_mode}` | step-00 | Mode autonome |
| `{bw_accessible}` | step-01 | Bitwarden item trouvé |
| `{dirs_created}` | step-02 | Dossiers créés sur VPS |
| `{registry_updated}` | step-02 | Entrée ajoutée dans registry.yml |
| `{doc_file}` | step-03 | Path doc initiale écrite |
| `{clawmem_collection}` | step-04 | Nom collection ClawMem |
| `{smoke_test_ok}` | step-05 | vsearch retourne ≥1 passage |
| `{stepsCompleted}` | accumulé | Liste étapes terminées |
| `{created_files}` | accumulé | Pour rollback |
</state_variables>

<entry_point>
**FIRST ACTION:** Load `steps/step-00-init.md`
</entry_point>

<step_files>

| Step | File | Purpose | Conditional |
|------|------|---------|-------------|
| 00 | `steps/step-00-init.md` | Parse inputs, valider name regex + unicité dans registry.yml, init state JSON | — |
| 01 | `steps/step-01-collect-inputs.md` | Compléter inputs manquants, vérifier item Bitwarden accessible | — |
| 02 | `steps/step-02-registry-and-dirs.md` | Créer dirs docs/schemas/recipes sur VPS, ajouter entrée registry.yml | — |
| 03 | `steps/step-03-fetch-doc.md` | Fetch documentation initiale (WebFetch ou fetch-doc.sh auto-detect) | — |
| 04 | `steps/step-04-clawmem-bootstrap.md` | `clawmem collection add` + `clawmem update --embed` | — |
| 05 | `steps/step-05-smoke-test.md` | vsearch query de test → valider ≥1 passage, sync Mac miroir, résumé | — |
| 99 | `steps/step-99-rollback.md` | Supprimer dirs créés, retirer entrée registry.yml, drop collection ClawMem | On failure |

</step_files>

<execution_rules>
- **Load one step at a time** (progressif — pas tout charger d'un coup)
- **Persist state** dans `/tmp/octopulse-add-api-state-{name}.json` après chaque step
- **Follow next_step directive** à la fin de chaque step file
- **Idempotent** : si `name` déjà dans registry.yml au step-00 → skip gracefully (API déjà provisionnée)
- **Rollback on failure** : load `step-99-rollback.md`, utiliser state JSON pour undo
- **VPS via SSH** : `octopulse@204.168.209.232`
</execution_rules>

<targets>
- **VPS** : `octopulse@204.168.209.232`
- **Mac miroir** : `/Users/admin/octopulse/integrations/`
- **Registry** : `~/octopulse/integrations/registry.yml`
- **Dirs** : `~/octopulse/integrations/{docs,schemas,recipes}/{name}/`
- **ClawMem** : collection `docs-{name}`
</targets>
