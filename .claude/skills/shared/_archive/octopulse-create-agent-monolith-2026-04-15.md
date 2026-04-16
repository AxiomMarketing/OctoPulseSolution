---
name: octopulse:create-agent
description: "Crée un nouvel agent master OctoPulse (14 étapes déterministes : fichier agent + skills squelettes + vault ClawMem + communication-protocol + KAIROS crons + CLAUDE.md + validation). Utiliser pour ajouter un agent à n'importe quel service métier (marketing, comptabilité, support, etc.). Garantit la cohérence structurelle cross-services."
---

<objective>
Générer un agent master OctoPulse respectant intégralement la structure standard. Toute création manuelle d'agent est interdite (drift garanti) — utiliser ce skill.
</objective>

<quick_start>
Le skill demande les inputs, valide, puis exécute 14 étapes idempotentes. Durée ~2-5 min selon nombre de subs/crons.
</quick_start>

<input_required>
- **name** : kebab-case, regex `^[a-z][a-z0-9-]{2,31}$`, unique dans `.claude/agents/`
- **service** : nom du service métier (marketing, comptabilite, support-client, commercial, financier, etc.)
- **model** : claude-sonnet-4-6 | claude-opus-4-6 | claude-haiku-4-5-20251001
- **effort** : low | medium | high (si opus)
- **description_short** : 1 phrase pour le frontmatter
- **role_long** : paragraphe "Tu es X, qui fait Y, pour Z"
- **skills_initial** : liste des skills à créer (squelettes). Format `{name, description}`
- **sub_agents** (optionnel) : liste. Format `{name, description, model}`. Enchaîne create-sub-agent après.
- **crons** (optionnel) : liste. Format `{id, cron, prompt, priority}`
- **direct_flows** (optionnel) : liste. Format `{direction: 'in'|'out', peer: agent_name, message_type}`
</input_required>

<steps>

### Étape 1 — Valider inputs

Vérifier que tous les inputs obligatoires sont fournis avant toute action sur le filesystem.

```bash
# Valider format name (regex kebab-case)
python3 -c "import re,sys; sys.exit(0 if re.match(r'^[a-z][a-z0-9-]{2,31}$', '{{name}}') else 1)" \
  || { echo "ERREUR: name '{{name}}' invalide. Format requis: ^[a-z][a-z0-9-]{2,31}$"; exit 1; }

# Vérifier unicité — le fichier ne doit pas exister
ssh octopulse@204.168.209.232 "test ! -f ~/octopulse/.claude/agents/{{name}}.md" \
  || { echo "ERREUR: agent '{{name}}' existe déjà dans .claude/agents/. Abort."; exit 1; }

# Vérifier que le service existe sur le VPS
ssh octopulse@204.168.209.232 "test -d ~/octopulse/team-workspace/{{service}}" \
  || { echo "ERREUR: service '{{service}}' introuvable dans team-workspace/. Lancer /octopulse:create-service d'abord."; exit 1; }

# Vérifier model valide
python3 -c "
import sys
valid = ['claude-sonnet-4-6','claude-opus-4-6','claude-haiku-4-5-20251001']
if '{{model}}' not in valid:
    print(f'ERREUR: model invalide. Valeurs acceptées: {valid}')
    sys.exit(1)
"
```

Si une validation échoue → abort immédiat, ne pas poursuivre.

---

### Étape 2 — Générer le fichier .md agent

Lire le template master, substituer toutes les variables, écrire le fichier agent.

```bash
# Lire le template localement
TEMPLATE=$(cat /Users/admin/octopulse/.claude/skills/shared/templates/agent-master-template.md)
```

Substitutions à effectuer (toutes les occurrences `{{VAR}}`) :

