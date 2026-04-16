---
name: kairos:delegate
description: Déléguer une action asynchrone à KAIROS en déposant un trigger YAML. Utiliser quand l'action doit se faire "plus tard", "en parallèle de mon travail", "récurrente", ou "quand un autre agent aura fini". Ne PAS utiliser pour une action immédiate bloquante (reste dans la session pour ça).
allowed-tools: [Write, Read, Bash]
---

# Déléguer une action à KAIROS

KAIROS est le tick loop autonome d'OctoPulse. En déposant un fichier YAML dans `~/octopulse/kairos/triggers/inbox/`, tu programmes une action qui sera exécutée par la prochaine session Claude disponible (≤60s), sans monopoliser ta session actuelle.

---

## 🎯 Quand utiliser KAIROS (decision tree)

```
Action à déclencher ?
├─ Maintenant + je la finis moi-même
│   └── ❌ NE PAS utiliser KAIROS. Reste dans la session.
│
├─ Maintenant mais un AUTRE agent doit le faire
│   ├─ Blocage pour mon travail actuel (j'ai besoin du résultat)
│   │   └── Utilise le tool Agent directement (synchrone)
│   └─ Je peux continuer sans attendre
│       └── ✅ KAIROS avec priority=high
│
├─ Plus tard (heures / jours)
│   └── ✅ KAIROS avec priority=normal
│
├─ Récurrent (chaque jour / chaque lundi / chaque 1er)
│   └── ❌ NE PAS utiliser KAIROS trigger. Demande à Sparky d'ajouter un cron
│       dans config.yml (modification persistante, review humaine)
│
└─ Réactif sur événement futur connu (Fête des Mères, BF)
    └── ❌ NE PAS utiliser KAIROS trigger. Ajoute l'événement dans
        calendrier-evenements.md — KAIROS générera les alertes J-45/J-30/J-14
```

**Règle d'or** : KAIROS triggers = **actions ponctuelles différées**. Récurrence → cron. Événement calendaire → calendrier. Action immédiate bloquante → session courante.

---

## 📋 Format YAML canonique

```yaml
id: <agent>-<YYYYMMDD-HHMMSS>-<slug-court>    # exemple : radar-20260415-103500-alerte-juniqe
agent: <nom-agent-cible>                       # ∈ {sparky, atlas, forge, stratege, maeva, radar, sentinel, keeper, nexus, funnel, ou un sub-agent}
prompt: |                                       # Instruction complète, auto-contenue
  <instruction claire avec tout le contexte nécessaire>
  <l'agent appelé ne verra QUE ce prompt, pas ta session actuelle>
  <inclure : quoi faire, pourquoi, deadline, output attendu>
priority: normal | high | critical              # voir matrice ci-dessous
submitter: <ton-nom-agent>                       # OBLIGATOIRE — pour traçabilité Sentinel
created_at: <ISO 8601 UTC>                       # ex: 2026-04-15T10:35:00Z
notify_on: [failure, completion, critical_alert] # voir matrice ci-dessous
cc_sparky: true | false                          # voir règle CC ci-dessous
scheduled_for: <ISO 8601 UTC>                    # OPTIONNEL — si omis, exécuté au prochain tick
```

### Champs obligatoires
`id`, `agent`, `prompt`, `submitter`

### Tous les autres sont optionnels mais recommandés

---

## 🚦 Matrice priority

| Priority | Quand l'utiliser | Latence attendue | Notif Telegram |
|---|---|---|---|
| **critical** | Urgence business (drop CPM 50%+, bug prod, rupture charte marque détectée) | <60s | Start + completion + failure + alertes stdout |
| **high** | Action importante mais non-urgente (brief créatif, plan hebdo, audit) | <60s | Start + completion + failure |
| **normal** | Travail routinier (rapports quotidiens, veille, synthèses) | <60s | Failures uniquement |

⚠️ **N'abuse PAS de critical**. Sentinel détecte les agents qui over-escalade (Pattern 4.9 "Asymétrie d'influence"). Règle : <5% de tes triggers en critical.

---

## 🔔 Matrice notify_on

| Cas | notify_on recommandé |
|---|---|
| Job routinier (quotidien/hebdo) | `[failure]` |
| Job important | `[completion, failure]` |
| Job critique / urgent | `[completion, failure, critical_alert]` |
| Job silencieux (batch data) | `[failure]` |

**Règle de sécurité** : `failure` est TOUJOURS notifié par KAIROS même si absent de la liste (invariant post-fix F3).

---

## 🤝 Règle CC Sparky (obligatoire pour cross-domaine)

Si ton trigger cible un agent **hors de ton domaine direct** (ex: Radar déclenche Stratege, Forge déclenche Keeper), tu DOIS :

1. Mettre `cc_sparky: true` dans le YAML
2. Envoyer un message direct à Sparky via le tool SendMessage (ou log dans son vault) résumant l'action

Sinon → Sentinel détecte le **Pattern 4.11 "CC Sparky manquant"** et te signalera.

**Exception : flux directs autorisés** (défini dans `communication-protocol.md`). Ces 7 paires n'ont pas besoin de CC Sparky :
- Stratege → Forge, Stratege → Atlas
- Forge → Maeva-Director
- Radar → Stratege, Radar → Forge, Radar → Maeva-Director
- Keeper → Maeva-Director

---

## 🚧 Anti-abus

- **Max 10 triggers/jour par agent** (hors sub-agents). Au-delà → Sentinel Pattern 4.9.
- **Jamais un trigger qui re-déclenche toi-même** (boucle). Sentinel Pattern 4.1 "Répétition".
- **Jamais un trigger avec prompt vide** → KAIROS reject direct (validation F6).
- **Pas d'info sensible en clair** dans le prompt (tokens, clés). Le prompt sera loggé + potentiellement envoyé à Marty via Telegram.

