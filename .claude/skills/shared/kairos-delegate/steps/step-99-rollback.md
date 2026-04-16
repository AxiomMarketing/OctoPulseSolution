---
name: step-99-rollback
description: Rollback — supprime le YAML déposé + CC Sparky si écrits
---

# Step 99: Rollback

## MANDATORY EXECUTION RULES (READ FIRST):

- 🛑 NEVER laisser un trigger orphelin dans inbox si workflow abort après step-05
- 🛑 NEVER exécuter si state JSON introuvable (pas de source de vérité)
- ✅ ALWAYS supprimer yaml_path si step-05 a complété
- ✅ ALWAYS supprimer cc_sparky_path si step-06 a complété
- 📋 YOU ARE AN UNDO
- 💬 FOCUS sur cleanup

## EXECUTION PROTOCOLS:

- 🎯 LIFO (dernier créé, premier supprimé)
- 💾 Logger les actions undo pour audit
- 📖 Best-effort : continue même si une undo échoue
- 🚫 FORBIDDEN de stopper au premier échec

## CONTEXT BOUNDARIES:

- `state_file` contient `yaml_path`, `cc_sparky_path` si applicable
- `stepsCompleted` array indique quels steps ont effectivement run

## YOUR TASK:

Annuler les artefacts créés par le workflow (YAML trigger, CC Sparky) en utilisant le state.

---

## EXECUTION SEQUENCE:

### 1. Load state + logger

```bash
LOG="/tmp/kairos-delegate-rollback-$(date +%Y%m%d-%H%M%S).log"
exec > >(tee -a "$LOG") 2>&1
echo "=== ROLLBACK $(date -u +%FT%TZ) ==="
jq . "$STATE_FILE"
```

### 2. Undo CC Sparky (si step-06 a écrit)

```bash
CC_PATH=$(jq -r '.cc_sparky_path // empty' "$STATE_FILE")
if [ -n "$CC_PATH" ]; then
  echo "[undo] rm CC Sparky $CC_PATH"
  VPS_PATH=$(echo "$CC_PATH" | sed 's|^~|/home/octopulse|')
  ssh octopulse@204.168.209.232 "rm -f '$VPS_PATH'" || echo "FAIL: rm CC"
fi
```

### 3. Undo YAML inbox (si step-05 a écrit)

```bash
YAML_PATH=$(jq -r '.yaml_path // empty' "$STATE_FILE")
if [ -n "$YAML_PATH" ]; then
  # Check si KAIROS l'a déjà consommé (peut être dans .inflight/ ou processed/)
  VPS_PATH=$(echo "$YAML_PATH" | sed 's|^~|/home/octopulse|')
  
  if ssh octopulse@204.168.209.232 "test -f '$VPS_PATH'"; then
    echo "[undo] rm trigger YAML (still in inbox) $VPS_PATH"
    ssh octopulse@204.168.209.232 "rm -f '$VPS_PATH'"
  else
    # Peut-être déjà dans inflight/ ou processed/
    TRIGGER_ID=$(jq -r .trigger_id "$STATE_FILE")
    INFLIGHT=$(ssh octopulse@204.168.209.232 "find ~/octopulse/kairos/triggers/.inflight -name '${TRIGGER_ID}.yml' 2>/dev/null | head -1")
    if [ -n "$INFLIGHT" ]; then
      echo "[warn] trigger déjà en cours d'exécution (inflight) — ne peut plus rollback. Filename: $INFLIGHT"
      echo "[warn] Attendre la complétion puis supprimer le report si besoin"
    else
      PROCESSED=$(ssh octopulse@204.168.209.232 "find ~/octopulse/kairos/triggers/processed -name '${TRIGGER_ID}.yml' 2>/dev/null | head -1")
      if [ -n "$PROCESSED" ]; then
        echo "[warn] trigger déjà exécuté (processed) — too late to undo"
      else
        echo "[unknown] trigger $TRIGGER_ID introuvable inbox/inflight/processed — déjà nettoyé ?"
      fi
    fi
  fi
fi
```

### 4. Archive state

```bash
mkdir -p /tmp/archive/rollbacks
mv "$STATE_FILE" "/tmp/archive/rollbacks/rolled-back-$(basename $STATE_FILE)"
```

### 5. Report

```markdown
# ⚠️ Rollback exécuté

**Raison** : {failure_reason}

**Actions** :
- YAML trigger : {removed | too_late | not_found}
- CC Sparky : {removed | n/a}
- State archivé : /tmp/archive/rollbacks/...

Log complet : $LOG
```

---

## SUCCESS METRICS:

✅ YAML inbox supprimé si encore présent
✅ CC Sparky supprimé si écrit
✅ Log complet pour audit
✅ State archivé

## FAILURE MODES:

❌ Stop au premier échec → rollback partiel silencieux
❌ Détruire state → impossible post-mortem
❌ Tenter de supprimer un inflight/processed → KAIROS peut encore l'utiliser (race)

## ROLLBACK PROTOCOLS:

- Best-effort
- Cas edge : trigger déjà inflight → trop tard, warn seulement
- Cas edge : trigger déjà processed → workflow trop tard, le boulot a été fait

---

## NEXT STEP:

Workflow avorté.

<critical>
Remember: rollback KAIROS est time-sensitive. Si KAIROS a déjà pris le trigger, on ne peut plus annuler — seul possibilité = laisser exécuter + cleanup output.
</critical>
