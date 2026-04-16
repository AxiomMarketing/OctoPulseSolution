---
name: stratege:reaction-event
description: Réaction à un event Radar <24h — évaluation GO/NO-GO, brief express Forge, instruction Atlas, CC Marty si impact >200€.
---

# Réaction Event Radar

## Quand l'utiliser
- Réception `radar:alerte-24h` (score ≥ 70)
- Fenêtre d'action < 72h
- Décision attendue < 4h

## Entrées requises
- ALERT-YYYY-MM-DD-HH de Radar
- Capacité budget flex disponible (réserve events dans `stratege:allocation-budget`)
- Capacité Forge (peut-il produire en 24-48h ?)

## Étapes

1. **Triage rapide (< 1h)** :
   - Fit avec stratégie actuelle ? Oui/Non
   - Budget disponible ? Oui/Non (réserve events mensuelle)
   - Forge dispo ? Check direct auprès de Forge
   - Risque de drift de marque ? Non → OK, Oui → NO-GO

2. **Scoring décision** :
   - Impact estimé (€) vs coût (budget + temps équipe)
   - ROI espéré : > 2x → GO, 1-2x → conditional, < 1 → NO-GO

3. **Décision GO / CONDITIONAL / NO-GO** :
   - **GO** : activation complète
   - **CONDITIONAL** : activation test avec kill rule stricte
   - **NO-GO** : logger + feedback Radar (améliorer scoring)

4. **Si GO** :
   - Brief Forge **express** (format court `stratege:brief-forge` avec flag URGENT) — deadline 24-36h
   - Instruction Atlas **express** (`stratege:instruction-atlas` flag EVENT)
   - Budget : réserve events mensuelle (NE PAS piocher dans budget tests normaux)
   - Créer HYP rapide au registre (statut EN_ATTENTE → rapide vers EN_TEST)

5. **Escalades** :
   - Impact estimé > 200€ : **CC Marty obligatoire via Sparky** AVANT exécution
   - CC Sparky toujours (coordination)
   - CC Maeva si synergie organique possible

6. **Suivi post-event** :
   - Mesure impact réel sous 7j
   - Encoder learning (event + action + résultat)
   - Update budget réserve (reconstituer pour M+1)

## Sortie
- `team-workspace/marketing/strategie/events/EVT-YYYY-MM-DD.md`
- Brief Forge express
- Instruction Atlas express
- SendMessage → Radar (feedback scoring)
- CC Sparky + Marty (si >200€)

## Règles strictes
- **Décision < 4h** sinon fenêtre fermée
- **Pas de piochage budget tests normaux** : réserve events dédiée
- **CC Marty >200€** non négociable
- **Pas de drift de marque** sous prétexte urgence
- **Encoder learning** après (sinon répétition des erreurs)

## References
- Alerte Radar : `radar:alerte-24h`
- Brief : `stratege:brief-forge`
- Instruction : `stratege:instruction-atlas`
- Allocation : `stratege:allocation-budget`
- Escalade : `.claude/shared/escalade-matrix.md`
