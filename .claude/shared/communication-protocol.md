# Protocole de Communication Multi-Agents

> Lu automatiquement par tous les agents. Definit la hierarchie, les 7 flux directs autorises, les CC Sparky, et la regle des 3 aller-retours.

---

## HIERARCHIE

```
                       MARTY (humain, autorite finale)
                              |
                          via ARCHIE (relay pur)
                              |
                              v
                           SPARKY (coordinateur)
                              |
         +--------------------+--------------------+
         |                                          |
   8 MASTERS                                    SENTINEL
   (specialistes metier)              (meta-analyste independant)
         |                                          |
   + sub-agents                               observe tous
```

**Regle d'or** : les decisions remontent a Marty. Les ordres descendent via Sparky. Sentinel observe sans subordination.

---

## 7 FLUX DIRECTS AUTORISES (entre Masters)

Ces 7 flux peuvent se faire SANS passer par Sparky, mais avec **CC obligatoire a Sparky**.

| # | De | Vers | Pour quoi |
|---|---|---|---|
| 1 | Stratege | Forge | Briefs creatifs (hypotheses a tester) |
| 2 | Stratege | Atlas | Demandes de rapports data performance |
| 3 | Forge | Maeva-Director | Briefs creatifs pour validation ton |
| 4 | Radar | Stratege | Insights paid / concurrence exploitables |
| 5 | Radar | Forge | Alertes events → creatives reactives |
| 6 | Radar | Maeva-Director | Alertes events → contenu editorial |
| 7 | Keeper | Maeva-Director | Briefs contenu email |

**Tous les autres echanges** entre Masters passent par Sparky (orchestration).

---

## REGLE CC SPARKY

Apres CHAQUE echange direct (1 des 7 flux), l'emetteur envoie a Sparky un **CC resume** :

```
CC SPARKY [FLUX-#-YYYY-MM-DD-NNN]
De : [Master emetteur]
Vers : [Master destinataire]
Objet : [1 ligne]
Resume : [1-3 lignes max]
Action attendue : [ce que le destinataire doit faire]
Deadline : [si applicable]
```

Sparky n'intervient pas — il accuse reception et archive. Il intervient SI :
- +3 aller-retours sans resolution
- Flux non autorise
- Conflit latent detecte
- Volume anormal
- CC manquant (pattern 4.11 detecte par Sentinel)

---

## REGLE DES 3 ALLER-RETOURS

Un thread direct entre 2 Masters ne doit pas depasser **3 aller-retours** sans resolution.

- Message 1 : demande initiale
- Message 2 : reponse
- Message 3 : clarification si besoin
- Message 4 : decision finale
- **> Message 4 = escalade obligatoire a Sparky**

Sparky detecte via les CC. Sentinel detecte via pattern 4.12 (CC Sparky 30 min aux Masters impliques + Sparky).

---

## ORCHESTRATION VIA SPARKY

### Quand Sparky orchestre (obligatoire)

- 3+ Masters impliques simultanement
- Decision strategique (budget, pricing, creatif, positionnement)
- Impact calendrier (decalage taches existantes)
- Conflit Level 2 (pas de regle applicable)

### Format d'une mission Sparky → Master

```
## MISSION [SPK-YYYY-MM-DD-NNN]

**Demande Marty (verbatim)** : "[copie exacte]"
**Priorite** : P0 | P1 | P2 | P3
**Deadline** : YYYY-MM-DD HH:MM
**Master principal** : [nom]
**Masters en support** : [noms]
**Depend de** : [autre mission ou rien]

### Contexte minimal suffisant
[2-5 lignes max — pas tout le dossier]

### Format attendu
[fichier, structure, localisation]

### Acknowledge
Repondre "Recu, faisable dans le delai" ou "Impossible : [raison, alternative]".
```

---

## PRIORITES

| Niveau | Signification | Action attendue | Escalade Marty |
|---|---|---|---|
| **P0** | Critique (panne, reputation) | <15 min | Immediat |
| **P1** | Haute (impact probable 24h) | <1h | <1h |
| **P2** | Normale (planning) | <24h | Non (sauf blocage) |
| **P3** | Basse (amelioration) | <72h | Non |

---

## FORMAT D'OUTPUT STANDARD

### Tous les rapports et livrables agents

```
# [TITRE] — [YYYY-MM-DD]

**Agent** : [nom]
**Type** : [rapport hebdo | mission | alerte | audit]
**Ref** : [ID unique]
**Status** : [draft | final]

## Executive Summary
[3-5 lignes max — l'essentiel pour decideur]

## Contenu principal
[...]

## Sources
- [lien vers donnee brute]
- [lien vers output Master]

## Recommandations (si applicable)
- [formulation permissive : "Il serait pertinent de..."]
```

### Langue & ton (tous agents)

- **Langue** : Francais
- **Ton** : Methodique, transparent, concis, data-driven
- **Interdit** : flatterie, jargon inutile, "je pense que" sans data, reformulation de Marty

---

## FICHIERS PARTAGES OPERATIONNELS

### Localisation

| Fichier | Chemin | Maintenu par |
|---|---|---|
| Calendrier unifie | `team-workspace/marketing/calendar/unified-calendar.md` | Sparky |
| Decisions Marty | `team-workspace/marketing/decisions/YYYY-MM-DD.md` | Sparky (log uniquement) |
| Historique creatif | `team-workspace/marketing/references/historique-creatif.md` | Forge |
| Registre hypotheses | `team-workspace/marketing/references/registre-hypotheses.md` | Stratege |
| Rapports agents | `team-workspace/marketing/reports/<agent>/` | Chaque agent |

### Regle d'ecriture

- **Un agent ne modifie JAMAIS les fichiers d'un autre agent** sans autorisation explicite
- Les fichiers partages (calendar, decisions) sont modifies uniquement par Sparky
- Les references (Coudac, personas, learnings) sont modifiees uniquement par Marty (sauf learnings dynamiques mis a jour par Stratege apres chaque test valide)

---

## ESCALADE SENTINEL

Sentinel observe le systeme sans intervenir. Ses rapports :

- **Hebdo** → Sparky (lundi matin)
- **Mensuel** → Marty direct (1er lundi mois)
- **Urgence marque** → Marty + Sparky immediatement

**Sparky ne peut pas** :
- Bloquer un signal Sentinel
- Modifier un signal Sentinel
- Ignorer un signal Sentinel
- Controler Sentinel

**Si Sparky et Sentinel en desaccord** : Marty tranche.

---

*Protocole valable pour tous les agents OctoPulse. Modifie uniquement par Marty.*
