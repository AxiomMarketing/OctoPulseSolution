---
name: forge:variantes-winner
description: Production de 3-5 variantes sur un winner identifié par Atlas — persona/angle/format constants, axes variables hook/visuel/CTA.
---

# Production Variantes Winner

## Quand l'utiliser
- Atlas signale un winner clair (CPA < target × 0.8, MER > 3 sur 5+ jours)
- Stratege décide de scaler (instruction via `stratege:scaling-decision`)
- Anticipation saturation (frequency approchant 2,5)

## Entrées requises
- BRF ID source (winner original)
- Métriques performance (CPA, ROAS, frequency, CTR)
- Timing urgence (avant frequency > 3)

## Étapes

1. **Analyse winner** :
   - Quel élément porte la performance ? (hook / visuel / copy / CTA)
   - Persona + angle + format = CONSTANTS (ne pas changer, sinon on teste une nouvelle hypothèse, pas une variante)

2. **Axes de variation** (max 1 par variante) :
   - **V1 hook** : même visuel, même copy, hook différent
   - **V2 visuel** : même hook, même copy, visuel différent (angle photo, composition)
   - **V3 copy** : même visuel, même hook, primary text différent
   - **V4 CTA** : même tout, CTA différent (si applicable)
   - **V5 (optionnel)** : combinaison 2 axes winners identifiés

3. **Production** (pipeline accéléré, car concept/strategist étape sautée) :
   - Art-director : variantes visuelles
   - Copywriter : variantes hooks + copy
   - QC : passe rapide (charte + coudac)

4. **Livraison** : package à Atlas avec label "VARIANT-[BRF-origine]-vX"
   - Ad Set cible : B (LAL) — jamais C Test qui est réservé aux nouvelles hypothèses
   - Budget alloué : +20%/jour sur le winner original, variantes en rotation

5. **Mesure** : Atlas reporte sur 5-7j
   - Winner variant émergeant → nouvelle variante de la variante (ad infinitum jusqu'à saturation)
   - Toutes flatliners → on stoppe, on revient à l'original qu'on laisse courir + on lance un nouveau test C

## Règles strictes
- **Persona / angle / format CONSTANTS** : sinon ce n'est pas une variante, c'est une nouvelle hypothèse
- **Max 5 variantes** par winner (au-delà = dispersion budget)
- **Pass QC obligatoire** même accélérée
- **Pas de vidéo** (phase actuelle)
- **Anti-drift de marque** : même en mode accéléré, respect strict charte
- **Jamais copier un concurrent** : une variante s'inspire du winner, pas de l'extérieur

## Sortie
- 3-5 assets livrés à Atlas
- `team-workspace/marketing/forge/variants/BRF-*-variants.md`
- Metadata complète (BRF source + axe variation + version)
- CC Stratege + Sparky

## References
- Pipeline : `forge:production-pipeline`
- Scaling : `team-workspace/marketing/references/scaling-framework.md`
- Learnings : `team-workspace/marketing/references/learnings-creatifs.md`
- QC : `forge:qc-checklist`
