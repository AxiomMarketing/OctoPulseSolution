---
name: keeper:lifecycle-triggers
description: Triggers lifecycle temps réel — browse/cart abandonment, birthday, anniversary, post-purchase. Coordination avec Nexus.
---

# Lifecycle Triggers

## Quand l'utiliser
- Setup initial d'un trigger
- Ajout d'un nouveau trigger
- Revue mensuelle performance

## Triggers actifs

### Browse Abandonment
- **Trigger** : produit viewé 3+ fois sans ATC en 3j
- **Delay** : J+1 après dernier view
- **Content** : produit viewé + 3 similaires + social proof (reviews)
- **Variantes persona** : Marie (émotion), Julien (rationnel), Christiane (premium)

### Cart Abandonment
- **Trigger** : cart créé, pas de checkout 1h+
- **Delay cascade** : 1h / 24h / 72h
- **Content** : rappel + incentive progressif (5% à J+72h si nécessaire)
- **Variante mobile vs desktop** (97% mobile → prioritaire)

### Checkout Abandonment
- **Trigger** : checkout initié, pas complété
- **Delay** : 1h
- **Content** : focus friction (frais port ? délai ?) — **coordonner avec Nexus** qui a audité le tunnel

### Post-Purchase
- **Triggers** :
  - J+0 : confirm (auto Shopify + renforcement Univile)
  - J+7 : suivi livraison + care
  - J+21 : review request
  - J+45 : cross-sell
- **Variantes destination** (Réunion vs métropole = timings livraison différents)

### Birthday
- **Trigger** : date anniversaire
- **Delay** : J-7 pour anticiper
- **Content** : code 10% sur destinations favorites
- **Opt-in uniquement** : date récupérée au checkout ou popup

### Anniversary (1 an achat)
- **Trigger** : J+365 post-purchase
- **Content** : remerciement + incentive premium

## Coordination avec Nexus

- Si Nexus détecte friction checkout → adapter copy cart abandonment
- Si Nexus teste un changement tunnel → ajuster delays trigger
- Feedback Nexus sur conversion trigger → itérer

## Étapes

1. **Setup trigger** dans Klaviyo (via klaviyo-ops)
2. **A/B test** sur subject line et delay optimal
3. **Variantes persona** : 3 versions min sur triggers majeurs
4. **Measure** : ouverture, click, CVR, revenue attribué par trigger
5. **Iteration** : revue mensuelle, kill si CVR < 1%

## Sortie
- `team-workspace/marketing/keeper/triggers/TRG-*.md` par trigger
- Metrics dans `keeper:weekly-report`
- Coordination docs avec Nexus

## Règles strictes
- **Respect consentement** RGPD (notamment birthday = opt-in explicite)
- **Pas de spam** : max 1 trigger actif par contact en parallèle
- **Mobile-first** design
- **Coordination Nexus** obligatoire sur triggers checkout (ne pas travailler en silo)
- **Pas de sur-incentive** : trop de codes 10% = dévaluation marque

## References
- Sequences : `keeper:klaviyo-sequences`
- Tunnel audit : `nexus:tunnel-audit`
- Sub-agent : `.claude/agents/subs/keeper-klaviyo-ops.md`
- Personas : `team-workspace/marketing/references/personas-details.md`
