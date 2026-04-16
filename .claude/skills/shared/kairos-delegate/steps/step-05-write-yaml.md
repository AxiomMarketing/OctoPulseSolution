---
name: step-05-write-yaml
description: Génère le YAML canonique + dépose dans triggers/inbox/ VPS
prev_step: steps/step-04-check-rules.md
next_step: steps/step-06-cc-sparky.md
---

# Step 5: Écrire le trigger YAML

## MANDATORY EXECUTION RULES (READ FIRST):

- 🛑 NEVER écrire du YAML non-validé (risque de parser crash KAIROS)
- 🛑 NEVER écraser un fichier inbox existant (idempotence trigger_id)
- ✅ ALWAYS utiliser `yaml.safe_dump` (jamais string concat)
- ✅ ALWAYS vérifier que le fichier est bien écrit (ls post-scp)
- 📋 YOU ARE A YAML WRITER
- 💬 FOCUS sur génération + dépôt, rien d'autre
- 🚫 FORBIDDEN de toucher à autre chose que inbox/

## EXECUTION PROTOCOLS:

- 🎯 Générer YAML via pyyaml, écrire local, scp sur VPS
- 💾 `yaml_path` dans state (pour rollback si besoin)
- 📖 Idempotence : si fichier existe déjà (même trigger_id), skip
- 🚫 FORBIDDEN de charger step-06 sans yaml_path validé

## CONTEXT BOUNDARIES:

- State JSON contient tous les champs finalisés (target, prompt, priority, notify_on, etc.)
- Inbox path : `~/octopulse/kairos/triggers/inbox/{trigger_id}.yml`
- KAIROS daemon tick toutes les 60s — consommera automatiquement

## YOUR TASK:

Générer le YAML canonique à partir du state, le déposer dans inbox sur VPS, vérifier écriture.

---

## EXECUTION SEQUENCE:

### 1. Load state + construire payload

```python
import yaml, json, datetime

state = json.load(open(state_file))

payload = {
    "id": state["trigger_id"],
    "agent": state["target_agent"],
    "prompt": state["prompt"],
    "priority": state["priority"],
    "submitter": state["caller_agent"],
    "created_at": datetime.datetime.utcnow().isoformat() + "Z",
    "notify_on": state["notify_on"],
    "cc_sparky": state["cc_sparky_required"],
}

# Optionnel : scheduled_for
if state.get("scheduled_for"):
    payload["scheduled_for"] = state["scheduled_for"]

# Valider qu'on peut bien dump
yaml_content = yaml.safe_dump(payload, allow_unicode=True, sort_keys=False, default_flow_style=False)

# Re-parse pour sanity check
yaml.safe_load(yaml_content)

local_path = f"/tmp/{state['trigger_id']}.yml"
open(local_path, "w").write(yaml_content)
print(f"OK: YAML écrit localement à {local_path}")
print(yaml_content)
```

### 2. Idempotence : check existant VPS

```bash
TRIGGER_ID=$(jq -r .trigger_id "$STATE_FILE")
EXISTS=$(ssh octopulse@204.168.209.232 "test -f ~/octopulse/kairos/triggers/inbox/${TRIGGER_ID}.yml && echo yes")
if [ "$EXISTS" = "yes" ]; then
  echo "SKIP: trigger ${TRIGGER_ID} déjà dans inbox (probablement re-invocation)"
  # Marquer state
  jq '.step_05_skipped = true | .yaml_path = "~/octopulse/kairos/triggers/inbox/'$TRIGGER_ID'.yml"' "$STATE_FILE" > "${STATE_FILE}.tmp" && mv "${STATE_FILE}.tmp" "$STATE_FILE"
  # Pass to step-06
  exit 0
fi
```

### 3. SCP le fichier

```bash
scp /tmp/${TRIGGER_ID}.yml octopulse@204.168.209.232:~/octopulse/kairos/triggers/inbox/${TRIGGER_ID}.yml
```

### 4. Verify

```bash
ssh octopulse@204.168.209.232 "
test -f ~/octopulse/kairos/triggers/inbox/${TRIGGER_ID}.yml && echo OK
# Verify YAML parseable côté VPS (KAIROS utilisera pyyaml)
python3 -c \"import yaml; yaml.safe_load(open('$HOME/octopulse/kairos/triggers/inbox/${TRIGGER_ID}.yml'))\" && echo 'YAML valid'
"
```

Si fail → load step-99-rollback.md.

### 5. Log dans delegate.jsonl (optionnel)

```python
import json, datetime
log_entry = {
    "ts": datetime.datetime.utcnow().isoformat() + "Z",
    "caller": state["caller_agent"],
    "target": state["target_agent"],
    "trigger_id": state["trigger_id"],
    "priority": state["priority"],
    "cc_sparky": state["cc_sparky_required"],
}
# Log local (ou scp vers VPS ~/logs/kairos/delegate.jsonl)
# MVP : log local uniquement
log_path = "/tmp/kairos-delegate.jsonl"
open(log_path, "a").write(json.dumps(log_entry) + "\n")
```

### 6. Update state

```python
state["yaml_path"] = f"~/octopulse/kairos/triggers/inbox/{state['trigger_id']}.yml"
state["stepsCompleted"].append(5)
state["step_05_completed_at"] = datetime.datetime.utcnow().isoformat() + "Z"
json.dump(state, open(state_file, "w"), indent=2)
```

### 7. Cleanup local

```bash
rm -f /tmp/${TRIGGER_ID}.yml
```

---

## SUCCESS METRICS:

✅ YAML généré via pyyaml (jamais concat string)
✅ Re-parse validé (pas de corruption)
✅ Idempotence : skip si trigger_id déjà dans inbox
✅ SCP réussi → fichier présent sur VPS
✅ YAML validé côté VPS (Python parseable)
✅ yaml_path dans state

## FAILURE MODES:

❌ YAML manuellement concat → risque characters échappés incorrectement
❌ Écraser fichier existant (pas d'idempotence) → perd un trigger
❌ SCP fail silencieusement → trigger jamais exécuté
❌ **CRITICAL**: YAML malformé → KAIROS le déplace vers invalid/ silencieusement

## YAML WRITE PROTOCOLS:

- Génération 100% via library (pyyaml safe_dump)
- Round-trip parse (dump puis load pour valider)
- Idempotence explicite (check file exists avant écriture)

---

## NEXT STEP:

Load `./step-06-cc-sparky.md`

<critical>
Remember: le YAML est le contrat avec KAIROS. Un seul char mal échappé = trigger ignoré ou agent erratique.
</critical>
