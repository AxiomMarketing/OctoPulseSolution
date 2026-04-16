---
name: nexus:weekly-report
description: Rapport hebdo Nexus — tests en cours, CVR global et par source, top frictions détectées, recommandations Stratege/Funnel.
---

# Rapport Hebdo Nexus

## Quand l'utiliser
- **Lundi 11h** (après Atlas 7h, Radar 7h30, Funnel 10h, Keeper 10h30)
- Consolidation 7 jours

## Entrées requises
- Tests A/B en cours (statut)
- Data PostHog + Shopify 7j
- Atlas signaux (ATC > 0 sans achat)
- Funnel data consolidation

## Étapes

1. **Tests en cours** :
   - Liste TST-IDs
   - Status (J/N jours écoulés / durée prévue)
   - Tendance primary metric (sans conclusion si durée pas atteinte)
   - Tests concluant cette semaine (VALIDE / INVALIDE / INCONCLUSIF)

2. **CVR global** :
   - CVR 7j vs S-1 vs moyenne 4 semaines
   - Par device (mobile vs desktop)
   - Par destination (Réunion, métropole, autres)

3. **CVR par source** :
   - Paid (Atlas) : X%
   - Organic : Y%
   - Email (Keeper) : Z%
   - Direct : W%

4. **Top frictions détectées 7j** :
   - Top 3 drop-offs les plus douloureux (impact € estimé)
   - Session recordings patterns
   - Heatmaps patterns

5. **Post-purchase analysis** :
   - Fairing responses "comment connu ?" (si activé)
   - Reviews mentions friction

6. **Recommandations** :
   - Vers **Stratege** : landing pages à améliorer AVANT scaling paid (sinon budget gâché)
   - Vers **Funnel** : pages SEO à optimiser en priorité
   - Vers **Keeper** : triggers à ajuster (timing, content)

7. **Roadmap tests S+1** :
   - Tests à lancer
   - Tests à conclure
   - Dépendances dev/CMS

## Sortie
- `team-workspace/marketing/reports/nexus-weekly/YYYY-W[XX].md`
- SendMessage → Stratege (section landing à améliorer)
- SendMessage → Funnel (pages SEO)
- SendMessage → Keeper (triggers)
- CC Sparky résumé 3 lignes

## Règles strictes
- **Livrable avant 11h30** lundi
- **Pas de recommandation tranchée** sur CRO sans data > 2 semaines
- **Objectivité** : déclarer INVALIDE même si test voulait marcher
- **Coordination cross-Master** : chaque Master reçoit SA section actionable
- **Validation Marty** pour refontes majeures suggérées

## References
- Audit : `nexus:tunnel-audit`
- CRO : `nexus:cro-testing`
- Plan test : `nexus:ab-test-plan`
- Landing : `nexus:landing-optimization`
- Communication : `.claude/shared/communication-protocol.md`
