# Contexte Business — Mafate

> Plateforme de chiffrement souverain (Encryption as a Service). Produit SaaS en développement avec MVP opérationnel.

**Dernière mise à jour** : 2026-04-16
**Site** : mafate.io
**Statut** : MVP opérationnel (API + dashboard + blog + SDKs)
**Entité juridique** : UNIVILE SAS (même SIRET que Univile/Axiom)

---

## 1. IDENTITÉ

| Attribut | Valeur |
|---|---|
| **Nom** | Mafate |
| **Tagline** | "Where Data Finds Refuge" / "La forteresse de vos données" |
| **Type** | EaaS — Encryption as a Service |
| **Site** | mafate.io |
| **Fondateur** | Jonathan Dewaele |
| **Localisation** | Hébergé en France (Scaleway + OVH) — hors CLOUD Act |
| **Nom** | Réf. au Cirque de Mafate (La Réunion) — forteresse volcanique inaccessible, image de la protection des données |

---

## 2. POSITIONNEMENT

**Alternative souveraine à AWS KMS / Azure Key Vault.**

- 100% français — clés de chiffrement ne quittent jamais le territoire, hors juridiction CLOUD Act
- Conforme dès le premier jour : NIS2, DORA, RGPD
- Intégration en 10 minutes — API REST + SDKs (Node.js, Python, Go), 3 lignes de code
- Traçabilité complète — logs d'audit immutables avec chaîne HMAC-SHA256

**Contexte marché** :
- Coût moyen d'une fuite de données : 4,88M€ (IBM 2025)
- Économies grâce au chiffrement : 1,49M€
- Amende max NIS2 : 10M€ ou 2% du CA mondial
- 15 000 entités françaises impactées par NIS2 (vs <300 sous NIS1)
- Fuites FR récentes : FREE 24M IBANs, France Travail 43M, Viamedis 33M, Boulanger 27M

---

## 3. FONCTIONNALITÉS

