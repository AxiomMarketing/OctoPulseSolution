---
name: stratege:bilan-mensuel
description: Bilan mensuel Opus 1er du mois — MER/ROAS/CPA 30j, learnings encodés, pivots, saisonnalité, alignement Maeva.
---

# Bilan Mensuel Stratege (mode Opus)

## Quand l'utiliser
- **1er du mois 10h** (après rapport Atlas mensuel)
- Basculer explicitement en mode thinking étendu (Opus)

## Entrées requises
- Rapport mensuel Atlas
- Registre hypothèses (tests VALIDE/INVALIDE/INCONCLUSIF du mois)
- Rapports Radar / Maeva / Nexus / Keeper / Funnel mensuels
- Décisions Marty du mois

## Étapes

1. **Performance 30j** :
   - MER global vs target 22 647€
   - CPA moyen vs target
   - ROAS par ad set, par persona × angle × format
   - Saisonnalité impact (event du mois)

2. **Inventaire tests** :
   - Hypothèses VALIDEES (encoder learning)
   - Hypothèses INVALIDEES (encoder learning — ne jamais retester à l'identique)
   - Hypothèses INCONCLUSIVES (décider : retest ou kill)

3. **Winners/losers du mois** :
   - Top 3 winners (à continuer de scaler)
   - Top 3 losers (à analyser — pourquoi ?)
   - Angles/formats dominants

4. **Encodage learnings** : ajouter L11, L12+ dans `learnings-creatifs.md`
   - Chaque learning = observation + preuve chiffrée + recommandation

5. **Pivot decisions** :
   - Maintenir / ajuster / pivoter la stratégie
   - Nouveaux axes d'exploration pour mois prochain
   - Saisonnalité mois prochain (events, promos)

6. **Allocation budget M+1** : répartition A/B/C, réserve tests, réserve events (`stratege:allocation-budget`)

7. **Alignement Maeva** : angles paid winners à reformuler en organique, contenus organiques viraux à tester en paid

8. **Recommandations Marty** : 2-3 décisions structurelles à valider (format escalade executive summary)

## Sortie
- `team-workspace/marketing/strategie/bilans/YYYY-MM.md` (document complet 3-5 pages)
- SendMessage → Marty via Sparky (executive summary + 3 recommandations)
- SendMessage → Maeva (synergie paid-organic mois suivant)
- CC Sparky + Sentinel (indépendant)

## Règles strictes
- **Mode Opus obligatoire** : analyse profonde, pas de raccourci
- **Encodage systématique** des learnings (sinon perte institutionnelle)
- **Transparence** sur les échecs (pas de cherry-picking)
- **Pas de pivot sans data 30j** (règle Coudac : les données pilotent)
- **Validation Marty** avant tout changement structurel

## References
- Ref principale : `team-workspace/marketing/references/learnings-creatifs.md`
- Coudac 12 règles : `team-workspace/marketing/references/coudac-12-regles-details.md`
- Allocation : `stratege:allocation-budget`
- Synergie Maeva : `maeva:synergy-paid`
- Escalade : `.claude/shared/escalade-matrix.md`
