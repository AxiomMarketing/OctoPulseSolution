---
name: step-07-confirm
description: Confirmation finale au caller + archive state
prev_step: steps/step-06-cc-sparky.md
---

# Step 7: Confirmation

## MANDATORY EXECUTION RULES (READ FIRST):

- 🛑 NEVER claim success si step-05 n'a pas complété
- ✅ ALWAYS fournir trigger_id + ETA au caller
- ✅ ALWAYS indiquer où voir le résultat post-exécution
- 📋 YOU ARE A REPORTER
- 💬 FOCUS sur output clair au caller

## EXECUTION PROTOCOLS:

- 🎯 Résumé structuré (pas de blabla)
- 💾 Archiver state JSON (audit trail)
- 📖 Pas d'action sur VPS dans ce step

## CONTEXT BOUNDARIES:

- Le trigger est déposé (step-05), CC Sparky envoyé si requis (step-06)
- Le caller attend un message actionnable

## YOUR TASK:

Afficher confirmation finale au caller avec trigger_id, ETA, paths de log/rapport futurs.

---

## EXECUTION SEQUENCE:

### 1. Load state

```python
state = json.load(open(state_file))
```

### 2. Afficher confirmation

```markdown
# ✓ Trigger KAIROS déposé

**ID** : `{trigger_id}`
**Destinataire** : {target_agent}
**Priority** : {priority}
**Notify on** : {notify_on}
**CC Sparky** : {"oui" si cc_sparky_required else "non (flux direct autorisé)"}

## Cycle de vie

1. **Actuellement** : `~/octopulse/kairos/triggers/inbox/{trigger_id}.yml`
2. **Dans ≤60s** : KAIROS daemon tick → checkout vers `.inflight/`
3. **Exécution** : claude -p invoqué avec agent={target_agent}
4. **Si succès** : fichier → `triggers/processed/{YYYY-MM-DD}/` + rapport Markdown
5. **Notifications** : selon notify_on

## Où voir le résultat

- **Log daemon** : `~/logs/kairos/daemon.jsonl` → `event: job_end`, filter par trigger_id
- **Log run** : `~/logs/kairos/runs/{YYYY-MM-DD}.jsonl` → stdout_preview + exit
- **Rapport** : `~/octopulse/team-workspace/marketing/reports/kairos/{YYYY-MM-DD}/*-{trigger_id}.md`
- **Telegram** : si priority={priority}, notifications selon notify_on

## CLI debug

```bash
kairos-ctl logs --job {trigger_id}
ls ~/octopulse/kairos/triggers/processed/$(date +%F)/ | grep {trigger_id}
```

---
_Trigger accepted. Ton travail courant n'est pas bloqué — tu peux continuer._
```

### 3. Archive state JSON

```bash
mkdir -p /tmp/archive/kairos-delegate
mv "$STATE_FILE" "/tmp/archive/kairos-delegate/$(basename $STATE_FILE)"
```

### 4. Update state (une dernière fois avant archive)

```python
state["stepsCompleted"].append(7)
state["step_07_completed_at"] = datetime.datetime.utcnow().isoformat() + "Z"
state["workflow_status"] = "success"
json.dump(state, open(state_file, "w"), indent=2)
```

---

## SUCCESS METRICS:

✅ Message confirmation affiché au caller
✅ Trigger_id + ETA + paths fournis
✅ State JSON archivé (pas détruit — audit)
✅ `workflow_status: success` marqué

## FAILURE MODES:

❌ Message trop long = caller n'agit pas dessus
❌ Oublier le trigger_id dans le message (impossible de tracer)
❌ Oublier les paths de debug (caller perdu si quelque chose va mal)
❌ Détruire le state JSON (pas d'audit post-mortem)

## CONFIRM PROTOCOLS:

- Factuel, pas promotionnel
- Paths absolus pour clarté
- Archive state pour forensics

---

## NEXT STEP:

Workflow complet. Retour au caller agent avec confirmation.

<critical>
Remember: le trigger est déjà déposé. Ce step est purement informationnel pour que le caller sache quoi faire ensuite.
</critical>
