---
name: keeper:lal-audiences
description: Production audiences LAL pour Stratege — sources seed 1000+, hashage SHA-256, refresh hebdo, metadata YAML.
---

# LAL Audiences pour Stratege

## Quand l'utiliser
- Setup initial LAL sources
- Refresh hebdo (dernière activité)
- Création d'une nouvelle LAL source à la demande Stratege

## Entrées requises
- Segments CRM définis (`keeper:segmentation-crm`)
- Meta custom audiences Univile
- Sub-agent `keeper-klaviyo-ops` pour push Meta

## LAL sources core

### LAL 1% — Meilleurs clients
- **Seed** : Top 10% CLV (min 1000 emails)
- **Usage Stratege** : Ad Set B LAL prioritaire
- **Refresh** : hebdo

### LAL 2% — Clients actifs
- **Seed** : Tous acheteurs 12 derniers mois (min 1000 emails)
- **Usage** : Ad Set B LAL secondaire
- **Refresh** : hebdo

### LAL 3% — Engaged email
- **Seed** : Clicks email 90 derniers jours (min 1000 emails)
- **Usage** : audience chaude nurturing paid
- **Refresh** : hebdo

### LAL Diaspora Réunion
- **Seed** : Diaspora segment (livraison métropole)
- **Usage** : Ad Set B LAL dédié diaspora
- **Refresh** : hebdo

### LAL Acheteurs cadeaux
- **Seed** : Achats avec adresse livraison ≠ adresse facturation
- **Usage** : campagnes Fête des Mères, Noël
- **Refresh** : mensuel

### LAL High AOV
- **Seed** : Commandes > 80€
- **Usage** : audience premium
- **Refresh** : hebdo

## Étapes

1. **Export seed** depuis Klaviyo selon segment
2. **Hashage SHA-256** (RGPD — jamais d'email en clair)
3. **Push Meta custom audience** → Meta crée LAL automatiquement
4. **Vérifier taille** LAL Meta (généralement 1-2% = 600k-1,2M profils France)
5. **Metadata** par LAL :
   ```yaml
   ---
   lal_id: LAL-01-meilleurs-clients
   source_segment: VIP (top 10% CLV)
   seed_size: 1200
   last_refresh: 2026-04-15
   meta_audience_id: 234567890
   usage: Ad Set B prioritaire
   performance_m-1: CPA moyen 14€, ROAS 3,8
   ---
   ```
6. **Notification Stratege** : liste LAL disponibles + metadata (si nouvelle LAL ou refresh majeur)

## Sortie
- `team-workspace/marketing/keeper/lal/LAL-*.md` (1 fichier par LAL)
- `keeper/lal/index.md` (registre)
- Push Meta audiences hebdomadaire
- Notification Stratege lors des changements

## Règles strictes
- **Seed min 1000** (sinon LAL Meta pas fiable)
- **SHA-256 systématique** (jamais email en clair)
- **Refresh hebdo** des LAL actives (sinon décalage seed → audience)
- **Metadata à jour** (Stratege doit savoir quelle LAL utiliser)
- **Pas de doublon** : une LAL = un segment unique

## References
- Segmentation : `keeper:segmentation-crm`
- Sub-agent : `.claude/agents/subs/keeper-klaviyo-ops.md`
- Usage Stratege : `stratege:instruction-atlas` (ad set B)
- Weekly : `keeper:weekly-report`
