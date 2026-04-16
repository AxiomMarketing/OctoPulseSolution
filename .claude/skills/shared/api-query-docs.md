---
name: "api:query-docs"
description: "Recherche vectorielle dans la documentation API officielle indexée. Retourne les 3-5 passages les plus pertinents (~1000 tokens) au lieu de charger toute la doc. Utiliser AVANT de construire une requête API pour s'assurer du bon format."
---

# Recherche documentation API

## Usage

Quand tu veux appeler une API externe (Meta Ads, Shopify, Printful, Klaviyo, PostHog), commence TOUJOURS par chercher la doc :

```bash
export PATH=$HOME/.bun/bin:$PATH
clawmem vsearch -c docs-<service> "<ta question>" -n 5
```

Services disponibles : `meta-ads`, `shopify`, `printful`, `klaviyo`, `posthog`

## Exemples

```bash
# Meta Ads : comment obtenir les insights par campagne
clawmem vsearch -c docs-meta-ads "get campaign insights ROAS spend impressions" -n 5

# Shopify : lister les commandes récentes
clawmem vsearch -c docs-shopify "list orders created in last 24 hours" -n 5

# Klaviyo : créer un événement tracking
clawmem vsearch -c docs-klaviyo "create event for purchase tracking" -n 5
```

## Règles

- Cherche AVANT de construire ta requête curl (pas après l'erreur 400)
- Si aucun résultat pertinent : fallback via `WebFetch <url_doc_officielle>` (URL dans registry.yml)
- Ne charge JAMAIS la doc entière — les passages suffisent
- Les docs sont mises à jour chaque nuit par KAIROS

## Si collection n'existe pas

```bash
# Vérifier les collections disponibles
clawmem doctor 2>&1 | grep "docs-"
```

Si absent : la doc n'a pas encore été fetchée. Utiliser WebFetch directement sur l'URL officielle.
