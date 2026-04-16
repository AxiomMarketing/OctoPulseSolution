# Contexte Business — OctoPulse

> Solution d'intégration d'agents IA en entreprise. Le système qu'on construit EST aussi le produit commercial.

**Dernière mise à jour** : 2026-04-16
**Site** : octopulse.ai
**Contact** : contact@octopulse.ai | +262 692 22 08 25 (Réunion) | +33 6 51 09 28 87 (France)
**Statut** : Site en ligne, MVP interne opérationnel (Univile = premier client)
**Entité juridique** : UNIVILE SAS (SIRET 891 146 490 00042)

---

## 1. IDENTITÉ

| Attribut | Valeur |
|---|---|
| **Nom** | OctoPulse |
| **Tagline** | "Votre entreprise, augmentée par l'IA opérationnelle" |
| **Type** | Intégration d'agents IA en entreprise |
| **Site** | octopulse.ai |
| **Fondateur** | Jonathan Dewaele |
| **Localisation** | La Réunion + Paris |
| **Disponibilité** | Lun–Ven, 8h–18h (heure Réunion, UTC+4) |
| **Branding** | Logo gradient cyan (#00C8FF) / violet (#9B7FFF) |

---

## 2. POSITIONNEMENT

**"Nous ne vendons pas un logiciel. Nous intégrons un écosystème d'agents intelligents dans vos locaux."**

- Un cerveau opérationnel qui travaille 24h/24
- Installé dans l'infrastructure du client (souveraineté totale, zéro dépendance cloud)
- Conçu sur mesure, connecté aux outils existants
- Security-first : les données ne quittent jamais le périmètre client

### Proposition de valeur en chiffres
| Stat | Valeur |
|---|---|
| Tâches automatisables | 70% |
| Disponibilité | 24h/24 |
| Données chez le client | 100% |
| Économie quotidienne estimée | 6h 05min/collaborateur |

---

## 3. DOUBLE NATURE — Produit commercial + Système interne

### A. Produit commercial (ce qu'on vend)
- Installation d'un système multi-agents IA dans les locaux du client
- Agents spécialisés par métier (compta, admin, relation client, direction)
- Supervision centralisée via dashboard
- Maintenance et évolution continue (abonnement)

### B. Système interne (ce qu'on utilise)
- 22 agents spécialisés (10 masters + 12 subs) pour Univile (marketing)
- Sparky coordinateur + Sentinel meta-analyste + Artchy interface
- KAIROS tick loop autonome 24/7 (17 crons + calendrier + triggers réactifs)
- ClawMem mémoire vectorielle (30 collections)
- 5 APIs connectées (Meta Ads, Shopify, Printful, Klaviyo, PostHog)
- Voice middleware Groq (Telegram vocaux)
- Security stack 7 couches

**Univile est le premier client.** Tout ce qu'on construit en interne valide le produit OctoPulse.

---

## 4. PROBLÈMES CLIENTS ADRESSÉS

1. **Tâches répétitives** — heures sur des opérations manuelles reproductibles
2. **Informations dispersées** — données fragmentées entre CRM, messagerie, ERP, fichiers
3. **Réactivité insuffisante** — clients qui attendent, équipes qui traitent en série
4. **Outils cloud sans maîtrise** — SaaS étrangers, données hors contrôle, non-conformité

---

## 5. USE CASES (4 agents proposés aux clients)

### Agent Comptabilité & Finance
- Traitement automatique factures, relances impayés, rapprochements bancaires
- Tableaux de bord financiers, export expert-comptable
- **Résultats** : -80% temps factures, +35% recouvrement, 0 oubli relance

### Agent Administratif & Secrétariat
- Tri emails, réponses types, gestion agendas, comptes-rendus réunion
- Numérisation/indexation documents, suivi workflows
- **Résultats** : 3h économisées/collaborateur/semaine, -90% emails sans réponse 24h

### Agent Relation Client
- Réponse auto questions fréquentes, traitement réclamations, devis personnalisés
- MAJ CRM automatique, détection churn, rapport satisfaction hebdo
- **Résultats** : <5min délai réponse, +28% satisfaction, 24/7 disponibilité

### Agent Directeur (bras droit)
- Synthèse quotidienne activité + KPIs, alertes critiques
- Briefs et rapports direction, coordination inter-agents
- Dashboard stratégique temps réel, recommandations data-driven
- **Résultats** : 1 point de contact unique, -60% temps réunions

---

## 6. ARCHITECTURE

```
Serveur physique client (Mac Mini dédié)
├── Agent Directeur (tour de contrôle)
│   ├── Agent Comptabilité
│   ├── Agent Administratif
│   ├── Agent Relation Client
│   └── Agents personnalisés...
├── Connexions outils existants (CRM, ERP, messagerie, comptabilité)
├── Réseau privé Tailscale (zéro port exposé)
├── Guardrails sécurité (credentials isolés, validation humaine, audit log)
└── Tableau de bord supervision
```

---

## 7. SÉCURITÉ (6 piliers)

1. **Données hébergées chez le client** — aucune info vers serveurs tiers
2. **Cloisonnement total** — chaque agent = moindre privilège
3. **Guardrails + validation humaine** — actions critiques = confirmation obligatoire
4. **Tailscale** — VPN mesh chiffré, aucun port exposé sur Internet
5. **Traçabilité complète** — chaque action loggée, horodatée, auditable
6. **Sauvegardes incrémentales** — restauration rapide, rétention configurable

---

## 8. PROCESSUS DE DÉPLOIEMENT (8 phases)

| Phase | Titre | Durée |
|---|---|---|
| 1 | Audit organisationnel et technique | 1-2 semaines |
| 2 | Rapport + recommandations + ROI estimé | Fin de phase 1 |
| 3 | Conception architecture multi-agents | 1 semaine |
| 4 | Installation + configuration infra | 2-3 jours |
| 5 | Développement agents + automatisations sur mesure | 2-4 semaines |
| 6 | Phase pilote sur 1 service | 4-6 semaines |
| 7 | Déploiement global + formation par service | 2-4 semaines |
| 8 | Maintenance + optimisation continue | Abonnement mensuel |

**Durée totale estimée** : 10-15 semaines de l'audit au déploiement global.

---

## 9. TARIFICATION

| Offre | Description | Prix |
|---|---|---|
| **Starter** | 1 service audité, 1 Agent Directeur + 1 Agent métier, connexion 2-3 outils, formation pilote, support 3 mois | Sur devis |
| **Enterprise** (recommandé) | Multi-services, Agent Directeur + 4-6 Agents métier, architecture sécurisée, connexion tous outils, dashboard supervision, support prioritaire | Sur devis |
| **Maintenance** | Supervision mensuelle, MAJ + optimisations, nouveaux cas d'usage, rapports performance, support <4h, revue trimestrielle | Abonnement mensuel |

**Trust badges** : Réponse sous 24h · Audit gratuit sans engagement · 100% données sécurisées

---

## 10. STACK TECHNIQUE

### Site octopulse.ai
| Couche | Techno |
|---|---|
| **Frontend** | React 19, Vite 7, Tailwind 4.2, Framer Motion |
| **Hosting** | Docker + Nginx |
| **Lead capture** | Webhook n8n (`n8n.axiom-marketing.io/webhook/axiom-lead`) |

### Système interne (OctoPulse réel)
| Couche | Techno |
|---|---|
| **Runtime** | Claude Code (Opus 4.6 / Sonnet 4.6 / Haiku 4.5) |
| **Agents** | 22 agents (.claude/agents/) avec skills partagées |
| **Orchestrateur** | Sparky (décomposition + consolidation) |
| **Scheduler** | KAIROS daemon Python asyncio (systemd) |
| **Mémoire** | ClawMem multi-vault (GGUF embedding 314MB) |
| **APIs** | Meta Ads, Shopify, Printful, Klaviyo, PostHog (via RAG + validation) |
| **Sécurité** | 7 couches SecureClaw-équivalent |
| **Communication** | Telegram (plugin + voice middleware Groq Whisper) |
| **Secrets** | Bitwarden CLI (cache tmpfs) |
| **Infra** | VPS Hetzner ARM64 Ubuntu 24.04 |

---

## 11. PROSPECTION

- **CTA principal** : "Demander un audit gratuit" (formulaire contact + booking)
- **Sujets** : Demande d'info, Audit gratuit, Devis personnalisé, Partenariat
- **Webhook leads** : `n8n.axiom-marketing.io/webhook/axiom-lead`
- **Canaux à développer** : LinkedIn B2B, content marketing, cas clients publiés

---

## 12. AVANTAGE CONCURRENTIEL

- **Battle-tested** sur cas réel (Univile — e-commerce live, pas une démo)
- **Multi-services** extensible (marketing opérationnel, compta/support/commercial à venir)
- **Français-first** (La Réunion + France, souveraineté données)
- **Security-by-design** (7 couches, pas un add-on)
- **Code custom** (pas un wrapper GPT/ChatGPT, vrai engineering)
- Les produits naissent des prestations Axiom → crédibilité technique

---

## 13. CONFIDENTIALITÉ

**Interne ≠ Externe** : ne JAMAIS divulguer aux prospects :
- Les noms des agents internes (Sparky, Sentinel, Atlas, etc.) → termes génériques : "Agent Directeur", "Agent Comptabilité"
- La stack technique détaillée (ClawMem, KAIROS, Lasso, etc.) → parler résultats
- Les patterns de sécurité spécifiques → dire "security-first, 7 couches"
- Le fait que c'est basé sur Claude Code → dire "IA propriétaire"

**Ce qu'on PEUT partager** :
- Les résultats mesurables (-80% temps factures, etc.)
- Le processus en 8 phases
- Les tarifs (sur devis)
- Les cas d'usage génériques
- Les principes de sécurité (souveraineté, audit trail, validation humaine)

---

_Ce fichier est maintenu par Artchy et les agents OctoPulse._
