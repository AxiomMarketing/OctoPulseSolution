---
name: funnel:weekly-report
description: Rapport hebdo Funnel — trafic organique multi-canal, CVR organique vs paid, top pages, recommandations vers Stratege/Maeva/Nexus.
---

# Rapport Hebdo Funnel

## Quand l'utiliser
- **Lundi 10h** (après rapports Atlas 7h et Radar 7h30)
- Consolidation 7 jours

## Entrées requises
- Output `funnel:ga4-analysis`
- Stats Pinterest (via pin-master)
- Stats SEO (via seo-scout)
- Rapport Atlas hebdo (cross-check)
- Rapport Nexus hebdo (friction tunnel)

## Étapes

1. **Trafic organique par canal** :
   - Google organic search : X sessions / Y conversions / Z revenue
   - Pinterest : idem
   - Direct : idem
   - Referral : idem
   - Email (Keeper) : idem

2. **Top 10 pages** (toutes sources organiques) :
   - URL + sessions + CVR

3. **Top 10 queries SEO** (Search Console) :
   - Query + impressions + position + CTR

4. **CVR organique vs paid** :
   - Organic : X%
   - Paid (Atlas) : Y%
   - Email : Z%
   - Moyenne Univile : W%

5. **MER global** (tous canaux) :
   - Revenue total / (spend paid + coût prod organic + coût outils)
   - Tendance S-1

6. **Anomalies attribution** :
   - Écarts Meta vs Shopify
   - Causes probables (iOS, window attribution)

7. **Recommandations routées** :
   - Vers **Stratege** : canaux organiques qui convertissent bien (angles à tester en paid), ou ad sets paid qui sous-performent vs organique (réallocation)
   - Vers **Maeva** : contenus organiques winners (à amplifier), pages à créer
   - Vers **Keeper** : segments qui convertissent bien (à activer)
   - Vers **Nexus** : pages avec fort drop-off (friction à auditer)

## Sortie
- `team-workspace/marketing/reports/funnel-weekly/YYYY-W[XX].md`
- SendMessage → Stratege (section recommandations)
- SendMessage → Maeva (section contenu)
- SendMessage → Keeper (segments)
- SendMessage → Nexus (friction)
- CC Sparky résumé 3 lignes

## Règles strictes
- **Livrable avant 11h** lundi
- **Recommandations routées** : chaque Master reçoit SA section
- **Transparence** : déclarer les anomalies d'attribution
- **MER global** est un KPI primary (pas secondaire)

## References
- GA4 analysis : `funnel:ga4-analysis`
- Consolidation : `funnel:data-consolidation`
- Communication : `.claude/shared/communication-protocol.md`
