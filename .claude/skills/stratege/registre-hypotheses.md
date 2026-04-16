---
name: stratege:registre-hypotheses
description: Maintenance du registre hypothèses — création EN_ATTENTE, lancement EN_TEST, conclusion VALIDE/INVALIDE/INCONCLUSIF, encodage learning.
---

# Registre Hypothèses — Source de vérité

## Quand l'utiliser
- Création d'une nouvelle hypothèse (`stratege:generer-hypothese`)
- Lancement d'un test (instruction Atlas envoyée)
- Conclusion d'un test (après 5-14j)
- Query pour éviter doublons

## Fichier unique
`team-workspace/marketing/strategie/registre-hypotheses.md`

## Format registre

```markdown
# Registre Hypothèses — Univile Paid

## Légende statuts
- EN_ATTENTE : créée, pas encore testée
- EN_TEST : lancée, en cours de collecte data
- VALIDE : critères succès atteints, learning encodé
- INVALIDE : critères échec atteints (>50€, 0 achat, 0 ATC), learning encodé
- INCONCLUSIF : data insuffisante, kill ou relancer selon signal

## Index actif

| ID | Titre | Persona | Angle | Format | Statut | Date création | Date fin | CPA | Learning |
|----|-------|---------|-------|--------|--------|---------------|----------|-----|----------|
| HYP-2026-W15-01 | Angle Transformation Marie | Marie | Transformation | Carousel | EN_TEST | 2026-04-14 | — | — | — |
| HYP-2026-W14-03 | Diaspora LAL 2% | — | Héritage | Image | VALIDE | 2026-04-07 | 2026-04-14 | 14€ | L11 |
| ... |

## Archive (>6 mois)
[lien fichier archive par année]
```

## Étapes

### Créer une hypothèse
1. Générer via `stratege:generer-hypothese`
2. Ajouter ligne au registre : statut EN_ATTENTE
3. ID format : HYP-YYYY-WXX-NN

### Lancer un test
1. Instruction Atlas envoyée
2. Update ligne : statut EN_TEST, date lancement
3. Ajouter BRF ID + INS ID en liens

### Conclure un test (5-14j plus tard)
1. Analyser data Atlas sur durée test
2. Appliquer critères succès/échec définis à la création
3. Verdict :
   - **VALIDE** : critères succès atteints → encoder learning, continuer scaling via `stratege:scaling-decision`
   - **INVALIDE** : critères échec atteints (>50€, 0 achat, 0 ATC) → encoder learning, NE JAMAIS RETESTER À L'IDENTIQUE
   - **INCONCLUSIF** : data insuffisante (<5 achats ET dans budget) → décider relance ou kill définitif
4. Update registre : statut + CPA final + learning ID
5. Si learning nouveau : ajouter à `learnings-creatifs.md` (L11+)

### Query avant nouvelle hypothèse
1. Rechercher dans registre la combinaison persona × angle × format
2. Si VALIDE → c'est une itération, pas une hypothèse
3. Si INVALIDE → refuser nouvelle hypothèse à l'identique (règle Coudac)
4. Si INCONCLUSIF → OK avec note "retest avec ajustement"

## Sortie
- Registre à jour (fichier unique maintenu)
- Cross-ref avec `learnings-creatifs.md`
- Rapport mensuel basé sur registre (`stratege:bilan-mensuel`)

## Règles strictes
- **Source de vérité unique** : pas de duplication ailleurs
- **Update dans l'heure** après décision (sinon perte)
- **JAMAIS retester à l'identique** un INVALIDE (règle Coudac)
- **Learning obligatoire** sur VALIDE et INVALIDE (pas seulement VALIDE)
- **Archive annuelle** : >6 mois = fichier archive séparé

## References
- Générateur : `stratege:generer-hypothese`
- Learnings : `team-workspace/marketing/references/learnings-creatifs.md`
- Bilan : `stratege:bilan-mensuel`
- Testing : `team-workspace/marketing/references/testing-framework.md`
