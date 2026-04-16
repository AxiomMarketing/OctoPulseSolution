---
name: atlas:weekly-report
description: Rapport hebdo lundi 7h — consolidation 7j, MER/ROAS/CPA par créative × ad set, winners/losers, recommandations plan tests.
---

# Rapport Hebdo Atlas

## Quand l'utiliser
- **Lundi 7h** (avant Radar 7h30 et plan Stratege 9h)
- Consolidation des 7 jours écoulés

## Entrées requises
- 7 rapports quotidiens
- Instructions Stratege semaine passée
- Briefs Forge livrés

## Étapes

1. **MER / ROAS / CPA** global et par ad set sur 7j

2. **Performance par créative** :
   - Top 5 winners (CPA bas, ROAS haut, volume)
   - Top 5 losers (à kill ou déjà kill)
   - Neutres (laisser courir ou kill selon stratégie)

3. **Performance par persona × angle × format** :
   - Quelle combinaison domine ?
   - Quelle combinaison patine ?

4. **Tendances** :
   - Cette semaine vs semaine précédente (Δ%)
   - Cette semaine vs moyenne 4 semaines

5. **Hypothèses conclues** (pour registre Stratege) :
   - HYP-X : VALIDE / INVALIDE / INCONCLUSIF
   - Data : CPA, ROAS, ATC, durée
   - Recommandation

6. **Signaux pour Stratege** :
   - Opportunités scaling
   - Besoin variantes Forge (winners saturation imminente)
   - ATC sans achat (flag Nexus)
   - Audiences qui s'essoufflent (flag Keeper pour refresh LAL)

7. **Recommandations plan tests W+1** :
   - 2-3 hypothèses suggérées (mais Stratege décide)

## Sortie
- `team-workspace/marketing/reports/atlas-weekly/YYYY-W[XX].md`
- SendMessage → Stratege (rapport complet)
- CC Sparky (résumé 3 lignes)
- SendMessage → Funnel (si anomalie attribution)

## Règles strictes
- **Livrable avant 7h30** (Radar consolide ensuite, Stratege planifie à 9h)
- **Objectivité totale** : flagger autant winners que losers
- **Pas de recommandation tranchée** sur hypothèses futures (c'est Stratege)
- **Attribution transparente** : si anomalie, signalée pas masquée

## References
- Quotidien : `atlas:daily-report`
- Mensuel : `atlas:monthly-report`
- Escalade : `atlas:alert-escalade`
- Seuils : `team-workspace/marketing/references/atlas-seuils-alertes.md`
