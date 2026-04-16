---
name: octopulse:create-sub-agent
description: "Crée un sub-agent attaché à un master OctoPulse (6 étapes). Les sub-agents n'ont pas de crons, pas de flux externes, pas de skills partagées — ils reçoivent des briefs de leur master parent uniquement. Utiliser pour ajouter des capacités spécialisées à un master (ex: forge-copywriter attaché à forge)."
---

<objective>
Générer un sub-agent OctoPulse respectant la structure standard. Sub-agents = enfants directs d'un master, nom préfixé par celui du parent.
</objective>

<input_required>
- **name** : kebab-case préfixé par le parent. Regex `^{parent_master}-[a-z0-9-]{2,31}$`
- **parent_master** : nom d'un master existant (doit avoir un .md dans `.claude/agents/`)
- **model** : claude-sonnet-4-6 | claude-haiku-4-5-20251001 | claude-opus-4-6 (rarement)
- **description_short** : 1 phrase pour frontmatter
- **role_long** : paragraphe décrivant le rôle et la personnalité du sub-agent
- **scope** : périmètre précis (ce qu'il fait, ce qu'il ne fait PAS)
- **tools** (optionnel, défaut: [Read, Write, Edit, Bash, Grep]) : liste des tools autorisés
</input_required>

<steps>

### Étape 1 — Valider les inputs

Vérifier le format du nom :
```bash
# Le name doit commencer par {parent_master}-
echo "{{name}}" | grep -qP "^{{parent_master}}-[a-z0-9-]{2,31}$" && echo "OK" || echo "ERREUR: format invalide"
```

Vérifier que le master parent existe sur le VPS :
```bash
ssh octopulse@VPS "test -f ~/octopulse/.claude/agents/{{parent_master}}.md && echo 'OK' || echo 'ERREUR: master introuvable'"
```

Vérifier que le sub-agent n'existe pas déjà :
```bash
ssh octopulse@VPS "test ! -f ~/octopulse/.claude/agents/subs/{{name}}.md && echo 'OK' || echo 'ERREUR: sub déjà existant'"
```

Si l'une des vérifications échoue, stopper et afficher l'erreur avant de continuer.

---

### Étape 2 — Générer le fichier .md

Lire le template :
```bash
cat ~/octopulse/.claude/skills/shared/templates/agent-sub-template.md
```

Substituer les placeholders suivants dans le contenu du template :
- `{{SUB_NAME}}` → valeur de **name**
- `{{PARENT_MASTER}}` → valeur de **parent_master**
- `{{MODEL}}` → valeur de **model**
- `{{SUB_DESCRIPTION}}` → valeur de **description_short**
- `{{ROLE_LONG}}` → valeur de **role_long**
- `{{SCOPE}}` → valeur de **scope**
- `{{TOOLS}}` → liste des tools ou défaut `[Read, Write, Edit, Bash, Grep]`
- `{{WORKFLOW_STEPS}}` → placeholder `À définir lors des premiers briefs`

Écrire le fichier résultant en local :
```
~/octopulse/.claude/agents/subs/{{name}}.md
```

---

### Étape 3 — Créer le vault agent-memory sur le VPS

Créer le répertoire vault :
```bash
ssh octopulse@VPS "mkdir -p ~/.claude/agent-memory/subs/{{name}}"
```

Vérifier la création :
```bash
ssh octopulse@VPS "test -d ~/.claude/agent-memory/subs/{{name}} && echo 'OK'"
```

---

### Étape 4 — Bootstrap ClawMem

Enregistrer la collection ClawMem :
```bash
ssh octopulse@VPS 'export PATH=$HOME/.bun/bin:$PATH; clawmem collection add --path ~/.claude/agent-memory/subs/{{name}} --name sub-{{name}}'
```

Créer le marker d'initialisation :
```bash
ssh octopulse@VPS "touch ~/.claude/agent-memory/subs/{{name}}/.clawmem-initialized"
```

Vérifier que la collection est bien visible :
```bash
ssh octopulse@VPS 'export PATH=$HOME/.bun/bin:$PATH; clawmem doctor | grep "sub-{{name}}"'
```

La sortie doit contenir `sub-{{name}}` — si absent, relancer la commande `collection add`.

---

### Étape 5 — Patcher le master parent

Lire le fichier master :
```bash
cat ~/octopulse/.claude/agents/{{parent_master}}.md
```

Localiser la section `## Sub-agents` dans le fichier :
- Si la section **existe** : ajouter la ligne suivante à la fin de la liste existante :
  ```
  - **{{name}}** — {{description_short}}
  ```
- Si la section **est absente** : la créer après la section `## Tools disponibles` :
  ```markdown
  ## Sub-agents

  - **{{name}}** — {{description_short}}
  ```

Écrire le fichier master modifié en local.

---

### Étape 6 — Synchronisation et validation finale

Copier le fichier sub-agent vers le VPS :
```bash
scp ~/octopulse/.claude/agents/subs/{{name}}.md octopulse@VPS:~/octopulse/.claude/agents/subs/{{name}}.md
```

Copier le fichier master patché vers le VPS :
```bash
scp ~/octopulse/.claude/agents/{{parent_master}}.md octopulse@VPS:~/octopulse/.claude/agents/{{parent_master}}.md
```

Valider le frontmatter du nouveau sub-agent sur le VPS :
```bash
ssh octopulse@VPS "head -5 ~/octopulse/.claude/agents/subs/{{name}}.md"
```

Confirmer la collection ClawMem :
```bash
ssh octopulse@VPS 'export PATH=$HOME/.bun/bin:$PATH; clawmem doctor | grep "sub-{{name}}"'
```

Afficher le résumé de création :

```
✓ Sub-agent {{name}} créé (parent: {{parent_master}})
  .md        : ~/octopulse/.claude/agents/subs/{{name}}.md
  Vault      : ~/.claude/agent-memory/subs/{{name}}/ (sub-{{name}})
  Parent     : {{parent_master}} (section Sub-agents patchée)
```

</steps>

<safety>
Les sub-agents NE DOIVENT PAS avoir :
- Leur propre dossier `.claude/skills/<name>/` — les skills partagées appartiennent au master
- De flux directs vers d'autres masters — toute communication passe par le parent
- De crons dans KAIROS — le master parent gère les récurrences
- De triggers KAIROS réactifs — le master dépose si besoin

Règles de communication :
- Sub-agent → master : communication directe, toujours
- Master cross-sub : via master parent uniquement, jamais en direct
</safety>

<examples>

### Exemple : forge-copywriter

Input :
```yaml
name: forge-copywriter
parent_master: forge
model: claude-sonnet-4-6
description_short: "Copywriter créatif pour scripts vidéo et textes publicitaires"
role_long: "Tu es forge-copywriter, spécialiste copywriting créatif. Tu rédiges scripts UGC, hooks punchy, CTAs."
scope: |
  IN SCOPE : scripts vidéo <30s, hooks texte, CTAs, headlines.
  OUT OF SCOPE : briefing stratégique (c'est forge-strategist), validation ton marque (c'est maeva via master).
```

Résultat attendu :
```
✓ Sub-agent forge-copywriter créé (parent: forge)
  .md        : ~/octopulse/.claude/agents/subs/forge-copywriter.md
  Vault      : ~/.claude/agent-memory/subs/forge-copywriter/ (sub-forge-copywriter)
  Parent     : forge (section Sub-agents patchée)
```

Artefacts créés : 1 fichier sub + 1 vault + patch forge.md (section Sub-agents). Aucun autre artefact.

</examples>
