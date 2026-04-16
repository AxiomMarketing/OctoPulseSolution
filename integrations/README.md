# OctoPulse — API Integrations

Central hub for managing, caching, and querying external API documentation. All agents access APIs via this layer — never raw credentials or direct HTTP calls.

---

## 1. Vue d'ensemble

Architecture en 3 temps :

```
Nightly Fetch  →  ClawMem Index  →  Agent vsearch + validate + call
```

**Nightly Fetch** (`~/octopulse/integrations/scripts/fetch-all-docs.sh`)
- Tourne chaque nuit via systemd user timer `docs-refresh.timer`
- Télécharge / met à jour la doc de chaque API dans `docs/<api>/`
- Génère `docs/CHANGELOG.md` si des changements sont détectés
- Prend un snapshot dans `docs/_snapshots/` pour comparaison

**ClawMem Index**
- Chaque dossier `docs/<api>/` est indexé dans une collection `docs-<api>`
- L'index vectoriel permet une recherche sémantique sur la doc
- Mis à jour automatiquement après chaque fetch nightly

**Agent vsearch + validate + call**
- L'agent cherche via `clawmem vsearch -c docs-<api> "<query>"`
- Construit la requête JSON et la valide contre le schéma JSON (`schemas/<api>/`)
- Exécute l'appel via `_lib/safe-caller.sh` avec gestion du rate-limit
- Les credentials sont lus depuis Bitwarden via `bw-get`

---

## 2. Structure dossiers

```
~/octopulse/integrations/
├── registry.yml              # Source of truth : APIs, BW items, rate limits
├── rate-limit-state.json     # État des appels en cours (agent+api)
├── integrations-ctl          # CLI de monitoring (voir §7)
│
├── docs/
│   ├── CHANGELOG.md          # Changements détectés par le nightly
│   ├── _snapshots/           # Snapshots pour diff nightly
│   ├── meta-ads/             # Doc Meta Marketing API
│   ├── shopify/              # Doc Shopify Admin API
│   ├── printful/             # Doc Printful API
│   ├── klaviyo/              # Doc Klaviyo API
│   └── posthog/              # Doc PostHog API
│
├── schemas/
│   ├── meta-ads/             # JSON Schemas des requêtes Meta
│   ├── shopify/              # JSON Schemas Shopify
│   ├── printful/             # JSON Schemas Printful
│   ├── klaviyo/              # JSON Schemas Klaviyo
│   └── posthog/              # JSON Schemas PostHog
│
├── recipes/
│   ├── meta-ads/             # Scripts bash prêts à l'emploi Meta
│   ├── shopify/              # Scripts bash Shopify
│   ├── printful/             # Scripts bash Printful
│   ├── klaviyo/              # Scripts bash Klaviyo
│   └── posthog/              # Scripts bash PostHog
│
├── scripts/
│   ├── fetch-all-docs.sh     # Orchestrateur nightly
│   ├── fetch-meta-docs.sh    # Fetcher spécifique Meta
│   ├── fetch-printful-docs.sh
│   ├── fetch-klaviyo-docs.sh
│   ├── fetch-posthog-docs.sh
│   └── detect-breaking-changes.sh
│
├── _lib/
│   ├── bw-get.sh             # Lecture credentials Bitwarden
│   ├── rate-limiter.sh       # Gestion rate-limit par agent+api
│   ├── safe-caller.sh        # Exécuteur HTTP sécurisé
│   └── validate-request.sh   # Validation JSON Schema
│
├── tests/
│   └── e2e-atlas-meta.sh     # Test E2E complet
│
└── logs/
    └── (symlink → ~/logs/integrations/)
```

---

## 3. APIs intégrées

| API | Display Name | BW Item | Rate Limit | Fetch |
|-----|-------------|---------|-----------|-------|
| `meta-ads` | Meta Marketing API | `meta-long-token` | 150/h, 2000/j | nightly |
| `shopify` | Shopify Admin API | `shopify-access-token` | 30/min | skip (MCP) |
| `printful` | Printful API | `Printful` | 100/h | nightly |
| `klaviyo` | Klaviyo API | `klaviyo-api-key` | 75/min | nightly |
| `posthog` | PostHog API | `posthog-api-key` | 500/h | nightly |

Shopify utilise le MCP officiel `shopify-ai-toolkit` — pas de fetch nightly nécessaire.

---

## 4. Usage agent (workflow /api:safe-call)

Workflow type pour un agent faisant appel à une API :

```bash
# 1. Chercher la doc pertinente
clawmem vsearch -c docs-meta-ads "campaigns list fields" -n 3

# 2. Construire la requête JSON
# (l'agent construit le payload basé sur les résultats vsearch)

# 3. Valider contre le schéma
~/octopulse/integrations/_lib/validate-request.sh meta-ads campaigns payload.json

# 4. Exécuter l'appel via safe-caller
~/octopulse/integrations/_lib/safe-caller.sh \
  --api meta-ads \
  --method GET \
  --endpoint "/act_{{ACCOUNT_ID}}/campaigns" \
  --params "fields=id,name,status&limit=10"
```

Le skill `/api:safe-call` encapsule ces 4 étapes. Utiliser ce skill plutôt que des appels directs.

---

## 5. Ajout d'une nouvelle API

Utiliser le skill `/octopulse:add-api-integration` qui automatise :

