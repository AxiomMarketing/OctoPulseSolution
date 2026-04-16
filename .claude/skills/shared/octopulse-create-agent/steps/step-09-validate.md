---
name: step-09-validate
description: Validation finale clawmem doctor + kairos-ctl + frontmatter parse
prev_step: steps/step-08-sync-mirror.md
next_step: steps/step-10-summary.md
---

# Step 9: Validation finale

## MANDATORY EXECUTION RULES (READ FIRST):

- 🛑 NEVER skip la validation (c'est le filet de sécurité avant summary)
- 🛑 NEVER mark stepsCompleted si une validation fail
- ✅ ALWAYS ULTRA THINK avant de déclarer l'agent opérationnel
- ✅ ALWAYS checker les 3 points : ClawMem / KAIROS (si applicable) / frontmatter
- 📋 YOU ARE A VALIDATOR
- 💬 FOCUS sur vérifications, pas sur corrections (si fail → rollback)

## EXECUTION PROTOCOLS:

- 🎯 3 checks indépendants, chacun doit passer
- 💾 Log chaque résultat dans state JSON `validation_results`
- 📖 Si un check fail → load step-99-rollback.md
- 🚫 FORBIDDEN de cacher un fail

## CONTEXT BOUNDARIES:

- L'agent existe sur VPS + Mac, avec skills, vault, peut-être crons
- Tous les fichiers tracked dans `created_files` et `patched_files`

## YOUR TASK:

Valider que l'agent est opérationnel en vérifiant ClawMem, KAIROS (si crons), et parse des fichiers créés.

---

## EXECUTION SEQUENCE:

### 1. Check ClawMem

```bash
ssh octopulse@204.168.209.232 '
export PATH=$HOME/.bun/bin:$PATH
clawmem doctor 2>&1 | tail -20
'
```

Doit :
- `All checks passed.` en fin
- Ligne `✓ Collection "agent-{name}"` présente

Si absent ou si erreur → fail.

### 2. Check KAIROS (conditionnel)

```bash
CRONS_PRESENT=$(jq -r '.crons != null and (.crons | length > 0)' /tmp/octopulse-create-agent-state.json)
if [ "$CRONS_PRESENT" = "true" ]; then
  ssh octopulse@204.168.209.232 '
  systemctl --user is-active kairos.service
  ~/octopulse/kairos/kairos-ctl status 2>&1 | head -5
  ~/octopulse/kairos/kairos-ctl list 2>&1 | grep -E "'$(jq -r ".crons | .[].id" /tmp/octopulse-create-agent-state.json | paste -sd"|" -)'"
  '
fi
```

Expected si crons :
- service active
- heartbeat alive
- Chaque cron id présent dans `kairos-ctl list`

### 3. Parse frontmatter de tous les fichiers créés

```python
import json, frontmatter

state = json.load(open("/tmp/octopulse-create-agent-state.json"))
results = {"parse_errors": []}

# Pour chaque .md créé
for f in state["created_files"]:
    if not f.endswith(".md"): continue
    if f.startswith("~/.claude/agent-memory"): continue  # pas de MD dans les vaults
    
    # Translate ~ to /home/octopulse for SSH check
    vps_path = f.replace("~", "/home/octopulse")
    # On fait via ssh cat
    import subprocess
    content = subprocess.check_output(
        ["ssh", "octopulse@204.168.209.232", f"cat {vps_path}"],
        text=True
    )
    try:
        fm = frontmatter.loads(content)
        name = fm.get("name")
        if not name:
            results["parse_errors"].append(f"{f} : name absent")
    except Exception as e:
        results["parse_errors"].append(f"{f} : {e}")

state["validation_results"] = results
json.dump(state, open("/tmp/octopulse-create-agent-state.json", "w"), indent=2)

if results["parse_errors"]:
    print("FAIL: parse errors :", results["parse_errors"])
    exit(1)
else:
    print("OK: tous les frontmatter parse")
```

### 4. Résumé validation

Marquer state JSON :
```python
import json, datetime
state = json.load(open("/tmp/octopulse-create-agent-state.json"))
state["stepsCompleted"].append(9)
state["step_09_completed_at"] = datetime.datetime.utcnow().isoformat() + "Z"
state["validated"] = True
json.dump(state, open("/tmp/octopulse-create-agent-state.json", "w"), indent=2)
```

---

## SUCCESS METRICS:

✅ `clawmem doctor` : All checks passed + collection agent-{name} présente
✅ Si crons : kairos.service active + tous les jobs listés
✅ Tous les .md créés ont un frontmatter `name` valide
✅ State JSON `validated: true`

## FAILURE MODES:

❌ clawmem doctor retourne une erreur → load rollback
❌ kairos.service inactive malgré step-05 → restart manuel tenté puis rollback si échoue
❌ Frontmatter invalid → rollback (agent cassé)
❌ Mac miroir md5 diff (step-08 a fail silently) → retry sync puis warn

## VALIDATE PROTOCOLS:

- Tous checks indépendants (on ne stop pas au premier fail, on agrège pour debug)
- Un seul fail = rollback
- Pas de "tentative de fix", le skill n'est pas un fixer

---

## NEXT STEP:

Load `./step-10-summary.md`

<critical>
Remember: validation = tous vert ou rollback. Pas de "yellow". Si quelque chose est incertain, on rollback.
</critical>
