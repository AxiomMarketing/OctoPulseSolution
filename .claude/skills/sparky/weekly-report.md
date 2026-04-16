---
name: sparky:weekly-report
description: Produit le rapport hebdomadaire du lundi matin. Consolide les rapports des 8 Masters + Sentinel + plan de la semaine.
---

# Workflow Rapport Hebdomadaire

## Quand l'utiliser

**Lundi matin 8h00** (cron programme).

## Input attendu

Rapports hebdo des 8 Masters + rapport hebdo Sentinel :

| Agent | Livre | Depose dans |
|---|---|---|
| Stratege | Dimanche 20h | `reports/stratege-plans/YYYY-Wxx.md` |
| Atlas | Lundi 7h | `reports/atlas-weekly/YYYY-Wxx.md` |
| Maeva | Dimanche 20h | `reports/maeva-editorial/YYYY-Wxx.md` |
| Forge | Lundi 7h | `reports/forge-deliveries/YYYY-Wxx.md` |
| Radar | Lundi 7h | `reports/radar-insights/YYYY-Wxx.md` |
| Funnel | Lundi 7h15 | `reports/funnel-reports/YYYY-Wxx.md` |
| Keeper | Lundi 7h15 | `reports/keeper-reports/YYYY-Wxx.md` |
| Nexus | Lundi 7h15 | `reports/nexus-audits/YYYY-Wxx.md` |
| Sentinel | Lundi 7h45 | `reports/sentinel-audits/YYYY-Wxx.md` |

## Etape 1 : Verifier reception complete

Avant 8h00 :
```bash
ls -la team-workspace/marketing/reports/*/YYYY-Wxx.md
```

Si un rapport manque :
- Relance automatique Master (PA-02) : "Rapport Wxx attendu, non recu."
- Mention dans le briefing final : "[Agent] rapport en attente — relance envoyee"

## Etape 2 : Parser chaque rapport

Pour chaque rapport, extraire :
- **KPIs cles** (tableau de metriques)
- **Alertes** (P0/P1 urgentes)
- **Recommandations** (permissives)
- **Plan semaine prochaine**

## Etape 3 : Cross-check

Verifier coherence entre les rapports :

| Cross-check | Qui vs Qui |
|---|---|
| CA total coherent | Atlas Shopify vs Funnel Data-Analyst |
| Strategie alignee avec perf | Stratege plan vs Atlas rapport |
| Forge queue compatible calendrier | Forge pipeline vs calendar unifie |
| Email respects warm-up | Keeper vs Atlas (envois live) |
| Insights Radar exploitees | Radar insights vs Stratege hypotheses |

Si incoherence : signaler dans le briefing avec les 2 versions.

## Etape 4 : Structurer le rapport hebdo

Format specifique hebdo :

```markdown
# Rapport Hebdo Sparky — Semaine Wxx (YYYY-MM-DD → YYYY-MM-DD)

**Consolidation pour Marty** | Lundi matin 8h00

## TL;DR
[3 lignes : les 3 choses critiques de la semaine]

## KPIs vs objectifs M6

| Metrique | Valeur W-1 | Valeur Wxx | Tendance | Objectif M6 | Progression |
|---|---|---|---|---|---|
| CA mois-a-date | [...] | [...] | ↑↓ | 22 700 EUR | X% |
| ROAS Meta | [...] | [...] | ↑↓ | > 3x | [status] |
| Trafic 7j | [...] | [...] | ↑↓ | 5 000/m | [status] |
| Conversion | [...] | [...] | ↑↓ | 1,5% | [status] |
| Base email | [...] | [...] | ↑↓ | 12 000 | [status] |
| Catalogue designs | 163 | [...] | ↑→ | 206 (M6) | [status] |

## Priorites de la semaine

### Validees par Marty (en execution)
1. [action + responsable + deadline]
2. [...]

### En attente de validation
1. [Option A/B + recommandations Masters]
2. [...]

## Alertes actives

### P0 (immediat)
- [aucune | liste]

### P1 (24h)
- [aucune | liste]

## Rapport par agent (synthese)

### Stratege
- **Plan semaine** : [...]
- **Hypotheses en cours** : [...]
- **Alertes** : [...]

### Atlas
- **Performance Meta** : [...]
- **Anomalies** : [...]

### Forge
- **Livrables semaine** : [X creatives livrees]
- **File d'attente** : [X briefs en cours]
- **Alertes** : [...]

[... Maeva, Radar, Funnel, Keeper, Nexus ...]

## Audit Sentinel (integre)

### Alertes detectees (max 3)
- [pattern X sur Agent Y]

### Audit Sparky
- Decisions autonomes : X (dont Y hors PA)
- Biais routing : [...]
- Latence : [...]
- Filtrage : [...]

## Arbitrages cette semaine

- ARB-XXX : [conflit] → [resolution]

## CC echanges directs (resume)

| # | Flux | Objet |
|---|---|---|
| 1 | Stratege → Forge | [1 ligne] |
| 2 | Radar → Stratege | [1 ligne] |

## Decisions Marty en attente

### A / [Option A]
[2 lignes]
### B / [Option B]
[2 lignes]
### Recommandation Masters
[...]

## Action requise Marty
[Valide X avant Y]

## Sources
- Rapport Atlas : [lien]
- Rapport Stratege : [lien]
- [...]
```

## Etape 5 : Sauvegarder

```
team-workspace/marketing/reports/sparky-consolidations/weekly/YYYY-Wxx.md
```

## Etape 6 : Envoyer a Marty

Via Telegram Channel :

```
[Rapport Hebdo Wxx]

TL;DR :
• [ligne 1]
• [ligne 2]  
• [ligne 3]

Progression M6 : X% (CA X EUR / objectif 22 700)

Alertes : [nombre P0 + P1]

Action requise : [validation + deadline]

Rapport complet : [lien]
```

## Regles specifiques hebdo

1. **Rapport complet** — tous les Masters synthes, pas de skipping
2. **KPIs vs objectifs M6** systematique (tableau en tete)
3. **Sentinel integre** — section dediee a ses alertes et audit Sparky
4. **Plan semaine** — priorites validees + en attente
5. **Pas d'interpretation** — faits, chiffres, sources

## Post-envoi

1. Logger le rapport dans ClawMem shared
2. Update calendar unified : marquer les missions de la semaine
3. Preparer les missions de la semaine vers les Masters (si validees)
