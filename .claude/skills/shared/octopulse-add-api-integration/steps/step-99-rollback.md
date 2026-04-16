---
name: step-99-rollback
description: Annuler le provisioning en cours — supprimer dirs créés, retirer entrée registry.yml, drop collection ClawMem
prev_step: "any step on failure"
next_step: null
---

# Step 99: Rollback

## MANDATORY EXECUTION RULES (READ FIRST):

- ALWAYS lire le state JSON avant toute suppression (éviter de supprimer le mauvais)
- NEVER supprimer une API qui existait AVANT ce provisioning (rollback = undo seulement)
- ALWAYS restaurer le backup registry.yml si présent
- YOU ARE AN UNDOER — supprimer ce qui a été créé par ce provisioning uniquement
- FORBIDDEN de toucher les autres APIs dans registry.yml

## CONTEXT:

Ce step est chargé quand une erreur irrécupérable survient dans les steps 01-05.
Il utilise le state JSON pour savoir exactement ce qui a été fait et doit être défait.

---

## EXECUTION SEQUENCE:

### 1. Load state (si disponible)

```bash
STATE_FILE="/tmp/octopulse-add-api-state-${name}.json"
if [ ! -f "$STATE_FILE" ]; then
  echo "State JSON introuvable — rollback manuel requis"
  echo "Vérifier manuellement :"
  echo "  - ~/octopulse/integrations/registry.yml (retirer entrée ${name})"
  echo "  - ~/octopulse/integrations/docs/${name}/ (supprimer si créé)"
  exit 1
fi

NAME=$(python3 -c "import json; print(json.load(open('$STATE_FILE'))['name'])")
DIRS_CREATED=$(python3 -c "import json; print(json.load(open('$STATE_FILE'))['dirs_created'])")
REGISTRY_UPDATED=$(python3 -c "import json; print(json.load(open('$STATE_FILE'))['registry_updated'])")
CLAWMEM_COLLECTION=$(python3 -c "import json; v=json.load(open('$STATE_FILE'))['clawmem_collection']; print(v if v else '')")
```

### 2. Drop collection ClawMem (si créée)

```bash
if [ -n "$CLAWMEM_COLLECTION" ]; then
  ssh octopulse@204.168.209.232 "
  export PATH=\$HOME/.bun/bin:\$PATH
  clawmem collection remove --name docs-${NAME} 2>/dev/null && echo 'ClawMem collection dropped' || echo 'ClawMem collection not found (OK)'
  "
fi
```

### 3. Restaurer registry.yml depuis backup

```bash
ssh octopulse@204.168.209.232 "
BACKUP=\$(ls -t ~/octopulse/integrations/registry.yml.bak.* 2>/dev/null | head -1)
if [ -n \"\$BACKUP\" ]; then
  cp \"\$BACKUP\" ~/octopulse/integrations/registry.yml
  echo \"Registry restauré depuis \$BACKUP\"
else
  echo 'Pas de backup trouvé — retrait manuel de l entrée ${NAME}'
  # Tentative de retrait par sed si backup absent
  python3 -c \"
import re, pathlib
path = pathlib.Path('/home/octopulse/octopulse/integrations/registry.yml')
content = path.read_text()
# Supprimer le bloc YAML de l'API
pattern = r'  ${NAME}:.*?(?=\n  [a-z]|\Z)'
cleaned = re.sub(pattern, '', content, flags=re.DOTALL)
path.write_text(cleaned)
print('Entrée ${NAME} retirée (fallback regex)')
  \"
fi
"
```

### 4. Supprimer les dossiers créés (si créés)

```bash
if [ "$DIRS_CREATED" = "True" ]; then
  ssh octopulse@204.168.209.232 "
  rm -rf ~/octopulse/integrations/docs/${NAME}/
  rm -rf ~/octopulse/integrations/schemas/${NAME}/
  rm -rf ~/octopulse/integrations/recipes/${NAME}/
  echo 'Dossiers supprimés'
  "
fi
```

### 5. Cleanup Mac miroir (si synced)

```bash
if [ -d "/Users/admin/octopulse/integrations/docs/${NAME}" ]; then
  rm -rf /Users/admin/octopulse/integrations/docs/${NAME}
  rm -rf /Users/admin/octopulse/integrations/schemas/${NAME}
  rm -rf /Users/admin/octopulse/integrations/recipes/${NAME}
  echo "Mac miroir nettoyé"
fi
```

### 6. Valider rollback

```bash
ssh octopulse@204.168.209.232 "
# Vérifier que l'entrée n'est plus dans registry.yml
grep -q '^  ${NAME}:' ~/octopulse/integrations/registry.yml && echo 'WARNING: entrée encore présente' || echo 'OK: entrée absente'
# Vérifier que les dirs n'existent plus
test -d ~/octopulse/integrations/docs/${NAME} && echo 'WARNING: dossier doc encore présent' || echo 'OK: dossier doc absent'
"
```

### 7. Message final

```
ROLLBACK COMPLET pour API '${name}'

Ce qui a été défait :
  [x] Collection ClawMem docs-{name} supprimée (si créée)
  [x] registry.yml restauré depuis backup (entrée {name} retirée)
  [x] Dossiers docs/{name}/ schemas/{name}/ recipes/{name}/ supprimés
  [x] Mac miroir nettoyé

Le système est dans l'état antérieur au provisioning.
Corriger l'erreur, puis relancer /octopulse:add-api-integration.
```

### 8. Cleanup state JSON

```bash
rm -f "$STATE_FILE"
echo "State JSON supprimé"
```

---

## SUCCESS METRICS:

- Aucune entrée `{name}` dans registry.yml
- Aucun dossier `docs/{name}/`, `schemas/{name}/`, `recipes/{name}/` sur VPS
- Aucune collection `docs-{name}` dans ClawMem
- State JSON supprimé

## FAILURE MODES:

- Backup registry.yml absent → tentative de suppression regex (risqué, alerter)
- Clawmem collection remove non disponible → noter pour cleanup manuel
- Dossiers non supprimables (permissions) → escalader à l'admin
