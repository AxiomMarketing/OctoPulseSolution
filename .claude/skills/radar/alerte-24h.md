---
name: radar:alerte-24h
description: Protocole alerte event <24h — brief express Stratege (paid) ou Maeva (organique), CC Sparky + Marty si impact estimé >200 EUR.
---

# Alerte 24h — Event exploitable

## Quand l'utiliser
- Sortie de `radar:event-detection` avec score ≥ 70
- Fenêtre d'exécution de l'event < 72h (sinon passer par le cycle hebdo normal)
- Breaking news / viralité soudaine / mouvement concurrent majeur

## Entrées requises
- Fichier `events/EVT-YYYY-MM-DD-NN.md` produit par `radar:event-detection`
- Scoring impact € (cf. learnings events similaires)
- Validation faisabilité Forge (peut-il produire en 24-48h ?)

## Étapes

1. **Recheck < 1h** : vérifier que l'event n'est pas déjà saturé (sursaut Instagram des 60 dernières minutes = souvent déjà mainstream)

2. **Brief express** (format court) :
   ```markdown
   ### ALERT-YYYY-MM-DD-HH:MM — [titre event]

   - **Type** : [saisonnier / viral / concurrent / opportunité flash]
   - **Fenêtre d'action** : [HH:MM aujourd'hui → HH:MM J+X]
   - **Impact estimé** : XX-YY EUR (base : [learning ref])
   - **Persona cible** : Marie / Julien / Christiane
   - **Angle proposé** : [1 des 6]
   - **Format suggéré** : [image / carousel / story — jamais vidéo paid]
   - **Preuve** : [URL + screenshot]
   - **Recommandation activation** : paid / organique / les deux
   - **Blockers potentiels** : [stock produit / délai prod / conformité charte]
   ```

3. **Routage** :
   - Paid dominant → SendMessage direct → **Stratege**
   - Organique dominant → SendMessage direct → **Maeva**
   - Mixte → les deux, coordination via Sparky

4. **CC obligatoires** :
   - Sparky (résumé 2 lignes)
   - Marty (via Sparky) SI impact estimé > 200 EUR

5. **Suivi post-alerte** :
   - Loguer la décision Stratege/Maeva (GO / NO-GO / WAIT)
   - Mesurer impact réel sous 7j
   - Encoder learning dans `team-workspace/marketing/references/learnings-creatifs.md` via Stratege

## Sortie
- Message Telegram push (via bridge si configuré)
- Fichier `team-workspace/marketing/radar/alerts/ALERT-YYYY-MM-DD-HH.md`
- Entrée dans registre hypothèses Stratege (statut EN_ATTENTE) si GO

## Règles strictes
- **Max 2 alertes 24h par semaine** : au-delà, Radar perd sa crédibilité. Les autres events passent par le hebdo.
- **Jamais déclencher soi-même une campagne** : Radar alerte, Stratege/Maeva décident.
- **Décision GO/NO-GO attendue < 4h** : au-delà, la fenêtre d'exécution est probablement fermée.
- **Pas de FOMO généré artificiellement** : le scoring doit rester honnête. Un event à impact estimé 50€ ne mérite pas d'alerte 24h.
- **Pas de vidéo, pas de retargeting** (règles Coudac — phase actuelle)

## References
- Détection : `radar:event-detection`
- Scoring : `team-workspace/marketing/references/scoring-insights-paid.md`
- Event framework : `team-workspace/marketing/references/event-detection.md`
- Escalade matrix : `.claude/shared/escalade-matrix.md`
- Communication : `.claude/shared/communication-protocol.md`
