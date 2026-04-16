---
name: radar:event-detection
description: Détecter un event exploitable paid/organique en moins de 24h — scoring, filtrage persona, escalade Stratege/Maeva si impact estimé > 50 EUR.
---

# Détection Event <24h

## Quand l'utiliser
- Un scout (concurrence/tendances/actu/calendar) remonte un signal temps réel
- Event calendar (sur les 267 trackés) arrive dans les 7 prochains jours
- Buzz viral sur niche Univile (Réunion, cadeaux, déco, diaspora)
- Mouvement concurrent soudain (promo, relaunch, scandale)

## Entrées requises
- Signal brut du scout (texte, URL, screenshot, date, source)
- Référentiel personas (Marie / Julien / Christiane)
- Calendar 267 events (`team-workspace/marketing/references/` + vault radar-calendar)

## Étapes

1. **Captation** : consigner le signal dans `team-workspace/marketing/radar/inbox/EVT-YYYY-MM-DD-NN.md`
   - source, date, angle potentiel, lien preuve

2. **Filtrage persona** : l'event concerne-t-il ≥ 1 des 3 personas Univile ? Sinon → classer "hors scope", logger et stop

3. **Scoring impact** (0-100) :
   - Taille audience impactée (0-30)
   - Fraîcheur (0-20, -3pts par jour écoulé)
   - Fit angle Univile 6 angles (0-25)
   - Production faisable < 48h (0-15)
   - Preuve social existante (0-10)

4. **Décision** :
   - Score ≥ 70 → ALERTE 24h (voir `radar:alerte-24h`)
   - Score 50-69 → insight à inclure dans weekly-report
   - Score < 50 → log et archive

5. **Pré-brief** (score ≥ 70) :
   - Hypothèse paid potentielle (persona × angle × format)
   - Ou angle contenu organique pour Maeva
   - Estimation impact € si activé (base : learnings events similaires)

## Sortie
- Fichier `team-workspace/marketing/radar/events/EVT-YYYY-MM-DD-NN.md`
- Si score ≥ 70 : déclenchement skill `radar:alerte-24h`
- CC Sparky systématique (résumé 2 lignes)

## Règles strictes
- **Pas de spéculation** : chaque event = source vérifiable
- **Délai < 24h** non négociable entre détection et escalade Stratege/Maeva
- **Pas d'over-alerting** : max 2 alertes 24h par semaine (sinon Radar perd sa crédibilité)
- **Jamais bypass Stratege** pour décider d'une activation paid

## References
- Scoring détaillé : `team-workspace/marketing/references/scoring-insights-paid.md`
- Event framework : `team-workspace/marketing/references/event-detection.md`
- Personas : `team-workspace/marketing/references/personas-details.md`
- Angles 6 : `team-workspace/marketing/references/angles-6-details.md`
- Sub-agent calendar : `.claude/agents/subs/radar-calendar.md`
- Protocole alerte : `radar:alerte-24h`
