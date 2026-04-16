# Les 12 Regles Coudac -- Version Detaillee

> Reference operationnelle pour Univile. Ces regles constituent l'ADN du Paid Media chez Coudac et sont encodees dans le SOUL Atlas (operationnel) + SOUL Stratege (strategique). Chaque regle est developpee avec : principe, pourquoi, exemples Univile concrets, anti-patterns, application pratique.

**Source** : Methodologie Coudac adaptee au contexte Univile (e-commerce POD, catalogue 163 designs, budget ~1 800 EUR/mois Meta Ads, 3 personas).

---

## TABLE DES MATIERES

1. [La creative = le ciblage](#1--la-creative--le-ciblage)
2. [MER et COS priment sur ROAS](#2--mer-et-cos-priment-sur-roas)
3. [Kill rule : ~1,8x CPA sans conversion](#3--kill-rule--18x-cpa-sans-conversion)
4. [Scaling : +20% max par jour](#4--scaling--20-max-par-jour)
5. [Frequence max : 3](#5--frequence-max--3)
6. [Laisser tourner 5-7 jours](#6--laisser-tourner-5-7-jours)
7. [Retargeting = tonneau perce](#7--retargeting--tonneau-perce)
8. [Hyperconsolidation des ad sets](#8--hyperconsolidation-des-ad-sets)
9. [Produit visible des la 1ere seconde](#9--produit-visible-des-la-1ere-seconde)
10. [Production creative continue](#10--production-creative-continue)
11. [Tester, mesurer, iterer](#11--tester-mesurer-iterer)
12. [Les donnees pilotent, pas l'intuition](#12--les-donnees-pilotent-pas-lintuition)

---

## 1 -- La creative = le ciblage

### Principe
En 2026, avec l'algorithme Meta Advantage+, ce n'est plus le ciblage qui trouve l'audience -- c'est la creative elle-meme. Une bonne creative trouve ses acheteurs. Une mauvaise creative, meme avec le meilleur ciblage, ne convertit pas.

### Pourquoi
- Meta dispose de plus de donnees de comportement que n'importe quel marketeur.
- L'algorithme apprend qui est susceptible d'acheter a partir des 3 premieres secondes de visionnage + du pattern de clics.
- Les audiences LAL et Broad se comportent differemment selon le hook visuel, pas selon les parametres de ciblage.

### Exemples Univile concrets
- **Breaking News Eruption** (ROAS 23,5x) a performe en Broad *et* LAL -- la creative a fait le tri elle-meme.
- **Carrousel Avant/Apres Sacre-Coeur** pour Julien : le format fait venir les proprietaires deco-soignes meme sans interet-cible precis.
- La **Video brand content Univile** (231 EUR depenses, 0 achat) avait pourtant le "bon" ciblage Reunionnais diaspora -- mais la creative ne vendait rien.

### Anti-patterns a eviter
- Blamer le ciblage quand une creative ne performe pas ("on va changer les audiences"). Non : la creative est le probleme.
- Tester plusieurs audiences pour une meme creative mediocre.
- Creer une creative generique en esperant que le ciblage fera le travail.

### Application pratique (Stratege)
- Les hypotheses portent sur la **creative** (format, hook, angle, produit, copy), pas sur les parametres de ciblage.
- Pour un meme persona cible, on teste differentes creatives -- pas differents interets.
- Quand un persona ne convertit pas (ex : Julien), la question est : "quelle creative le convertirait ?" pas "quel LAL 2% cibler ?".

---

## 2 -- MER et COS priment sur ROAS

### Principe
- **ROAS (Return on Ad Spend)** = revenus attribues / depense ads. Biaise par la valeur de commande et par l'attribution Meta.
- **MER (Marketing Efficiency Ratio)** = CA total / depense ads total. La verite globale de l'efficacite marketing.
- **COS (Cost of Sale)** = depense ads / CA total. Inverse du MER, exprime en %.

### Pourquoi
- Le ROAS Meta sur-attribue (view-through, cross-device, fenetres longues).
- Le MER traduit ce que voit le comptable : "combien on encaisse vs combien on depense".
- En arbitrant entre creatives, ROAS comparatif est utile. Pour piloter un business, MER est la reference.

### Exemples Univile concrets
- ROAS global hors eruption : 2,62x. MER reel : ~2,1x (l'ecart de 20% entre ROAS Atlas et MER comptable est un signal de sur-attribution).
- Breakeven ROAS Univile : 1,55x. En dessous, on perd de l'argent.
- Semaine eruption : ROAS 7,91x, mais MER mensuel n'a monte que de 4,5x a 5,8x (lift ponctuel).

### Anti-patterns a eviter
- Celebrer un ROAS 8x sans verifier le MER.
- Comparer le ROAS Meta au ROAS Google sans normaliser (attribution differente).
- Prendre une decision budgetaire > 30% sur la base du ROAS seul.

### Application pratique
- **Metrique primaire du Stratege** : CPA (car comparable entre creatives).
- **Metrique primaire business** : MER (reference mensuelle Marty).
- **Alerte rouge** : ecart > 20% entre ROAS Atlas et MER comptable -> investiguer avec Nexus avant toute decision.

---

## 3 -- Kill rule : ~1,8x CPA sans conversion

### Principe
Si une creative a depense 1,8x le CPA cible sans generer 1 seul achat, elle est killee. Chez Univile : **CPA cible 28 EUR -> kill a ~50 EUR depenses sans achat**.

### Pourquoi
- Statistiquement, si aucune conversion apres 1,8x le CPA cible, la probabilite d'en avoir ensuite est < 10%.
- Chaque euro depense au-dela est brule -- il vaut mieux le redeployer sur une autre hypothese.
- La kill rule est binaire : elle evite les decisions emotionnelles ("encore un petit effort...").

### Exemples Univile concrets
- **Video brand content** (Flop A1) : 231 EUR depenses, 0 achat. Aurait du etre killee a 50 EUR. L'ecart : 181 EUR brules.
- **Carrousel narratif abstrait** (Flop A2) : 127 EUR, 0 achat. Killee trop tard.
- Sur la periode analysee : **516 EUR (28% du budget) brules sur 4 creatives** -- toutes auraient du etre killees plus tot.

### Anti-patterns a eviter
- Prolonger "parce que le CTR est bon" -> le CTR sans achat = piege a clics.
- Prolonger "parce qu'on y croit" -> decision emotionnelle.
- Kill trop tot a 30 EUR sans achat (manque de donnees pour conclure).

### Application pratique
- **Budget minimum par test = 50 EUR** (ou 2x CPA cible). En dessous, pas assez de donnees pour conclure.
- **Exception zone grise ATC sans achat** : ATC > 0 apres 50 EUR -> prolonger 3 jours max, investiguer post-clic avec Nexus.
- **Executant : Atlas** applique la kill rule. **Stratege** encode le learning apres kill.

---

## 4 -- Scaling : +20% max par jour

### Principe
Quand un winner est identifie, le budget de son ad set augmente de **+20% maximum** par palier. Chaque palier doit etre stabilise **5 jours** avant la hausse suivante.

### Pourquoi
- L'algorithme Meta re-apprend a chaque changement budgetaire. Un +50% d'un coup casse les phases d'apprentissage.
- +20% laisse l'algorithme ajuster la distribution sans perdre la performance.
- 5 jours = duree minimum pour valider qu'un palier tient avant de monter.

### Exemples Univile concrets
Paliers concrets depuis le budget actuel (50 EUR/jour de base, hors test) :
- **Palier 0** : 50 EUR/jour (budget actuel base)
- **Palier 1 (J+1)** : 60 EUR/jour (+20%)
- **Palier 2 (J+6)** : 72 EUR/jour (+20%)
- **Palier 3 (J+11)** : 86 EUR/jour (+20%)
- **Palier 4 (J+16)** : 103 EUR/jour (+20% -- depasse le plafond, validation Marty obligatoire)

### Anti-patterns a eviter
- Doubler le budget d'un jour a l'autre parce que "ca marche". Destruction de la phase d'apprentissage garantie.
- Augmenter le budget d'un ad set qui vient de rentrer dans un winner -- attendre validation a 5j.
- Cumuler plusieurs +20% dans la meme semaine.

### Application pratique
- **Declenchement du scaling** : winner confirme (ROAS > 5x apres 5j, > 30 EUR depenses, >= 2 achats).
- **Validation Marty obligatoire** pour chaque palier (le Stratege recommande, Marty decide).
- **Stop automatique** : si ROAS < 2x ou CPA > 35 EUR a un palier -> retour au palier precedent.

---

## 5 -- Frequence max : 3

### Principe
Quand la frequence d'une creative depasse 3 (meme personne voit la pub 3+ fois en 7j), elle est rafraichie. Au-dela, elle brule l'audience.

### Pourquoi
- Frequence 1-2 : decouverte, bon CTR.
- Frequence 2-3 : consideration, conversions.
- Frequence > 3 : lassitude, CPM monte, CPA explose, commentaires negatifs possibles.
- Signal Univile : **Frequence B3 actuelle = 3,69 (ETAT CRITIQUE)**.

### Exemples Univile concrets
- Le workhorse Statique Mockup Reunion a une frequence 3,69 -> le CPA a augmente de 22 EUR a 41 EUR sur les 4 dernieres semaines.
- Le Breaking News Eruption a tenu 5 jours avant d'atteindre freq 3 (erosion L7).
- Les carrousels Avant/Apres tiennent 2-4 semaines avant de depasser 3.

### Anti-patterns a eviter
- Laisser tourner une creative "parce qu'elle marche" meme a freq 4+. Les derniers achats coutent tres cher.
- Attendre freq 3 pour briefer Forge -- trop tard, il faut la variante avant.

### Application pratique
- **Anticiper** : des freq 2,5, briefer Forge pour une variante.
- **Breaking News** : erosion rapide, V2 pret avant J3 (regle non-negociable n6).
- **Workhorse (Statique/Carrousel)** : variante dans les 48h apres detection de freq 2,5.

---

## 6 -- Laisser tourner 5-7 jours

### Principe
**Aucune hypothese ne peut etre conclue avant 5 jours.** L'algorithme Meta a besoin de 5-7 jours pour sortir de la phase d'apprentissage et stabiliser la distribution.

### Pourquoi
- Jours 1-2 : Meta explore. CPM et CPA volatils, pas representatifs.
- Jours 3-4 : stabilisation partielle.
- Jours 5-7 : donnees fiables pour conclure.
- Au-dela de 14 jours : le contexte change (weekend, evenements), les donnees ne sont plus comparables.

### Exemples Univile concrets
- Breaking News Eruption (ROAS 23,5x confirme a J7) avait un ROAS "affole" 42x a J1 -- impossible a conclure a J1.
- Flash Info Sakura n'a genere ses 2 achats qu'a J4 -> conclu a J5.
- A l'inverse, la Video brand content n'a jamais converti -- a J5, 0 achat + depense 50 EUR = kill net.

### Anti-patterns a eviter
- Killer a J2 parce que "0 achat encore". Trop tot, pas assez de donnees.
- Scaler a J2 parce que "ROAS 12x". Volatilite, pas significatif.
- Conclure a J10+ sans prolongation justifiee.

### Application pratique
- **Duree minimum par test : 5-7 jours.**
- **Duree maximum avant conclusion : 14 jours.**
- **Seuil de conclusion : 50 EUR depenses ET 2 achats minimum pour validation.**
- **Grace period scaling horizontal** : 5 jours dans le nouvel ad set avant application kill rule.

---

## 7 -- Retargeting = tonneau perce

### Principe
Chez Univile, le retargeting a ete TESTE et INVALIDE. Decision Coudac : **budget retargeting = 0 EUR**. Les 157 EUR depenses sur DPA ont produit 0 conversion additionnelle.

### Pourquoi
- Le catalogue Univile (163 designs) n'est pas un catalogue DPA classique (ecommerce generaliste).
- Le cycle de decision est court : visite -> achat dans la meme journee souvent.
- Les viewers qui n'achetent pas le jour J n'achetent pas plus en retargeting.
- Meta Advantage+ inclut deja un retargeting implicite dans les campagnes conversion.

### Exemples Univile concrets
- **Flop C1** : DPA retargeting, 157 EUR, 0 achat.
- Le funnel Univile est SAIN (VC->ATC 11,63%, API->Purchase 91,38%) -- le probleme n'est pas post-visite mais creative.
- Les conversions additionnelles viennent de nouvelles creatives, pas de relance sur les viewers.

### Anti-patterns a eviter
- Proposer "on relance les viewers avec une promo" -> non, tonneau perce.
- Proposer "retargeting ATC sans achat" -> Meta Advantage+ le fait deja.
- Proposer "abandoner cart email + retargeting" -> Keeper (email) suffit, pas besoin de budget ads.

### Application pratique
- **Pas d'hypothese retargeting a ce stade** (regle non-negociable).
- **Si besoin de relancer** : passer par Keeper (email lifecycle) plutot que par le paid.
- **Exception future possible** : si le catalogue grandit (500+ designs) et que le cycle se rallonge.

---

## 8 -- Hyperconsolidation des ad sets

### Principe
**Maximum 3 ad sets** dans le compte Meta (A Broad, B LAL, C Test). Pas de multiplication d'ad sets par persona, par lieu, par audience.

### Pourquoi
- Chaque ad set a besoin de 50+ conversions/semaine pour sortir de la phase d'apprentissage.
- Budget Univile (60 EUR/jour) divise sur 6 ad sets = famine garantie.
- Meta Advantage+ preconise la consolidation maximale : laisser l'algo distribuer.

### Exemples Univile concrets
Structure cible Univile :
- **Ad Set A -- Broad** : 60-70% du budget (36-42 EUR/j), conversion, audience large.
- **Ad Set B -- LAL/Interets** : 20-30% (12-18 EUR/j), Look-alike acheteurs, LAL visiteurs, interets diaspora.
- **Ad Set C -- Test** : 10% (6 EUR/j), terrain d'essai pour nouvelles hypotheses.
- **Ad Set D (occasionnel)** : ad set special pour event imprevisible (eruption) -- 50-100 EUR, limite dans le temps.

### Anti-patterns a eviter
- Creer un ad set par persona (Marie/Julien/Christiane) -> famine.
- Creer un ad set par pays (France/Reunion/Maurice) -> Meta fait mieux le tri.
- Creer un ad set par lieu ou par format -> explosion de la complexite, dilution du signal.

### Application pratique
- **Toute creation d'ad set necessite validation Marty** (changement de structure).
- **Les hypotheses passent par C (Test)**, puis promues en A ou B en cas de validation.
- **Ad set D** uniquement pour event urgent (< 6h de reactivite), en accord avec Marty.

---

## 9 -- Produit visible des la 1ere seconde

### Principe
Toute creative (image ou video) doit montrer le **produit Univile** (une affiche accrochee, cadree, visible) **des la 1ere seconde**. Pas de "buildup", pas de teasing, pas d'emotion abstraite avant.

### Pourquoi
- Le scroll Meta dure 1,5 seconde par creative.
- Si le produit n'est pas visible, l'utilisateur scrolle sans comprendre ce qu'on vend.
- L'emotion doit accompagner le produit, pas le precede.

### Exemples Univile concrets
- **B2 Carrousel Avant/Apres** (ROAS 69x) : slide 1 montre le mur + l'affiche. Produit visible immediatement.
- **Breaking News Eruption** (ROAS 23,5x) : bandeau rouge + produit affiche + ticker. 1 seconde = tout comprendre.
- **A1 Video brand content** (0 achat) : 5 premieres secondes d'emotion sans produit visible. Scroll garanti.

### Anti-patterns a eviter
- Ouvrir une video sur un paysage sans affiche.
- Carrousel avec 1ere slide "lifestyle abstrait", 2eme slide le produit.
- Creative avec le produit "suggere" mais pas cadre.

### Application pratique
- **Briefs Forge** contiennent la contrainte explicite : "produit visible des la 1ere seconde".
- **QC Forge** rejette toute creative ou le produit n'apparait qu'apres 1 seconde.
- **Prix mentionne** (quand applicable) dans la premiere zone visible de l'image.

---

## 10 -- Production creative continue

### Principe
**3-5 nouvelles creatives par semaine**, pas un gros batch de 20 tous les 2 mois. Le pipeline creatif est une riviere, pas un reservoir.

### Pourquoi
- Un gros batch -> l'algorithme est noye, les creatives se cannibalisent.
- Des livraisons regulieres -> Meta peut evaluer chaque creative distinctement.
- La saisonnalite et les events exigent une capacite de reaction continue (pas d'accumulation).

### Exemples Univile concrets
- Rythme cible : **2-5 creatives/semaine Forge**, dont 1 URGENT occasionnelle (event).
- Periode haute (pre-saison Fete des Meres, Black Friday) : 4-5 creatives/semaine.
- Periode normale : 2-3 creatives/semaine.

### Anti-patterns a eviter
- "On fait 20 creatives pour Noel en septembre" -> toutes dans le pipeline d'un coup, chaos algorithmique.
- "On attend la fin du sprint creatif pour lancer" -> le test continue est bloque.
- "On sature Forge avec 10 briefs d'un coup" -> Forge bloque, delais exploses.

### Application pratique
- **Stratege planifie** les briefs en flux continu (pas de bursts).
- **Forge a un pipeline de 3 creatives en tampon** en permanence.
- **Briefs d'avance** : quand un winner est identifie, 2-3 variantes dans les 48h (avant erosion).

---

## 11 -- Tester, mesurer, iterer

### Principe
L'ADN meme du Stratege. **Chaque euro depense doit produire un learning.** Tout, absolument tout, passe par le cycle Hypothese -> Test -> Mesure -> Iteration.

### Pourquoi
- Sans framework de test, le succes est accidentel.
- Sans mesure, on ne sait pas pourquoi ca a marche (impossible a reproduire).
- Sans iteration, on refait les memes erreurs.

### Exemples Univile concrets
- **Succes reproductible** : Breaking News Eruption (ROAS 23,5x) a ete methodise -> framework Breaking News applicable a tout event (Grand Raid, Fete Cafre, eruption future).
- **Echec avec learning** : Video brand content (0 achat, 231 EUR) -> learning "Pas de video narrative brand", encode dans les combinaisons INTERDITES.
- **Echec sans learning** (anti-pattern historique) : 4 tests Julien en famine (0 vente), JAMAIS validated ni invalides -> a refaire avec methodologie.

### Anti-patterns a eviter
- Lancer une creative sans hypothese formelle.
- Conclure "ca n'a pas marche" sans identifier la cause.
- Retester exactement la meme chose en esperant un resultat different.

### Application pratique
- **Chaque brief Forge** = 1 hypothese formulee au format HYP-YYYY-Wxx-NN.
- **Chaque test** a un seuil de validation ET un seuil d'echec pre-definis.
- **Chaque conclusion** encode un learning dans le registre `/_strategie/registre-hypotheses.md`.

---

## 12 -- Les donnees pilotent, pas l'intuition

### Principe
**"Je pense que"** est toujours suivi de **"testons pour verifier"**. Aucune decision sur le sentiment.

### Pourquoi
- L'intuition est biaisee par les derniers signaux (recency bias).
- Les intuitions d'une equipe sont souvent contradictoires -> donnees = arbitre.
- Les donnees echouent parfois, l'intuition echoue plus souvent.

### Exemples Univile concrets
- Intuition : "les videos fonctionnent mieux". Donnee : les videos ont 0 achat chez Univile sur 231 EUR -> Interdit.
- Intuition : "on devrait multiplier les ad sets pour mieux cibler". Donnee : hyperconsolidation = meilleurs resultats (regle 8).
- Intuition : "Julien n'est pas le bon persona". Donnee : Julien n'a JAMAIS ete teste correctement (4 tests en famine).

### Anti-patterns a eviter
- "Mon instinct me dit que..." sans donnees pour etayer.
- Rejeter une donnee parce qu'elle contredit l'intuition.
- Prendre une decision budgetaire > 10% sans donnees alignees.

### Application pratique
- **Toute recommandation Marty** inclut les donnees factuelles (format fixe : Situation -> Donnees -> Recommandation -> Impact attendu).
- **Priorite aux chiffres Atlas** en cas de conflit avec l'intuition.
- **Registre d'hypotheses** = memoire objective du systeme (anti-biais recency).

---

## SYNTHESE : tableau de reference rapide

| # | Regle | Seuil Univile | Executant | Frequence d'application |
|---|-------|---------------|-----------|------------------------|
| 1 | Creative = ciblage | Hypotheses portent sur creative | Stratege | Permanent |
| 2 | MER > ROAS | Ecart > 20% = alerte | Stratege + Marty | Mensuel |
| 3 | Kill 1,8x CPA | ~50 EUR sans achat | Atlas | Quotidien |
| 4 | Scaling +20%/j | 5j entre paliers | Stratege + Marty | Ad hoc |
| 5 | Freq max 3 | Action des 2,5 | Stratege + Forge | Hebdo |
| 6 | 5-7j test | Min 5j, max 14j | Atlas + Stratege | Chaque test |
| 7 | Pas de retargeting | Budget = 0 EUR | Stratege | Permanent |
| 8 | Max 3 ad sets | A/B/C (+D event) | Stratege + Marty | Permanent |
| 9 | Produit 1ere seconde | Contrainte brief | Forge | Chaque creative |
| 10 | Production continue | 3-5 creatives/sem | Stratege + Forge | Hebdo |
| 11 | Tester-mesurer-iterer | HYP-YYYY-Wxx-NN | Stratege | Permanent |
| 12 | Donnees priment | Pas d'intuition | Stratege + Marty | Permanent |

---

## REFERENCES CROISEES

- **Testing framework detaille** : `/team-workspace/marketing/references/testing-framework.md`
- **Scaling framework detaille** : `/team-workspace/marketing/references/scaling-framework.md`
- **Allocation budgetaire** : `/team-workspace/marketing/references/allocation-budgetaire.md`
- **Registre des hypotheses** : `/team-workspace/marketing/_strategie/registre-hypotheses.md`
- **Context Univile complet** : `/team-workspace/marketing/references/univile-context.md` (section 8 = resume de ces regles)
