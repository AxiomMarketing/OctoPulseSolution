---
name: funnel:seo-audit
description: Audit SEO site univile.com — keywords destinations, content gaps, backlinks, Core Web Vitals, quick wins + long terme.
---

# SEO Audit univile.com

## Quand l'utiliser
- Audit trimestriel standard
- Après refonte majeure site
- Avant campagne contenu organique d'envergure

## Entrées requises
- Sub-agent `funnel-seo-scout`
- Accès Google Search Console + Bing Webmaster
- Ahrefs / SEMrush si disponible (sinon Ubersuggest gratuit)
- Core Web Vitals (PageSpeed Insights)

## Étapes

1. **Keyword research clusters** par destination :
   - Réunion : "affiche Réunion", "cadeau Réunion", "art mural Réunion", "déco créole"
   - Mayotte, autres destinations : idem
   - Long tail : "cadeau diaspora Réunion Paris", etc.
   - Intention SERP : info / navigation / commercial / transaction

2. **Content gaps** :
   - Keywords avec volume > 500/mois où Univile n'est pas positionné top 10
   - Angle de contenu blog / pages destination à créer
   - Prioriser par (volume × CTR) / effort

3. **On-page audit** (top 20 pages) :
   - Title tag (≤60 chars)
   - Meta description (≤155 chars)
   - H1 unique et descriptif
   - Structure H2/H3
   - Alt text images
   - Internal linking
   - Mots-clés cibles naturels

4. **Technical SEO** :
   - Core Web Vitals (LCP < 2,5s, INP < 200ms, CLS < 0,1)
   - Mobile-first (97% trafic mobile)
   - Sitemap.xml à jour
   - Robots.txt correct
   - Schema.org structured data (Product, BreadcrumbList, Organization)
   - Canonical tags

5. **Backlinks** :
   - Profil actuel (DR, nb referring domains)
   - Opportunités diaspora (blogs créoles, annuaires Réunion)
   - Toxic links à désavouer

6. **Quick wins** (< 1 mois) :
   - Meta descriptions manquantes
   - Titles trop longs / dupliqués
   - Images non optimisées
   - Internal linking manquant

7. **Long terme** (3-12 mois) :
   - Nouveau content clusters
   - Backlinks acquisition
   - Refonte pages faibles

## Sortie
- `team-workspace/marketing/funnel/seo-audits/YYYY-MM.md`
- Action items quick wins → transmettre à équipe dev/CMS
- Brief content clusters → Maeva
- CC Sparky

## Règles strictes
- **Mobile-first** toujours prioritaire (97% trafic)
- **Pas de keyword stuffing** (contenu pour humains d'abord)
- **Alignement voix Univile** dans les contenus SEO
- **Tracking CVR** : SEO doit générer conversions, pas juste trafic
- **Sync Maeva** : briefs content SEO cohérents avec calendrier éditorial

## References
- Sub-agent : `.claude/agents/subs/funnel-seo-scout.md`
- Destinations : `team-workspace/marketing/references/destinations-univile.md`
- Consolidation data : `funnel:data-consolidation`
