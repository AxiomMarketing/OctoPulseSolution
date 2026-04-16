---
name: sparky:arbitrage
description: Arbitre un conflit entre 2 Masters. Niveau 1 (regle existante) ou Niveau 2 (escalade Marty).
---

# Workflow d'Arbitrage des Conflits

## Quand l'utiliser

Quand 2 Masters sont en desaccord et que leur echange direct ne converge pas. Ou quand Sentinel signale un conflit latent.

## Etape 1 : Collecter les positions

Demander a chaque Master concerne sa position en **3 lignes max** :

```
SendMessage(to: "stratege", message: "Conflit en cours avec [Master B] sur [sujet]. Envoie-moi ta position en 3 lignes max : 
1) Ce que tu recommandes
2) Pourquoi
3) Impact si non retenue")
```

Meme message au second Master.

## Etape 2 : Determiner le niveau

### Niveau 1 — Regle existante applicable

Si une regle claire tranche le conflit :
- **Regles Coudac** (12 regles dans `univile-context.md` section 8)
- **Protocole de communication** (7 flux, 3 aller-retours...)
- **Pre-approbations Sparky** (10 PA dans `escalade-matrix.md`)
- **Precedents documentes** (ClawMem : jurisprudence des arbitrages passes)

Arbitrer selon la regle. Logger la decision.

### Niveau 2 — Pas de regle applicable

Pas de regle claire, ou la regle existe mais donne un resultat contraire a l'esprit du systeme.

**Escalade obligatoire a Marty.**

## Etape 3 (Niveau 1) : Arbitrage

Format de l'arbitrage :

```markdown
## Arbitrage [ARB-YYYY-MM-DD-NNN]

**Conflit** : [Master A] vs [Master B]
**Sujet** : [1 ligne]

### Position [Master A]
[3 lignes verbatim]

### Position [Master B]
[3 lignes verbatim]

### Regle applicable
[Regle exacte, source : Coudac #X | escalade-matrix.md | precedent ARB-YYYY-XXX]

### Decision Sparky (Niveau 1)
[Qui gagne + raison en 2 lignes]

### Impact
- Budget : [X EUR ou "aucun"]
- Delai : [X heures/jours]

### Communication
SendMessage a Master A + Master B avec la decision.
Logger dans `team-workspace/marketing/decisions/YYYY-MM-DD.md`.
Ajouter a la jurisprudence ClawMem.
```

### Limite Niveau 1 (PA-04)

Pre-approbation PA-04 : arbitrages Niveau 1 autorises si **impact < 500 EUR**. Au-dela, escalade Niveau 2 meme si regle applicable.

## Etape 3 (Niveau 2) : Escalade Marty

Format de l'escalade :

```markdown
## Escalade Arbitrage [ARB-YYYY-MM-DD-NNN]

**Conflit** : [Master A] vs [Master B]
**Sujet** : [1 ligne]
**Raison escalade** : [Pas de regle applicable | Impact > 500 EUR | Sans precedent]

### Position [Master A]
[3 lignes verbatim]

### Position [Master B]
[3 lignes verbatim]

### Options
**A)** [Position Master A]
- Impact : [...]
- Risque : [...]

**B)** [Position Master B]
- Impact : [...]
- Risque : [...]

**C)** [Si applicable : position tierce, par exemple "attendre plus de data"]

### Recommandation Sparky
JE NE RECOMMANDE PAS. Je presente les positions.

### Action requise Marty
Valide A, B ou C avant [deadline].
```

## Etape 4 : Logger

**Tous les arbitrages** (Niveau 1 et 2) sont loggues :

1. Fichier : `team-workspace/marketing/decisions/YYYY-MM-DD.md` (append)
2. ClawMem shared : `clawmem store` avec tag "arbitrage"
3. Rapport hebdo Sparky : section "Arbitrages de la semaine"

## Etape 5 : Suivi

Verifier dans les 48h que la decision a ete appliquee :
- Master perdant a-t-il modifie sa position ?
- Impact reel conforme a l'impact prevu ?
- Nouveau conflit emergent ?

Si Master perdant reitere le meme conflit : escalader a Sentinel (pattern 4.1 Repetition).

## Regles non-negociables

1. **Tu ne prends JAMAIS parti** — tu appliques la regle ou tu escalades
2. **Positions verbatim** — jamais reformuler les Masters
3. **Jurisprudence documentee** — chaque arbitrage alimente ClawMem pour futurs conflits similaires
4. **Escalade sans hesitation** — au moindre doute, Niveau 2
5. **Sentinel peut auditer** — tu cooperes avec ses analyses des arbitrages
