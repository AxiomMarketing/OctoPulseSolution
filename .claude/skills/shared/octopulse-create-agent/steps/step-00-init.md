---
name: step-00-init
description: Parse + valide inputs, check unicity + service exists, init state JSON
next_step: steps/step-01-generate-agent-md.md
---

# Step 0: Initialization

## MANDATORY EXECUTION RULES (READ FIRST):

- 🛑 NEVER skip l'étape de validation regex + unicité
- 🛑 NEVER procéder si `{service}` n'existe pas (propose `/octopulse:create-service` à la place)
- ✅ ALWAYS créer le state JSON dans `/tmp/octopulse-create-agent-state.json` avant step-01
- ✅ ALWAYS noter `{tools_list}` défaut si pas fourni par user
- 📋 YOU ARE AN INITIALIZER, not a creator
- 💬 FOCUS sur inputs parsing + validation, pas sur création de fichiers
- 🚫 FORBIDDEN de charger step-01 tant que inputs invalides ou service manquant

## EXECUTION PROTOCOLS:

- 🎯 Parse tous les inputs avant validation
- 💾 Écrire state JSON immédiatement après validation réussie
- 📖 Si resume detected (state JSON déjà présent + stepsCompleted non vide) → ne PAS écraser, charger next incomplete step
- 🚫 FORBIDDEN de créer fichiers agents ici

## CONTEXT BOUNDARIES:

- Aucune variable de previous step (c'est le 1er)
- VPS + Mac miroir disponibles, supposer les deux accessibles
- `~/octopulse/` existe (workspace établi)
- Template `agent-master-template.md` existe dans `shared/templates/`

## YOUR TASK:

Parser les inputs utilisateur, valider regex + unicité du nom, vérifier l'existence du service métier, et initialiser le state JSON pour les steps suivantes.

---

## EXECUTION SEQUENCE:

### 1. Collect inputs

Inputs requis (voir SKILL.md `<parameters>`) : `name`, `service`, `model`, `description_short`, `role_long`, `skills_initial[]`.
Inputs optionnels : `effort` (si opus), `sub_agents[]`, `crons[]`, `direct_flows[]`, `auto_mode`.

**If `{auto_mode}` = true AND tous les inputs déjà fournis en argument structuré :**
→ Parser et passer à l'étape 2

**If `{auto_mode}` = false AND inputs partiels :**
→ Demander interactivement les inputs manquants via AskUserQuestion (1 question par input manquant)

### 2. Validate name regex

```bash
python3 -c "import re, sys; sys.exit(0 if re.match(r'^[a-z][a-z0-9-]{2,31}$', '{name}') else 1)" \
  || { echo 'ERROR: name invalide — doit matcher ^[a-z][a-z0-9-]{2,31}$'; exit 1; }
```

### 3. Check unicity

```bash
ssh octopulse@204.168.209.232 "test ! -f ~/octopulse/.claude/agents/{name}.md" \
  || { echo 'ERROR: agent {name} existe déjà'; exit 1; }
```

### 4. Check service exists

```bash
ssh octopulse@204.168.209.232 "test -d ~/octopulse/team-workspace/{service}"
```

**Si le service n'existe pas :**
- Stop workflow
- Message utilisateur : "Service `{service}` introuvable. Crée-le d'abord via `/octopulse:create-service`"
- NE PAS créer l'agent

### 5. Validate model enum

Accepter uniquement : `claude-sonnet-4-6`, `claude-opus-4-6`, `claude-haiku-4-5-20251001`.
Si opus + `effort` absent → défaut `medium`.

### 6. Setup tools_list default

Si `tools_list` non fourni :
```yaml
tools_list: [Read, Write, Edit, Bash, Grep, Glob, Agent, TaskCreate, TaskUpdate, TaskList]
```

Pour les skills qui nécessitent explicit tools : le template les injectera.

### 7. Write state JSON

```bash
cat > /tmp/octopulse-create-agent-state.json <<EOF
{
  "name": "{name}",
  "service": "{service}",
  "model": "{model}",
  "effort": "{effort}",
  "description_short": "{description_short}",
  "role_long": "{role_long}",
  "skills_initial": {skills_initial_json},
  "sub_agents": {sub_agents_json},
  "crons": {crons_json},
  "direct_flows": {direct_flows_json},
  "tools_list": {tools_list_json},
  "auto_mode": {auto_mode},
  "created_files": [],
  "patched_files": [],
  "clawmem_collections": [],
  "stepsCompleted": [0],
  "started_at": "$(date -u +%FT%TZ)"
}
EOF
```

### 8. Confirm start (si pas auto_mode)

**If `{auto_mode}` = true:**
→ Proceed to step-01 directement

**If `{auto_mode}` = false:**
AskUserQuestion résumant les inputs :
```yaml
questions:
  - header: "Start"
    question: "Workflow initialisé pour créer l'agent `{name}` dans le service `{service}` (modèle {model}). Démarrer ?"
    options:
      - label: "Démarrer (Recommandé)"
        description: "Lancer les 10 étapes"
      - label: "Modifier les inputs"
        description: "Revenir et ajuster"
      - label: "Annuler"
        description: "Abort workflow"
    multiSelect: false
```

---

## SUCCESS METRICS:

✅ Inputs requis tous présents et validés
✅ Name matches regex
✅ Name unique dans `.claude/agents/`
✅ Service existe (ou workflow aborté avec message clair)
✅ Model enum valide
✅ State JSON écrit dans `/tmp/octopulse-create-agent-state.json` avec tous les inputs
✅ `stepsCompleted: [0]` inscrit

## FAILURE MODES:

❌ Procéder malgré regex invalide
❌ Procéder si agent existe déjà (drift garanti)
❌ Procéder si service manquant sans proposer create-service
❌ State JSON non écrit → steps suivantes perdent le contexte
❌ **CRITICAL**: Ne pas utiliser AskUserQuestion quand auto_mode=false

## INIT PROTOCOLS:

- Parse ALL inputs avant validation
- Validation fail → abort propre avec message actionnable
- State JSON = source de vérité pour les steps suivantes ET pour le rollback
- Ne JAMAIS créer de fichiers agents ici

---

## NEXT STEP:

Après confirmation (ou auto), load `./step-01-generate-agent-md.md`.

<critical>
Remember: init = parse + validate + setup state. Ne pas générer de fichiers, pas patcher de configs. Tout ça arrive dans les steps suivantes.
</critical>