| Placeholder | Valeur |
|---|---|
| `{{AGENT_NAME}}` | name |
| `{{AGENT_DESCRIPTION_SHORT}}` | description_short |
| `{{MODEL}}` | model |
| `{{EFFORT}}` | effort (ou "medium" par défaut) |
| `{{AGENT_ROLE_LONG}}` | role_long |
| `{{SERVICE_NAME}}` | service |
| `{{TOOLS_LIST}}` | Liste markdown `- Read, Write, Edit, Bash, Grep, Glob` + outils déduits des skills |
| `{{SUBS_LIST_OR_NONE}}` | Liste `- **sub.name** — sub.description` ou `Aucun sub-agent pour cet agent.` |
| `{{SKILLS_TABLE}}` | Tableau `\| nom \| fréquence \| description \|` (une ligne par skill) |
| `{{FREQUENCY}}` | Déduire des crons (ex: "Hebdomadaire lundi 09:00") ou "À définir" |
| `{{INPUTS}}` | "À définir" |
| `{{OUTPUTS}}` | "À définir" |
| `{{DIRECT_FLOWS_OR_NONE}}` | Tableau `\| direction \| peer \| message_type \|` ou `Aucun flux direct.` |

```bash
# Écrire le fichier généré localement d'abord
cat > /tmp/{{name}}.md << 'AGENT_EOF'
# [CONTENU GÉNÉRÉ PAR SUBSTITUTION DU TEMPLATE]
AGENT_EOF

# SCP vers VPS
scp /tmp/{{name}}.md octopulse@204.168.209.232:~/octopulse/.claude/agents/{{name}}.md

# Copie Mac locale (Syncthing backup)
cp /tmp/{{name}}.md /Users/admin/octopulse/.claude/agents/{{name}}.md
```

---

### Étape 3 — Créer dossier skills et squelettes

Créer le répertoire skills de l'agent et générer un squelette pour chaque skill demandé.

```bash
# Créer répertoire sur VPS
ssh octopulse@204.168.209.232 "mkdir -p ~/octopulse/.claude/skills/{{name}}"

# Créer répertoire local
mkdir -p /Users/admin/octopulse/.claude/skills/{{name}}
```

Pour chaque entrée dans `skills_initial` (skill.name + skill.description) :

```bash
# Lire le template skill
SKILL_TMPL=$(cat /Users/admin/octopulse/.claude/skills/shared/templates/skill-template.md)

# Substituer les placeholders
# {{SKILL_NAMESPACE}} → {{name}}
# {{SKILL_NAME}}      → skill.name
# {{SKILL_DESCRIPTION}} → skill.description
# {{SKILL_TITLE}}     → "# skill.name" (titre lisible)
# Tous les autres {{...}} → "TODO: à implémenter"

# Écrire localement puis SCP
cat > /tmp/{{name}}-skill-{{skill.name}}.md << 'SKILL_EOF'
# [SQUELETTE GÉNÉRÉ]
SKILL_EOF

scp /tmp/{{name}}-skill-{{skill.name}}.md \
    octopulse@204.168.209.232:~/octopulse/.claude/skills/{{name}}/{{skill.name}}.md

cp /tmp/{{name}}-skill-{{skill.name}}.md \
    /Users/admin/octopulse/.claude/skills/{{name}}/{{skill.name}}.md
```

---

### Étape 4 — Créer le vault agent-memory

```bash
# Idempotent : mkdir -p ne fail pas si déjà existant
ssh octopulse@204.168.209.232 "mkdir -p ~/.claude/agent-memory/{{name}}"

# Vérification
ssh octopulse@204.168.209.232 "test -d ~/.claude/agent-memory/{{name}}" \
  && echo "Vault directory OK" \
  || { echo "ERREUR: impossible de créer le vault directory"; exit 1; }
```

---

### Étape 5 — Bootstrap ClawMem (OBLIGATOIRE)

Un agent sans vault ClawMem est invisible au système de mémoire — ne jamais sauter cette étape.

