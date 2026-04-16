# Nexus — Framework d'Audit Tunnel de Conversion

> Document de reference pratique pour le domaine CRO / Conversion (Nexus). Utilise avec `/Users/admin/octopulse/.claude/shared/univile-context.md` pour le contexte business.

**Derniere mise a jour** : 2026-04-13
**Metrique directrice** : RPV (Revenue Per Visitor) = CA / Sessions
**Trafic Univile** : ~3 000 sessions/mois (97% mobile, 3% desktop)
**Conversion actuelle** : ~1% | **Cible M6** : 1,5% | **Cible M12** : 2%

---

## TABLE DES MATIERES

1. [Framework d'audit — Vue d'ensemble](#1-framework-daudit--vue-densemble)
2. [KPIs par etape du tunnel](#2-kpis-par-etape-du-tunnel)
3. [Checklist quick wins UX (bi-hebdo)](#3-checklist-quick-wins-ux-bi-hebdo)
4. [Patterns de problemes recurrents](#4-patterns-de-problemes-recurrents)
5. [Diagnostic technique](#5-diagnostic-technique)
6. [Framework ICE pour prioriser les quick wins](#6-framework-ice-pour-prioriser-les-quick-wins)
7. [Mode operatoire cyclique](#7-mode-operatoire-cyclique)

---

# 1. FRAMEWORK D'AUDIT — VUE D'ENSEMBLE

## 1.1 Tunnel de conversion Univile — cartographie

```
IMPRESSIONS META
    |
    v
LINK CLICKS (CTR ~1,51%)
    |
    v
LANDING PAGE VIEWS (~72,7% des clics)
    |
    v
VIEW CONTENT (multi-vues, ~174% = bonne exploration)
    |
    v
ADD TO CART (~9,1% des VC)  ← POINT DE FRICTION PRINCIPAL
    |
    v
INITIATE CHECKOUT (~44,7% des ATC)
    |
    v
PURCHASE (~41,7% des IC)
```

**Diagnostic 2026 (base March 22) :** Le funnel post-ATC est SAIN. Le probleme est AVANT le Add to Cart, sur la page produit.

## 1.2 Metrique directrice : RPV

```
RPV = CA total / Sessions uniques
RPV = Taux de conversion x AOV
RPV actuel Univile = ~5,67 EUR
```

| Cible | Actuel | M3 | M6 | M12 |
|-------|--------|-----|-----|------|
| RPV | 5,67 EUR | 6,25 EUR | 7,00 EUR | 9,00 EUR |
| Taux conversion | 1% | 1,25% | 1,5% | 2% |
| AOV | 50 EUR | 52 EUR | 55 EUR | 65-70 EUR |

**Tout ce que Nexus fait doit augmenter le RPV.** Si une optimisation augmente la conversion mais baisse l'AOV au point que le RPV diminue, c'est un echec.

## 1.3 Les 6 fonctions de Nexus

1. Auditer le tunnel complet (cartographie + drop-offs)
2. Identifier frictions (technique, cognitive, emotionnelle, financiere, processuelle)
3. Prioriser via ICE
4. Concevoir et suivre les quick wins (5-8 par sprint bi-hebdo)
5. Concevoir les tests (quand trafic le permet — voir section strategie test)
6. Monitorer le RPV (alerte si baisse > 15% sur 2 semaines)

## 1.4 Taxonomie des frictions

| Type de friction | Exemples | Impact typique |
|-----------------|----------|---------------|
| **Technique** | Page lente, erreur 404, bouton non fonctionnel, image cassee | Abandon immediat |
| **Cognitive** | Description confuse, trop d'options, prix pas clair, navigation complexe | Hesitation → abandon |
| **Emotionnelle** | Pas de social proof, pas de reassurance, design amateur, images basse qualite | Defiance → abandon |
| **Financiere** | Prix trop eleve percu, frais livraison surprise, pas de paiement fractionne visible | Abandon panier |
| **Processuelle** | Trop d'etapes checkout, formulaire trop long, compte obligatoire | Abandon checkout |

---

# 2. KPIs PAR ETAPE DU TUNNEL

## 2.1 Landing pages — premiere page vue apres clic

| Element | Quoi verifier | Standard / Benchmark | Outil |
|---------|--------------|----------------------|-------|
| **Message match** | Pub → landing : coherence visuelle + textuelle | 100% coherence | Verif manuelle |
| **Hero section** | Proposition de valeur claire < 3 secondes | Above the fold | PostHog heatmaps |
| **LCP** (Largest Contentful Paint) | Vitesse chargement principal | < 2,5 s | PageSpeed Insights |
| **FID** (First Input Delay) | Reactivite | < 100 ms | PageSpeed Insights |
| **CLS** (Cumulative Layout Shift) | Stabilite visuelle | < 0,1 | PageSpeed Insights |
| **Social proof above the fold** | Trustpilot, avis, clients | >=1 element visible sans scroll | Verif manuelle |
| **Mobile responsive** | iPhone SE (375px), boutons > 44px, texte > 16px | Aucun element coupe | Test mobile reel |
| **CTA principal** | Un seul CTA clair, visible, contraste | Bouton contraste fort | Verif manuelle |
| **Distractions** | Pop-ups, bannieres non essentiels | Minimum | PostHog session recordings |
| **Offres visibles** | Livraison offerte 70 EUR, 3x sans frais 100 EUR | Dans les 3 premieres secondes | Verif manuelle |

### Regle de message match

| Type trafic | Landing page optimale |
|-------------|----------------------|
| Pub produit specifique | Page produit du produit (ideal) |
| Pub collection (ex: Reunion) | Page collection Reunion avec Piton en hero |
| Pub marque / generique | Homepage ou "Notre histoire" |
| Google Shopping | Page produit |
| Pinterest | Page produit ou collection |
| SEO | Page optimisee pour le mot-cle |

Homepage comme landing par defaut pour toutes les pubs = **message match = 0** = friction majeure.

## 2.2 Pages collection

| Element | Quoi verifier | Standard |
|---------|--------------|----------|
| Navigation / filtrage | Le visiteur trouve son lieu/region facilement | Filtres region, style, prix, format |
| Images produit | Taille suffisante, attractives, coherentes | Min 300x400px, ratio consistant |
| Prix visible | Sans clic supplementaire | Prix sous chaque produit |
| Nombre de produits / page | Eviter paralysis of choice | 12-24 / page |
| Tri par defaut | Best-sellers mis en avant | "Recommandes" ou "Best-sellers" en premier |
| Quick view | Details sans quitter la collection | Hover / clic rapide : image zoom + prix + ATC |
| Breadcrumbs | Contexte de navigation | Visibles et fonctionnels |
| Mobile scroll | Fluide, lazy loading | Pas de saccade, pas de CLS |
| Vide / erreur | Message + suggestion si filtre sans resultat | — |

## 2.3 Pages produit — LE POINT CRITIQUE

La page produit est l'endroit ou la decision d'achat se prend. Point de friction principal identifie (VC → ATC = 9,1%). **Nexus consacre la majorite de ses efforts ici.**

### 2.3.1 Vue d'ensemble des zones

| Zone | Elements | Priorite |
|------|---------|----------|
| Images | Galerie, zoom, mockups, angles | **CRITIQUE** |
| Titre + Prix | Clarte, format, promotions | **CRITIQUE** |
| Description | Emotion d'abord, specs ensuite | HAUTE |
| Options | Format, cadre, quantite | HAUTE |
| Social proof | Avis, etoiles, Trustpilot, nombre ventes | **CRITIQUE** |
| Trust elements | Fabrication, livraison, paiement, retours | HAUTE |
| CTA | Bouton ATC visible, couleur, taille, texte | **CRITIQUE** |
| Cross-sell | Suggestions complementaires | MOYENNE-HAUTE |
| Urgence / Rarete | Stock, edition limitee | MOYENNE |
| Mobile UX | Boutons, scroll, images, texte | **CRITIQUE** (97% trafic) |

### 2.3.2 Images produit

| Critere | Standard optimal | Impact conversion |
|---------|-----------------|-------------------|
| Nombre d'images | 4-6 min (produit seul, mockup interieur, detail, packaging, en situation) | +40% ATC (Shopify 2025) |
| Mockup en situation | >=2 photos en interieur realiste | +15-25% ATC (Baymard) |
| Zoom disponible | Pinch-to-zoom mobile, hover desktop | Attendu par 56% (NNGroup) |
| Qualite image | Min 1500x2000px, WebP compression | Images floues = -20% confiance |
| Coherence galerie | Meme eclairage, meme style | Incoherence = amateur percu |
| Video (ideal) | 5-15s affiche en situation dans un interieur | +85% ATC avec video (Wyzowl 2025) |

### 2.3.3 Description produit — ordre Univile

Alignement charte editoriale (emotion d'abord, specs ensuite) :

| Ordre | Zone | Contenu |
|-------|------|---------|
| 1 (toujours) | Hook emotionnel | "Le port de Honfleur au petit matin. Ce moment ou les bateaux dorment encore." |
| 2 | Histoire du lieu | Anecdote, contexte, pourquoi special |
| 3 | Message personnel | "Si tu connais, tu sais." / "Ce lieu, il te rappelle quoi ?" |
| 4 (en bas, onglet) | Specs produit | Format, papier, impression, cadre |
| 5 | Livraison | Delai, gratuite 70 EUR |

Regles :
- Tutoiement B2C
- Vocabulaire : "affiche" (pas poster, pas print), "art mural" (pas decoration murale), "creation" (pas produit)
- Test : "Si ta grand-mere ne comprend pas, reformule"

### 2.3.4 Social proof — le quick win #1

| Element | Standard optimal | Etat probable Univile |
|---------|-----------------|----------------------|
| Etoiles produit | Sous le titre, visibles sans scroll | A verifier |
| Nombre d'avis | "X avis" cliquable vers section avis | A verifier |
| Avis detailles | 3-5 avis recents visibles | Probablement absent |
| **Trustpilot global** | Badge "4,5/5 sur Trustpilot (260 avis)" | Probablement absent |
| Partenaires B2B | "Deja chez Leroy Merlin et Fnac" | Non exploite |
| UGC | Photos de clients avec leur affiche | Non exploite |

**Impact potentiel** : 92% des consommateurs lisent les avis avant d'acheter (Spiegel Research). Ajouter avis sur page produit = +10-35% conversion. **Univile a 260 avis 4,5/5 Trustpilot + partenaires prestigieux non exploites sur les pages produit.** Quick win #1.

### 2.3.5 Trust elements

| Element | Contenu | Placement |
|---------|---------|-----------|
| Livraison offerte | "Livraison offerte des 70 EUR" | A cote ATC + header sticky |
| Paiement fractionne | "3x sans frais des 100 EUR" | A cote du prix + ATC |
| Retours | Politique claire, rassurante | Sous ATC ou onglet |
| Paiement securise | Icones CB, PayPal, Apple Pay + cadenas | Sous ATC |
| Fabrication | "Imprime sur papier premium mat" | Dans specs |
| Origine | "Marque nee a La Reunion" (diaspora) | Footer / A propos |
| Garantie | Satisfaction garantie | Pres ATC |

### 2.3.6 CTA (Bouton Add to Cart)

| Critere | Standard | Justification |
|---------|---------|--------------|
| Texte | "Ajouter au panier" | Moins engageant que "Acheter" = reduit anxiete |
| Couleur | Contraste fort avec le fond (Vert Racines #2E6B4F ou unique sur la page) | Element le plus visible |
| Taille | 100% largeur mobile, min 48px hauteur | Doigt = 44-48px min (Apple HIG) |
| Position | Visible sans scroll desktop. Mobile : sticky bas OU apres 1 scroll max | ATC invisible = pas d'achat |
| Feedback | Animation / changement visuel apres clic | Confirme l'action |
| Etat desactive | "Selectionnez un format" si pas de selection | Evite clic frustrant |

### 2.3.7 Cross-sell — leviers AOV

| Type | Implementation | Impact AOV estime |
|------|---------------|------------------|
| "Vous aimerez aussi" | 4-6 produits meme region/style sous description | +5-15% |
| "Completez votre mur" | 2-3 affiches gallery wall | +15-25% |
| Pack / Bundle | "La Trilogie Reunionnaise" 3 affiches prix reduit | +30-50% |
| Upsell format | "Prenez le grand format pour seulement +13 EUR" | +5-10% |
| Upsell cadre | "Ajoutez un cadre noir pour X EUR" | +25-35 EUR / commande |

### 2.3.8 Mobile UX (97% du trafic — priorite absolue)

| Critere | Standard | Probleme courant |
|---------|---------|-----------------|
| Taille boutons | Min 44x44px, ideal 48x48px | Clics manques |
| Taille texte | Min 16px body, 14px annotations | Plisser les yeux = partir |
| Pas de scroll horizontal | Aucun element ne deborde | Images larges, tableaux non responsifs |
| Images adaptees | WebP, compression, lazy loading | LCP > 2,5s |
| Espacement zones cliquables | Min 8px entre clics | Clics accidentels |
| Formulaires | Input type adapte (email, tel), autocomplete | Clavier non adapte |
| Navigation sticky | Header compact scroll, ATC sticky bas | Perdre le CTA en scrollant |
| Galerie images | Swipe fluide, dots indicateurs | Swipe qui bug = frustration |

## 2.4 Panier / Mini-cart

| Element | Standard optimal | Impact |
|---------|-----------------|--------|
| Resume clair | Image + nom + format + cadre + prix / article | Clarte = confiance |
| Modification facile | Changer quantite, format, supprimer sans reload | Friction = abandon |
| Sous-total visible | Haut ET bas du panier | Toujours savoir combien |
| **Barre progression livraison** | "Plus que X EUR pour la livraison gratuite" | +8-15% AOV (Shopify 2025) |
| Barre progression 3x | "Plus que X EUR pour 3x sans frais" | +5-10% AOV supplementaire |
| Cross-sell dans panier | 2-3 "Completez votre mur" | +10-20% AOV |
| Code promo | Champ visible mais **pas proeminent** | Trop visible = visiteur part chercher code sur Google |
| CTA Checkout | Gros bouton, contraste, "Commander" / "Passer au paiement" | Bouton le plus important |
| Mini-cart drawer | S'ouvre au clic ATC sans quitter page | Evite perte de contexte |
| Trust badges | Securise + livraison trackee sous CTA | Derniere reassurance |
| Estimation livraison | "Livraison estimee : X-Y jours" | Reduit incertitude |

## 2.5 Checkout Shopify (contraintes)

**Shopify standard (hors Plus) = peu modifiable.**

Nexus ne peut **PAS** :
- Changer layout checkout
- Ajouter/supprimer etapes
- Modifier champs formulaire
- Ajouter code custom

Nexus PEUT :
- Optimiser pre-checkout (tout ce qui est avant)
- Verifier methodes de paiement configurees
- S'assurer que checkout est en francais (EN si detecte)
- Verifier config Shopify Payments (3x sans frais)
- Recommander passage Shopify Plus si volume le justifie

### Metriques checkout

| Metrique | Valeur Univile | Action |
|---------|---------------|--------|
| IC → Purchase | 41,7% | **Deja excellent** — maintenir |
| Abandon checkout par etape | A mesurer | Identifier etape problematique |
| Methode paiement utilisee | A mesurer | Verifier que 3x sans frais est utilise |

## 2.6 Page de confirmation / post-achat

| Element | Objectif |
|---------|----------|
| Confirmation claire | "Merci, votre commande est en route" |
| Numero de commande | Visible, copiable |
| Recap produits | Ce qui a ete commande, quand arrivee |
| Tracking | Des que disponible, via email |
| Incitation UGC / parrainage | Lien vers formulaire photo / code parrainage |
| Upsell complementaire | "Et si vous ajoutiez X a votre commande ? (offre 24h)" |

---

# 3. CHECKLIST QUICK WINS UX (BI-HEBDO)

Cette checklist est parcourue **a chaque audit bi-hebdomadaire** (tous les 15 jours). Chaque item decoche → ligne dans le backlog ICE.

## 3.1 Landing / homepage

- [ ] Message match coherent pour chaque campagne active (Meta, Pinterest, Google)
- [ ] Trustpilot 4,5/5 visible above the fold
- [ ] "Livraison offerte des 70 EUR" visible above the fold
- [ ] Un seul CTA principal, pas d'hesitation
- [ ] LCP < 2,5s mobile
- [ ] Pop-up email apparaissant apres >=15s (pas immediat)
- [ ] Aucune image cassee ou produit sans image

## 3.2 Page collection

- [ ] Prix affiche sous chaque produit (pas de clic pour decouvrir prix)
- [ ] Tri par defaut = best-sellers ou recommandes (pas "date d'ajout")
- [ ] Filtres region / style / prix / format fonctionnels
- [ ] Breadcrumbs presents et coherents
- [ ] Pas de collection vide ou quasi-vide
- [ ] Lazy loading images activé
- [ ] Bouton "ajouter au panier" rapide (quick view) disponible

## 3.3 Page produit

- [ ] 4-6 images minimum par produit
- [ ] Mockup en situation (interieur realiste) : >=2
- [ ] Zoom disponible (pinch mobile, hover desktop)
- [ ] Etoiles + nombre d'avis sous le titre
- [ ] 3-5 avis detailles visibles sans clic
- [ ] Badge Trustpilot "4,5/5" visible
- [ ] "Livraison offerte des 70 EUR" a cote du prix ET du bouton ATC
- [ ] "3x sans frais des 100 EUR" a cote du prix ET du bouton ATC
- [ ] Selection format : visuelle (icones tailles), pas dropdown texte seul
- [ ] Prix par format affiche a cote de chaque option
- [ ] Cadre : visuels des 3 options (noir, blanc, bois naturel)
- [ ] Guide de taille avec schema
- [ ] Description : emotion d'abord, specs en bas (onglet si possible)
- [ ] Cross-sell "Vous aimerez aussi" : 4-6 produits
- [ ] Cross-sell "Completez votre mur" : 2-3 affiches gallery wall
- [ ] Upsell format + cadre dans section options
- [ ] CTA "Ajouter au panier" 100% largeur mobile, min 48px hauteur
- [ ] CTA sticky bas d'ecran mobile apres scroll
- [ ] UGC integre si disponible (photos clients)

## 3.4 Panier / mini-cart

- [ ] Mini-cart drawer active (pas redirection vers page panier)
- [ ] Barre de progression livraison gratuite visible
- [ ] Barre de progression 3x sans frais (si panier < 100 EUR)
- [ ] Cross-sell dans le panier (2-3 suggestions)
- [ ] Champ code promo discret (pas proeminent)
- [ ] Estimation livraison affichee
- [ ] Trust badges sous le bouton Checkout

## 3.5 Checkout (dans les limites Shopify)

- [ ] CB, PayPal, Apple Pay, Google Pay actifs
- [ ] 3x sans frais (Shopify Payments) configure et actif
- [ ] Shop Pay active (express checkout)
- [ ] Checkout en francais
- [ ] Logo Univile dans le checkout

## 3.6 Technique transverse

- [ ] LCP < 2,5s (mobile)
- [ ] CLS < 0,1 (pas de layout shift au chargement)
- [ ] FID < 100ms
- [ ] Aucune erreur 404 detectee (crawl Firecrawl / Screaming Frog)
- [ ] Sitemap XML a jour
- [ ] Schema.org Product correct sur toutes pages produit
- [ ] Pixel Meta fonctionne (test Pixel Helper)
- [ ] Tracking PostHog fonctionne (test session)
- [ ] Tracking Klaviyo (evenement Viewed Product trigger)

---

# 4. PATTERNS DE PROBLEMES RECURRENTS

## 4.1 Abandon panier

| Cause probable | Symptome | Diagnostic | Action |
|---------------|----------|------------|--------|
| Frais livraison surprise | Abandon a l'etape "adresse de livraison" | Shopify Analytics + session recordings | Afficher "Livraison offerte des 70 EUR" avant le panier |
| Code promo introuvable | Abandon apres ouverture champ code | Session recordings (visiteur tape puis quitte) | Code promo discret OU desactiver le champ sauf pour flows specifiques |
| Pas de 3x sans frais visible | Panier > 100 EUR, abandon | Segmentation abandon par AOV | Afficher 3x sans frais a cote du prix ET dans le panier |
| Paiement incomplet | Methodes limitees | Shopify Analytics methode paiement | Activer PayPal, Apple Pay, Google Pay, Shop Pay |
| Lenteur panier | Temps avant next step > 10s | PageSpeed Insights | Optimiser images panier, reduire JS |
| Compte obligatoire | Formulaire bloque le guest checkout | Config Shopify | Activer guest checkout |
| Doute qualite | Abandon sur page produit avec hover Trust | PostHog heatmap | Ajouter social proof + Trustpilot + UGC |

## 4.2 Lenteur checkout

| Symptome | Diagnostic | Action |
|----------|------------|--------|
| LCP > 3s | PageSpeed Insights | Optimiser hero image (WebP, lazy loading, compression) |
| FID > 100ms | Core Web Vitals | Reduire JS bloquant, differer scripts non critiques |
| CLS > 0,1 | Layout shift au scroll | Reserver espace images (width / height attributs), fonts preload |
| TTFB > 600ms | Shopify server time | Verifier Shopify CDN, apps lourdes a desactiver |
| Mobile vs desktop | Mobile 2-3x plus lent | Optimiser images en priorite mobile, reduire widgets tiers |

## 4.3 Mobile (97% du trafic)

| Probleme | Detection | Fix |
|----------|-----------|-----|
| Boutons trop petits | Heatmaps PostHog (clics cote du bouton) | Min 44x44px, ideal 48x48px |
| Texte trop petit | Session recordings (zoom natif utilise) | Min 16px body |
| Scroll horizontal | Test sur iPhone SE (375px) | Audit CSS, overflow:hidden, tables responsive |
| Images floues | Qualite image | Exporter en 2x resolution, WebP |
| Galerie qui bug | Session recordings (swipe qui ne fonctionne pas) | Auditer script galerie (Aurora theme) |
| Formulaire clavier inadapte | Test manuel | `type="email"`, `type="tel"`, `autocomplete` approprie |
| CTA sous la fold | Scroll analytics | Sticky CTA bas d'ecran ou pousser ATC above the fold |
| Pop-up qui bloque | Session recordings | Delai >=15s avant pop-up, fermeture facile |

## 4.4 Friction emotionnelle / cognitive

| Probleme | Symptome | Action |
|----------|----------|--------|
| Pas de social proof | CTR eleve mais ATC faible | Ajouter 3-5 avis recents + Trustpilot badge |
| Description specs-first | Temps court sur page, 0 interaction description | Refonte emotion d'abord (brief Maeva) |
| Mockup manquant | Abandon page produit sans swipe galerie | Ajouter 2-3 mockups interieur realiste |
| Prix percu trop eleve | Page produit vue, pas d'ATC | Afficher "A partir de 28 EUR" + comparaison taille + justification qualite |
| Hesitation format | Clics multiples sur dropdown format puis abandon | Selection visuelle (icones tailles) + guide de taille |
| Hesitation cadre | Ouverture option cadre puis abandon | 3 visuels des cadres (noir, blanc, bois) |

## 4.5 Cross-canal (Meta → site, Pinterest → site)

| Probleme | Symptome | Action |
|----------|----------|--------|
| Message match faible | Pub produit → homepage generique | Landing page dediee ou redirection page produit |
| Visuel pub ≠ page produit | CTR pub eleve, ATC site faible | Aligner visuel hero produit avec pub |
| Offre pub absente site | "Bienvenue -10%" dans pub mais pas sur la page | Afficher l'offre des le clic (bannière, pop-up non bloquante) |
| Persona pub ≠ ton site | Marie (diaspora) voit pub "ton ile" puis ton site generique | Test de landing pages personas-specifiques |

---

# 5. DIAGNOSTIC TECHNIQUE

## 5.1 Shopify

| Element | Quoi verifier | Outil |
|---------|--------------|-------|
| Theme (Aurora v3.1.1) | Version a jour, pas de bug connu | Shopify admin |
| Apps installees | Nombre, impact performance | Shopify app analyzer |
| Shopify Payments | CB, PayPal, Apple Pay, Google Pay, Shop Pay, 3x sans frais | Admin > Settings > Payments |
| Sitemap XML | Genere automatiquement, contient toutes URLs actives | `univile.com/sitemap.xml` |
| Robots.txt | Pas de blocage accidentel | `univile.com/robots.txt` |
| Hreflang FR/EN | Balises correctes entre versions | View source |
| Structured data | Product schema present et valide | Google Rich Results Test |
| Metadescriptions | Uniques par page | Screaming Frog crawl |
| Redirects 301 | Pas de chaines, pas de 404 | Crawl Firecrawl / Screaming Frog |

## 5.2 Sync Klaviyo

| Flux | Verification | Action si casse |
|------|--------------|-----------------|
| Customer Created | Nouveau compte Shopify → sync Klaviyo | Reset webhook Shopify → Klaviyo |
| Started Checkout | Mise au panier + email → evenement Klaviyo | Verifier app Klaviyo Shopify |
| Placed Order | Commande → evenement + trigger Post-Purchase | Verifier l'event schema |
| Fulfilled Order | Expedition → trigger email suivi | Verifier sync Shopify fulfillments |
| Viewed Product | Vue produit → Klaviyo signup pop-up context | Verifier snippet Klaviyo dans theme |
| Refunded Order | Remboursement → sortie flows lifecycle | Webhook fulfilled_at status |

## 5.3 Tracking / Pixels

| Pixel / Tracker | Quoi verifier | Outil |
|-----------------|--------------|-------|
| **Meta Pixel** | Evenements PageView, ViewContent, AddToCart, InitiateCheckout, Purchase | Meta Pixel Helper (extension Chrome) |
| **Conversions API (CAPI)** | Deduplication pixel + server-side | Meta Events Manager |
| **GA4** | Evenements ecommerce (view_item, add_to_cart, purchase) | GA4 DebugView |
| **Google Ads** | Conversion tag actif (Purchase) | Google Tag Assistant |
| **Pinterest Tag** | PageVisit, AddToCart, Checkout | Pinterest Tag Helper |
| **PostHog** | Session recordings, autocapture events | PostHog dashboard |
| **Klaviyo** | Viewed Product, Active on Site | Klaviyo event feed |
| **Hotjar / heatmaps** (optionnel) | Heatmaps pages cles | Hotjar dashboard |

## 5.4 Performance Core Web Vitals

| Metrique | Cible | Actuel Univile (a mesurer) | Outil |
|----------|-------|---------------------------|-------|
| **LCP** | < 2,5s | A mesurer | PageSpeed Insights, CrUX |
| **FID / INP** | < 100ms / < 200ms | A mesurer | Core Web Vitals |
| **CLS** | < 0,1 | A mesurer | PageSpeed Insights |
| TTFB | < 600ms | A mesurer | PageSpeed / WebPageTest |
| Mobile-friendly | Pass | A mesurer | Google Mobile-Friendly Test |

## 5.5 Synchronisation cross-agents

Nexus envoie des donnees a :
- **Stratege** : perf landing pages, insights message match, recommandations pages dediees (mensuel)
- **Atlas** : taux de conversion par landing, device, source (hebdo + sur alerte)
- **Keeper** : abandon checkout enrichie, segments comportementaux site, triggers recommandes (hebdo)
- **Forge** : insights visuels conversion (mensuel)
- **Maeva-Director** : recommandations structure descriptions produit (ad hoc)

Nexus recoit de :
- **Stratege** : qualite trafic par source, landing pages cibles
- **Atlas** : performance par landing page, breakdown device/age/gender
- **Keeper** : abandon checkout data, taux par etape post-ATC
- **Funnel** : trafic par canal non-Meta (Pinterest, SEO, direct, Google Shopping)
- **PostHog / GA4** : comportement on-site

---

# 6. FRAMEWORK ICE POUR PRIORISER LES QUICK WINS

## 6.1 Principe

Chaque optimisation identifiee est scoree sur 3 axes (1-10) :

- **I — Impact** : impact potentiel sur le RPV (conversion x AOV)
- **C — Confidence** : niveau de confiance dans le resultat (base sur data, benchmarks, best practices)
- **E — Ease** : facilite d'implementation (temps + competences + cout)

**Score ICE = (I x C x E) / 10**

Classement par score decroissant → top 5-8 pour le sprint bi-hebdo.

## 6.2 Grille de scoring

### Impact (I)

| Score | Signification |
|-------|---------------|
| 1-3 | Micro-amelioration, difficile a mesurer individuellement |
| 4-6 | Amelioration mesurable sur une metrique intermediaire (CTR, temps sur page) |
| 7-8 | Impact mesurable sur le RPV (+5-15%) |
| 9-10 | Impact majeur sur le RPV (>15%) ou sur un segment de trafic important |

### Confidence (C)

| Score | Signification |
|-------|---------------|
| 1-3 | Hypothese sans donnees locales ni benchmark |
| 4-6 | Base sur best practice ou benchmark externe |
| 7-8 | Base sur data locale (session recordings, funnel, A/B historique) |
| 9-10 | Base sur donnees locales + benchmark + pattern repetable (ex: ajout avis = 10-35% uplift prouve) |

### Ease (E)

| Score | Signification |
|-------|---------------|
| 1-3 | Necessite refonte majeure, > 1 semaine dev |
| 4-6 | Modification moyenne, 1-3 jours dev |
| 7-8 | Simple, < 1 jour dev ou config Shopify |
| 9-10 | Immediat (< 2h), config admin ou widget standard |

## 6.3 Seuils d'action

| Zone | Score ICE | Action |
|------|-----------|--------|
| **No-brainer** | I>=7, C>=8, E>=8 | Implementer immediatement (priorite absolue) |
| **High priority** | ICE total > 60 | Sprint en cours |
| **Medium priority** | ICE total 30-60 | Sprint suivant |
| **Low priority** | ICE total < 30 | Backlog, reevaluation mensuelle |

## 6.4 Exemples concrets (baseline Univile)

| Quick win | I | C | E | ICE | Priorite |
|-----------|---|---|---|-----|----------|
| Ajouter Trustpilot 4,5/5 + 3 avis sur page produit | 9 | 9 | 9 | 72,9 | **No-brainer** |
| Barre progression livraison gratuite dans panier | 8 | 9 | 8 | 57,6 | High |
| Ajouter 3 mockups interieur sur 10 produits top | 8 | 8 | 6 | 38,4 | High |
| Selection format visuelle (icones) vs dropdown | 7 | 7 | 5 | 24,5 | Medium |
| Mini-cart drawer vs redirection page panier | 7 | 8 | 4 | 22,4 | Medium |
| Video 10s sur 1 produit bestseller | 6 | 6 | 3 | 10,8 | Low |

## 6.5 Processus de decision

1. Lister toutes les optimisations identifiees (audit + backlog)
2. Scorer chaque une sur I, C, E (1-10)
3. Calculer ICE = (I x C x E) / 10
4. Classer par score decroissant
5. Filtrer les no-brainers (I>=7, C>=8, E>=8) — prioritaires
6. Selectionner le top 5-8 pour le sprint en cours
7. Rediger specs detaillees (quoi, ou, pourquoi, comment mesurer, plan rollback)
8. Soumettre a Marty pour validation
9. Documenter etat "avant" (screenshots + metriques)
10. Implementer (dev / Shopify admin)
11. Mesurer etat "apres" (14-30 jours minimum)
12. Conclure : impact reel vs attendu → garder ou rollback

---

# 7. MODE OPERATOIRE CYCLIQUE

## 7.1 Cycle bi-hebdomadaire (tous les 15 jours)

| Etape | Duree | Action |
|-------|-------|--------|
| J1 | 1 jour | Audit leger : parcours checklist section 3, revue KPIs, session recordings (10-20 sessions) |
| J2 | 0,5 jour | Identification frictions + scoring ICE nouveaux items |
| J3 | 0,5 jour | Selection top 5-8 quick wins sprint en cours |
| J3 | 0,5 jour | Specs + soumission validation Marty |
| J4-J11 | 8 jours | Implementation (dev / admin) + documentation avant |
| J12-J15 | 4 jours | Mesure post-implementation, conclusion, mise a jour backlog |

## 7.2 Cycle mensuel (1er du mois)

- Audit complet : parcours exhaustif des sections 2.1 a 2.6
- RPV segmente (source, device, page entree, demographie)
- Analyse cohortes trafic
- Rapport mensuel Sparky → Marty
- Coordination cross-domaines (Stratege, Atlas, Keeper, Forge, Maeva)

## 7.3 Cycle trimestriel

- Audit profond avec Opus thinking
- Revue strategique du tunnel (architecture, navigation, UX globale)
- Tests conceptuels (si trafic > 5 000 sessions/mois)
- Benchmarking concurrence (Juniqe, Desenio, Posterlounge)
- Roadmap CRO du trimestre suivant

## 7.4 Strategie de test par niveau de trafic

| Trafic / mois | Strategie | Justification |
|--------------|-----------|---------------|
| < 5 000 | Quick wins uniquement (patterns prouves) | Pas assez de volume pour A/B fiables |
| 5 000 - 10 000 | Tests sequentiels (avant/apres 30j) | Volume limite, test 1 variable a la fois |
| > 10 000 | A/B tests rigoureux (significativite 95% / puissance 80%) | Volume suffisant, methodologie standard |
| > 50 000 | Multivariate tests | Volume pour tester plusieurs variables simultanees |

**Univile 2026 (~3 000 sessions/mois)** = **quick wins uniquement** en 2026, A/B tests envisageables Q4 2026 / 2027 si trafic atteint 10 000/mois.

## 7.5 Regles d'or Nexus

1. **Rien n'est optimise sans mesure avant/apres** (screenshots + metriques)
2. **Rien n'est deploye sans validation Marty**
3. **Le RPV est la metrique directrice** — jamais optimiser taux de conversion au detriment de l'AOV si le RPV baisse
4. **Mobile-first absolu** (97% du trafic)
5. **Message match avant tout** — coherence pub ↔ landing page = facteur de conversion #1
6. **Social proof est le quick win #1** — 260 avis Trustpilot + partenaires B2B sous-exploites = gisement majeur
7. **Post-ATC fonctionne** (IC → Purchase = 41,7%) — concentrer les efforts sur la page produit (VC → ATC = 9,1%)

---

*Reference CRO / Conversion — a consulter avant tout audit, quick win ou specification de changement site.*
