---
name: radar:weekly-report
description: Rapport hebdo Radar — lundi 7h30, top 5 insights paid + top 5 content + events 7-30j + mouvements concurrents. CC Sparky.
---

# Rapport Hebdo Radar

## Quand l'utiliser
- **Lundi 7h30** (avant plan-hebdo Stratege 9h et planning Maeva)
- Après exécution de `radar:insights-paid` et `radar:insights-content`
- Hors fenêtre si event majeur détecté (→ `radar:alerte-24h`)

## Entrées requises
- Outputs 4 scouts des 7 derniers jours
- Fichiers produits : `insights-paid/YYYY-WXX.md`, `insights-content/YYYY-WXX.md`, éventuels `events/EVT-*.md`
- Calendar 267 events pour lookahead 30j

## Étapes

1. **Synthèse scouts** : agréger métriques hebdo
   - Volume signaux bruts collectés (par scout)
   - Taux conversion en insight retenu (signal → insight)
   - Taux d'adoption S-1 (insights de la semaine précédente effectivement utilisés par Stratege/Maeva)

2. **Top 5 insights paid** (résumé depuis `insights-paid/YYYY-WXX.md`)

3. **Top 5 insights content** (résumé depuis `insights-content/YYYY-WXX.md`)

4. **Events 7-30 jours** : lookahead calendar, notation impact potentiel Univile

5. **Mouvements concurrents majeurs** : 3 faits marquants max (lancement produit, promo, changement positionnement)

6. **Alertes anticipées** : risques, opportunités saisonnières approchantes

7. **KPIs Radar** :
   - Volume insights produits : X paid / Y content
   - Taux adoption S-1 : Z%
   - Alertes 24h déclenchées : N
   - Faux positifs S-1 : M

## Sortie
- `team-workspace/marketing/reports/radar-weekly/YYYY-W[XX].md`
- SendMessage → Sparky (consolidation)
- SendMessage → Stratege (section paid)
- SendMessage → Maeva (section content)

## Règles strictes
- **Livrable avant 8h30** lundi (Atlas a son rapport à 8h30, Stratege planifie à 9h)
- **Pas de contenu nouveau** : ce rapport résume, il ne génère pas d'insights (ceux-ci viennent de `insights-paid` / `insights-content`)
- **Max 1 page exécutive** + sections détaillées en annexe
- **KPIs transparents** : si taux adoption faible, le dire (feedback vers Stratege/Maeva pour ajuster le format des insights)

## References
- Protocole communication : `.claude/shared/communication-protocol.md`
- Output formats : `.claude/shared/output-formats.md`
- Skills amont : `radar:insights-paid`, `radar:insights-content`
