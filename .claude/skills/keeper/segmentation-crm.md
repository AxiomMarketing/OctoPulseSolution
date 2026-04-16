---
name: keeper:segmentation-crm
description: Segmentation CRM dynamique — RFM, comportementale, diaspora, exclusions paid. Refresh quotidien automatique.
---

# Segmentation CRM

## Quand l'utiliser
- Setup initial segments
- Création d'un nouveau segment à la demande Stratege
- Revue mensuelle (déduplication, pertinence)

## Entrées requises
- Base Klaviyo + Shopify
- Comportement navigation (PostHog via Funnel)
- Sub-agent `keeper-klaviyo-ops`

## Segments core

### RFM (Recency, Frequency, Monetary)

| Segment | Définition | Usage |
|---------|-----------|-------|
| VIP | 3+ achats OU CLV > 200€ | Séquences loyalty, LAL source premium |
| Meilleurs clients | Top 10% CLV | LAL source #1 Stratege |
| Acheteurs récents | Purchase < 30j | **Exclusion paid** (anti-waste) |
| Acheteurs actifs | Purchase 30-90j | Email regular, pas paid |
| Dormants | Purchase 90-180j | Séquence winback |
| Churned | Purchase > 180j | Campagne réactivation ponctuelle |

### Comportementale

| Segment | Définition | Usage |
|---------|-----------|-------|
| Browsers engagés | 3+ sessions, 0 achat | Séquence browse abandonment |
| Cart abandoners | Cart créé, pas checkout | Abandoned cart flow |
| Engaged email | Clicks 3+ en 30j | Audience chaude nurturing |
| Unsubs récents | Unsub < 30j | Suppression active |

### Diaspora & destination

| Segment | Définition | Usage |
|---------|-----------|-------|
| Diaspora Réunion | Livraison hors Réunion + adresse métropole | Messaging diaspora |
| Locaux Réunion | Livraison Réunion | Messaging local |
| Mayotte & autres | Livraison DOM autres | Messaging spécifique |
| International | Livraison hors France | Futur, faible volume |

## Exclusions paid (critiques)

- **Acheteurs < 30j** : exclusion obligatoire Ad Sets A et B (anti-waste)
- **Unsubs** : exclusion email ET paid
- **B2B contacts** : ségrégés des consumer audiences

## Étapes

1. **Setup Klaviyo segments dynamiques** (via sub-agent klaviyo-ops)
2. **Sync vers Meta custom audiences** : hashage SHA-256 obligatoire (RGPD)
3. **Refresh** : auto quotidien sur Klaviyo, push Meta hebdomadaire
4. **Cross-check Funnel** : data PostHog cohérente avec Klaviyo
5. **Metadata** : chaque segment a un YAML doc (critères, taille actuelle, usage, date dernière MAJ)

## Sortie
- `team-workspace/marketing/keeper/segments/index.md` (registre segments)
- `team-workspace/marketing/keeper/segments/SEG-*.md` (1 fichier par segment, metadata)
- Push Meta custom audiences (hebdo)
- Metrics dans `keeper:weekly-report`

## Règles strictes
- **RGPD** : consentement explicite, droit à l'oubli
- **Hashage SHA-256** pour push Meta (jamais d'email en clair)
- **Exclusions paid systématiques** (acheteurs < 30j, unsubs)
- **Refresh quotidien** minimum
- **Cross-check** Funnel + Shopify trimestriel

## References
- Sub-agent : `.claude/agents/subs/keeper-klaviyo-ops.md`
- Personas : `team-workspace/marketing/references/personas-details.md`
- LAL audiences : `keeper:lal-audiences`
- Weekly : `keeper:weekly-report`
