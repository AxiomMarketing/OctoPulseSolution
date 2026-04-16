---
name: funnel:data-consolidation
description: Consolidation multi-canal — Shopify + PostHog + Meta Ads + Pinterest + Klaviyo + Fairing, réconciliation attribution, MER global, dashboard Marty.
---

# Data Consolidation Multi-Canal

## Quand l'utiliser
- Consolidation hebdo (dashboard Marty vendredi)
- Diagnostic d'anomalie détectée (attribution divergente)
- Bilan mensuel cross-canal

## Entrées requises
- **Shopify** : revenue source de vérité
- **Meta Ads** (via Atlas) : spend + events conversion
- **PostHog** : comportement utilisateur first-party
- **Pinterest analytics** : reach organique + outbound clicks
- **Klaviyo** (via Keeper) : revenue email attribué
- **Fairing** : post-purchase "comment nous avez-vous connus ?" (self-reported attribution)

## Étapes

1. **Pull 7j data** depuis toutes sources

2. **Réconciliation revenue** :
   - Shopify total : source vérité
   - Somme attributions Meta + Email + Organic + Direct : doit matcher à ±5%
   - Écart > 5% : investigation immédiate

3. **Détection anomalies** :
   - Meta vs Shopify : si écart > 10%, probable problème pixel/CAPI
   - Klaviyo : si revenue email > 30% total → vérifier attribution (double-count ?)
   - Fairing : si "Instagram" dominant mais Atlas ne reflète pas → problème attribution

4. **MER global calculé** :
   - Revenue total Shopify / (Spend Meta + Coût outils + Coût production Forge estimé)
   - Target : > 3

5. **Dashboard Marty** (format simple, 1 page) :
   ```markdown
   # Dashboard Univile — Semaine WXX

   ## Revenue
   - Total Shopify : XXXX€
   - vs S-1 : Δ+X%
   - vs M-1 : Δ+X%

   ## MER global
   - [X,X]
   - Target : 3,0

   ## Sources (attribution modèle last-click Shopify)
   - Paid Meta : XX% | XX€ | Δ
   - Organic : XX% | XX€ | Δ
   - Email : XX% | XX€ | Δ
   - Direct : XX% | XX€ | Δ
   - Referral : XX% | XX€ | Δ

   ## Cross-check Fairing (self-reported)
   - [top 3 sources déclarées]

   ## Anomalies détectées
   - [si applicable]

   ## Top 5 produits (revenue)
   ```

6. **Distribution** :
   - Dashboard → Marty direct (Telegram push vendredi 17h)
   - CC Sparky
   - CC Stratege (section paid)

## Sortie
- `team-workspace/marketing/funnel/consolidation/YYYY-WXX.md`
- Push Telegram Marty (résumé)
- Alert immediate si anomalie critique

## Règles strictes
- **Shopify revenue = vérité** (pas négociable)
- **Écarts > 10%** = investigation sous 24h
- **Dashboard Marty** = 1 page max, pas verbeux
- **Transparence anomalies** (ne jamais masquer)
- **PostHog first-party** (pas de dépendance cookie tiers qui va disparaître)

## References
- GA4/PostHog : `funnel:ga4-analysis`
- Pinterest : `funnel:pinterest-strategy`
- Weekly : `funnel:weekly-report`
- Sub-agent : `.claude/agents/subs/funnel-data-analyst.md`
- Atlas monthly : `atlas:monthly-report`