```bash
# Vérifier si collection déjà initialisée (idempotence)
ALREADY=$(ssh octopulse@204.168.209.232 \
  'export PATH=$HOME/.bun/bin:$PATH; clawmem collection list 2>/dev/null | grep "agent-{{name}}" || true')

if [ -z "$ALREADY" ]; then
  # Créer la collection
  ssh octopulse@204.168.209.232 \
    'export PATH=$HOME/.bun/bin:$PATH; clawmem collection add \
      --path ~/.claude/agent-memory/{{name}} \
      --name agent-{{name}}'

  # Créer marker d'initialisation
  ssh octopulse@204.168.209.232 \
    "touch ~/.claude/agent-memory/{{name}}/.clawmem-initialized"

  echo "ClawMem collection agent-{{name}} créée."
else
  echo "ClawMem collection agent-{{name}} déjà existante — skip."
fi

# Validation obligatoire
ssh octopulse@204.168.209.232 \
  'export PATH=$HOME/.bun/bin:$PATH; clawmem doctor' | grep "agent-{{name}}" \
  || { echo "ERREUR: clawmem doctor ne trouve pas agent-{{name}}"; exit 1; }
```

---

### Étape 6 — Patcher communication-protocol (si flux directs)

Exécuter uniquement si `direct_flows` est non vide.

```bash
# Récupérer le fichier sur VPS
scp octopulse@204.168.209.232:~/octopulse/.claude/shared/communication-protocol.md \
    /tmp/communication-protocol.md

# Backup avant modification
cp /tmp/communication-protocol.md /tmp/communication-protocol.md.orig
```

Pour chaque flux dans `direct_flows` (flux.direction + flux.peer + flux.message_type) :

```python
# Trouver le dernier numéro de ligne dans le tableau des flux
# et appender : | N+1 | {{name}} | flux.peer | flux.message_type | CC Sparky 30 min |
import re

with open('/tmp/communication-protocol.md', 'r') as f:
    content = f.read()

# Trouver la dernière ligne du tableau flux (pattern | N | ...)
lines = content.split('\n')
last_flux_idx = -1
last_flux_num = 0
for i, line in enumerate(lines):
    m = re.match(r'\|\s*(\d+)\s*\|', line)
    if m:
        last_flux_idx = i
        last_flux_num = int(m.group(1))

new_line = f"| {last_flux_num+1} | {{name}} | {peer} | {message_type} | CC Sparky 30 min |"
lines.insert(last_flux_idx + 1, new_line)

with open('/tmp/communication-protocol.md', 'w') as f:
    f.write('\n'.join(lines))
```

```bash
# SCP retour sur VPS et Mac
scp /tmp/communication-protocol.md \
    octopulse@204.168.209.232:~/octopulse/.claude/shared/communication-protocol.md

cp /tmp/communication-protocol.md \
    /Users/admin/octopulse/.claude/shared/communication-protocol.md
```

---

### Étape 7 — Patcher KAIROS config.yml (si crons)

Exécuter uniquement si `crons` est non vide.

```bash
# Récupérer config KAIROS
scp octopulse@204.168.209.232:~/octopulse/kairos/config.yml /tmp/kairos-config.yml

# Backup
cp /tmp/kairos-config.yml /tmp/kairos-config.yml.orig
```

Pour chaque entrée dans `crons` (cron.id + cron.cron + cron.prompt + cron.priority) :

```python
import yaml

with open('/tmp/kairos-config.yml', 'r') as f:
    config = yaml.safe_load(f)

# Vérifier idempotence (job.id déjà présent ?)
existing_ids = [j.get('id') for j in config.get('jobs', [])]
if cron_id not in existing_ids:
    config['jobs'].append({
        'id': cron_id,           # ex: "{{name}}-weekly"
        'cron': cron_schedule,   # ex: "0 9 * * 1"
        'agent': '{{name}}',
        'prompt': cron_prompt,
        'priority': cron_priority,
        'enabled': True,
        'notify_on': ['failure']
    })
else:
    print(f"Job {cron_id} déjà présent — skip.")

with open('/tmp/kairos-config.yml', 'w') as f:
    yaml.dump(config, f, allow_unicode=True, default_flow_style=False)
```

