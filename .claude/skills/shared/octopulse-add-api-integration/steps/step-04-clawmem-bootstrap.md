---
name: step-04-clawmem-bootstrap
description: Créer la collection ClawMem docs-<name>, lancer clawmem update --embed pour indexer la documentation
prev_step: steps/step-03-fetch-doc.md
next_step: steps/step-05-smoke-test.md
---

# Step 4: Bootstrap collection ClawMem

## MANDATORY EXECUTION RULES (READ FIRST):

- NEVER lancer clawmem sans vérifier que docs/{name}/reference.md existe
- ALWAYS utiliser le PATH correct ($HOME/.bun/bin:$PATH) pour clawmem
- ALWAYS vérifier que la collection a bien été créée après add
- YOU ARE AN INDEXER — créer la collection et embedder, pas fetcher de doc
- FORBIDDEN de charger step-05 si clawmem_collection = null

## YOUR TASK:

Créer la collection ClawMem `docs-{name}` pointant sur le dossier de documentation, puis lancer l'embedding.

---

## EXECUTION SEQUENCE:

### 1. Load state

```bash
STATE_FILE="/tmp/octopulse-add-api-state-${name}.json"
NAME=$(python3 -c "import json; print(json.load(open('$STATE_FILE'))['name'])")
DOC_FILE=$(python3 -c "import json; print(json.load(open('$STATE_FILE'))['doc_file'])")
```

### 2. Vérifier que le fichier doc existe

```bash
ssh octopulse@204.168.209.232 "
test -f ~/octopulse/integrations/docs/${NAME}/reference.md && echo 'DOC_FOUND' || echo 'DOC_MISSING'
"
```

Si `DOC_MISSING` → abort avec message "Relancer depuis step-03".

### 3. Vérifier si collection déjà existante (idempotence)

```bash
ssh octopulse@204.168.209.232 "
export PATH=\$HOME/.bun/bin:\$PATH
clawmem collection list 2>/dev/null | grep -q 'docs-${NAME}' && echo 'ALREADY_EXISTS' || echo 'NOT_EXISTS'
"
```

Si `ALREADY_EXISTS` : logger un warning mais continuer (re-embed est idempotent).

### 4. Créer la collection ClawMem

```bash
ssh octopulse@204.168.209.232 "
export PATH=\$HOME/.bun/bin:\$PATH
clawmem collection add \
  --path ~/octopulse/integrations/docs/${NAME} \
  --name docs-${NAME} \
  2>&1
"
```

Vérifier que la sortie ne contient pas d'erreur.

### 5. Lancer l'embedding

```bash
ssh octopulse@204.168.209.232 "
export PATH=\$HOME/.bun/bin:\$PATH
echo 'Starting embed for docs-${NAME}...'
clawmem update --embed 2>&1 | tail -5
echo 'Embed complete'
"
```

Note : `clawmem update --embed` indexe toutes les collections. Pour les systèmes avec beaucoup de collections, il peut prendre 1-2 minutes.

### 6. Vérifier que la collection est bien listée

```bash
ssh octopulse@204.168.209.232 "
export PATH=\$HOME/.bun/bin:\$PATH
clawmem collection list 2>/dev/null | grep 'docs-${NAME}'
"
```

Si absent → abort avec message d'erreur clawmem.

### 7. Update state

```python
state["clawmem_collection"] = f"docs-{name}"
state["stepsCompleted"].append(4)
json.dump(state, open(STATE_FILE, "w"), indent=2)
print(f"Step 4 OK: collection docs-{name} créée et indexée")
```

---

## SUCCESS METRICS:

- Collection `docs-{name}` visible dans `clawmem collection list`
- `clawmem update --embed` terminé sans erreur
- `clawmem_collection` renseigné dans state JSON
- `stepsCompleted` contient 4

## FAILURE MODES:

- clawmem non trouvé dans PATH → utiliser `export PATH=$HOME/.bun/bin:$PATH`
- Collection add échoue si path inexistant → vérifier step-02 a bien créé les dirs
- Embed échoue sur fichier vide → vérifier step-03 a bien écrit reference.md

---

## NEXT STEP:

Load `./step-05-smoke-test.md`
