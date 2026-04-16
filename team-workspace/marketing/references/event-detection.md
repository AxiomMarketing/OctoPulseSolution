# Detection d'Events — Reference Exploitation Paid

> Document de reference partage par Radar, Scout-Actu, Scout-Tendances, Calendar, Stratege, Forge, Maeva-Director, Keeper. Contient la typologie des events exploitables pour Univile, les lead-times standard (J-45/J-30/J-14), la matrice event x format creatif recommande, les exemples d'events passes avec performance obtenue, et la checklist go/no-go.

**Derniere mise a jour :** 2026-04-13
**Mainteneur :** Radar (Master Intelligence)
**Reference methodologique :** SOUL-radar sections 3, 10, 22 + learnings Univile L1-L10

---

## TABLE DES MATIERES

1. [Pourquoi l'event-driven est le flux le plus rentable](#1-pourquoi-levent-driven-est-le-flux-le-plus-rentable)
2. [Typologie des events exploitables](#2-typologie-des-events-exploitables)
3. [Lead-times standard J-45 / J-30 / J-14](#3-lead-times-standard-j-45--j-30--j-14)
4. [Matrice event x format creatif](#4-matrice-event-x-format-creatif)
5. [Historique events + performance](#5-historique-events--performance)
6. [Workflow detection → creative en ligne](#6-workflow-detection--creative-en-ligne)
7. [Checklist go/no-go pour actionner un event](#7-checklist-gono-go-pour-actionner-un-event)
8. [Signaux precurseurs a surveiller](#8-signaux-precurseurs-a-surveiller)
9. [Erosion predictible et variantes V2](#9-erosion-predictible-et-variantes-v2)
10. [Events a NE JAMAIS actionner](#10-events-a-ne-jamais-actionner)

---

## 1. POURQUOI L'EVENT-DRIVEN EST LE FLUX LE PLUS RENTABLE

### 1.1 Chiffres de reference

- **CPM event-driven :** 1,63 EUR (eruption Piton 2026)
- **CPM benchmark hors event :** 8-15 EUR
- **Division CPM :** x5 a x10 grace a l'event
- **ROAS Breaking News eruption :** 23,5x
- **CTR Breaking News eruption :** 9,58%
- **Ratio event-driven / creative classique :** Breaking News = CHAMPION A L'ECHELLE

### 1.2 Pourquoi ca marche (learnings L1-L10)

- **L1** — Breaking News bypass les defenses anti-pub (mimetisme editorial)
- **L2** — Event-driven divise le CPM par 5-10x (eruption 1,63 EUR vs 8-15 EUR)
- **L3** — Flash Info marche SANS event reel (Sakura ROAS 10,19x avec event cree artificiellement)
- **L4** — Produit DOIT etre visible des la 1ere seconde
- **L7** — Erosion Breaking News est previsible (J1 : 32x → J2 : 23x → J3 : 7x) → preparer V2 avant CTR < 5%

### 1.3 Implications strategiques

1. **Detection rapide est critique** — chaque heure de retard = opportunite perdue
2. **Pas de perfection, mais vitesse** — 80% en 4h > 100% en 48h
3. **Budget test faible suffit** — 10-15 EUR/j genere un ROAS > 10x en event CRITICAL
4. **Erosion gere par rotation** — preparer V2 apres 48-72h, pas plus tard

---

## 2. TYPOLOGIE DES EVENTS EXPLOITABLES

### 2.1 NATURELS (fenetre 0-24h, score 5 automatique souvent)

| Event | Frequence | Exemples | Score typique |
|-------|-----------|----------|---------------|
| **Eruption volcanique** | 1-3/an (Piton), aleatoire ailleurs | Piton Fournaise, Montagne Pelee, La Soufriere | 22-25 |
| **Aurore boreale** | Saisonnier (Islande, Nord) | Non-catalogue Univile (tangentiel) | 8-12 |
| **Phenomene marin spectaculaire** | Saisonnier | Baleines (Reunion juin-octobre), marees exceptionnelles | 15-20 |
| **Meteo exceptionnelle** | Aleatoire | Neige historique, tempete non destructrice | 10-18 |
| **Floraison / saison** | Annuelle | Sakura (mars-avril), lavande (juin-juillet), momiji (oct-nov) | 18-22 |

**Regle de detection :** alerte immediate Scout-Actu directe en /_alertes/ pour eruption / cyclone cat 3+ / buzz > 500k.

### 2.2 SAISONNIERS (fenetre J-14 a J-1, predictible)

| Event | Periode | Score typique | Persona |
|-------|---------|---------------|---------|
| **Sakura Japon** | Mars-avril | 22-25 | Julien |
| **Saison baleines Reunion** | Juin-octobre | 15-18 | Marie + Christiane |
| **Lavande Provence** | Juin-juillet | 18-22 | Julien |
| **Momiji Japon** | Octobre-novembre | 18-22 | Julien |
| **Automne France** | Octobre-novembre | 12-15 | Julien |
| **Premiere neige Hokkaido** | Decembre-fevrier | 12-16 | Julien |
| **Solstices / equinoxes** | 4/an | 8-12 | Tous (poesie) |

### 2.3 CULTURELS (fenetre J-7 a J+1)

| Event | Exemples | Score typique | Persona |
|-------|----------|---------------|---------|
| **Classement UNESCO** | Nouveau site inscrit | 20-24 | Multi-persona |
| **Film/serie majeur** | Netflix, Amazon sur destination catalogue | 15-20 | Marie + Julien |
| **Festival local** | Sakifo, Gwo Ka, Kreol | 10-15 | Marie local |
| **Fete culturelle** | Fete Cafre, Dipavali, Cavadee | 12-18 | Marie + Christiane |
| **Anniversaire historique** | 50 ans d'un site, commemoration | 10-14 | Variable |

### 2.4 SPORTIFS (fenetre J-3 a J+1)

| Event | Exemples | Score typique |
|-------|----------|---------------|
| **Diagonale des Fous** | Octobre Reunion | 18-22 |
| **Marathon du Morne** | Septembre Maurice | 14-18 |
| **Tour des Yoles** | Juillet-aout Martinique | 14-18 |
| **Route du Rhum** | Tous les 4 ans, arrivee Pointe-a-Pitre | 16-20 |
| **Tour de France (etapes paysageres)** | Juillet | Variable (8-14) |
| **JO** | 2/an | Haut si lieu catalogue |

### 2.5 BUZZ VIRAL (fenetre 0-12h !)

| Trigger | Seuil | Score | Action |
|---------|-------|-------|--------|
| **Video virale lieu catalogue** | > 500k vues en 24h | 20-25 | Breaking News < 4h |
| **Video virale lieu catalogue** | 100k-500k vues | 15-20 | Flash Info < 12h |
| **Post Reddit/Instagram viral** | > 50k engagements | 12-18 | Hypothese test |
| **Celebrite dans lieu catalogue** | Celebrite majeure | 15-22 | Selon contexte |
| **Meme internet lieu catalogue** | Viral | 10-15 | A evaluer (tonalite) |

### 2.6 CONCURRENCE (fenetre 24-72h, reaction differee)

| Trigger | Score | Action |
|---------|-------|--------|
| **Promo massive concurrent > 40%** | 10-14 | Pas de reaction prix. Email Keeper differenciation. |
| **Nouvelle collection concurrent sur territoire Univile** | 15-18 | Alerte Stratege, renforcer specificite |
| **Changement positionnement majeur** | 12-16 | Analyse approfondie (thinking Opus) |

### 2.7 COMMERCIAUX / PLANIFIES (fenetre J-45 a J-1)

| Event | Date 2026 | Importance | Lead time complet |
|-------|-----------|------------|-------------------|
| **Saint-Valentin** | 14 fevrier | MOYENNE | J-45 = 31 dec |
| **Paques** | 5-6 avril | FAIBLE-MOYENNE | J-45 = 19 fev |
| **Fete des Meres** | 25 mai | HAUTE (PIC) | J-45 = 10 avril |
| **Fete des Peres** | 21 juin | MOYENNE | J-45 = 7 mai |
| **Rentree** | 1 septembre | HAUTE | J-45 = 17 juillet |
| **Black Friday** | 27 novembre | TRES HAUTE (PIC) | J-45 = 13 octobre |
| **Cyber Monday** | 30 novembre | HAUTE | J-45 = 16 octobre |
| **Noel** | 25 decembre | TRES HAUTE (PIC) | J-45 = 10 novembre |

---

## 3. LEAD-TIMES STANDARD J-45 / J-30 / J-14

### 3.1 J-45 — Meta Ads

**Qui :** Stratege + Forge
**Quoi :** preparation campagne, production creatives, tests hypotheses
**Pourquoi ce delai :** phase learning algo Meta + iterations creatives + tests preliminaires

**Activites J-45 :**
- Briefing creatif Forge (format, angle, persona)
- Production 5-8 visuels (test A/B/C)
- Declinaisons obligatoires : 1:1, 4:5, 9:16
- Validation regles Univile (cadres, mockups, lumiere)
- Configuration campagne Meta (ad sets, audiences, budgets)

**Livrable :** creatives + campagne pretes a lancer a J-30.

### 3.2 J-30 — Contenu organique

**Qui :** Maeva-Director + Forge
**Quoi :** calendrier editorial, posts Instagram/Pinterest/TikTok, briefs rédactionnels
**Pourquoi ce delai :** reserve pour production contenu + planning publications

**Activites J-30 :**
- Definition calendrier editorial (J-30 a J+3)
- Production visuels organiques
- Redaction captions et copywriting
- Programmation dans Meta Business Suite / Pinterest
- Creation assets Pinterest (boards thematiques)

**Livrable :** calendrier organique complete a J-14.

### 3.3 J-14 — Email sequences

**Qui :** Keeper
**Quoi :** sequences email Klaviyo, segmentation, copies
**Pourquoi ce delai :** reserve pour configuration + tests deliverability

**Activites J-14 :**
- Definition segments cibles (Marie, Julien, Christiane, segments custom)
- Redaction sequences (3-5 emails typiquement)
- Design templates Klaviyo
- Configuration triggers et flows
- A/B test sujets emails
- Tests deliverability (warm-up S1-S5 deja en cours)

**Livrable :** sequences programmees a J-7, envoi progressif J-10 a J+1.

### 3.4 J-7 — Derniers ajustements

**Qui :** Stratege + Forge + Maeva + Keeper
**Quoi :** derniers ajustements, monitoring precoce, rafraichissement
**Activites :** push final, rafraichissement creatives si fatigue, montee budgets vers PIC.

### 3.5 J-0 — Jour event

**Monitoring intensif :** ROAS heure par heure, CPM, CTR, frequence. Adjuster budget +/- selon performance.

### 3.6 Synthese visuelle

```
J-45 ──────────── J-30 ──────────── J-14 ──────────── J-7 ──────────── J-0 ──────── J+X
 |                  |                 |                 |                 |
 Stratege+Forge    Maeva+Forge       Keeper            Tous             EVENT
 Creatives         Contenu org.      Emails            Push final       Monitoring
 Ads pretes        Calendar          Sequences         Budget PIC       ROAS live
```

---

## 4. MATRICE EVENT X FORMAT CREATIF

### 4.1 Regle generale

| Format | ROAS | Quand l'utiliser | Erosion |
|--------|------|-----------------|---------|
| **Breaking News** | 10-23,5x | Event reel imprevisible, < 24h, forte emotion | Erosion J2 (-30%) / J3 (-70%) |
| **Flash Info** | 5-10x | Saisonnier ou culturel, fenetre jours | Erosion J5-7 |
| **Alerte Meteo** | 5-8x | Phenomene climatique destination | Erosion J3-5 |
| **Edition Speciale** | 4-8x | Event planifie, anticipation | Erosion J10-14 |
| **Carrousel Avant/Apres** | 69x (CHAMPION) | Transformation espace, theme saisonnier | Lente |
| **Mockup Statique** | 3,42-27x (WORKHORSE) | Quotidien, production continue | Lente |
| **Carrousel Multi-lieux** | 1,14x | Collection discovery, Marie | Moyenne |

### 4.2 Matrice detaillee

| Type event | Format #1 | Format #2 (V2) | Angle dominant | Persona |
|------------|-----------|----------------|----------------|---------|
| Eruption volcan | Breaking News | Flash Info poetique | Fierte | Marie+Christiane+Julien |
| Saison Sakura | Flash Info | Mockup saisonnier | Poesie / FOMO | Julien |
| Saison baleines | Alerte Meteo | Mockup Reunion | Poesie | Marie+Christiane |
| Classement UNESCO | Edition Speciale | Breaking News | Fierte | Multi |
| Film/serie annonce | Edition Speciale | Flash Info | Decouverte | Marie+Julien |
| Festival local | Flash Info | Mockup | Fierte | Marie local |
| Diagonale des Fous | Edition Speciale | Flash Info | Fierte/exploit | Christiane+Julien |
| Buzz viral | Breaking News | — | FOMO | Variable |
| Fete des Meres | Edition Speciale | Mockup cadeau | Cadeau | Marie+Julien |
| Fete des Peres | Edition Speciale | Mockup cadeau | Cadeau | Marie+Julien |
| Black Friday | Edition Speciale bundle | Carrousel collection | Collection/bulk | Tous |
| Noel | Edition Speciale cadeau | Mockup famille | Cadeau | Tous |
| Rentree | Avant/Apres | Edition Speciale | Transformation | Julien |

### 4.3 Declinaisons obligatoires pour chaque creative (rappel)

- **1:1** (1080x1080) — Feed
- **4:5** (1080x1350) — Mobile
- **9:16** (1080x1920) — Stories

**Regle :** pas de creative sans les 3 declinaisons. Perte de reach Meta sinon.

---

## 5. HISTORIQUE EVENTS + PERFORMANCE

### 5.1 Events reels — Performances obtenues

| Event | Date | Format | ROAS | CTR | CPM | Budget test | Duree |
|-------|------|--------|------|-----|-----|-------------|-------|
| **Eruption Piton Fournaise** | Mars 2026 | Breaking News | **23,5x** | **9,58%** | **1,63 EUR** | 15 EUR/j | ~3 semaines |
| **Sakura Flash Info (event cree)** | Mars-avril 2026 | Flash Info | **10,19x** | nc | nc | ~10 EUR/j | ~3 semaines |
| **Carrousel Avant/Apres** | Test (pas a l'echelle) | Carrousel | **69x** | nc | nc | Faible | Variable |
| **Cadeau emotionnel (workhorse)** | Recurrent | Statique Mockup | **3,42x** | nc | 17,44 EUR CPA | Continu | Continu |
| **Nostalgie/fierte Reunion** | Recurrent | Multi-formats | **1,14x** | nc | 33 EUR CPA | Continu | CPA trop eleve |

### 5.2 Learnings operationnels

- **L7 erosion previsible :** Breaking News eruption J1 : 32x → J2 : 23x → J3 : 7x. Preparer V2 AVANT CTR < 5%.
- **L9 ad set B porte 100% des ventes** : A (Broad) et C (Test) jamais testes correctement. Ne pas conclure prematurement.
- **L10 famine :** creatives < 10 EUR/7j = jamais testees (Meta les ignore). Ne pas conclure sur creative ignoree.

### 5.3 Events a venir (candidats haute valeur)

| Event | Date 2026 | Score paid anticipation | Preparation |
|-------|-----------|-------------------------|-------------|
| Fete des Meres | 25 mai | 18-22 | EN COURS (creatives prep) |
| Saison baleines Reunion | Juin-octobre | 15-18 | A preparer |
| Diagonale des Fous | Mi-octobre | 18-22 | A preparer septembre |
| Fete Cafre | 20 decembre | 20-24 | A preparer novembre |
| Noel | 25 decembre | 22-25 | Preparation octobre |
| Prochain event imprevu | Aleatoire | 20-25 potentiel | Etat de veille permanent |

---

## 6. WORKFLOW DETECTION → CREATIVE EN LIGNE

### 6.1 Workflow event reel imprevu (< 4h)

```
T=0  Scout-Actu detecte event (eruption, buzz > 500k, etc.)
     |
T+5  Scout-Actu ecrit alerte en /_alertes/ (bypass Radar)
     |
T+10 Sparky detecte fichier, spawn Radar avec contexte
     |
T+20 Radar ouvre Opus thinking :
     - Analyse impact
     - Scoring paid /25
     - Recommandation creative (format, angle, produit, headline)
     - Go/No-go
     |
T+30 Radar ecrit alerte enrichie /_alertes/
     Envoi DIRECT :
     - Stratege (hypothese budget)
     - Forge (brief creative)
     - Maeva-Director (si organique)
     - Keeper (si segment)
     CC Sparky obligatoire
     |
T+45 Forge lance production express :
     - Visuel principal
     - Declinaisons 1:1 / 4:5 / 9:16
     - Headline + fait marquant
     |
T+2h Forge livre creatives
     |
T+2h30 Stratege configure campagne Meta :
     - Ad set Test (nouveau ou existant)
     - Budget test 10-15 EUR/j
     - Audiences pertinentes
     |
T+3h Creative en revue finale (regles Univile)
     |
T+4h CREATIVE EN LIGNE
     |
T+4h Monitoring initial (heure par heure 24h)
T+24h Evaluation : scaler +20% si ROAS > seuil, ou kill
T+48h V2 preparee par Forge (erosion previsible)
T+72h V2 en ligne si J3 < 5% CTR
```

### 6.2 Workflow event saisonnier (J-14 a J-7)

```
J-14 Radar alerte lead time atteint (via Calendar)
     |
J-14 Stratege valide hypothese, budget, format
J-14 Forge recoit brief detaille
     |
J-10 Forge livre creatives (5-8 variantes)
J-10 Keeper prepare sequences email
J-10 Maeva prepare contenu organique
     |
J-7  Pre-launch :
     - Test creative en Ad Set Test (10 EUR/j)
     - Emails warm-up segment
     - Posts organiques teasing
     |
J-3  Push budget Stratege (selon perf test)
J-3  Emails campagne lancee
     |
J-0  PIC : budget max, monitoring intensif
J+1  Decroissance progressive
J+3  Retour budget normal
```

### 6.3 Workflow fete commerciale majeure (J-45 a J-0)

```
J-45 Stratege + Forge : production creatives (5-8 visuels)
J-45 Declinaisons obligatoires
     |
J-30 Maeva : calendrier organique
J-30 Forge : validation creatives finales
     |
J-14 Keeper : sequences email prep
J-14 Stratege : configuration campagne complete
     |
J-7 Push final :
    - Email warm-up
    - Scaling budget progressif
    - Organique teasing
     |
J-3 PIC preparation :
    - Email derniere chance
    - Creatives urgence ("plus que X jours")
    - Budget max
     |
J-0 EVENT : monitoring intense
J+1 Decroissance rapide, retour budget normal
```

---

## 7. CHECKLIST GO/NO-GO POUR ACTIONNER UN EVENT

### 7.1 Checklist obligatoire

Avant d'actionner un event, verifier TOUS les points suivants :

- [ ] **Pertinence destination** — L'event concerne-t-il une destination du catalogue Univile ?
- [ ] **Produit catalogue** — Avons-nous au moins 1 produit directement lie ?
- [ ] **Persona cible** — Au moins 1 persona Univile est-il touche ?
- [ ] **Score paid >= 15** — L'event atteint-il le seuil HIGH (voir scoring-insights-paid.md) ?
- [ ] **Fenetre realiste** — Le lead time permet-il de produire une creative a temps ?
- [ ] **Tonalite appropriee** — L'event est-il commercialement exploitable sans risque ethique ?
- [ ] **Cadres regle Univile** — Mockups chaleureux (pas scandinave froid) + cadres noir/blanc/bois ?
- [ ] **Test journaliste** — "Univile profite de X" — est-ce defendable ?
- [ ] **Budget disponible** — Stratege peut-il allouer 5-15 EUR/j sans casser budget actuel ?
- [ ] **Capacite Forge** — Forge peut-il produire dans le delai ?

Si **tous** les points sont OK → **GO**.
Si **1 point rouge** (NO-GO absolu, voir section 10) → **NO-GO** immediat.
Si **1-2 points orange** → **GO AVEC PRECAUTION** + escalade Sparky.

### 7.2 Matrice decision rapide

| Situation | Verdict |
|-----------|---------|
| Event naturel Reunion + pas de victime + produit catalogue + score paid 20+ | **GO CRITICAL** |
| Buzz viral 500k+ lieu catalogue + tonalite positive | **GO CRITICAL** |
| Classement UNESCO lieu catalogue | **GO CRITICAL** |
| Saison Sakura + produit catalogue | **GO HIGH** |
| Film annonce destination catalogue | **GO HIGH** |
| Festival local destination catalogue | **GO MEDIUM** |
| Promo concurrent -40% | **NO-GO sur prix, GO Keeper differenciation** |
| Catastrophe avec victimes destination catalogue | **NO-GO absolu** |
| Event non lie au catalogue | **NO-GO (pas pertinent)** |
| Sujet memoire sensible (esclavage, chlordecone, Fukushima) | **NO-GO absolu** |

---

## 8. SIGNAUX PRECURSEURS A SURVEILLER

### 8.1 Signaux precurseurs eruption Piton de la Fournaise

- **Activite sismique** (requete Scout-Actu : "piton fournaise activite sismique")
- **Deformations OVPF** (Observatoire Volcanologique du Piton)
- **Alerte vigilance prefecture Reunion**
- **Trafic augmente sur sites info Reunion**

**Action :** passer veille quotidienne → horaire pendant periode precurseur.

### 8.2 Signaux precurseurs cyclone

- **Alertes Meteo France OI**
- **Nom de tempete attribue (liste annuelle)**
- **Trajectoire prediction > 100 km destination catalogue**

**Action :** passer en alerte A_EVITER potentielle, preparer suspension campagnes.

### 8.3 Signaux precurseurs buzz viral

- **Post TikTok lieu catalogue avec montee rapide (+100k/24h)**
- **Mention lieu dans trending Twitter/X**
- **Reprise par media grand public**

**Action :** Scout-Actu intensifie monitoring, alerte Radar si > 100k vues en 24h.

### 8.4 Signaux precurseurs tendance deco

- **Hausse > 50% recherche Pinterest sur 30j**
- **Mention repetee par 3+ blogs deco majeurs**
- **Apparition dans newsletters Juniqe / Architectural Digest**

**Action :** Scout-Tendances integre dans rapport hebdo, evaluer angle paid Stratege.

### 8.5 Signaux precurseurs concurrence

- **Changement visible sur page d'accueil concurrent**
- **Newsletter annoncant nouveaute**
- **Posts Instagram/FB indiquant "bientot disponible"**
- **Baisse/hausse significative activite Meta ads**

---

## 9. EROSION PREDICTIBLE ET VARIANTES V2

### 9.1 Pattern d'erosion Breaking News (L7)

| Jour | CTR relatif | ROAS relatif | Action |
|------|-------------|--------------|--------|
| J1 | 100% (ex 9,58%) | 100% (23,5x) | Scaling +20% si budget |
| J2 | 70% | 70% (16x) | Preparer V2 |
| J3 | 30-40% | 30% (7x) | V2 EN LIGNE |
| J4+ | < 20% | < 20% | Kill V1, V2 porte |

**Regle :** apres 48h sur event reel, commencer production V2 systematiquement. Ne pas attendre l'erosion visible.

### 9.2 V2 — Angles de rotation

| Event | V1 | V2 | V3 (si longue duree) |
|-------|-----|-----|----------------------|
| Eruption volcan | Breaking News pur (photo brute) | Flash Info poetique (vue d'artiste) | Mockup salon "La Reunion vit" |
| Saison Sakura | Flash Info annonce | Carrousel lieux Japon | Mockup cadeau "poesie Sakura" |
| UNESCO | Edition Speciale annonce | Fierte locale Marie + Christiane | Mockup patrimoine |
| Buzz viral | Breaking News reactif | Contextualisation / explication | Profondeur (making-of, storytelling) |

### 9.3 Regle production continue (COUDAC #10)

3-5 nouvelles creatives par semaine. Pas de gros batch. L'event est l'occasion d'intensifier, pas de debuter.

---

## 10. EVENTS A NE JAMAIS ACTIONNER

### 10.1 NO-GO absolu (section SOUL-radar 3)

- **Catastrophe avec victimes** (cyclone destructeur, eruption destructrice, seisme mortel)
- **Evenement politique controverse** (elections, manifestations violentes)
- **Tragedie humaine** (accident majeur, drame personnel)
- **Terrorisme** (aucune recuperation possible)
- **Tout evenement ou le marketing serait percu comme "profiteering"**

### 10.2 NO-GO pour Univile specifiquement

- **Sujets memoires sensibles** :
  - Esclavage (Abolition 22 mai / 27 mai / 20 decembre) — post organique respectueux seulement, pas de promo
  - Chlordecone (Antilles) — JAMAIS evoque
  - Fukushima (Japon) — JAMAIS evoque
  - Maree noire Wakashio (Maurice) — reference passee sensible

- **Sujets politiques DOM-TOM** :
  - Vie chere / manifestations
  - Tensions communautaires
  - Indépendantisme / autonomie

- **Tendances hors ADN Univile** :
  - Deco industrielle metal (contradictoire cadres bois/noir/blanc)
  - Scandinave froid (contradictoire lumiere chaleureuse Univile)
  - Fan art / licences tierces (contradictoire specialite "lieux significatifs")

### 10.3 Test final

Avant chaque event : **"Est-ce que Marty / Jonathan seraient gene-s si cette publicite etait screenshot-ee et partagee en mal ?"**

Si OUI → NO-GO.
Si NON → GO.

---

*Document de reference — OctoPulse / Univile — mainteneur Radar*
*MAJ : ajout d'events historiques et nouveaux learnings apres chaque cycle*
