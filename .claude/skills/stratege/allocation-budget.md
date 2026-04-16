---
name: stratege:allocation-budget
description: Allocation budgétaire mensuelle — ad sets A/B/C, réserve tests, réserve events Radar, arbitrage MER, validation Marty.
---

# Allocation Budgétaire Mensuelle

## Quand l'utiliser
- 1er du mois après bilan mensuel
- Ajustement intra-mois si Marty valide un changement (>±20%)
- Préparation pivot stratégique

## Entrées requises
- Budget total mois M validé par Marty
- Performance historique par ad set
- Learnings winners saisonniers
- Réserve events besoin estimé (Radar calendar)

## Structure standard

```
Budget total mensuel : 100%
├── Ad Set A — Broad    : 35-45% (pérenne, diffusion large)
├── Ad Set B — LAL      : 30-40% (audiences CRM/LAL Keeper)
├── Ad Set C — Test     : 10-20% (hypothèses 2-3/mois, ~180€ base)
└── Réserve events      : 5-10% (Radar 24h, saisonnalité imprévue)
```

## Étapes

1. **Baseline historique** : performance 3 derniers mois par ad set
   - Qui a le meilleur MER ?
   - Qui a le meilleur CPA ?
   - Volume d'achats par ad set

2. **Ajustement saisonnalité** :
   - Fête des Mères, Noël, rentrée, soldes → booster semaines clés
   - Creux saisonniers (janv., août) → réduction si pas d'opportunité

3. **Allocation proposée** :
   - A Broad : adapté aux winners saturés (scaling vertical existant)
   - B LAL : croissance via nouvelles audiences CRM Keeper
   - C Test : 2-3 hypothèses × 50-60€ = ~120-180€
   - Réserve events : minimum 50€ pour pouvoir réagir Radar

4. **Format proposition Marty** :
   ```markdown
   ## Allocation M+1 — Proposition Stratege

   Budget total : XXX€ (validé par Marty YYYY-MM-DD)

   ### Répartition
   - Ad Set A : XX€ (XX%) — [justification]
   - Ad Set B : XX€ (XX%) — [justification]
   - Ad Set C : XX€ (XX%) — [justification]
   - Réserve : XX€ (XX%) — [justification]

   ### Changements vs M-1
   - [diff en + / -]

   ### Scénarios alternatifs
   - Option A : [ce choix]
   - Option B : [alternative]

   ### Recommandation : Option [X]
   ```

5. **Validation Marty** via Sparky (format executive summary)

6. **Exécution** : instruction Atlas cadre mensuelle

7. **Monitoring** : tracking dépenses réelles vs allocation
   - Alert Stratege si dépassement >10%
   - Rebalance intra-mois si nécessaire (avec validation Marty si >±20%)

## Sortie
- `team-workspace/marketing/strategie/budgets/YYYY-MM.md`
- SendMessage → Marty via Sparky (executive summary + options)
- Instruction Atlas (après validation Marty)

## Règles strictes
- **Validation Marty obligatoire** avant exécution
- **Réserve events non-nulle** : toujours prévoir capacité Radar
- **Jamais > 50% budget sur 1 seul ad set** (diversification)
- **Test budget min 180€** (2-3 hypothèses viables)
- **Monitoring réel vs prévu** : debrief mensuel

## References
- Allocation détaillée : `team-workspace/marketing/references/allocation-budgetaire.md`
- Testing framework : `team-workspace/marketing/references/testing-framework.md`
- Scaling : `team-workspace/marketing/references/scaling-framework.md`
- Escalade Marty : `.claude/shared/escalade-matrix.md`
- Bilan mensuel : `stratege:bilan-mensuel`