```bash
# SCP retour
scp /tmp/kairos-config.yml octopulse@204.168.209.232:~/octopulse/kairos/config.yml

# Restart KAIROS et vérifier actif
ssh octopulse@204.168.209.232 \
  "systemctl --user restart kairos.service && sleep 3 && systemctl --user is-active kairos.service" \
  | grep -q "^active$" \
  || { echo "ERREUR: kairos.service n'est pas actif après restart"; exit 1; }
```

---

### Étape 8 — Enchaîner sub_agents (si fournis)

Exécuter uniquement si `sub_agents` est non vide. Les subs doivent être créés séquentiellement, pas en parallèle.

Pour chaque sub dans `sub_agents` (sub.name + sub.description + sub.model) :

```
Invoquer le skill /octopulse:create-sub-agent avec les paramètres :
  name         = sub.name
  parent_master = {{name}}
  model        = sub.model
  description  = sub.description

Attendre la confirmation de complétion avant de passer au sub suivant.
```

Note : `/octopulse:create-sub-agent` gère son propre vault, skills squelettes et synchro — ne pas dupliquer ces actions ici.

---

### Étape 9 — Patcher CLAUDE.md

```bash
# Récupérer CLAUDE.md depuis VPS
scp octopulse@204.168.209.232:~/octopulse/CLAUDE.md /tmp/CLAUDE.md

# Backup
cp /tmp/CLAUDE.md /tmp/CLAUDE.md.orig
```

```python
with open('/tmp/CLAUDE.md', 'r') as f:
    content = f.read()

new_entry = f"- **{{name}}** ({model}) — {description_short}"

# Vérifier idempotence
if new_entry in content:
    print("Entrée déjà présente dans CLAUDE.md — skip.")
else:
    # Chercher section "### Agents disponibles" ou "### Agents"
    if '### Agents disponibles' in content:
        content = content.replace(
            '### Agents disponibles\n',
            f'### Agents disponibles\n{new_entry}\n'
        )
    elif '### Agents' in content:
        content = content.replace(
            '### Agents\n',
            f'### Agents\n{new_entry}\n'
        )
    else:
        # Créer la section à la fin du fichier
        content += f'\n\n### Agents\n{new_entry}\n'

    with open('/tmp/CLAUDE.md', 'w') as f:
        f.write(content)
```

```bash
# SCP retour sur VPS et Mac
scp /tmp/CLAUDE.md octopulse@204.168.209.232:~/octopulse/CLAUDE.md
cp /tmp/CLAUDE.md /Users/admin/octopulse/CLAUDE.md
```

---

### Étape 10 — Bloc KAIROS délégation

Le template `agent-master-template.md` inclut déjà la section délégation KAIROS dans le fichier agent généré à l'étape 2. Aucune action supplémentaire requise.

Vérifier que la section est bien présente dans le fichier généré :

```bash
grep -q "Délégation asynchrone via KAIROS" /tmp/{{name}}.md \
  && echo "Section KAIROS delegation OK" \
  || echo "AVERTISSEMENT: section KAIROS absente — vérifier le template"
```

---

### Étape 11 — Synchro VPS ↔ Mac

Syncthing gère la synchro automatique, mais forcer immédiatement pour les fichiers critiques.

```bash
# Fichier agent
scp octopulse@204.168.209.232:~/octopulse/.claude/agents/{{name}}.md \
    /Users/admin/octopulse/.claude/agents/{{name}}.md

# Dossier skills complet
scp -r octopulse@204.168.209.232:~/octopulse/.claude/skills/{{name}}/ \
    /Users/admin/octopulse/.claude/skills/

# Vérifier présence locale
test -f /Users/admin/octopulse/.claude/agents/{{name}}.md \
  && echo "Synchro Mac agent OK" \
  || echo "ERREUR: fichier agent absent sur Mac après synchro"

test -d /Users/admin/octopulse/.claude/skills/{{name}} \
  && echo "Synchro Mac skills OK" \
  || echo "ERREUR: dossier skills absent sur Mac après synchro"
```

