---
name: stratege:instruction-atlas
description: Instruction campagne vers Atlas — INS-YYYY-MM-DD-NN, allocation ad sets A/B/C, créatives promote/test/kill, kill rules, calendrier.
---

# Instruction vers Atlas

## Quand l'utiliser
- Après validation du plan hebdo (transformer décisions en instructions exécutables)
- Pivot intra-semaine si signal majeur
- Scaling d'un winner (`stratege:scaling-decision`)

## Entrées requises
- Plan hebdo validé
- Briefs Forge envoyés (IDs)
- Budget total semaine
- Kill rules en vigueur (Coudac)

## Format instruction

```markdown
# INS-YYYY-MM-DD-NN — [objet court]

## Contexte
- Plan hebdo ref : [PLAN-YYYY-WXX.md]
- Hypothèses testées : [HYP-IDs]

## Structure ad sets

### Ad Set A — Broad
- Budget : X€/j
- Créatives actives : [BRF IDs]
- Créatives à kill : [BRF IDs si applicable]

### Ad Set B — LAL
- Budget : Y€/j
- Audience LAL source : [meilleurs clients 2% / diaspora / ...]
- Créatives actives : [BRF IDs]

### Ad Set C — Test
- Budget : Z€/j (~30-60€ sur durée test)
- Hypothèse testée : [HYP-ID]
- Créatives : [BRF IDs]

## Créatives — Actions

| BRF ID | Action | Ad Set | Raison |
|--------|--------|--------|--------|
| BRF-X | PROMOTE | B | Winner S-1, CPA 12€ |
| BRF-Y | KILL | A | Frequency 3,2, CPA 45€ |
| BRF-Z | TEST | C | Nouvelle hypothèse |

## Kill rules actives
- 1,8x CPA target sans conversion → kill
- Frequency > 3 → pause
- ATC>0 sans achat J+5 → kill + flag Nexus

## Calendrier
- Lancement : lundi 14h
- Checkpoint intraday : mardi 18h
- Rapport quotidien : 8h30

## Escalade attendue
- Si 3 kills en série sur Ad Set C → alerter Stratege
- Si MER < 2,0 sur 2j → alerter Stratege
- Si attribution anomalie → flag Funnel

## Budget total semaine
- Total : XXX€
- Split A/B/C : XX% / YY% / ZZ%
- Réserve events : XX€
```

## Étapes

1. **Composer** instruction avec ID INS-YYYY-MM-DD-NN
2. **Sauvegarder** : `team-workspace/marketing/strategie/instructions/INS-YYYY-MM-DD-NN.md`
3. **Envoyer** : SendMessage → Atlas
4. **CC Sparky** résumé 2 lignes
5. **Suivi** : vérifier réception et questionnement Atlas sous 2h

## Règles strictes
- **Atlas EXÉCUTE** : ne pas spéculer sur ce qu'Atlas fera différemment
- **Hyperconsolidation** : max 3 ad sets (jamais de fragmentation — règle Coudac #8)
- **Scaling +20%/jour max** : paliers 50→60→72→86€/j
- **Kill rules standard** : ne jamais les désactiver sans justification + validation Marty
- **Jamais modifier le compte Meta directement** : c'est Atlas

## References
- Format détaillé : `.claude/shared/output-formats.md` section 3
- Scaling : `team-workspace/marketing/references/scaling-framework.md`
- Atlas seuils : `team-workspace/marketing/references/atlas-seuils-alertes.md`
- Coudac : `team-workspace/marketing/references/coudac-12-regles-details.md`
