---
name: step-00-init
description: Parse et valider inputs (name regex + unicité registry.yml), init state JSON, détection resume
next_step: steps/step-01-collect-inputs.md
---

# Step 0: Initialisation

## MANDATORY EXECUTION RULES (READ FIRST):

- NEVER procéder sans `name` valide (regex kebab-case strict)
- NEVER écraser une API déjà dans registry.yml (idempotence)
- ALWAYS initialiser `auto_mode: true` par défaut
- ALWAYS vérifier unicité dans registry.yml avant de continuer
- YOU ARE AN INITIALIZER — parse + validate, pas d'actions VPS ici
- FORBIDDEN de passer au step-01 sans state JSON écrit

## YOUR TASK:

Parser les inputs, valider le nom de l'API, vérifier qu'elle n'existe pas déjà, initialiser le state JSON.

---

## EXECUTION SEQUENCE:

### 1. Collecter les inputs disponibles

Inputs requis :
- `name` (obligatoire) — kebab-case unique
- `display_name` (obligatoire)
- `docs_url` (obligatoire)
- `bw_item` (obligatoire)
- `auth_header` (obligatoire)
- `base_api_url` (obligatoire)

Inputs optionnels (défauts) :
- `openapi_spec` → null
- `rate_limits_per_hour` → 100
- `fetch_schedule` → "nightly"
- `auto_mode` → true

Si un input obligatoire manque et `auto_mode: true` → abort avec message précis.
Si `auto_mode: false` → AskUserQuestion pour chaque champ manquant.

### 2. Valider le nom (regex)

```bash
python3 -c "
import re, sys
name = '${name}'
if not re.match(r'^[a-z][a-z0-9-]{1,31}$', name):
    print(f'FAIL: name invalide: {name}. Doit être kebab-case ^[a-z][a-z0-9-]{{1,31}}$', file=sys.stderr)
    sys.exit(1)
print('OK regex')
"
```

### 3. Vérifier unicité dans registry.yml

```bash
ssh octopulse@204.168.209.232 "
grep -q '^  ${name}:' ~/octopulse/integrations/registry.yml && echo ALREADY_EXISTS || echo NOT_FOUND
"
```

Si `ALREADY_EXISTS` :
```
API '${name}' déjà présente dans registry.yml.
Provisioning déjà fait. Pour re-indexer : /api:query-docs ${name} "test"
Workflow terminé (skip graceful).
```
Exit proprement sans erreur.

### 4. Detect resume

```bash
STATE_FILE="/tmp/octopulse-add-api-state-${name}.json"
if [ -f "$STATE_FILE" ] && [ $(find /tmp -name "octopulse-add-api-state-${name}.json" -mmin -30 | wc -l) -gt 0 ]; then
  LAST_STEP=$(python3 -c "import json; s=json.load(open('$STATE_FILE')); print(max(s.get('stepsCompleted',[0])))")
  echo "[resume] state trouvé, dernier step: $LAST_STEP"
  # Charger le step suivant non complété
fi
```

### 5. Écrire le state JSON

```bash
STATE_FILE="/tmp/octopulse-add-api-state-${name}.json"
cat > "$STATE_FILE" <<EOF
{
  "name": "${name}",
  "display_name": "${display_name}",
  "docs_url": "${docs_url}",
  "bw_item": "${bw_item}",
  "auth_header": "${auth_header}",
  "base_api_url": "${base_api_url}",
  "openapi_spec": ${openapi_spec_or_null},
  "rate_limits_per_hour": ${rate_limits_per_hour:-100},
  "fetch_schedule": "${fetch_schedule:-nightly}",
  "auto_mode": ${auto_mode:-true},
  "bw_accessible": null,
  "dirs_created": false,
  "registry_updated": false,
  "doc_file": null,
  "clawmem_collection": null,
  "smoke_test_ok": false,
  "stepsCompleted": [0],
  "created_files": [],
  "started_at": "$(date -u +%FT%TZ)"
}
EOF
echo "State JSON écrit : $STATE_FILE"
```

---

## SUCCESS METRICS:

- name valide regex `^[a-z][a-z0-9-]{1,31}$`
- name absent de registry.yml (ou skip graceful si présent)
- State JSON écrit avec tous les inputs
- `stepsCompleted: [0]` inscrit

## FAILURE MODES:

- name invalide → entrée registry.yml corrompue
- API déjà présente sans skip graceful → doublon dans registry.yml

---

## NEXT STEP:

Load `./step-01-collect-inputs.md`
