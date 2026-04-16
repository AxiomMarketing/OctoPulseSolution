---
name: atlas:alert-escalade
description: Protocole d'escalade — ROAS <0,8 → Stratege, ATC sans achat → Nexus, anomalie attribution → Funnel, budget → Marty via Sparky.
---

# Alert & Escalade

## Quand l'utiliser
- Détection d'un seuil critique (voir `atlas:kill-rules`)
- Pattern anormal (3 kills série, attribution divergente)
- Crise potentielle (MER effondre)

## Matrice escalade

| Signal | Seuil | Destinataire | Délai | Canal |
|--------|-------|--------------|-------|-------|
| ROAS < 0,8 (48h) | rouge | Stratege | < 2h | SendMessage |
| MER < 2 (3j) | rouge | Stratege + Marty | < 2h | SendMessage + Sparky |
| 3 kills série Ad Set C | orange | Stratege | < 24h | SendMessage |
| ATC > 0, 0 achat (5j) | orange | Nexus + Stratege | < 24h | SendMessage |
| Attribution Meta ≠ Shopify (>10%) | orange | Funnel | < 24h | SendMessage |
| Frequency > 3 ad set critique | orange | Stratege | < 12h | SendMessage |
| Budget dépassé > +10% | rouge | Marty via Sparky | < 4h | Sparky |
| Event Radar détecté intraday | variable | Radar (check) + Stratege | immédiat | SendMessage |
| Compte Meta suspendu | critique | Marty + Stratege | IMMÉDIAT | Telegram push |

## Étapes

1. **Détection** (via daily report ou monitoring continu)

2. **Classification** :
   - **Rouge** : impact business immédiat (perte revenue, crise)
   - **Orange** : à traiter sous 24h (dégradation possible)
   - **Jaune** : à surveiller (pattern émergent)

3. **Message escalade** (format court) :
   ```markdown
   [ALERT-YYYY-MM-DD-HH:MM — couleur]

   Signal : [X]
   Seuil : [Y] atteint
   Data : [chiffres précis]
   Impact estimé : [€ sur période si non traité]
   Diagnostic préliminaire : [hypothèse]
   Actions prises : [kill / pause / rien]
   Recommandation : [action proposée]
   ```

4. **Envoi** :
   - SendMessage direct au destinataire
   - CC Sparky (sauf si destinataire = Sparky)
   - CC Marty SI rouge ET impact > 500€/j

5. **Suivi** :
   - Confirmation réception attendue < 1h (rouge) ou < 6h (orange)
   - Si pas de réponse : escalade Marty directement
   - Logger toutes les escalades pour audit Sentinel

## Sortie
- Log `team-workspace/marketing/reports/atlas-alerts/ALERT-YYYY-MM-DD-HH.md`
- Messages envoyés
- Suivi complétude action

## Règles strictes
- **Pas d'action unilatérale** sur signal orange/rouge (Stratege décide)
- **Telegram push** pour critique (compte suspendu, CB refusée)
- **Exception kill rules standard** : appliquées SANS escalade préalable (juste log)
- **Pas de spam** : un alert par signal unique (déduplication)
- **Audit trail** : Sentinel doit pouvoir vérifier que les escalades ont eu lieu

## References
- Kill rules : `atlas:kill-rules`
- Seuils : `team-workspace/marketing/references/atlas-seuils-alertes.md`
- Escalade matrix : `.claude/shared/escalade-matrix.md`
- Protocole comm : `.claude/shared/communication-protocol.md`
