---
name: step-02-registry-and-dirs
description: Créer les dossiers docs/schemas/recipes sur VPS, ajouter entrée dans registry.yml
prev_step: steps/step-01-collect-inputs.md
next_step: steps/step-03-fetch-doc.md
---

# Step 2: Registry + dossiers

## MANDATORY EXECUTION RULES (READ FIRST):

- NEVER modifier registry.yml sans backup préalable
- ALWAYS créer les 3 dossiers (docs, schemas, recipes) en une seule commande
- ALWAYS vérifier que l'entrée registry.yml est valide YAML après édition
- YOU ARE A PROVISIONER — créer la structure, pas fetcher de doc
- FORBIDDEN de charger step-03 si registry_updated = false

## YOUR TASK:

Créer les répertoires de l'API sur VPS et ajouter l'entrée correspondante dans registry.yml.

---

## EXECUTION SEQUENCE:

### 1. Load state

```bash
STATE_FILE="/tmp/octopulse-add-api-state-${name}.json"
NAME=$(python3 -c "import json; print(json.load(open('$STATE_FILE'))['name'])")
DISPLAY_NAME=$(python3 -c "import json; print(json.load(open('$STATE_FILE'))['display_name'])")
DOCS_URL=$(python3 -c "import json; print(json.load(open('$STATE_FILE'))['docs_url'])")
BW_ITEM=$(python3 -c "import json; print(json.load(open('$STATE_FILE'))['bw_item'])")
AUTH_HEADER=$(python3 -c "import json; print(json.load(open('$STATE_FILE'))['auth_header'])")
BASE_API_URL=$(python3 -c "import json; print(json.load(open('$STATE_FILE'))['base_api_url'])")
OPENAPI_SPEC=$(python3 -c "import json; v=json.load(open('$STATE_FILE'))['openapi_spec']; print(v if v else 'null')")
RATE_LIMIT=$(python3 -c "import json; print(json.load(open('$STATE_FILE'))['rate_limits_per_hour'])")
FETCH_SCHEDULE=$(python3 -c "import json; print(json.load(open('$STATE_FILE'))['fetch_schedule'])")
```

### 2. Backup registry.yml

```bash
ssh octopulse@204.168.209.232 "
cp ~/octopulse/integrations/registry.yml ~/octopulse/integrations/registry.yml.bak.$(date +%Y%m%d%H%M%S)
echo 'Backup OK'
"
```

### 3. Créer les dossiers sur VPS

```bash
ssh octopulse@204.168.209.232 "
set -e
mkdir -p ~/octopulse/integrations/docs/${NAME}
mkdir -p ~/octopulse/integrations/schemas/${NAME}
mkdir -p ~/octopulse/integrations/recipes/${NAME}
touch ~/octopulse/integrations/docs/${NAME}/.gitkeep
echo 'Dirs created OK'
"
```

Enregistrer dans state :
```python
state["created_files"].extend([
    f"~/octopulse/integrations/docs/{name}/",
    f"~/octopulse/integrations/schemas/{name}/",
    f"~/octopulse/integrations/recipes/{name}/"
])
state["dirs_created"] = True
```

### 4. Ajouter entrée dans registry.yml

Construire le bloc YAML à appendre sous `apis:` :

```yaml
  {name}:
    display_name: "{display_name}"
    docs_base_url: "{docs_url}"
    openapi_spec: {openapi_spec_or_null}
    bw_item: {bw_item}
    auth_header: '{auth_header}'
    base_api_url: {base_api_url}
    rate_limits:
      per_hour: {rate_limits_per_hour}
    fetch_schedule: {fetch_schedule}
```

```bash
ssh octopulse@204.168.209.232 "
cat >> ~/octopulse/integrations/registry.yml <<'YAML_BLOCK'
  ${NAME}:
    display_name: \"${DISPLAY_NAME}\"
    docs_base_url: ${DOCS_URL}
    openapi_spec: ${OPENAPI_SPEC}
    bw_item: ${BW_ITEM}
    auth_header: '${AUTH_HEADER}'
    base_api_url: ${BASE_API_URL}
    rate_limits:
      per_hour: ${RATE_LIMIT}
    fetch_schedule: ${FETCH_SCHEDULE}
YAML_BLOCK
echo 'registry.yml updated'
"
```

### 5. Valider YAML après édition

```bash
ssh octopulse@204.168.209.232 "
python3 -c \"import yaml; yaml.safe_load(open('/home/octopulse/octopulse/integrations/registry.yml'))\" && echo 'YAML valid' || echo 'YAML INVALID'
"
```

Si `YAML INVALID` → restaurer backup et abort avec message d'erreur.

### 6. Update state

```python
state["registry_updated"] = True
state["stepsCompleted"].append(2)
json.dump(state, open(STATE_FILE, "w"), indent=2)
print("Step 2 OK: dirs created, registry.yml updated")
```

---

## SUCCESS METRICS:

- Dossiers `docs/{name}/`, `schemas/{name}/`, `recipes/{name}/` présents sur VPS
- Entrée `{name}:` présente dans registry.yml
- registry.yml passe la validation `yaml.safe_load`
- `registry_updated: true` dans state JSON

## FAILURE MODES:

- Édition registry.yml casse le YAML → backup restauré
- Dossiers non créés → step-03 fetch doc échoue (path inexistant)
- Pas de backup → corruption irréversible si appended content invalide

---

## NEXT STEP:

Load `./step-03-fetch-doc.md`
