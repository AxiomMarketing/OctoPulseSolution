---
name: funnel:pinterest-strategy
description: Stratégie Pinterest organique — boards destinations, cadence pins, SEO pins, rich pins produits Printful. Piloté par pin-master sub-agent.
---

# Pinterest Strategy

## Quand l'utiliser
- Setup initial boards
- Revue mensuelle performance
- Ajustement saisonnier (Fête des Mères, Noël)

## Entrées requises
- Sub-agent `funnel-pin-master` (production)
- Catalogue produits Printful (assets visuels)
- Destinations Univile (Réunion, Mayotte, diaspora) + personas
- Analytics Pinterest

## Étapes

1. **Structure boards** :
   - 1 board par destination (Réunion, Mayotte, autres)
   - 1 board par thématique (Art Mural, Cadeaux Diaspora, Déco Créole)
   - 1 board "Coulisses Univile" (authentique, communauté)

2. **Cadence publication** :
   - 15-20 pins/semaine (via pin-master, batchs hebdo)
   - Timing : mâtins et soirées week-end
   - Mix : 70% pins produits, 20% inspiration, 10% behind-the-scenes

3. **SEO pins** :
   - Titre ≤ 60 chars avec keywords destinations
   - Description 150-300 chars avec hashtags pertinents
   - Alt text obligatoire (accessibilité + SEO)

4. **Rich Pins** :
   - Activer rich pins produits (prix, dispo) connectés Shopify
   - Mise à jour automatique lors refresh catalog

5. **Boards collaboratifs** (optionnel) :
   - Partenariats influenceurs diaspora
   - Validation Marty avant activation

6. **Mesure** :
   - Impressions, saves, outbound clicks (vers univile.com)
   - CVR Pinterest vs autres canaux organiques (via GA4)

## Sortie
- Plan Pinterest mensuel : `team-workspace/marketing/funnel/pinterest/YYYY-MM.md`
- Instructions pin-master (briefs batchs hebdo)
- Rapport performance dans `funnel:weekly-report`

## Règles strictes
- **Validation humaine obligatoire** sur chaque batch (anti-drift de marque)
- **Pas de pins générés à la chaîne** sans curation
- **Alignement charte** Univile stricte (palette, pas de cadres rouges/dorés)
- **Pas de repin de concurrents** (intégrité)
- **Rich pins produits = priorité** (trafic qualifié vers univile.com)

## References
- Sub-agent : `.claude/agents/subs/funnel-pin-master.md`
- Destinations : `team-workspace/marketing/references/destinations-univile.md`
- SEO : `funnel:seo-audit`
