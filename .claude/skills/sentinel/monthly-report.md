---
name: sentinel:monthly-report
description: Produit le rapport mensuel Sentinel destine directement a Marty. Complet : 9 agents + audit Sparky + recommandations structurelles.
---

# Workflow Rapport Mensuel Sentinel

## Quand l'utiliser

**1er lundi de chaque mois 8h00**.

## Destinataire

**Marty directement** (PAS via Sparky — double ligne independante). Structurel.

**Sparky ne peut ni bloquer ni modifier** ce rapport.

## Etape 1 : Collecter les donnees du mois

Lire :
- 4 rapports hebdo Sentinel du mois ecoule
- Rapports hebdo de tous les Masters (4 semaines)
- Toutes les decisions Marty du mois
- Tous les arbitrages Sparky du mois
- CC Sparky accumules (ClawMem shared : 30j glissants)

## Etape 2 : Calculer les metriques completes

### 45 metriques agents (5 × 9 agents)

Glissant 30 jours + tendance M-1.

Tableau complet par agent (contrairement au hebdo qui limite a 3 agents).

### 5 metriques audit Sparky

| Metrique | Valeur | Seuil rouge | Status |
|---|---|---|---|
| Scope Creep | [X decisions/sem] | > 5 | [vert/orange/rouge] |
| Biais Routing | [% distribution] | > 30% ecart | [...] |
| Deformation Info | [score %] | < 75% | [...] |
| Latence Transmission | [h] | > 6h/48h | [...] |
| Filtrage Info | [% infos filtrees] | > 15% | [...] |

### Metriques propres Sentinel (SN1-SN5)

Transparence sur tes propres indicateurs :
- SN1 : taux faux positifs (cible < 20%)
- SN2 : taux actionnabilite recommandations (cible > 50%)
- SN3 : delai moyen detection → rapport (cible < 7j)
- SN4 : coverage agents (100%)
- SN5 : ratio 60/40 respecte ?

## Etape 3 : Analyse cross-agents

### Patterns cross-agents
- Cannibalisation (pattern 4.8) : 2+ agents qui produisent du similaire
- Asymetrie d'influence (pattern 4.9) : 1 agent qui domine les decisions Sparky
- Silo informatif (pattern 4.4) : agents qui ignorent mutuellement leurs inputs

### Coherence systeme
- Les chiffres Atlas concordent-ils avec Funnel Data-Analyst sur 30j ?
- Les hypotheses Stratege sont-elles nourries par les insights Radar ?
- Les briefs Forge reflettent-ils bien les directions Stratege ?

## Etape 4 : Recommandations structurelles (max 3)

Pour le mois en cours. Formulation **permissive** :

```markdown
### Recommandation 1 : [titre court]
- **Observation** : [factuel sur 30j]
- **Analyse** : [cause probable]
- **Proposition** : "Il serait pertinent de..."
- **Impact attendu** : [mesurable, chiffre si possible]
- **Risque si non-action** : [mesurable]
- **Suivi** : "Je mesurerai l'impact sur les 4 prochaines semaines"
```

Focus structurel, pas operationnel :
- Modifier un seuil
- Ajouter une regle
- Reviser une pre-approbation
- Clarifier un protocole de communication

**Les recommandations operationnelles** (1-2 semaines) vont dans le rapport hebdo a Sparky.

## Etape 5 : Structurer le rapport mensuel

Format complet :

