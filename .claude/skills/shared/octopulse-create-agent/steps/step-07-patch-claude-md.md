---
name: step-07-patch-claude-md
description: Ajoute l'agent à la section "Agents disponibles" de CLAUDE.md
prev_step: steps/step-06-chain-subs.md
next_step: steps/step-08-sync-mirror.md
---

# Step 7: Patch CLAUDE.md

## MANDATORY EXECUTION RULES (READ FIRST):

- 🛑 NEVER écraser CLAUDE.md (append uniquement)
- 🛑 NEVER créer une nouvelle section si "Agents disponibles" n'existe pas — append dans l'existante ou créer sous la section appropriée
- ✅ ALWAYS backup `.orig`
- ✅ ALWAYS vérifier l'idempotence (si le nom est déjà dans la section, skip)
- 📋 YOU ARE A DOC PATCHER
- 💬 FOCUS sur une ligne à ajouter, rien de plus

## EXECUTION PROTOCOLS:

- 🎯 Cherche la section "## Agents disponibles" ou "### Agents disponibles" — patch dans celle-là
- 💾 Backup + tracking
- 📖 Si section absente, créer sous "## Services actifs" ou fin du fichier
- 🚫 FORBIDDEN de toucher les autres sections

## CONTEXT BOUNDARIES:

- Fichier cible : `~/octopulse/CLAUDE.md`
- Format ligne à ajouter : `- **{name}** ({model}) — {description_short}`

## YOUR TASK:

Ajouter une ligne dans la section "Agents disponibles" de CLAUDE.md avec le nouvel agent.

---

## EXECUTION SEQUENCE:

### 1. Backup + pull

```bash
ssh octopulse@204.168.209.232 "cp ~/octopulse/CLAUDE.md ~/octopulse/CLAUDE.md.orig"
scp octopulse@204.168.209.232:~/octopulse/CLAUDE.md /tmp/claude-md.md
```

### 2. Patch Python

```python
import json, re
state = json.load(open("/tmp/octopulse-create-agent-state.json"))
name, model, desc = state["name"], state["model"], state["description_short"]

content = open("/tmp/claude-md.md").read()
new_line = f"- **{name}** ({model}) — {desc}"

# Idempotence
if f"**{name}**" in content:
    print(f"SKIP: {name} déjà dans CLAUDE.md")
else:
    # Cherche section "Agents disponibles"
    section_pattern = re.compile(r"(^#{2,3}\s+Agents disponibles.*?$)", re.MULTILINE | re.IGNORECASE)
    match = section_pattern.search(content)
    if match:
        # Append après la section header (trouve la prochaine section ou fin)
        start = match.end()
        # Trouver la prochaine section de même niveau ou plus haut
        next_section = re.search(r"^\s*#", content[start:], re.MULTILINE)
        if next_section:
            insert_pos = start + next_section.start()
            new_content = content[:insert_pos].rstrip() + f"\n{new_line}\n\n" + content[insert_pos:]
        else:
            new_content = content.rstrip() + f"\n{new_line}\n"
    else:
        # Section absente — append à la fin avec header
        new_content = content.rstrip() + f"\n\n## Agents disponibles\n\n{new_line}\n"
    
    open("/tmp/claude-md-new.md", "w").write(new_content)
    print(f"OK: {new_line} ajouté")
```

### 3. SCP back

```bash
scp /tmp/claude-md-new.md octopulse@204.168.209.232:~/octopulse/CLAUDE.md
```

### 4. Update state

```python
import json, datetime
state = json.load(open("/tmp/octopulse-create-agent-state.json"))
state["patched_files"].append({
    "path": "~/octopulse/CLAUDE.md",
    "backup": "~/octopulse/CLAUDE.md.orig"
})
state["stepsCompleted"].append(7)
state["step_07_completed_at"] = datetime.datetime.utcnow().isoformat() + "Z"
json.dump(state, open("/tmp/octopulse-create-agent-state.json", "w"), indent=2)
```

---

## SUCCESS METRICS:

✅ CLAUDE.md contient la ligne de l'agent
✅ Backup créé
✅ Autres sections intactes (diff minimal)
✅ Idempotence vérifiée

## FAILURE MODES:

❌ Section "Agents disponibles" absente + création chaotique (ex: au mauvais endroit)
❌ Double insertion (pas d'idempotence)
❌ Backup non créé → rollback impossible

## PATCH PROTOCOLS:

- Idempotent : re-run = skip si déjà patché
- Pas de regex destructive sur markdown (risque de casser d'autres sections)
- Test de validité : le MD doit toujours rendre correctement

---

## NEXT STEP:

Load `./step-08-sync-mirror.md`

<critical>
Remember: 1 ligne dans 1 section. Rien de plus.
</critical>
