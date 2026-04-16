---
name: step-06-chain-subs
description: Invoker /octopulse:create-sub-agent pour chaque sub dans sub_agents
prev_step: steps/step-05-patch-kairos.md
next_step: steps/step-07-patch-claude-md.md
---

# Step 6: Chaînage des sub-agents

## MANDATORY EXECUTION RULES (READ FIRST):

- 🛑 NEVER skip ce step si `sub_agents` non vide
- 🛑 NEVER créer sub-agent manuellement ici (doit invoquer l'autre skill)
- ✅ ALWAYS utiliser le tool Skill pour invoquer `/octopulse:create-sub-agent`
- ✅ ALWAYS attendre la complétion d'un sub avant de passer au suivant (sequential)
- 📋 YOU ARE A DELEGATION ORCHESTRATOR
- 💬 FOCUS sur chaînage correct, rien d'autre

## EXECUTION PROTOCOLS:

- 🎯 Conditionnel : skip si `sub_agents` vide
- 💾 Tracker les subs créés dans state JSON
- 📖 Sequential (pas parallèle) : si un sub échoue, stop et rollback l'ensemble
- 🚫 FORBIDDEN de short-circuiter le skill create-sub-agent (pas de raccourci)

## CONTEXT BOUNDARIES:

- `sub_agents` = liste `{name, description, model}` dans state JSON
- Chaque sub doit être préfixé par le nom du parent master (convention)
- Le master est déjà créé (step-01), on peut le référencer comme parent

## YOUR TASK:

Si `sub_agents` fourni, invoquer `/octopulse:create-sub-agent` sequentially pour chacun avec `parent_master={name}`.

---

## EXECUTION SEQUENCE:

### 1. Check condition

```bash
SUBS=$(jq -c .sub_agents /tmp/octopulse-create-agent-state.json)
if [ "$SUBS" = "null" ] || [ "$SUBS" = "[]" ]; then
  echo "SKIP: aucun sub-agent"
  python3 -c "
import json
s = json.load(open('/tmp/octopulse-create-agent-state.json'))
s['stepsCompleted'].append(6)
s['step_06_skipped'] = True
json.dump(s, open('/tmp/octopulse-create-agent-state.json','w'), indent=2)
"
  exit 0
fi
```

### 2. Pour chaque sub

```python
import json
state = json.load(open("/tmp/octopulse-create-agent-state.json"))
name = state["name"]  # parent master
subs_processed = []

for sub in state["sub_agents"]:
    sub_name = sub["name"]
    # Convention : sub_name doit commencer par parent name
    if not sub_name.startswith(f"{name}-"):
        # Auto-prefix si user a juste donné la partie après
        sub_name = f"{name}-{sub_name}"
    
    # Invoquer le skill
    # Via Skill tool dans Claude : Skill(skill="octopulse:create-sub-agent", args=...)
    # Ici on documente la séquence, l'exécution réelle est via le Skill tool
    print(f"→ Invoquer /octopulse:create-sub-agent name={sub_name} parent={name} model={sub['model']}")
    subs_processed.append(sub_name)

state["subs_created"] = subs_processed
```

**Instruction pour l'agent Claude qui exécute ce step :**

Pour chaque sub dans state["sub_agents"], appeler le tool Skill :
```
Skill(
  skill="octopulse:create-sub-agent",
  args="name=<sub_name> parent_master=<master_name> model=<sub.model> description=<sub.description>"
)
```

Attendre la complétion. Si la skill retourne error, abort.

### 3. Validation

Après chaque sub :
```bash
ssh octopulse@204.168.209.232 "test -f ~/octopulse/.claude/agents/subs/${SUB_NAME}.md && echo OK"
```

Et vérifier que le parent .md a été patché (section Sub-agents contient le nouveau sub).

### 4. Update state JSON après tous les subs

```python
import json, datetime
state = json.load(open("/tmp/octopulse-create-agent-state.json"))
state["stepsCompleted"].append(6)
state["step_06_completed_at"] = datetime.datetime.utcnow().isoformat() + "Z"
# Les subs_created sont déjà trackés
json.dump(state, open("/tmp/octopulse-create-agent-state.json", "w"), indent=2)
```

Note importante : les fichiers créés par create-sub-agent sont tracked dans SON propre state. Pour le rollback master, seuls les patches parent.md sont à undo (et les vaults sub si on veut).

---

## SUCCESS METRICS:

✅ Step skipped si pas de sub_agents
✅ Chaque sub créé via /octopulse:create-sub-agent (pas manuellement)
✅ Chaque sub vérifié présent sur VPS
✅ Parent master .md patché avec section Sub-agents listant les nouveaux
✅ State JSON tracking les subs créés

## FAILURE MODES:

❌ Sub création échoue mid-way → rollback master + tous les subs déjà créés
❌ Court-circuit du skill create-sub-agent (créer manuellement) → drift garanti
❌ Sub name mal préfixé → Pattern Sentinel violation

## CHAIN PROTOCOLS:

- Sequential strict (pas parallèle)
- Auto-prefix si user oublie : `sub_name = f"{master}-{sub_name}"` si absent
- Stop on first failure, rollback en cascade

---

## NEXT STEP:

Load `./step-07-patch-claude-md.md`

<critical>
Remember: toujours passer par `/octopulse:create-sub-agent`. C'est lui qui gère vault + parent patch. Ne jamais créer un sub manuellement ici.
</critical>