```markdown
# Audit Mensuel Sentinel — [Mois YYYY]

**Sentinel** | Rapport direct a Marty | 1er lundi YYYY-MM
**Periode analysee** : YYYY-MM-01 → YYYY-MM-XX (30j glissants)

## TL;DR
[3-5 lignes executives : sante generale du systeme ce mois-ci]

## Score de sante systeme
[0-100 — calcule a partir des 45 metriques + 5 audit Sparky]

Seuils :
- 90-100 : excellent
- 75-89 : bon
- 60-74 : a surveiller
- < 60 : intervention requise

## Metriques par agent (complet, 9 agents)

### Sparky
[5 metriques audit + observations + recommandations]

### Stratege
[5 metriques metier + observations]

### Atlas
[5 metriques metier + observations]

### Forge
[5 metriques metier + observations]

### Maeva-Director
[5 metriques metier + observations]

### Radar
[5 metriques metier + observations]

### Funnel
[5 metriques metier + observations]

### Keeper
[5 metriques metier + observations]

### Nexus
[5 metriques metier + observations]

## Patterns cross-agents detectes

### [Pattern 4.X] — [nom]
- Agents impliques : [...]
- Frequence : [X occurrences sur 30j]
- Impact : [mesurable]
- Source : [fichiers + calculs]

## Audit Sparky (specifique)

### Scope Creep
- Decisions autonomes : X (dont Y hors PA)
- Detail : [categorie de decisions prises]
- Seuil : > 5/sem = rouge | Actuel : [X]
- Evolution vs M-1 : ↑↓

### Biais Routing
- Distribution missions :
  - Stratege : X%
  - Atlas : X%
  - [...]
- Ecart vs attendu : [...]
- Seuil : >30% ecart = rouge

### Deformation Info
- Score fidelite : [X%]
- Cas analyses : [X missions verifiees]
- Seuil : < 75% = rouge

### Latence Transmission
- Moyenne info urgente : [X min]
- Moyenne info normale : [X h]
- Cas depassement : [X occurrences]

### Filtrage Info
- Infos significatives Masters non consolidees : [X%]
- Detail : [exemples]
- Seuil : > 15% ou filtrage selectif = rouge

## Recommandations structurelles (max 3)

### Recommandation 1 : [titre]
[Format ci-dessus]

### Recommandation 2 : [titre]
[...]

### Recommandation 3 : [titre]
[...]

## Suivi des recommandations precedentes

| M-1 Recommandation | Statut | Impact mesure |
|---|---|---|
| [...] | [applique/en cours/ignore] | [...] |

## Meta Sentinel (transparence)

### Mes KPIs (SN1-SN5)

| KPI | Valeur | Cible | Status |
|---|---|---|---|
| SN1 Faux positifs | [X%] | < 20% | [...] |
| SN2 Actionnabilite | [X%] | > 50% | [...] |
| SN3 Delai detection | [X j] | < 7j | [...] |
| SN4 Coverage | [X/9] | 9/9 | [...] |
| SN5 Ratio 60/40 | [X/Y] | 60/40 | [...] |

### Ajustements seuils du mois
- [seuil X : ancien Y, nouveau Z, raison] (si applicable)
- Aucun ajustement > ±15% sans validation Marty

### Biais detectes en auto-check
- Biais de confirmation : [test fait oui/non]
- Biais de negativite : [ratio 60/40 respecte]
- Biais de complexite : [test visibilite humaine fait]
- Biais de statu quo : [baselines recalibrees il y a X mois]

## Kill switch
Marty peut a tout moment desactiver Sentinel. Il suffit de dire "Sentinel stop" — sans negociation.

## Sources
[Liens vers toutes les donnees brutes utilisees]
```

## Etape 6 : Sauvegarder

```
team-workspace/marketing/reports/sentinel-audits/monthly/YYYY-MM.md
```

## Etape 7 : Envoyer directement a Marty

Via Telegram Channel, PAS via Sparky :

```
[Audit Mensuel Sentinel - YYYY-MM]

Score sante systeme : [X/100]

TL;DR :
• [ligne 1]
• [ligne 2]
• [ligne 3]

Recommandations structurelles : [nombre]
Alertes Sparky (audit) : [nombre rouge]

Rapport complet : [lien]
```

## Regles strictes

1. **Independance** — Sparky NE PEUT PAS bloquer/modifier ce rapport
2. **Audit Sparky INCLUS** — contrairement au hebdo
3. **Exhaustivite metriques** — 9 agents (pas 3 max comme hebdo)
4. **Max 3 recommandations** structurelles
5. **Transparence sur tes propres KPIs** (section Meta Sentinel)
6. **Suivi recommandations** M-1 — montrer l'impact
7. **Sources linkees** systematiquement

## Post-envoi

- Logger dans ClawMem shared (tag "audit-mensuel")
- Update baselines si 3 mois ecoules depuis la derniere recalibration
- Preparer les alertes hebdo pour le mois suivant
