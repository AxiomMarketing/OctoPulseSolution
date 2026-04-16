---
name: step-05-response
description: Parser la reponse, detecter les erreurs 4xx/5xx, signaler les breaking changes potentiels.
prev_step: steps/step-04-execute.md
---

# Step 5: Traitement reponse

## MANDATORY EXECUTION RULES (READ FIRST):

- NEVER silently ignore 4xx errors
- ALWAYS flag unexpected 4xx as potential breaking change
- YOU ARE A RESPONSE HANDLER, not a retry engine
- FOCUS on parsing, error classification, and alerting
- FORBIDDEN to make additional API calls in this step

## EXECUTION PROTOCOLS:

- Read response from /tmp/api_response.json
- Classify by HTTP status
- Alert Sparky if 3 consecutive 4xx on same endpoint

## CONTEXT BOUNDARIES:

- State available: http_status, response (from step-04), service, endpoint, agent_name
- Output: final parsed response returned to caller

## YOUR TASK:

Parser la reponse HTTP, classifier les erreurs, et alerter si breaking change probable.

---

## EXECUTION SEQUENCE:

### 1. Lire la reponse

```bash
cat /tmp/api_response.json | jq '.' 2>/dev/null || cat /tmp/api_response.json
```

### 2. Classifier par status HTTP

**2xx (Succes):**
- Afficher reponse formatee JSON
- Return reponse au caller

**400 Bad Request:**
```
ERREUR 400: Requete invalide.
Action: re-verifier params via /api:query-docs + /api:validate-request
Detail: <error message from response>
```

**401 Unauthorized:**
```
ERREUR 401: Cle API invalide ou expiree.
Action: forcer refresh -> rm /run/user/$(id -u)/api-key-* && re-bw-get
```

**403 Forbidden:**
```
ERREUR 403: Permissions insuffisantes.
Action: escalader a Marty pour verifier les scopes de l'app.
```

**429 Rate Limited:**
```
ERREUR 429: Rate limit atteint cote serveur.
Retry-After: <header value si present>
Action: attendre avant de re-essayer.
```

**5xx Server Error:**
```
ERREUR <status>: Erreur serveur API.
Retry-backoff effectue en step-04.
```

### 3. Detecter breaking change potentiel

Si status 4xx ET inattendu (validation etait OK en step-02):
- Incrementer compteur d'erreurs consecutives pour cet endpoint (stocker dans ~/.cache/octopulse/api-errors/<service>-<endpoint_clean>.count)
- Si compteur >= 3:
  ```
  ALERTE SPARKY: 3 erreurs 4xx consecutives sur <service>/<endpoint>.
  Possible breaking change API. Investigation necessaire.
  ```
  Declencher KAIROS trigger:
  ```bash
  kairos-ctl trigger sparky "Breaking change possible: <service> <endpoint> retourne 4xx x3. Verifier changelog API." --priority high
  ```

### 4. Retourner au caller

Afficher le resultat final:
```
[api:safe-call] Resultat
  Status   : <http_status>
  Latency  : <latency_ms>ms
  Service  : <service>
  Endpoint : <endpoint>
  Response : <json or error summary>
```

## SUCCESS METRICS:

- Response parsed and displayed
- Errors classified with clear action
- Breaking change detection triggered if needed

## FAILURE MODES:

- Cannot parse JSON -> display raw response with warning
- KAIROS not available -> log alert to ~/logs/api-alerts.log instead

<critical>
Remember: ALWAYS return a clear result to the caller — never end silently. Even errors must be surfaced with actionable guidance.
</critical>
