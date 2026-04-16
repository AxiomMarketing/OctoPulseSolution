---
name: funnel:ga4-analysis
description: Analyse data GA4 + PostHog + Shopify — sessions, conversion par source, funnel landing→purchase, cross-check Atlas et Nexus.
---

# GA4 + PostHog Analysis

## Quand l'utiliser
- Rapport hebdo Funnel (lundi)
- Diagnostic anomalie Atlas (attribution)
- Support décision Stratege (canal allocation)

## Entrées requises
- Sub-agent `funnel-data-analyst`
- PostHog (trafic + événements comportement — first-party déjà en place projet Univile)
- GA4 (si disponible en complément)
- Shopify analytics (revenue brut source de vérité)
- Fairing post-purchase survey (si activé)

## Étapes

1. **Sessions 7j** :
   - Total
   - Par canal (direct, organic search, paid social, email, referral)
   - Par device (97% mobile attendu)
   - Par destination (top 5 pays/régions)

2. **Conversion par source** :
   - CVR par canal
   - Revenue par canal
   - AOV par canal
   - Top 10 pages de landing (avec CVR)

3. **Funnel analysis** (landing → product → cart → checkout → purchase) :
   - Drop-off par étape
   - Temps moyen par étape
   - Device split
   - Mobile vs desktop funnel

4. **Cross-check Atlas (paid)** :
   - Attribution Meta vs Shopify (écart attendu ±5%)
   - Si > 10% → flag Atlas + Funnel investigation
   - Identifier cause : attribution window, cookies, iOS privacy

5. **Cross-check Nexus (tunnel)** :
   - Top frictions détectées (vs Nexus audit)
   - Pages à optimiser en priorité
   - A/B tests en cours impact

6. **Segments avancés** :
   - New vs returning (via Keeper CRM cross-ref)
   - Diaspora vs local Réunion
   - Mobile vs desktop behavior

7. **Recommandations** :
   - Stratege : canal à scaler / freiner
   - Nexus : friction prioritaire
   - Maeva : contenu qui convertit
   - Keeper : segments à activer

## Sortie
- `team-workspace/marketing/funnel/data/YYYY-WXX.md`
- Section dans `funnel:weekly-report`
- SendMessage aux Masters concernés (recommandations ciblées)

## Règles strictes
- **Shopify revenue = source vérité** (toute divergence d'attribution se résoud en faveur de Shopify)
- **PostHog first-party** (pas de dépendance cookie tiers)
- **Mobile-first analytics** (segment primary)
- **Pas de conclusions sur < 7j** (sauf crise)
- **Flagger anomalies plutôt que cacher**

## References
- Sub-agent : `.claude/agents/subs/funnel-data-analyst.md`
- Consolidation : `funnel:data-consolidation`
- Weekly : `funnel:weekly-report`
