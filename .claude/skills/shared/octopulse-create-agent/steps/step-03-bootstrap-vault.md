---
name: step-03-bootstrap-vault
description: Crée agent-memory vault + clawmem collection add + marker
prev_step: steps/step-02-create-skills.md
next_step: steps/step-04-patch-communication.md
---

# Step 3: Bootstrap ClawMem vault

## MANDATORY EXECUTION RULES (READ FIRST):

- 🛑 NEVER skip ce step (agent sans vault = invisible au système de mémoire, pattern Sentinel 4.11)
- 🛑 NEVER créer la collection si elle existe déjà (idempotent)
- ✅ ALWAYS utiliser `~/bin/bw-ensure-unlock.sh` avant `clawmem` (session peut être stale)
- ✅ ALWAYS créer le marker `.clawmem-initialized` pour idempotence
- 📋 YOU ARE A VAULT PROVISIONER
- 💬 FOCUS sur ClawMem collection setup, rien d'autre

## EXECUTION PROTOCOLS:

- 🎯 Créer le dossier AVANT d'ajouter la collection (clawmem scans le path)
- 💾 Append `agent-{name}` dans state JSON `clawmem_collections`
- 📖 Vérifier via `clawmem doctor` que la collection apparaît
- 🚫 FORBIDDEN de procéder si clawmem binary introuvable

## CONTEXT BOUNDARIES:

- `clawmem` binary dans `~/.bun/bin/` (PATH à exporter avant)
- `bw-ensure-unlock.sh` dispo sur VPS dans `~/bin/`
- Collection naming : `agent-{name}` (masters) vs `sub-{name}` (subs)

## YOUR TASK:

Créer le dossier agent-memory, bootstrap la collection ClawMem, marquer initialisé, valider via `clawmem doctor`.

---

## EXECUTION SEQUENCE:

### 1. Load state

```bash
NAME=$(jq -r .name /tmp/octopulse-create-agent-state.json)
```

### 2. Créer dossier agent-memory

```bash
ssh octopulse@204.168.209.232 "mkdir -p ~/.claude/agent-memory/${NAME}"
```

### 3. Bootstrap collection ClawMem

```bash
ssh octopulse@204.168.209.232 '
export PATH=$HOME/.bun/bin:$PATH
# Ensure bw unlocked (not strictly needed for collection add mais pattern safe)
source ~/.bw-env 2>/dev/null || true
# Check si collection déjà existe — idempotent
if clawmem doctor 2>&1 | grep -q "agent-'"${NAME}"'"; then
  echo "SKIP: collection agent-'${NAME}' existe déjà"
else
  clawmem collection add --path ~/.claude/agent-memory/'"${NAME}"' --name agent-'${NAME}'
  echo "CREATED: collection agent-'${NAME}'"
fi
'
```

### 4. Marker idempotent

```bash
ssh octopulse@204.168.209.232 "touch ~/.claude/agent-memory/${NAME}/.clawmem-initialized"
```

### 5. Validation via clawmem doctor

```bash
ssh octopulse@204.168.209.232 '
export PATH=$HOME/.bun/bin:$PATH
clawmem doctor 2>&1 | grep -q "agent-'"${NAME}"'" && echo "PASS: collection visible" || { echo "FAIL: collection non détectée"; exit 1; }
'
```

Si FAIL → load `step-99-rollback.md`.

### 6. Update state JSON

```python
import json, datetime
state = json.load(open("/tmp/octopulse-create-agent-state.json"))
state["clawmem_collections"].append(f"agent-{state['name']}")
state["created_files"].append(f"~/.claude/agent-memory/{state['name']}/")
state["stepsCompleted"].append(3)
state["step_03_completed_at"] = datetime.datetime.utcnow().isoformat() + "Z"
json.dump(state, open("/tmp/octopulse-create-agent-state.json", "w"), indent=2)
```

---

## SUCCESS METRICS:

✅ Dossier `~/.claude/agent-memory/{name}/` créé
✅ Collection `agent-{name}` registered dans ClawMem
✅ Marker `.clawmem-initialized` écrit
✅ `clawmem doctor` voit la collection
✅ State JSON updated

## FAILURE MODES:

❌ clawmem binary introuvable → abort avec instruction "installer clawmem"
❌ Collection add échoue (conflit, DB locked) → retry 1x puis rollback
❌ `clawmem doctor` ne voit pas la collection malgré add réussi → anomalie, logger + alerter

## VAULT PROTOCOLS:

- Idempotent : re-run = skip gracefully si collection existe
- Dossier PRÉCÈDE l'add (clawmem a besoin du path)
- Marker utile pour les scripts bootstrap VPS qui listent les vaults

---

## NEXT STEP:

Load `./step-04-patch-communication.md`

<critical>
Remember: vault = mémoire isolée de l'agent. Sans ça, il est invisible à ClawMem et aux hooks cross-session.
</critical>
