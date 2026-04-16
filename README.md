# OctoPulse Solution — Plan stratégique 1M€ CA 2026

## Objectif
Atteindre 1 million d'euros de chiffre d'affaires en décembre 2026 avec l'ensemble des produits et services.

## Les 5 entités business (même société : UNIVILE SAS)

| Entité | Site | Description | Status |
|---|---|---|---|
| **Univile** | univile.com | E-commerce affiches déco (Shopify, Printful, Klaviyo) | Actif — CA principal (~17k€/mois) |
| **Axiom Marketing** | axiom-marketing.io | Agence prestation tech (sites, apps, Shopify, tracking, IA) | Actif — peu de clients 2026, panier moyen 3-4k€ |
| **Mafate** | mafate.io | EaaS — Encryption as a Service, chiffrement souverain NIS2/DORA/RGPD | Opérationnel — app + API + SDKs + pricing en ligne |
| **OctoPulse** | octopulse.ai | Intégration agents IA en entreprise, installé chez le client | MVP interne (Univile = 1er client), site commercial en ligne |
| **OmnySync** | (pas encore de site) | Connecteur bidirectionnel Cegid ↔ Shopify (AdonisJS) | Client pilote Pop and Shoes, productisation en cours |

## Structure du repo

- `business/` — Fichiers contexte détaillés par entité (univile.md, axiom-marketing.md, mafate.md, octopulse.md, omnysync.md)
- `persona/` — Personnalité de l'assistant IA (Artchy) + fichiers OpenClaw originaux
- `system-context/` — Configuration système OctoPulse (CLAUDE.md, protocoles)

## Contexte clé pour le plan

### Synergies cross-entités
- Axiom fait des prestations → les clients deviennent prospects pour OctoPulse (IA) et Mafate (chiffrement)
- Univile est le 1er client OctoPulse → preuve vivante pour la vente du produit
- Pop and Shoes (client Axiom) est le 1er client OmnySync → productisation du connecteur
- Mafate répond à NIS2/DORA (obligations chiffrement 2026) → timing marché idéal

### Obligations légales 2026 (Mafate)
- NIS2 : 15 000 entités françaises impactées (vs <300 sous NIS1)
- DORA : obligation chiffrement secteur financier
- RGPD renforcé suite aux fuites 2025 (FREE 24M IBANs, France Travail 43M, Viamedis 33M, Boulanger 27M)
- Loi résilience cyber en cours d'adoption → obligation chiffrement données sensibles

### Localisation
Jonathan Dewaele, La Réunion (UTC+4). Clients : France + DOM-TOM + international francophone.

## Fichiers à lire pour le plan
1. `business/univile.md` (212 lignes) — chiffres, personas, concurrence
2. `business/axiom-marketing.md` (156 lignes) — services, portfolio, prospection
3. `business/mafate.md` (178 lignes) — EaaS, pricing, stack, articles blog
4. `business/octopulse.md` (221 lignes) — produit + système interne, 8 phases déploiement
5. `business/omnysync.md` (79 lignes) — connecteur Cegid↔Shopify
