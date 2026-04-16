---
name: step-04-execute
description: Fetcher la cle Bitwarden, executer le curl avec retry-backoff, logger l'appel en JSONL.
prev_step: steps/step-03-rate-limit.md
next_step: steps/step-05-response.md
---

# Step 4: Execution

## MANDATORY EXECUTION RULES (READ FIRST):

- NEVER hardcode API keys — ALWAYS use bw-get.sh
- ALWAYS log every call, even failures
- YOU ARE AN EXECUTOR, not a planner
- FOCUS on fetch key + curl + log only
- FORBIDDEN to retry more than 3 times

## EXECUTION PROTOCOLS:

- Fetch token via bw-get.sh
- Build curl command for service
- Execute with retry-backoff if 5xx
- Log result immediately after

## CONTEXT BOUNDARIES:

- State available: service, method, endpoint, payload, agent_name, validation_result
- Output: response, http_status, latency_ms, token (sensitive — do not print)

## YOUR TASK:

Fetcher la cle API, executer l'appel HTTP avec retry, et logger le resultat.

---

## EXECUTION SEQUENCE:

### 1. Verifier si un recipe existe

```bash
ls ~/octopulse/integrations/recipes/<service>/ 2>/dev/null
```

Si un recipe couvre ce endpoint: utiliser le recipe plutot que construire manuellement.

### 2. Fetch token Bitwarden

```bash
TOKEN=$(~/octopulse/integrations/_lib/bw-get.sh <bw_item>)
```

Bitwarden items par service:
| Service | bw_item |
|---------|---------|
| meta-ads | meta-long-token |
| shopify | shopify-access-token |
| printful | Printful |
| klaviyo | klaviyo-api-key |
| posthog | posthog-api-key |

Ne jamais afficher TOKEN dans les logs.

### 3. Construire et executer le curl

Note START_TIME pour latency.

**Meta Ads (GET):**
```bash
curl -s -o /tmp/api_response.json -w "%{http_code}" \
  "https://graph.facebook.com/v21.0<endpoint>?<payload_as_querystring>" \
  -H "Authorization: Bearer $TOKEN"
```

**Shopify:**
```bash
curl -s -o /tmp/api_response.json -w "%{http_code}" \
  "https://rungraphik.myshopify.com/admin/api/2026-04<endpoint>.json" \
  -H "X-Shopify-Access-Token: $TOKEN"
```

**Printful:**
```bash
curl -s -o /tmp/api_response.json -w "%{http_code}" \
  "https://api.printful.com<endpoint>" \
  -H "Authorization: Bearer $TOKEN"
```

**Klaviyo:**
```bash
curl -s -o /tmp/api_response.json -w "%{http_code}" \
  "https://a.klaviyo.com/api<endpoint>" \
  -H "Authorization: Klaviyo-API-Key $TOKEN" \
  -H "revision: 2024-10-15"
```

**PostHog:**
```bash
curl -s -o /tmp/api_response.json -w "%{http_code}" \
  "https://app.posthog.com/api<endpoint>" \
  -H "Authorization: Bearer $TOKEN"
```

### 4. Si 5xx: retry avec backoff

```bash
~/octopulse/integrations/_lib/retry-backoff.sh 3 2 curl ...
```

Maximum 3 retries, backoff 2s.

### 5. Calculer latency_ms

END_TIME - START_TIME en millisecondes.

Set `http_status` et `latency_ms` en state.

### 6. Logger l'appel

```bash
~/octopulse/integrations/_lib/log-api-call.sh \
  <service> <agent_name> <method> <endpoint> <http_status> <latency_ms> <response_size>
```

Toujours logger, meme en cas d'erreur.

## SUCCESS METRICS:

- Token fetched (not hardcoded)
- curl executed
- Logged in JSONL

## FAILURE MODES:

- bw-get.sh fails -> STOP, cannot proceed without key
- curl fails after 3 retries -> proceed to step-05 with error state

## NEXT STEP:

Load `steps/step-05-response.md`
