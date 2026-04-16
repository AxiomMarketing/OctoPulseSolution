---
name: stratege:brief-forge
description: Rédiger brief vers Forge au format BRF-YYYY-WXX-NN — hypothèse + persona + format + angle + contraintes + deadline.
---

# Brief Forge

## Quand l'utiliser
- Chaque hypothèse sélectionnée dans plan hebdo nécessite 1 brief Forge
- Variante d'un winner (scaling → production variantes)
- Réaction event Radar (brief express)

## Entrées requises
- Hypothèse formalisée (HYP-YYYY-WXX-NN)
- Persona, angle, format cibles
- Contraintes charte

## Format

```markdown
# BRF-YYYY-WXX-NN — [titre court]

## Hypothèse testée
Ref : HYP-YYYY-WXX-NN
"Si [action], alors [résultat] car [rationnel]"

## Persona cible
- [Marie / Julien / Christiane]
- Niveau connaissance Univile : [découverte / considération / conversion]
- Bénéfice mis en avant : [...]

## Angle
- [1 des 6 angles]
- Tonalité : [émotion / rationnel / urgence / communauté / héritage / ...]

## Format
- [image / carousel]
- **Pas de vidéo** (phase actuelle)
- Ad format Meta : feed / story / reel (organique uniquement)

## Contraintes charte
- Palette : #001f4d / #c75146 / #2E6B4F / blanc galerie
- Pas de cadre rouge/doré
- Produit visible première seconde
- Mobile first

## Contraintes copy
- Primary text ≤ 125 chars
- Hook percutant ≤ 40 chars
- CTA unique et clair

## Ad set cible
- [A Broad / B LAL / C Test]
- Budget alloué : X€/j
- Durée prévue : X jours

## Deadline livraison
- J+3 max (target)
- Hard limit J+5

## Variantes requises
- V2 hook ready (rotation frequency)
- V2 visuel ready

## References croisées
- Learning similaire : L[X]
- Concurrent benchmark : [URL si applicable]
- Winner organique source : [si réutilisation]
```

## Étapes

1. **Composer** le brief selon template ci-dessus
2. **Générer ID** : BRF-YYYY-WXX-NN (NN = numéro séquentiel semaine)
3. **Sauvegarder** : `team-workspace/marketing/briefs/inbox/BRF-YYYY-WXX-NN.md`
4. **Envoyer** : SendMessage → Forge avec contenu du brief
5. **CC Sparky** : 2-3 lignes (ID + hypothèse + deadline)

## Règles strictes
- **Hypothèse obligatoire** (pas de brief générique "fais-moi une belle créa")
- **1 brief = 1 hypothèse**
- **Pas de vidéo** (phase actuelle)
- **Deadline réaliste** : minimum 48h pour Forge
- **Clarifications < 4h** si Forge remonte ambiguïté

## References
- Format détaillé : `.claude/shared/output-formats.md` section 2
- Matrice P×A×F : `team-workspace/marketing/references/matrice-persona-angle-format.md`
- Formats créatives : `team-workspace/marketing/references/formats-creatives-details.md`
- Coudac : `team-workspace/marketing/references/coudac-12-regles-details.md`
