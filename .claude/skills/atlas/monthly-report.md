---
name: atlas:monthly-report
description: Rapport mensuel 1er du mois — bilan 30j, attribution persona × angle × format, saisonnalité, input bilan Stratege.
---

# Rapport Mensuel Atlas

## Quand l'utiliser
- **1er du mois 7h** (avant bilan mensuel Stratege)
- Période : mois écoulé complet

## Entrées requises
- 30 rapports quotidiens + 4 rapports hebdo
- Instructions Stratege mois passé
- Scalings appliqués

## Étapes

1. **MER / ROAS / CPA** 30j vs M-1 vs M-2 (tendance)

2. **Volume** :
   - Spend total
   - Achats total
   - AOV moyen

3. **Attribution détaillée** :
   - Par ad set (A/B/C) : spend / ROAS / volume
   - Par persona : Marie / Julien / Christiane
   - Par angle (6 angles)
   - Par format (image / carousel)

4. **Matrice croisée persona × angle** : heatmap performance

5. **Saisonnalité** :
   - Events du mois impactés
   - Week-ends vs semaine
   - Pics/creux (peut indiquer payday, fin de mois, etc.)

6. **Hypothèses du mois** :
   - Nb tests lancés
   - Nb VALIDE / INVALIDE / INCONCLUSIF
   - Coût moyen par test

7. **Scalings** :
   - Winners scalés (BRF IDs + facteur × budget atteint)
   - Scalings avortés (pourquoi)

8. **Anomalies** :
   - Dégradation ROAS inexpliquée
   - Ad sets sous-performants
   - Attribution Shopify vs Meta (écart)

## Sortie
- `team-workspace/marketing/reports/atlas-monthly/YYYY-MM.md`
- SendMessage → Stratege (input pour `stratege:bilan-mensuel`)
- CC Sparky
- CC Funnel (cross-check data consolidation)

## Règles strictes
- **Livrable avant 9h** le 1er (Stratege attaque bilan à 10h)
- **Exhaustivité** : tous les data points (pas de cherry-picking)
- **Attribution transparente** : écarts Meta vs Shopify = flagués
- **Pas de conclusions stratégiques** (c'est Stratege qui tire les learnings)

## References
- Hebdo : `atlas:weekly-report`
- Bilan Stratege : `stratege:bilan-mensuel`
- Consolidation data : `funnel:data-consolidation`
- Seuils : `team-workspace/marketing/references/atlas-seuils-alertes.md`
