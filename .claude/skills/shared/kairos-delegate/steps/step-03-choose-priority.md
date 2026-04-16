---
name: step-03-choose-priority
description: Appliquer matrice priority + notify_on défaut selon le cas d'usage
prev_step: steps/step-02-collect-inputs.md
next_step: steps/step-04-check-rules.md
---

# Step 3: Matrice priority + notify_on

## MANDATORY EXECUTION RULES (READ FIRST):

- 🛑 NEVER permettre priority invalide (enum strict)
- 🛑 NEVER abuser de "critical" (max 5% des triggers agent, Sentinel Pattern 4.9)
- ✅ ALWAYS calculer notify_on défaut selon priority si non fourni
- ✅ ALWAYS warn si priority=critical ET prompt sans indicateur urgence business
- 📋 YOU ARE A PRIORITY ASSESSOR
- 💬 FOCUS sur assignation priority + notify_on
- 🚫 FORBIDDEN de laisser notify_on vide (garantie que failures sont notifiées)

## EXECUTION PROTOCOLS:

- 🎯 Appliquer matrices selon SKILL.md `<references>`
- 💾 Sauver priority + notify_on finalisés dans state
- 📖 Critical sans justification → downgrade à high + warn
- 🚫 FORBIDDEN de charger step-04 sans priority+notify_on finalisés

## CONTEXT BOUNDARIES:

- Priority input = user-provided (peut être mal calibré)
- Critical doit rester rare — si > 5% des invocations d'un agent, Sentinel flaggue
- notify_on vide = invariant post-fix KAIROS : failure notifié TOUJOURS (même si liste vide)

## YOUR TASK:

Valider priority, appliquer matrice notify_on défaut, détecter abus critical, finaliser dans state.

---

## EXECUTION SEQUENCE:

### 1. Load state

```python
state = json.load(open(state_file))
priority = state["priority"]
notify_on = state.get("notify_on") or []
prompt = state["prompt"]
```

### 2. Validate priority enum

```python
VALID_PRIORITIES = ("normal", "high", "critical")
if priority not in VALID_PRIORITIES:
    print(f"FAIL: priority invalide '{priority}'. Accepté : {VALID_PRIORITIES}", file=sys.stderr)
    sys.exit(1)
```

### 3. Detect critical abuse

Heuristique : si priority=critical, chercher des signaux d'urgence business dans le prompt :

```python
CRITICAL_KEYWORDS = [
    "urgence", "critical", "drop", "spike", "rupture", "bug prod",
    "crise", "fraud", "compliance", "légal", "urgent",
    "data loss", "perte données", "down", "offline", "500",
]
if priority == "critical":
    has_signal = any(kw in prompt.lower() for kw in CRITICAL_KEYWORDS)
    if not has_signal:
        # Warn + optionally downgrade
        print("⚠️ priority=critical sans signal urgence clair dans le prompt.", file=sys.stderr)
        print("Mots-clés attendus : urgence, drop, spike, bug prod, crise, compliance, rupture...", file=sys.stderr)
        print("Downgrade auto à priority=high (évite Sentinel Pattern 4.9).", file=sys.stderr)
        priority = "high"
        state["priority_downgraded"] = True
```

### 4. Apply notify_on matrix

```python
PRIORITY_NOTIFY_DEFAULTS = {
    "normal":   ["failure"],
    "high":     ["completion", "failure"],
    "critical": ["completion", "failure", "critical_alert"],
}

if not notify_on:
    notify_on = PRIORITY_NOTIFY_DEFAULTS[priority]

# Invariant : failure doit TOUJOURS être dans notify_on
if "failure" not in notify_on:
    notify_on.append("failure")
    state["notify_on_failure_auto_added"] = True
```

### 5. Update state

```python
state["priority"] = priority
state["notify_on"] = notify_on
state["stepsCompleted"].append(3)
state["step_03_completed_at"] = datetime.datetime.utcnow().isoformat() + "Z"
json.dump(state, open(state_file, "w"), indent=2)
print(f"priority={priority}, notify_on={notify_on}")
```

---

## SUCCESS METRICS:

✅ Priority ∈ {normal, high, critical}
✅ Notify_on non vide
✅ Failure TOUJOURS dans notify_on (invariant)
✅ Critical sans signal → downgraded à high + noté dans state
✅ State JSON finalisé pour priority + notify_on

## FAILURE MODES:

❌ Accepter priority invalide → KAIROS ne saura pas router notifications
❌ notify_on vide → failure silencieuses (avant fix F3 KAIROS)
❌ Critical abus → Sentinel Pattern 4.9 (asymétrie d'influence)
❌ Agent spammeur de critical → Marty ignore les alertes

## PRIORITY PROTOCOLS:

- Matrix appliquée rigoureusement
- Critical = gated par mot-clé urgence (heuristique mais utile)
- Failure = invariant (doit toujours notifier)

---

## NEXT STEP:

Load `./step-04-check-rules.md`

<critical>
Remember: priority = signal aux humains (Marty). Abus = perte de confiance. Downgrade silencieux si pas de justification.
</critical>
