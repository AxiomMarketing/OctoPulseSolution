# Formats Creatives — Specifications Detaillees

> Document de reference technique et editorial pour chaque format creative autorise chez Univile. Specs, structure, performance, erosion, anti-patterns, regles DO/DON'T.
>
> **Derniere MAJ** : 2026-04-13
> **Source** : SOUL Forge (sections 1.8-1.11, 1.23-1.24) + historique creatif

---

## TABLE DES MATIERES

1. [Les 4 formats autorises — vue d'ensemble](#1-les-4-formats-autorises--vue-densemble)
2. [Breaking News / Flash Info (CHAMPION)](#2-breaking-news--flash-info-champion)
3. [Carrousel Avant/Apres (CHAMPION ROAS 69x)](#3-carrousel-avantapres-champion-roas-69x)
4. [Statique Mockup (WORKHORSE)](#4-statique-mockup-workhorse)
5. [Carrousel Multi-lieux / Collection](#5-carrousel-multi-lieux--collection)
6. [Declinaisons techniques — 1:1 / 4:5 / 9:16](#6-declinaisons-techniques--11--45--916)
7. [Regles DO/DON'T production](#7-regles-dodont-production)
8. [Formats interdits](#8-formats-interdits)
9. [Specs organique par plateforme](#9-specs-organique-par-plateforme)
10. [Specs email Klaviyo](#10-specs-email-klaviyo)

---

## 1. LES 4 FORMATS AUTORISES — VUE D'ENSEMBLE

| Rang | Format | ROAS | CTR | Statut | Usage |
|---|---|---|---|---|---|
| 1 | **Breaking News / Flash Info** | **10-23,5x** | 9,58% | **CHAMPION A L'ECHELLE** | Event-driven, format par defaut tout lancement |
| 2 | **Carrousel Avant/Apres** | **69x** (micro-budget) | Haut | **CHAMPION a scaler** | Evergreen, transformation espace |
| 3 | **Statique Mockup** | 3,42-27x | Moyen | **WORKHORSE** | Fiable, organique, cadeau |
| 4 | Carrousel Multi-lieux | 1,14x | Moyen | Correct, CPA eleve | Diaspora, nostalgie (optimiser) |

**Formats interdits** : Video, Carrousel narratif abstrait, DPA/Retargeting, Mockup salon classique sans disruption.

**Regle critique** (Learning L4) : **Le produit DOIT etre visible des la 1ere seconde**. Tout format qui cache le produit = fail.

---

## 2. BREAKING NEWS / FLASH INFO (CHAMPION)

### 2.1 Performance prouvee

| Creative | ROAS | CTR | CPM | Notes |
|---|---|---|---|---|
| Eruption Piton Fournaise | **23,5x** | 9,58% | **1,63 EUR** | Pic absolu — CPM divise par 5-10x vs benchmark |
| Sakura Kyoto | **10,19x** | Haut | Bas | Event CREE (pas reel) — prouve L3 |
| Flash Info Saison | En test | — | — | A valider |

### 2.2 Pourquoi ca marche — 8 biais cognitifs empiles

1. **Pattern Interrupt (Von Restorff)** — Bandeau rouge casse le feed uniforme, le cerveau s'arrete net
2. **Biais d'autorite** — Format "news TV" = credibilite instantanee
3. **FOMO** — "Edition limitee", "1ere fois en 19 ans" = urgence
4. **Information Gap** — "Alerte Info" cree un besoin de savoir = curiosite
5. **Effet de halo** — Produit associe a un evenement prestigieux/historique
6. **Aversion a la perte** — "Tu vas rater ca" > "Tu vas gagner ca"
7. **Preuve sociale** — 501 reactions, 20 partages = validation massive
8. **Ancrage prix** — "Des 28 EUR" elimine la barriere psychologique

### 2.3 Specifications visuelles OBLIGATOIRES

| Element | Spec | Pourquoi |
|---|---|---|
| **Bandeau haut** | Rouge vif (#FF0000), texte blanc gras | Scroll-stop instantane (rouge = alerte biologique) |
| **Titre** | "ERUPTION HISTORIQUE", "FLASH INFO", "ALERTE" + sujet | Urgence + contexte |
| **Logo** | "UNIVILE NEWS" en haut a droite, style chaine TV | Mimetisme editorial, credibilite |
| **Ticker bas** | Bandeau defilant style news, texte blanc sur fond sombre | "EN DIRECT : [LIEU]" + info complementaire |
| **Point rouge** | Avant "EN DIRECT" | Signal "live", urgence temps reel |
| **Produit** | Tableau encadre, tenu par mains gantees OU pose sur chevalet OU en situation cinematique | Produit = heros, pas element secondaire |
| **Fond** | Dramatique et contextuel (lave, petales, tempete, lumiere) — **PAS un salon** | Immersion dans l'evenement |
| **Contraste** | Tableau clair sur fond sombre OU couleurs vives sur fond neutre | Le produit RESSORT |

### 2.4 Les 5 variantes du format

| Variante | Quand l'utiliser | Ton | Exemple |
|---|---|---|---|
| **BREAKING NEWS** | Event reel urgent (eruption, buzz viral) | Dramatique, urgent | Eruption Piton Fournaise |
| **FLASH INFO** | Event saisonnier ou cree | Poetique ou festif | Sakura Kyoto |
| **ALERTE INFO** | Meteo, phenomene naturel | Informatif, captivant | "Tempete sur l'Atlantique" |
| **EDITION SPECIALE** | Lancement produit, collaboration | Exclusif, premium | "Nouvelle collection Reunion" |
| **DERNIERE MINUTE** | Fin de disponibilite, dernier jour | Urgence maximale | "Dernier stock Cascade Langevin" |

### 2.5 Templates prompt Nanobanana 2

**Pour event dramatique (eruption, tempete)** :
```
Cinematic news broadcast style image. A framed art print showing [DESCRIPTION DU TABLEAU]
held by gloved hands against a dramatic backdrop of [CONTEXTE EVENT — lava, storm, etc.].
Red "BREAKING NEWS" banner at top. "UNIVILE NEWS" logo top right corner.
News ticker at bottom reading "EN DIRECT : [LIEU]".
Dark, smoky atmosphere with emergency-style red and blue lights.
The framed print is the focal point, well-lit against the dark background.
Professional news photography style. 4:5 aspect ratio. High contrast.
```

**Pour event poetique (sakura, saison)** :
```
Artistic news broadcast style image. A framed art print showing [DESCRIPTION DU TABLEAU]
displayed on a wooden easel in [CONTEXTE — Japanese garden, autumn forest, etc.].
Red "FLASH INFO" banner at top. "UNIVILE NEWS" logo top right.
Ticker at bottom. [ELEMENTS POETIQUES — cherry blossom petals falling, golden leaves, etc.]
Soft, warm lighting. Dreamy atmosphere mixed with news broadcast elements.
The print is the hero element, centered and well-lit. 4:5 aspect ratio.
```

### 2.6 Copy Breaking News — Template

```
[EMOJI SIGNAL] [TITRE EVENEMENT EN MAJUSCULES]

[Fait marquant en 1 ligne — chiffre ou stat impressionnante]
[Elevation emotionnelle en 1 ligne]

Notre nouveau tableau '[Nom]' capture cet instant unique.
Edition limitee.

Des [PRIX] EUR . Livraison offerte des 70 EUR
```

### 2.7 Exemple concret winner (Eruption ROAS 23,5x)

> ERUPTION HISTORIQUE — Piton de la Fournaise
>
> La lave a atteint l'ocean pour la 1ere fois en 19 ans. Un evenement mondial.
>
> Notre nouveau tableau 'Coulee 2026' capture cet instant unique. Edition limitee.
>
> Des 28 EUR . Livraison offerte des 70 EUR

### 2.8 Erosion previsible (Learning L7)

| Jour | ROAS attendu | Action |
|---|---|---|
| J1 | 32x | Lancer |
| J2 | 23x | Continuer |
| J3 | 7x | **Preparer V2 IMMEDIATEMENT** |
| J4 | < 5x | Kill ou swap vers V2 |

**Regle** : **Preparer la V2 AVANT que le CTR passe sous 5%** (generalement J3-J4). Ne JAMAIS attendre l'erosion complete pour reagir.

### 2.9 Angles de renouvellement (V2, V3)

Pour un event reel en erosion :
- V2 : "La lave a cesse" / "Retour au calme"
- V3 : "Les dernieres images" / "L'ile respire"
- V4 : "Il y a 1 mois / 3 mois — souvenir" (post-event)

Pour un event saisonnier : duree de vie plus longue (2-4 semaines), erosion plus lente.

### 2.10 Anti-patterns Breaking News

| Anti-pattern | Pourquoi ca tue le format |
|---|---|
| Fond "salon classique" | Casse l'immersion event — doit etre contextuel (lave, jardin, tempete) |
| Pas de bandeau rouge | Perte du pattern interrupt (Von Restorff) |
| Produit absent du visuel | L4 violé — le produit DOIT etre visible |
| Pas d'ancrage temporel | Pas de FOMO |
| Pas de mention prix | Pas d'ancrage cognitif — perte de l'acheteur qualifie |
| Preparer V2 trop tard (J5+) | Budget brule en erosion, creative morte |

---

## 3. CARROUSEL AVANT/APRES (CHAMPION ROAS 69x)

### 3.1 Performance prouvee

| Creative | Format | ROAS | CPA | Budget | Notes |
|---|---|---|---|---|---|
| B2 "Avant/Apres Reunion" | Carrousel AA | **69x** | **5,15 EUR** | **16 EUR** (micro) | **Jamais teste a l'echelle** |

**Status** : CHAMPION absolu. **Priorite 2026 : scaler a 100-500 EUR/creative** pour confirmer le ROAS.

### 3.2 Pourquoi ca marche

1. **Demonstration de valeur** — le spectateur VOIT ce que l'affiche change (pas d'argumentation, pure visual proof)
2. **Projection** — "mon mur nu ressemble a slide 1, je peux avoir slide 2"
3. **Engagement carrousel** — swipe = investissement cognitif (le spectateur est mobilise)
4. **Pattern universel** — Before/After est connu, parle a tous

### 3.3 Structure slides (3 slides minimum)

| Slide | Role | Intention | Duree visuelle |
|---|---|---|---|
| **1 — Avant** | Mur vide, piece chaleureuse mais incomplete | Creer le manque | 1-2s |
| **2 — Apres** | Meme piece, meme angle, **avec l'affiche** | Revelation, "la piece a une ame" | 2-3s |
| **3 — Close-up** | Gros plan sur l'affiche encadree | Preuve qualite + CTA | 1-2s |

**Regle cruciale** : **Slide 1 et slide 2 doivent etre le MEME angle**. C'est la comparaison directe qui cree l'impact. Changer d'angle = casser la demo.

### 3.4 Slide 1 — Avant (specs)

**DO** :
- Piece deja chaleureuse (canape, plantes, parquet)
- Mur vide (bien visible, grand)
- Lumiere naturelle (golden hour)
- Composition "il manque quelque chose" evidente

**DON'T** :
- Piece totalement vide/scandinave (la piece doit deja avoir une ame, seul le mur est nu)
- Mur surcharge avec autre deco
- Flash studio
- Angle different de slide 2

### 3.5 Slide 2 — Apres (specs)

**DO** :
- **Meme angle exact** que slide 1
- **Meme eclairage**
- Affiche en position focale (centree, bien eclairee)
- Taille 50x70 ou 61x91 visible
- Cadre noir / blanc / bois uniquement

**DON'T** :
- Changement d'angle (casse la demo)
- Changement d'eclairage
- Affiche trop petite ou mal placee
- Cadre fantaisie

### 3.6 Slide 3 — Close-up (specs)

**DO** :
- Gros plan sur l'affiche (face a face ou leger angle)
- Cadre net, details visibles
- Lumiere chaude, rendant hommage au papier
- Zone de texte en bas pour CTA overlay

**DON'T** :
- Angle bizarre / decorative
- Flou artistique
- Texte dans l'image (garder pour overlay separe)

### 3.7 Templates prompts Nanobanana 2

**Slide 1 (Avant)** :
```
Professional interior photography of a warm living room with an EMPTY main wall.
Earthy tones: linen sofa in sage green, wooden coffee table, monstera plant.
The wall above the sofa is completely bare — no art, no decoration.
The empty wall is the focal point, creating a sense of something missing.
Warm golden hour light. Shot on Canon EOS R5, 35mm, f/2.8, natural lighting.
NOT: cold scandinavian, white empty walls (the room is warm, the wall is just bare).
```

**Slide 2 (Apres)** :
```
[EXACTEMENT la meme scene que slide 1, MAIS avec l'affiche ajoutee]
Professional interior photography of the same warm living room.
Same sage green sofa, same wooden coffee table, same monstera plant.
NOW: a framed art print of [lieu] (50x70cm, black frame) centered above the sofa.
The poster transforms the room — it gives the space its soul.
Same warm golden hour light. Shot on Canon EOS R5, 35mm, f/2.8.
```

**Slide 3 (Close-up + CTA)** :
```
Close-up shot of the framed art print of [lieu] on the wall.
The frame and the print are sharp and detailed. We can see the artwork clearly.
Warm light illuminating the poster. Slightly angled shot from below.
Text overlay space at the bottom for CTA.
Shot on Canon EOS R5, 85mm, f/1.8, shallow depth of field.
```

### 3.8 Anti-patterns Carrousel AA

| Anti-pattern | Pourquoi ca tue le format |
|---|---|
| Slide 1 et slide 2 angles differents | Casse la demo visuelle |
| Slide 1 totalement vide / scandinave froid | Pas de creation de manque — la piece doit deja etre chaleureuse |
| Pas de close-up (slide 3) | Manque la preuve qualite |
| Carrousel > 5 slides | Dilue l'impact, perte d'attention |
| Texte narratif long en overlay | Le visuel parle, pas besoin de discourir |

---

## 4. STATIQUE MOCKUP (WORKHORSE)

### 4.1 Performance prouvee

| Creative | ROAS | CPA | Notes |
|---|---|---|---|
| Cascade Langevin Mockup | **27x** | — | Workhorse fiable |
| B3 "Le cadeau qui touche" | **3,42x** | 17,44 EUR | Workhorse cadeau |

### 4.2 Pourquoi ca marche

- **Simplicite production** (pas de carrousel a decliner)
- **Projection directe** — le spectateur se voit chez lui
- **Versatile** — marche en paid, organique, email
- **Bon rapport qualité / coût de production**

### 4.3 Les 3 types de mockup

| Type | Usage | Persona compatible | Performance |
|---|---|---|---|
| **Mockup salon situationnel** (paid) | Creative Meta Ads | Marie, Julien | ROAS 3-27x |
| **Mockup cadeau** (paid/organique) | Angle cadeau avec emballage visible | Marie, Christiane | ROAS 3,42x prouve |
| **Mockup gallery wall** (organique) | Multiple affiches = upsell | Julien (collection) | A tester |

### 4.4 Structure du mockup qui convertit

| Element | Role |
|---|---|
| **Affiche** | Point focal, minimum 25% de la surface image, parfaitement lisible |
| **Interieur** | Chaleureux, credible (pas showroom, pas studio) |
| **Eclairage** | Golden hour ou lumiere naturelle chaude |
| **Accessoires de vie** | Bougie, livre, tasse de cafe, plantes — signaler "c'est un VRAI chez soi" |
| **Cadre** | Noir / blanc / bois uniquement |

### 4.5 Template prompt Nanobanana 2

```
Professional interior photography of a warm, lived-in living room.
Earthy tones: exposed wooden beams on the ceiling, a comfortable linen sofa
in sage green with mustard and terracotta throw pillows. A large monstera plant
in a terracotta pot to the left. Woven jute rug on wide plank oak flooring.
A framed art print of [lieu — ex: tropical waterfall in a lush green canyon]
(50x70cm, black frame) centered on the main wall above the sofa.
The poster is the clear focal point of the image.
Warm golden hour light streaming through a window on the right,
casting soft shadows. A ceramic mug and an open book on the wooden coffee table.
Cozy, authentic, warm atmosphere — this is someone's real home, not a showroom.
Shot on Canon EOS R5, 35mm lens, f/2.8, natural lighting.
NOT: cold scandinavian, white empty walls, artificial lighting, studio flash.
```

### 4.6 Ce qui marche / ce qui ne marche pas

| CA MARCHE | CA NE MARCHE PAS |
|---|---|
| Interieur chaleureux credible | Scandinave froid (Learning L5 — "Mockup salon classique" a CTR 2,47% et 0 achat) |
| Plantes, bois, textiles | Mur blanc vide seul |
| Golden hour | Flash studio |
| Cadre noir / bois | Cadre fantaisie (dore, argente) |
| Accessoires de vie | Piece trop rangee / vitrine |
| Produit en point focal (> 25% surface) | Produit perdu dans le decor |

### 4.7 Anti-pattern MAJEUR : Mockup salon classique sans disruption

**Learning L5** : les mockups salons "catalogue" classiques ont un CTR de 2,47% et 0 achat. **A ne plus utiliser tel quel.**

**Solution** : le mockup doit avoir un element disruptif :
- Lumiere dramatique (coucher de soleil dans la fenetre)
- Angle inhabituel (vue du sol, contre-plongee)
- Contexte narratif (personne lisant sur le canape, tasse fumante)
- Composition forte (affiche enorme, panoramique)

Le mockup "plat" est mort. Le mockup "en vie" marche.

---

## 5. CARROUSEL MULTI-LIEUX / COLLECTION

### 5.1 Performance prouvee

| Creative | Format | ROAS | CPA | Notes |
|---|---|---|---|---|
| B4 "Diaspora Reunion" | Carrousel Multi | 1,14x | **33 EUR** (cible 28 EUR) | **A OPTIMISER** |

### 5.2 Le probleme du format

- Dilue le focus (plusieurs lieux = cerveau divisé)
- CPA eleve (33 EUR vs cible 28 EUR)
- Fonctionne, mais moins bien que le Statique Mockup 1 lieu

### 5.3 Quand l'utiliser (hypothese)

- **Persona Julien Collection** : "5 affiches pour un mur de voyages" — upsell naturel
- **Angle Collection discovery** : faire decouvrir le catalogue
- **Organique** : feed deroulant, pas de pression conversion

### 5.4 Structure carrousel Collection (hypothese)

| Slide | Role |
|---|---|
| 1 — Accroche | "5 affiches pour un mur de voyages" + mockup gallery wall |
| 2-6 — Chaque lieu | 1 lieu par slide, contexte + produit |
| 7 — CTA | Pack collection + discount + CTA |

### 5.5 Optimisation du Carrousel Multi-lieux existant

Pour le reduire vs Statique Mockup 1 lieu :
- Limiter a 3 lieux max (pas 5-6)
- Chaque lieu = emotion forte (pas "5 lieux generiques")
- Mettre un vrai CTA final (pas juste un mood)

**Meilleure alternative** : **remplacer par Statique Mockup 1 lieu intime** — focus + ROAS potentiellement meilleur.

---

## 6. DECLINAISONS TECHNIQUES — 1:1 / 4:5 / 9:16

Chaque creative paid est **obligatoirement declinee en 3 formats**.

### 6.1 Specs techniques

| Format | Resolution | Ratio | Usage | Adaptation |
|---|---|---|---|---|
| **1:1** | **1080x1080** | Carre | Feed Facebook | Composition centree, affiche au milieu, decor symetrique |
| **4:5** | **1080x1350** | Portrait | Feed Instagram (mobile-first) | Composition verticale, affiche dans le tiers superieur, plus de sol/decor en bas |
| **9:16** | **1080x1920** | Stories | Stories / Reels / TikTok | Composition tres verticale, affiche centree en haut, espace en bas pour texte/CTA overlay |

### 6.2 Points de vigilance

**Instagram Feed n'est PAS du 1:1 carre** — c'est du **4:5 portrait**. Le 4:5 prend plus de place dans le feed et performe mieux. **Par defaut, utiliser 4:5 pour Instagram.**

**Pour Stories (9:16)** :
- Zone de texte safe : 80px du haut, 200px du bas (eviter occultation par UI Instagram)
- Prevoir espace en bas pour CTA overlay
- Affiche en haut-centre

### 6.3 Cadrage — regles de composition

**Pour 4:5 (prioritaire)** :
- Affiche dans tiers superieur
- Sol / decor en bas = respiration
- Lumiere / fenetre a droite ou gauche

**Pour 1:1** :
- Composition centree et symetrique
- Affiche au milieu
- Decor equilibre

**Pour 9:16** :
- Affiche centrée en haut
- Décor en bas
- Place pour CTA overlay dans la zone safe

### 6.4 Ordre de priorite de production

1. **4:5 d'abord** (format dominant Instagram, conversion forte)
2. **9:16 ensuite** (Stories, Reels, diversifie l'inventaire)
3. **1:1 en dernier** (Feed Facebook, moins critique)

**En mode urgent** : produire uniquement le 4:5, les autres formats dans un 2eme temps.

---

## 7. REGLES DO/DON'T PRODUCTION

### 7.1 DO — Obligatoires pour chaque creative paid

1. Montrer le produit (affiche en situation) **DES la premiere image**
2. Utiliser un mockup realiste dans un interieur **credible et chaleureux**
3. Avoir un texte **court et emotionnel** (primary text max 3 lignes)
4. Inclure un CTA **clair et specifique** ("Decouvre", "Transforme ton salon", "Offre-lui")
5. Decliner en **3 formats** : 1:1 + 4:5 + 9:16
6. Cibler **UN persona specifique** (Marie, Julien ou Christiane — jamais "tout le monde")
7. Mentionner le **prix** ("A partir de 28 EUR" ou "Livraison offerte des 70 EUR")
8. Utiliser une image produit **EXISTANTE** du catalogue (jamais inventer une affiche)
9. Verifier dans l'historique creatif que l'angle/format n'a pas deja echoue
10. Specifier l'ad set de destination (C pour test, B pour variante winner)
11. Consulter les LEARNINGS ACCUMULES avant chaque production
12. Tracer l'hypothese HYP-XXXX du Stratege dans le brief final

### 7.2 DON'T — Interdits sans exception

1. **JAMAIS de video** — ROAS 0 historique (A1 : 231 EUR, 0 achat)
2. **JAMAIS de concept abstrait sans demonstration de valeur** — ROAS 0 historique (A2 : 127 EUR, 0 achat)
3. **JAMAIS de DPA/retargeting** — pas assez de volume (< 5 000 sessions/mois)
4. **JAMAIS de photo de paysage seul sans contexte produit**
5. **JAMAIS de texte > 3 lignes** en primary text
6. **JAMAIS de creative sans prix et sans CTA**
7. **JAMAIS de scandinave froid** (murs blancs vides, meuble IKEA neutre, studio aseptise)
8. **JAMAIS d'eclairage artificiel/flash** — toujours lumiere naturelle ou chaude
9. **JAMAIS de cadre hors catalogue** (UNIQUEMENT : noir, blanc, bois)
10. **JAMAIS de creative qui repete un angle deja echoue** dans l'historique
11. **JAMAIS modifier l'hypothese du Stratege** sans son accord
12. **JAMAIS produire sans avoir lu le dernier feedback de performance**

### 7.3 Palette couleurs Univile (pour overlays)

| Couleur | Hex | Usage |
|---|---|---|
| **Bleu Fonce** | #001f4d | Textes de titre, encadres, elements identitaires |
| **Sable / Beige** | #fff8e7 | Fonds, ambiance chaleureuse, arriere-plans de texte |
| **Terracotta** | #c75146 | CTA, prix promo, accents energiques, boutons |
| **Blanc Casse** | #f8f5f0 | Espaces de respiration, fond de texte leger |
| **Gris Chaud** | #d4cfc7 | Sous-titres, textes secondaires |
| **Vert Racines** | #2E6B4F | Badges ("Nouveau", "En stock"), elements de reassurance |

### 7.4 Interieurs — reference CHALEUREUX

**Elements qui doivent apparaitre dans les interieurs mockup** :
- Materiaux naturels : bois, lin, rotin, pierre
- Plantes vertes (monstera, ficus, eucalyptus)
- Coussins, plaids en laine, tapis
- Lumiere naturelle (fenetre, golden hour, fin d'apres-midi)
- Murs textures (enduit, pierre, brique douce)
- Ambiance "chez soi" — pas showroom, pas catalogue
- Canape en tissu (gris, beige, vert sauge)
- Table basse en bois brut ou marbre chaud
- Bougie, livre, tasse de cafe (accessoires de vie)

**Elements a bannir** :
- Murs blancs vides
- Meuble IKEA neutre
- Carrelage blanc
- Total white
- Studio aseptise
- Ambiance corporate

---

## 8. FORMATS INTERDITS

### 8.1 Les 4 formats proscrits

| Format | Raison | Depense brulee | Achats |
|---|---|---|---|
| **Video brand content** | Piege a clics (CTR eleve mais 0 intention) | 231 EUR (A1) | 0 |
| **Carrousel narratif abstrait** | Pas de demo valeur | 127 EUR (A2) | 0 |
| **DPA / Retargeting** | Volume trafic insuffisant (< 5 000/mois) | 157 EUR (C1) | 0 |
| **Mockup salon classique sans disruption** | CTR 2,47% + 0 achat | — | 0 |

### 8.2 Pourquoi ne PAS reconsiderer ces formats

- **Video** : coute cher en production + CPM eleve. Tant que budget < 10 KEUR/mois, non viable.
- **Abstrait narratif** : contredit la regle fondamentale "produit visible des la 1ere seconde" (L4).
- **DPA** : ouvrable quand trafic > 5 000 sessions/mois (objectif M6 — Aout 2026).
- **Mockup salon classique** : reformer le mockup avec disruption (lumiere dramatique, angle inhabituel).

### 8.3 Reperes de decision

Si un brief propose un de ces formats, **Forge doit REFUSER** (ou escalader au Stratege avec justification historique).

---

## 9. SPECS ORGANIQUE PAR PLATEFORME

### 9.1 Specs techniques

| Plateforme | Format | Resolution | Ratio | Usage |
|---|---|---|---|---|
| **Instagram Feed** | Post standard | 1080x1350 | 4:5 | Post produit, transformation |
| **Instagram Feed** | Carrousel | 1080x1350 | 4:5 | Avant/Apres, multi-lieux |
| **Instagram Stories** | Story | 1080x1920 | 9:16 | Ephemere, promo flash |
| **Facebook Feed** | Post standard | 1200x628 | ~1,91:1 | Post produit, partage |
| **Facebook Feed** | Post carre | 1080x1080 | 1:1 | Alternative au paysage |
| **Pinterest** | Pin standard | 1000x1500 | 2:3 | Inspiration deco, mockup |
| **Pinterest** | Pin long | 1000x2100 | ~1:2.1 | Avant/Apres vertical |

### 9.2 Style organique vs paid

| Aspect | Paid (Meta Ads) | Organique |
|---|---|---|
| Disruption | OBLIGATOIRE (Breaking News, bandeau rouge) | Plus subtile (ambiance, esthetique) |
| Prix | TOUJOURS mentionne | Rarement (CTA "lien en bio") |
| CTA | Agressif ("Achete", "Decouvre") | Soft ("Dis-moi en commentaire", "Enregistre") |
| Style | Performance-first | Brand-first (coherence feed) |
| Texte dans l'image | Autorise | Minimal |

### 9.3 Regles Pinterest specifiques

- Format **vertical obligatoire** (les pins horizontaux performent mal)
- Max ratio 1:2.1
- Texte overlay reduit mais descriptif
- Pins "inspo" plus que "pub"

---

## 10. SPECS EMAIL KLAVIYO

### 10.1 Specifications techniques

| Element | Spec | Pourquoi |
|---|---|---|
| **Header** | 600x300 px | Taille standard Klaviyo. Visible sans scroll sur mobile. |
| **Hero image** | 600x400 px | Image principale. Plus grande, plus immersive. |
| **Inline product** | 600xAuto (hauteur libre) | Image de produit dans le corps |
| **Resolution** | 72 DPI (web) | Emails ne supportent pas retina partout |
| **Poids max** | **200 KB par image** | Au-dela, blocage / ralentissement |
| **Format fichier** | JPEG (photos) / PNG (graphiques) | JPEG pour mockups, PNG pour boutons/badges |
| **Largeur max** | 600 px | Standard email |

### 10.2 Style email vs paid

| Aspect | Paid | Email |
|---|---|---|
| Style Univile | Full (Ghibli, hyper-saturation) | Attenue (plus clean, plus lisible) |
| Complexite visuelle | Haute (fond dramatique, overlays) | Basse (fond simple, produit clair) |
| Texte dans l'image | OUI | NON (sauf si Keeper demande) |
| Fond | Contextuel | Neutre ou leger (sable, blanc casse, bois clair) |
| CTA dans l'image | OUI (bouton style) | NON (bouton dans HTML Klaviyo) |

### 10.3 Types de visuels par sequence

| Sequence | Type visuel | Ambiance |
|---|---|---|
| **Welcome** | Hero chaleureux + produit vedette | Accueillante, premium |
| **Abandon panier** | Rappel produit + urgence legere | Clean, direct |
| **Post-achat** | Cross-sell + remerciement | Chaleureuse, gratitude |
| **VIP** | Premium exclusif | Luxe, special |
| **Winback** | Emotionnel nostalgie | Doux, rappel |
| **Newsletter** | Produit du moment saisonnier | Selon saison |

### 10.4 Regles email specifiques

- **Pas de texte incruste** dans l'image (le texte se gere dans Klaviyo en HTML)
- **Poids < 200 KB** obligatoire
- **Style plus clean** que paid (lisibilite email > disruption)
- **1 image = 1 message** (pas de surcharge)

---

*Document de reference — Marketing Univile — 2026-04-13. Mis a jour apres chaque cycle de feedback Forge/Stratege.*
