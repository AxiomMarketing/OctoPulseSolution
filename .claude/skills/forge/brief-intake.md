---
name: forge:brief-intake
description: Réception et parsing d'un brief Stratege BRF-YYYY-WXX-NN — validation cohérence learnings, ventilation vers sub-agents.
---

# Brief Intake

## Quand l'utiliser
- Réception d'un brief Stratege (SendMessage)
- Avant d'engager la production créative

## Entrées requises
- Brief Stratege au format `BRF-YYYY-WXX-NN` (voir `.claude/shared/output-formats.md` section 2)
- Learnings encodés (`learnings-creatifs.md`)
- Matrice Persona × Angle × Format (`matrice-persona-angle-format.md`)

## Étapes

1. **Parser** le brief :
   - Hypothèse testée
   - Persona cible (Marie / Julien / Christiane)
   - Angle (1 des 6)
   - Format (image / carousel — pas de vidéo en phase actuelle)
   - Contraintes spécifiques
   - Deadline

2. **Validation learnings** :
   - Cette combinaison persona × angle × format a-t-elle déjà été testée ?
   - Si INVALIDE déjà encodé → BLOCKER, renvoyer à Stratege pour reformulation
   - Si VALIDE déjà : confirmer intention d'itérer (variante)
   - Si INCONCLUSIF : OK avec note

3. **Validation charte** :
   - Aucun cadre rouge/doré (règle anti-drift)
   - Produit visible première seconde (règle Coudac #9)
   - Conformité ton Univile

4. **Ventilation sub-agents** :
   - **forge-strategist** : concept + moodboard (48h avant le reste)
   - **forge-art-director** : visuel (24h après concept)
   - **forge-copywriter** : hooks + primary text + CTA (en parallèle de l'art-director)
   - **forge-qc** : validation finale (après art+copy)

5. **Planning** : timings + jalons + deadline finale

6. **Clarifications** : si ambiguïté dans le brief, question à Stratege AVANT de lancer (éviter waste)

## Sortie
- Fichier `team-workspace/marketing/forge/briefs-accepted/BRF-YYYY-WXX-NN.md`
- Messages aux 4 sub-agents avec leur scope
- CC Sparky (2 lignes : brief accepté + deadline)

## Règles strictes
- **Jamais accepter** un brief contre les learnings sans escalade Stratege
- **Jamais lancer production** sans validation learnings + charte
- **Un brief = une hypothèse** (pas de mélange)
- **Questions < 4h après réception** du brief si ambiguïté

## References
- Output format brief : `.claude/shared/output-formats.md` section 2
- 12 règles Coudac : `team-workspace/marketing/references/coudac-12-regles-details.md`
- Learnings : `team-workspace/marketing/references/learnings-creatifs.md`
- Sub-agents : `.claude/agents/subs/forge-strategist.md`, `forge-art-director.md`, `forge-copywriter.md`, `forge-qc.md`
