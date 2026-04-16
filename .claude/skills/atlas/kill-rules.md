---
name: atlas:kill-rules
description: Application des kill rules automatiques — 1,8x CPA sans conversion, frequency >3, ATC sans achat. Escalade si 3 kills série.
---

# Kill Rules

## Quand l'utiliser
- **Monitoring continu** (appliquées dans les rapports quotidiens)
- Déclenchement automatique dès qu'un seuil est atteint
- Revue hebdo (ajustement si pattern inefficace)

## Règles standard (Coudac)

### Règle 1 — CPA dérivé
- **Seuil** : CPA > 1,8x target sans conversion
- **Budget min test** : 50€ (ou 2x CPA target)
- **Action** : kill créative
- **Exception** : aucune — sous 50€ = famine, test invalide de toutes façons

### Règle 2 — Frequency saturation
- **Seuil Alerte** : frequency > 2,5 → FLAG refresh créa (V2 doit être prête)
- **Seuil Pause** : frequency > 3 → PAUSE ad set ou kill créa
- **Action** : Rafraîchir créative AVANT freq 2,5 (proactif)

### Règle 3 — ATC sans conversion
- **Seuil** : ATC > 0 depuis 5 jours sans achat
- **Action** : kill créative ET flag Nexus (probable friction tunnel)
- **Diagnostic** : Nexus audit landing/checkout

### Règle 4 — ROAS effondrement
- **Seuil** : ROAS < 0,8 sur 48h
- **Action** : escalade IMMÉDIATE Stratege (pas kill auto, décision humaine)

### Règle 5 — MER global
- **Seuil** : MER < 2 sur 3j
- **Action** : escalade Stratege + Marty via Sparky

## Étapes application

1. **Check quotidien** (dans `atlas:daily-report`) :
   - Balayer toutes les créatives actives
   - Pour chacune, évaluer règles 1-5

2. **Kill exécution** :
   - Logger dans `team-workspace/marketing/reports/atlas-daily/` section "Actions"
   - Mettre à OFF dans Meta Ads
   - Notifier Stratege si pattern (3 kills série sur ad set C)

3. **Escalade** :
   - 3 kills en série sur Ad Set C → SendMessage Stratege
   - ROAS effondrement → SendMessage Stratege immédiate
   - MER < 2 sur 3j → CC Marty via Sparky

4. **Exceptions documentées** :
   - Si Stratege demande de laisser courir malgré règle → valide pour 48h max, then re-check

## Sortie
- Kills loggés dans daily-report
- Messages d'escalade si seuils critiques
- Update statut créatives dans tracking

## Règles strictes
- **Jamais désactiver une kill rule** sans validation Marty
- **Application rapide** : < 2h après détection seuil
- **Logging obligatoire** : toute kill doit être traçable
- **Ne PAS bypasser** sur pression (même Stratege) sans audit trail

## References
- Seuils complets : `team-workspace/marketing/references/atlas-seuils-alertes.md`
- Coudac règles 3 et 5 : `team-workspace/marketing/references/coudac-12-regles-details.md`
- Escalade : `atlas:alert-escalade`
- Diagnostic tunnel : `nexus:tunnel-audit`
