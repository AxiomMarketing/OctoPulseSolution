---
name: step-01-generate-agent-md
description: Read template, substitute variables, write .claude/agents/{name}.md sur VPS
prev_step: steps/step-00-init.md
next_step: steps/step-02-create-skills.md
---

# Step 1: Générer le fichier agent master

## MANDATORY EXECUTION RULES (READ FIRST):

- 🛑 NEVER écraser un fichier agent existant (double-check même si step-00 a validé)
- 🛑 NEVER hardcoder des paths Mac dans le .md généré (c'est pour VPS + Mac miroir générique)
- ✅ ALWAYS lire le template depuis `~/octopulse/.claude/skills/shared/templates/agent-master-template.md`
- ✅ ALWAYS append créé file path dans state JSON `created_files`
- 📋 YOU ARE A GENERATOR, not an editor
- 💬 FOCUS sur substitution template → fichier agent, rien d'autre

## EXECUTION PROTOCOLS:

- 🎯 Lire template VPS + substituer + écrire en une passe
- 💾 Update state JSON `created_files: [+ agents/{name}.md]` + `stepsCompleted: [+1]`
- 📖 Pas de création de skills folder ici (c'est step-02)
- 🚫 FORBIDDEN de charger step-02 avant que agent .md parse frontmatter OK

## CONTEXT BOUNDARIES:

- State JSON disponible avec tous les inputs (lire `/tmp/octopulse-create-agent-state.json`)
- Template `agent-master-template.md` contient 13 placeholders `{{VAR}}`
- Ne pas modifier le template (read-only)

## YOUR TASK:

Lire le template agent master, substituer les 13 placeholders avec les inputs de state JSON, écrire le fichier agent sur VPS.

---

## EXECUTION SEQUENCE:

### 1. Load state

```bash
STATE=$(cat /tmp/octopulse-create-agent-state.json)
NAME=$(echo "$STATE" | jq -r .name)
SERVICE=$(echo "$STATE" | jq -r .service)
# ... etc pour tous les champs
```

### 2. Read template depuis VPS

```bash
ssh octopulse@204.168.209.232 "cat ~/octopulse/.claude/skills/shared/templates/agent-master-template.md" > /tmp/tpl-master.md
```

### 3. Préparer les substitutions

Pour chaque placeholder, calculer la valeur :

| Placeholder | Valeur |
|---|---|
| `{{AGENT_NAME}}` | `$NAME` |
| `{{AGENT_DESCRIPTION_SHORT}}` | `$DESCRIPTION_SHORT` |
| `{{AGENT_ROLE_LONG}}` | `$ROLE_LONG` |
| `{{SERVICE_NAME}}` | `$SERVICE` |
| `{{MODEL}}` | `$MODEL` |
| `{{EFFORT}}` | `$EFFORT` (ou "medium" si vide) |
| `{{TOOLS_LIST}}` | Joiner de `$TOOLS_LIST` array en markdown list `- Read\n- Write\n...` |
| `{{SUBS_LIST_OR_NONE}}` | Si `sub_agents` non vide : markdown list `- **<name>** — <description>` ; sinon "Aucun sub-agent pour cet agent." |
| `{{SKILLS_TABLE}}` | Tableau markdown 3 col `\| Skill \| Fréquence \| Description \|` depuis `skills_initial` (Fréquence = "à définir" par défaut) |
| `{{FREQUENCY}}` | Dérivé de `crons` si présent (ex: "Quotidien 7h45, Hebdo lundi 8h"), sinon "Continue (sur demande)" |
| `{{INPUTS}}` | "À définir" (placeholder — remplir manuellement plus tard) |
| `{{OUTPUTS}}` | "À définir" |
| `{{DIRECT_FLOWS_OR_NONE}}` | Si `direct_flows` non vide : table `\| Direction \| Peer \| Message type \|` ; sinon "Aucun flux direct — tout passe par Sparky." |

### 4. Faire la substitution

Utiliser Python pour sécurité (jq peut casser sur multi-line) :

```python
import json, sys
state = json.load(open("/tmp/octopulse-create-agent-state.json"))
template = open("/tmp/tpl-master.md").read()

subs = {
    "{{AGENT_NAME}}": state["name"],
    "{{AGENT_DESCRIPTION_SHORT}}": state["description_short"],
    # ... etc
}

for key, val in subs.items():
    template = template.replace(key, str(val))

# Vérifier qu'il ne reste aucun {{}} non substitué
import re
remaining = re.findall(r"\{\{[A-Z_]+\}\}", template)
if remaining:
    print(f"ERROR: placeholders non substitués : {remaining}", file=sys.stderr)
    sys.exit(1)

open("/tmp/generated-agent.md", "w").write(template)
print("OK, agent .md généré dans /tmp/generated-agent.md")
```

### 5. Écrire sur VPS

```bash
scp /tmp/generated-agent.md octopulse@204.168.209.232:~/octopulse/.claude/agents/{name}.md
```

### 6. Valider le frontmatter

```bash
ssh octopulse@204.168.209.232 "python3 -c 'import frontmatter; fm = frontmatter.load(\"$HOME/octopulse/.claude/agents/{name}.md\"); print(fm[\"name\"])'"
```

Doit imprimer `{name}`. Sinon → load step-99-rollback.md.

### 7. Update state JSON

```bash
python3 <<'PY'
import json, datetime
state = json.load(open("/tmp/octopulse-create-agent-state.json"))
state["created_files"].append(f"~/octopulse/.claude/agents/{state['name']}.md")
state["stepsCompleted"].append(1)
state["step_01_completed_at"] = datetime.datetime.utcnow().isoformat() + "Z"
json.dump(state, open("/tmp/octopulse-create-agent-state.json", "w"), indent=2)
PY
```

---

## SUCCESS METRICS:

✅ Template lu sans erreur
✅ Les 13 placeholders substitués (aucun `{{VAR}}` restant dans le fichier généré)
✅ Fichier écrit sur VPS à `~/octopulse/.claude/agents/{name}.md`
✅ Frontmatter parse OK (name matche)
✅ State JSON updated avec `created_files` + `stepsCompleted: [0,1]`

## FAILURE MODES:

❌ Placeholders non substitués → agent cassé → rollback
❌ scp échoue (réseau/permissions) → rollback
❌ Frontmatter invalide (YAML cassé par substitution) → rollback
❌ Écrire par-dessus un agent existant (devrait être bloqué par step-00, mais double-check)

## GENERATOR PROTOCOLS:

- Template est immuable
- Toute substitution produit du markdown valide + YAML parseable
- Échec = rollback complet de ce step (rm le fichier créé)

---

## NEXT STEP:

Load `./step-02-create-skills.md`

<critical>
Remember: ce step génère UN fichier agent. Pas de skills folder, pas de vault, pas de patches. Juste le `.md` agent.
</critical>
