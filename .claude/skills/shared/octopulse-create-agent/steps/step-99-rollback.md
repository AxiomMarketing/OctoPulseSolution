---
name: step-99-rollback
description: Rollback atomique — undo tous les artefacts via state JSON
---

# Step 99: Rollback

## MANDATORY EXECUTION RULES (READ FIRST):

- 🛑 NEVER exécuter ce step sans state JSON valide
- 🛑 NEVER rollback les sub-agents via ce step (ils ont leur propre rollback dans leur skill)
- ✅ ALWAYS commencer par les backups (.orig) AVANT de supprimer les fichiers créés
- ✅ ALWAYS logger chaque action undo pour audit post-mortem
- 📋 YOU ARE AN UNDO EXECUTOR
- 💬 FOCUS sur restauration état initial

## EXECUTION PROTOCOLS:

- 🎯 Ordre inverse des créations (LIFO : dernier créé, premier supprimé)
- 💾 Logger rollback dans `/tmp/octopulse-rollback-<timestamp>.log`
- 📖 Continuer même si une undo échoue (on fait best-effort)
- 🚫 FORBIDDEN de s'arrêter au premier échec

## CONTEXT BOUNDARIES:

- `created_files` : à supprimer
- `patched_files` : à restaurer depuis `.orig`
- `clawmem_collections` : à `remove`
- `subs_created` : à rollback via leur propre skill si déjà exécuté

## YOUR TASK:

Restaurer l'état pré-workflow en utilisant state JSON : restore backups, delete created files, remove ClawMem collections.

---

## EXECUTION SEQUENCE:

### 1. Load state + logger

```bash
mkdir -p /tmp/rollback-logs
LOG=/tmp/rollback-logs/octopulse-create-agent-$(date +%Y%m%d-%H%M%S).log
exec > >(tee -a "$LOG") 2>&1
echo "=== ROLLBACK START $(date -u +%FT%TZ) ==="
jq . /tmp/octopulse-create-agent-state.json
```

### 2. Restore patched files (depuis backups)

```bash
jq -c '.patched_files[]' /tmp/octopulse-create-agent-state.json | while read entry; do
  PATH_FILE=$(echo "$entry" | jq -r .path)
  BACKUP=$(echo "$entry" | jq -r .backup)
  echo "[undo-patch] Restoring $PATH_FILE from $BACKUP"
  ssh octopulse@204.168.209.232 "cp '$BACKUP' '$PATH_FILE' && rm '$BACKUP'" || echo "  FAIL"
done
```

### 3. Revert KAIROS restart si on avait patché config

Si kairos/config.yml était dans patched_files, restart le service pour charger la version restaurée :
```bash
if jq -e '.patched_files[] | select(.path | contains("kairos/config.yml"))' /tmp/octopulse-create-agent-state.json >/dev/null; then
  ssh octopulse@204.168.209.232 'systemctl --user restart kairos.service'
fi
```

### 4. Delete created files

```bash
jq -r '.created_files[]' /tmp/octopulse-create-agent-state.json | tac | while read path; do
  echo "[undo-create] Removing $path"
  VPS_PATH=$(echo "$path" | sed 's|^~|/home/octopulse|')
  if [ "${path: -1}" = "/" ]; then
    ssh octopulse@204.168.209.232 "rmdir '$VPS_PATH' 2>/dev/null" || echo "  SKIP (dir not empty)"
  else
    ssh octopulse@204.168.209.232 "rm -f '$VPS_PATH'" || echo "  FAIL"
    # Mac mirror aussi
    MAC_PATH=$(echo "$path" | sed 's|^~/octopulse|/Users/admin/octopulse|; s|^~/.claude|/Users/admin/.claude|')
    rm -f "$MAC_PATH" 2>/dev/null || echo "  SKIP Mac mirror $MAC_PATH"
  fi
done
```

### 5. Remove ClawMem collections

```bash
jq -r '.clawmem_collections[]' /tmp/octopulse-create-agent-state.json | while read coll; do
  echo "[undo-clawmem] Removing collection $coll"
  ssh octopulse@204.168.209.232 "
export PATH=\$HOME/.bun/bin:\$PATH
clawmem collection remove --name '$coll'
" || echo "  FAIL"
done
```

### 6. Rollback subs (si créés)

Pour chaque sub dans `subs_created`, invoquer leur rollback individuel — ils ont leur propre state JSON.

Si `/octopulse:create-sub-agent` a archivé son state JSON en `/tmp/archive/` : retrouver + rollback. Sinon, cleanup best-effort manuel.

### 7. Archive state JSON (pour audit)

```bash
mkdir -p /tmp/archive/rollbacks
mv /tmp/octopulse-create-agent-state.json /tmp/archive/rollbacks/rolled-back-$(jq -r .name /tmp/octopulse-create-agent-state.json)-$(date +%Y%m%d-%H%M%S).json
```

### 8. Report

```markdown
# ⚠️ Rollback exécuté — agent {name}

**Raison :** {failure reason de l'étape qui a déclenché}

**Actions undo :**
- {N} fichiers supprimés
- {N} fichiers restaurés depuis backups .orig
- {N} collections ClawMem supprimées
- Mac mirror nettoyé
- State JSON archivé dans `/tmp/archive/rollbacks/`

**Log complet :** `$LOG`

État système : **restauré à pré-workflow**.
```

---

## SUCCESS METRICS:

✅ Tous les backups .orig restaurés (patched_files)
✅ Tous les created_files supprimés VPS + Mac
✅ Toutes les collections ClawMem removed
✅ KAIROS restarté si config.yml était patché
✅ Log complet écrit pour audit
✅ State JSON archivé, pas détruit

## FAILURE MODES:

❌ Continuer malgré état incohérent (partiellement rollback) → warn visible dans log
❌ Perdre le log (pas de tee) → aucune trace pour debug
❌ Détruire state JSON → impossible d'analyser ce qui s'est passé

## ROLLBACK PROTOCOLS:

- Best-effort : continuer même si un undo échoue
- Log agressif (tout tracé)
- Archive state (pas delete) — pour post-mortem

---

## NEXT STEP:

Workflow avorté. Retour caller avec état rolled-back.

<critical>
Remember: rollback = restauration best-effort. Certains artefacts peuvent rester, le log doit les lister pour que Marty puisse finir manuellement si besoin.
</critical>