---

### Étape 12 — Restart services si config KAIROS modifiée

Inclus dans l'étape 7 (restart kairos.service après patch config.yml). Si aucun cron n'a été ajouté, aucun restart nécessaire.

```bash
# Vérification de l'état final du service (toujours, indépendamment des crons)
ssh octopulse@204.168.209.232 "systemctl --user is-active kairos.service" \
  | grep -q "^active$" \
  && echo "KAIROS service actif OK" \
  || echo "AVERTISSEMENT: KAIROS service non actif — investiguer"
```

---

### Étape 13 — Validation finale (OBLIGATOIRE)

Ne jamais sauter cette étape — les échecs silencieux coûtent 10x plus cher à déboguer.

```bash
# 1. Vérifier vault ClawMem
ssh octopulse@204.168.209.232 \
  'export PATH=$HOME/.bun/bin:$PATH; clawmem doctor' | grep "agent-{{name}}" \
  || { echo "ERREUR VALIDATION: collection ClawMem agent-{{name}} absente"; exit 1; }

# 2. Vérifier crons KAIROS (si applicable)
if [ -n "{{crons}}" ]; then
  ssh octopulse@204.168.209.232 \
    "~/octopulse/kairos/kairos-ctl list" | grep "{{name}}" \
    || { echo "ERREUR VALIDATION: jobs KAIROS pour {{name}} absents"; exit 1; }
fi

# 3. Valider frontmatter du fichier agent (parseable YAML)
python3 -c "
import frontmatter, sys
try:
    fm = frontmatter.load('/Users/admin/octopulse/.claude/agents/{{name}}.md')
    assert fm.get('name'), 'frontmatter: champ name manquant'
    assert fm.get('description'), 'frontmatter: champ description manquant'
    assert fm.get('model'), 'frontmatter: champ model manquant'
    print('Frontmatter OK:', fm['name'])
except Exception as e:
    print(f'ERREUR VALIDATION frontmatter: {e}')
    sys.exit(1)
"

# 4. Vérifier présence sur VPS
ssh octopulse@204.168.209.232 "test -f ~/octopulse/.claude/agents/{{name}}.md" \
  && echo "Fichier agent VPS OK" \
  || { echo "ERREUR VALIDATION: fichier agent absent sur VPS"; exit 1; }

# 5. Vérifier comptage skills
SKILLS_COUNT=$(ssh octopulse@204.168.209.232 \
  "ls ~/octopulse/.claude/skills/{{name}}/*.md 2>/dev/null | wc -l")
echo "Skills créées: $SKILLS_COUNT (attendu: {{skills_initial|length}})"
```

---

### Étape 14 — Output summary

```
✓ Agent {{name}} créé

  .md        : ~/octopulse/.claude/agents/{{name}}.md
  Skills     : N créées dans ~/octopulse/.claude/skills/{{name}}/
  Vault      : ~/.claude/agent-memory/{{name}}/ (ClawMem agent-{{name}})
  Subs       : N sous-agents enchaînés
  KAIROS     : N crons ajoutés
  Flux       : N flux directs enregistrés
  CLAUDE.md  : section agents patchée

Prochaines étapes :
1. Remplir INPUTS/OUTPUTS dans {{name}}.md
2. Implémenter les skills (actuellement squelettes)
3. Test : `kairos-ctl dry-run {{name}}-<job>` si crons
```

</steps>

<validation>
Chaque étape est idempotente : si ré-exécutée (ex: vault déjà existant), skip gracefully avec message.

Rollback sur échec :
- Si étape 2-7 échoue → suppression des fichiers créés dans cet appel
- Si étape 8+ échoue → agent créé partiellement, logger warnings, laisser l'utilisateur décider
</validation>

<rollback>
En cas d'erreur avant complétion :

