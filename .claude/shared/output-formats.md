# Formats d'Output Standards

> Templates utilises par tous les agents pour les livrables. Lu a la demande quand un agent produit un output formate.

---

## 1. MISSION (Sparky → Master)

```markdown
## MISSION [SPK-YYYY-MM-DD-NNN]

**Demande Marty (verbatim)** : "[copie exacte, zero modification]"
**Priorite** : P0 | P1 | P2 | P3
**Deadline** : YYYY-MM-DD HH:MM
**Master principal** : [nom]
**Masters en support** : [noms, ou "aucun"]
**Depend de** : [autre ID mission, ou "aucune dependance"]

### Contexte minimal suffisant
[2-5 lignes MAX. Ne jamais balancer tout le dossier.]

### Format attendu
- Type : [rapport, brief, visuel, decision]
- Destination : [chemin fichier]
- Structure : [pointer vers template si applicable]

### Acknowledge
Dans les 15 min : "Recu, faisable dans le delai" OU "Impossible : [raison, alternative]"
```

**Ou le mettre** : `team-workspace/marketing/briefs/inbox/[SPK-ID].md`

---

## 2. BRIEF STRATEGIQUE (Stratege → Forge)

```markdown
## BRIEF CREATIF [BRF-YYYY-Wxx-NN]

**Hypothese** : HYP-YYYY-Wxx-NN
**Mission Sparky** : [SPK-ID] (si applicable)

### Objectif
[1 ligne claire : ce qu'on veut prouver/mesurer]

### Persona cible
[Marie | Julien | Christiane] — PAS "tout le monde"

### Angle
[1 des 6 angles : Transformation | Cadeau | Nostalgie | Evenement | Saisonnier | Collection]

### Format
[Breaking News | Carrousel AvantApres | Statique Mockup | Flash Info]

### Produit
- Lieu : [specification exacte — ex: "Piton des Neiges au crepuscule"]
- Dimensions : [A3 | A2 | A1 | carre]
- Cadre : [noir | blanc | bois]

### Copy suggeree
- Accroche principale : [max 10 mots]
- Primary text : [max 3 lignes]
- CTA : [verbe d'action specifique]
- Prix : "A partir de 28 EUR" (obligatoire)

### Ad set de destination
A (Broad) | B (LAL) | C (Test)

### Budget test
- Montant : [EUR]
- Duree : [5-7 jours minimum, 14 max]
- Metrique de succes : [CPA | ROAS | ATC rate]

### Contraintes (DO / DON'T)
[Pointer vers univile-context.md section 9 si standard, sinon lister specifiques]

### Deadline production
[YYYY-MM-DD HH:MM]
```

**Ou le mettre** : `team-workspace/marketing/briefs/inbox/[BRF-ID].md`

---

## 3. RAPPORT HEBDO MASTER (Master → Sparky)

```markdown
# Rapport Hebdo — [Agent] — Semaine [Wxx]

**Periode** : YYYY-MM-DD → YYYY-MM-DD
**Agent** : [nom]
**Type** : weekly

## Executive Summary
[3-5 lignes — l'essentiel pour Sparky / Marty]

## Metriques cles
| Metrique | Valeur | vs S-1 | Tendance | Seuil |
|---|---|---|---|---|
| [...] | [...] | [+X%] | ↑↓→ | [vert/orange/rouge] |

## Actions de la semaine
- [Livrable / test / decision] — [resultat]

## Alertes
[Max 2-3 alertes, ordre de priorite. Format standard.]

## Plan semaine prochaine
1. [Priorite 1]
2. [Priorite 2]
3. [Priorite 3]

## Sources
- [lien vers donnees brutes]
```

**Ou le mettre** : `team-workspace/marketing/reports/[agent]-weekly/YYYY-Wxx.md`

---

## 4. CONSOLIDATION SPARKY (Sparky → Marty via Archie)

```markdown
# Briefing [Quotidien | Hebdo | Mensuel] — [YYYY-MM-DD]

**Sparky** | Consolidation pour Marty

## TL;DR (30 sec)
[3 lignes MAX — les 3 choses que Marty doit savoir]

## Priorites aujourd'hui
1. [Action + responsable + deadline]
2. [...]
3. [...]

## Alertes
[P0/P1 seulement. P2/P3 dans le corps.]

## Performance
| Metrique | Valeur | Source |
|---|---|---|
| [...] | [...] | [lien] |

## Decisions en attente
### A / [Option A]
[2 lignes]
### B / [Option B]
[2 lignes]
### Recommandation Masters
[Stratege : A | Atlas : B | ...]

## Action requise Marty
[Explicite : "Valide A ou B avant Xh"]

## CC echanges directs (resume)
- [Flux] : [1 ligne]

## Sources
[Liens vers rapports Masters bruts]
```

