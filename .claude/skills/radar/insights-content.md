---
name: radar:insights-content
description: Produire des insights contenu organique pour Maeva — tendances TikTok/Instagram, hashtags émergents, timings publication, max 5/semaine.
---

# Insights Contenu pour Maeva

## Quand l'utiliser
- Consolidation hebdo vendredi (pour planning Maeva semaine suivante)
- À la demande de Maeva sur un thème saisonnier
- Détection viralité dans la niche Réunion/cadeaux/déco/diaspora

## Entrées requises
- Outputs scouts `radar-scout-tendances` (TikTok, Instagram Reels, Pinterest) + `radar-scout-concurrence` (competitors organique)
- Calendrier éditorial Maeva (`team-workspace/marketing/references/maeva-calendrier-editorial.md`)
- Destinations Univile (`team-workspace/marketing/references/destinations-univile.md`)

## Étapes

1. **Collecte 7j** : outputs scouts + veille hashtags + sons viraux TikTok

2. **Filtrage niche** : l'insight est-il activable pour Marie / Julien / Christiane ET aligné destinations Univile (Réunion, Mayotte, diaspora) ?

3. **Typologie** :
   - **Format trend** (nouveau format Reel/carousel qui cartonne)
   - **Son/musique trend** (utilisable dans nos Reels)
   - **Hashtag émergent** (pas encore saturé)
   - **Contenu viral adjacent** (à adapter à notre univers)
   - **Timing** (créneau horaire performant par plateforme)

4. **Scoring** :
   - Viralité actuelle (saves, shares, vues)
   - Fenêtre d'opportunité (jours avant saturation)
   - Fit voix de marque Univile
   - Effort production

5. **Top 5 insights** formatés :
   ```markdown
   ### INS-CONTENT-YYYY-WXX-NN — [titre]
   - **Source** : [plateforme + URL exemple + date]
   - **Type** : [format/son/hashtag/viral/timing]
   - **Persona cible** : Marie / Julien / Christiane
   - **Plateforme(s)** : Instagram / TikTok / Pinterest
   - **Effort** : [faible/moyen/élevé]
   - **Fenêtre** : [JJ-MM → JJ-MM+X]
   - **Proposition activation** : [1 post / série / campagne contenue]
   ```

6. **Livraison** : SendMessage → Maeva + CC Sparky résumé 2 lignes

## Sortie
- `team-workspace/marketing/radar/insights-content/YYYY-WXX.md`
- Message structuré vers Maeva vendredi pour planning lundi

## Règles strictes
- **Voix de marque** : chaque insight doit respecter personas + ton Univile (intime, authentique, chaleureux — pas corporate cold)
- **Pas de tendance générique** : TOUJOURS adaptée niche Univile
- **Fenêtre opportunité** explicite (date limite activation)
- **Max 5 insights/semaine** (Maeva pilote son calendrier, Radar suggère)
- **Pas de brief production** : c'est à Maeva de briefer son contenu

## References
- Calendrier éditorial : `team-workspace/marketing/references/maeva-calendrier-editorial.md`
- Destinations : `team-workspace/marketing/references/destinations-univile.md`
- Personas : `team-workspace/marketing/references/personas-details.md`
- Sub-agents : `.claude/agents/subs/radar-scout-tendances.md`, `radar-scout-concurrence.md`
