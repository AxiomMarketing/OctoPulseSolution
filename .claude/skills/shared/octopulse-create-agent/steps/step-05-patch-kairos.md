---
name: step-05-patch-kairos
description: Append jobs dans kairos/config.yml + restart service (conditionnel)
prev_step: steps/step-04-patch-communication.md
next_step: steps/step-06-chain-subs.md
---

# Step 5: Patch KAIROS config.yml

## MANDATORY EXECUTION RULES (READ FIRST):

- 🛑 NEVER modifier config.yml si `crons` est vide → skip
- 🛑 NEVER oublier de restart kairos.service si on a patché
- ✅ ALWAYS backup `.orig` avant
- ✅ ALWAYS valider YAML après patch avant restart
- 📋 YOU ARE A YAML SURGEON
- 💬 FOCUS sur section `jobs:` append uniquement

## EXECUTION PROTOCOLS:

- 🎯 Parse YAML complet, ajouter dans `jobs:` array, écrire retour
- 💾 Backup + patched_files tracking
- 📖 Restart kairos.service après validation
- 🚫 FORBIDDEN de casser les autres jobs existants (défense : parser → append → dump, pas de regex sur YAML)

## CONTEXT BOUNDARIES:

- `crons` = liste `{id, cron, prompt, priority}` (priority optional, défaut "normal")
- `notify_on` défaut : `["failure"]` pour normal, `["completion","failure"]` pour high, `["completion","failure","critical_alert"]` pour critical
- Fichier cible : `~/octopulse/kairos/config.yml`

## YOUR TASK:

Si `crons` fourni, parser config.yml, append les nouveaux jobs avec `agent: {name}` + `enabled: true`, restart service.

---

## EXECUTION SEQUENCE:

### 1. Check condition

```bash
CRONS=$(jq -c .crons /tmp/octopulse-create-agent-state.json)
if [ "$CRONS" = "null" ] || [ "$CRONS" = "[]" ]; then
  echo "SKIP: aucun cron, pass to step-06"
  python3 -c "
import json
s = json.load(open('/tmp/octopulse-create-agent-state.json'))
s['stepsCompleted'].append(5)
s['step_05_skipped'] = True
json.dump(s, open('/tmp/octopulse-create-agent-state.json','w'), indent=2)
"
  exit 0
fi
```

### 2. Backup

```bash
ssh octopulse@204.168.209.232 "cp ~/octopulse/kairos/config.yml ~/octopulse/kairos/config.yml.orig"
```

### 3. Pull config

```bash
scp octopulse@204.168.209.232:~/octopulse/kairos/config.yml /tmp/kairos-config.yml
```

### 4. Parse + append + dump

```python
import yaml, json, sys

state = json.load(open("/tmp/octopulse-create-agent-state.json"))
name = state["name"]
crons = state["crons"]

cfg = yaml.safe_load(open("/tmp/kairos-config.yml"))
cfg.setdefault("jobs", [])

PRIORITY_NOTIFY_DEFAULTS = {
    "normal":   ["failure"],
    "high":     ["completion", "failure"],
    "critical": ["completion", "failure", "critical_alert"],
}

for c in crons:
    priority = c.get("priority", "normal")
    notify_on = c.get("notify_on", PRIORITY_NOTIFY_DEFAULTS.get(priority, ["failure"]))
    new_job = {
        "id": c["id"],
        "agent": name,
        "cron": c["cron"],
        "prompt": c["prompt"],
        "priority": priority,
        "notify_on": notify_on,
        "enabled": True,
    }
    # Idempotence : skip si id existe déjà
    if any(j.get("id") == new_job["id"] for j in cfg["jobs"]):
        print(f"SKIP: job {new_job['id']} existe déjà")
        continue
    cfg["jobs"].append(new_job)

with open("/tmp/kairos-config-new.yml", "w") as f:
    yaml.safe_dump(cfg, f, allow_unicode=True, sort_keys=False, default_flow_style=False)

# Validate YAML reparses
yaml.safe_load(open("/tmp/kairos-config-new.yml"))
print(f"OK: {len(crons)} jobs traités")
```

### 5. SCP back

```bash
scp /tmp/kairos-config-new.yml octopulse@204.168.209.232:~/octopulse/kairos/config.yml
```

### 6. Restart kairos.service

```bash
ssh octopulse@204.168.209.232 '
systemctl --user restart kairos.service
sleep 3
systemctl --user is-active kairos.service
'
```

Doit retourner `active`. Sinon → rollback.

### 7. Validate via kairos-ctl

```bash
ssh octopulse@204.168.209.232 '~/octopulse/kairos/kairos-ctl list 2>&1 | grep -E "$(jq -r ".crons | .[].id" /tmp/octopulse-create-agent-state.json | tr "\n" "|" | sed "s/|$//")"'
```

Chaque cron id doit apparaître dans la liste.

### 8. Update state

```python
import json, datetime
state = json.load(open("/tmp/octopulse-create-agent-state.json"))
state["patched_files"].append({
    "path": "~/octopulse/kairos/config.yml",
    "backup": "~/octopulse/kairos/config.yml.orig"
})
state["stepsCompleted"].append(5)
state["step_05_completed_at"] = datetime.datetime.utcnow().isoformat() + "Z"
json.dump(state, open("/tmp/octopulse-create-agent-state.json", "w"), indent=2)
```

---

## SUCCESS METRICS:

✅ Step skipped si pas de crons
✅ config.yml parse OK après patch
✅ kairos.service active après restart
✅ `kairos-ctl list` montre les nouveaux jobs

## FAILURE MODES:

❌ YAML cassé après patch → restore .orig, rollback
❌ Service ne démarre pas après restart → restore .orig, rollback
❌ Jobs pas visibles dans kairos-ctl malgré service actif → warning, investiguer

## KAIROS PATCH PROTOCOLS:

- YAML parse → append → dump (pas de manipulation texte)
- Idempotence : skip job si id existe
- Restart service obligatoire (sinon jobs en RAM = pas synced)

---

## NEXT STEP:

Load `./step-06-chain-subs.md`

<critical>
Remember: YAML est fragile. Utiliser pyyaml, jamais regex sur le fichier.
</critical>