1. Ajout de l'entrée dans `registry.yml`
2. Création des dossiers `docs/<api>/`, `schemas/<api>/`, `recipes/<api>/`
3. Écriture du fetcher `scripts/fetch-<api>-docs.sh`
4. Indexation initiale dans ClawMem (`clawmem add -c docs-<api>`)
5. Ajout de recettes de base dans `recipes/<api>/`

**Manuelle (sans skill) :**

```bash
# 1. Ajouter dans registry.yml
vim ~/octopulse/integrations/registry.yml

# 2. Créer la structure
mkdir -p ~/octopulse/integrations/{docs,schemas,recipes}/<new-api>

# 3. Écrire la doc initiale
cat > ~/octopulse/integrations/docs/<new-api>/overview.md << 'EOF'
# <API> Overview
...
EOF

# 4. Indexer dans ClawMem
clawmem add -c docs-<new-api> ~/octopulse/integrations/docs/<new-api>/

# 5. Tester
integrations-ctl test <new-api>
```

---

## 6. Maintenance

### Nightly timer

```bash
# Statut du timer
systemctl --user status docs-refresh.timer

# Logs du dernier run
journalctl --user -u docs-refresh.service -n 50

# Forcer un refresh maintenant
systemctl --user start docs-refresh.service

# Voir le log détaillé
tail -100 ~/logs/integrations/nightly-refresh.log
```

### Snapshots

Les snapshots sont stockés dans `docs/_snapshots/` avec timestamp. Le script `detect-breaking-changes.sh` compare le snapshot précédent avec la version actuelle et écrit dans `docs/CHANGELOG.md`.

### CHANGELOG

`docs/CHANGELOG.md` est généré automatiquement par le nightly. Consulter via :
```bash
integrations-ctl diff
```

---

## 7. CLI `integrations-ctl`

Binaire : `~/octopulse/integrations/integrations-ctl`
Alias : `integrations-ctl` (défini dans `~/.bashrc`)

### Commandes

#### `status` — Vue d'ensemble de toutes les APIs

```bash
integrations-ctl status
```

Affiche pour chaque API :
- Nombre de fichiers doc, schémas, recettes
- Présence de la collection ClawMem
- Date du dernier fetch
- État du rate-limit
- Statut du timer nightly

Exemple de sortie :
```
APIs registered: 5

  ✓ meta-ads        docs=5 schemas=4 recipes=5 clawmem=✓ last_fetch=2026-04-15
  ✓ shopify         docs=6 schemas=0 recipes=0 clawmem=✓ last_fetch=never
  ✓ printful        docs=5 schemas=0 recipes=0 clawmem=✓ last_fetch=2026-04-15
  ✓ klaviyo         docs=4 schemas=0 recipes=0 clawmem=✓ last_fetch=2026-04-15
  ✓ posthog         docs=3 schemas=0 recipes=0 clawmem=✓ last_fetch=2026-04-15

Rate-limit: 1 active agent+api pairs tracked
Nightly timer: active
```

#### `list` — Tableau des APIs enregistrées

```bash
integrations-ctl list
```

#### `logs <api> [-n N]` — Derniers appels d'une API

```bash
integrations-ctl logs meta-ads
integrations-ctl logs meta-ads -n 50
```

Lit `~/logs/integrations/<api>.jsonl` et affiche les N dernières lignes.

#### `test <api>` — Diagnostic complet d'une API

```bash
integrations-ctl test meta-ads
integrations-ctl test shopify
```

Vérifie :
1. Présence des fichiers doc
2. vsearch ClawMem fonctionnel (retourne des résultats)
3. Nombre de schémas JSON
4. Nombre de recettes bash
5. BW item configuré

#### `diff` — Changements détectés par le dernier nightly

```bash
integrations-ctl diff
```

Affiche les 2000 derniers caractères de `docs/CHANGELOG.md`.

---

## 8. Troubleshooting

### Docs vides (doc_count = 0)

```bash
# Vérifier le dossier
ls ~/octopulse/integrations/docs/<api>/

# Forcer un fetch
~/octopulse/integrations/scripts/fetch-<api>-docs.sh

# Ou fetch global
~/octopulse/integrations/scripts/fetch-all-docs.sh
```

### vsearch no results

```bash
# Vérifier que la collection existe
clawmem doctor

# Ré-indexer
clawmem add -c docs-<api> ~/octopulse/integrations/docs/<api>/

# Tester vsearch directement
clawmem vsearch -c docs-<api> "test query" -n 3
```

### bw-get fail

```bash
# Vérifier que le vault Bitwarden est déverrouillé
bw status

# Déverrouiller si nécessaire
export BW_SESSION=$(bw unlock --raw)

# Tester la lecture du secret
~/octopulse/integrations/_lib/bw-get.sh <bw_item_name>
```

### Rate-limit exceeded

```bash
# Voir l'état actuel
cat ~/octopulse/integrations/rate-limit-state.json

# Réinitialiser un agent+api pair (si bloqué par erreur)
# Éditer rate-limit-state.json et vider le tableau de l'entrée concernée
vim ~/octopulse/integrations/rate-limit-state.json

# Vérifier les logs de l'API
integrations-ctl logs <api> -n 30
```

### Schema validation fail

```bash
# Lister les schémas disponibles
ls ~/octopulse/integrations/schemas/<api>/

# Valider manuellement un payload
~/octopulse/integrations/_lib/validate-request.sh <api> <endpoint> payload.json

# Voir le schéma
cat ~/octopulse/integrations/schemas/<api>/<endpoint>-request.schema.json | python3 -m json.tool
```
