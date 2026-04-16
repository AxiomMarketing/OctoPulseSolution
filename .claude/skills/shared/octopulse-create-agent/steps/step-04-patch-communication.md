---
name: step-04-patch-communication
description: Append flux directs dans communication-protocol.md (conditionnel)
prev_step: steps/step-03-bootstrap-vault.md
next_step: steps/step-05-patch-kairos.md
---

# Step 4: Patch communication-protocol

## MANDATORY EXECUTION RULES (READ FIRST):

- 🛑 NEVER modifier communication-protocol.md si `direct_flows` est vide → skip direct to step-05
- 🛑 NEVER écraser le fichier entier (append uniquement)
- ✅ ALWAYS créer un backup `.orig` avant modification
- ✅ ALWAYS respecter la numérotation existante des flux (trouve le dernier N puis N+1, N+2...)
- 📋 YOU ARE A SURGICAL EDITOR, not a rewriter
- 💬 FOCUS sur append dans la section "Flux directs autorisés" uniquement

## EXECUTION PROTOCOLS:

- 🎯 Conditionnel : skip si `direct_flows` vide
- 💾 Backup `.orig` → state JSON `patched_files` avec info backup
- 📖 Pattern : tableau markdown existe, trouver la dernière ligne de data, append après
- 🚫 FORBIDDEN de toucher les sections autres que la table flux

## CONTEXT BOUNDARIES:

- `direct_flows` = liste `{direction: 'in'|'out', peer, message_type}`
- Fichier cible : `~/octopulse/.claude/shared/communication-protocol.md`
- Convention : table markdown `| # | Émetteur | Récepteur | Type de message | Règle |`

## YOUR TASK:

Si `direct_flows` fourni, ajouter les flux dans la table existante de communication-protocol.md.

---

## EXECUTION SEQUENCE:

### 1. Check condition

```bash
FLOWS=$(jq -c .direct_flows /tmp/octopulse-create-agent-state.json)
if [ "$FLOWS" = "null" ] || [ "$FLOWS" = "[]" ]; then
  echo "SKIP: aucun flux direct, pass to step-05"
  # Update state
  python3 -c "
import json
s = json.load(open('/tmp/octopulse-create-agent-state.json'))
s['stepsCompleted'].append(4)
s['step_04_skipped'] = True
json.dump(s, open('/tmp/octopulse-create-agent-state.json','w'), indent=2)
"
  # Load next step
  exit 0
fi
```

### 2. Backup

```bash
ssh octopulse@204.168.209.232 "cp ~/octopulse/.claude/shared/communication-protocol.md ~/octopulse/.claude/shared/communication-protocol.md.orig"
```

### 3. Pull file local pour édition

```bash
scp octopulse@204.168.209.232:~/octopulse/.claude/shared/communication-protocol.md /tmp/comm-proto.md
```

### 4. Trouver le dernier N et append

Script Python :

```python
import json, re
state = json.load(open("/tmp/octopulse-create-agent-state.json"))
name = state["name"]
flows = state["direct_flows"]

content = open("/tmp/comm-proto.md").read()

# Trouver le dernier numéro dans la table
rows = re.findall(r"^\|\s*(\d+)\s*\|.*\|$", content, re.MULTILINE)
last_num = max([int(r) for r in rows]) if rows else 0

# Générer nouvelles lignes
new_lines = []
for f in flows:
    last_num += 1
    emit = name if f["direction"] == "out" else f["peer"]
    recv = f["peer"] if f["direction"] == "out" else name
    new_lines.append(f"| {last_num} | {emit} | {recv} | {f['message_type']} | CC Sparky 30 min |")

# Append après la dernière ligne de la table
# Pattern : trouver la position après la dernière row data
pattern = re.compile(r"(^\|\s*\d+\s*\|.*\|\s*$)", re.MULTILINE)
matches = list(pattern.finditer(content))
if matches:
    # Insérer après la dernière match
    last_match = matches[-1]
    insert_pos = last_match.end()
    new_content = content[:insert_pos] + "\n" + "\n".join(new_lines) + content[insert_pos:]
else:
    # Pas de table détectée — append à la fin (unlikely)
    new_content = content + "\n\n## Flux directs ajoutés\n\n" + "\n".join(new_lines) + "\n"

open("/tmp/comm-proto-new.md", "w").write(new_content)
print(f"Appended {len(new_lines)} flux directs")
```

### 5. SCP back

```bash
scp /tmp/comm-proto-new.md octopulse@204.168.209.232:~/octopulse/.claude/shared/communication-protocol.md
```

### 6. Update state JSON

```python
import json, datetime
state = json.load(open("/tmp/octopulse-create-agent-state.json"))
state["patched_files"].append({
    "path": "~/octopulse/.claude/shared/communication-protocol.md",
    "backup": "~/octopulse/.claude/shared/communication-protocol.md.orig"
})
state["stepsCompleted"].append(4)
state["step_04_completed_at"] = datetime.datetime.utcnow().isoformat() + "Z"
json.dump(state, open("/tmp/octopulse-create-agent-state.json", "w"), indent=2)
```

---

## SUCCESS METRICS:

✅ Step skipped si pas de direct_flows (state marqué step_04_skipped)
✅ Sinon : backup créé + table augmentée avec les nouveaux flux numérotés
✅ State JSON tracking backup path pour rollback

## FAILURE MODES:

❌ Backup non créé → rollback impossible
❌ Pattern regex table non match → append à la fin du fichier (warn mais not fatal)
❌ SCP back échoue → état incohérent, rollback via backup

## PATCH PROTOCOLS:

- Backup TOUJOURS avant modif
- Ne JAMAIS toucher les autres sections du fichier
- Numérotation continue (pas de trous)

---

## NEXT STEP:

Load `./step-05-patch-kairos.md`

<critical>
Remember: surgical append. Pas de réécriture. Si quelque chose va mal, on restaure .orig.
</critical>
