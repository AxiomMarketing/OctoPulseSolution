---
name: step-10-summary
description: Output résumé + checklist prochaines étapes utilisateur
prev_step: steps/step-09-validate.md
---

# Step 10: Summary

## MANDATORY EXECUTION RULES (READ FIRST):

- 🛑 NEVER claim success si validated != true dans state JSON
- ✅ ALWAYS afficher le résumé structuré (table)
- ✅ ALWAYS lister les actions post-création requises de l'utilisateur
- 📋 YOU ARE A REPORTER
- 💬 FOCUS sur clarté de l'output

## EXECUTION PROTOCOLS:

- 🎯 Output markdown-formaté en chat
- 💾 Ne pas écrire de fichier (sauf si save_mode était set)
- 📖 Cleanup state JSON après affichage (move vers `/tmp/archive/`)

## YOUR TASK:

Afficher un résumé complet de la création + checklist pour Marty.

---

## EXECUTION SEQUENCE:

### 1. Load state

```python
import json
state = json.load(open("/tmp/octopulse-create-agent-state.json"))
```

### 2. Afficher résumé

```markdown
# ✓ Agent {name} créé

## Fichiers créés sur VPS + Mac

| Type | Chemin |
|---|---|
| Agent .md | `~/octopulse/.claude/agents/{name}.md` |
| Skills | N squelettes dans `~/octopulse/.claude/skills/{name}/` |
| Vault | `~/.claude/agent-memory/{name}/` (collection `agent-{name}`) |

## Fichiers patchés

{ Pour chaque entrée dans state.patched_files : path + backup }

## Sub-agents attachés

{ Liste state.subs_created ou "aucun" }

## Jobs KAIROS ajoutés

{ Liste state.crons ou "aucun" }

## Flux directs enregistrés

{ Liste state.direct_flows ou "aucun" }

## Validations

- ClawMem doctor : ✓
- KAIROS service (si crons) : ✓
- Frontmatter parse : ✓
- Mac miroir md5 match : ✓

---

## ✏️ Prochaines étapes pour Marty

1. **Remplir les placeholders** dans `~/octopulse/.claude/agents/{name}.md` :
   - Section INPUTS (actuellement "À définir")
   - Section OUTPUTS (actuellement "À définir")
2. **Implémenter les skills** (squelettes TODO) dans `~/octopulse/.claude/skills/{name}/`
3. **Remplir le context métier** si nouveau service : `~/octopulse/team-workspace/{service}/references/{service}-context.md`
4. **Tester** :
   - Si crons : `kairos-ctl dry-run {crons[0].id}`
   - Via Telegram : envoyer `@{name} ping` et vérifier réponse
5. **Documenter dans `CLAUDE.md`** les patterns spécifiques à cet agent si applicable
```

### 3. Archive state JSON

```bash
mkdir -p /tmp/archive
mv /tmp/octopulse-create-agent-state.json /tmp/archive/octopulse-create-agent-$(jq -r .name /tmp/octopulse-create-agent-state.json)-$(date +%Y%m%d-%H%M%S).json 2>/dev/null
```

---

## SUCCESS METRICS:

✅ Résumé affiché complet
✅ Checklist actionable fournie
✅ State JSON archivé (pas détruit — utile pour audit futur)

## FAILURE MODES:

❌ Résumé incomplet (données manquantes dans state) → debug state JSON avant
❌ Oubli des actions manuelles requises pour l'utilisateur

## SUMMARY PROTOCOLS:

- Ton : factuel, pas promotionnel
- Liste actionnable : chaque item = une action concrète
- Lien vers fichiers créés pour review facile

---

## NEXT STEP:

Workflow complete. Retour au caller.

<critical>
Remember: le skill est fini. Archive state, affiche résumé, c'est tout.
</critical>
