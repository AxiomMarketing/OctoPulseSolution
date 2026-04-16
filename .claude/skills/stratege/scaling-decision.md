---
name: stratege:scaling-decision
description: Décision de scaling d'un winner — vertical +20%/jour, paliers 50→60→72→86€, horizontal, variantes Forge, validation Marty si +50%.
---

# Scaling Decision

## Quand l'utiliser
- Atlas signale winner clair : CPA < target × 0,8, MER > 3, sur 5+ jours
- Registre hypothèses a VALIDE une hypothèse
- Capacité budget disponible

## Entrées requises
- BRF ID winner + métriques (CPA, MER, frequency, CTR, budget courant, durée)
- Budget total disponible
- Learnings de scalings passés
- Benchmark saturation (frequency approchant 2,5)

## Étapes

1. **Validation winner** (strict) :
   - CPA < target × 0,8 : ✅
   - MER > 3 sur 5j minimum : ✅
   - Frequency < 2,5 : ✅
   - Volume suffisant (≥ 5 achats) : ✅
   Si UN seul KO → pas de scaling, continuer à observer

2. **Choix stratégie scaling** :
   - **Vertical** : augmenter budget sur ad set existant
     - +20%/jour MAX (règle Coudac #4)
     - Paliers : 50 → 60 → 72 → 86 → 103 → 124 → 149 €/j
     - 1 palier = 24h minimum d'observation avant incrément suivant
   - **Horizontal** : dupliquer sur nouvel ad set (même créative, audience adjacente LAL)
   - **Variantes** : brief Forge pour 3-5 variantes sur axe hook/visuel/copy (voir `forge:variantes-winner`)

3. **Plan scaling type** :
   - J+1 : +20% vertical (palier 1)
   - J+2 : check CPA, si stable → +20% (palier 2)
   - J+3-4 : lancement variantes Forge en rotation (prévenir saturation)
   - J+5 : si tout OK, horizontal nouvel ad set LAL 2%

4. **Validation Marty** :
   - Scaling < +50% budget existant : auto-décision Stratege
   - Scaling > +50% budget existant : escalade Marty via Sparky AVANT exécution

5. **Instruction Atlas** (via `stratege:instruction-atlas`)

6. **Monitoring** : checkpoints daily sur CPA, rollback si dégradation > 15%

## Sortie
- `team-workspace/marketing/strategie/scalings/SCL-YYYY-MM-DD-[BRF-ID].md`
- Instruction Atlas
- Brief Forge (si variantes)
- CC Sparky + Marty (si +50%)

## Règles strictes
- **+20%/jour MAX** (non négociable)
- **Jamais brusquer** : doubler le budget en 1 jour = apprentissage Meta perdu
- **Frequency watch** : rafraîchir créative avant 2,5 (jamais attendre 3)
- **Rollback immédiat** si CPA dégradation > 15% 48h
- **Escalade Marty** si +50% budget

## References
- Scaling framework : `team-workspace/marketing/references/scaling-framework.md`
- Coudac règle #4 : `team-workspace/marketing/references/coudac-12-regles-details.md`
- Variantes : `forge:variantes-winner`
- Allocation : `stratege:allocation-budget`
