---
name: sparky:orchestration
description: Orchestre un projet multi-agents (3+ Masters) ou une mission complexe. Regle des 3 Masters, prevention double-emploi, coordination.
---

# Workflow d'Orchestration

## Quand l'utiliser

**OBLIGATOIRE** si :
- 3+ Masters impliques simultanement
- Mission transversale (impacte plusieurs domaines)
- Cron programme (briefing quotidien, hebdo, mensuel)
- Campagne evenementielle

**PAS obligatoire** si :
- 1-2 Masters → echange direct autorise (via les 7 flux)

## Regle des 3 Masters

Des qu'une action necessite **3 ou plus Masters simultanement**, Sparky orchestre. Pas un Master qui contacte les 2 autres (cela creerait un goulot d'etranglement et casserait la hierarchie).

## Etape 1 : Identifier le Master principal

Un seul Master principal par mission. Les autres sont en support.

### Matrice de routage

| Mission | Principal | Support |
|---|---|---|
| Campagne evenementielle (event Radar) | Stratege | Radar, Forge, Atlas, Maeva |
| Lancement produit | Stratege | Forge, Atlas, Maeva, Keeper |
| Pivot strategique | Stratege | Atlas, Sentinel (audit d'impact) |
| Black Friday | Stratege | Tous |
| Audit systeme | Sentinel | Tous (observes, pas sollicites) |
| Consolidation rentabilite | Funnel (Data-Analyst) | Atlas, Stratege, Keeper |

## Etape 2 : Verifier les dependances

Construire un DAG (Directed Acyclic Graph) des dependances :

```
[Sous-tache A] → [Sous-tache B] → [Sous-tache D]
                               ↗
            [Sous-tache C]
```

- **Pas de cycle** : si A depend de B et B depend de A → impossible, revoir.
- **Chemin critique** : identifier la plus longue chaine de dependances. C'est ce qui determine la deadline globale.
- **Paralleliser** ce qui peut l'etre (A et C en parallele si independantes).

## Etape 3 : Envoyer les missions en parallele

Pour toutes les sous-taches **sans dependance entre elles** : envoyer les missions en parallele via SendMessage multi-agents.

```
SendMessage(to: "stratege", message: "<mission 1>")
SendMessage(to: "atlas", message: "<mission 2>")
SendMessage(to: "radar", message: "<mission 3>")
```

Le systeme Teams de Claude Code gere les reponses en parallele — tu recois les acknowledges au fur et a mesure.

## Etape 4 : Gerer les dependances sequentielles

Pour les sous-taches **avec dependance** : ne lancer la tache N+1 qu'apres reception de l'output de la tache N.

Exemple :
- Forge produit les visuels (tache 1)
- Atlas lance la campagne Meta avec ces visuels (tache 2, depend de 1)
- Le TaskList de Claude Code permet de declarer cette dependance

```typescript
TaskCreate({ subject: "Forge produit visuels", description: "..." })
TaskCreate({ subject: "Atlas lance campagne", description: "..." })
// Puis declarer la dependance :
TaskUpdate({ taskId: "2", addBlockedBy: ["1"] })
```

## Etape 5 : Prevention du double-emploi

**Une sous-tache = UN seul Master responsable.** Les autres sont en support.

Si 2 Masters s'auto-attribuent la meme tache :
- Intervenir immediatement
- Trancher selon la matrice de routage
- Informer les deux Masters par message clair
- Logger dans les decisions

## Etape 6 : Monitoring de la mission

A chaque tick (si en mode KAIROS) ou manuellement :

- Verifier que chaque Master a acknowledge dans les 15 min
- Verifier l'avancement selon les deadlines intermediaires
- Si un Master est en retard > 2h : escalader ou reassigner selon PA-02

## Etape 7 : Consolidation au fur et a mesure

Des que chaque Master livre son output :
- Lire le livrable dans `team-workspace/marketing/briefs/done/`
- Verifier coherence avec les autres outputs
- Detecter contradictions → escalader

A la fin, consolider via le skill `sparky:consolidation`.

## Formats output

Pour chaque mission envoyee a un Master, utiliser le format `output-formats.md` section 1.

Pour la consolidation finale, utiliser le format `output-formats.md` section 4.

## Regles critiques

1. **Contexte minimal suffisant** — ne pas transmettre tout le dossier, juste ce que le Master doit savoir
2. **Deadline explicite** — chaque mission a une deadline precise
3. **Acknowledge obligatoire** — chaque Master confirme reception et faisabilite dans 15 min
4. **CC sur echanges directs** — si des Masters echangent en direct pendant la mission, ils doivent te CC
5. **Zero directive procedurale** — tu dis QUOI et QUAND, pas COMMENT
