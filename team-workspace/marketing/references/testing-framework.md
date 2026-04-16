# Testing Framework -- Paid Media Univile

> Reference operationnelle du cycle de test en paid media. Tout test commence par une hypothese formalisee, se mesure sur 5-7 jours minimum avec 50 EUR budget minimum, et se conclut par un learning encode dans le registre. **Kill rule : ~1,8x CPA sans conversion.**

**Contexte Univile** : CPA cible 28 EUR, breakeven ROAS 1,55x, budget test C ~6 EUR/j (~180 EUR/mois), structure A/B/C hyperconsolidee.

---

## TABLE DES MATIERES

1. [Qu'est-ce qu'une hypothese](#1-quest-ce-quune-hypothese)
2. [Format standard d'une hypothese](#2-format-standard-dune-hypothese)
3. [Les 10 variables testables](#3-les-10-variables-testables)
4. [La regle d'or : 1 variable par test](#4-la-regle-dor--1-variable-par-test)
5. [Sources d'hypotheses](#5-sources-dhypotheses)
6. [Matrice ICE de priorisation](#6-matrice-ice-de-priorisation)
7. [Budget et duree minimum par test](#7-budget-et-duree-minimum-par-test)
8. [Metriques : primaire CPA, secondaires CTR/ATC/Freq/CPM](#8-metriques--primaire-cpa-secondaires)
9. [Seuils de decision et arbre kill vs scale](#9-seuils-de-decision-et-arbre-kill-vs-scale)
10. [Structure des ad sets A/B/C](#10-structure-des-ad-sets-abc)
11. [Registre d'hypotheses : structure et statuts](#11-registre-dhypotheses)
12. [Cycles de test complets (exemples)](#12-cycles-de-test-complets-exemples)

---

## 1. Qu'est-ce qu'une hypothese

Une hypothese Stratege est une affirmation testable au format :

> **"Si [action/variable], alors [resultat attendu], car [raison factuelle basee sur les donnees]."**

Chaque hypothese :
- Porte sur UNE variable (voir regle d'or).
- A un seuil de validation ET un seuil d'echec pre-definis.
- Encode un learning meme si elle echoue.
- Est tracee dans le registre avec un ID unique HYP-YYYY-Wxx-NN.

---

## 2. Format standard d'une hypothese

### Template

```
ID : HYP-[ANNEE]-W[SEMAINE]-[NUMERO]
Hypothese : Si [action], alors [resultat attendu] car [raison]
Variable testee : [audience / angle creatif / hook visuel / format / placement / copy / landing page / timing / produit / prix]
Metrique cible : [CPA / CTR / ATC rate / conversion rate]
Seuil de validation : [metrique < X OU metrique > Y]
Seuil d'echec : [depense > X EUR ET 0 achat ET 0 ATC]
Budget test : [montant]
Duree minimum : [jours]
Ad set de destination : [C pour test / A ou B pour variante winner / D pour event]
Persona cible : [Marie / Julien / Christiane]
Format : [Breaking News / Carrousel AA / Statique Mockup / Flash Info / Carrousel Multi]
Brief Forge associe : [BRF-XXXX]
Learning encode si echec : [ce qu'on apprendra meme si ca rate]
```

### Exemple concret (Univile)

```
ID : HYP-2026-W14-01
Hypothese : Si on lance un carrousel Avant/Apres ciblant Julien avec des lieux France
    (Sacre-Coeur, Etretat) dans le Broad (A), alors on obtiendra un CPA < 35 EUR
    car le format Avant/Apres est le champion historique (ROAS 69x) mais n'a jamais
    ete teste avec les bons lieux et le bon ad set pour Julien.
Variable testee : Persona (Julien) x Format champion (AA) x Ad Set (Broad)
Metrique cible : CPA
Seuil de validation : CPA < 35 EUR ET au moins 2 achats en 7 jours
Seuil d'echec : Depense > 50 EUR ET 0 achat ET 0 ATC
Budget test : 50 EUR (7 jours x ~7 EUR/j en Ad Set C)
Duree minimum : 7 jours
Ad set de destination : C (test) puis promotion en A si validation
Persona cible : Julien
Format : Carrousel Avant/Apres
Brief Forge associe : BRF-2026-W14-01
Learning encode si echec : "Le format Avant/Apres ne fonctionne pas pour Julien
    sur les lieux France -- le probleme n'est pas le format mais le fit persona/lieu"
```

---

## 3. Les 10 variables testables

| Variable | Exemples | Impact attendu |
|----------|----------|---------------|
| **Audience** | Broad vs LAL, nouveau persona, exclusion segment | Qui recoit la pub |
| **Angle creatif** | Evenement, cadeau, transformation, nostalgie, saisonnier | Quelle emotion declenche l'achat |
| **Hook visuel** | Bandeau Breaking News, split avant/apres, mockup contextuel | Les 3 premieres secondes |
| **Format** | Breaking News, Carrousel AA, Statique, Flash Info, Multi-lieux | Le vehicule du message |
| **Placement** | Feed, Stories, Reels, Avantage+ | Ou la pub apparait |
| **Copy** | Hook texte, description, CTA | Les mots qui accompagnent |
| **Landing page** | Collection vs fiche produit vs page custom | Ou le clic atterrit |
| **Timing** | Jour de la semaine, heure, saison, event | Quand la pub est diffusee |
| **Produit** | Lieu specifique, gamme Original vs Edition, format affiche | Quoi est mis en avant |
| **Prix** | Mention prix vs pas de prix, "a partir de" vs prix exact | Qualification du trafic |

---

## 4. La regle d'or : 1 variable par test

**1 variable = 1 test.** Si on change 3 variables simultanement, on ne saura pas laquelle a cause le succes ou l'echec.

### Exception autorisee : combinaison totalement inedite

Quand une combinaison n'a **jamais** ete testee (ex : Breaking News x Julien x France), le test combinatoire est acceptable **car il n'y a aucune baseline a isoler**. Cas typiques Univile :
- Nouveau persona + format deja prouve ailleurs.
- Event imprevisible + creative d'urgence (< 6h).
- Combinaison persona x angle jamais explorees dans la matrice (ex : Christiane x Fete Cafre).

### Application pratique

- **Par defaut** : on isole 1 variable par rapport a une baseline existante.
- **Si combinatoire** : c'est notifie explicitement dans l'hypothese ("combinaison inedite").
- **Jamais** : changer 4 variables en disant "on va voir".

---

## 5. Sources d'hypotheses

Stratege ne "pense pas" a des hypotheses -- il les **genere a partir de sources factuelles**.

### Source 1 : Donnees Atlas (performance)

| Signal Atlas | Hypothese type |
|-------------|----------------|
| Creative avec ATC > 3 mais 0 achat | "Le probleme est post-ATC. Tester une landing page differente." |
| Ad Set A avec 0 conversion malgre budget | "Les creatives ne sont pas adaptees au Broad. Tester le format champion en Broad." |
| Frequence > 3 sur un workhorse | "L'audience est fatiguee. Tester une variante (meme format, autre lieu)." |
| ROAS qui s'erode sur un winner | "Le cycle de vie est atteint. Preparer V2 avec angle de renouvellement." |
| Ecart CPA entre ad sets | "Reallouer du budget de l'ad set couteux vers l'ad set efficient." |

### Source 2 : Insights Radar (veille)

| Signal Radar | Hypothese type |
|-------------|----------------|
| Evenement reel (eruption, festival, saison) | "Creer une creative Breaking News surfant sur l'event dans les < 24h." |
| Concurrent lance un nouveau format | "Tester un angle similaire adapte a Univile." |
| Tendance deco/lifestyle detectee | "Creer une creative qui s'inscrit dans cette tendance." |
| Hashtag viral lie a un lieu Univile | "Boost organique ou creative paid sur ce lieu." |

### Source 3 : Historique creatif (patterns)

| Signal historique | Hypothese type |
|------------------|----------------|
| Combinaison persona x format jamais testee | "Tester cette combinaison avec le format champion." |
| Format gagnant sur un lieu, non teste sur un autre | "Decliner le format gagnant sur d'autres lieux." |
| Angle qui a fonctionne une fois | "Tester la reproductibilite avec un lieu different." |

### Source 4 : Nexus (conversion post-clic)

| Signal Nexus | Hypothese type |
|-------------|----------------|
| Landing page X convertit mieux que Y | "Envoyer les ads vers la landing page X." |
| Page collection convertit 3x plus que page produit | "Tester l'envoi vers collection plutot que fiche produit." |
| Checkout abandonne au step frais de port | "Mentionner 'Livraison offerte des 70 EUR' dans la creative." |

### Source 5 : Keeper (CRM/segments)

| Signal Keeper | Hypothese type |
|-------------|----------------|
| Segment email avec taux ouverture 45% | "Creer une audience LAL basee sur ce segment email." |
| Clients VIP (panier > 100 EUR) avec profil precis | "Creer une audience LAL VIP." |
| Segment "acheteurs cadeaux" identifie | "Tester un angle cadeau specifique sur LAL acheteurs cadeaux." |

---

## 6. Matrice ICE de priorisation

Chaque hypothese est notee sur 3 axes de 1 a 10. **Score ICE = I x C x E.**

| Axe | Critere | 1 (bas) | 5 (moyen) | 10 (haut) |
|-----|---------|---------|-----------|-----------|
| **I = Impact potentiel** | En EUR generes si l'hypothese est validee | < 100 EUR/mois | 100-500 EUR/mois | > 500 EUR/mois |
| **C = Confiance** | Donnees existantes qui supportent l'hypothese | Intuition pure | Signal indirect (ATC, CTR) | Donnee directe (achat, ROAS) |
| **E = Facilite** | Effort production (Forge) + budget necessaire | > 200 EUR + brief complexe | 50-200 EUR + brief standard | < 50 EUR + variante d'existant |

### Regles de priorisation

| Regle | Detail |
|-------|--------|
| **Max 2-3 hypotheses en test simultane** | Budget contraint (~6 EUR/j C = ~180 EUR/mois) |
| **Au moins 1 hypothese "safe"** | Variante d'un winner prouve (meme format, autre lieu/texte) |
| **Au moins 1 hypothese "exploratoire"** | Combinaison jamais testee (nouveau persona/format/angle) |
| **Score ICE > 300 = prioritaire** | En dessous de 100, reporter au cycle suivant |
| **Event = priorite absolue** | Le timing prime sur le score ICE (fenetre < 24-48h) |

### Exemple matrice remplie

| ID | Hypothese | I | C | E | Score | Rang |
|----|-----------|---|---|---|-------|------|
| HYP-W14-01 | Carrousel AA x Julien x France en Broad | 8 | 6 | 7 | 336 | 1 |
| HYP-W14-02 | Breaking News x Christiane x Fete Cafre | 7 | 7 | 6 | 294 | 2 |
| HYP-W14-03 | Statique Mockup x Marie x Martinique | 5 | 5 | 8 | 200 | 3 |
| HYP-W14-04 | Video lifestyle x Julien x Paris | 6 | 2 | 4 | 48 | REFUSE (video INTERDITE + faible confiance) |

---

## 7. Budget et duree minimum par test

| Parametre | Valeur | Raison |
|-----------|--------|--------|
| **Budget minimum par test** | **50 EUR** (ou 2x CPA cible) | En dessous, pas assez de donnees pour conclure |
| **Duree minimum** | **5-7 jours** | L'algorithme Meta a besoin de ce temps d'apprentissage |
| **Duree maximum avant conclusion** | **14 jours** | Au-dela, contexte change, donnees plus fiables |
| **Achats minimum pour valider** | **2** | 1 achat peut etre un accident statistique |
| **Budget test mensuel C** | **~180 EUR** (6 EUR/j) | 10% du budget total Meta |

### Pourquoi 50 EUR et pas 30 EUR ?

- CPA cible Univile = 28 EUR.
- Kill rule Coudac = 1,8x CPA = ~50 EUR.
- Sous 50 EUR, impossible de dire si c'est un echec statistique ou reel.
- 50 EUR sans achat = signal clair de kill.

### Pourquoi 5-7 jours et pas 3 ?

- Jours 1-2 : phase d'apprentissage Meta, donnees volatiles.
- Jours 3-4 : stabilisation partielle.
- Jours 5-7 : donnees fiables.
- Au-dela de 14j : weekends + events changent le contexte.

---

## 8. Metriques : primaire CPA, secondaires

### Metrique primaire : CPA (pas ROAS)

**Pourquoi CPA et pas ROAS :**
- Le ROAS est biaise par la valeur de commande (1 commande a 100 EUR donne un ROAS 2x meilleur qu'une commande a 50 EUR pour le meme CPA).
- Le CPA est comparable entre creatives independamment du panier.
- Le CPA est controlable (on peut le baisser en ameliorant la creative).
- Le ROAS reste utilise en secondaire pour comparer des creatives entre elles.

**CPA cible Univile** : 28 EUR. **CPA max tolere** : 42 EUR (1,5x cible).

### Metriques secondaires

| Metrique | Usage | Seuil d'alerte |
|---------|-------|---------------|
| **CTR** (Click-Through Rate) | Qualite du hook visuel | < 1% = hook faible ; > 8% = trafic suspect (piege a clics) |
| **ATC rate** (Add-to-Cart / clic) | Qualite du post-clic | < 3% = landing page ou produit inadapte |
| **Conversion rate** (achat/clic) | Efficacite du funnel complet | < 0,5% = probleme quelque part dans le parcours |
| **CPM** (cout 1000 impressions) | Efficience distribution | > 15 EUR = audience trop restreinte ou fatigue |
| **Frequence** (vues/personne) | Fatigue creative | > 3 = renouveler la creative |

---

## 9. Seuils de decision et arbre kill vs scale

### Tableau de decision

| Situation | Seuil | Conclusion |
|-----------|-------|-----------|
| **Validation** | CPA < 1,5x CPA cible (< 42 EUR) ET >= 2 achats | HYPOTHESE VALIDEE -- encoder learning, planifier scaling |
| **Validation forte** | CPA < CPA cible (< 28 EUR) ET >= 3 achats | HYPOTHESE VALIDEE -- scaling prioritaire |
| **Echec net** | Depense > 50 EUR ET 0 achat ET 0 ATC | HYPOTHESE INVALIDEE -- encoder learning, ne JAMAIS retester la meme chose |
| **Zone grise : ATC sans achat** | ATC > 0 mais 0 achat apres 50 EUR | PROLONGER 3 jours max. Investiguer post-ATC avec Nexus (checkout, prix final, frais de port ?) |
| **Zone grise : micro-budget** | Depense < 50 EUR et resultats ambigus | INCONCLUSIF -- relancer avec budget suffisant ou reporter |
| **Zone grise : famine** | En ligne > 7j, depense < 10 EUR | INCONCLUSIF -- creative ignoree par Meta. Deplacer vers autre ad set |

### Arbre de decision Kill vs Scale

```
Apres 5-7 jours, a 50 EUR+ depenses :

                 Y a-t-il >= 2 achats ?
                /                    \
              OUI                     NON
              /                        \
      CPA < 42 EUR ?          Y a-t-il >= 1 ATC ?
        /       \                    /       \
      OUI       NON                OUI       NON
      |         |                   |          |
   VALIDEE   ZONE GRISE         ZONE GRISE   KILL NET
   |         (ATC>0,achat)      (ATC mais     |
   |           |                  0 achat)    |
   |     Prolonger 3j             |       Encoder le
   |     puis decision         Prolonger    learning
   |                              3j       "PARCE QUE..."
Ad set ?                       + Nexus
  /      \
CPA<28 ET                      Si apres J10
>=3 achats ?                   toujours 0 achat
  /     \                      = INVALIDE
OUI      NON
|         |
SCALE     SCALE
PRIORITAIRE STANDARD
(winner     (winner
 fort)       potentiel)
```

### Regle critique

**Un kill sans learning = un echec complet.** Un kill avec learning = un progres. Chaque hypothese INVALIDEE doit encoder un learning de la forme :

> "Ca n'a pas marche PARCE QUE [raison specifique], donc on ne retestera PAS [exactement la meme chose] mais on pourrait tester [variante qui adresse la raison]."

---

## 10. Structure des ad sets A/B/C

| Ad Set | Role | Budget cible | Usage des tests |
|--------|------|-------------|----------------|
| **A -- Broad** | Conversion sur audience large | 60-70% (36-42 EUR/j) | Promotion de winners valides depuis C |
| **B -- LAL/Interets** | Conversion sur audience pre-qualifiee | 20-30% (12-18 EUR/j) | Promotion de winners + formats workhorse |
| **C -- Test** | Terrain d'essai hypotheses | 10% (~6 EUR/j) | Lancement initial des hypotheses |
| **D -- Event (ad hoc)** | Urgence event imprevisible | 50-100 EUR limite | Creative Breaking News URGENT |

### Parcours d'une creative

```
1. Hypothese formulee (Stratege)
2. Brief Forge -> Creative produite (48h ou 2h URGENT)
3. Lancement dans Ad Set C (Test) a ~7 EUR/j
4. Mesure 5-7 jours
   - Si validation -> Scaling horizontal (C -> B, puis B -> A)
   - Si echec -> Kill + learning encode
   - Si zone grise -> Prolongation 3j + diagnostic
5. Grace period 5j a chaque changement d'ad set (kill rule suspendu)
```

---

## 11. Registre d'hypotheses

### Fichier

`/team-workspace/marketing/_strategie/registre-hypotheses.md`

### Structure

```markdown
# Registre d'Hypotheses -- Stratege Univile

## Hypotheses actives

| ID | Hypothese | Variable | Metrique | Seuil | Budget | Duree | Statut | Learning |
|----|-----------|----------|----------|-------|--------|-------|--------|----------|
| HYP-2026-W14-01 | Si AA x Julien x France en Broad... | Persona + Ad Set | CPA < 35 EUR | 2 achats min | 50 EUR | 7j | EN_TEST | -- |
| HYP-2026-W14-02 | Si BN x Christiane x Fete Cafre... | Persona + Timing | CPA < 28 EUR | 2 achats min | 50 EUR | 5j | EN_ATTENTE | -- |

## Historique (hypotheses conclues)

| ID | Hypothese | Resultat | CPA reel | Achats | Learning encode |
|----|-----------|---------|----------|--------|----------------|
| HYP-2026-W12-01 | BN Eruption x Marie x Reunion | VALIDE | 1,96 EUR | 53 | L1+L2+L7 |
| HYP-2026-W12-02 | Flash Info Sakura x Julien x Japon | VALIDE | 3,43 EUR | 2 | L3 |
```

### Statuts possibles

| Statut | Signification |
|--------|--------------|
| **EN_ATTENTE** | Hypothese formulee, pas encore en test (brief Forge en cours ou budget pas disponible) |
| **EN_TEST** | Creative lancee, en cours de mesure (minimum 5 jours avant conclusion) |
| **VALIDE** | CPA < seuil ET achats >= minimum. Learning positif encode. |
| **INVALIDE** | Depense > budget ET echec (0 achat ou CPA > seuil). Learning negatif encode. |
| **INCONCLUSIF** | Famine, micro-budget, ou zone grise non resolue. A re-tester avec conditions differentes. |

---

## 12. Cycles de test complets (exemples)

### Cycle 1 : Tester un format champion sur un persona non teste

**Etape 1 : Generer l'hypothese**
Source : historique montre que Carrousel Avant/Apres = champion (ROAS 69x) mais jamais teste pour Julien sur lieux France.

**Etape 2 : Brief Forge**
```
BRIEF STRATEGIQUE -> FORGE
Ref : BRF-2026-W15-01
Hypothese : HYP-2026-W15-01
Objectif : Tester si le format AA convertit pour Julien (proprio metro)
Persona : Julien (30-50, proprio metro, deco soignee)
Angle : Transformation (mur vide -> mur decore)
Format : Carrousel AA (2-3 slides)
Produit : Sacre-Coeur (50x70, cadre noir)
Copy suggeree : "Vos murs racontent vos voyages. A partir de 28 EUR."
Contraintes : PAS de video, produit visible slide 2, prix mentionne
References : B2 Avant/Apres (ROAS 69x)
Ad set : C (test)
Budget : 50 EUR / 7 jours
Metrique succes : CPA < 35 EUR
```

**Etape 3 : Atlas lance le test**
"Lancer BRF-2026-W15-01 dans Ad Set C a 7 EUR/j. Ne PAS toucher pendant 5 jours."

**Etape 4 : Mesure (J5-J7), 3 scenarios**

- **Scenario A -- Validation** : J5, 2 achats, CPA 22 EUR. -> Promouvoir vers A + B. Grace period 5j. Brief variantes (Etretat, Mont-Saint-Michel).
- **Scenario B -- Echec** : J7, 0 achat, CTR 0,8%. -> Learning : "Le hook (Sacre-Coeur generique) n'arrete pas Julien. Prochaine hypothese : lieux plus instagrammables (Etretat, Gorges du Verdon)."
- **Scenario C -- Zone grise** : J7, 5 ATC, 0 achat. -> Prolonger 3j + Nexus investigation post-clic. Si J10 toujours 0 achat, encoder "Le format genere de l'interet (ATC) mais ne convertit pas. Probleme post-clic a resoudre."

### Cycle 2 : Exploiter un event imprevisible (eruption)

**Etape 1 : Radar detecte l'event**
"Eruption Piton de la Fournaise confirmee -- medias nationaux."

**Etape 2 : Hypothese URGENTE**
```
ID : HYP-2026-W16-01 (URGENT)
Hypothese : Si on lance un Breaking News dans les < 6h, alors ROAS > 10x
   car BN + event reel divise CPM par 5-10x (L2) et precedent = 23,5x.
Variable : Timing (reactivite < 6h)
Budget : 50 EUR (ad set D)
Duree : 5 jours max (erosion prevue)
```

**Etape 3 : Brief Forge URGENT < 2h**
```
BRIEF STRATEGIQUE -> FORGE [URGENT - < 2h]
Format : Breaking News
Angle : Evenement/FOMO
Produit : Piton de la Fournaise (affiche recente)
Copy : "ALERTE INFO : Le Piton entre en eruption. Edition limitee."
Contraintes : Bandeau rouge, ticker news, produit visible, prix mentionne
Deadline : 2 heures max
```

**Etape 4 : Mesure quotidienne + V2 preparee**
- J1 : ROAS 30x, CTR 8,5% -> CHAMPION confirme
- J2 : ROAS 18x (erosion naturelle) -> BRIEF Forge V2 "La lave a cesse"
- J3 : ROAS 6x, CTR < 5% -> LANCER V2 immediatement
- J5 : V1 eteint, V2 en place -> nouveau cycle

### Cycle 3 : Diagnostiquer 3 kills en serie

**Etape 1 : Atlas rapporte 3 kills consecutifs**
Semaine 17 : 3 creatives killees (0 achat, 0 ATC, > 50 EUR chacune). Toutes = Marie x Statiques Mockup x Reunion dans Ad Set A (Broad).

**Etape 2 : Stratege ouvre Opus thinking** (obligatoire a partir de 3 kills)

Questions a investiguer :
1. Est-ce le format ? (Statique Mockup = rang 3, pas le champion)
2. Est-ce l'audience ? (Ad Set A = Broad, a-t-il deja converti avec d'autres formats ?)
3. Est-ce le timing ? (Changement saisonnier ou algorithmique ?)
4. Est-ce la fatigue ? (Frequence existante dans A ?)

**Etape 3 : Diagnostic + hypothese corrective**
Conclusion : le Broad (A) n'a JAMAIS converti avec des Statiques Mockup. Les seuls formats qui convertissent a l'echelle sont Breaking News et Avant/Apres. Les Statiques sont des workhorse de l'Ad Set B (LAL), pas du Broad.

```
ID : HYP-2026-W18-01
Hypothese : Si on lance un Breaking News / Flash Info dans l'Ad Set A (Broad)
   avec un angle "Lieu du mois" cree de toutes pieces, alors on obtiendra
   des conversions en Broad car le format BN est le seul prouve comme
   scroll-stopper capable de convertir une audience froide (L1, L3).
```

**Learning encode :** "Les Statiques Mockup ne fonctionnent PAS comme scroll-stopper en Broad (audience froide). Le Broad necessite un format disruptif (Breaking News, Flash Info). Les Statiques sont reservees au LAL (audience pre-qualifiee)."

---

## REFERENCES CROISEES

- **12 regles Coudac detaillees** : `/team-workspace/marketing/references/coudac-12-regles-details.md`
- **Scaling framework** : `/team-workspace/marketing/references/scaling-framework.md`
- **Allocation budgetaire** : `/team-workspace/marketing/references/allocation-budgetaire.md`
- **Registre des hypotheses (live)** : `/team-workspace/marketing/_strategie/registre-hypotheses.md`
- **SOUL Stratege (source)** : `/_openclaw_agents_source/SOUL-stratege-paid-media.md` (section 6)
