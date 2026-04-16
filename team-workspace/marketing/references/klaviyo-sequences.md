# Klaviyo Sequences — Reference CRM/Lifecycle Univile

> Document de reference pratique pour le domaine CRM/Lifecycle (Keeper). Utilise avec `/Users/admin/octopulse/.claude/shared/univile-context.md` pour le contexte business.

**Derniere mise a jour** : 2026-04-13
**Phase actuelle** : Warm-up S1-S5 (premiers envois jamais realises sur la base de 9 150 contacts)
**Objectif M6** : Part email dans le CA = 18% | Base active = 12 000 abonnes

---

## TABLE DES MATIERES

1. [Vue d'ensemble — Etat Klaviyo aujourd'hui](#1-vue-densemble--etat-klaviyo-aujourdhui)
2. [Les 6 sequences lifecycle core](#2-les-6-sequences-lifecycle-core)
   - 2.1 Welcome Series
   - 2.2 Abandoned Cart
   - 2.3 Browse Abandonment
   - 2.4 Post-Purchase
   - 2.5 Win-Back
   - 2.6 VIP (sequence avancee post-activation)
3. [Plan de warm-up S1-S5](#3-plan-de-warm-up-s1-s5)
4. [Segments standards](#4-segments-standards)
5. [Regles deliverability](#5-regles-deliverability)
6. [Glossaire KPIs](#6-glossaire-kpis)

---

# 1. VUE D'ENSEMBLE — ETAT KLAVIYO AUJOURD'HUI

## 1.1 Actifs herites

| Element | Etat | Detail |
|---------|------|--------|
| **Contacts** | 9 150 | Tous dormants — aucun email marketing jamais envoye |
| **Flows en draft** | 8 | Welcome, Abandon Cart, Browse Abandonment, Post-Purchase, Winback, Sunset, Back in Stock, Price Drop — **aucun actif** |
| **Templates** | 35 | Crees, jamais utilises. A auditer |
| **Connexion Shopify** | Active | Evenements Started Checkout, Placed Order, Fulfilled Order, Customer Created |
| **Connexion Meta Pixel** | Active | Synchronisee pour la segmentation |
| **SPF/DKIM/DMARC** | A verifier | Prerequis obligatoire avant tout envoi |
| **Double opt-in** | A configurer | Non en place |
| **Domaine d'envoi dedie** | A configurer | Recommande : `mail.univile.com` (isoler reputation marketing de transactionnelle) |

## 1.2 Base — estimation conservatrice

| Segment estime | Nombre | Qualite |
|---------------|--------|---------|
| Clients < 90j | ~200-300 | Haute — priorite warm-up S1 |
| Clients 90-365j | ~500-700 | Moyenne — warm-up S2-S3 |
| Clients > 365j | ~300-500 | Basse — risque bounce eleve |
| Inscrits newsletter < 6 mois sans achat | ~1 000-1 500 | Moyenne — S2-S3 |
| Inscrits newsletter > 6 mois sans achat | ~3 000-4 000 | Basse — S4-S5 seulement si metriques OK |
| Contacts origine inconnue / B2B imports | ~2 000-3 000 | Tres basse — verification bulk obligatoire |

## 1.3 Codes promo dedies (attribution email)

Chaque flow utilise un code distinct des codes Meta Ads pour permettre l'attribution propre :

| Code | Flow | Detail |
|------|------|--------|
| `WELCOME10` | Welcome Series | -10% premier achat (E1 + E4) |
| `PANIER5` | Abandon Cart | -5% relance panier (E3, 24h de validite) |
| `RETOUR15` | Winback | -15% reactivation client dormant (E2, 7j) |
| `BIENVENUE10` | Newsletter signup site | -10% inscription (alias WELCOME10 cote site) |

---

# 2. LES 6 SEQUENCES LIFECYCLE CORE

## 2.1 Welcome Series

### Vue d'ensemble

| Attribut | Detail |
|----------|--------|
| **Objectif** | Convertir le nouvel inscrit en premier acheteur. Presenter la marque, creer l'attachement, declencher le premier achat avec `WELCOME10` |
| **Trigger** | Newsletter signup (formulaire site) OU Shopify Customer Created sans achat |
| **Exclusion** | Clients ayant deja achete (→ Post-Purchase) / Contacts B2B identifies (→ flow B2B dedie) |
| **Nombre d'emails** | 4 |
| **Duree totale** | 5 jours |
| **KPIs cibles** | Ouverture E1 > 50%, ouverture serie > 40%, CTR > 8%, conversion serie > 5%, RPR > 2 EUR |

### Emails

| # | Timing | Objet | Contenu cle | CTA |
|---|--------|-------|-------------|-----|
| W-E1 | Immediat | "Bienvenue chez Univile — voici votre -10%" | Accueil chaleureux + presentation marque en 3 phrases + code `WELCOME10` + livraison offerte 70 EUR | "Decouvrir la collection" → `/collections/all` |
| W-E2 | J+1 (si E1 ouvert) | "Ne a La Reunion — l'histoire derriere vos affiches" | Histoire Univile, ancrage Reunion, 2 gammes Original + Edition | "Decouvrir nos origines" → page A Propos |
| W-E3 | J+3 (tous) | "Les 5 affiches preferees de nos clients" | 5 bestsellers lifestyle + rappel `WELCOME10` + barre progression livraison | "Voir tous les coups de coeur" → collection bestsellers |
| W-E4 | J+5 (si pas d'achat) | "Votre code -10% expire dans 48h" | Urgence douce + 3 bestsellers + reassurance (3x sans frais, livraison 70 EUR) | "Utiliser mon code -10%" (pre-applique si possible) |

### A/B tests prioritaires

| Test | A | B | Metrique |
|------|---|---|----------|
| Objet E1 | "Bienvenue chez Univile — voici votre -10%" | "Votre cadeau de bienvenue est pret" | Taux ouverture |
| Timing E4 | J+5 | J+7 | Taux conversion |
| Contenu E3 | 5 bestsellers | 3 bestsellers + 2 nouveautes | CTR |

---

## 2.2 Abandoned Cart

### Vue d'ensemble

| Attribut | Detail |
|----------|--------|
| **Objectif** | Recuperer les paniers abandonnes. **Flow a plus fort ROI immediat** — intention d'achat deja demontree |
| **Trigger** | Shopify `Started Checkout` + aucun achat apres 1h |
| **Exclusion** | Achat effectue / Contact ayant recu un AC dans les 7j (anti-spam) / Contacts B2B |
| **Nombre d'emails** | 3 |
| **Duree totale** | 48h |
| **KPIs cibles** | Recovery rate > 8%, ouverture E1 > 45%, RPR > 3 EUR |
| **Benchmark** | Ouverture AC moyenne 50,5% (Omnisend 2025), recovery 5-12% ecom |

### Emails

| # | Timing | Objet | Contenu cle | CTA |
|---|--------|-------|-------------|-----|
| AC-E1 | 1h apres abandon | "Vous avez oublie quelque chose ?" | Image dynamique produit du panier + nom + prix — **aucune promo**, juste rappel | "Reprendre ma commande" → checkout pre-rempli |
| AC-E2 | 24h apres | "Votre panier est encore la" | Image produit + 2-3 avis Trustpilot + reassurance qualite + mention livraison offerte | "Finaliser ma commande" → checkout |
| AC-E3 | 48h apres | "-5% sur votre panier — juste pour vous" | Code `PANIER5` (validite 24h) + image produit + rappel paiement 3x | "Utiliser mon code -5%" → checkout pre-applique |

### Segmentation avancee AC

| Segment | Traitement specifique |
|---------|----------------------|
| Panier > 100 EUR | Mentionner paiement 3x sans frais des E1 (frein financier probable) |
| Panier > 70 EUR | Mentionner "Bonne nouvelle : livraison offerte !" des E1 |
| Panier < 70 EUR | Suggerer produit complementaire pour atteindre seuil livraison offerte (E2) |
| Client recurrent | **Pas** de code `PANIER5` en E3. Angle "Votre collection s'agrandit" a la place |
| Premiere visite | Ajouter reassurance supplementaire (avis, garantie, histoire marque) |

### A/B tests prioritaires

| Test | A | B | Metrique |
|------|---|---|----------|
| Timing E1 | 1h | 30min | Recovery rate |
| Incentive E3 | -5% (PANIER5) | Livraison offerte (si panier < 70 EUR) | RPR |

---

## 2.3 Browse Abandonment

### Vue d'ensemble

| Attribut | Detail |
|----------|--------|
| **Objectif** | Re-engager les visiteurs qui consultent des produits sans ajouter au panier. Intention plus faible que AC → approche plus douce, **pas de promo** |
| **Trigger** | `Viewed Product` + aucun ATC apres 4h + aucun achat |
| **Exclusion** | Ajout au panier (→ AC flow) / Achat / Browse Abandonment recu < 14j / B2B |
| **Nombre d'emails** | 2 |
| **Duree totale** | 24h |
| **KPIs cibles** | CTR > 3%, ouverture > 25%, conversion > 1% |

### Emails

| # | Timing | Objet | Contenu cle | CTA |
|---|--------|-------|-------------|-----|
| BA-E1 | 2h apres derniere consultation | "Ce lieu vous a tape dans l'oeil ?" | Image dynamique produit consulte + nom + prix + 2-3 similaires | "(Re)decouvrir [nom du lieu]" → fiche produit |
| BA-E2 | 24h apres | "D'autres lieux qui pourraient vous plaire" | 4-6 reco (meme destination/style/gamme prix) + rappel `WELCOME10` si nouveau | "Voir toute la collection" → collection concernee |

---

## 2.4 Post-Purchase

### Vue d'ensemble

| Attribut | Detail |
|----------|--------|
| **Objectif** | Maximiser la satisfaction, collecter de l'UGC, preparer le reachat. **LE flow qui transforme un acheteur unique en client recurrent** |
| **Trigger** | Shopify `Placed Order` |
| **Exclusion** | Commande B2B / Commande annulee-remboursee (sortir du flow) |
| **Nombre d'emails** | 4 |
| **Duree totale** | 14 jours |
| **KPIs cibles** | Repeat purchase > 8% sous 90j, 1 avis Trustpilot / 10 commandes, UGC collecte |

### Emails

| # | Timing | Objet | Contenu cle | Ton / Adaptation persona |
|---|--------|-------|-------------|---------------------------|
| PP-E1 | Immediat | "Merci [Prenom] — votre affiche est en preparation" | Remerciement personnel + resume commande + tracking + delai 5-10j depuis La Reunion. Aucun CTA commercial | Personnel, chaleureux, reunionnais. Marie : "Votre bout de La Reunion arrive bientot sur votre mur". Julien : "Votre affiche est en preparation dans notre atelier" |
| PP-E2 | J+3 | "3 idees pour sublimer votre affiche [nom du lieu]" | Guide d'accrochage + 3 mises en situation + photos UGC + CTA partage | Utile, inspirant. Julien : focus gallery wall. Marie : focus communautaire "Montrez-nous votre coin Reunion !" |
| PP-E3 | J+7 | "Et si [nom du lieu] avait un voisin sur votre mur ?" | Cross-sell 3-4 produits complementaires + mockup 2 affiches cote a cote. Si panier initial < 70 EUR : livraison offerte mentionnee | Suggestif, pas pushy. Marie : "Completez votre collection reunionnaise". Julien : "La piece manquante de votre gallery wall" |
| PP-E4 | J+14 | "[Prenom], votre avis compte enormement pour nous" | Demande Trustpilot + demande photo UGC + offre parrainage (-10 EUR parrain + -10 EUR filleul) | Reconnaissant, communautaire |

### Segmentation PP

| Signal client | Traitement |
|--------------|------------|
| Premier achat > 100 EUR | Tag `VIP potentiel`. PP-E3 avec produits premium |
| Premier achat multi-produits | Tag `collectionneur`. PP-E3 avec gallery wall guide |
| Achat pendant promo | Tag `sensible prix`. PP-E3 sans promo supplementaire |
| Achat plein tarif | Tag `insensible prix`. PP-E3 avec produits Edition |
| Client recurrent | Reco basees sur historique complet. Ne **pas** redemander Trustpilot si deja donne |

---

## 2.5 Win-Back

### Vue d'ensemble

| Attribut | Detail |
|----------|--------|
| **Objectif** | Reactiver les clients sans achat depuis 90j. Fenetre critique reachat = 30-45j. A 90j → risque churn |
| **Trigger** | Segment dynamique : derniere commande > 90j ET derniere activite email < 180j (sinon → Sunset) |
| **Exclusion** | Contact dans Sunset / B2B / Achat < 90j |
| **Nombre d'emails** | 3 |
| **Duree totale** | 14 jours (J90 → J104) |
| **KPIs cibles** | Reactivation > 3% (achat dans les 30j suivant E1), ouverture > 20% |

### Emails

| # | Timing | Objet | Contenu cle | CTA |
|---|--------|-------|-------------|-----|
| WB-E1 | J+90 sans achat | "Ca fait longtemps, [Prenom] !" | Constat bienveillant + nouveautes depuis dernier achat + hero image pertinente pour collection preferee | "Decouvrir les nouveautes" → page nouveautes |
| WB-E2 | J+97 (si pas d'achat depuis E1) | "Un petit cadeau pour votre retour" | Code `RETOUR15` -15% (validite 7j) + 3 bestsellers + rappel livraison/3x | "Utiliser mon code -15%" |
| WB-E3 | J+104 (si pas d'achat) | "On reste amis ?" | Ton leger "on comprend, la vie est chargee" + derniere chance `RETOUR15` (48h) + CTA explicite "Oui je veux rester" / "Non merci" | "Utiliser mon code -15%" + preference center |

### Contacts non-responsifs apres WB-E3 → segment "a risque" → observation avant bascule Sunset.

---

## 2.6 VIP (sequence avancee — post-activation M4)

### Vue d'ensemble

| Attribut | Detail |
|----------|--------|
| **Objectif** | Recompenser les clients fideles (2+ achats, panier cumule > 150 EUR). Les traiter en VIP : acces prioritaire, avant-premieres, exclusivites |
| **Trigger** | Entree segment RFM "Champions" ou "Loyaux" |
| **Priorite deploiement** | M4 post-activation, minimum 50 contacts dans le segment |
| **Nombre d'emails** | 3 |

### Emails

| # | Timing | Angle | CTA |
|---|--------|-------|-----|
| VIP-E1 | Entree segment | "Bienvenue dans le club" — reconnaissance + acces prioritaire | Voir avantages VIP |
| VIP-E2 | J+7 | "En avant-premiere pour vous" — nouveau produit avant lancement public | Precommander en exclu |
| VIP-E3 | J+14 | "Merci d'etre la" — offre exclusive VIP (pas un simple code promo : ex. edition limitee signee) | Decouvrir l'exclusivite |

### Regles VIP

- **Aucun code promo standard** : les VIP achetent deja plein tarif. Les recompenser par du contenu exclusif, pas par des remises
- Acces prioritaire aux drops (24-48h avant public)
- Invitation aux events physiques si applicable
- Support client prioritaire

---

## 2.7 Sunset (nettoyage — complete les 6 core mais ne genere pas de CA)

### Vue d'ensemble

| Attribut | Detail |
|----------|--------|
| **Objectif** | Nettoyer la liste des inactifs pour proteger la deliverability |
| **Trigger** | 0 ouverture ET 0 clic depuis 120j (tous flows confondus) |
| **Exclusion** | Achat dans les 120j (client actif meme sans ouvrir emails) / B2B |
| **Nombre d'emails** | 2 |
| **KPIs cibles** | Nettoyage 10-20% inactifs par trimestre, reactivation > 5% |

### Emails

| # | Timing | Objet | Contenu |
|---|--------|-------|---------|
| SU-E1 | J+120 inactivite | "Vous etes toujours la, [Prenom] ?" | Constat factuel + CTA "Oui, je veux rester" (1 clic). Minimaliste, pas de produit |
| SU-E2 | J+130 (si pas de clic) | "Derniere chance de rester dans la famille Univile" | Notification suppression sous 48h + CTA definitif |

### Action post-Sunset

| Resultat | Action |
|----------|--------|
| Clic "je veux rester" | Maintien liste active + tag `reactive via Sunset` |
| Aucun clic E1+E2 | Suppression automatique → segment "archive" (RGPD) |
| Hard bounce E1 ou E2 | Suppression immediate et definitive |

---

# 3. PLAN DE WARM-UP S1-S5

## 3.1 Pourquoi le warm-up est obligatoire

| Facteur | Detail |
|---------|--------|
| Reputation inexistante | univile.com n'a jamais envoye en volume. ISPs (Gmail, Outlook, Yahoo, Orange, Free, SFR) n'ont aucun historique |
| Base jamais contactee | 9 150 contacts accumules sans contact. Adresses potentiellement invalides, abandonnees, ou spam traps |
| Risque envoi massif | 9 150 contacts d'un coup = signal spam massif. Blocage, throttle, ou spam folder garantis |
| Cout reparation | Reputation degradee = 3-6 mois pour reparer. Warm-up = 5 semaines. **Le choix est evident** |

## 3.2 Prerequis AVANT toute activation

Aucun email ne part tant que ces prerequis ne sont pas remplis :

- [ ] SPF / DKIM / DMARC configures et valides (DMARC mode `reject`, pas `none`)
- [ ] Double opt-in active
- [ ] Domaine d'envoi dedie configure (`mail.univile.com`)
- [ ] Analyse de la base completee (segments reels, pas estimes)
- [ ] Hard bounces preemptifs nettoyes (ZeroBounce ou NeverBounce)
- [ ] 18 templates emails prets (voir ci-dessous)
- [ ] Attribution Klaviyo configuree (7j clic, 1j ouverture)
- [ ] Codes promo crees dans Shopify (WELCOME10, PANIER5, RETOUR15)
- [ ] Unsubscribe page personnalisee avec option "reduire frequence"

## 3.3 Les 18 emails prerequis

| Flow | Emails | Total |
|------|--------|-------|
| Welcome | W-E1, W-E2, W-E3, W-E4 | 4 |
| Abandoned Cart | AC-E1, AC-E2, AC-E3 | 3 |
| Browse Abandonment | BA-E1, BA-E2 | 2 |
| Post-Purchase | PP-E1, PP-E2, PP-E3, PP-E4 | 4 |
| Winback | WB-E1, WB-E2, WB-E3 | 3 |
| Sunset | SU-E1, SU-E2 | 2 |
| **TOTAL** | | **18** |

## 3.4 Planning semaine par semaine

### Semaine 1 — 200 meilleurs contacts

| Parametre | Detail |
|-----------|--------|
| Volume | 200 contacts |
| Criteres | Achat < 90j ET ouverture email transactionnel ET email verifie |
| Flows actifs | Welcome Series uniquement |
| Volume envoi estime | ~200-250 emails |
| Seuils securite | Bounce < 1% / Spam < 0,05% / Unsub < 0,3% |
| Seuil passage S2 | Bounce < 1% ET spam < 0,05% ET ouverture > 30% |

### Semaine 2 — 500 contacts

| Parametre | Detail |
|-----------|--------|
| Volume | 500 (200 de S1 + 300 nouveaux) |
| Criteres nouveaux | Clients < 6 mois OU inscrits newsletter < 3 mois + email verifie |
| Flows actifs | Welcome + **Abandon Cart** |
| Volume envoi estime | ~500-700 emails |
| Seuils securite | Bounce < 1,5% / Spam < 0,08% / Unsub < 0,4% |
| Seuil passage S3 | Bounce < 1,5% ET spam < 0,08% ET AC recovery > 3% |

### Semaine 3 — 2 000 contacts

| Parametre | Detail |
|-----------|--------|
| Volume | 2 000 |
| Criteres | Clients < 12 mois + inscrits < 6 mois + S1/S2 engages + email verifie |
| Flows actifs | Welcome + AC + **Browse Abandonment** |
| Volume envoi estime | ~2 000-3 000 emails |
| Seuils securite | Bounce < 2% / Spam < 0,1% / Unsub < 0,5% |
| Seuil passage S4 | Bounce < 2% ET spam < 0,1% ET ouverture globale > 20% |

### Semaine 4 — 5 000 contacts

| Parametre | Detail |
|-----------|--------|
| Volume | 5 000 |
| Criteres | S1-S3 + tous clients + inscrits < 12 mois + email verifie |
| Flows actifs | Tous precedents + **Post-Purchase** + **Winback** |
| Volume envoi estime | ~5 000-8 000 emails |
| Seuils securite | Bounce < 2% / Spam < 0,1% / Unsub < 0,5% |
| Seuil passage S5 | Bounce < 2% ET spam < 0,1% ET ouverture > 18% ET >=1 conversion trackee |

### Semaine 5 — Base complete (9 150)

| Parametre | Detail |
|-----------|--------|
| Volume | 9 150 sauf hard bounces nettoyes |
| Flows actifs | **Les 6 flows core + Sunset** (active en dernier, pour nettoyer) |
| Volume envoi estime | ~9 000-15 000 emails |
| Seuils securite | Bounce < 2% / Spam < 0,1% / Unsub < 0,5% |
| Objectif fin S5 | 6 flows core actifs, reputation etablie, base nettoyee, premiers revenus mesurables |

## 3.5 Regle en cas de depassement de seuil

| Seuil franchi | Action immediate |
|---------------|-----------------|
| Orange (S1-S2) | Reduire volume, investiguer qualite segment, reprendre apres stabilisation |
| Orange (S3-S4) | Stop des envois aux nouveaux contacts, maintenir S1+S2, analyser tranche problematique |
| Rouge (toute semaine) | **STOP immediat**, diagnostic Klaviyo-Ops, nettoyage agressif, escalade Sparky + Marty si bounce > 3% ou spam > 0,15% |

---

# 4. SEGMENTS STANDARDS

## 4.1 Segmentation RFM (Recence, Frequence, Montant)

| Segment | Recence | Frequence | Montant | Taille estimee | Action CRM |
|---------|---------|-----------|---------|---------------|------------|
| **Champions** | < 30j | 3+ achats | > 200 EUR | 1-2% | Programme VIP, avant-premieres, jamais de promo |
| **Loyaux** | < 90j | 2+ achats | > 100 EUR | 3-5% | Cross-sell, gallery wall, UGC, parrainage |
| **Prometteurs** | < 60j | 1 achat | > 50 EUR | 8-12% | Post-Purchase optimise, cross-sell personnalise, incitation 2e achat |
| **Nouveaux** | < 30j | 1 achat | < 50 EUR | 5-8% | Post-Purchase standard, guide accrochage, demande review |
| **A risque** | 60-120j | 1-2 achats | Variable | 15-20% | Winback E1 (nouveautes) |
| **En danger** | 90-180j | 1 achat | Variable | 10-15% | Winback complet avec incentive |
| **Perdus** | > 180j | 1 achat | Variable | 20-30% | Sunset flow puis suppression |
| **Dormants** | > 180j | 0 achat (inscrit seul) | 0 EUR | 30-40% | Sunset accelere (1 email reactivation → suppression) |

### Migrations automatiques

- Nouveau → Prometteur apres 2e achat
- Prometteur → A risque apres 60j sans achat
- A risque → En danger apres 90j
- En danger → Perdu apres 180j
- Perdu → suppression apres Sunset

## 4.2 Matrice flows x segments RFM

| Segment | Welcome | AC | Browse | PP | Winback | Sunset | Newsletter | Promo |
|---------|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| Champions | — | Oui (sans code) | — | Oui (VIP) | — | — | Oui (preview) | Jamais |
| Loyaux | — | Oui (sans code) | Oui | Oui | — | — | Oui | Rarement |
| Prometteurs | — | Oui + code E3 | Oui | Oui | Oui (>90j) | — | Oui | Occasionnel |
| Nouveaux | — | Oui + code E3 | Oui | Oui | Oui (>90j) | — | Oui | Occasionnel |
| A risque | — | Oui | Oui | — | Oui (prioritaire) | — | Oui | Oui (incentive) |
| En danger | — | Oui | — | — | Oui (complet) | Pre-Sunset | Reduit | Oui (fort) |
| Perdus | — | — | — | — | — | Oui | — | — |
| Dormants | — | — | — | — | — | Oui (accelere) | — | — |

## 4.3 Segmentation comportementale

### Par source d'acquisition

| Source | Segment Klaviyo | Traitement |
|--------|----------------|-----------|
| Meta Ads | `source:meta` | Exclure du retargeting Meta si actif email (anti-cannibalisation) |
| Pinterest | `source:pinterest` | Ton visuel/lifestyle, sensibilite esthetique |
| SEO / Google organique | `source:organic` | Intention haute, cross-sell rapide |
| Email (referral) | `source:email` | Deja dans l'ecosysteme, potentiel ambassadeur |
| Direct | `source:direct` | Fidele qui revient, VIP potentiel |
| B2B (tag Shopify) | `source:b2b` | Flow B2B dedie uniquement. **Jamais** de flow B2C |

### Par destination preferee

| Destination | Segment | Usage CRM |
|-------------|---------|-----------|
| La Reunion | `dest:reunion` | Contenu + cross-sell Reunion. Persona Marie principal |
| France metropole | `dest:france` | Paris, Bretagne, Cote d'Azur. Persona Julien |
| Maurice | `dest:maurice` | Cross-sell Maurice + Reunion (archipel) |
| Martinique | `dest:martinique` | Cross-sell Antilles |
| Guadeloupe | `dest:guadeloupe` | Cross-sell Antilles |
| Japon | `dest:japon` | Segment experimental, nouveau |
| Multi | `dest:multi` | Client explorateur, cross-sell inter-destinations |

### Par format prefere

| Format | Segment | Action |
|--------|---------|--------|
| 30x40 (Petit) | `format:petit` | Upsell vers 50x70 "Pour un rendu encore plus spectaculaire" |
| 50x70 (Moyen, bestseller) | `format:moyen` | Cross-sell standard, gallery wall |
| 61x91 (Grand) | `format:grand` | Client premium. Cadre assorti. Edition suggeree |
| Carte postale 13x18 | `format:carte` | Petit budget ou cadeau. Upsell 30x40 |

### Par device

| Device | Segment | Templates |
|--------|---------|-----------|
| Mobile | `device:mobile` | Mobile-first, CTA gros, peu de texte |
| Desktop | `device:desktop` | Templates riches, grid produits plus grands |

## 4.4 Segmentation B2B vs B2C

### Identification B2B (2 criteres suffisent → tag `segment:b2b`)

| Critere | Source | Fiabilite |
|---------|--------|-----------|
| Tag Shopify "B2B" | Alex/Baptiste | Haute |
| Email professionnel (domaine entreprise) | Email domain | Moyenne |
| Montant commande > 300 EUR | Shopify | Haute |
| Format 40x50 (exclusif B2B) | Line item | Certaine |
| Frequence > 3x/trimestre | Analyse Klaviyo | Haute |
| Nom entreprise dans adresse | Shopify customer | Moyenne |

### Flows B2B dedies

| Flow | Contenu | Trigger |
|------|---------|---------|
| B2B Welcome | Catalogue pro + grille tarifaire + contact commercial (Alex/Baptiste) | Tag B2B ajoute |
| B2B Post-Order | Confirmation + suivi + proposition renouvellement | Commande B2B |
| B2B Nurturing | Nouveautes catalogue, cas d'usage (hotels, bureaux, restaurants), offres volume | Trimestre (campagne manuelle) |
| B2B Reactivation | "Ca fait longtemps" + nouveau catalogue + contact commercial | 120j sans commande B2B |

### Regle de muraille B2B / B2C

- Un contact B2B ne recoit **JAMAIS** un email B2C (exclusion dans tous les flows B2C)
- Un contact B2C ne recoit **JAMAIS** un email B2B
- Contact non classe → flow B2C par defaut
- Migration B2C → B2B possible (requalification Alex/Baptiste)
- Migration B2B → B2C exceptionnelle (decision Marty uniquement)

---

# 5. REGLES DELIVERABILITY

## 5.1 Seuils de surveillance

| Metrique | Outil | Frequence | Vert | Orange (attention) | Rouge (STOP) |
|----------|-------|-----------|------|--------------------|-----------| 
| Bounce rate global | Klaviyo | Chaque envoi | < 1% | 1-2% | > 2% |
| Hard bounce rate | Klaviyo | Chaque envoi | < 0,5% | 0,5-1% | > 1% |
| Spam complaint rate | Klaviyo + Google Postmaster | Quotidien | < 0,05% | 0,05-0,1% | > 0,1% |
| Taux ouverture global | Klaviyo | Hebdo | > 25% | 15-25% | < 15% |
| Taux clic global | Klaviyo | Hebdo | > 2% | 1-2% | < 1% |
| Unsubscribe / envoi | Klaviyo | Chaque envoi | < 0,3% | 0,3-0,5% | > 0,5% |
| Sender Score | senderscore.org | Mensuel | > 80 | 60-80 | < 60 |
| Google Postmaster reputation | GPT | Hebdo | Haute | Moyenne | Basse / Mauvaise |
| Blacklist (MXToolbox) | MXToolbox | Hebdo | 0 | 1-2 mineures | Majeure (Spamhaus, Barracuda) |

## 5.2 Actions par seuil

### Orange (attention)

| Metrique | Action | Delai |
|----------|--------|-------|
| Bounce 1-2% | Verifier qualite segment, identifier invalides, nettoyer | 24h |
| Spam 0,05-0,1% | Verifier contenu (mots declencheurs), verifier frequence, reduire volume | 24h |
| Ouverture 15-25% | Revoir objets, verifier heure envoi, tester nouveaux objets | 1 semaine |
| Sender Score 60-80 | Audit hygiene liste, accelerer Sunset | 1 semaine |

### Rouge (STOP)

| Metrique | Action immediate | Notifie |
|----------|-----------------|---------|
| Bounce > 2% | STOP tous envois sauf transactionnels, nettoyage d'urgence, verification bulk | Sparky (P0) + Marty |
| Spam > 0,1% | STOP envois marketing, analyse contenu, verification provenance contacts | Sparky (P0) + Marty |
| Ouverture < 15% | Reduire volume 50%, focus segments engages, revoir strategie | Sparky (P1) |
| Sender Score < 60 | Plan remediation complet (nettoyage agressif, reduction volume, focus engagement), 4-8 semaines | Sparky (P0) + Marty |
| Blacklist majeure | STOP total, contact blacklist operator, audit complet | Sparky (P0) + Marty + Nexus |

## 5.3 Bonnes pratiques permanentes

### Authentification SPF / DKIM / DMARC

- **SPF** : enregistrement TXT autorisant Klaviyo a envoyer depuis `mail.univile.com`
- **DKIM** : signature cryptographique Klaviyo (2 CNAME ajoutes au DNS)
- **DMARC** : policy `reject` (pas `none`, pas `quarantine` non plus a terme) + rapports agregeés a `dmarc@univile.com`
- Verification mensuelle via MXToolbox + Google Postmaster Tools
- **Jamais** envoyer avant que les 3 soient verts

### Hygiene permanente

| Pratique | Detail | Frequence |
|----------|--------|-----------|
| Double opt-in | Tous nouveaux inscrits confirment avant reception | Permanent |
| Sunset flow actif | Contacts 0 ouverture/clic 120j → nettoyage auto | Continu |
| Nettoyage trimestriel | Verification bulk ZeroBounce/NeverBounce. Suppression invalides, spam traps, role-based (info@, contact@) | Trimestriel |
| Frequence maitrisee | Max 1 email marketing / contact / semaine (hors transac). Exception BF / Noel : 2-3/semaine max | Permanent |
| List-Unsubscribe header | Chaque email marketing | Permanent |
| Ratio texte / image | > 60/40. Eviter emails 100% image (declencheur spam) | Permanent |
| Separation reputation | `mail.univile.com` = marketing, `univile.com` = transactionnel | Permanent |

## 5.4 Plan de crise deliverability

Declencheur : Sender Score < 50 OU blacklist Spamhaus.

| # | Etape | Delai | Responsable |
|---|-------|-------|-------------|
| 1 | STOP total emails marketing | Immediat | Klaviyo-Ops |
| 2 | Notification Sparky (P0) + Marty | < 15 min | Keeper |
| 3 | Diagnostic (cause : bad list, spam content, hack ?) | < 2h | Keeper + Nexus |
| 4 | Nettoyage agressif (suppression non-engages 60j+) | < 4h | Klaviyo-Ops |
| 5 | Demande retrait blacklist | < 24h | Nexus |
| 6 | Reprise progressive : 100 contacts engages uniquement | J+2 | Keeper |
| 7 | Augmentation +100/jour si metriques OK | J+2 a J+30 | Keeper |
| 8 | Retour a la normale | J+30-60 | Keeper |
| 9 | Post-mortem | J+3 | Keeper → Sparky → Marty |

**Temps retour estime** : 4-8 semaines pour Sender Score > 70. **Prevenir coute 10x moins cher que guerir.**

---

# 6. GLOSSAIRE KPIs

| KPI | Formule | Seuil bon | Seuil mauvais |
|-----|---------|-----------|--------------|
| RPR (Revenue Per Recipient) | Revenue / Nombre recipients | > 1 EUR | < 0,30 EUR |
| Recovery rate (AC) | Conversions AC / Abandons AC | > 8% | < 3% |
| Part email dans CA | CA attribue email / CA total | > 18% M6 | < 5% M6 |
| Taux reachat 90j | Clients 2+ achats 90j / Total clients | > 12% M6 | < 8% |
| CLV 12m | Somme achats / client / 12 mois glissants | > 80 EUR | < 40 EUR |
| Cout par email | (Klaviyo + production) / Emails envoyes | < 0,02 EUR | > 0,05 EUR |
| ROI email | Revenue email / Cout email total | > 30x | < 10x |
| List growth rate | (Inscrits - Unsubs - Nettoyages) / Taille debut mois | > 2%/mois | Negatif |
| Taux engagement liste | Contacts ayant ouvert/clique 1 email 90j / Total | > 30% | < 15% |

---

*Reference CRM/Lifecycle Univile — a consulter avant toute brief Keeper → Maeva-Director, Forge, Klaviyo-Ops.*
