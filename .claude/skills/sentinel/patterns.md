---
name: sentinel:patterns
description: Detection des 12 patterns problematiques. Appliques a chaque audit (hebdo + mensuel).
---

# Les 12 Patterns Problematiques

## Regles generales

- **Delai confirmation 48h** — pattern signale SEULEMENT s'il persiste 48h+ ou se repete 2+ fois en 30j
- **Score confiance** — >= 8/10 pour signaler, 5-7 stocke, < 5 ignore
- **Source** — toujours source + calcul + periode explicites
- **Urgence marque** — exception : patterns 4.3 Drift de Marque en cas majeur, escalade immediate

---

## 4.1 REPETITION

### Signal
Un agent rejette systematiquement la meme approche malgre des echecs anterieurs ou persiste dans une approche qui a echoue.

### Seuil
2+ occurrences identiques sur 30 jours.

### Exemple Univile
Stratege relance une hypothese persona "Julien" avec le meme angle Transformation apres 2 echecs CPA > 40 EUR, sans iterer sur l'angle ou le format.

### Comment detecter
- Lire registre hypotheses (`team-workspace/marketing/references/registre-hypotheses.md`)
- Comparer avec historique creatif (Forge)
- Verifier les learnings encodes

### Source de donnee
- Registre hypotheses Stratege
- Rapports hebdo Forge
- ClawMem : `clawmem search "hypothese [sujet]"` sur 30j

---

## 4.2 BIAIS DE RECENCE

### Signal
Surponderation des donnees court terme (< 7j) vs tendance 30j.

### Seuil
Decision basee sur < 7j de donnees ignorant la tendance 30j + ecart significatif entre les 2.

### Exemple
Atlas recommande killer une creative apres 2j de baisse, alors que sa tendance 14j reste positive.

### Comment detecter
- Verifier que les rapports cite 30j ET 7j
- Comparer la recommandation avec la tendance 30j
- Si decision ne colle pas avec 30j → alerte

### Source
- Rapports hebdo Atlas
- Rapports Stratege (hypotheses)
- Decisions Marty (justifications)

---

## 4.3 DRIFT DE MARQUE

### Signal
Outputs s'eloignent progressivement de l'identite Univile (personas, ton, visuels, positionnement).

### Seuil
3+ ecarts charte en 30j.

### Exemple
- Forge produit des visuels avec cadres non autorises (rouge, dore)
- Maeva-Director utilise un ton corporate cold plutot qu'intime
- Stratege cible "tout le monde" au lieu des 3 personas

### URGENCE MARQUE
Si ecart majeur (reputation risk, identite de marque violee) : **escalade immediate a Marty + Sparky**, ne pas attendre 48h.

### Source
- `univile-context.md` (reference)
- Outputs Forge, Maeva-Director, Stratege
- Historique creatif

---

## 4.4 SILO INFORMATIF

### Signal
Un agent ignore systematiquement les inputs d'autres agents.

### Seuil
50%+ d'inputs cross-agent non pris en compte dans les outputs.

### Exemple
Stratege genere des hypotheses qui ne prennent jamais en compte les insights Radar des 4 dernieres semaines.

### Comment detecter
- Lister les inputs recus par l'agent (CC Sparky, echanges directs, briefs)
- Verifier s'ils sont reflechis dans les outputs
- Calculer le ratio input utilise / input recu

### Source
- CC Sparky
- Rapports hebdo des agents (section "inputs")
- Cross-analyse outputs vs inputs

---

## 4.5 SUR-PRODUCTION

### Signal
Agent produit des outputs qui ne sont pas consommes en aval.

### Seuil
30%+ de livrables sans utilisation (par un autre agent ou Marty).

### Exemple
Forge livre 5 creatives / semaine, mais Atlas n'en utilise que 2 dans les campagnes (les 3 autres archivees sans test).

### Comment detecter
- Comptabiliser livrables produits
- Comptabiliser livrables consommes en aval
- Ratio

### Source
- Rapports hebdo producteurs (Forge, Maeva, Stratege)
- Rapports hebdo consommateurs (Atlas, Keeper, Nexus)

---

## 4.6 CONSENSUS MOU

### Signal
Le systeme n'explore plus — tous les tests reprennent les memes formats, personas, angles.

### Seuil
< 15% de premieres fois (nouveaux angles, nouveaux formats, nouveaux personas testes) sur 4 semaines.

### Exemple
4 semaines consecutives sans tester persona Julien malgre les learnings L9 (Ad Set A et C jamais testes correctement).

