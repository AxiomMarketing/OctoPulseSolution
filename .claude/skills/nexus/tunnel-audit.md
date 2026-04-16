---
name: nexus:tunnel-audit
description: Audit complet tunnel univile.com — landing→ATC→checkout→payment→merci. Drop-off, friction, device split. Recommandations quick wins vs refonte.
---

# Audit Tunnel univile.com

## Quand l'utiliser
- Audit trimestriel standard
- Après refonte (landing, checkout, paiement)
- Diagnostic Atlas ATC > 0 sans achat persistant
- Avant campagne majeure (Fête des Mères)

## Entrées requises
- Accès PostHog (funnels, heatmaps, session recordings)
- Shopify analytics (CVR, AOV, panier moyen)
- Atlas attribution data (trafic paid)
- Fairing post-purchase survey (si activé)
- Mobile : 97% du trafic — priorité

## Étapes

1. **Mesure drop-off par étape** (fenêtre 30j) :
   - Landing → Product view
   - Product view → ATC
   - ATC → Checkout initié
   - Checkout initié → Payment
   - Payment → Merci (success)

2. **Benchmark Univile vs e-commerce FR** :
   - ATC rate : bench 8-12%, actuel XX%
   - Checkout init rate : bench 40-50%, actuel XX%
   - Payment complete rate : bench 70-80%, actuel XX%
   - Overall CVR : bench 1,5-2,5%, actuel XX%

3. **Temps moyen par étape** :
   - Flag si > 2x moyenne (possible friction)

4. **Device split analysis** :
   - Mobile CVR vs desktop CVR (attendu mobile < desktop sur pas e-commerce)
   - Si écart > 50% en faveur desktop → problème mobile UX

5. **Session recordings** (top 20 drop-offs) :
   - PostHog recordings : visualiser où ça bloque
   - Patterns récurrents (erreur js, form confus, CTA pas clair)

6. **Heatmaps** :
   - Clics sur éléments non cliquables (confusion)
   - Zones ignorées (contenu pas lu)
   - Dead clicks

7. **Audit technique** :
   - Core Web Vitals par page (LCP, INP, CLS)
   - Errors javascript console
   - Form validation blocking
   - Payment providers disponibles (mobile wallet ?)

8. **Friction prioritaire** (top 3) :
   - Chacune scorée par impact CVR estimé + effort refonte

9. **Recommandations** :
   - Quick wins (< 1 semaine, dev local)
   - Refonte partielle (2-4 semaines)
   - Refonte majeure (> 1 mois)

## Sortie
- `team-workspace/marketing/nexus/audits/YYYY-MM-audit.md`
- SendMessage → Stratege (section recommandations impact paid)
- SendMessage → Funnel (cross-ref data consolidation)
- CC Sparky
- Validation Marty pour refontes majeures

## Règles strictes
- **Mobile first** (97% trafic)
- **Validation humaine** pour charte Univile (tutoiement B2C, vocabulaire "affiche" / "art mural")
- **Jamais de friction artificielle** (popup intrusif = kill CVR mobile)
- **Benchmarks objectifs** vs e-commerce FR (pas de confort)
- **Validation Marty** pour changements impactant identité marque

## References
- Ref : `team-workspace/marketing/references/nexus-tunnel-audit.md`
- Destinations : `team-workspace/marketing/references/destinations-univile.md`
- Funnel data : `funnel:ga4-analysis`
- CRO testing : `nexus:cro-testing`
