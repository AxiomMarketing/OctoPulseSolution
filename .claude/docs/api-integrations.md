# API Integrations — Guide Agent

## Architecture

```
docs/<api>/*.md  →  ClawMem docs-<api>  →  vsearch → validate → safe-call
```

5 APIs disponibles : `meta-ads`, `shopify`, `printful`, `klaviyo`, `posthog`

## Workflow standard (utiliser le skill)

```
/api:safe-call api=meta-ads endpoint=/act_{ACCOUNT_ID}/campaigns method=GET params={"fields":"id,name,status"}
```

## Étapes manuelles si besoin

```bash
# 1. Chercher dans la doc
clawmem vsearch -c docs-meta-ads "campaigns endpoint fields" -n 3

# 2. Valider le payload
~/octopulse/integrations/_lib/validate-request.sh meta-ads campaigns payload.json

# 3. Appeler l'API
~/octopulse/integrations/_lib/safe-caller.sh \
  --api meta-ads --method GET \
  --endpoint "/act_{ACCOUNT_ID}/campaigns" \
  --params "fields=id,name,status"
```

## Collections ClawMem

| Collection | API |
|-----------|-----|
| `docs-meta-ads` | Meta Marketing API |
| `docs-shopify` | Shopify Admin API |
| `docs-printful` | Printful API |
| `docs-klaviyo` | Klaviyo API |
| `docs-posthog` | PostHog API |

## Rate limits (respecter impérativement)

| API | Limite |
|-----|--------|
| meta-ads | 150/h, 2000/j |
| shopify | 30/min |
| printful | 100/h |
| klaviyo | 75/min |
| posthog | 500/h |

## Credentials (jamais hardcodés)

Tous les secrets sont dans Bitwarden. Le `safe-caller.sh` les lit automatiquement via `bw-get`.

## Ajouter une nouvelle API

```
/octopulse:add-api-integration
```

## Diagnostic

```bash
integrations-ctl status     # vue d'ensemble
integrations-ctl test <api> # diagnostic complet
integrations-ctl diff       # voir les changements nightly
```
