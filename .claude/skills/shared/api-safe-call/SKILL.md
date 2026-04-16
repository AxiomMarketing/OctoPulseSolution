---
name: "api:safe-call"
description: "Appel API securise : doc lookup, schema validation, rate-limit check, curl avec retry, log structure. Utiliser pour TOUT appel API externe dans OctoPulse. Protege contre les incidents (requetes erronees, rate-limit, leaks)."
argument-hint: <service> <method> <endpoint> [payload_json]
---

<objective>
Executer un appel API externe de facon securisee et tracee, en consultant la doc, validant le payload, verifiant le rate-limit, puis en executant avec retry et logging JSONL.
</objective>

<parameters>
- service : meta-ads | shopify | printful | klaviyo | posthog
- method : GET | POST | PUT | DELETE
- endpoint : path apres base URL (ex: /act_XXX/insights)
- payload_json : JSON en string (optionnel pour GET)
</parameters>

<state_variables>
- service: string         # API cible
- method: string          # HTTP method
- endpoint: string        # API endpoint path
- payload: string         # JSON payload (peut etre vide)
- agent_name: string      # nom de l'agent appelant (pour rate-limit log)
- doc_passages: string    # passages retournes par vsearch
- validation_result: object  # {valid, error, warning}
- token: string           # cle API recuperee via bw-get
- response: object        # reponse curl parsee
- http_status: int        # code HTTP retour
- latency_ms: int         # latence en ms
</state_variables>

<entry_point>
Load `steps/step-00-init.md`
</entry_point>

<step_files>
| Step | Fichier | Description |
|------|---------|-------------|
| 0 | steps/step-00-init.md | Parse args, setup state, identifier agent |
| 1 | steps/step-01-query-docs.md | Consulter doc indexee via clawmem vsearch |
| 2 | steps/step-02-validate.md | Valider payload via validate-request.sh |
| 3 | steps/step-03-rate-limit.md | Verifier quota rate-limit par agent+API |
| 4 | steps/step-04-execute.md | Fetch cle bw-get, curl, retry-backoff, log |
| 5 | steps/step-05-response.md | Parser reponse, detecter 4xx, retourner |
</step_files>
