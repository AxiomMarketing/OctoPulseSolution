---
name: step-03-fetch-doc
description: Fetch documentation initiale via stratégie auto-detect (OpenAPI spec ou WebFetch markdown), sauvegarder dans docs/<name>/reference.md
prev_step: steps/step-02-registry-and-dirs.md
next_step: steps/step-04-clawmem-bootstrap.md
---

# Step 3: Fetch documentation initiale

## MANDATORY EXECUTION RULES (READ FIRST):

- ALWAYS choisir la stratégie selon openapi_spec disponible ou non
- ALWAYS sauvegarder le résultat dans `docs/{name}/reference.md` sur VPS
- NEVER laisser docs/{name}/ vide (ClawMem ne peut pas indexer)
- YOU ARE A DOC FETCHER — obtenir la doc, pas valider ni indexer
- FORBIDDEN de charger step-04 si aucun fichier .md dans docs/{name}/

## YOUR TASK:

Fetch la documentation de l'API en utilisant la meilleure stratégie disponible, puis sauvegarder sur le VPS.

---

## EXECUTION SEQUENCE:

### 1. Load state et choisir stratégie

```bash
STATE_FILE="/tmp/octopulse-add-api-state-${name}.json"
NAME=$(python3 -c "import json; print(json.load(open('$STATE_FILE'))['name'])")
DOCS_URL=$(python3 -c "import json; print(json.load(open('$STATE_FILE'))['docs_url'])")
OPENAPI_SPEC=$(python3 -c "import json; v=json.load(open('$STATE_FILE'))['openapi_spec']; print(v if v else '')")
FETCH_SCHEDULE=$(python3 -c "import json; print(json.load(open('$STATE_FILE'))['fetch_schedule'])")
```

**Arbre de décision stratégie :**

```
Si fetch_schedule == "skip_use_mcp"
  → Stratégie C (stub minimal)
Sinon si openapi_spec non-null et non-vide
  → Stratégie A (OpenAPI spec)
Sinon
  → Stratégie B (WebFetch markdown)
```

### 2. Stratégie A — OpenAPI spec disponible

```bash
ssh octopulse@204.168.209.232 "
curl -fsSL '${OPENAPI_SPEC}' -o /tmp/${NAME}-openapi.json 2>&1 && echo 'SPEC_OK' || echo 'SPEC_FAIL'
"
```

Si `SPEC_OK` : convertir en markdown lisible par les agents :
```bash
ssh octopulse@204.168.209.232 "
python3 <<'PYEOF'
import json, pathlib
spec = json.load(open('/tmp/${NAME}-openapi.json'))
md = []
md.append(f'# {spec.get(\"info\", {}).get(\"title\", \"${NAME}\")} API Reference')
md.append(f'\\nBase URL: {spec.get(\"servers\", [{}])[0].get(\"url\", \"\")}')
md.append(f'\\nVersion: {spec.get(\"info\", {}).get(\"version\", \"unknown\")}')
md.append('\\n## Endpoints\\n')
for path, methods in spec.get('paths', {}).items():
    for method, info in methods.items():
        md.append(f'### {method.upper()} {path}')
        md.append(info.get('summary', '') + '\\n')
        if 'parameters' in info:
            md.append('**Parameters:**')
            for p in info['parameters']:
                md.append(f'- {p[\"name\"]} ({p.get(\"in\",\"\")}) {\"required\" if p.get(\"required\") else \"optional\"}: {p.get(\"description\",\"\")}')
            md.append('')
pathlib.Path('~/octopulse/integrations/docs/${NAME}/reference.md').expanduser().write_text('\\n'.join(md))
print('OPENAPI_MD_WRITTEN')
PYEOF
"
```

### 2b. Stratégie B — WebFetch markdown (fallback)

Utiliser l'outil WebFetch avec le prompt suivant :

```
WebFetch url="${docs_url}"
prompt="Extrais tous les endpoints disponibles, leurs paramètres requis et optionnels, les exemples de requêtes curl, et les formats de réponse JSON. Inclus les codes d'erreur courants. Formate en markdown structuré avec sections H2 par endpoint ou par ressource."
```

Sauvegarder la réponse dans un fichier temporaire local, puis SCP sur VPS :

```bash
# Après WebFetch, écrire le contenu dans /tmp/${name}-doc-raw.md localement
# Puis copier sur VPS :
scp /tmp/${name}-doc-raw.md octopulse@204.168.209.232:~/octopulse/integrations/docs/${NAME}/reference.md
echo "DOC_WRITTEN"
```

### 2c. Stratégie C — stub MCP (skip fetch)

Créer un stub minimal indiquant que l'API utilise un MCP officiel :

```bash
ssh octopulse@204.168.209.232 "
cat > ~/octopulse/integrations/docs/${NAME}/reference.md <<'MD'
# ${DISPLAY_NAME} — MCP Integration

Cette API est intégrée via MCP officiel. Pas de fetch custom.

## Utilisation

Utiliser le MCP tool directement depuis les agents au lieu de /api:query-docs.

## Référence

- Docs : ${DOCS_URL}
MD
echo 'STUB_WRITTEN'
"
```

### 3. Vérifier que le fichier existe et est non-vide

```bash
ssh octopulse@204.168.209.232 "
SIZE=$(wc -c < ~/octopulse/integrations/docs/${NAME}/reference.md 2>/dev/null || echo 0)
if [ "$SIZE" -lt 100 ]; then
  echo 'DOC_TOO_SMALL'
  exit 1
fi
echo \"DOC_OK: ${SIZE} bytes\"
"
```

Si `DOC_TOO_SMALL` → abort avec message pour retenter avec une autre stratégie.

### 4. Update state

```python
state["doc_file"] = f"~/octopulse/integrations/docs/{name}/reference.md"
state["created_files"].append(f"~/octopulse/integrations/docs/{name}/reference.md")
state["stepsCompleted"].append(3)
json.dump(state, open(STATE_FILE, "w"), indent=2)
print("Step 3 OK: doc fetched and saved")
```

---

## SUCCESS METRICS:

- `docs/{name}/reference.md` présent sur VPS, taille ≥ 100 bytes
- Stratégie choisie (A/B/C) cohérente avec openapi_spec et fetch_schedule
- `doc_file` renseigné dans state JSON
- `stepsCompleted` contient 3

## FAILURE MODES:

- OpenAPI spec inaccessible → fallback sur stratégie B automatiquement
- WebFetch retourne contenu vide → abort, contenu trop petit pour indexer
- File non créé sur VPS → ClawMem step-04 échoue

---

## NEXT STEP:

Load `./step-04-clawmem-bootstrap.md`
