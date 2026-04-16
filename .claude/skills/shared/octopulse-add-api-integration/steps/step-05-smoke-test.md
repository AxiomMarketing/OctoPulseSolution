---
name: step-05-smoke-test
description: vsearch query de test sur la collection docs-<name>, sync Mac miroir, résumé final du provisioning
prev_step: steps/step-04-clawmem-bootstrap.md
next_step: null
---

# Step 5: Smoke test + sync + résumé

## MANDATORY EXECUTION RULES (READ FIRST):

- NEVER marquer le provisioning comme succès si vsearch retourne 0 passages
- ALWAYS syncer le Mac miroir après validation VPS
- ALWAYS afficher un résumé complet avec checklist de validation
- YOU ARE THE VALIDATOR — smoke test + cleanup + summary
- FORBIDDEN de marquer smoke_test_ok = true si vsearch retourne 0 résultats

## YOUR TASK:

Valider que la collection ClawMem répond correctement, synchroniser sur le Mac miroir, afficher le résumé final et la checklist de validation.

---

## EXECUTION SEQUENCE:

### 1. Load state

```bash
STATE_FILE="/tmp/octopulse-add-api-state-${name}.json"
NAME=$(python3 -c "import json; print(json.load(open('$STATE_FILE'))['name'])")
DISPLAY_NAME=$(python3 -c "import json; print(json.load(open('$STATE_FILE'))['display_name'])")
COLLECTION=$(python3 -c "import json; print(json.load(open('$STATE_FILE'))['clawmem_collection'])")
```

### 2. Smoke test vsearch

```bash
ssh octopulse@204.168.209.232 "
export PATH=\$HOME/.bun/bin:\$PATH
RESULTS=\$(clawmem vsearch -c docs-${NAME} 'list available endpoints' -n 3 2>&1)
echo \"\$RESULTS\"
COUNT=\$(echo \"\$RESULTS\" | grep -c '^\[' 2>/dev/null || echo 0)
if [ \"\$COUNT\" -lt 1 ]; then
  echo 'SMOKE_FAIL: 0 passages retournés'
  exit 1
fi
echo \"SMOKE_OK: \${COUNT} passages\"
"
```

Si `SMOKE_FAIL` :
```
Smoke test échoué : vsearch retourne 0 passages pour docs-{name}.
Causes possibles :
  - L'embedding n'est pas terminé (attendre 1-2 min et réessayer)
  - reference.md trop court ou mal formaté
  - Erreur silencieuse clawmem lors de l'embed

Action : relancer step-04 ou vérifier les logs clawmem.
```
Abort sans marquer succès.

### 3. Sync Mac miroir

```bash
rsync -avh --delete \
  octopulse@204.168.209.232:~/octopulse/integrations/docs/${NAME}/ \
  /Users/admin/octopulse/integrations/docs/${NAME}/
echo "Sync Mac miroir OK"
```

Créer aussi le dossier local si inexistant :
```bash
mkdir -p /Users/admin/octopulse/integrations/{docs,schemas,recipes}/${NAME}
```

### 4. Update state final

```python
state["smoke_test_ok"] = True
state["stepsCompleted"].append(5)
state["completed_at"] = datetime.datetime.utcnow().isoformat() + "Z"
json.dump(state, open(STATE_FILE, "w"), indent=2)
```

### 5. Résumé final

Afficher :

```
==========================================
  API provisionnée : {display_name}
==========================================

CHECKLIST DE VALIDATION
  [x] Dossiers créés    ~/octopulse/integrations/docs/{name}/
                        ~/octopulse/integrations/schemas/{name}/
                        ~/octopulse/integrations/recipes/{name}/
  [x] registry.yml      entrée '{name}' ajoutée
  [x] Bitwarden         item '{bw_item}' accessible
  [x] Documentation     docs/{name}/reference.md écrit
  [x] ClawMem           collection docs-{name} indexée
  [x] Smoke test        vsearch retourne ≥1 passage
  [x] Mac miroir        synced /Users/admin/octopulse/integrations/docs/{name}/

UTILISATION IMMÉDIATE
  Query doc    : /api:query-docs {name} "comment authentifier"
  Validate req : /api:validate-request {name} <endpoint> <payload>
  Safe call    : /api:safe-call {name} <endpoint>

AUTOMATIQUE (KAIROS nightly 02:30)
  Re-indexation : fetch_schedule = {fetch_schedule}
  Prochaine exécution : cette nuit à 02:30 UTC

PROCHAINES ÉTAPES (optionnel)
  - Créer schemas JSON dans schemas/{name}/ pour activer /api:validate-request
  - Créer recipes dans recipes/{name}/ pour les appels courants
  - Tester un appel réel : ~/octopulse/integrations/_lib/bw-get.sh {bw_item}
==========================================
```

### 6. Cleanup state temporaire (optionnel)

```bash
# Garder le state JSON 24h pour debug, puis cleanup automatique
# Le cron nightly cleanup /tmp/octopulse-add-api-state-*.json s'en charge
```

---

## SUCCESS METRICS:

- vsearch retourne ≥1 passage pour "list available endpoints"
- Mac miroir synced
- `smoke_test_ok: true` dans state JSON
- Résumé affiché avec checklist complète

## FAILURE MODES:

- vsearch retourne 0 → embedding pas terminé ou fichier doc invalide
- rsync échoue → Mac miroir désynchronisé (non bloquant pour VPS)
- Résumé non affiché → agent n'a pas de visibilité sur l'état final

---

## PROVISIONING COMPLETE

L'API `{name}` est maintenant disponible dans le système d'intégrations OctoPulse.
