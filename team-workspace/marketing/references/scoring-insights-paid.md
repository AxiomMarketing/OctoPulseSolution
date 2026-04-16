# Scoring Insights Paid — Framework Detaille /25

> Document de reference partage par Radar, Scout-Actu, Scout-Tendances, Stratege. Contient le framework complet de scoring des insights orientes paid : grille 5 criteres x 5 points = /25, format JSON standardise, exemples concrets d'insights haute valeur vs bruit, procedure d'evaluation.

**Derniere mise a jour :** 2026-04-13
**Mainteneur :** Radar (Master Intelligence)
**Consommateur principal :** Stratege
**Source methodologique :** SOUL-radar section 10 + learnings Univile L1-L10

---

## TABLE DES MATIERES

1. [Pourquoi un scoring standardise](#1-pourquoi-un-scoring-standardise)
2. [Les 5 criteres de scoring](#2-les-5-criteres-de-scoring)
3. [Grille detaillee par critere](#3-grille-detaillee-par-critere)
4. [Score total et action Stratege](#4-score-total-et-action-stratege)
5. [Format d'insight standardise JSON](#5-format-dinsight-standardise-json)
6. [Exemples d'insights HAUTE VALEUR (20-25)](#6-exemples-dinsights-haute-valeur-20-25)
7. [Exemples d'insights MOYENNE VALEUR (15-19)](#7-exemples-dinsights-moyenne-valeur-15-19)
8. [Exemples d'insights FAIBLE VALEUR (10-14)](#8-exemples-dinsights-faible-valeur-10-14)
9. [Exemples de BRUIT a rejeter (< 10)](#9-exemples-de-bruit-a-rejeter--10)
10. [Procedure d'evaluation](#10-procedure-devaluation)
11. [Anti-patterns et pieges](#11-anti-patterns-et-pieges)

---

## 1. POURQUOI UN SCORING STANDARDISE

### 1.1 Probleme identifie (audit systeme)

> "Radar produit de l'intelligence que personne ne transforme en strategie. Les insights concurrentiels sont documentes mais aucun agent ne les transforme en actions paid. Pipeline qui fuit."

### 1.2 Objectif du scoring

1. **Quantifier la valeur paid** de chaque insight (pas de "je pense que c'est important")
2. **Trier automatiquement** les insights : CRITICAL / HIGH / MEDIUM / LOW
3. **Lier scoring a une action concrete** Stratege (budget, format, deadline)
4. **Filtrer le bruit** : 90% des signaux n'atteignent pas le seuil d'action

### 1.3 Consequence si pas de scoring

- Stratege submerge d'insights non prioritises
- Temps perdu a re-evaluer chaque signal
- Risque de rater les opportunites CRITICAL dans le bruit
- Pas de feedback loop (impossible de mesurer qualite Radar)

---

## 2. LES 5 CRITERES DE SCORING

Chaque insight est note sur 5 dimensions independantes, de 1 a 5 points, pour un total sur 25.

| # | Critere | Question |
|---|---------|----------|
| 1 | **Potentiel Breaking News** | Cet event peut-il generer une creative Breaking News performante ? |
| 2 | **Fenetre de reaction** | Combien de temps avant que l'opportunite disparaisse ? |
| 3 | **Persona cible** | Quel persona Univile est impacte, et combien ? |
| 4 | **Produit Univile** | A-t-on un produit catalogue directement lie ? |
| 5 | **Charge emotionnelle** | Quelle intensite emotionnelle l'event genere-t-il ? |

---

## 3. GRILLE DETAILLEE PAR CRITERE

### 3.1 Critere 1 — Potentiel Breaking News

Evalue la capacite de l'event a produire une creative format Breaking News / Flash Info / Edition Speciale performante. Reference historique : Breaking News eruption Piton ROAS 23,5x, CTR 9,58%.

| Score | Definition | Exemples |
|-------|------------|----------|
| **5** | Evident, viral, spectaculaire, media-friendly | Eruption Piton, buzz 500k+ vues lieu catalogue, classement UNESCO |
| **4** | Fort potentiel, accrocheur | Film/serie majeur annonce, saison Sakura, tempete exceptionnelle |
| **3** | Possible avec bon angle creatif | Festival local, saison baleines, tendance deco montante forte |
| **2** | Faible, besoin de travail creatif important | Info touristique generale, saisonnalite douce |
| **1** | Non exploitable en Breaking News | Info contextuelle, statistique, generalite |

**Regle de calibration :** si le fait-marquant ne tient pas dans un titre de 8 mots en majuscules, score <= 2.

### 3.2 Critere 2 — Fenetre de reaction

Evalue le temps disponible avant que l'opportunite perde sa valeur. Plus la fenetre est courte, plus l'urgence (et donc la valeur paid differenciante) est haute.

| Score | Definition | Fenetre | Action attendue |
|-------|------------|---------|-----------------|
| **5** | Heures | < 24h | Creative en ligne < 4h |
| **4** | Quelques jours | 2-7 jours | Creative < 24h |
| **3** | 1-2 semaines | 7-14 jours | Preparation standard |
| **2** | 3-6 semaines | 14-45 jours | Workflow lead time classique |
| **1** | Plus de 6 semaines | > 45 jours | Pas d'urgence |

**Attention :** fenetre trop courte (< 2h) + absence produit catalogue = frustration garantie, score 3 max meme si viral.

### 3.3 Critere 3 — Persona cible

Evalue combien de personas Univile sont touches par l'event et avec quelle intensite. Multi-persona > mono-persona.

| Score | Definition | Exemples |
|-------|------------|----------|
| **5** | Multi-persona (Marie + Julien + Christiane touches) | Eruption Piton (fierte locale + fierte diaspora + FOMO voyage) |
| **4** | 2 personas principaux | Saison Sakura (Julien FOMO + Marie si lien Japon) |
| **3** | 1 persona principal | Fete Cafre (Christiane locale + Marie diaspora) |
| **2** | Persona secondaire uniquement | Tendance deco tres jeune (hors Marie/Julien/Christiane) |
| **1** | Aucun persona clairement touche | Info tangentielle |

**Regle de prudence :** toujours verifier que le persona n'est PAS en famine (ex: Julien = 0 conversion historique, donc toute opportunite Julien vaut son poids d'or).

### 3.4 Critere 4 — Produit Univile

Evalue la correspondance directe avec le catalogue. Sans produit associe, pas de creative exploitable.

| Score | Definition | Exemples |
|-------|------------|----------|
| **5** | Plusieurs produits catalogue + best-sellers | Piton Fournaise (best-seller + Plaine des Sables + Maido) |
| **4** | 2-3 produits catalogue directement lies | Sakura Japon (plusieurs visuels cerisiers) |
| **3** | 1 produit catalogue lie | Festival Sakifo (Saint-Leu dans catalogue) |
| **2** | Lien indirect, catalogue generique correspondant | Tendance deco "tropicale" (catalogue Reunion match) |
| **1** | Aucun produit catalogue lie | Event dans lieu non couvert |

**Regle d'opportunite :** si score 4-5 MAIS produit en famine (jamais teste correctement), surclasser d'1 point — c'est une chance de sortir le produit du placard.

### 3.5 Critere 5 — Charge emotionnelle

Evalue l'intensite emotionnelle mobilisable par l'event. Base neuroscience ads : emotion > cognition pour CTR.

| Score | Definition | Emotions typiques |
|-------|------------|-------------------|
| **5** | Tres forte (fierte, nostalgie profonde, FOMO viral) | Eruption (fierte locale), buzz massif (FOMO) |
| **4** | Forte (emerveillement, poesie, attachement) | Sakura (poesie), baleines (contemplation) |
| **3** | Moyenne (interet, curiosite, decouverte) | Festival culturel, classement touristique |
| **2** | Faible (informatif, neutre) | Statistique tourisme, lancement produit generique |
| **1** | Nulle (administratif, tangentiel) | Changement reglementaire, actu politique non-deco |

**Regle anti-cerebral :** si l'insight necessite 3 lignes d'explication pour etre compris, score <= 2. L'emotion doit etre immediate.

---

## 4. SCORE TOTAL ET ACTION STRATEGE

| Total | Categorie | Action Stratege | Budget test | Format recommande | Timing |
|-------|-----------|-----------------|-------------|-------------------|--------|
| **20-25** | **CRITICAL** | Campagne reactive sous 4h | 10-15 EUR/j | Breaking News | Immediat |
| **15-19** | **HIGH** | Hypothese de test sous 24h | 5-10 EUR/j | Flash Info / Mockup | < 24h |
| **10-14** | **MEDIUM** | Integre prochaine rotation test | 5 EUR/j | Au choix | 3-7j |
| **5-9** | **LOW** | Archive, utiliser si rien de mieux | — | — | — |

### 4.1 Seuils d'action absolus

- **Score >= 20** : obligation de proposer une hypothese Stratege sous 4h (alerte directe Radar → Stratege + CC Sparky)
- **Score 15-19** : integration rapport quotidien + proposition hypothese si budget disponible
- **Score 10-14** : rapport hebdomadaire, utilise en ideation
- **Score < 10** : archive, pas d'envoi

### 4.2 Regle budget

Ne jamais proposer budget > 15 EUR/j en test sur event, meme CRITICAL. L'eruption Piton a atteint ROAS 23,5x a 15 EUR/j — scaling par palier +20% apres validation 5 jours (regle COUDAC #4).

---

## 5. FORMAT D'INSIGHT STANDARDISE JSON

### 5.1 Schema JSON complet

```json
{
  "id": "INS-YYYY-MM-DD-NNN",
  "timestamp": "ISO 8601",
  "type": "event | concurrence | tendance | saisonnalite | tourisme",
  "source_scout": "scout-actu | scout-concurrence | scout-tendances | calendar",
  "titre": "Max 100 caracteres",
  "resume": "2-4 phrases",
  "sources": ["url1", "url2"],

  "scoring_urgence": {
    "score": 1-5,
    "temporalite": 0-2,
    "impact_business": 0-2,
    "actionabilite": -1 a 1
  },

  "scoring_paid": {
    "potentiel_breaking_news": 1-5,
    "fenetre_reaction": 1-5,
    "persona_cible": 1-5,
    "produit_univile": 1-5,
    "charge_emotionnelle": 1-5,
    "score_total": 5-25,
    "categorie": "CRITICAL | HIGH | MEDIUM | LOW"
  },

  "recommandation_creative": {
    "format": "Breaking News | Flash Info | Alerte Meteo | Edition Speciale | Mockup | Carrousel Avant/Apres",
    "variante_visuelle": "description",
    "produits_concernes": ["handle1", "handle2"],
    "angle_emotionnel": "fierte | nostalgie | FOMO | poesie | transformation | cadeau",
    "headline_suggeree": "TITRE EN MAJUSCULES",
    "fait_marquant": "chiffre ou stat impressionnante"
  },

  "section_stratege": {
    "hypothese_test": "formulation exploitable",
    "angle_creatif": "description",
    "persona_cible": ["Marie", "Julien", "Christiane"],
    "budget_test_suggere": "X EUR/j",
    "fenetre_opportunite": {"debut": "date", "fin": "date"},
    "kpi_a_surveiller": "ROAS | CTR | CPC | CPM"
  },

  "go_nogo": {
    "verdict": "GO | GO_AVEC_PRECAUTION | NO_GO",
    "justification": "raison"
  },

  "destinataires": ["stratege", "forge", "maeva-director", "keeper", "nexus"],

  "expire": "YYYY-MM-DD",
  "expire_justification": "raison"
}
```

### 5.2 Regles de remplissage cles

| Champ | Regle |
|-------|-------|
| `id` | Format INS-YYYY-MM-DD-NNN, incrementer dans la journee |
| `type` | Un seul type par insight. Si doublon (event + concurrence), creer 2 insights |
| `sources` | Toujours au moins 1 URL (sauf scan interne) |
| `scoring_paid.score_total` | Somme des 5 sous-scores, entre 5 et 25 |
| `recommandation_creative.headline_suggeree` | 8 mots max, en MAJUSCULES |
| `section_stratege.hypothese_test` | Format "SI [condition], ALORS [action], PARCE QUE [argument]" |
| `expire` | Obligatoire. Voir SOUL-radar section 8 pour regles de calcul |

---

## 6. EXEMPLES D'INSIGHTS HAUTE VALEUR (20-25)

### 6.1 Exemple A — Eruption Piton de la Fournaise (score 25/25)

**Contexte :** 13 mars 2026, phase effusive debute, medias reunionnais couvrent.

| Critere | Score | Justification |
|---------|-------|---------------|
| Potentiel Breaking News | 5 | Phenomene visuel extraordinaire, meta-friendly |
| Fenetre reaction | 5 | < 24h, priorite absolue |
| Persona cible | 5 | Marie + Christiane + Julien (FOMO voyage) |
| Produit Univile | 5 | Piton Fournaise best-seller + Plaine des Sables + Maido |
| Charge emotionnelle | 5 | Fierte extreme, spectacle, FOMO |
| **TOTAL** | **25** | **CRITICAL** |

**Hypothese Stratege :** "SI on lance Breaking News Piton dans les 4h avec headline 'LA REUNION VIT, LE PITON GRONDE', ALORS on atteint ROAS > 10x sur budget 15 EUR/j, PARCE QUE c'est le format historiquement le plus performant (23,5x precedent) et la fenetre emotionnelle est maximale."

Resultat historique : ROAS 23,5x, CTR 9,58%, CPM 1,63 EUR (vs benchmark 8-15 EUR).

### 6.2 Exemple B — Saison Sakura (score 22/25)

**Contexte :** mars 2026, pic floraison predit debut avril.

| Critere | Score | Justification |
|---------|-------|---------------|
| Potentiel Breaking News | 5 | Phenomene ephemere, visuellement iconique |
| Fenetre reaction | 4 | 2-3 semaines de pic |
| Persona cible | 3 | Julien principalement (FOMO voyage) |
| Produit Univile | 5 | Plusieurs visuels cerisiers Japon catalogue |
| Charge emotionnelle | 5 | Poesie, ephemere, FOMO |
| **TOTAL** | **22** | **CRITICAL** |

**Hypothese Stratege :** "SI on lance Flash Info Sakura 'SAKURA 2026 — FLORAISON CONFIRMEE DEBUT AVRIL', ALORS ROAS > 8x sur audience Julien (proprio metro), PARCE QUE Sakura a deja prouve le modele (ROAS 10,19x precedent) et que Julien est en famine — opportunite rare."

Resultat historique : ROAS 10,19x sur event Sakura cree artificiellement (L3).

### 6.3 Exemple C — Classement UNESCO nouveau site Reunion (score 21/25)

**Contexte hypothetique :** UNESCO ajoute les volcans de la Reunion a la liste.

| Critere | Score | Justification |
|---------|-------|---------------|
| Potentiel Breaking News | 5 | Annonce majeure, fierte locale |
| Fenetre reaction | 3 | 1 semaine de pic mediatique |
| Persona cible | 4 | Marie + Christiane (fierte diaspora + locale) |
| Produit Univile | 5 | Catalogue volcans Reunion riche |
| Charge emotionnelle | 4 | Fierte forte |
| **TOTAL** | **21** | **CRITICAL** |

**Hypothese Stratege :** "SI on lance Edition Speciale 'LA REUNION AU PATRIMOINE MONDIAL — UN HONNEUR UNIVERSEL', ALORS ROAS > 8x sur Marie + Christiane, PARCE QUE double persona fierte + confirmation externe de la valeur du territoire."

---

## 7. EXEMPLES D'INSIGHTS MOYENNE VALEUR (15-19)

### 7.1 Exemple D — Diagonale des Fous (score 18/25)

**Contexte :** octobre 2026, trail annuel mi-octobre, couverture media.

| Critere | Score | Justification |
|---------|-------|---------------|
| Potentiel Breaking News | 3 | Event predictible, pas de surprise |
| Fenetre reaction | 3 | 1-2 semaines |
| Persona cible | 4 | Christiane + Marie (fierte locale), Julien (exploit sportif) |
| Produit Univile | 4 | Cirques, paysages Reunion dans catalogue |
| Charge emotionnelle | 4 | Fierte / exploit |
| **TOTAL** | **18** | **HIGH** |

**Hypothese Stratege :** "SI on lance Flash Info 'LA DIAGONALE DES FOUS — QUAND LA REUNION DEVIENT LEGENDE', ALORS ROAS > 4x sur Christiane + Julien, PARCE QUE l'evenement fait converger fierte locale et fascination metropolitaine."

### 7.2 Exemple E — Film Netflix Reunion annonce (score 17/25)

**Contexte :** Netflix annonce une serie documentaire sur l'ocean Indien incluant la Reunion.

| Critere | Score | Justification |
|---------|-------|---------------|
| Potentiel Breaking News | 4 | Annonce media avec portee large |
| Fenetre reaction | 2 | Diffusion dans 3-6 mois (lead time long) |
| Persona cible | 4 | Marie + Julien (decouverte) |
| Produit Univile | 4 | Catalogue Reunion large |
| Charge emotionnelle | 3 | Interet, curiosite |
| **TOTAL** | **17** | **HIGH** |

**Hypothese Stratege :** "SI on prepare un teasing 'LA REUNION FAIT SON CINEMA' avant diffusion, ALORS ROAS > 3x + trafic SEO qualifie lors de la sortie, PARCE QUE la diffusion genera une demande organique qu'on peut capter."

### 7.3 Exemple F — Tendance Pinterest "Coastal grandmother" montante (score 15/25)

**Contexte :** hausse recherches "coastal grandmother" +80% en 30j sur Pinterest.

| Critere | Score | Justification |
|---------|-------|---------------|
| Potentiel Breaking News | 2 | Tendance diffuse, pas d'event |
| Fenetre reaction | 3 | 3-6 mois de montee |
| Persona cible | 4 | Christiane (senior) + Marie (diaspora mer) |
| Produit Univile | 4 | Plages Reunion / Maurice / Antilles matchent |
| Charge emotionnelle | 2 | Esthetique, pas viscerale |
| **TOTAL** | **15** | **HIGH** |

**Hypothese Stratege :** "SI on teste un carrousel 'Coastal grandmother x plages Reunion' sur Christiane, ALORS ROAS > 3x, PARCE QUE Christiane en famine + tendance Pinterest en montee = double opportunite."

---

## 8. EXEMPLES D'INSIGHTS FAIBLE VALEUR (10-14)

### 8.1 Exemple G — Desenio lance promo -30% (score 11/25)

| Critere | Score | Justification |
|---------|-------|---------------|
| Potentiel Breaking News | 2 | Non-exploitable en creative reactive |
| Fenetre reaction | 3 | Promo limitee |
| Persona cible | 2 | Pas de persona direct |
| Produit Univile | 2 | Lien indirect (repositionnement) |
| Charge emotionnelle | 2 | Aucune |
| **TOTAL** | **11** | **MEDIUM** |

**Action :** pas de riposte prix. Note dans rapport hebdo. Email Keeper differenciation si promo > 40%.

### 8.2 Exemple H — Sortie nouvelle palette Pantone (score 10/25)

| Critere | Score | Justification |
|---------|-------|---------------|
| Potentiel Breaking News | 2 | Pas accrocheur |
| Fenetre reaction | 2 | 6 mois influence |
| Persona cible | 2 | Tangentiel |
| Produit Univile | 2 | Influence indirecte |
| Charge emotionnelle | 2 | Faible |
| **TOTAL** | **10** | **MEDIUM** |

**Action :** briefer Forge pour ajustement mockups si cohere avec la saison. Pas d'urgence.

---

## 9. EXEMPLES DE BRUIT A REJETER (< 10)

### 9.1 Actu politique locale

"La collectivite Reunion adopte un nouveau plan de developpement."
- Potentiel BN : 1, Fenetre : 1, Persona : 1, Produit : 1, Emotion : 1 = **5/25 LOW**
- **Action :** ignorer, ne pas meme creer d'insight.

### 9.2 Tendance deco hors ADN Univile

"Deco industrielle metal en forte hausse sur TikTok."
- Potentiel BN : 2, Fenetre : 2, Persona : 1 (non cible), Produit : 1, Emotion : 1 = **7/25 LOW**
- **Action :** ignorer. Cf regle Univile — cadres noir/blanc/bois uniquement.

### 9.3 Statistique tourisme generale

"Nombre de touristes en France en hausse de 3,5% en 2025."
- Potentiel BN : 1, Fenetre : 1, Persona : 1, Produit : 2, Emotion : 1 = **6/25 LOW**
- **Action :** ignorer. Pas actionnable.

### 9.4 Lancement produit concurrent mineur

"Poster Store lance nouveau format 13x18 cm."
- Potentiel BN : 1, Fenetre : 2, Persona : 1, Produit : 1, Emotion : 1 = **6/25 LOW**
- **Action :** ignorer, meme Scout-Concurrence ne remonte pas.

---

## 10. PROCEDURE D'EVALUATION

### 10.1 Workflow

```
SIGNAL DETECTE (Scout)
    |
    v
[1] Filtre pertinence Univile (cf SOUL-radar section 13)
    - Concerne destination catalogue ?
    - Concerne marche deco ?
    - Concerne concurrent direct ?
    → Si NON sur les 3 : IGNORE
    |
    v
[2] Filtre actionnabilite
    - Univile peut FAIRE quelque chose ?
    → Si NON : archive score 1, rapport hebdo uniquement
    |
    v
[3] Scoring urgence (cf SOUL-radar section 12) → 1-5
    |
    v
[4] Scoring paid /25 (ce document)
    - Potentiel Breaking News : 1-5
    - Fenetre reaction : 1-5
    - Persona cible : 1-5
    - Produit Univile : 1-5
    - Charge emotionnelle : 1-5
    → Total /25 → CRITICAL/HIGH/MEDIUM/LOW
    |
    v
[5] Generation hypothese Stratege (format SI/ALORS/PARCE QUE)
    |
    v
[6] Remplissage JSON complet
    |
    v
[7] Determination destinataires + expire + go/no-go
    |
    v
[8] Envoi (direct Stratege si score >= 15, via Sparky sinon)
```

### 10.2 Check-list avant envoi

- [ ] Les 5 criteres paid sont notes (pas de "N/A")
- [ ] Le score total est entre 5 et 25 (somme exacte)
- [ ] La hypothese Stratege suit le format SI / ALORS / PARCE QUE
- [ ] La headline tient en 8 mots majuscules
- [ ] Le produit Univile est nomme (handle ou libelle catalogue)
- [ ] La date d'expiration est justifiee
- [ ] Le verdict go/no-go est explicite
- [ ] Le CC Sparky est prepare

---

## 11. ANTI-PATTERNS ET PIEGES

### 11.1 Anti-pattern : survalorisation viralite

**Piege :** un buzz viral 500k vues = reflexe score 5 partout.
**Realite :** si produit catalogue = 1 ou persona cible = 1, le score total retombe a 15-18 (HIGH, pas CRITICAL).
**Correction :** noter chaque critere individuellement avec honnetete, meme si l'ensemble semble "wow".

### 11.2 Anti-pattern : inflation par enthousiasme

**Piege :** Radar detecte une tendance qui lui parle et gonfle les notes.
**Realite :** le Stratege perd confiance dans le scoring, ignore les insights.
**Correction :** regle "un score 5 est rare". Moins de 20% des events doivent atteindre score 25.

### 11.3 Piege : fenetre courte = score 5 automatique

**Piege :** reflexe "event < 24h → score 5".
**Realite :** fenetre courte + pas de produit + pas de persona = juste de la pression sans resultat.
**Correction :** fenetre courte doit etre combinee avec au moins 3 autres criteres >= 4.

### 11.4 Piege : melange urgence et valeur paid

**Piege :** confondre score d'urgence (1-5) et score paid (5-25).
**Realite :** une alerte peut etre urgente (score urgence 5) mais LOW paid (score 8) — exemple catastrophe = A_EVITER, pas un GO paid.
**Correction :** les deux scores sont independants. Toujours les renseigner separement.

### 11.5 Piege : oubli du go/no-go

**Piege :** score 25 + go/no-go "GO" sans reflexion.
**Realite :** certains events tres "scorables" sont NO-GO absolu (catastrophe avec victimes).
**Correction :** passer le test du journaliste (SOUL-radar section 3.GO/NO-GO) systematiquement.

### 11.6 Piege : pas de hypothese exploitable

**Piege :** insight score 22 envoye sans hypothese SI/ALORS/PARCE QUE.
**Realite :** le Stratege ne sait pas quoi faire, perd du temps a reformuler.
**Correction :** l'hypothese est OBLIGATOIRE pour score >= 15. Sinon retour en arriere.

---

*Document de reference — OctoPulse / Univile — mainteneur Radar*
*MAJ : ajout d'exemples d'insights reels apres chaque event majeur*
