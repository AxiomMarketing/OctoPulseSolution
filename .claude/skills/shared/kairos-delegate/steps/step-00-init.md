---
name: step-00-init
description: Parse inputs du caller, init state JSON, détection resume
next_step: steps/step-01-validate-need.md
---

# Step 0: Initialization

## MANDATORY EXECUTION RULES (READ FIRST):

- 🛑 NEVER procéder sans `caller_agent` identifié (traçabilité Sentinel)
- 🛑 NEVER écraser un state JSON en cours (check resume)
- ✅ ALWAYS initialiser `auto_mode: true` par défaut (agents invoquent en batch)
- ✅ ALWAYS générer un timestamp ISO UTC pour trigger_id
- 📋 YOU ARE AN INITIALIZER
- 💬 FOCUS sur parsing + setup, pas sur validation business
- 🚫 FORBIDDEN de charger step-01 sans state JSON écrit

## EXECUTION PROTOCOLS:

- 🎯 Parse tous les inputs avant toute action
- 💾 Écrire state JSON immédiatement
- 📖 Resume detection : si state JSON existant avec stepsCompleted > 0, reprendre au prochain step incomplete
- 🚫 FORBIDDEN de créer trigger YAML ici

## CONTEXT BOUNDARIES:

- Aucun contexte previous step (1er)
- Le caller est un agent (pas un humain direct la plupart du temps)
- VPS accessible via `octopulse@204.168.209.232`

## YOUR TASK:

Parser les inputs caller, détecter si resume possible, initialiser state JSON pour les steps suivantes.

---

## EXECUTION SEQUENCE:

### 1. Collect inputs

Inputs attendus (voir SKILL.md `<parameters>`) :
- `caller_agent` (obligatoire)
- `target_agent` (obligatoire)
- `prompt` (obligatoire)
- `priority` (obligatoire)
- `notify_on` (optionnel)
- `scheduled_for` (optionnel, ISO 8601)
- `auto_mode` (défaut true)

Si un input obligatoire manque :
- **If `{auto_mode}` = true** : abort avec message "Missing required input: X"
- **If `{auto_mode}` = false** : AskUserQuestion pour chaque missing

### 2. Check resume

```bash
CALLER=$(echo "$caller_agent" | sed 's/[^a-z0-9-]/-/g')
STATE_PATTERN="/tmp/kairos-delegate-state-${CALLER}-*.json"

# Recent state (last 5 min) = probable same invocation
RECENT=$(find /tmp -name "kairos-delegate-state-${CALLER}-*.json" -mmin -5 2>/dev/null | head -1)
if [ -n "$RECENT" ]; then
  LAST_STEP=$(jq '.stepsCompleted[-1] // 0' "$RECENT")
  echo "[resume] state trouvé : $RECENT (last step: $LAST_STEP)"
  export STATE_FILE="$RECENT"
  # Load next incomplete step
  exit 0
fi
```

### 3. Generate trigger_id

Format : `{caller}-{YYYYMMDD-HHMMSS}-{6char-slug}`

```bash
TS=$(date -u +%Y%m%d-%H%M%S)
SLUG=$(head -c 8 /dev/urandom | base64 | tr -dc 'a-z0-9' | head -c 6)
TRIGGER_ID="${CALLER}-${TS}-${SLUG}"
```

### 4. Write state JSON

```bash
STATE_FILE="/tmp/kairos-delegate-state-${CALLER}-${TS}.json"
cat > "$STATE_FILE" <<EOF
{
  "caller_agent": "$caller_agent",
  "target_agent": "$target_agent",
  "prompt": $(jq -Rs . <<< "$prompt"),
  "priority": "$priority",
  "notify_on": $notify_on_json,
  "scheduled_for": $scheduled_for_or_null,
  "auto_mode": $auto_mode,
  "trigger_id": "$TRIGGER_ID",
  "cc_sparky_required": null,
  "yaml_path": null,
  "validation_result": null,
  "stepsCompleted": [0],
  "started_at": "$(date -u +%FT%TZ)"
}
EOF
```

### 5. Confirm start (si !auto_mode)

**If `{auto_mode}` = true:**
→ Proceed to step-01

**If `{auto_mode}` = false:**
```yaml
questions:
  - header: "Start delegation"
    question: "Délégation KAIROS : {caller_agent} → {target_agent} (priority={priority}). Démarrer ?"
    options:
      - label: "Démarrer (Recommandé)"
        description: "Valider et déposer le trigger"
      - label: "Annuler"
        description: "Pas de délégation"
    multiSelect: false
```

---

## SUCCESS METRICS:

✅ Tous les inputs obligatoires présents
✅ `trigger_id` unique généré
✅ State JSON écrit avec chemin retenu
✅ Resume détection fonctionne (skip init si state récent existe)
✅ `stepsCompleted: [0]` inscrit

## FAILURE MODES:

❌ Procéder sans caller_agent → impossible de tracer Sentinel Pattern 4.11
❌ Trigger_id non unique → collision avec file existante
❌ State JSON non écrit → steps suivantes ne peuvent rien lire
❌ **CRITICAL**: Confondre auto_mode avec invocation humaine (la plupart des callers sont des agents)

## INIT PROTOCOLS:

- Parse ALL inputs avant validation
- Resume = safe re-invocation (agent peut re-appeler)
- Trigger_id deterministic uniquement via timestamp + slug random
- State file path = single source of truth pour les steps suivantes

---

## NEXT STEP:

Load `./step-01-validate-need.md`

<critical>
Remember: init = setup seulement. Pas de création de YAML, pas de validation business. Tout ça arrive dans les steps suivantes.
</critical>
