---
name: nexus:cro-testing
description: Pilotage des tests CRO — hypothèse, hiérarchie ICE, duration min 2 sem / 1000 visiteurs, significance stat, stop criteria.
---

# CRO Testing

## Quand l'utiliser
- Lancement d'un test A/B sur le site Univile
- Validation d'une friction détectée lors de `nexus:tunnel-audit`
- Optimisation d'une landing page spécifique

## Entrées requises
- Hypothèse formalisée (friction identifiée + solution proposée)
- Outil A/B test (PostHog feature flags, Optimizely, ou natif Shopify)
- Data baseline (CVR 30j sur la page/étape)

## Étapes

1. **Formaliser hypothèse** :
   ```
   Observation : [friction détectée, data]
   Hypothèse : "Si on [change X], alors [métrique Y] +/-Z% car [rationnel]"
   ```

2. **Scoring ICE** :
   - Impact potentiel CVR (+X%)
   - Confiance (basé sur benchmark + data)
   - Effort dev (heures/jours)
   - Priorisation parmi les tests en backlog

3. **Design test** :
   - Variant A (control)
   - Variant B (challenger)
   - Metrique primaire : CVR (checkout completion)
   - Metriques secondaires : AOV, time-on-page, bounce rate
   - Split 50/50

4. **Sample size calculation** :
   - MDE (minimum detectable effect) : +10% relatif minimum
   - Power : 80%
   - Significance : 95%
   - Min visiteurs par variant : généralement 1000 (dépend CVR baseline)

5. **Duration** :
   - **Minimum 2 semaines** (cycle hebdomadaire complet)
   - **Maximum 4 semaines** (sinon décision peut être biaisée par contexte)
   - Vérifier sample size atteint avant conclure

6. **Monitoring** :
   - Check hebdo (pas daily — évite biais de récence)
   - Ne jamais stopper prématurément (sauf si significance atteinte + sample size OK)

7. **Stop criteria** :
   - Sample size atteint ET significance > 95% → conclure
   - Sample size atteint mais pas de significance → inconclusif
   - Variant B catastrophique (CVR chute > 20% sig) → kill immédiat

8. **Learning** :
   - VALIDE : winner → déployer 100%
   - INVALIDE : variant B abandonné, control reste
   - Encoder dans `nexus-tunnel-audit.md` learnings

## Sortie
- `team-workspace/marketing/nexus/tests/TST-YYYY-NN.md`
- Rapport résultat dans `nexus:weekly-report`
- Update `team-workspace/marketing/references/nexus-tunnel-audit.md` learnings

## Règles strictes
- **Min 2 semaines + 1000 visiteurs** (non négociable)
- **1 variable par test** (sinon on ne sait pas ce qui marche)
- **Significance 95%** avant conclure (pas 80%)
- **Documentation systématique** (learning encodé même si invalide)
- **Pas de p-hacking** (pas de re-run mid-test pour "voir")
- **Coordination Keeper** si test impacte post-purchase ou trigger email

## References
- Audit tunnel : `nexus:tunnel-audit`
- Plan A/B : `nexus:ab-test-plan`
- Landing optimization : `nexus:landing-optimization`
