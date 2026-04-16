---
name: step-00-init
description: Parse service/method/endpoint/payload args, detect agent name, validate service is supported.
next_step: steps/step-01-query-docs.md
---

# Step 0: Initialisation

## MANDATORY EXECUTION RULES (READ FIRST):

- STOP if service is not one of: meta-ads, shopify, printful, klaviyo, posthog
- ALWAYS set agent_name from context (current agent or "manual" if invoked directly)
- YOU ARE AN INITIALIZER, not an executor
- FOCUS on parsing and validation only
- FORBIDDEN to make any API call in this step

## EXECUTION PROTOCOLS:

- Parse all arguments before proceeding
- Validate service is in supported list
- Complete this step fully before loading step-01

## CONTEXT BOUNDARIES:

- Input: arguments passed to the skill (service, method, endpoint, payload_json)
- Output: state variables set for downstream steps
- No network calls in this step

## YOUR TASK:

Parse and validate the input arguments, set up state variables for the workflow.

---

## EXECUTION SEQUENCE:

### 1. Parse Arguments

Extract from skill invocation:
- `service` (required) : meta-ads | shopify | printful | klaviyo | posthog
- `method` (required) : GET | POST | PUT | DELETE
- `endpoint` (required) : path string starting with /
- `payload` (optional) : JSON string, default to "{}" if GET

### 2. Validate Service

Supported services: `meta-ads`, `shopify`, `printful`, `klaviyo`, `posthog`

If service not in list:
```
ERREUR: Service inconnu '<service>'. Valeurs acceptees: meta-ads, shopify, printful, klaviyo, posthog
```
STOP. Do not continue.

### 3. Detect Agent Name

Set `agent_name` = current agent identifier (from session context, or "manual" if unknown).

### 4. Confirm State

Print summary:
```
[api:safe-call] Init
  Service  : <service>
  Method   : <method>
  Endpoint : <endpoint>
  Payload  : <payload or "(none)">
  Agent    : <agent_name>
```

## SUCCESS METRICS:

- service is valid
- method is one of GET/POST/PUT/DELETE
- endpoint starts with /
- State variables set

## FAILURE MODES:

- Unknown service -> STOP with clear error
- Missing required args -> STOP with usage hint

## NEXT STEP:

Load `steps/step-01-query-docs.md`
