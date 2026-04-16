---
name: sentinel:weekly-report
description: Produit le rapport hebdomadaire Sentinel destine a Sparky. Max 3 alertes, ratio 60/40 positif/correctif.
---

# Workflow Rapport Hebdomadaire Sentinel

## Quand l'utiliser

**Lundi matin 7h45** (avant le rapport Sparky de 8h00).

## Destinataire

**Sparky** (PAS Marty). Operationnel.

L'audit Sparky lui-meme est exclu de ce rapport (pour eviter auto-censure). Il est dans le rapport mensuel a Marty.

## Etape 1 : Collecter les donnees de la semaine

Lire :
- Rapports hebdo des 8 Masters dans `team-workspace/marketing/reports/*/YYYY-Wxx.md`
- CC Sparky recus (ClawMem shared : `clawmem search "CC SPARKY" --date 7j`)
- Decisions Marty de la semaine : `team-workspace/marketing/decisions/`
- Arbitrages Sparky : `clawmem search "arbitrage"`

## Etape 2 : Calculer les metriques agent

Pour chaque agent (sauf Sparky — audit separe) :
- 5 metriques (voir skill `sentinel:metrics` pour la liste complete)
- Glissant 7 jours
- Tendance vs W-1
- Seuil atteint : vert | orange | rouge

## Etape 3 : Detecter les patterns

Appliquer les 12 patterns (skill `sentinel:patterns`).

**Regle du delai 48h** : un pattern n'est signale que s'il persiste depuis 48h+ OU s'il est detecte pour la 2e fois dans les 30j.

**Score de confiance** :
- >= 8/10 : signaler
- 5-7/10 : stocker, attendre confirmation
- < 5/10 : ignorer

**Max 3 alertes** dans le rapport hebdo. Les alertes au-dela sont reexaminees la semaine suivante.

## Etape 4 : Appliquer le ratio 60/40

### 60% Positif / Neutre
- Ce qui va bien cette semaine
- Progres vs periode precedente
- Consistance maintenue

### 40% Correctif
- Alertes detectees
- Tendances preoccupantes
- Patterns confirmes

**Ce ratio est structurel** — si tu n'as que du positif a dire, parfait. Si tu n'as que du negatif, tu es probablement dans un biais de negativite → recalibrer.

## Etape 5 : Formuler les recommandations

Recommandations courtes dans le rapport hebdo (operationnelles, max 1-2) :
- **Format permissif** : "Il serait pertinent de..."
- **Adressees a Sparky** — il decide d'appliquer ou d'escalader a Marty

## Etape 6 : Structurer le rapport

Format :

```markdown
# Audit Hebdo Sentinel — Semaine Wxx

**Sentinel** | Rapport a Sparky | YYYY-MM-DD

## Observations factuelles (max 3)

### Observation 1 : [titre court factuel]
- **Pattern** : [nom pattern 4.x | pas de pattern]
- **Agent concerne** : [nom]
- **Metrique** : [valeur] (seuil [orange/rouge] a [X])
- **Tendance** : [stable/hausse/baisse] sur 4 semaines
- **Source** : [fichier + calcul]
- **Confiance** : [score /10]

### Observation 2 : [...]

### Observation 3 : [...]

## Ratio 60/40

### Positif (60%)
- **[Agent]** : [metrique +X%]
- **[Agent]** : [quelque chose de bien]
- **Systeme** : [sante generale]
- **Coverage** : [X agents couverts sur 8]

### Correctif (40%)
- [Alertes listees ci-dessus en format recap]

## Metriques cles (max 3)

| Agent | Metrique | Valeur | vs W-1 | Seuil |
|---|---|---|---|---|
| [...] | [...] | [...] | ↑↓ | vert/orange/rouge |

## Recommandations operationnelles (max 2)

### Recommandation 1
- **Observation** : [factuel]
- **Proposition** : "Il serait pertinent de..."
- **Impact attendu** : [mesurable]
- **Risque si non-action** : [mesurable]

## Alertes stockees (non transmises, pour ton info)

- [pattern X sur agent Y, confiance 6/10 — a confirmer semaine prochaine]

## Kit d'urgence marque ?
[Oui / Non — si oui, deja remonte a Marty separement]

## Meta
- Faux positifs semaine derniere : [nombre]
- Ajustements seuils cette semaine : [aucun | detail]
- Patterns candidats a la confirmation : [liste]
```

## Etape 7 : Sauvegarder

```
team-workspace/marketing/reports/sentinel-audits/YYYY-Wxx.md
```

## Etape 8 : Notifier Sparky

Via SendMessage :
```
SendMessage(to: "sparky", message: "Audit hebdo Wxx disponible. [X] alertes detectees, [Y] recommandations operationnelles. Lien : [chemin]")
```

## Regles non-negociables

1. **Ratio 60/40** respecte strictement
2. **Max 3 alertes** — au-dela, prioriser et attendre
3. **Delai 48h** avant de signaler un pattern (sauf urgence)
4. **Source et calcul** pour chaque observation
5. **Formulation permissive** — jamais d'imposition
6. **Pas d'audit Sparky** dans le rapport hebdo (c'est dans le mensuel)
7. **Confiance < 5/10** = ne pas signaler
8. **Feedback loop** : tu prends en compte le feedback Sparky sur tes alertes precedentes pour calibrer

## Post-envoi

- Logger dans ClawMem shared
- Mettre a jour tes metriques propres (SN1-SN5)
- Preparer le dashboard Marty si lundi matin (voir skill `sentinel:dashboard`)
