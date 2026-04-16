---
name: nexus:landing-optimization
description: Optimisation landing pages produit — par persona (Marie émotion / Julien rationnel / Christiane premium), au-dessus fold, social proof, mobile first.
---

# Landing Optimization

## Quand l'utiliser
- Préparation landing page pour nouveau produit Printful
- Diagnostic d'une landing sous-performante (Atlas CPA élevé, Nexus drop-off)
- Refonte saisonnière (Fête des Mères collection)

## Entrées requises
- Audit tunnel récent (`nexus:tunnel-audit`)
- Persona cible (Marie / Julien / Christiane)
- Produit + assets Printful
- Competitors benchmark

## Structure landing optimisée

### Au-dessus du fold (critique mobile)

1. **Visuel produit** (hero)
   - Produit visible 1ère seconde
   - Mockup contextuel (affiche dans un intérieur)
   - Pas de cadre rouge/doré (charte)

2. **Titre H1**
   - ≤ 60 chars
   - Bénéfice + destination (ex. "Offrez un morceau de Réunion")
   - Tutoiement B2C

3. **Prix + frais livraison visibles**
   - Transparence immédiate (clé CRO Univile)
   - Frais port géo-adaptés (Réunion vs métropole)

4. **CTA primaire**
   - Couleur contrastée palette Univile
   - Wording action (pas "Acheter" — "Je l'offre", "Je choisis")
   - Au-dessus fold

### En-dessous du fold

5. **Social proof immédiate**
   - Reviews clients (3-5 avec photos produit)
   - Nombre clients ("Déjà X Réunionnais nous font confiance")

6. **Variantes par persona** (section adaptable)
   - **Marie** : photos lifestyle, émotion, storytelling "offrir"
   - **Julien** : specs produit, qualité, matériaux, provenance
   - **Christiane** : héritage, collection, produit artisanal authentique

7. **Garanties & confiance**
   - Livraison Printful transparente (délai estimé par géo)
   - Satisfait ou remboursé 30j
   - Paiement sécurisé

8. **FAQ rapide** (accordéon)
   - Délais livraison
   - Formats disponibles
   - Matériaux
   - Retours

9. **CTA secondaire** (répété en bas)

### Mobile-first (97% trafic)

- Poids total < 1,5 MB
- LCP < 2,5s
- Images WebP
- Font loading optimisé
- Pas de popup intrusif
- Sticky bar CTA scroll long
- Bottom sheet pour variantes (pas de dropdown classique)

## Étapes

1. **Analyser landing actuelle** (audit rapide)
2. **Identifier persona dominant** par source trafic
3. **Lister améliorations** scorer ICE
4. **Proposer 3-5 quick wins** (< 1 semaine)
5. **Proposer test A/B** si changement majeur (`nexus:ab-test-plan`)
6. **Livrer brief dev/CMS** avec mockups
7. **Mesurer post-déploiement** (CVR, AOV, time-on-page)

## Sortie
- `team-workspace/marketing/nexus/landings/LND-[produit]-YYYY-MM.md`
- Brief dev/CMS
- Plan test A/B si applicable
- Validation charte Marty pour éléments nouveaux

## Règles strictes
- **Mobile-first non négociable** (97% trafic)
- **Charte Univile stricte** : palette, tutoiement B2C, vocabulaire "affiche" / "art mural"
- **Validation Marty** si changement identité (tone, visuel hero)
- **Pas de friction artificielle** (popup exit-intent OK, popup d'entrée NON)
- **Social proof réel** (jamais faux reviews)
- **Transparence frais port** dès le hero (friction Univile classique)

## References
- Audit : `nexus:tunnel-audit`
- CRO : `nexus:cro-testing`
- Personas : `team-workspace/marketing/references/personas-details.md`
- Destinations : `team-workspace/marketing/references/destinations-univile.md`
- Ref : `team-workspace/marketing/references/nexus-tunnel-audit.md`
