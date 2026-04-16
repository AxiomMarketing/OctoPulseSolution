# Format d'un flux direct autorisé

Les flux directs permettent à 2 Masters de communiquer sans passer par Sparky. Ils sont numérotés dans `shared/communication-protocol.md`.

## Format d'ajout

Quand `/octopulse:create-agent` configure des flux directs, il ajoute au tableau existant :

| # | Émetteur | Récepteur | Type de message | Règle |
|---|----------|-----------|-----------------|-------|
| N+1 | {{AGENT_A}} | {{AGENT_B}} | {{MESSAGE_TYPE}} | CC Sparky dans 30 min |

## Règles immuables

1. **Max 3 aller-retours** sans escalade Sparky (Pattern 4.12)
2. **CC Sparky obligatoire** dans les 30 min après échange (Pattern 4.11)
3. **Pas de flux direct entre services différents** — passage par Sparky obligatoire
4. **Sentinel ne participe jamais** aux flux directs — il observe

## Exemples de flux existants marketing

1. Stratege → Forge (briefs créatifs)
2. Stratege → Atlas (demandes data)
3. Forge → Maeva-Director (validation ton)
4. Radar → Stratege (insights paid)
5. Radar → Forge (alertes events créatives)
6. Radar → Maeva-Director (alertes events editorial)
7. Keeper → Maeva-Director (briefs contenu email)
