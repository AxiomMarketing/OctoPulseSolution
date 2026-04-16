---
name: step-02-collect-inputs
description: Valider target_agent regex, prompt non-vide, vérifier existence target
prev_step: steps/step-01-validate-need.md
next_step: steps/step-03-choose-priority.md
---

# Step 2: Valider et collecter inputs

## MANDATORY EXECUTION RULES (READ FIRST):

- 🛑 NEVER accepter target_agent invalide (regex strict)
- 🛑 NEVER accepter prompt vide ou < 10 caractères
- 🛑 NEVER laisser passer des secrets en clair dans le prompt
- ✅ ALWAYS vérifier que target_agent existe sur VPS
- ✅ ALWAYS strip + sanitize le prompt
- 📋 YOU ARE AN INPUT VALIDATOR
- 💬 FOCUS sur validation stricte, pas d'application business
- 🚫 FORBIDDEN de procéder si un input est invalide

## EXECUTION PROTOCOLS:

- 🎯 Valider target_agent → regex + existence
- 💾 Écrire validations dans state JSON
- 📖 Si fail → abort avec message précis (pas rollback, rien n'a été créé)
- 🚫 FORBIDDEN de charger step-03 avec inputs invalides

## CONTEXT BOUNDARIES:

- State JSON contient target_agent et prompt des inputs caller
- Liste des agents valides = fichiers dans `~/octopulse/.claude/agents/` + `subs/`
- Patterns de secrets connus : AWS key, Anthropic/Groq keys, SSH keys, bearer tokens

## YOUR TASK:

Valider strictement target_agent (regex + existence) et prompt (non-vide + pas de secrets).

---

## EXECUTION SEQUENCE:

### 1. Load state

```bash
STATE_FILE=$(find /tmp -name 'kairos-delegate-state-*.json' -mmin -10 | head -1)
TARGET=$(jq -r .target_agent "$STATE_FILE")
PROMPT=$(jq -r .prompt "$STATE_FILE")
```

### 2. Regex target_agent

```bash
python3 -c "
import re, sys
target = '$TARGET'
# Master : ^[a-z][a-z0-9-]{2,31}$
# Sub : ^[a-z][a-z0-9-]+-[a-z0-9-]+$ (contient un -)
if not re.match(r'^[a-z][a-z0-9-]{2,31}$', target):
    print(f'FAIL: target_agent invalid: {target}', file=sys.stderr)
    sys.exit(1)
print('OK regex')
"
```

### 3. Existence sur VPS

```bash
ssh octopulse@204.168.209.232 "
test -f ~/octopulse/.claude/agents/${TARGET}.md \
  || test -f ~/octopulse/.claude/agents/subs/${TARGET}.md
"
```

Si échec :
```
FAIL: target_agent '{target}' n'existe pas sur le VPS.

Agents disponibles : liste via `ls ~/octopulse/.claude/agents/*.md`
Sub-agents : liste via `ls ~/octopulse/.claude/agents/subs/*.md`
```

### 4. Prompt non-vide + longueur

```python
prompt = state["prompt"]
if not prompt or len(prompt.strip()) < 10:
    # Abort
    print("FAIL: prompt vide ou < 10 caractères", file=sys.stderr)
    sys.exit(1)
```

Max length : 10 000 chars (prévient DOS + match KAIROS timeout 900s).

### 5. Secret scanning (patterns rapides)

```python
import re
SECRET_PATTERNS = {
    "aws_key": r"AKIA[0-9A-Z]{16}",
    "anthropic_key": r"sk-ant-[A-Za-z0-9_-]{20,}",
    "groq_key": r"gsk_[A-Za-z0-9]{40,}",
    "bearer": r"Bearer\s+[A-Za-z0-9_-]{20,}",
    "ssh_private": r"-----BEGIN (RSA|OPENSSH|EC|DSA) PRIVATE KEY-----",
    "generic_api_key": r"[\"']?(api[_-]?key|apikey|token|secret)[\"']?\s*[:=]\s*[\"'][A-Za-z0-9_\-]{20,}[\"']",
}
hits = []
for name, pat in SECRET_PATTERNS.items():
    if re.search(pat, prompt):
        hits.append(name)
if hits:
    print(f"FAIL: secret pattern détecté : {hits}. Ne JAMAIS mettre de secrets en clair dans un trigger (il sera loggé + potentiellement envoyé à Marty via Telegram).", file=sys.stderr)
    sys.exit(1)
```

### 6. Update state

```python
import json, datetime
state = json.load(open(state_file))
state["prompt"] = prompt.strip()  # normalized
state["target_validated"] = True
state["stepsCompleted"].append(2)
state["step_02_completed_at"] = datetime.datetime.utcnow().isoformat() + "Z"
json.dump(state, open(state_file, "w"), indent=2)
```

---

## SUCCESS METRICS:

✅ Target_agent match regex `^[a-z][a-z0-9-]{2,31}$`
✅ Target_agent existe sur VPS (fichier .md présent)
✅ Prompt ≥ 10 chars et ≤ 10 000 chars
✅ Aucun pattern secret détecté dans le prompt
✅ State JSON mis à jour

## FAILURE MODES:

❌ Target_agent invalide → trigger file avec mauvais name → KAIROS skip ou erreur
❌ Prompt vide → KAIROS timeout 900s sur claude -p ""
❌ Secret dans prompt → leak via logs + Telegram
❌ **CRITICAL**: bypass la secret detection (garde-fou majeur)

## VALIDATION PROTOCOLS:

- Regex strict = pas de negotiation
- Secret detection = deny by default, pas de "probably OK"
- Si ambigüité : abort propre plutôt que "je tente"

---

## NEXT STEP:

Load `./step-03-choose-priority.md`

<critical>
Remember: input validation = rempart anti-leaking + anti-error. Un secret qui passe = un incident de sécurité.
</critical>
