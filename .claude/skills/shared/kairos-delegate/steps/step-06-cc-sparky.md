---
name: step-06-cc-sparky
description: Si cross-domaine, envoyer message résumé à Sparky (Pattern 4.11)
prev_step: steps/step-05-write-yaml.md
next_step: steps/step-07-confirm.md
---

# Step 6: CC Sparky (conditionnel)

## MANDATORY EXECUTION RULES (READ FIRST):

- 🛑 NEVER skip CC Sparky si `cc_sparky_required: true` (Pattern 4.11)
- 🛑 NEVER envoyer un spam détaillé → résumé concis uniquement
- ✅ ALWAYS préciser le trigger_id + caller + target + 1 ligne contexte
- ✅ ALWAYS skip si flux direct autorisé (cc_sparky_required: false)
- 📋 YOU ARE A NOTIFIER
- 💬 FOCUS sur message court à Sparky

## EXECUTION PROTOCOLS:

- 🎯 Conditionnel sur `cc_sparky_required`
- 💾 Noter dans state si CC envoyé
- 📖 Best-effort : si l'envoi échoue, warn mais ne bloque pas (Sparky verra le trigger via monitoring)
- 🚫 FORBIDDEN de s'arrêter si CC fail (le trigger est déjà déposé)

## CONTEXT BOUNDARIES:

- `yaml_path` existe depuis step-05
- Sparky = agent coordinator sur VPS, accessible via SendMessage si même team, sinon via fichier CC dans son vault
- MVP : écrire un fichier de notification dans `~/.claude/agent-memory/sparky/cc-inbox/` (Sparky le lira à son prochain tick)

## YOUR TASK:

Si `cc_sparky_required`, écrire un fichier CC dans le vault de Sparky avec résumé du trigger.

---

## EXECUTION SEQUENCE:

### 1. Check condition

```bash
CC_REQUIRED=$(jq -r .cc_sparky_required "$STATE_FILE")
if [ "$CC_REQUIRED" != "true" ]; then
  echo "SKIP: flux direct autorisé, pas de CC Sparky"
  jq '.stepsCompleted += [6] | .step_06_skipped = true' "$STATE_FILE" > "${STATE_FILE}.tmp" && mv "${STATE_FILE}.tmp" "$STATE_FILE"
  exit 0
fi
```

### 2. Construire le message CC

```python
import json, datetime
state = json.load(open(state_file))

cc_message = f"""# CC Sparky : Trigger KAIROS déposé

**Trigger ID** : `{state['trigger_id']}`
**Émetteur** : {state['caller_agent']}
**Destinataire** : {state['target_agent']}
**Priority** : {state['priority']}
**Créé** : {datetime.datetime.utcnow().isoformat()}Z

## Contexte (1ère ligne du prompt)

> {state['prompt'].split('.')[0][:200]}

## Raison CC

Flux `{state['caller_agent']}` → `{state['target_agent']}` n'est pas dans les 7 flux directs autorisés (communication-protocol.md). CC Sparky obligatoire (Pattern Sentinel 4.11).

## Action attendue Sparky

- Accuser réception sous 30 min (marker dans ce fichier ou réponse)
- Si mission complexe (> 3 Masters impactés) : considérer orchestration globale au lieu de triggers individuels
- Si conflit avec une mission en cours : escalader Marty

---
_Généré par /kairos:delegate_
"""

cc_filename = f"cc-{state['trigger_id']}.md"
cc_local = f"/tmp/{cc_filename}"
open(cc_local, "w").write(cc_message)
```

### 3. Écrire dans vault Sparky

```bash
ssh octopulse@204.168.209.232 "mkdir -p ~/.claude/agent-memory/sparky/cc-inbox"
scp /tmp/${CC_FILENAME} octopulse@204.168.209.232:~/.claude/agent-memory/sparky/cc-inbox/${CC_FILENAME}
```

### 4. Best-effort : SendMessage si team alive

Si le workflow tourne dans une session Claude avec un team qui inclut Sparky, on peut aussi envoyer un message direct :

```python
# Pseudo-code (exécution via tool SendMessage dans la session)
# SendMessage(to="sparky", summary="CC trigger <id>", message=cc_message)
# Mais cette action dépend du contexte d'invocation — si pas de team, skip
```

Noter dans state si SendMessage a été tenté.

### 5. Cleanup + update state

```bash
rm -f /tmp/${CC_FILENAME}
```

```python
state["cc_sparky_sent"] = True
state["cc_sparky_path"] = f"~/.claude/agent-memory/sparky/cc-inbox/{cc_filename}"
state["stepsCompleted"].append(6)
state["step_06_completed_at"] = datetime.datetime.utcnow().isoformat() + "Z"
json.dump(state, open(state_file, "w"), indent=2)
```

---

## SUCCESS METRICS:

✅ Skip si `cc_sparky_required: false`
✅ Fichier CC écrit dans `~/.claude/agent-memory/sparky/cc-inbox/` si requis
✅ Message court (résumé), pas tout le prompt
✅ Raison CC explicitée (quel flux, quel pattern)

## FAILURE MODES:

❌ Skip quand cross-domaine → Pattern 4.11 violation
❌ Message trop long → pollue le vault Sparky
❌ Bloquer le workflow si CC fail → le trigger est déjà déposé, il va s'exécuter
❌ **CRITICAL**: Oublier d'écrire dans vault Sparky (Sparky ne verra jamais)

## CC PROTOCOLS:

- Conditionnel strict sur cc_sparky_required
- Best-effort : log + continue si écriture échoue (warn)
- Format concis : trigger_id + caller + target + 1 ligne contexte

---

## NEXT STEP:

Load `./step-07-confirm.md`

<critical>
Remember: CC Sparky = visibilité, pas permission. Le trigger est déjà déposé à step-05, le CC est informationnel.
</critical>
