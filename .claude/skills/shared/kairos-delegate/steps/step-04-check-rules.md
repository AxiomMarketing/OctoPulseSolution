---
name: step-04-check-rules
description: CC Sparky si cross-domaine + anti-abus (max 10/jour, pas self-trigger)
prev_step: steps/step-03-choose-priority.md
next_step: steps/step-05-write-yaml.md
---

# Step 4: CC Sparky + Anti-abus

## MANDATORY EXECUTION RULES (READ FIRST):

- 🛑 NEVER skip le check CC Sparky cross-domaine (Pattern Sentinel 4.11)
- 🛑 NEVER permettre > 10 triggers/jour par même caller_agent (Pattern 4.9)
- ✅ ALWAYS vérifier les 7 flux directs autorisés (exceptions CC)
- ✅ ALWAYS calculer `cc_sparky_required: bool` dans state
- 📋 YOU ARE A RULES ENFORCER
- 💬 FOCUS sur règles communication-protocol + anti-abus
- 🚫 FORBIDDEN de charger step-05 si anti-abus bloque

## EXECUTION PROTOCOLS:

- 🎯 Check 1 : flux direct autorisé (caller → target) → skip CC Sparky
- 🎯 Check 2 : compter triggers caller dans processed/ + inbox/ des 24h glissantes
- 💾 Écrire `cc_sparky_required` + `daily_count` dans state
- 📖 Si limit dépassé → abort avec message + suggestion (wait 24h ou escalade Sparky manuel)

## CONTEXT BOUNDARIES:

- 7 flux directs autorisés documentés dans `~/octopulse/.claude/shared/communication-protocol.md`
- Triggers historiques accessibles via `ls ~/octopulse/kairos/triggers/processed/YYYY-MM-DD/` + inbox
- State JSON contient caller_agent + target_agent

## YOUR TASK:

Appliquer les règles communication-protocol (CC Sparky) + anti-abus (rate-limit daily count).

---

## EXECUTION SEQUENCE:

### 1. Check flux direct autorisé

```python
AUTHORIZED_DIRECT_FLOWS = [
    ("stratege", "forge"),
    ("stratege", "atlas"),
    ("forge", "maeva-director"),  # ou "maeva" selon nommage
    ("radar", "stratege"),
    ("radar", "forge"),
    ("radar", "maeva-director"),
    ("keeper", "maeva-director"),
]

state = json.load(open(state_file))
caller = state["caller_agent"]
target = state["target_agent"]

# Normalize : si target = sub-agent, check parent
target_parent = target.split("-")[0] if "-" in target else target
caller_parent = caller.split("-")[0] if "-" in caller else caller

# Flux direct si paire authorized
is_direct = (caller, target) in AUTHORIZED_DIRECT_FLOWS or \
            (caller_parent, target_parent) in AUTHORIZED_DIRECT_FLOWS

state["is_direct_flow"] = is_direct
state["cc_sparky_required"] = not is_direct
```

### 2. Anti-abus : daily rate-limit

```bash
# Compter triggers caller dans les 24h glissantes
CALLER=$(jq -r .caller_agent "$STATE_FILE")
TODAY=$(date -u +%F)
YESTERDAY=$(date -u -d "yesterday" +%F 2>/dev/null || date -u -v-1d +%F)

COUNT=$(ssh octopulse@204.168.209.232 "
find ~/octopulse/kairos/triggers/processed/{${TODAY},${YESTERDAY}}/ -name '${CALLER}-*.yml' 2>/dev/null | wc -l
find ~/octopulse/kairos/triggers/inbox/ -name '${CALLER}-*.yml' 2>/dev/null | wc -l
find ~/octopulse/kairos/triggers/.inflight/ -name '${CALLER}-*.yml' 2>/dev/null | wc -l
" | awk '{sum+=$1} END {print sum}')

echo "Daily count for $CALLER: $COUNT"

if [ "$COUNT" -ge 10 ]; then
  cat <<MSG
❌ ABUSE RATE LIMIT: $CALLER a déjà 10 triggers dans les 24h glissantes.

Pattern Sentinel 4.9 ("asymétrie d'influence") → limite atteinte.

Options :
1. Attendre que des triggers expirent (next processed)
2. Escalade manuelle à Sparky pour demander une orchestration au lieu de multiples triggers
3. Si urgence réelle : override via kairos-ctl CLI manuel (laisse trace dans logs)

Abort.
MSG
  exit 1
fi
```

### 3. Anti-abus : check prompt similarity (léger)

Si le caller a déjà envoyé un trigger avec prompt très similaire dans les 2h → warn Pattern 4.1 Répétition.

```python
# Implémentation simple : hash de la première phrase du prompt
import hashlib
first_sentence = prompt.split(".")[0][:100]
prompt_hash = hashlib.md5(first_sentence.encode()).hexdigest()[:10]

# Check dans les triggers récents
# (implémentation simplifiée : on skip pour MVP, juste noter)
state["prompt_hash"] = prompt_hash
```

### 4. Check self-trigger (double-check)

Normalement déjà caught en step-01 mais safety net :
```python
if caller == target:
    print("FAIL: self-trigger détecté (Pattern 4.1). Abort.", file=sys.stderr)
    sys.exit(1)
```

### 5. Update state

```python
state["daily_count"] = daily_count
state["stepsCompleted"].append(4)
state["step_04_completed_at"] = datetime.datetime.utcnow().isoformat() + "Z"
json.dump(state, open(state_file, "w"), indent=2)
print(f"CC Sparky required: {state['cc_sparky_required']}, daily count: {daily_count}")
```

---

## SUCCESS METRICS:

✅ `cc_sparky_required` calculé selon 7 flux directs authorized
✅ Daily count calculé, < 10 (sinon abort)
✅ Self-trigger bloqué (double-check)
✅ State JSON updated

## FAILURE MODES:

❌ Skip CC Sparky cross-domaine → Pattern 4.11 violation
❌ Abuser >10 triggers/jour → Pattern 4.9 violation (asymétrie)
❌ Self-trigger passé → Pattern 4.1 violation (répétition)
❌ Check basé sur noms exacts sans normaliser sub-parent

## RULES PROTOCOLS:

- Les 7 flux directs sont figés dans communication-protocol.md — source de vérité
- Rate limit per caller sur 24h glissantes (pas calendaires stricts)
- Self-trigger = Patterns 4.1 + 4.9 + 4.12 cumulés → abort

---

## NEXT STEP:

Load `./step-05-write-yaml.md`

<critical>
Remember: ces règles existent pour éviter que KAIROS devienne un spam channel. Respect strict.
</critical>
