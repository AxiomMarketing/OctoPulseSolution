---
name: "api:validate-request"
description: "Valide une requête API contre le JSON Schema local AVANT envoi. Détecte champs manquants, types invalides, valeurs hors enum. Utiliser entre la construction de la requête et l'envoi."
---

# Validation pré-flight API

## Usage

```bash
~/octopulse/integrations/_lib/validate-request.sh <service> <endpoint> '<payload_json>'
```

## Exemples

```bash
# Meta Ads : valider params insights
~/octopulse/integrations/_lib/validate-request.sh meta-ads insights '{"fields":"spend,impressions","date_preset":"yesterday","level":"campaign"}'
# → {"valid": true}

# Meta Ads : payload invalide
~/octopulse/integrations/_lib/validate-request.sh meta-ads insights '{"fields":"INVALID","date_preset":"demain"}'
# → {"valid": false, "error": "'demain' is not one of ['today', 'yesterday', ...]"}
```

## Retour

- `{"valid": true}` → OK, tu peux envoyer
- `{"valid": false, "error": "...", "path": "...", "hint": "..."}` → corrige et re-valide
- `{"valid": true, "warning": "no_schema"}` → pas de schema pour cet endpoint, envoie prudemment

## Règles

- Valide TOUJOURS avant d'envoyer (surtout Meta Ads — incident historique)
- Si pas de schema : envoi prudent avec limit=1 d'abord (test)
- Les schemas sont dans `~/octopulse/integrations/schemas/<service>/`
