---
name: keeper:klaviyo-sequences
description: Pilotage séquences Klaviyo — welcome series, abandoned cart, post-purchase, winback, VIP. A/B subject lines, optimisation via klaviyo-ops.
---

# Séquences Klaviyo

## Quand l'utiliser
- Setup initial séquences
- Revue mensuelle performance
- Ajustement saisonnier (Fête des Mères, Noël)
- Nouveau segment activé

## Entrées requises
- Sub-agent `keeper-klaviyo-ops`
- Klaviyo account Univile
- Segments CRM (`keeper:segmentation-crm`)
- Calendrier éditorial Maeva (alignement messaging)

## Séquences core (6 flows)

### 1. Welcome Series
- **Trigger** : nouvel opt-in (popup, checkout, Shopify sub)
- **Séquence** : email 1 (bienvenue + discount 10%) → email 2 J+2 (histoire Univile, destinations) → email 3 J+5 (bestsellers) → email 4 J+10 (review social proof)
- **Target CVR** : >5%

### 2. Abandoned Cart
- **Trigger** : cart créé, pas de checkout complet
- **Séquence** : email 1 à J+1h → email 2 à J+24h (soft reminder + review) → email 3 à J+72h (incentive 5% ou frais port offerts)
- **Target recovery** : >15% carts

### 3. Browse Abandonment
- **Trigger** : produit viewé 3+ fois, pas d'ATC
- **Séquence** : email 1 J+1 avec produit viewé + similaires
- **Target CVR** : >2%

### 4. Post-Purchase
- **Trigger** : achat
- **Séquence** : email 1 J+0 (confirm) → email 2 J+7 (suivi livraison + care) → email 3 J+21 (review request) → email 4 J+45 (cross-sell)

### 5. Winback
- **Trigger** : pas d'achat depuis 90j (post-purchase)
- **Séquence** : email 1 "on vous a manqué" → email 2 avec incentive → email 3 last chance

### 6. VIP Loyalty
- **Trigger** : 3+ achats ou CLV > 200€
- **Séquence** : access early drops, exclusive content, perks

## Séquences futures (5 flows à activer)

- Birthday flow
- Anniversary flow (achat)
- Re-engagement dormants
- Diaspora-specific welcome
- Seasonal campaigns

## Étapes opérationnelles

1. **Setup** : via sub-agent klaviyo-ops, structure email Univile (palette, charte)
2. **Briefs Maeva** : copy / visuels pour chaque séquence (voix Univile)
3. **Briefs Forge** : visuels dédiés email (format banner)
4. **A/B test subject lines** : permanent sur Welcome et Cart
5. **Measure** : ouverture, clicks, CVR, revenue attribué
6. **Itération** : revue mensuelle

## Sortie
- `team-workspace/marketing/keeper/flows/YYYY-MM-overview.md`
- Metrics dans `keeper:weekly-report`
- Coordination avec Maeva (calendrier) et Forge (assets)

## Règles strictes
- **Validation humaine** avant activation nouveau flow
- **Voix Univile** stricte (pas de template Klaviyo générique)
- **Mobile-first** design (97% lecture mobile)
- **Pas de double-tagging** : chaque contact = 1 flow dominant
- **Respect consentement RGPD**

## References
- Sub-agent : `.claude/agents/subs/keeper-klaviyo-ops.md`
- Sequences ref : `team-workspace/marketing/references/klaviyo-sequences.md`
- Segmentation : `keeper:segmentation-crm`
- Lifecycle : `keeper:lifecycle-triggers`
