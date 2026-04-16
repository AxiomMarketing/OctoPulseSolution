---
name: step-01-query-docs
description: Consulter la doc indexee ClawMem pour verifier le format correct avant de construire la requete.
prev_step: steps/step-00-init.md
next_step: steps/step-02-validate.md
---

# Step 1: Consultation documentation

## MANDATORY EXECUTION RULES (READ FIRST):

- ALWAYS consult doc before building request (never skip)
- NEVER proceed if vsearch completely fails with no output
- YOU ARE A DOC READER, not a request builder
- FOCUS on finding relevant passages only
- FORBIDDEN to make any API call in this step

## EXECUTION PROTOCOLS:

- Run vsearch command
- If collection missing: warn and use WebFetch fallback
- Complete doc review before loading step-02

## CONTEXT BOUNDARIES:

- State available: service, method, endpoint, payload, agent_name
- Output: doc_passages stored in state

## YOUR TASK:

Rechercher dans la doc indexee les passages pertinents pour le endpoint/methode cible.

---

## EXECUTION SEQUENCE:

### 1. Construire la query vsearch

Query = "<method> <endpoint> <key fields from payload>"

Example: "GET /insights spend impressions date_preset"

### 2. Lancer vsearch

```bash
export PATH=$HOME/.bun/bin:$PATH
clawmem vsearch -c docs-<service> "<query>" -n 5
```

### 3. Si collection absente

If exit code != 0 or output contains "collection not found":
```
WARN: Collection docs-<service> absente. Fallback WebFetch.
```
Use WebFetch on official doc URL from `~/octopulse/integrations/registry.yml` (field `doc_url`).

### 4. Lire les passages

Afficher les passages retournes. Identifier:
- Format attendu des params (query string vs body JSON)
- Champs obligatoires
- Valeurs enum valides
- Headers requis specifiques

Store passages in `doc_passages`.

## SUCCESS METRICS:

- vsearch executed (or WebFetch fallback used)
- Relevant passages read
- doc_passages state set

## FAILURE MODES:

- Both vsearch and WebFetch fail -> STOP + report to Sparky

## NEXT STEP:

Load `steps/step-02-validate.md`
