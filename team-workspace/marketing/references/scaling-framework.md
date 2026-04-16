# Scaling Framework -- Paid Media Univile

> Reference operationnelle du scaling des winners. Methode Coudac : **+20% max par jour**, paliers valides sur 5 jours, validation Marty a chaque palier, signaux de kill systematiquement appliques. 3 types de scaling : vertical (budget), horizontal (duplication ad sets), creatif (variantes).

**Contexte Univile** : budget base 50 EUR/j, fourchette 50-100 EUR/j, plafond 100 EUR/j avec validation Marty, plancher saisonnier 35 EUR/j (juillet-aout).

---

## TABLE DES MATIERES

1. [Definition d'un winner (3 niveaux)](#1-definition-dun-winner)
2. [Scaling vertical : augmenter le budget](#2-scaling-vertical--augmenter-le-budget)
3. [Paliers concrets : 50 -> 60 -> 72 -> 86 EUR/jour](#3-paliers-concrets)
4. [Scaling horizontal : dupliquer dans d'autres ad sets](#4-scaling-horizontal)
5. [Scaling creatif : variantes via Forge](#5-scaling-creatif)
6. [Duree de vie et courbes d'erosion par format](#6-duree-de-vie-et-courbes-derosion)
7. [Signaux de scaling (ROAS, frequence, ATC rate)](#7-signaux-de-scaling)
8. [Signaux de kill et retour en arriere](#8-signaux-de-kill)
9. [Grace period : 5 jours dans un nouvel ad set](#9-grace-period)
10. [Validation Marty par palier (workflow)](#10-validation-marty-par-palier)
11. [Rafraichissement proactif (V2 avant erosion)](#11-rafraichissement-proactif)

---

## 1. Definition d'un winner

| Niveau | Critere | Action immediate |
|--------|---------|-----------------|
| **Winner potentiel** | ROAS > 3x apres 5 jours ET > 20 EUR depenses ET >= 1 achat | Observer 2 jours supplementaires avant scaling |
| **Winner confirme** | ROAS > 5x apres 5 jours ET > 30 EUR depenses ET >= 2 achats | Scaling vertical + horizontal |
| **Super winner** | ROAS > 10x apres 5 jours ET > 20 EUR depenses | Scaling agressif + variations creatives urgentes (< 48h) |

### Exemples Univile

- **Breaking News Eruption** (ROAS 23,5x) = Super winner -> scaling agressif + V2 briefee immediatement.
- **Carrousel Avant/Apres B2** (ROAS 69x) = Super winner (record Univile) -> variantes lieux demandees.
- **Flash Info Sakura** (ROAS 10,19x) = Super winner -> brief variantes (Torii, Hanami).
- **Statique Mockup Cadeau** (ROAS 3,42x, 23 achats) = Winner potentiel stable -> maintien, pas de scaling agressif.

---

## 2. Scaling vertical : augmenter le budget

**Methode :** Augmenter le budget de l'ad set contenant le winner de **+20% par palier**.

### Regles absolues

1. Chaque palier = validation Marty obligatoire.
2. Chaque palier = stabilisation 5 jours avant la hausse suivante.
3. Si degradation a un palier -> retour IMMEDIAT au palier precedent.
4. +20% max par jour (regle Coudac #4, non negociable).

### Tableau des conditions

| Jour | Budget | Condition |
|------|--------|----------|
| J0 (validation) | Budget actuel | Winner confirme (ROAS > 5x, > 30 EUR depenses, >= 2 achats) |
| J1 | +20% | Si ROAS maintenu > 3x |
| J6 | +20% supplementaire | Si ROAS maintenu > 3x sur 5 jours |
| J11 | +20% supplementaire | Idem |
| J16 | +20% supplementaire | Idem |
| **STOP et retour** | Palier precedent | Si ROAS < 2x ou CPA > 35 EUR |

---

## 3. Paliers concrets

### Depuis budget base 50 EUR/jour

| Palier | Jour | Budget | Delta | Validation |
|--------|------|--------|-------|------------|
| Palier 0 | J0 | **50 EUR/j** | Baseline | -- |
| Palier 1 | J1 | **60 EUR/j** | +20% (+10 EUR/j) | Marty OK |
| Palier 2 | J6 | **72 EUR/j** | +20% (+12 EUR/j) | Marty OK |
| Palier 3 | J11 | **86 EUR/j** | +20% (+14 EUR/j) | Marty OK |
| Palier 4 | J16 | **103 EUR/j** | +20% (+17 EUR/j) | **Depasse plafond 100 EUR** -- Marty decide specifiquement |
| Palier 5 | J21 | **124 EUR/j** | +20% | Au-dela du plafond normal -- discussion de fond Marty |

### Depuis budget base 60 EUR/jour (etat actuel Univile)

| Palier | Jour | Budget | Delta |
|--------|------|--------|-------|
| Palier 0 | J0 | 60 EUR/j | Baseline |
| Palier 1 | J1 | 72 EUR/j | +20% |
| Palier 2 | J6 | 86 EUR/j | +20% |
| Palier 3 | J11 | 103 EUR/j | +20% (plafond depasse, validation speciale) |

### Regle du palier

**Palier valide = 5 jours consecutifs a ROAS > 3x et CPA < 35 EUR.**
Si un seul jour a ROAS < 2x ou CPA > 35 EUR a un palier : retour immediat au palier precedent, stabilisation 5 jours, puis re-tentative.

---

## 4. Scaling horizontal : dupliquer dans d'autres ad sets

**Methode :** Dupliquer la creative gagnante dans d'autres ad sets pour atteindre de nouvelles audiences.

### Tableau des duplications

| Winner dans... | Dupliquer dans... | Attention |
|----------------|-------------------|-----------|
| **C (Test)** | B (LAL) puis A (Broad) | Grace period de 5 jours dans chaque nouvel ad set |
| **B (LAL)** | A (Broad) | Grace period de 5 jours |
| **A (Broad)** | B (LAL) | Grace period de 5 jours |

### Sequence recommandee

Un winner valide en C se promeut typiquement :
1. **J+1** : duplication dans B (LAL/interets).
2. **J+6** : si ca performe dans B, duplication dans A (Broad).
3. **J+11** : si tout performe, initier scaling vertical (budget).

### Regle

**On ne duplique jamais un winner dans plus d'un nouvel ad set a la fois.** On promeut a B, on observe 5 jours, puis a A si signal positif.

---

## 5. Scaling creatif : variantes via Forge

**Methode :** Quand un winner est identifie, briefer Forge pour 2-3 variantes **dans les 48h**. Ne PAS attendre que le winner s'erode.

### Types de variantes

| Type | Description | Exemple Univile |
|------|-------------|----------------|
| **Meme format, autre lieu** | Reproduire la structure gagnante avec un lieu different | BN Eruption marche -> BN Grand Raid, BN Fete Cafre |
| **Meme format, autre persona** | Adapter le texte/contexte pour un autre persona | BN Marie -> BN Julien (meme format, autre angle texte) |
| **Meme format, autre produit** | Mettre un autre produit du catalogue dans la meme structure | AA Sacre-Coeur -> AA Etretat, AA Gorges du Verdon |
| **Evolution du hook** | Garder le meme format mais changer le hook visuel | BN "ALERTE" -> Flash Info "A LA UNE" |
| **V2 du winner** | Preparer le remplacement AVANT l'erosion | BN Eruption V1 -> V2 "La lave a cesse, les images restent" |

### Regle

**Des qu'un winner est confirme, brief 2-3 variantes en 48h.** C'est une regle non-negociable : le pipeline de releves doit etre pret avant l'erosion (qui est previsible pour chaque format, voir section 6).

---

## 6. Duree de vie et courbes d'erosion

### Tableau d'erosion par format

| Format | Duree de vie typique | Signal d'erosion | Action |
|--------|---------------------|-----------------|--------|
| **Breaking News (event reel)** | 3-5 jours | ROAS divise par 4-5 en 3j (L7) | **V2 pret AVANT J3** |
| **Flash Info (event cree)** | 5-10 jours | CTR < 3% ou ROAS < 3x | V2 dans les 48h |
| **Statique Mockup** | 2-4 semaines | Frequence > 3 ou CTR < 1% | Variante lieu/produit |
| **Carrousel Avant/Apres** | 2-4 semaines | Frequence > 3 ou CTR < 1,5% | Variante lieu |
| **Carrousel Multi-lieux** | 3-6 semaines | CTR < 0,8% | Rotation de lieux |

### Exemple concret : erosion Breaking News Eruption

| Jour | ROAS | CTR | CPM | Action |
|------|------|-----|-----|--------|
| J1 | 32x | 9,2% | 1,50 EUR | Champion confirme -> brief V2 immediatement |
| J2 | 23x | 8,5% | 1,80 EUR | V2 en production chez Forge |
| J3 | 7x | 5,2% | 3,10 EUR | V1 en fin de vie -> V2 prete (< 24h) |
| J4 | 3x | 3,8% | 4,20 EUR | Lancement V2, V1 pause |
| J5 | -- | -- | -- | V2 tourne seule |

**Learning L7 encode :** l'erosion Breaking News divise le ROAS par 4-5 en 3 jours. V2 doit etre prete AVANT J3.

---

## 7. Signaux de scaling

### Conditions d'augmentation du budget global (ET, pas OU)

| # | Condition | Seuil Univile |
|---|----------|--------------|
| 1 | ROAS global compte > 3x sur les 7 derniers jours | > 3x |
| 2 | CPA moyen < 28 EUR sur les 7 derniers jours | < 28 EUR |
| 3 | Au moins 3 creatives actives avec des achats | >= 3 |
| 4 | Frequence < 2,5 sur tous les ad sets | < 2,5 |
| 5 | Au moins 10 achats dans les 7 derniers jours | >= 10 |

### Signaux specifiques par type

#### ROAS
- ROAS > 5x sur 5j + depense > 30 EUR + 2 achats -> **Winner confirme** (scaling OK).
- ROAS > 10x sur 5j -> **Super winner** (scaling agressif + variantes urgentes).
- ROAS qui se maintient > 3x a chaque palier -> continuer scaling.

#### Frequence
- Frequence < 2 : audience non saturee, scaling possible.
- Frequence 2-2,5 : zone de surveillance, anticiper variante.
- Frequence > 2,5 : **STOP scaling**, briefer Forge variante avant hausse.
- Frequence > 3 : **URGENCE**, switcher sur V2 ou pause.

#### ATC rate
- ATC rate > 8% : signal fort de creative qui fonctionne, scaling OK.
- ATC rate 3-8% : normal, scaling possible.
- ATC rate < 3% : signal faible, ne PAS scaler avant d'avoir resolu le post-clic.

#### CPA
- CPA < 28 EUR : scaling prioritaire.
- CPA 28-42 EUR : scaling conditionnel (observer 2j supplementaires).
- CPA > 42 EUR : **pas de scaling**, identifier le probleme.

---

## 8. Signaux de kill

### Conditions de reduction du budget

| Declencheur | Action | Urgence |
|-------------|--------|---------|
| ROAS global < 1,5x sur 7 jours | Recommander -20% a Marty | Normale |
| CPA moyen > 45 EUR sur 7 jours | Recommander -20% a Marty | Normale |
| ROAS < 0,3x sur 2 jours consecutifs | **URGENCE** : recommander pause creatives + diagnostic complet | Urgente |
| 0 achat compte entier pendant 4 jours | **URGENCE** : diagnostic + alerte Marty + alerte Sparky | Urgente |
| 3 kills en serie | **Diagnostic Opus obligatoire** (pattern a investiguer) | Urgente |

### Stop scaling et retour au palier precedent

Conditions pour revenir au palier precedent apres une hausse :

| Signal | Action |
|--------|--------|
| ROAS < 2x apres hausse | Retour immediat au palier precedent |
| CPA > 35 EUR apres hausse | Retour immediat au palier precedent |
| Frequence > 3 apres hausse | Pause creative + retour au palier |
| Volume d'achats diminue de > 30% vs palier precedent | Retour au palier precedent |

---

## 9. Grace period

**Definition :** Quand une creative est promue dans un **nouvel ad set** (scaling horizontal), les compteurs sont remis a zero. **5 jours d'observation** sans toucher. **La kill rule ne s'applique qu'a partir du jour 5 dans le NOUVEL ad set.**

### Pourquoi

- L'algorithme Meta re-apprend a chaque nouvelle combinaison ad set x creative.
- J1-J4 dans un nouvel ad set : donnees volatiles.
- J5+ : donnees fiables pour appliquer la kill rule.

### Exemple concret

Breaking News Eruption validee en C (J7) -> duplication en B :

| Jour dans B | Depense | Achats | Kill rule ? |
|-------------|---------|--------|------------|
| J1-J4 (B) | 28 EUR | 0 | **NON** (grace period) |
| J5 (B) | 35 EUR | 0 | Observer encore 2j |
| J7 (B) | 50 EUR | 0 ET 0 ATC | **OUI** kill + learning |
| J7 (B) | 50 EUR | 1 achat + 2 ATC | Continuer, possible winner |

---

## 10. Validation Marty par palier

### Principe

**TOUTE modification de budget necessite la validation de Marty.** Stratege recommande, Marty decide. Pas d'autonomie Stratege sur les changements de budget.

### Format de la recommandation

```
RECOMMANDATION STRATEGE -> MARTY (via Sparky)
Type : Scaling vertical
Resume : Augmenter budget Ad Set A de 60 a 72 EUR/j (palier 2)

Situation :
- Ad Set A a un winner confirme (BN Eruption, ROAS 23,5x)
- Palier 1 (60 EUR/j) valide sur 5 jours : ROAS maintenu 8x, CPA 18 EUR
- Frequence A = 2,1 (saine)
- 12 achats dans les 5 derniers jours

Recommandation : Passer A de 60 a 72 EUR/j (+20%)

Impact attendu :
- +400 EUR de CA mensuel si ROAS 5x maintenu
- +150 EUR de marge nette

Risque si non fait :
- Plafonner la croissance du winner
- Erosion naturelle sans capitalisation

Action requise : Valider / Refuser / Reporter
```

### Workflow

```
1. Stratege identifie signal de scaling (conditions 1-5 remplies)
2. Stratege formule recommandation (format ci-dessus)
3. Envoi a Sparky (qui consolide avec autres demandes Marty du jour)
4. Marty valide / refuse / reporte
5. Si validation -> Stratege instruit Atlas pour appliquer le changement
6. Atlas applique + rapport dans rapport matinal suivant
7. Monitoring 5 jours avant palier suivant
```

### Seuils necessitant validation

| Decision | Seuil |
|----------|-------|
| Tout changement de budget quotidien | Meme +1 EUR |
| Reallocation entre ad sets | Tout transfert > 5 EUR/j |
| Kill d'un workhorse | Pause d'une creative qui a genere > 10 achats au total |
| Scaling d'un winner | Toute augmentation |
| Changement de plafond | Passage de 100 a 120 EUR/j (ex) |

---

## 11. Rafraichissement proactif

### Regle non-negociable

**Preparer le V2 AVANT que le V1 s'erode.** Pour Breaking News : V2 pret avant J3. Pour les autres formats : V2 pret avant frequence 2,5.

### Declencheurs et actions

| Declencheur | Action du Stratege |
|-------------|-------------------|
| CTR < 5% sur un Breaking News apres J3 | Brief Forge V2 immediatement |
| ROAS < 3x sur un Breaking News apres J3 | Brief Forge V2 immediatement |
| Frequence > 2,5 sur n'importe quelle creative | Brief Forge variante (autre lieu, meme format) |
| CTR < 1% sur un Statique apres 2 semaines | Brief Forge remplacement |
| **Winner identifie** | **Brief Forge 2-3 variantes dans les 48h (ne PAS attendre l'erosion)** |

### Pipeline cible Forge

- **2-3 creatives en tampon** en permanence (en attente de lancement).
- **1 V2 par winner actif** (pret a switch).
- **Rythme normal** : 2-3 briefs/semaine. **Pre-saison** : 4-5 briefs/semaine.

---

## ARBRE DE DECISION : SCALE vs MAINTAIN vs KILL

```
Apres 5-7 jours de test :

                 Y a-t-il >= 2 achats ET CPA < 42 EUR ?
                /                                \
              OUI                                 NON
              /                                    \
        ROAS > 5x ?                         Y a-t-il des ATC ?
        /          \                         /           \
     OUI           NON                    OUI            NON
     |              |                      |              |
   ROAS > 10x ?  WINNER           Prolonger 3j       KILL + learning
     /    \      POTENTIEL        + Nexus post-clic   "parce que..."
    OUI    NON   Observer 2j      |
    |      |                      Si echec apres J10 :
  SUPER  WINNER                   INVALIDE + learning
  WINNER CONFIRME
    |      |
  Scaling  Scaling
  agressif standard
  + V2      + duplication
  < 48h     horizontale
```

---

## REFERENCES CROISEES

- **12 regles Coudac detaillees** : `/team-workspace/marketing/references/coudac-12-regles-details.md`
- **Testing framework** : `/team-workspace/marketing/references/testing-framework.md`
- **Allocation budgetaire** : `/team-workspace/marketing/references/allocation-budgetaire.md`
- **SOUL Stratege (source)** : `/_openclaw_agents_source/SOUL-stratege-paid-media.md` (section 8)
- **Registre des hypotheses (live)** : `/team-workspace/marketing/_strategie/registre-hypotheses.md`
