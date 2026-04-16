---
name: atlas:daily-report
description: Rapport quotidien 8h30 — pull data Meta 24h, status ad sets A/B/C, alertes seuils, actions recommandées.
---

# Rapport Quotidien Atlas

## Quand l'utiliser
- **Tous les jours 8h30**
- Hors fenêtre si crise (ex. MER < 1 détecté intraday)

## Entrées requises
- Accès Meta Ads (API ou dashboard)
- Historique CPA 7j et 30j par ad set
- Kill rules actives (`atlas:kill-rules`)
- Instructions Stratege en cours

## Étapes

1. **Pull data 24h** : Spend, Impressions, CTR, CPA, ROAS, Frequency, ATC, Purchases — par ad set A/B/C

2. **Comparer 7j et 30j** : tendance positive / stable / dégradation

3. **Alertes** :
   - CPA > 1,8x target sans conversion → FLAG kill
   - Frequency > 2,5 → alerte refresh créa
   - Frequency > 3 → FLAG pause
   - ATC > 0 depuis 5j sans achat → FLAG Nexus
   - ROAS < 0,8 → escalade Stratege immédiate
   - MER global < 2 (J sur J) → alerte

4. **Actions appliquées** (dans la journée précédente) :
   - Kills exécutés
   - Créatives lancées
   - Budgets ajustés

5. **Actions recommandées aujourd'hui** (décisions proposées Stratege) :
   - Budgets à ajuster
   - Créatives à rafraîchir
   - Kills à valider

6. **Format rapport** :
   ```markdown
   # Atlas Daily — YYYY-MM-DD

   ## MER 24h / 7j / 30j
   - 24h : XX | 7j : XX | 30j : XX

   ## Ad Sets
   | Ad Set | Spend | CPA | ROAS | Freq | Status |
   |--------|-------|-----|------|------|--------|
   | A Broad | XX€ | XX | XX | XX | ✅/⚠️/🛑 |
   | B LAL | ... | | | | |
   | C Test | ... | | | | |

   ## Alertes (si applicable)
   - [flag + action]

   ## Actions 24h
   - [exécutées]

   ## Recommandations
   - [proposées]
   ```

## Sortie
- `team-workspace/marketing/reports/atlas-daily/YYYY-MM-DD.md`
- SendMessage → Stratege (si alerte rouge uniquement)
- Sinon silencieux (pas de spam)

## Règles strictes
- **Livrable avant 9h** pour plan hebdo Stratege
- **Alerte rouge immédiate** si MER < 1 ou ROAS < 0,8
- **Pas d'action unilatérale** hors kill rules standard (Stratege décide)
- **Données primes sur intuition**

## References
- Seuils : `team-workspace/marketing/references/atlas-seuils-alertes.md`
- Kill rules : `atlas:kill-rules`
- Weekly : `atlas:weekly-report`
