---
name: maeva:weekly-report
description: Rapport hebdo Maeva — volume publié, engagement, winners à signaler à Stratege, saisonnalité à venir. Mardi 9h.
---

# Rapport Hebdo Maeva

## Quand l'utiliser
- **Mardi 9h** (après que Atlas ait fourni le rapport hebdo paid lundi)
- Consolidation des 7 jours écoulés

## Entrées requises
- Stats Instagram Insights / TikTok Analytics / Pinterest Analytics / GA4 (via Funnel data-analyst)
- Calendrier publié S-1
- Cross-check avec les tests paid menés (pour détecter synergies)

## Étapes

1. **Volume publié par canal** :
   - Instagram : X reels / Y carousels / Z stories
   - TikTok : X reels
   - Pinterest : X pins (via pin-master)
   - Blog : X articles

2. **Engagement** :
   - Reach, impressions, saves, shares, comments (pas likes en metric principale)
   - Followers gagnés
   - CVR organique (via Funnel GA4)

3. **Top 3 winners organiques** :
   - Posts qui explosent (saves > moyenne × 3 OU shares > moyenne × 5)
   - Angle identifié → signal vers Stratege pour test paid

4. **Top 3 flops** : posts sous la moyenne — analyser pourquoi (angle ? format ? timing ?)

5. **Saisonnalité J+7 / J+30** : events approchants + contenus prévus

6. **Signal vers Stratege** (section dédiée) :
   - Angles organiques winners à tester en paid
   - Contenus viraux adjacents dans la niche (insight)

7. **Signal vers Radar** : besoins d'insights spécifiques pour la semaine suivante

## Sortie
- `team-workspace/marketing/reports/maeva-weekly/YYYY-W[XX].md`
- SendMessage → Stratege (section signal paid)
- SendMessage → Sparky (résumé 2 lignes)
- SendMessage → Funnel (ref croisée data GA4)

## Règles strictes
- **Métrique primaire = saves + shares** (pas likes)
- **Objectivité** : déclarer les flops aussi, pas seulement winners
- **Transparence attribution** : un spike peut venir d'un partage externe (diaspora WhatsApp) — flagger
- **Pas de recommandation paid** : Maeva SIGNALE à Stratege, Stratege DÉCIDE

## References
- Protocole comm : `.claude/shared/communication-protocol.md`
- Output formats : `.claude/shared/output-formats.md`
- Synergie : `maeva:synergy-paid`
- Data analyst : `.claude/agents/subs/funnel-data-analyst.md`
