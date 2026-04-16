---
name: keeper:weekly-report
description: Rapport hebdo Keeper — ouvertures/clicks, revenue email, opt-ins, segments MAJ, nouvelles LAL. Lundi 10h30.
---

# Rapport Hebdo Keeper

## Quand l'utiliser
- **Lundi 10h30** (après Atlas 7h, Radar 7h30, Funnel 10h)
- Consolidation 7 jours

## Entrées requises
- Stats Klaviyo (par flow et campaign)
- Segments à jour
- LAL refresh status

## Étapes

1. **Performance flows** (par flow : Welcome, Cart, Browse, Post-purchase, Winback, VIP)
   - Ouvertures (target > 40%)
   - Clicks (target > 3%)
   - CVR (target > 2%)
   - Revenue attribué (target > 20% total email)
   - Unsubs rate (seuil rouge > 0,5%/campaign)

2. **Performance campaigns broadcast** (si applicable semaine) :
   - Subject line A/B winner
   - Best time send
   - Segments activés

3. **Segments MAJ** :
   - Segments créés/supprimés
   - Taille des segments critiques (VIP, Meilleurs clients, Diaspora, Exclusions)
   - Anomalies (chute soudaine)

4. **LAL refresh** :
   - Nouvelles LAL disponibles
   - LAL avec changement de taille significatif
   - LAL à désactiver (underperform)

5. **Opt-ins & churn** :
   - Nouveaux opt-ins 7j
   - Unsubs 7j
   - Net growth
   - Baseline N-1 vs moyenne 4 semaines

6. **Revenue consolidation** :
   - Revenue email total 7j
   - vs S-1 (tendance)
   - % total revenue (cross-check Funnel)

7. **Flux vers Stratege** :
   - Nouvelles LAL dispos pour tests
   - Segments qui convertissent mieux (à activer en paid)
   - Signaux à tester (hooks email qui performent)

## Sortie
- `team-workspace/marketing/reports/keeper-weekly/YYYY-W[XX].md`
- SendMessage → Stratege (section LAL + signaux)
- SendMessage → Maeva (si angles email performants à reprendre organique)
- CC Sparky résumé 3 lignes
- CC Funnel (cross-check revenue email)

## Règles strictes
- **Seuils rouges** :
  - Unsubs > 0,5% par campaign → investigation
  - Ouvertures < 30% sur Welcome → problème delivery ou subject
  - CVR < 1% sur Cart → problème urgent (incentive ? timing ?)
- **Baseline N-1 ET moyenne 4 semaines** (détecter tendances)
- **Transparence** : flagger chute même si ponctuelle

## References
- Klaviyo seq : `keeper:klaviyo-sequences`
- Segments : `keeper:segmentation-crm`
- LAL : `keeper:lal-audiences`
- Communication : `.claude/shared/communication-protocol.md`
