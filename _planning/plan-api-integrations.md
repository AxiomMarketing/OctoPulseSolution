# Plan d'implémentation — Système d'intégration API avec RAG ClawMem

> **Objectif** : permettre aux agents OctoPulse de faire des requêtes API correctes du premier coup, sans charger la doc entière, avec validation pré-flight et protection anti-blocage (pattern qui a causé l'incident Meta).

## Architecture cible

```
┌────────────────────────────────────────────────────────────────┐
│  NIGHTLY (KAIROS 02:30) — Docs fraîches                        │
│  ├── fetch-all-docs.sh                                          │
│  │   └── Pour chaque API registry.yml : télécharger doc         │
│  ├── diff avec snapshot précédent → détecter breaking changes   │
│  │   └── Si breaking → Telegram Marty (critical)                │
│  └── clawmem update --embed (re-index toutes collections)       │
└────────────────┬───────────────────────────────────────────────┘
                 │
                 ▼
┌────────────────────────────────────────────────────────────────┐
│  RUNTIME (agent qui veut appeler une API)                      │
│                                                                 │
│  1. /api:query-docs meta-ads "get campaign insights 24h"        │
│     → clawmem vsearch -c docs-meta-ads → 3 passages (~1K tokens)│
│                                                                 │
│  2. Agent construit sa requête avec ces passages                │
│                                                                 │
│  3. /api:validate-request meta-ads /insights <payload>          │
│     → JSON Schema check local → OK ou erreur précise            │
│                                                                 │
│  4. /api:safe-call meta-ads /insights <payload>                 │
│     → Rate-limit check → curl + retry backoff → log JSONL       │
│     → Si 4xx/5xx inattendu → flag potentiel breaking change     │
└────────────────────────────────────────────────────────────────┘
```

## 3 couches de protection contre l'incident Meta

1. **Doc RAG** : l'agent ne codify jamais sans avoir consulté la doc officielle indexée
2. **Validation locale** : JSON Schema vérifie la requête AVANT envoi, attrape les erreurs courantes
3. **Rate-limit per agent+API** : max N requêtes/min, coupe automatique si abus

## Structure filesystem cible

```
~/octopulse/integrations/
├── _lib/                              # Helpers réutilisables
│   ├── bw-get.sh                       # Fetch clé Bitwarden (cache tmpfs)
│   ├── fetch-doc.sh                    # Scraping générique URL → markdown
│   ├── validate-request.sh             # JSON Schema validation
│   ├── log-api-call.sh                 # Logger structuré
│   ├── retry-backoff.sh                # Exponential backoff retry
│   └── rate-limit.sh                   # Check quota avant call
│
├── registry.yml                        # Déclaratif : config pour chaque API
│                                       # (URL doc, OpenAPI spec, item BW, auth type)
│
├── docs/                               # Docs fetched (mise à jour hebdo/nightly)
│   ├── meta-ads/
│   │   ├── campaigns.md
│   │   ├── insights.md
│   │   ├── adsets.md
│   │   ├── _meta.yml                   # fetch_date, api_version, SHA256
│   │   └── CHANGELOG.md                # diff vs snapshot précédent
│   ├── shopify/
│   ├── printful/
│   ├── klaviyo/
│   └── posthog/
│
├── schemas/                            # JSON Schema pour validation pré-flight
│   ├── meta-ads/
│   │   ├── insights-request.schema.json
│   │   └── campaigns-request.schema.json
│   └── ...
│
├── recipes/                            # Snippets validés (cookbook copiable)
│   ├── meta-ads/
│   │   ├── get-campaign-insights.sh
│   │   ├── get-ad-performance.sh
│   │   └── ...
│   └── ...
│
├── logs/                               # Audit trail des appels API
│   ├── meta-ads.jsonl
│   ├── shopify.jsonl
│   └── ...
│
└── scripts/                            # Scripts d'administration
    ├── fetch-all-docs.sh               # KAIROS nightly — master fetch
    ├── index-all-docs.sh               # Rebuild ClawMem collections
    ├── detect-breaking-changes.sh      # Diff + alerte Telegram
    ├── smoke-test.sh                   # Test post-refresh
    └── integrations-ctl                # CLI status/debug
```

## ClawMem collections

| Collection | Path indexé |
|------------|-------------|
| `docs-meta-ads` | `~/octopulse/integrations/docs/meta-ads/` |
| `docs-shopify` | `~/octopulse/integrations/docs/shopify/` |
| `docs-printful` | `~/octopulse/integrations/docs/printful/` |
| `docs-klaviyo` | `~/octopulse/integrations/docs/klaviyo/` |
| `docs-posthog` | `~/octopulse/integrations/docs/posthog/` |

Chaque collection indexée via `clawmem collection add` + `update --embed`. Latence mesurée ~400ms/query, donc quasi-transparent.

## Skills à créer

### `/api:query-docs`
**Usage** : `/api:query-docs meta-ads "get campaign insights 24h"`
**Sortie** : 3-5 passages pertinents avec scores de similarité + URL source
**Coût** : ~1000 tokens vs 50000 pour toute la doc

### `/api:validate-request`
**Usage** : `/api:validate-request meta-ads /v21/insights <payload_json>`
**Sortie** : `OK` ou liste d'erreurs précises (param manquant, type invalide, etc.)
**Technique** : jsonschema Python + schema local dans `schemas/meta-ads/`

### `/api:safe-call`
**Usage** : `/api:safe-call meta-ads GET /v21/act_XXX/insights --params "..."`
**Workflow interne** :
1. Rate-limit check (quota atteint ? → abort)
2. Charge clé Bitwarden via `bw-get.sh`
3. Validate request via schema (reuse `/api:validate-request`)
4. curl avec retry exponentiel (si 5xx)
5. Log appel dans JSONL (status, latency, size)
6. Si 4xx inattendu → flag pour monitoring breaking change
7. Return response JSON

### `/octopulse:add-api-integration`
**Usage** : workflow assisté pour ajouter une nouvelle API
**Inputs** : nom, URL doc officielle, URL OpenAPI spec (si dispo), item Bitwarden, auth type
**Actions** : crée dirs, ajoute à registry, bootstrap ClawMem, 1er fetch, dry-run test
**Implémentation** : via `create-skills-workflow` (multi-steps)

## KAIROS nightly job

```yaml
# ~/octopulse/kairos/config.yml
jobs:
  - id: integrations-docs-refresh
    agent: null        # exécution directe shell (pas via claude -p)
    cron: "30 2 * * *" # chaque nuit 02h30
    script: "~/octopulse/integrations/scripts/fetch-all-docs.sh"
    priority: high
    notify_on: [failure, critical_alert]
    timeout_sec: 3600  # 1h max
    enabled: true
```

**Workflow du job** :
```
1. Pour chaque API dans registry.yml :
   a. Télécharger doc officielle (curl/scraping)
   b. Sauvegarder snapshot horodaté dans docs/<api>/_snapshot-YYYY-MM-DD.tar.gz
   c. Comparer avec snapshot J-1 → générer CHANGELOG.md diff
   d. Si breaking change détecté (endpoint supprimé, param required ajouté) :
      → Telegram Marty priority=critical
   e. Écrire _meta.yml avec date, version API, SHA256

2. clawmem update --embed (rebuild embeddings)

3. Smoke test : pour chaque collection, vsearch avec query type
   (ex: docs-meta-ads "campaign insights") → doit retourner ≥ 1 passage

4. Si tout OK : log success + notify completion (optionnel)
   Si fail : rollback au snapshot précédent + alerte Marty
```

## Registry.yml — format déclaratif

```yaml
# ~/octopulse/integrations/registry.yml
version: 1
apis:
  meta-ads:
    display_name: "Meta Marketing API"
    docs_base_url: "https://developers.facebook.com/docs/marketing-api/"
    docs_toc_url: "https://developers.facebook.com/docs/marketing-api/reference/"
    openapi_spec: null  # Meta n'expose pas OpenAPI
    scraping_strategy: "custom_scraper_meta.py"
    bw_item: "meta-marketing-api-token"
    auth_header: "Authorization: Bearer {{TOKEN}}"
    base_api_url: "https://graph.facebook.com/v21.0"
    rate_limits:
      per_hour: 150
      per_day: 2000
    critical_endpoints:  # pour detection breaking change
      - "/act_{id}/campaigns"
      - "/act_{id}/insights"
    fetch_schedule: "nightly"
    
  shopify:
    display_name: "Shopify Admin API"
    docs_base_url: "https://shopify.dev/docs/api/admin"
    mcp_available: "Shopify/shopify-ai-toolkit"  # ← on privilégie le MCP officiel
    scraping_strategy: "skip_use_mcp"
    bw_item: "shopify-admin-token"
    base_api_url: "https://{{STORE}}.myshopify.com/admin/api/2026-04"
    rate_limits:
      per_minute: 40
    
  printful:
    display_name: "Printful API"
    docs_base_url: "https://developers.printful.com/docs/"
    openapi_spec: "https://api.printful.com/openapi.json"  # ← facile si existe
    scraping_strategy: "openapi"
    bw_item: "printful-api-token"
    ...
  
  klaviyo:
    ...
  
  posthog:
    ...
```

## Detection breaking change

Algorithme de diff dans `detect-breaking-changes.sh` :

1. Parse les markdown fetched pour extraire structure endpoints :
   - Liste endpoints (path + method)
   - Paramètres (nom, type, required/optional)
   - Response schema
2. Compare avec snapshot J-1 :
   - **BREAKING** : endpoint supprimé / utilisé par un recipe existant
   - **BREAKING** : paramètre devient required
   - **BREAKING** : changement de type (string → int)
   - **ADDITIVE** : nouveaux endpoints (pas bloquant)
   - **ADDITIVE** : nouveaux paramètres optionnels (pas bloquant)
3. Si BREAKING détecté :
   - Liste précise des changements dans `docs/<api>/CHANGELOG.md`
   - Telegram Marty : "⚠️ BREAKING CHANGE Meta Ads : endpoint /v20/insights supprimé. Recipes affectés : get-campaign-insights.sh. Action : réviser."
   - Trigger KAIROS reactif pour Sentinel : audit des recipes

## Rate-limit agents

Compteur par **(agent, api)** sur fenêtre glissante :
- Stockage : `~/octopulse/integrations/rate-limit-state.json` (persistant)
- Format : `{"atlas_meta-ads": {"hour": [timestamps...], "day": [timestamps...]}}`
- Check dans `safe-call.sh` avant tout appel
- Si dépassement :
  - Abort + retour erreur explicite
  - Log dans `~/logs/integrations/rate-limits.jsonl`
  - Si dépassement répété par le même agent → Sentinel flaggue Pattern 4.9

**Seuils par défaut** :
| API | Agent seuil | Limite réelle API |
|---|---|---|
| Meta Ads | 150/h | 200/h par app |
| Shopify | 30/min | 40/min |
| Printful | 100/h | 120/h |
| Klaviyo | 150/min | ? (à check) |
| PostHog | illimité pratiquement | généreux |

## Monitoring — CLI `integrations-ctl`

```bash
integrations-ctl status         # dernier fetch, erreurs, queries count
integrations-ctl list           # liste APIs enregistrées
integrations-ctl logs meta-ads  # tail logs pour une API
integrations-ctl test meta-ads  # smoke test : fetch doc + index + vsearch + call dry-run
integrations-ctl diff meta-ads  # affiche CHANGELOG diff J-1 vs today
```

## Task breakdown — 22 tâches en 9 phases

### Phase 1 — Scaffold (2 tasks, parallèle)
- **T1** Créer structure dirs + `_lib/bw-get.sh` + `_lib/log-api-call.sh`
- **T2** Créer `registry.yml` squelette + 5 entrées APIs (Meta/Shopify/Printful/Klaviyo/PostHog)

### Phase 2 — Fetchers (5 tasks, parallèle)
- **T3** Fetcher générique `fetch-doc.sh` + stratégies (openapi / scraping / markdown-crawl)
- **T4** Meta Ads : fetcher custom (doc structurée sur developers.facebook.com)
- **T5** Shopify : skip fetch (on utilise MCP officiel)
- **T6** Printful : OpenAPI-based fetch
- **T7** Klaviyo + PostHog : markdown-based fetch

### Phase 3 — Indexation ClawMem (2 tasks)
- **T8** `index-all-docs.sh` — bootstrap 5 collections `docs-<api>`
- **T9** Smoke test vsearch sur chaque collection

### Phase 4 — Validation (3 tasks, parallèle)
- **T10** `_lib/validate-request.sh` — engine JSON Schema
- **T11** Schemas Meta Ads (le plus risqué) : insights, campaigns, adsets
- **T12** Schemas des 4 autres APIs (priorité write endpoints)

### Phase 5 — Skills agents (4 tasks)
- **T13** Skill `/api:query-docs` (via `meta-skill-creator` — c'est simple, 1 fichier)
- **T14** Skill `/api:validate-request`
- **T15** Skill `/api:safe-call` (via `create-skills-workflow` — c'est un workflow multi-step : rate-limit → fetch clé → validate → call → log)
- **T16** Patch CLAUDE.md : règle "toujours via /api:safe-call pour les APIs externes"

### Phase 6 — Rate-limit + sécurité (2 tasks)
- **T17** `_lib/rate-limit.sh` + state persistant + integration dans safe-call
- **T18** Detection anomalies (pattern répété 4xx → alerte breaking change)

### Phase 7 — KAIROS nightly (3 tasks)
- **T19** `scripts/fetch-all-docs.sh` master
- **T20** `scripts/detect-breaking-changes.sh` + alerte Telegram
- **T21** Config KAIROS : nouveau job `integrations-docs-refresh` 02:30 quotidien

### Phase 8 — Provisioning nouvelle API (1 task)
- **T22** Skill `/octopulse:add-api-integration` (workflow multi-step via `create-skills-workflow`)

### Phase 9 — Monitoring + E2E test (3 tasks)
- **T23** CLI `integrations-ctl` (status/list/logs/test/diff)
- **T24** Shopify AI Toolkit installation (MCP officiel, parallèle custom pour Shopify)
- **T25** E2E test complet : Atlas query docs → construit requête → valide → call → log

## Dépendances / ordonnancement

```
T1 ──┬── T3 ──┬── T4, T5, T6, T7 (parallèle)
     │        │
T2 ──┘        └── T8 ── T9
                                       
                 T10 ──┬── T11, T12 (parallèle)
                       │
                       └── T13, T14, T15 (parallèle) ── T16

T17 (indép) ── T18

T19 ── T20 ── T21 (KAIROS cron)

T22 (indép — nécessite T13+T15 pour référence)

T23 (indép)
T24 (indép)

T25 ── dépend de tout le reste
```

**Critical path** : T1/T2 → T3 → T8 → T15 → T25 (~6 waves)

## Effort estimé

- Phase 1-2 : 2-3h (scaffold + fetchers)
- Phase 3-4 : 1-2h (indexation + validation)
- Phase 5-6 : 2h (skills + rate-limit)
- Phase 7 : 1h (KAIROS)
- Phase 8-9 : 1-2h (provisioning + monitoring)
- **Total : 7-10h** sur 5-7 implementers parallèles via APEX

## Considérations supplémentaires

### Sécurité
- Clés API jamais dans les docs indexées (scrub avant indexation)
- Clés dans Bitwarden uniquement, fetch à la demande
- Logs scrub des tokens avant écriture JSONL
- Hook LLM Guard sur le tool Bash pour détecter fuites accidentelles

### Observabilité
- Chaque appel API : JSONL entry avec agent, endpoint, latency, status, size
- Analyse hebdomadaire automatique via Sentinel : top 10 endpoints les plus appelés, erreurs répétées, recommandations recipes à créer
- Dashboard simple accessible via `integrations-ctl status`

### Évolution
- Pattern transportable à n'importe quelle nouvelle API (skill `/octopulse:add-api-integration`)
- Snapshots versionnés permettent rollback de doc si scraping casse
- Possibilité future : hooks pour déclencher re-indexation après chaque fetch manuel

### Risques & mitigations
- **Risque 1** : site doc change structure HTML → scraping cassé
  - Mitigation : tests post-fetch (au moins 1 endpoint connu doit apparaître), fallback sur snapshot J-1, alerte Marty
- **Risque 2** : ClawMem indexation lente si doc > 1 MB par API
  - Mitigation : chunking pre-indexation, timeout 10 min max
- **Risque 3** : API provider change auth method (ex: Meta passe de access_token à OAuth)
  - Mitigation : detection breaking change → alerte Telegram, rollback auto

## Success criteria

- [ ] Atlas peut faire `/api:query-docs meta-ads "get insights"` et recevoir 3 passages en ~400ms
- [ ] Atlas peut faire `/api:safe-call meta-ads GET /v21/act_XXX/campaigns` avec validation pré-flight et log complet
- [ ] Nightly refresh à 02:30 met à jour les 5 collections sans intervention
- [ ] Breaking change Meta → Telegram Marty dans les 24h
- [ ] Ajouter une 6e API prend < 30 min via `/octopulse:add-api-integration`
- [ ] Incident Meta plus jamais reproductible (validation locale + rate-limit + recipes validés)

---

## Prochaine étape

Valider ce plan avec Marty, puis lancer l'implémentation via :
```
/apex -a -x -m implémente le système d'intégration API avec RAG ClawMem (voir plan dans _planning/plan-api-integrations.md)
```
