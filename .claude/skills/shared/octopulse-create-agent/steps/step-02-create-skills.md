---
name: step-02-create-skills
description: Crée dossier skills/{name}/ + squelettes par skill_initial
prev_step: steps/step-01-generate-agent-md.md
next_step: steps/step-03-bootstrap-vault.md
---

# Step 2: Créer skills folder + squelettes

## MANDATORY EXECUTION RULES (READ FIRST):

- 🛑 NEVER créer des skills complètes ici (seulement les squelettes avec TODO)
- 🛑 NEVER utiliser namespace autre que `{name}:skill-name` dans le frontmatter
- ✅ ALWAYS lire template `skill-template.md` depuis `shared/templates/`
- ✅ ALWAYS append chaque skill créée dans state JSON `created_files`
- 📋 YOU ARE A SCAFFOLDER, not a skill writer
- 💬 FOCUS sur générer les fichiers vides avec structure correcte

## EXECUTION PROTOCOLS:

- 🎯 Une skill = un fichier markdown dans `.claude/skills/{name}/`
- 💾 Tracker chaque fichier créé pour rollback
- 📖 Les skills réelles seront remplies par l'utilisateur plus tard (TODO placeholders dans le template)
- 🚫 FORBIDDEN de skip un skill de skills_initial

## CONTEXT BOUNDARIES:

- `{skills_initial}` disponible dans state JSON (liste `{name, description}`)
- Template `skill-template.md` a 7 placeholders (SKILL_NAMESPACE, SKILL_NAME, SKILL_DESCRIPTION, SKILL_TITLE, INPUT_DESCRIPTION, OUTPUT_DESCRIPTION, EXAMPLES)
- Dossier `.claude/skills/{name}/` n'existe pas encore (à créer)

## YOUR TASK:

Créer le dossier skills et un fichier squelette par skill listée dans `{skills_initial}`, en utilisant le template partagé.

---

## EXECUTION SEQUENCE:

### 1. Load state + skills liste

```bash
STATE=$(cat /tmp/octopulse-create-agent-state.json)
NAME=$(echo "$STATE" | jq -r .name)
SKILLS=$(echo "$STATE" | jq -c .skills_initial)  # ex: [{"name":"daily-report","description":"..."}]
```

### 2. Créer le dossier skills

```bash
ssh octopulse@204.168.209.232 "mkdir -p ~/octopulse/.claude/skills/${NAME}"
```

### 3. Lire le template squelette

```bash
ssh octopulse@204.168.209.232 "cat ~/octopulse/.claude/skills/shared/templates/skill-template.md" > /tmp/tpl-skill.md
```

### 4. Générer chaque skill squelette

Pour chaque skill dans `{skills_initial}` :

```python
import json
state = json.load(open("/tmp/octopulse-create-agent-state.json"))
template = open("/tmp/tpl-skill.md").read()

for skill in state["skills_initial"]:
    content = template
    subs = {
        "{{SKILL_NAMESPACE}}": state["name"],
        "{{SKILL_NAME}}": skill["name"],
        "{{SKILL_DESCRIPTION}}": skill["description"],
        "{{SKILL_TITLE}}": skill["name"].replace("-", " ").title(),
        "{{INPUT_DESCRIPTION}}": "À définir. (Placeholder — remplir selon besoin de la skill.)",
        "{{OUTPUT_DESCRIPTION}}": "À définir.",
        "{{EXAMPLES}}": "À compléter avec 1-2 exemples d'usage.",
        # Step templates aussi placeholders
        "{{STEP1_TITLE}}": "TODO : première étape",
        "{{STEP1_BODY}}": "À remplir.",
        "{{STEP2_TITLE}}": "TODO : deuxième étape",
        "{{STEP2_BODY}}": "À remplir.",
        "{{RULE_1}}": "TODO : règle principale",
        "{{RULE_2}}": "TODO : règle secondaire",
    }
    for k, v in subs.items():
        content = content.replace(k, v)
    out = f"/tmp/skill-{skill['name']}.md"
    open(out, "w").write(content)
    print(f"Generated: {out}")
```

### 5. SCP chaque squelette sur VPS

```bash
for skill_file in /tmp/skill-*.md; do
  scp "$skill_file" "octopulse@204.168.209.232:~/octopulse/.claude/skills/${NAME}/"
done
```

Cleanup : `rm /tmp/skill-*.md`

### 6. Validation frontmatter batch

```bash
ssh octopulse@204.168.209.232 "
for f in ~/octopulse/.claude/skills/${NAME}/*.md; do
  python3 -c \"import frontmatter; fm=frontmatter.load('\$f'); print(fm.get('name'))\"
done
"
```

Chaque ligne doit imprimer `{name}:<skill-name>`.

### 7. Update state JSON

```python
import json, datetime
state = json.load(open("/tmp/octopulse-create-agent-state.json"))
for skill in state["skills_initial"]:
    state["created_files"].append(f"~/octopulse/.claude/skills/{state['name']}/{skill['name']}.md")
state["created_files"].append(f"~/octopulse/.claude/skills/{state['name']}/")  # dossier à cleanup
state["stepsCompleted"].append(2)
state["step_02_completed_at"] = datetime.datetime.utcnow().isoformat() + "Z"
json.dump(state, open("/tmp/octopulse-create-agent-state.json", "w"), indent=2)
```

---

## SUCCESS METRICS:

✅ Dossier `~/octopulse/.claude/skills/{name}/` créé
✅ N fichiers skill créés (N = len(skills_initial))
✅ Tous les frontmatter parse OK avec name = `{name}:<skill-name>`
✅ State JSON updated avec chemins fichiers

## FAILURE MODES:

❌ skills_initial liste vide → agent sans skills (OK techniquement, mais bizarre — warn)
❌ Un fichier skill avec frontmatter cassé → rollback l'ensemble
❌ mkdir échoue (permission) → rollback

## SCAFFOLDER PROTOCOLS:

- Squelette = fichier parse-able, pas fonctionnel
- User remplira les TODO plus tard manuellement ou via édition Claude
- 1 skill = 1 fichier dans `{name}/` (pas de sous-dossiers pour skills simples)

---

## NEXT STEP:

Load `./step-03-bootstrap-vault.md`

<critical>
Remember: squelettes uniquement. Ne pas écrire de logique business. L'utilisateur complétera les skills quand elles seront invoquées.
</critical>
