# Contexte Business — OmnySync

> Solution de connexion Cegid ↔ Shopify. En préparation.

**Dernière mise à jour** : 2026-04-16
**Site** : (pas encore de site)
**Statut** : En préparation (concept, pas encore de développement)

---

## 1. IDENTITÉ

| Attribut | Valeur |
|---|---|
| **Nom** | OmnySync |
| **Type** | Solution de synchronisation ERP ↔ E-commerce |
| **Connexion** | Cegid (ERP) ↔ Shopify (e-commerce) |
| **Fondateur** | Jonathan Dewaele |
| **Statut** | En préparation (avril 2026) |

---

## 2. DESCRIPTION

Connecteur bidirectionnel Cegid ↔ Shopify. Application AdonisJS qui synchronise :
- **Shopify → Cegid** : commandes, clients, données e-commerce
- **Cegid → Shopify** : stocks, prix, catalogue produits, données ERP

**Origine** : développé initialement comme prestation Axiom pour **Pop and Shoes** (client pilote, partenariat 3 ans). Maintenant productisé en SaaS autonome pour d'autres retailers.

---

## 3. CLIENT PILOTE

| Attribut | Valeur |
|---|---|
| **Client** | Pop and Shoes |
| **Relation** | 3 ans de partenariat via Axiom |
| **Résultat** | Sync bidirectionnelle temps réel, 0 perte de données |
| **Stack déployée** | Shopify + Cegid + AdonisJS + GraphQL + Polaris |

---

## 4. MARCHÉ CIBLE

- **Retailers FR** utilisant Cegid (ERP) + Shopify (e-commerce)
- **Taille** : PME et ETI multi-canaux (boutique physique + e-commerce)
- **Douleur** : double saisie manuelle, stocks désynchronisés, commandes web non remontées dans l'ERP
- **Concurrence** : connecteurs existants souvent rigides, peu adaptés au workflow français

> À compléter : pricing model, nombre de prospects identifiés

---

## 5. STACK TECHNIQUE

| Composant | Technologie |
|---|---|
| **Backend** | AdonisJS (TypeScript) |
| **API Shopify** | Admin REST + GraphQL |
| **API Cegid** | À documenter (SOAP ? REST ?) |
| **Sync** | Webhook-driven + batch scheduled |
| **UI admin** | Polaris (Shopify design system) |
| **Hosting** | Self-hosted (Docker) |

---

## 6. ROADMAP

> Statut : client pilote opérationnel (Pop and Shoes).
> Prochaines étapes :
> - [ ] Productiser l'app (multi-tenant, onboarding self-service)
> - [ ] Site web OmnySync (pas encore créé)
> - [ ] Premiers prospects hors Pop and Shoes
> - [ ] Pricing + packaging

---

_Placeholder. Ce fichier sera enrichi au lancement du projet OmnySync._
