---
name: sparky:consolidation
description: Consolide les outputs des Masters, les CC des echanges directs, et les rapports crons en un briefing synthetique pour Marty.
---

# Workflow de Consolidation

## Quand l'utiliser

- **Fin de journee** : briefing quotidien du soir (~18h)
- **Lundi matin** : rapport hebdomadaire (apres reception rapports Masters)
- **1er du mois** : rapport mensuel complet (avec audit Sentinel)
- **Fin de mission multi-agents** : consolidation des livrables

## Input

3 sources de donnees :
1. **Outputs des missions** que tu as orchestrees → `team-workspace/marketing/briefs/done/`
2. **CC des echanges directs** entre Masters → ta memoire (ClawMem) et logs Sparky
3. **Rapports crons** des Masters → `team-workspace/marketing/reports/[agent]-weekly/`

## Etape 1 : Lire et parser les sources

### Missions completees aujourd'hui/cette semaine
```bash
ls -la team-workspace/marketing/briefs/done/ | grep $(date +%Y-%m-%d)
```

### Rapports Masters
```bash
ls -la team-workspace/marketing/reports/*/YYYY-Wxx.md
```

### CC Sparky recus
Interroger ClawMem : `clawmem search "CC SPARKY"` pour la periode.

## Etape 2 : Detecter les contradictions

Cross-verification entre Masters :

- **Atlas vs Funnel (Data-Analyst)** : verifier que les chiffres CA concordent
- **Stratege vs Atlas** : strategie recommandee compatible avec performance reelle ?
- **Forge vs Sentinel** : qualite creative vs patterns detectes ?
- **Radar vs Stratege** : insights Radar pris en compte dans les hypotheses ?

Si contradiction detectee :
- **NE PAS TRANCHER** (tu ne decides pas)
- Inclure les **2 versions** dans la consolidation
- Indiquer source de chaque version
- Escalader a Marty avec options A/B

## Etape 3 : Structurer la consolidation

Utiliser le format `output-formats.md` section 4 :

```markdown
# Briefing [Quotidien | Hebdo | Mensuel] — YYYY-MM-DD

**Sparky** | Consolidation pour Marty

## TL;DR (30 sec)
[3 lignes MAX — les 3 choses que Marty doit savoir]

## Priorites aujourd'hui
1. [Action + responsable + deadline]
2. [...]
3. [...]

## Alertes
[P0/P1 seulement. P2/P3 dans le corps.]

## Performance
| Metrique | Valeur | Source |
|---|---|---|
| CA mois | 17 127 EUR | Atlas-Shopify |
| ROAS Meta | 2,62x | Atlas |
| Progression M6 | 75% | Funnel Data-Analyst |

## Decisions en attente
### A / [Option A]
[2 lignes]
### B / [Option B]
[2 lignes]
### Recommandation Masters
[Stratege : A | Atlas : B | ...]

## Action requise Marty
[Explicite : "Valide A ou B avant 18h"]

## CC echanges directs (resume)
- **Stratege → Forge** : Brief creatif Marie / Transformation / Fete des Meres
- **Radar → Stratege** : Juniqe -15% posters abstraits
- **Keeper → Maeva** : Brief contenu email VIP reachat

## Auto-audit Sparky (hebdo uniquement)
- Decisions autonomes cette semaine : X (dont Y hors PA)
- Detail : [...]

## Sources
- Rapport Atlas : [lien]
- Rapport Stratege : [lien]
- Rapport Radar : [lien]
- [...]
```

## Etape 4 : Regles de synthese

### Concision > exhaustivite
- **TL;DR** : 3 lignes max
- **Priorites** : max 3
- **Alertes** : P0/P1 seulement en tete
- **Metriques** : 4-6 metriques cles, pas toutes

### Sources toujours linkees
Chaque chiffre = lien vers donnee brute. Marty ne depend jamais de ta bonne foi.

### Pas de reformulation Marty
Si tu cites une demande Marty : verbatim exact.

### Recommandations neutres
Presenter les recommandations des Masters, pas TA recommandation. Format : "Stratege recommande X. Atlas recommande Y."

## Etape 5 : Sauvegarder

```
team-workspace/marketing/reports/sparky-consolidations/YYYY-MM-DD.md
```

## Etape 6 : Envoyer a Marty

Via Telegram Channel (si reseau Marty) ou le canal approprie.

Format Telegram :
```
[Briefing quotidien du JJ/MM]

TL;DR :
• [ligne 1]
• [ligne 2]
• [ligne 3]

Action requise : [Valide A ou B avant 18h]

Rapport complet : [lien vers fichier]
```

## Etape 7 : Update memoire ClawMem shared

Enregistrer dans ClawMem shared :
- Les decisions Marty (log complet)
- Les patterns observes
- Les missions completees avec leur resolution

## Regles non-negociables pour la consolidation

1. **Zero interpretation** — tu consolides, tu ne commentes pas les strategies
2. **Contradictions signalees** — jamais masquees
3. **Sentinel signals** — transmis SANS FILTRE si recus
4. **Ton methodique** — pas de flatterie, pas de jargon inutile
5. **Decisions en choix A/B** — jamais de dissertations
