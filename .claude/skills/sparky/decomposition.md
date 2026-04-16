---
name: sparky:decomposition
description: Decompose une demande Marty en sous-taches actionnables. Determine si simple (1-2 Masters, exec directe) ou complexe (3+ Masters, validation Marty).
---

# Workflow de Decomposition

## Input
Une demande de Marty (via Archie), transmise verbatim.

## Etape 1 : Copier le verbatim

**Regle #1** : copie exacte, jamais reformule. Conserve la demande Marty mot pour mot.

## Etape 2 : Analyser

Poser les 4 questions :

1. **Quels Masters sont concernes ?** (liste precise)
2. **Y a-t-il des dependances ?** (telle sous-tache depend de telle autre)
3. **Quels sont les delais ?** (implicites ou explicites dans la demande)
4. **Conflits avec taches en cours ?** (verifier le calendrier unifie et les briefs in-progress)

Pour le routage par domaine, se referer au tableau ci-dessous :

| Type de demande | Master principal | Support |
|---|---|---|
| Question strategique (pricing, positionnement) | Stratege | — |
| Analyse performance Meta Ads | Atlas | Stratege (si interpretation) |
| Donnees ventes / CA / MER / rentabilite | Funnel (sub-agent Data-Analyst) | — |
| Nouveau brief creatif | Forge | Maeva-Director (pour le ton) |
| Contenu editorial | Maeva-Director | — |
| Alerte concurrence/tendance | Radar | Stratege (si action requise) |
| Probleme conversion | Nexus | Atlas (data) |
| CRM / fidelisation / VIP | Keeper | Nexus (si lien conversion) |
| Probleme technique / API | Nexus | — |
| Analyse multi-domaine | Stratege + Atlas | Autres selon besoin |
| Campagne evenementielle | Stratege (plan) | Atlas (budget) + Forge + Maeva |

### IMPORTANT — Data Analyst

Les questions "donnees ventes" / "CA total" / "MER" / "rentabilite" vont chez **Funnel (sub-agent Data-Analyst)**. PAS Atlas (qui ne voit que Meta Ads). Data-Analyst a la vue multi-canal (Shopify + Meta + Klaviyo + Pinterest).

## Etape 3 : Determiner Simple vs Complexe

| Critere | Simple (exec directe) | Complexe (validation Marty) |
|---|---|---|
| Nombre Masters impliques | 1-2 | 3+ |
| Budget implique | 0 EUR | > 0 EUR |
| Impact calendrier | Aucun | Decalage taches existantes |
| Reversibilite | Facile | Irreversible ou couteux |
| Duree estimee | < 24h | > 24h |

**Si UN seul critere complexe** → validation Marty obligatoire avant execution.

## Etape 4 : Produire le Plan de Mission

Utiliser le format `output-formats.md` section 1 :

```markdown
## Plan de Mission [SPK-YYYY-MM-DD-NNN]

**Demande Marty (verbatim)** : "[copie exacte]"
**Date** : YYYY-MM-DD
**Complexite** : Simple | Complexe
**Validation requise** : Oui | Non

### Sous-taches

| # | Tache | Master | Deadline | Depend de | Format attendu |
|---|---|---|---|---|---|
| 1 | ... | Stratege | YYYY-MM-DD HH:MM | — | Brief creatif format BRF |
| 2 | ... | Forge | YYYY-MM-DD HH:MM | #1 | 3 visuels 1:1 / 4:5 / 9:16 |
| 3 | ... | Atlas | YYYY-MM-DD HH:MM | #2 | Rapport performance J+7 |

### Risques identifies
- [risque 1 + mitigation]
- [risque 2 + mitigation]

### Estimation de livraison finale : [date/heure]

### Pre-approbations applicables : [PA-XX si applicable]
```

## Etape 5 : Selon la complexite

### Si SIMPLE (validation requise = Non)
1. Sauvegarder le plan dans `team-workspace/marketing/briefs/inbox/SPK-YYYY-MM-DD-NNN.md`
2. Envoyer chaque sous-tache aux Masters via `SendMessage` au format output-formats.md section 1
3. Logger dans la consolidation du jour

### Si COMPLEXE (validation requise = Oui)
1. Sauvegarder le plan dans `team-workspace/marketing/briefs/inbox/SPK-YYYY-MM-DD-NNN-DRAFT.md`
2. Envoyer a Marty (via Telegram Channel) pour validation avec options A/B si pertinent
3. Attendre validation explicite avant dispatch
4. Si rejete : revoir le plan
5. Si valide : renommer en SPK-YYYY-MM-DD-NNN.md et dispatcher

## Etape 6 : Update memoire

1. Logger la decomposition dans ClawMem shared (pattern reconnaissable pour futures demandes similaires)
2. Mettre a jour le calendrier unifie avec les nouvelles deadlines

## Regles specifiques

- **Jamais** de sous-tache sans Master responsable
- **Jamais** de "quand tu peux" — toujours une deadline
- **Chaque** Master doit acknowledge sa mission dans les 15 min
- **Contexte minimal** — 2-5 lignes max par sous-tache, pas le dossier complet
