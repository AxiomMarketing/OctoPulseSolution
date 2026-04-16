---
name: step-03-rate-limit
description: Verifier le quota rate-limit pour cet agent et cette API avant d'envoyer.
prev_step: steps/step-02-validate.md
next_step: steps/step-04-execute.md
---

# Step 3: Rate-limit check

## MANDATORY EXECUTION RULES (READ FIRST):

- STOP immediately if rate-limit exceeded (exit 1)
- NEVER bypass rate-limit check
- YOU ARE A GATEKEEPER, not an executor
- FOCUS on quota verification only
- FORBIDDEN to call the API if rate-limit exceeded

## EXECUTION PROTOCOLS:

- Run rate-limit.sh with service + agent_name
- If exceeded: STOP with clear message and wait time
- If OK: proceed to execute

## CONTEXT BOUNDARIES:

- State available: service, agent_name
- Output: rate-limit status (ok or exceeded)

## YOUR TASK:

Verifier que l'agent n'a pas depasse son quota pour cette API.

---

## EXECUTION SEQUENCE:

### 1. Lancer le check

```bash
~/octopulse/integrations/_lib/rate-limit.sh <service> <agent_name>
```

### 2. Interpreter exit code

**Exit 0 (OK):**
-> Afficher: "[rate-limit] OK pour <service> / <agent_name>"
-> Continuer vers step-04

**Exit 1 (Exceeded):**
-> Afficher:
```
STOP: Rate-limit depasse pour <service> (agent: <agent_name>)
Attendre avant de re-essayer ou reduire la frequence des appels.
```
-> STOP. Ne pas executer l'appel.

## SUCCESS METRICS:

- rate-limit.sh executed
- Exit 0 received

## FAILURE MODES:

- Exit 1 -> STOP, no API call made
- rate-limit.sh missing -> warn, proceed with caution (log manually)

## NEXT STEP:

Load `steps/step-04-execute.md`
