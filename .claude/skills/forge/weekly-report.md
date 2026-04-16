---
name: forge:weekly-report
description: Rapport hebdo Forge — volume produit, pass rate QC, file d'attente, learnings nouveaux. Lundi 9h30.
---

# Rapport Hebdo Forge

## Quand l'utiliser
- **Lundi 9h30** (après plan-hebdo Stratege 9h, avant Atlas 10h)
- Consolidation des 7 jours

## Entrées requises
- Logs production (`forge/briefs-accepted/`, `forge/delivered/`, `forge/qc/`)
- Sub-agents individual reports
- Feedback Atlas (performance créatives livrées S-1)

## Étapes

1. **Volume produit** :
   - Créatives paid livrées : X (target 3-5/sem)
   - Créatives organiques livrées : Y (support Maeva)
   - Créatives email livrées : Z (support Keeper)

2. **Pass rate QC** :
   - Pass 1 1er passage : X% (target > 70%)
   - Cycles retake moyens : X (target < 1,5)
   - Failures blocs les plus fréquents (identifier patterns)

3. **File d'attente** :
   - Briefs en cours : X
   - Briefs en attente : Y
   - Briefs bloqués (clarification Stratege) : Z

4. **Performance créatives livrées S-1** (feedback Atlas):
   - Winners : [liste BRF IDs]
   - Losers : [liste BRF IDs]
   - Neutres : [liste]

5. **Learnings nouveaux** (L11+) :
   - Patterns observés à encoder dans `learnings-creatifs.md`
   - Combinaisons persona × angle × format à flaguer

6. **Blockers identifiés** :
   - Manque d'assets produit (escalade fournisseur)
   - Briefs récurrents imprécis (feedback Stratege)
   - Sub-agent en souffrance (surcharge)

7. **Prospective S+1** : briefs attendus, capacité disponible

## Sortie
- `team-workspace/marketing/reports/forge-weekly/YYYY-W[XX].md`
- SendMessage → Stratege (section performance + learnings)
- SendMessage → Sparky (résumé 2 lignes)

## Règles strictes
- **Honnêteté** sur pass rate et cycles retake (ne pas masquer les échecs)
- **Feedback Atlas obligatoire** : sans retour performance, impossible d'itérer
- **Learnings partagés** : toute observation récurrente est codifiée
- **Prospective réaliste** : pas de sur-promesse capacité

## References
- Pipeline : `forge:production-pipeline`
- QC : `forge:qc-checklist`
- Learnings : `team-workspace/marketing/references/learnings-creatifs.md`
- Protocole comm : `.claude/shared/communication-protocol.md`