### Chiffrement
- **AES-256-GCM** (approuvé ANSSI & NIST)
- Envelope encryption + HSM (PKCS#11)
- Rotation automatique des clés, zéro downtime, re-chiffrement transparent
- Isolation cryptographique par tenant (aucun matériel clé partagé)

### API
| Endpoint | Action |
|---|---|
| `POST /v1/encrypt` | Chiffrer données |
| `POST /v1/decrypt` | Déchiffrer données |
| `POST /v1/hash` | HMAC-SHA256 déterministe |
| `GET /v1/keys` | Lister clés |
| `POST /v1/keys` | Créer clé |
| `POST /v1/keys/{id}/rotate` | Rotation de clé |
| `GET /v1/api-keys` | Lister API keys |
| `GET /v1/audit` | Logs d'audit |

### Dashboard
- Gestion des clés + versions + export
- Gestion des API keys avec permissions granulaires
- Audit logs complets avec recherche/filtrage
- Attestations de conformité exportables (NIS2/DORA/RGPD)
- Billing & abonnement (Stripe)
- Team management + RBAC (Admin, Key Operator, Auditor, Viewer)
- MFA obligatoire (TOTP + WebAuthn)
- SSO (SAML, OAuth)

---

## 4. TARIFICATION

| Plan | Mensuel | Annuel | Opérations/mois | Clés | API Keys | Attestations |
|---|---|---|---|---|---|---|
| **Free** | 0€ | 0€ | 10 000 | 3 | 1 | — |
| **Startup** | 99€ | 79€/mois | 100 000 | 25 | 5 | 1/mois |
| **Business** | 499€ | 399€/mois | 1 000 000 | 100 | 25 | Illimitées |
| **Enterprise** | Sur devis | Sur devis | Illimité | Illimitées | Illimitées | Illimitées |

- **Dépassement** : 0,50€ / 1 000 opérations supplémentaires
- **Attestation supplémentaire (Startup)** : 9,90€
- **Enterprise** : déploiement dédié/on-premise, DPA personnalisé, SLA 99.99%, support 24/7

---

## 5. USE CASES CIBLÉS

| Vertical | Douleur | Exemple fuite |
|---|---|---|
| **Santé (HDS)** | Données patients, résultats labo | Viamedis 33M — numéros sécu exposés |
| **Finance (DORA)** | IBANs, données bancaires | FREE 24M IBANs en clair |
| **SaaS** | Isolation multi-tenant, questionnaires sécu clients | Chiffrement = réponse en 5 min |

---

## 6. STACK TECHNIQUE

| Couche | Technologie |
|---|---|
| **EaaS Server** | Go 1.26, chi, pgx, PKCS#11 (HSM), port :8080 |
| **Dashboard** | AdonisJS 7, Inertia.js, React 19, Tailwind 4.2, port :3333 |
| **Database** | PostgreSQL 17.9 (port 5434), Redis 8.6 (port 6380) |
| **Auth** | Sessions + MFA (TOTP, WebAuthn) + SAML SSO |
| **Paiement** | Stripe |
| **Email** | Resend |
| **Monitoring** | Sentry (Node + React + profiling) |
| **Infra** | Docker, Scaleway + OVH (France), CI/CD GitHub Actions |

### SDKs
- **Node.js** : `@mafate/sdk` (TypeScript, zero magic)
- **Python** : `mafate` (Python 3.9+, requests, TypedDict)
- **Go** : `mafate-go`
- Exemples aussi en PHP, Ruby, Java, C#, cURL

### Code source
- Repo : `github.com/AxiomMarketing/mafate`
- Local : `/Users/admin/WebstormProjects/AppSecurity/`

---

## 7. CONTENU / BLOG

8 articles publiés :
1. CLOUD Act : pourquoi vos données chez AWS/Azure/Google ne sont pas souveraines
2. NIS2 en France : guide définitif pour PME et ETI 2026
3. DORA et chiffrement dans la finance
4. Données santé et chiffrement
5. Ransomware et double extorsion
6. Pourquoi plusieurs clés de chiffrement
7. IBAN en clair et chiffrement en France
8. Hémorragie de données France 2025

---

## 8. ÉTAT (avril 2026) — OPÉRATIONNEL ✅

App complète et en ligne. Serveur en production.

- ✅ API EaaS (encrypt, decrypt, keys, audit, API key CRUD)
- ✅ Dashboard complet (gestion clés, API keys, audit logs, attestations, billing, team)
- ✅ Auth (sessions + MFA TOTP/WebAuthn + RBAC + SAML SSO)
- ✅ Envelope encryption (AES-256-GCM + HSM PKCS#11)
- ✅ Cache 2 niveaux (L1 sync.Map 30s + L2 Redis 5min)
- ✅ Audit log immutable avec chaîne HMAC
- ✅ SDKs (Node.js, Python, Go) + exemples 7 langages
- ✅ Landing page + pricing + blog (8 articles) + pages légales
- ✅ Paiement Stripe intégré
- ✅ Déploiement production (Docker, Scaleway + OVH France)
- ✅ 28 tests unitaires (100% pass)

---

## 9. STRATÉGIE GO-TO-MARKET

> À définir par Jonathan :
> - Canaux d'acquisition (content marketing via blog ? LinkedIn B2B ? partnerships ?)
> - Premiers beta testers ciblés (vertical santé ? finance ? SaaS ?)
> - Timeline lancement public
> - Objectif ARR année 1

---

## 10. CONFIDENTIALITÉ

- Architecture technique interne = confidentielle
- Ne PAS divulguer la stack Go/AdonisJS aux prospects (parler résultats, pas implémentation)
- Les articles de blog sont publics (marketing content)
- Pricing est public
- Code source (GitHub privé) = strictement confidentiel

---

_Ce fichier est maintenu par les agents OctoPulse. Artchy le consulte pour tout sujet Mafate._