---

## 🛠️ Comment déposer concrètement

### Option A — via le tool Write
```
Write(
  file_path="/home/octopulse/octopulse/kairos/triggers/inbox/radar-20260415-103500-alerte-juniqe.yml",
  content="""id: radar-20260415-103500-alerte-juniqe
agent: stratege
prompt: |
  URGENCE : Juniqe vient de lancer une campagne Fête des Mères avec un angle
  "Transformation espace" à -30% jusqu'au 24 avril. Source : screenshot Meta Ad Library.

  Analyse requise :
  1. Impact probable sur nos CPM (est-on en concurrence directe sur l'audience LAL) ?
  2. Recommandation : kill notre campagne A/B en cours OU scale up OU créer angle différenciant ?
  3. Deadline : bilan attendu demain 9h, avant le plan hebdo Stratege
priority: high
submitter: radar-scout-concurrence
created_at: 2026-04-15T10:35:00Z
notify_on: [completion, failure]
cc_sparky: true
"""
)
```

### Option B — via Bash (plus concis si besoin)
```bash
cat > /home/octopulse/octopulse/kairos/triggers/inbox/<id>.yml <<'YAML'
id: ...
agent: ...
prompt: |
  ...
priority: ...
submitter: ...
YAML
```

### Option C — via CLI (pour Marty / admin)
```bash
kairos-ctl trigger <agent> "<prompt>" --priority normal
```
(Ne fournit pas tous les champs — utile pour tests, pas pour production agents.)

---

## 🔁 Cycle de vie d'un trigger

```
1. Tu écris le YAML dans triggers/inbox/
2. KAIROS ramasse au prochain tick (≤60s)
3. Fichier déplacé vers triggers/.inflight/ (checkout atomique)
4. Session claude -p --agent <target> s'ouvre
5. L'agent exécute ton prompt
6. Si succès : fichier → triggers/processed/YYYY-MM-DD/ + rapport écrit
   Si échec  : failure notifié sur Telegram, fichier reste en processed avec meta
7. Tu peux vérifier l'outcome dans :
   - ~/logs/kairos/daemon.jsonl (event job_end)
   - team-workspace/marketing/reports/kairos/YYYY-MM-DD/<id>.md (rapport complet)
```

---

## ✅ 3 exemples canoniques

### Exemple 1 — Radar détecte un event, délègue à Stratege
```yaml
id: radar-20260415-140000-event-breaking-news
agent: stratege
prompt: |
  Breaking news détectée : annonce gouvernementale d'un chèque vacances 500€
  pour familles avec enfant <18 ans. Angle potentiel "Cadeau" × "Event".

  Source : Le Monde 15/04 14:00
  Lead-time estimé : 72h avant saturation concurrence

  Action : proposer 1 hypothèse testable avant 18h aujourd'hui (pour que Forge
  puisse produire les créatifs dès demain matin).
priority: high
submitter: radar-scout-actu
created_at: 2026-04-15T14:00:00Z
notify_on: [completion, failure]
cc_sparky: true
```

### Exemple 2 — Forge délègue relecture QC à sub-agent
```yaml
id: forge-20260415-163000-qc-carrousel-paques
agent: forge-qc
prompt: |
  Carrousel "Joyeuses Pâques 2026" prêt à la validation finale.

  Assets :
  - /team-workspace/marketing/assets/paques-2026/carrousel-v3/

  Checks : charte couleur (palette Univile validée), cohérence ton Maeva,
  règle COUDAC 9 (produit visible 1ère seconde).

  Si validé : marque le carrousel ready_to_publish dans le manifest.
priority: normal
submitter: forge-art-director
created_at: 2026-04-15T16:30:00Z
notify_on: [failure]
cc_sparky: false   # flux direct forge→forge-qc interne, pas de CC
```

### Exemple 3 — Sentinel détecte pattern critique, escalade
```yaml
id: sentinel-20260415-090000-drift-marque-urgence
agent: sparky
prompt: |
  URGENCE MARQUE : Sentinel Pattern 4.3 "Drift de marque" détecté — 4 écarts
  charte en 7 jours (vs seuil 3/30j). Outputs Forge s'éloignent de la voix Maeva.

  Preuves : /team-workspace/marketing/reports/sentinel/2026-04-15/drift-analysis.md

  Action demandée à Sparky :
  1. Convoquer Forge-Strategist + Maeva-Director dans les 24h
  2. Revue de la dernière salve créative
  3. Décision : pause production OU correction charte OU recadrage
priority: critical
submitter: sentinel
created_at: 2026-04-15T09:00:00Z
notify_on: [completion, failure, critical_alert]
cc_sparky: true
```

---

## 🔍 Debug & vérification

- Voir ton trigger déposé : `ls ~/octopulse/kairos/triggers/inbox/`
- Suivre son exécution : `kairos-ctl logs --job <id>`
- Lire le rapport post-run : `~/octopulse/team-workspace/marketing/reports/kairos/YYYY-MM-DD/*<id>*.md`
- Si bloqué en inflight : vérifier `triggers/.inflight/` — peut indiquer un crash daemon
- Si rejeté : vérifier `triggers/invalid/` — reason en commentaire dans le fichier

---

## Résumé 1-phrase

> **KAIROS triggers = actions ponctuelles différées cross-agent. Pour tout le reste (récurrent, immédiat, calendaire), utilise le bon outil.**
