---
name: stratege:generer-hypothese
description: Formaliser une hypothèse testable depuis signal Atlas/Radar/Nexus/Keeper — persona × angle × format, ICE, critères succès.
---

# Générer Hypothèse

## Quand l'utiliser
- Nouveau signal reçu (Atlas ATC sans achat, Radar insight, Nexus friction, Keeper segment)
- Préparation `stratege:plan-hebdo` (2-3 hypothèses à sélectionner)
- Event saisonnier ou opportunité Radar

## Entrées requises
- Signal source (ID + contexte)
- Matrice persona × angle × format (pour vérifier non-doublon)
- Learnings encodés
- Registre hypothèses existantes

## Étapes

1. **Reformuler le signal** en problème testable :
   - "Atlas observe X, on pense que Y, on veut tester Z"

2. **Vérifier non-doublon** :
   - Cette combinaison persona × angle × format a-t-elle été testée ?
   - Si INVALIDE encodé → refuser (règle Coudac : jamais retester à l'identique)
   - Si VALIDE : c'est une itération, pas une hypothèse

3. **Format hypothèse standard** :
   ```markdown
   ### HYP-YYYY-WXX-NN

   - **Signal source** : [ID + source + date]
   - **Persona** : Marie / Julien / Christiane
   - **Angle** : [1 des 6]
   - **Format** : image / carousel (pas de vidéo)
   - **Hypothèse** : "Si on teste [X], alors le CPA baissera de Y% car [rationnel]"
   - **Preuve préalable** : [benchmark concurrent / learning adjacent / data Atlas]
   - **Critères succès** :
     - Primaire : CPA < XX€ sur 5-7j
     - Secondaire : ATC > YY, frequency < 2,5
   - **Critères échec net** : >50€ dépensés ET 0 achat ET 0 ATC
   - **Budget alloué** : X€
   - **Durée prévue** : 5-7j (min), 14j (max)
   - **ICE** : Impact XX / Confiance XX / Effort XX = Score XX
   - **Statut** : EN_ATTENTE
   ```

4. **Enregistrer** dans registre hypothèses

5. **Décision inclusion** dans plan hebdo : top ICE de la semaine

## Sortie
- Ajout au registre hypothèses
- Si sélectionnée : brief Forge + instruction Atlas
- Log `team-workspace/marketing/strategie/hypotheses/HYP-YYYY-WXX-NN.md`

## Règles strictes
- **1 variable par test** (sauf combinaison jamais testée)
- **Métrique primaire = CPA** (pas ROAS)
- **Min 50€, 5-7j** (sinon test invalide)
- **Hypothèse porte sur CREATIVE** pas sur ciblage (règle Coudac #1)
- **Rationale obligatoire** : "pourquoi cette hypothèse ?" — si pas de rationale, pas de test

## References
- Testing framework : `team-workspace/marketing/references/testing-framework.md`
- Matrice P×A×F : `team-workspace/marketing/references/matrice-persona-angle-format.md`
- Learnings : `team-workspace/marketing/references/learnings-creatifs.md`
- Scoring : `team-workspace/marketing/references/scoring-insights-paid.md`