```bash
# 1. Supprimer fichier agent
ssh octopulse@204.168.209.232 "rm -f ~/octopulse/.claude/agents/{{name}}.md"
rm -f /Users/admin/octopulse/.claude/agents/{{name}}.md

# 2. Supprimer dossier skills
ssh octopulse@204.168.209.232 "rm -rf ~/octopulse/.claude/skills/{{name}}/"
rm -rf /Users/admin/octopulse/.claude/skills/{{name}}/

# 3. Supprimer collection ClawMem
ssh octopulse@204.168.209.232 \
  'export PATH=$HOME/.bun/bin:$PATH; clawmem collection remove --name agent-{{name}} 2>/dev/null || true'

# 4. Supprimer vault directory
ssh octopulse@204.168.209.232 "rm -rf ~/.claude/agent-memory/{{name}}/"

# 5. Revert communication-protocol (si backup .orig existe)
if [ -f /tmp/communication-protocol.md.orig ]; then
  scp /tmp/communication-protocol.md.orig \
      octopulse@204.168.209.232:~/octopulse/.claude/shared/communication-protocol.md
  cp /tmp/communication-protocol.md.orig \
      /Users/admin/octopulse/.claude/shared/communication-protocol.md
fi

# 6. Revert KAIROS config (si backup .orig existe)
if [ -f /tmp/kairos-config.yml.orig ]; then
  scp /tmp/kairos-config.yml.orig \
      octopulse@204.168.209.232:~/octopulse/kairos/config.yml
  ssh octopulse@204.168.209.232 "systemctl --user restart kairos.service"
fi

# 7. Revert CLAUDE.md (si backup .orig existe)
if [ -f /tmp/CLAUDE.md.orig ]; then
  scp /tmp/CLAUDE.md.orig octopulse@204.168.209.232:~/octopulse/CLAUDE.md
  cp /tmp/CLAUDE.md.orig /Users/admin/octopulse/CLAUDE.md
fi

echo "Rollback complet pour agent {{name}}"
```
</rollback>

<examples>

### Exemple 1 : Agent simple sans subs ni crons

Input :
```yaml
name: compta-factures
service: comptabilite
model: claude-sonnet-4-6
description_short: "Agent gestion factures fournisseurs et clients"
role_long: "Tu es compta-factures, responsable du traitement quotidien des factures. Vérification cohérence, enregistrement, relances."
skills_initial:
  - {name: process-invoice, description: "Traite une facture PDF"}
  - {name: reconciliation, description: "Rapprochement bancaire mensuel"}
```

Résultat : 1 fichier agent + 2 skills squelettes + 1 vault + 1 collection ClawMem. Aucun flux direct, aucun cron, aucun sub.

### Exemple 2 : Agent complet (comme les masters marketing actuels)

Input :
```yaml
name: commercial-head
service: commercial
model: claude-opus-4-6
effort: high
description_short: "Head of Sales — pipeline B2B et stratégie acquisition comptes"
role_long: "Tu es commercial-head, directeur commercial. Tu gères le pipeline, les hypothèses de vente, les briefs aux BDR."
skills_initial:
  - {name: pipeline-review, description: "Revue pipeline hebdo"}
sub_agents:
  - {name: commercial-bdr, description: "BDR cold outreach", model: claude-sonnet-4-6}
  - {name: commercial-ae, description: "Account Executive closings", model: claude-sonnet-4-6}
crons:
  - {id: commercial-head-weekly, cron: "0 9 * * 1", prompt: "/commercial-head:pipeline-review", priority: high}
direct_flows:
  - {direction: out, peer: atlas, message_type: "data request CA"}
```

Résultat : agent + 1 skill + 2 subs (via create-sub-agent) + 1 cron (via KAIROS patch) + 1 flux (via protocol patch) + vault + synchro complet.

</examples>

<safety>
- JAMAIS créer un agent sans passer par cette skill
- JAMAIS skip l'étape 5 (ClawMem bootstrap) — un agent sans vault est invisible au système de mémoire
- JAMAIS skip l'étape 13 (validation) — les échecs silencieux coûtent 10x plus cher à debug
</safety>
