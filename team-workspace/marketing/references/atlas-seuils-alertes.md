# Atlas — Seuils & Alertes Performance Meta Ads

> Document de reference pratique pour le domaine Performance Paid (Atlas). Utilise avec `/Users/admin/octopulse/.claude/shared/univile-context.md` pour le contexte business.

**Derniere mise a jour** : 2026-04-13
**Budget actuel** : 60 EUR/jour (50 base + 10 test) — Meta Ads
**CPA cible** : 28 EUR
**Seuil rentabilite** : 22 647 EUR/mois (ecart a combler +5 520 EUR)

---

## TABLE DES MATIERES

1. [Seuils de performance globaux](#1-seuils-de-performance-globaux)
2. [Seuils KILL — quand couper une creative](#2-seuils-kill--quand-couper-une-creative)
3. [Seuils SCALE — quand scaler](#3-seuils-scale--quand-scaler)
4. [Seuils ANOMALIE — quand declencher une alerte](#4-seuils-anomalie--quand-declencher-une-alerte)
5. [Seuils Breaking News / event-driven](#5-seuils-breaking-news--event-driven)
6. [Arbre de decision kill / scale / maintain](#6-arbre-de-decision-kill--scale--maintain)
7. [Templates rapports](#7-templates-rapports)
8. [Regles d'or non-negociables](#8-regles-dor-non-negociables)

---

# 1. SEUILS DE PERFORMANCE GLOBAUX

## 1.1 Metriques cles et seuils

| Metrique | Vert (sain) | Orange (attention) | Rouge (action) | Reference |
|----------|-------------|--------------------|-----------|------------|
| **ROAS global** | > 3x | 1,5x - 3x | < 1,5x | Cible Coudac |
| **ROAS breakeven** | 1,55x | — | — | Marge 63,7% |
| **CPA moyen** | < 28 EUR | 28-40 EUR | > 40 EUR | Cible = 28 EUR |
| **CPM** | 8-15 EUR | 15-25 EUR | > 25 EUR (hors niche) | Benchmark deco |
| **CPM event-driven** | 1-5 EUR | 5-10 EUR | > 10 EUR | Event : Univile Eruption = 1,63 EUR |
| **CTR** | > 2% | 1-2% | < 1% | Benchmark 0,9-1,5% |
| **CTR Breaking News** | > 8% | 5-8% | < 5% | Ref : Eruption = 9,58% |
| **Frequence** | < 2 | 2 - 2,5 | > 2,5 (pre-alerte) / > 3 (critique) | Coudac regle 5 |
| **ATC rate (LPV → ATC)** | > 12% | 8-12% | < 8% | Ref : Univile = 15,8% (sain) |
| **Taux IC → Purchase** | > 40% | 25-40% | < 25% | Ref : Univile = 41,7% (sain) |
| **MER** (CA total / depense mkt total) | > 10x | 5-10x | < 5x | Metrique directrice > ROAS |
| **COS** (depense / CA) | < 10% | 10-20% | > 20% | Garde-fou budget |

## 1.2 Regles d'interpretation

- **MER > ROAS** : le ROAS Meta est declare par Meta (conflit d'interet). MER = verite globale (tout le marketing). COS = garde-fou absolu.
- **ROAS 0,3x ou moins sur 2 jours consecutifs** = URGENCE. Diagnostic immediat + alerte Stratege + Sparky + Marty sans attendre la regle 4 jours.
- **0 achat COMPTE ENTIER pendant 4 jours (5 si weekend inclus)** = diagnostic complet + alerte.

## 1.3 Budget — bornes operationnelles

| Parametre | Valeur | Regle |
|-----------|--------|-------|
| Budget quotidien actuel | 60 EUR/j (50 base + 10 test) | — |
| Budget mensuel | ~1 800 EUR/mois | — |
| **Plancher normal** | 50 EUR/jour | Ne **jamais** descendre sauf juillet-aout |
| Plancher saisonnier | 35 EUR/jour | Juillet-aout uniquement |
| **Plafond sans validation** | 100 EUR/jour | Au-dessus = validation Marty ou Jonathan obligatoire |
| Kill budget min test | 50 EUR OU 2x CPA target | Sous 50 EUR = famine, **invalide pour conclure** |
| Scaling max par jour | +20% | Jamais doubler d'un coup. Paliers, 3-5j entre chaque |

## 1.4 Allocation cible (Coudac)

| Ad Set | Lettre | Part cible | Budget a 50 EUR/j | Budget a 60 EUR/j | Budget a 70 EUR/j |
|--------|--------|------------|-------------------|-------------------|-------------------|
| Broad | A | 60% | 30 EUR | 36 EUR | 42 EUR |
| LAL / Interets | B | 30% | 15 EUR | 18 EUR | 21 EUR |
| Test | C | 10% | 5 EUR | 6 EUR | 7 EUR |
| Retargeting | — | 0% | 0 EUR | 0 EUR | 0 EUR |

**Retargeting = 0 EUR** tant que trafic < 5 000 visiteurs/mois (tonneau perce — regle Coudac 7).

---

# 2. SEUILS KILL — QUAND COUPER UNE CREATIVE

## 2.1 Regle d'or : age minimum avant kill

> **Aucune creative ne peut etre tuee avant 5 jours complets en ligne.**
> Unique exception : CTR > 8% avec 0 conversion → kill immediate (trafic poubelle / bots).
> L'algorithme Meta a besoin de 5-7 jours pour apprendre. Tuer trop tot = gaspillage budget d'apprentissage.

## 2.2 Table de kill (RECOMMANDATION — validation Marty ou Jonathan obligatoire)

| Situation | Seuil | Condition d'age | Action |
|-----------|-------|-----------------|--------|
| Creative sans achat | Depense > **50 EUR** | >= 5 jours en ligne | RECOMMANDER **PAUSE** → valid. Marty / Jonathan |
| Creative ROAS < 1x | Depense > 50 EUR | >= 7 jours en ligne | RECOMMANDER **PAUSE** → valid. Marty / Jonathan |
| CTR > 8% + 0 conversion | Depense > 15 EUR | **Pas de minimum d'age** | RECOMMANDER **PAUSE** immediat (bots / clics poubelle) |
| Frequence > 3,5 sur une creative | — | Pas de minimum | RECOMMANDER pause des plus anciennes |
| **FAMINE** : ignoree par Meta | > 7 jours en ligne ET depense < 10 EUR | Pas de minimum | RECOMMANDER deplacement vers autre ad set. **Ne pas conclure** — pas testee |

## 2.3 Kill rule avec filet ATC

Le cas le plus subtil : creative qui a des ATC mais 0 achat.

| Scenario | Depense | ATC | Action |
|----------|---------|-----|--------|
| Creative loser confirme | > 50 EUR | 0 | **KILL** (recommander pause) |
| Probleme post-ATC a investiguer | > 50 EUR | > 3 | **Prolonger 3 JOURS**. Investiguer POURQUOI (frais port, checkout casse, prix final surprenant) |
| Zone grise | > 50 EUR | 1-3 | Prolonger 2 JOURS max puis kill si toujours 0 achat |

> **REGLE CRITIQUE** : la prolongation est **TOUJOURS TEMPORELLE** (X jours), JAMAIS budgetaire (X EUR).
> Dire "prolonger 3 jours, verdict le [date]" — PAS "laisser tourner jusqu'a 70 EUR".
> Quand ATC > 0 mais 0 achat → **toujours** investiguer le pourquoi (frais port ? checkout ? surprise prix ?).

## 2.4 Famine (creative ignoree par l'algorithme)

Meta distribue le budget de maniere inegale au sein d'un ad set. Une creative qui n'a pas recu de budget n'a **PAS** ete testee. **La kill rule ne s'applique pas.**

- Creative en ligne > 7 jours avec < 10 EUR depenses → Meta l'a ignoree
- Action : deplacer dans un autre ad set pour chance equitable OU retirer si pipeline a des alternatives
- **NE JAMAIS** conclure qu'elle ne marche pas

## 2.5 Ce que Atlas fait jour par jour (jours 1-7)

| Jour | Action |
|------|--------|
| J1-J2 | Reporter signaux (impressions, CTR, ATC). **NE RIEN TOUCHER.** |
| J3 | Si 0 ATC ET depense > 30 EUR → noter "pre-alerte" mais NE PAS pauser |
| J4 | Si toujours 0 ATC → preparer creative de remplacement |
| J5 | **EVALUER** : 0 ATC et depense > 50 EUR → KILL. ATC > 0 → laisser jusqu'au J7 |
| J7 | Decision finale test. Achat + ROAS > 2x → signaler Stratege pour promotion Broad + LAL |

## 2.6 Grace period apres promotion

Quand une creative est promue du Test vers Broad ou LAL :

- Compteurs remis a zero
- Nouvelle grace period de 5 jours dans le nouvel ad set
- Kill rule ne s'applique qu'a partir du jour 5 dans le **nouvel** ad set
- Pourquoi : une creative qui marchait en Test (5 EUR/j, audience restreinte) a besoin de temps pour performer dans un ad set different

---

# 3. SEUILS SCALE — QUAND SCALER

## 3.1 Conditions de scaling (TOUTES doivent etre reunies)

Atlas detecte et signale au Stratege quand :

- [ ] ROAS global compte > 3x sur les 7 derniers jours
- [ ] CPA moyen < 28 EUR sur les 7 derniers jours
- [ ] Au moins 3 creatives actives avec des achats
- [ ] Frequence < 2,5 sur tous les ad sets
- [ ] Au moins 10 achats dans les 7 derniers jours

Le Stratege decide. Atlas execute apres validation Marty.

## 3.2 Seuils de detection scaling (par creative)

| Situation | Seuil | Age min | Action Atlas |
|-----------|-------|---------|--------------|
| Creative ROAS > 5x | > 30 EUR depenses | 5 jours | SIGNALER Stratege — recommander duplication/scaling |
| Creative ROAS > 10x | > 20 EUR depenses | 5 jours | SIGNALER Stratege — recommander duplication + augmentation |
| Ad Set ROAS > 3x | 7j glissants | — | SIGNALER Stratege — recommander +20% |
| 3+ creatives avec achats meme ad set | — | — | SIGNALER Stratege — ad set sain |

## 3.3 Methode de scaling

- **+20% par palier**, jamais plus
- Attendre **5 jours** entre chaque palier
- Si degradation (ROAS, CPA, frequence) → **revenir** au palier precedent
- Toujours apres validation Marty

---

# 4. SEUILS ANOMALIE — QUAND DECLENCHER UNE ALERTE

## 4.1 Alertes budget

| Declencheur | Action Atlas | Destinataires |
|-------------|--------------|---------------|
| ROAS global < 1,5x sur 7 jours | Alerte + recommandation baisse 20% | Stratege |
| CPA moyen > 45 EUR sur 7 jours | Alerte + recommandation baisse 20% | Stratege |
| ROAS < 0,3x sur 2 jours consecutifs | **URGENCE** : alerte + diagnostic | Stratege + Sparky + Marty |
| 0 achat COMPTE ENTIER 4 jours (5 si weekend) | Diagnostic complet + alerte | Stratege + Sparky + Marty |

## 4.2 Alertes frequence

| Frequence | Statut | Action |
|-----------|--------|--------|
| < 2 | Sain | Rien |
| 2 - 2,5 | Pre-alerte | Signaler Stratege — preparer creatives remplacement |
| 2,5 - 3 | Alerte | Signaler — injecter 2-3 nouvelles creatives |
| > 3 | Critique | RECOMMANDER pauser plus anciennes — validation Marty |
| > 4 | Urgence | RECOMMANDER reduction budget -30% + renouvellement creatives — validation Marty |

## 4.3 Alertes pipeline creatif

| Declencheur | Action |
|-------------|--------|
| Pipeline < 3 creatives actives avec achats | SIGNALER Stratege (et Forge en urgence si critique) |
| 0 creative active avec achats | Signalement direct a Forge autorise (urgence absolue) |
| Erosion Breaking News (CTR < 5% OU ROAS < 3x) | SIGNALER Stratege → V2 a demander Forge **avant** erosion complete |

## 4.4 Alertes statuts inactifs

**REGLE ABSOLUE** : Ne JAMAIS recommander de couper/pauser une ad deja PAUSED, WITH_ISSUES, CAMPAIGN_PAUSED ou ADSET_PAUSED. Leurs metriques sont **historiques**, pas un signal d'action.

## 4.5 Alerte budget non depense

Budget non depense sur un ad set ABO = **PAS une perte**. C'est un cout d'opportunite (on ne peut pas tester). Ne jamais dire "X EUR perdus" si l'ad set n'a pas depense.

---

# 5. SEUILS BREAKING NEWS / EVENT-DRIVEN

## 5.1 Learnings accumules

| # | Learning | Implication |
|---|----------|-------------|
| L1 | Breaking News bypass les defenses anti-pub (mimetisme editorial) | Format par defaut tout lancement |
| L2 | Event-driven divise CPM par 5-10x (1,63 EUR vs 8-15 EUR benchmark) | Fenetre reaction < 24h |
| L3 | Flash Info marche SANS event reel (Sakura ROAS 10,19x avec event "cree") | Creer des "events" artificiels (saisons, anniversaires, etc.) |
| L4 | Produit DOIT etre visible des la 1ere seconde | Pas de teasing |
| L5 | Mockup Salon mort comme scroll-stopper (CTR 2,47%) | Utile en slide 2-3 uniquement |
| L6 | Prix doit etre mentionne | Toujours "A partir de 28 EUR" |
| L7 | Erosion Breaking News previsible (J1: 32x, J2: 23x, J3: 7x) | **Preparer V2 AVANT CTR < 5%** |
| L8 | Funnel n'est PAS le probleme (VC→ATC 11,63%, ATC→Purchase 91,38%) | Problemes viennent des CREATIVES |

## 5.2 Seuils specifiques Breaking News

| Metrique | Vert | Rafraichissement (signaler V2 a Forge) | Erosion terminale (kill) |
|----------|------|----------------------------------------|-------------------------|
| CTR | > 8% | < 5% | < 2% |
| ROAS | > 10x | < 3x apres J3+ | < 1,5x |
| Duree de vie | 24-72h (event reel) / 2-4 semaines (saisonnier) | — | — |

## 5.3 Monitoring quotidien Breaking News

- Surveillance **quotidienne** du ROAS et CTR des creatives Breaking News
- Des que CTR < 5% OU ROAS < 3x → signaler Stratege (et Forge en urgence si pipeline critique)
- V2 pret **AVANT** erosion complete du V1
- La creative n'est pas "mauvaise" — le buzz s'essouffle naturellement

---

# 6. ARBRE DE DECISION KILL / SCALE / MAINTAIN

## 6.1 Nouvelle creative en Test (Ad Set C, 5 EUR/j)

```
NOUVELLE CREATIVE LANCEE DANS AD SET TEST C
|
+-- J1-J2 : ZONE DE PROTECTION — NE RIEN TOUCHER
|   +-- Observer : impressions, CTR, premiers clics
|   +-- ATC > 0 ? → Signal positif, noter dans le rendu
|   +-- CTR > 8% ET 0 conversion ? → EXCEPTION : KILL immediate (bots)
|   +-- Sinon → attendre, meme si 0 resultats (c'est NORMAL)
|
+-- J3-J4 : OBSERVATION ACTIVE
|   +-- ATC > 0 ? → Signal positif, laisser tourner
|   +-- Achat > 0 ? → Signal tres positif, preparer promotion
|   +-- 0 ATC ? → Pre-alerte, preparer creative remplacement AU CAS OU
|   +-- NE PAS KILL meme si 0 ATC (attendre J5 minimum)
|
+-- J5 : PREMIERE EVALUATION
|   +-- Achat > 0 ? → SIGNALER STRATEGE pour promotion Broad + LAL
|   +-- ATC > 3 ET 0 achat ? → Laisser jusqu'a J7
|   +-- ATC 1-3 ET 0 achat ? → Laisser jusqu'a J7
|   +-- 0 ATC apres 5 jours ET depense > 15 EUR ? → KILL
|
+-- J7 : DECISION FINALE EN TEST
|   +-- Achat > 0 ET ROAS > 2x ? → SIGNALER STRATEGE pour promotion
|   +-- Achat > 0 ET ROAS < 2x ? → GARDER en Test, observer 3 jours de plus
|   +-- 0 achat MAIS ATC > 5 ? → Prolonger 3 JOURS (probleme post-ATC)
|   +-- 0 achat ET ATC < 5 ET depense > 50 EUR ? → KILL
|   +-- 0 achat ET depense < 10 EUR ? → FAMINE, deplacer vers autre ad set
|
+-- J7+ (apres promotion Broad/LAL) :
    +-- Grace period 5 jours dans nouvel ad set
    +-- Apres grace period :
        +-- ROAS > 5x ? → CHAMPION — signaler Stratege, creer variantes
        +-- ROAS 2-5x ? → WORKHORSE — garder, signaler pour variantes
        +-- ROAS 1-2x ? → MEDIOCRE — garder si rien de mieux
        +-- ROAS < 1x apres 7 jours ? → KILL
```

## 6.2 Ad Set — ajuster le budget ?

```
EVALUATION HEBDOMADAIRE AD SET
|
+-- ROAS 7j > 3x ET frequence < 2,5 ?
|   → SIGNALER Stratege : conditions scaling reunies
|
+-- ROAS 7j 2x-3x ET frequence < 3 ?
|   → MAINTENIR budget — signaler "stable"
|
+-- ROAS 7j 1x-2x ?
|   +-- Frequence < 2 ? → Besoin nouvelles creatives (pas probleme budget)
|   +-- Frequence > 2,5 ? → Renouveler creatives + surveiller
|
+-- ROAS 7j < 1x ?
|   +-- Broad (A) ? → Tester autres creatives avant baisse
|   +-- LAL (B) ? → Recommander baisse -20% au Stratege
|   +-- Test (C) ? → Kill creatives, lancer nouvelles
|
+-- 0 achat sur 7 jours ?
    +-- Broad : restructurer (nouvelles creatives, verifier ciblage)
    +-- LAL : verifier qualite audience source
    +-- Test : kill toutes, repartir a zero
```

## 6.3 Budget global — monter, maintenir, baisser ?

```
EVALUATION HEBDOMADAIRE BUDGET GLOBAL
|
+-- ROAS global > 3x ET CPA < 28 EUR ET >=3 creatives avec achats ?
|   → SIGNALER Stratege : conditions scaling reunies
|   → Stratege recommande Marty, Atlas execute apres validation
|
+-- ROAS global 2x-3x ?
|   → MAINTENIR — signaler "stable" au Stratege
|
+-- ROAS global 1,5x-2x ?
|   → ALERTE : identifier creatives qui tirent vers le bas, kill
|   → Si 7 jours sans amelioration : signaler Stratege pour -20%
|
+-- ROAS global < 1,5x ?
|   → ALERTE Stratege + Marty : recommander -20%
|   → Diagnostic : quelles creatives/ad sets causent la baisse ?
|
+-- 0 achat COMPTE ENTIER 4 jours (5 si weekend) ?
    → DIAGNOSTIC COMPLET creative-par-creative :
      - Depense > 50 EUR ET 0 ATC → KILL
      - Depense > 15 EUR ET 0 ATC → KILL (si CTR > 8%)
      - Depense < 10 EUR → FAMINE, pas testee
      - ATC > 0 mais 0 achat → probleme post-ATC, investiguer
    → Notifier Stratege + Sparky + Marty IMMEDIATEMENT
    → Override : ROAS < 0,3x sur 2 jours → meme diagnostic sans attendre 4j
```

---

# 7. TEMPLATES RAPPORTS

## 7.1 Rapport QUOTIDIEN (Marty via Sparky)

```
================================================================
RAPPORT META ADS QUOTIDIEN — [DATE]
================================================================

## CHIFFRES DU JOUR (24h)
| Metrique | Valeur | vs hier | vs moyenne 7j | Statut |
|----------|--------|---------|---------------|--------|
| Depense | X EUR | +/-Y% | +/-Z% | VERT/ORANGE/ROUGE |
| Achats | X | | | |
| CA | X EUR | | | |
| ROAS | Xx | | | |
| CPA | X EUR | | | |
| Frequence max | X | | | |

## ETAT DES AD SETS
[Tableau par ad set : budget, depense, achats, ROAS, CPA, freq, nb creatives actives]

## ALERTES / RECOMMANDATIONS
- [Alerte 1 : description, impact, action recommandee, validation requise]
- [Recommandation kill : creative X (ID), depense Y EUR, 0 achat, >=5j ligne — PAUSE demande]
- [Recommandation scale : creative Z, ROAS 12x, signaler Stratege]

## PIPELINE CREATIF
- Creatives actives avec achats : X (seuil : >=3)
- Si < 3 : besoin urgent creatives → Forge + Stratege

## ACTIONS EXECUTEES (validation Marty obtenue)
- [Action 1]

================================================================
```

## 7.2 Rapport HEBDOMADAIRE — Resume (Marty via Sparky)

```
================================================================
RAPPORT HEBDOMADAIRE META ADS — S[NN] [YYYY]
================================================================

## COMPARATIF SEMAINE
| Metrique | Sem. precedente | Cette semaine | Evolution |
|----------|----------------|---------------|-----------|
| Depense | X EUR | X EUR | +X% ou -X% |
| Achats | X | X | |
| CA | X EUR | X EUR | |
| ROAS | Xx | Xx | |
| CPA | X EUR | X EUR | |

## TOP 3 CREATIVES DE LA SEMAINE
| Rank | Nom creative | ROAS | CPA | Depense | Achats | Format | Angle |
|------|-------------|------|-----|---------|--------|--------|-------|
| 1 | ... | Xx | X EUR | X EUR | X | Breaking News | Event eruption |

## FLOP DE LA SEMAINE
| Nom creative | Depense | 0 achat ? | Learning encode |
|-------------|---------|-----------|----------------|

## STRUCTURE REEL vs CIBLE COUDAC (60/30/10)
| Ad Set | Part reelle | Cible | Ecart |
|--------|------------|-------|-------|

## PLAN D'ACTIONS SEMAINE S+1
- [Recommandation Stratege 1]
- [Recommandation Atlas 1 a valider]

================================================================
```

## 7.3 Rapport HEBDOMADAIRE — Data (Stratege)

Extension du rapport Marty, avec en plus :

```
## METRIQUES PAR AD SET (7j)
[Tableau detaille]

## METRIQUES PAR CREATIVE (7j)
[Tableau detaille — toutes creatives, actives et pausees cette semaine]

## KILL RULES DECLENCHEES CETTE SEMAINE
[Liste]

## SIGNAUX DE SCALING DETECTES
[Liste]

## PIPELINE CREATIF : ETAT
- Actives avec achats : X
- En test : X
- Famine detectee : X
- V2 Breaking News requis : [liste]

## ENTONNOIR DE CONVERSION PAR AD SET (7j)
[Tableau LPV → VC → ATC → IC → Purchase]

## ANOMALIES DETECTEES
[Liste + diagnostic]
```

## 7.4 Bilan MENSUEL (Marty via Sparky)

```
================================================================
BILAN META ADS — [MOIS ANNEE]
================================================================

## CHIFFRES DU MOIS
| Metrique | Mois precedent | Ce mois | Evolution | Cible |
|----------|---------------|---------|-----------|-------|
| Depense totale | | | | |
| Achats | | | | |
| CA genere Meta | | | | |
| ROAS global | | | >3x | |
| CPA moyen | | | <28 EUR | |
| Frequence max | | | <3 | |
| Budget perdu (creatives 0 achat) | | | <25% | |
| Nb creatives actives avec achats | | | >=3 | |

## TOP 5 CREATIVES DU MOIS
[Nom, ROAS, CPA, depense, achats, format, angle, persona]

## FLOP 5 CREATIVES DU MOIS (+ learnings encodes)
[Nom, depense, ROAS, format, angle, raison du flop, learning]

## STRUCTURE : REEL vs CIBLE COUDAC (evolution sur le mois)
## CAMPAGNES SAISONNIERES : BILAN
## ANOMALIES ET INCIDENTS DU MOIS
## RECOMMANDATIONS STRATEGIQUES M+1 (du Stratege, executees par Atlas)

================================================================
```

---

# 8. REGLES D'OR NON-NEGOCIABLES

## 8.1 Les 3 regles d'or operationnelles

> **REGLE D'OR n1 — PROTECTION D'AGE MINIMUM**
> Aucune creative ne peut etre tuee avant **5 jours complets** en ligne.
> Seule exception : CTR > 8% avec 0 conversion = kill immediate (trafic poubelle).

> **REGLE D'OR n2 — JAMAIS DE PAUSE D'AD SET**
> On ne met **JAMAIS** un ad set entier en pause. Les kill rules s'appliquent aux creatives individuelles.
> Si toutes les creatives d'un ad set sont pausees, l'ad set s'arrete naturellement.

> **REGLE D'OR n3 — NE JAMAIS SACRIFIER UN WINNER POUR UN TEST**
> Budgets ad sets separes (ABO). On ne coupe **JAMAIS** une creative performante dans B
> pour liberer du budget test dans C. Si budget test insuffisant → demander a Marty d'augmenter.

## 8.2 Les 12 regles Coudac (reference synthese)

| # | Regle | Application Atlas |
|---|-------|-------------------|
| 1 | La crea = le ciblage | Broad : la creative determine qui voit la pub. Pas d'interets superflus |
| 2 | MER et COS > ROAS | MER = verite globale. COS = garde-fou |
| 3 | Kill rule : ~1,8x CPA sans conversion | 50 EUR ou 2x CPA target. Sous 50 EUR = famine = invalide |
| 4 | Scaling +20% max/jour | Jamais doubler. Paliers 20%, 3-5j entre chaque. Validation Marty |
| 5 | Frequence max 3 | Rafraichir AVANT freq > 2,5 = creer 2-3 variantes immediatement |
| 6 | Laisser tourner 5-7 jours | Aucune conclusion avant J5. Max 14j |
| 7 | Retargeting = tonneau perce | Budget = 0 tant que trafic < 5 000 visiteurs/mois |
| 8 | Hyperconsolidation | < 3 000 EUR/mois : 1 campagne, 2-3 ad sets max |
| 9 | Produit visible des la 1ere seconde | Pas de teasing, pas de build-up |
| 10 | Production continue | 3-5 nouvelles creatives/semaine, pas de gros batch |
| 11 | Tester, mesurer, iterer | Hypotheses formalisees, testees >=5j, encodees en learnings |
| 12 | Les donnees pilotent | Jamais l'intuition. Chiffres Atlas > hypothese |

## 8.3 Regles de validation budget (flux decisionnaire)

```
STRATEGE analyse data (recues d'Atlas)
  |
  +-- STRATEGE decide allocation cible (ex: "passer A de 36 a 42 EUR")
      |
      +-- STRATEGE envoie instruction a ATLAS
          |
          +-- ATLAS formule recommandation pour MARTY
              |
              +-- MARTY valide → ATLAS execute
              +-- MARTY refuse → ATLAS notifie STRATEGE
```

- Atlas ne decide **plus** de l'allocation budgetaire. Il execute apres validation Marty.
- TOUTE modification de budget (baisse, hausse, kill, scale) = validation Marty ou Jonathan.
- Au-dessus de 100 EUR/jour = validation Marty ou Jonathan obligatoire (pas d'autonomie).

---

*Reference Performance Meta Ads — a consulter avant tout kill, scale ou alerte budget.*
