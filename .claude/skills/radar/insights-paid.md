---
name: radar:insights-paid
description: Produire des insights paid-exploitables consolidés pour Stratege — format standardisé, fraîcheur <7j, max 5 par semaine.
---

# Insights Paid pour Stratege

## Quand l'utiliser
- Consolidation hebdo lundi 8h (avant plan-hebdo Stratege 9h)
- À la demande de Stratege sur un sujet spécifique (< 24h)
- Après détection d'un pattern concurrent récurrent

## Entrées requises
- Outputs scouts : `radar-scout-concurrence`, `radar-scout-tendances`, `radar-scout-actu`
- Registre hypothèses Stratege (`team-workspace/marketing/strategie/registre-hypotheses.md`) pour éviter doublons
- Learnings encodés (`team-workspace/marketing/references/learnings-creatifs.md`)

## Étapes

1. **Collecte 7j** : agréger outputs des 3 scouts sur la semaine écoulée

2. **Dé-duplication** : écarter tout insight déjà testé (voir registre hypothèses) ou signalé le mois précédent

3. **Scoring ICE adapté** par insight :
   - Impact paid potentiel (0-100) = fit persona × angle × volume audience
   - Confiance (proof social, preuve concurrent, learning similaire)
   - Effort production Forge (jours-h)

4. **Priorisation** : top 5 insights score ICE > 50

5. **Format standardisé** par insight :
   ```markdown
   ### INS-PAID-YYYY-WXX-NN — [titre]
   - **Source** : [scout + URL + date]
   - **Persona cible** : Marie / Julien / Christiane
   - **Angle proposé** : [1 des 6 angles]
   - **Format suggéré** : [image / video interdite / carousel]
   - **Hypothèse testable** : "Si [action], alors [résultat mesurable]"
   - **Preuve social** : [lien concurrent / benchmark]
   - **ICE** : Impact X / Confiance X / Effort X = Score XX
   - **Fenêtre fraîcheur** : [JJ-MM → JJ-MM+7]
   ```

6. **Livraison** : SendMessage → Stratege avec les 5 insights + CC Sparky résumé 2 lignes

## Sortie
- Fichier `team-workspace/marketing/radar/insights-paid/YYYY-WXX.md`
- Message structuré vers Stratege lundi 8h
- Archive mensuelle pour bilan

## Règles strictes
- **Jamais recommander vidéo** (interdit phase actuelle — règle Coudac)
- **Jamais recommander retargeting** sous 5000 visiteurs/mois
- **Fraîcheur < 7 jours** impérative (sinon archive)
- **Max 5 insights/semaine** (au-delà = bruit pour Stratege)
- **Pas de ciblage** dans la recommandation (règle Coudac : la créa est le ciblage)

## References
- Scoring : `team-workspace/marketing/references/scoring-insights-paid.md`
- 12 règles Coudac : `team-workspace/marketing/references/coudac-12-regles-details.md`
- Matrice Persona × Angle × Format : `team-workspace/marketing/references/matrice-persona-angle-format.md`
- Sub-agents scouts : `.claude/agents/subs/radar-scout-*.md`
