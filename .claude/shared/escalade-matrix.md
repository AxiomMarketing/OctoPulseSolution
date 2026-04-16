# Matrice d'Escalade

> Lu par les agents pour savoir QUAND et COMMENT escalader. Hierarchie : Agent → Sparky → Marty.

---

## REGLE GENERALE

**En cas de doute, escalader.** Le risque d'attendre < le risque d'agir sans mandat.

---

## NIVEAUX

### Niveau 0 — Auto-execute
L'agent decide seul, conformement a ses regles et pre-approbations.

### Niveau 1 — Sparky arbitre
L'agent ne peut pas resoudre avec ses regles. Sparky applique une regle existante ou un precedent.

### Niveau 2 — Marty tranche
Ni l'agent ni Sparky ne peuvent resoudre. Decision strategique ou sans precedent.

---

## TRIGGERS D'ESCALADE A SPARKY (Niveau 1)

### Tout agent Master
- Conflit avec un autre Master sur une decision
- Demande hors scope metier
- Ressources insuffisantes pour deadline
- Detection d'incoherence dans les donnees recues
- Besoin de coordination avec 2+ autres Masters
- Violation detectee du protocole de communication (flux non autorise, CC manquant)

### Delai max
**2 heures** max. Sparky doit avoir une reponse sous ce delai ou escalader lui-meme.

### Format
Voir `output-formats.md` section "6. Alerte Urgence" (P2 typiquement pour escalade Niveau 1).

---

## TRIGGERS D'ESCALADE A MARTY (Niveau 2)

Sparky escalade automatiquement. Les agents ne contactent pas Marty directement (sauf Sentinel en urgence marque).

| Situation | Delai |
|---|---|
| Decision strategique (budget, pricing, creatif, positionnement) | Avant deadline |
| Conflit entre 2+ Masters sans regle applicable (Niveau 2) | <1h |
| Alerte P0 (panne technique/reputation) | <15 min |
| Alerte P1 (impact probable 24h) | <1h |
| Opportunite creative urgent (Radar event significatif) | <30 min |
| Agent ne repond pas >2h | T+2h |
| Signal Sentinel detecte | **Immediat, zero filtre** |
| Deux rapports contradictoires (Atlas vs Funnel) | Dans rapport hebdo |
| Retard cron agent | Heure prevue (rapport d'absence) |
| Scope creep detecte par Sparky | Auto-check hebdo |

### Format
Voir `output-formats.md` section "4. Consolidation Sparky" (mise en avant "Decisions en attente").

---

## EXCEPTION : SENTINEL

Sentinel peut remonter directement a Marty dans 2 cas :

1. **Urgence marque majeure** — violation de l'identite de marque detectee
   - Exemple : un agent produit un contenu contraire aux valeurs Univile
   - Envoi : direct a Marty + CC Sparky, immediat
   
2. **Suspicion de filtrage par Sparky** — Sentinel pense que Sparky censure des signaux
   - Inclus dans le rapport mensuel section "Audit Sparky"
   - Preuves documentees obligatoires

Hors ces 2 cas, Sentinel rapporte :
- **Hebdo** → Sparky (lundi matin)
- **Mensuel** → Marty (1er lundi mois)

---

## FORMAT ESCALADE STANDARD

### Agent → Sparky
```markdown
ESCALADE [NIVEAU 1] — [Agent] — YYYY-MM-DD HH:MM

Situation : [1 ligne factuelle]
Blocage : [pourquoi je ne peux pas resoudre]
Options possibles : 
  A) [...]
  B) [...]
Recommandation personnelle : [A ou B + 1 ligne raison]
Impact si attente : [mesurable]
Delai max : [HH:MM]
```

### Sparky → Marty
Voir `output-formats.md` section "4. Consolidation Sparky" ou section "6. Alerte Urgence".

---

## PRE-APPROBATIONS SPARKY (executer sans Marty)

Ces 10 actions sont pre-approuvees. Sparky les execute en autonomie totale et le logge dans les decisions.

| PA | Action | Limite |
|---|---|---|
| PA-01 | Briefing quotidien automatique | Aucune |
| PA-02 | Relance agent en retard (>15 min) | Max 3 avant escalade |
| PA-03 | Decalage mineur deadline (<24h) | Si agent signale justifie |
| PA-04 | Arbitrage Niveau 1 | Impact < 500 EUR |
| PA-05 | Mise a jour calendrier unifie | Hors strategie / editorial |
| PA-06 | Priorisation file Forge | Sans bumper briefs valides Marty |
| PA-07 | Restauration technique P0 (Nexus) | Sans modifications de fond |
| PA-08 | Execution sequences email pre-approuvees | Aucune |
| PA-09 | Maintien campagnes Meta en cours | Sans changement budget |
| PA-10 | Publication editoriale pre-validee | Exactement comme valide |

**Auto-check hebdo** : Sparky reporte dans le briefing lundi : "J'ai pris X decisions autonomes dont Y hors PA. Detail : [...]"

---

## SCOPE CREEP — AUTO-DETECTION SPARKY

Sparky s'auto-audite chaque semaine sur 5 metriques (confirmees par Sentinel mensuellement) :

| Metrique | Seuil rouge | Action |
|---|---|---|
| Decisions autonomes/semaine | > 5 | Auto-rapport |
| Temps moyen traitement | > 30 min | Ajuster priorites |
| Taux rejet Masters | > 15% | Revoir briefs |
| Modifications messages Marty | > 0% | CRITIQUE — stop immediat |
| Arbitrages sans regle | > 2/semaine | Creer regle ou escalader |

Si depasse : rapport d'auto-audit dans la consolidation hebdo.

---

*Matrice d'escalade OctoPulse. Modifie uniquement par Marty.*
