---
name: step-02-validate
description: Valider le payload contre le JSON Schema local avant envoi.
prev_step: steps/step-01-query-docs.md
next_step: steps/step-03-rate-limit.md
---

# Step 2: Validation pre-flight

## MANDATORY EXECUTION RULES (READ FIRST):

- NEVER skip validation for Meta Ads (historical incident)
- ALWAYS re-validate after fixing errors
- YOU ARE A VALIDATOR, not a sender
- FOCUS on schema compliance only
- FORBIDDEN to send request before valid: true

## EXECUTION PROTOCOLS:

- Run validate-request.sh with service/endpoint/payload
- If invalid: fix payload and re-validate (max 2 retries)
- If no schema: proceed with caution (warn user)

## CONTEXT BOUNDARIES:

- State available: service, endpoint, payload, doc_passages
- Output: validation_result set, payload possibly corrected

## YOUR TASK:

Valider le payload JSON contre le schema local et corriger si necessaire.

---

## EXECUTION SEQUENCE:

### 1. Construire endpoint_clean

Strip query string from endpoint for schema lookup:
- `/act_XXX/insights?fields=spend` -> `insights`
- `/orders.json` -> `orders`

### 2. Lancer validation

```bash
~/octopulse/integrations/_lib/validate-request.sh <service> <endpoint_clean> '<payload>'
```

### 3. Interpreter le resultat

**Si `{"valid": true}`:**
-> Continuer vers step-03

**Si `{"valid": false, "error": "...", "hint": "..."}`:**
- Afficher l'erreur clairement
- Corriger le payload en utilisant les passages doc (doc_passages)
- Re-valider (max 2 tentatives)
- Si toujours invalid apres 2 retries -> STOP, afficher erreur finale

**Si `{"valid": true, "warning": "no_schema"}`:**
- Afficher: "WARN: Pas de schema pour cet endpoint. Envoi avec limit=1 recommande."
- Continuer (prudement)

### 4. Mettre a jour payload et validation_result

Store corrected payload and validation result in state.

## SUCCESS METRICS:

- validate-request.sh executed
- validation_result.valid = true (or no_schema warning acknowledged)
- Payload corrected if needed

## FAILURE MODES:

- Still invalid after 2 retries -> STOP with detailed error
- validate-request.sh missing -> warn, proceed with caution

## NEXT STEP:

Load `steps/step-03-rate-limit.md`
