---
name: stratege:plan-hebdo
description: Revue lundi 9h — lecture rapport Atlas, plan tests semaine (2-3 hypothèses, 1 safe + 1 exploratoire), briefs Forge, instructions Atlas.
---

# Plan Hebdo Stratege

## Quand l'utiliser
- **Lundi 9h** après rapport Atlas 8h30 et rapport Radar 7h30
- Ajustement mid-week si pivot majeur détecté

## Entrées requises
- Rapport hebdo Atlas (`reports/atlas-weekly/YYYY-WXX.md`)
- Insights paid Radar (`insights-paid/YYYY-WXX.md`)
- Registre hypothèses (`strategie/registre-hypotheses.md`)
- Budget disponible tests mensuel (~180€)

## Étapes

1. **Lecture data (15min)** : MER global, CPA par ad set A/B/C, winners/losers, tendance 7j et 30j

2. **Identification opportunités** : top 5 insights Radar + signaux Atlas (ATC sans achat, frequency haute, winner saturé)

3. **Scoring ICE** sur chaque hypothèse candidate : Impact (0-100) × Confiance × (1/Effort)

4. **Sélection 2-3 tests** :
   - 1 safe (haute confiance, persona × angle déjà validé, itération mineure)
   - 1 exploratoire (angle neuf, persona neuf ou combinaison jamais testée)
   - 1 optionnel (si budget permet)

5. **Allocation budget** : ~30-60€/test sur 5-7j (min 50€ sinon famine)

6. **Briefs Forge** : pour chaque hypothèse sélectionnée (`stratege:brief-forge`)

7. **Instruction Atlas** : structure ad sets A/B/C, créatives à kill/test/scale, calendrier lancement (`stratege:instruction-atlas`)

8. **Update registre hypothèses** : chaque nouveau test = entrée EN_ATTENTE

## Sortie
- `team-workspace/marketing/strategie/plans/YYYY-WXX.md`
- Briefs Forge envoyés
- Instruction Atlas envoyée
- CC Sparky résumé 3 lignes

## Règles strictes
- **Max 2-3 hypothèses simultanées** (budget contraint)
- **Toujours 1 safe + 1 exploratoire**
- **Jamais repasser test invalidé** sans modif significative
- **Metrique primaire = CPA** (pas ROAS)
- **Min 50€/test**, 5-7j min

## References
- Testing framework : `team-workspace/marketing/references/testing-framework.md`
- Coudac 12 règles : `team-workspace/marketing/references/coudac-12-regles-details.md`
- Skills liés : `stratege:generer-hypothese`, `stratege:brief-forge`, `stratege:instruction-atlas`
