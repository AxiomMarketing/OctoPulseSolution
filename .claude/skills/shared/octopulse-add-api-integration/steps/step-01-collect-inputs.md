---
name: step-01-collect-inputs
description: Compléter inputs manquants si auto_mode=false, vérifier item Bitwarden accessible via session active
prev_step: steps/step-00-init.md
next_step: steps/step-02-registry-and-dirs.md
---

# Step 1: Collecter et valider inputs

## MANDATORY EXECUTION RULES (READ FIRST):

- NEVER procéder sans Bitwarden accessible (clé non trouvée = appel API impossible)
- ALWAYS vérifier via session BW active (pas juste l'existence de l'item en dur)
- YOU ARE AN INPUT VALIDATOR — vérification, pas d'actions de provisioning
- FORBIDDEN de charger step-02 si bw_accessible = false

## YOUR TASK:

Compléter les inputs optionnels manquants si mode interactif, puis vérifier que l'item Bitwarden existe et est accessible.

---

## EXECUTION SEQUENCE:

### 1. Load state

```bash
STATE_FILE="/tmp/octopulse-add-api-state-${name}.json"
NAME=$(python3 -c "import json; print(json.load(open('$STATE_FILE'))['name'])")
BW_ITEM=$(python3 -c "import json; print(json.load(open('$STATE_FILE'))['bw_item'])")
AUTO_MODE=$(python3 -c "import json; print(json.load(open('$STATE_FILE'))['auto_mode'])")
```

### 2. Inputs optionnels (si auto_mode=false)

Si `auto_mode: false`, proposer de compléter les champs optionnels :

```yaml
questions:
  - header: "OpenAPI spec (optionnel)"
    question: "URL du fichier openapi.json si disponible ? (Entrée pour ignorer)"
    multiSelect: false
  - header: "Rate limit"
    question: "Limite d'appels par heure ? (défaut: 100)"
    multiSelect: false
  - header: "Fetch schedule"
    question: "Stratégie de fetch ?"
    options:
      - label: "nightly"
        description: "Re-indexé chaque nuit par KAIROS (recommandé)"
      - label: "skip_use_mcp"
        description: "API avec MCP officiel — skip le fetch custom"
    multiSelect: false
```

Si `auto_mode: true` → utiliser les défauts du state JSON.

### 3. Vérifier item Bitwarden sur VPS

```bash
ssh octopulse@204.168.209.232 '
source ~/.bw-env 2>/dev/null || true
if [ -z "$BW_SESSION" ]; then
  # Tenter déverrouillage automatique
  if [ -f ~/bin/bw-ensure-unlock.sh ]; then
    source <(~/bin/bw-ensure-unlock.sh 2>/dev/null)
  fi
fi
if [ -z "$BW_SESSION" ]; then
  echo "BW_SESSION_UNAVAILABLE"
  exit 1
fi
RESULT=$(bw list items --session "$BW_SESSION" --search "'"${BW_ITEM}"'" 2>/dev/null | python3 -c "import json,sys; items=json.load(sys.stdin); print(items[0][\"name\"] if items else \"NOT_FOUND\")")
echo "$RESULT"
'
```

Si `BW_SESSION_UNAVAILABLE` :
```
Bitwarden session non active sur le VPS.
Action requise : connecter via `ssh octopulse@204.168.209.232 'bw unlock'` puis relancer le skill.
```
Abort.

Si `NOT_FOUND` :
```
Item Bitwarden '${bw_item}' introuvable.
Créer d'abord l'item dans le vault Bitwarden avec ce nom exact, puis relancer.
```
Abort.

Si item trouvé → `bw_accessible: true` dans state JSON.

### 4. Update state

```bash
python3 - <<'EOF'
import json
state = json.load(open(STATE_FILE))
state["bw_accessible"] = True
state["stepsCompleted"].append(1)
json.dump(state, open(STATE_FILE, "w"), indent=2)
print("Step 1 OK: Bitwarden accessible")
EOF
```

---

## SUCCESS METRICS:

- Tous les inputs présents dans state JSON
- `bw_accessible: true` confirmé
- `stepsCompleted` contient 1

## FAILURE MODES:

- BW session absente → appels API impossible en production
- Item BW non trouvé → provisioning inutile si la clé manque
- Continuer sans BW accessible → erreurs silencieuses au runtime

---

## NEXT STEP:

Load `./step-02-registry-and-dirs.md`
