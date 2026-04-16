---
name: step-08-sync-mirror
description: Synchronisation VPS → Mac miroir pour tous les fichiers touchés
prev_step: steps/step-07-patch-claude-md.md
next_step: steps/step-09-validate.md
---

# Step 8: Sync Mac mirror

## MANDATORY EXECUTION RULES (READ FIRST):

- 🛑 NEVER forcer le sync si Syncthing est déjà à jour (check mtime)
- 🛑 NEVER toucher au VPS dans ce step (Mac uniquement)
- ✅ ALWAYS copier tous les fichiers de `created_files` + `patched_files` du state JSON
- ✅ ALWAYS vérifier md5sum match entre VPS et Mac après sync
- 📋 YOU ARE A MIRROR SYNCER
- 💬 FOCUS sur Mac copy uniquement

## EXECUTION PROTOCOLS:

- 🎯 scp chaque fichier du state individuellement (safe contre Syncthing lag)
- 💾 Pas de state update besoin (sync est idempotent)
- 📖 Syncthing finira de toute façon mais on force pour usage immédiat
- 🚫 FORBIDDEN de toucher au VPS ici

## CONTEXT BOUNDARIES:

- `created_files` et `patched_files` dans state JSON contiennent les paths
- Mac miroir = `/Users/admin/octopulse/` (pour les fichiers `~/octopulse/...`)
- Mac miroir = `/Users/admin/.claude/agent-memory/...` pour vaults (si configuré sync, sinon skip vault)

## YOUR TASK:

Copier tous les fichiers créés/patchés du VPS vers le miroir Mac, vérifier l'intégrité.

---

## EXECUTION SEQUENCE:

### 1. Extraire liste fichiers du state

```python
import json
state = json.load(open("/tmp/octopulse-create-agent-state.json"))
files_to_sync = []

# Créés
for f in state["created_files"]:
    # Skip dirs (se terminent par /), skip vaults locaux (on ne sync pas ~/.claude)
    if f.endswith("/"): continue
    if f.startswith("~/.claude/agent-memory/"): continue  # vault reste VPS-only par design
    files_to_sync.append(f)

# Patchés
for p in state["patched_files"]:
    files_to_sync.append(p["path"])

# Déduplication
files_to_sync = list(set(files_to_sync))
print("\n".join(files_to_sync))
```

### 2. SCP chaque fichier

Pour chaque path, le `~/octopulse/...` sur VPS correspond à `/Users/admin/octopulse/...` sur Mac.

```bash
for path in $FILES_TO_SYNC; do
  # Remplacer ~ par /home/octopulse pour VPS et /Users/admin pour Mac
  VPS_PATH=$(echo "$path" | sed 's|^~|/home/octopulse|')
  MAC_PATH=$(echo "$path" | sed 's|^~/octopulse|/Users/admin/octopulse|; s|^~/.claude|/Users/admin/.claude|')
  
  mkdir -p "$(dirname "$MAC_PATH")"
  scp "octopulse@204.168.209.232:$VPS_PATH" "$MAC_PATH"
done
```

### 3. Vérifier md5sum match

```bash
for path in $FILES_TO_SYNC; do
  VPS_MD5=$(ssh octopulse@204.168.209.232 "md5sum '$(echo $path | sed s#^~#/home/octopulse#)' 2>/dev/null | cut -d' ' -f1")
  MAC_MD5=$(md5 -q "$(echo $path | sed 's|^~/octopulse|/Users/admin/octopulse|; s|^~/.claude|/Users/admin/.claude|')" 2>/dev/null)
  if [ "$VPS_MD5" != "$MAC_MD5" ]; then
    echo "FAIL sync: $path (VPS=$VPS_MD5 Mac=$MAC_MD5)"
  fi
done
```

### 4. Update state JSON

```python
import json, datetime
state = json.load(open("/tmp/octopulse-create-agent-state.json"))
state["stepsCompleted"].append(8)
state["step_08_completed_at"] = datetime.datetime.utcnow().isoformat() + "Z"
json.dump(state, open("/tmp/octopulse-create-agent-state.json", "w"), indent=2)
```

---

## SUCCESS METRICS:

✅ Tous les fichiers created_files + patched_files copiés sur Mac
✅ md5sum match VPS vs Mac
✅ Pas de vault copié (design : vault reste VPS-only)

## FAILURE MODES:

❌ md5sum diff → retry une fois, sinon warn (Syncthing prendra le relais)
❌ Dossiers parents manquants sur Mac → `mkdir -p` préventif
❌ Vault copié par erreur (ne doit jamais l'être) → manifestation bug

## SYNC PROTOCOLS:

- scp individual (safe vs rsync qui peut conflicter avec Syncthing)
- Vaults ClawMem restent VPS-only (c'est la convention)
- Après ce step, Mac a une copie immédiate (pas besoin d'attendre Syncthing)

---

## NEXT STEP:

Load `./step-09-validate.md`

<critical>
Remember: Mac copy uniquement. VPS n'est pas modifié dans ce step.
</critical>