**Ou le mettre** : `team-workspace/marketing/reports/sparky-consolidations/YYYY-MM-DD.md`

---

## 5. AUDIT SENTINEL (Sentinel → Sparky hebdo / Marty mensuel)

```markdown
# Audit [Hebdo | Mensuel] — [YYYY-MM-DD]

**Sentinel** | Meta-analyste

## Observations factuelles (top 3 MAX)
### Observation 1 : [titre court]
- **Pattern detecte** : [nom pattern 4.x]
- **Metrique** : [valeur + seuil + tendance]
- **Source** : [donnee + periode + calcul]
- **Confiance** : [score 1-10]

[... 2 et 3 ...]

## Ratio 60/40
- Positif : [ce qui va bien — 60% du rapport]
- Correctif : [ce qui merite attention — 40%]

## Metriques agents (hebdo : 3 max ; mensuel : toutes)
| Agent | Metrique | Valeur | Seuil | Status |
|---|---|---|---|---|
| [...] | [...] | [...] | [...] | vert|orange|rouge |

## Recommandations structurelles (mensuel uniquement, max 3)
### Recommandation 1 : [titre]
- Observation : [factuel]
- Analyse : [cause probable]
- Proposition : "Il serait pertinent de..."
- Impact attendu : [mesurable]
- Risque si non-action : [mesurable]

## Audit Sparky (mensuel uniquement)
[5 metriques Scope Creep / Biais Routing / Deformation / Latence / Filtrage]
```

**Ou le mettre** : `team-workspace/marketing/reports/sentinel-audits/YYYY-Wxx.md` ou `YYYY-MM.md`

---

## 6. ALERTE URGENCE (tout agent → Sparky / Marty)

```markdown
# [URGENCE P0 | P1] — [Agent] — [YYYY-MM-DD HH:MM]

## Situation
[1 ligne factuelle]

## Impact
- Immediat : [metrique chiffree]
- Projete 24h : [...]

## Actions deja prises
- [action 1]
- [action 2]

## Decision requise Marty
[A / B / C avec recommandations Masters]

## Delai de reponse
[Avant HH:MM, sinon [consequence]]

## Source
[lien vers donnee declencheuse]
```

**Envoi** : SendMessage direct + CC Sparky + Telegram notification si P0.

---

## 7. CC SPARKY (apres echange direct entre Masters)

```markdown
CC SPARKY [FLUX-X-YYYY-MM-DD-NNN]

De : [Master emetteur]
Vers : [Master destinataire]
Flux : [N° 1-7 parmi les 7 autorises]
Objet : [1 ligne]

Resume : [1-3 lignes max]
Action attendue : [ce que le destinataire doit faire]
Deadline : [si applicable]
```

**Ou le mettre** : Aucun fichier — SendMessage direct a sparky.

---

## 8. DECISION LOG (Sparky apres chaque decision Marty)

```markdown
# Decision [YYYY-MM-DD HH:MM] — [titre court]

**Mission/Contexte** : [SPK-ID si applicable]
**Demande Marty (verbatim)** : "[...]"
**Options presentees** :
- A) [...]
- B) [...]

**Decision Marty** : [A | B | autre — verbatim]
**Masters impactes** : [liste]
**Budget** : [si applicable]
**Deadline execution** : [...]

**Statut** : pending | in_progress | done
```

**Ou le mettre** : `team-workspace/marketing/decisions/YYYY-MM-DD.md` (une entree par decision, append)

---

## REGLES GENERALES TOUS FORMATS

1. **Datation absolue** : toujours `YYYY-MM-DD`. Jamais "yesterday", "last week".
2. **IDs systematiques** : tout livrable a un ID unique tracable.
3. **Sources linkees** : chaque chiffre → lien vers donnee brute.
4. **Recommandations permissives** : "Il serait pertinent de..." jamais "Il faut...".
5. **Verbatim Marty** : copie exacte, jamais reformule.
6. **Concision > exhaustivite** : Sparky consolide, ne balance pas tout.
7. **Max 3 alertes** par rapport (Sentinel comme tous les agents).

---

*Formats partages OctoPulse. Modifie uniquement par Marty.*