### Comment detecter
- Cataloguer les tests effectues
- Comparer avec la matrice Persona × Angle × Format
- Calculer le % de combinaisons jamais testees / combinaisons totales possibles

### Source
- Registre hypotheses
- Historique creatif
- Rapports hebdo Stratege

---

## 4.7 DEGRADATION PROGRESSIVE

### Signal
La qualite d'un agent baisse lentement mais regulierement (pas une chute brutale).

### Seuil
R² > 0.6 sur 8 semaines (correlation descendante significative).

### Exemple
Pass QC 1er passage de Forge : 85% W-8 → 80% W-4 → 73% cette semaine. Pas de chute mais tendance.

### Comment detecter
- Collecter les metriques hebdo sur 8 semaines
- Calculer la regression lineaire
- Verifier R² > 0.6

### Source
- Rapports hebdo Sentinel precedents
- Metriques stockees ClawMem

---

## 4.8 CANNIBALISATION INTERNE

### Signal
2+ agents produisent des outputs quasi-identiques (redondance).

### Seuil
Similarite > 80% entre outputs de 2 agents differents.

### Exemple
Maeva-Director et Keeper produisent tous deux du contenu sur "Fete des Meres" avec le meme angle et persona, sans coordination.

### Comment detecter
- Comparer les outputs de periodes similaires
- Calculer une mesure de similarite (mots-cles, angles, personas, format)

### Source
- Outputs de tous les agents de contenu (Maeva, Keeper, Forge)

---

## 4.9 ASYMETRIE D'INFLUENCE

### Signal
Un agent domine > 40% des decisions Sparky (volume de missions, poids dans les arbitrages).

### Seuil
> 40% sur 30j.

### Exemple
Stratege genere 45% des missions Sparky, ce qui signifie que les 7 autres Masters se partagent les 55% restants.

### Comment detecter
- Calculer la distribution des missions Sparky par Master
- Verifier equilibrage vs attendu

### Source
- Briefs inbox Sparky
- Decisions Marty

---

## 4.10 ECHANGE DIRECT NON AUTORISE

### Signal
Flux direct entre 2 Masters qui N'EST PAS dans les 7 flux autorises.

### Seuil
1 seule occurrence = alerte (pattern grave car viole le protocole).

### Exemple
Nexus envoie un message direct a Atlas pour une question data (alors que ce n'est pas dans les 7 flux autorises). Devrait passer par Sparky.

### Comment detecter
- Lire les CC Sparky
- Verifier que chaque flux est dans la liste des 7 autorises (voir `communication-protocol.md`)

### Source
- CC Sparky
- Logs messages entre agents

---

## 4.11 CC SPARKY MANQUANT

### Signal
Flux autorise entre Masters mais CC Sparky absent (dans les 30 min).

### Seuil
1 occurrence.

### Exemple
Stratege envoie un brief a Forge mais oublie le CC a Sparky → Sparky perd la visibilite sur les echanges operationnels.

### Comment detecter
- Lister les echanges directs (via logs Masters)
- Verifier presence CC Sparky pour chacun
- Delai max 30 min entre echange et CC

### Source
- Logs Sparky
- Rapports hebdo Masters

---

## 4.12 REGLE DES 3 ALLER-RETOURS VIOLEE

### Signal
Thread direct entre Masters > 6 messages sans escalade a Sparky.

### Seuil
1 occurrence (3 aller-retours = 6 messages).

### Exemple
Stratege et Forge echangent 8 messages sur un brief sans resolution, sans escalader a Sparky.

### Comment detecter
- Analyser les threads directs (via CC Sparky avec historique)
- Compter les messages
- Verifier absence d'escalade

### Source
- CC Sparky
- Logs messages directs

---

## RAPPORT DES PATTERNS

Pour chaque pattern detecte :

```markdown
### Pattern [4.X] — [nom]

- **Agent(s) concerne(s)** : [nom(s)]
- **Premiere detection** : [date]
- **Occurrences** : [nombre en 30j]
- **Metrique** : [valeur actuelle vs seuil]
- **Source** : [fichier + calcul]
- **Confiance** : [score /10]
- **Impact estime** : [mesurable]
- **Recommandation** : "Il serait pertinent de..."
```

---

## REGLES META

1. **Max 3 patterns signales** par rapport hebdo (meme si plus detectes)
2. **Prioriser les patterns avec confiance >= 8** pour le rapport hebdo
3. **Patterns stockes** (confiance 5-7) reexamines la semaine suivante
4. **Urgence marque** (pattern 4.3 majeur) = escalade immediate, hors quota
5. **Feedback loop** : si un pattern signale est rejete par Sparky/Marty → ajuster seuil (±15% max sans validation)
