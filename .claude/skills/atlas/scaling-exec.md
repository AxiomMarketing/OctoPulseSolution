---
name: atlas:scaling-exec
description: Exécution d'un scaling décidé par Stratege — +20%/jour par palier, monitoring intraday, rollback si CPA dégrade >15%.
---

# Scaling Execution

## Quand l'utiliser
- Réception instruction Stratege (`stratege:scaling-decision`)
- Application par palier, jamais en une fois
- Rollback si dégradation

## Entrées requises
- INS-YYYY-MM-DD-NN avec flag SCALING
- BRF ID winner
- Palier courant + palier cible
- Plan variantes Forge (si applicable)

## Étapes

1. **Validation instruction** : lire INS Stratege, confirmer palier courant et palier cible

2. **Application palier J+1** :
   - +20% budget sur ad set concerné
   - Conserver exactement les mêmes créatives (pas de changement structurel)
   - Note : pas de +20% instantané sur Meta (Meta fait sa propre escalade intra-journée)

3. **Monitoring intraday J+1** :
   - Check 4h après lancement : spend prévu réaliste ?
   - Check 12h : CPA stable vs 7j précédent ?
   - Check 24h : CPA dégradation > 15% ? → FLAG rollback

4. **Décision palier J+2** :
   - Si CPA stable : go +20% (palier suivant)
   - Si CPA dégradé < 15% : hold le palier actuel 24h supplémentaires
   - Si CPA dégradé > 15% : rollback au palier précédent

5. **Palier suivant** : répéter étapes 2-4

6. **Lancement variantes** : si Forge livre les 3-5 variantes en J+3-4, les mettre en rotation sur Ad Set B LAL (jamais sur C Test qui reste dédié aux nouvelles hypothèses)

7. **Rapport Stratege** à chaque palier :
   - Spend effectif
   - CPA courant
   - Frequency courante
   - Recommandation continuer / hold / rollback

8. **Horizontal** (si décidé par Stratege) : duplication ad set avec audience LAL adjacente

## Sortie
- Log `team-workspace/marketing/reports/atlas-scalings/SCL-YYYY-MM-DD.md`
- SendMessage → Stratege à chaque palier
- Alert Marty via Sparky si rollback nécessaire (budget impact)

## Règles strictes
- **+20% MAX/jour** (non négociable — règle Coudac #4)
- **Paliers non-cumulables** : 1 palier = 24h observation
- **Frequency watch** : si approche 2,5 pendant scaling, stop et attendre variantes
- **Rollback immédiat** si CPA dégradation > 15%
- **Rapport Stratege obligatoire** à chaque palier (pas juste à la fin)

## References
- Décision scaling : `stratege:scaling-decision`
- Scaling framework : `team-workspace/marketing/references/scaling-framework.md`
- Variantes : `forge:variantes-winner`
- Escalade : `atlas:alert-escalade`
