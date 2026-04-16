---
name: octopulse:create-service
description: "Bootstrap un nouveau service métier OctoPulse (ex: comptabilité, support, commercial, financier). Crée team-workspace/<service>/ avec structure standard, génère un squelette de references/<service>-context.md, patche CLAUDE.md et univile-context.md. Puis permet d'enchaîner create-agent pour peupler le service."
---

<objective>
Ajouter un nouveau domaine métier à OctoPulse. OctoPulse n'est PAS un système marketing — le marketing est 1 service parmi N. Cette skill permet de scaler horizontalement à de nouveaux services sans drift structurel.
</objective>

<input_required>
- **name** : kebab-case (ex: comptabilite, support-client, commercial, financier, ressources-humaines). Regex `^[a-z][a-z0-9-]{2,31}$`
- **display_name** : version humaine (ex: "Comptabilité", "Support Client")
- **description** : 1-2 phrases décrivant la mission du service
- **agents_initial** (optionnel) : liste d'agents à créer juste après le service (format créé pour create-agent). Peut être vide.
- **kpis** (optionnel) : liste de KPIs principaux à tracker
- **budget_mensuel** (optionnel) : budget € du service si applicable
- **ownership** (optionnel) : responsable humain (utile si différent de Marty)
</input_required>

<steps>

### Étape 1 — Valider inputs

- Regex name : `^[a-z][a-z0-9-]{2,31}$` — rejeter si non conforme, indiquer le format attendu
- Unicité : `ssh octopulse@VPS "test ! -d ~/octopulse/team-workspace/{{name}}"` — si le dossier existe déjà → abort avec message clair, proposer mode update manuel
- display_name non vide
- Si validation échoue : arrêter immédiatement, ne pas continuer les étapes suivantes

### Étape 2 — Créer structure team-workspace

Lire `~/octopulse/.claude/skills/shared/templates/service-workspace.md` pour la liste exacte des sous-dossiers. La structure standard est :

```
team-workspace/<service>/
├── briefs/
│   ├── inbox/
│   └── done/
├── reports/
│   └── sparky-consolidations/
├── calendar/
├── decisions/
├── references/
└── assets/
```

Créer tous les dossiers via :

```bash
ssh octopulse@VPS 'mkdir -p ~/octopulse/team-workspace/{{name}}/{briefs/inbox,briefs/done,reports/sparky-consolidations,calendar,decisions,references,assets}'
```

Ajouter `.gitkeep` dans chaque dossier vide :

```bash
ssh octopulse@VPS 'find ~/octopulse/team-workspace/{{name}} -type d -empty -exec touch {}/.gitkeep \;'
```

### Étape 3 — Générer context.md squelette

Créer `~/octopulse/team-workspace/{{name}}/references/{{name}}-context.md` :

```markdown
# {{DISPLAY_NAME}} — Contexte métier

> Généré par `/octopulse:create-service`. À remplir.

## Mission
{{DESCRIPTION}}

## Chiffres clés
- Budget mensuel : {{BUDGET_OR_TBD}}
- Responsable : {{OWNERSHIP_OR_MARTY}}

## KPIs
{{KPI_LIST_OR_TBD}}

## Règles métier
À définir.

## Vocabulaire spécifique
À définir.

## Stakeholders
À définir.

## Outils / Systèmes
À définir (CRM, ERP, logiciel compta, etc.)

## Compliance / Règlementation
À définir.
```

Pour `{{KPI_LIST_OR_TBD}}` : si `kpis` fourni, générer une liste markdown `- item`. Sinon écrire `À définir.`
Pour `{{BUDGET_OR_TBD}}` : valeur fournie ou `À définir.`
Pour `{{OWNERSHIP_OR_MARTY}}` : valeur fournie ou `Marty`

### Étape 4 — Créer calendar/unified-calendar.md squelette

Créer `~/octopulse/team-workspace/{{name}}/calendar/unified-calendar.md` :

```markdown
# Calendrier unifié — {{DISPLAY_NAME}}

Événements, deadlines, périodes clés spécifiques au service.

## Deadlines récurrentes
| Jour | Deadline |
|------|----------|
| TBD  | TBD      |

## Événements 2026
À définir.
```

### Étape 5 — Patcher univile-context.md

- Lire `~/octopulse/.claude/shared/univile-context.md`
- Chercher section `## Services` — créer si absente (insérer après dernière section existante)
- Append ligne : `- **{{display_name}}** (\`team-workspace/{{name}}/\`) — {{description}}`
- Ne pas dupliquer si la ligne existe déjà

```bash
ssh octopulse@VPS "grep -q '## Services' ~/octopulse/.claude/shared/univile-context.md || echo '\n## Services\n' >> ~/octopulse/.claude/shared/univile-context.md"
ssh octopulse@VPS "echo '- **{{display_name}}** (\`team-workspace/{{name}}/\`) — {{description}}' >> ~/octopulse/.claude/shared/univile-context.md"
```

### Étape 6 — Patcher CLAUDE.md

- Lire `~/octopulse/CLAUDE.md`
- Chercher section `## Services actifs` — créer si absente (insérer juste après `## Contexte`)
- Append entrée similaire à univile-context
- Ne pas dupliquer si l'entrée existe déjà

```bash
ssh octopulse@VPS "grep -q '## Services actifs' ~/octopulse/CLAUDE.md || sed -i '/^## Contexte/a\\\n## Services actifs\n' ~/octopulse/CLAUDE.md"
ssh octopulse@VPS "echo '- **{{display_name}}** (\`team-workspace/{{name}}/\`) — {{description}}' >> ~/octopulse/CLAUDE.md"
```

### Étape 7 — Enchaîner agents_initial (si fournis)

Si `agents_initial` est non vide, pour chaque entrée de la liste :

- Invoquer `/octopulse:create-agent` avec les paramètres suivants :
  - `service` = `{{name}}`
  - `name` = nom de l'agent
  - `model`, `effort`, `description_short`, `role_long`, `skills_initial` = valeurs fournies
- Attendre la complétion de chaque agent avant de passer au suivant (séquentiel, pas parallèle)
- Logger chaque agent créé pour l'output final

Si `agents_initial` est vide ou absent : sauter cette étape.

### Étape 8 — Synchro VPS vers Mac

Rapatrier le nouveau service et les fichiers patchés sur le Mac local :

```bash
rsync -avh octopulse@VPS:~/octopulse/team-workspace/{{name}}/ /Users/admin/octopulse/team-workspace/{{name}}/
scp octopulse@VPS:~/octopulse/CLAUDE.md /Users/admin/octopulse/CLAUDE.md
scp octopulse@VPS:~/octopulse/.claude/shared/univile-context.md /Users/admin/octopulse/.claude/shared/univile-context.md
```

### Étape 9 — Validation

Vérifier que tout est en place :

```bash
# Structure workspace
ssh octopulse@VPS "ls ~/octopulse/team-workspace/{{name}}/"
# Doit afficher : briefs  reports  calendar  decisions  references  assets

# Context et calendrier générés
ssh octopulse@VPS "test -f ~/octopulse/team-workspace/{{name}}/references/{{name}}-context.md && echo OK"
ssh octopulse@VPS "test -f ~/octopulse/team-workspace/{{name}}/calendar/unified-calendar.md && echo OK"

# Patches docs
grep "{{display_name}}" ~/octopulse/CLAUDE.md
# Doit retourner exactement 1 match

# Agents créés listés dans KAIROS (si des crons ont été configurés)
kairos-ctl list | grep "{{name}}" || echo "Aucun cron KAIROS pour ce service (normal si pas configuré)"
```

Si une vérification échoue : rapporter l'erreur précise sans continuer les étapes de validation suivantes.

### Étape 10 — Output final

Afficher le résumé de complétion :

```
Service {{name}} bootstrappé

  Workspace  : ~/octopulse/team-workspace/{{name}}/
  Context    : references/{{name}}-context.md (squelette à remplir)
  Calendrier : calendar/unified-calendar.md (squelette)
  Patches    : CLAUDE.md + univile-context.md mis à jour
  Agents     : N agents créés (via create-agent chain)

Checklist post-création pour Marty :
1. [ ] Remplir {{name}}-context.md (chiffres, règles, KPIs, stakeholders)
2. [ ] Remplir calendar/unified-calendar.md
3. [ ] Créer les agents du service (si pas déjà fait) via `/octopulse:create-agent`
4. [ ] Définir les flux directs entre agents du service (patch communication-protocol)
5. [ ] Ajouter les crons KAIROS récurrents du service
6. [ ] Ajouter références métier dans `_references/<service>/` si besoin (docs externes)
```

</steps>

<examples>

### Exemple : bootstrap service Comptabilité

Input :

```yaml
name: comptabilite
display_name: Comptabilité
description: "Service comptabilité — traitement factures, paie, états financiers, relances impayés."
agents_initial:
  - name: compta-head
    model: claude-opus-4-6
    effort: high
    description_short: "Chef comptable — supervision, arbitrages, reporting Marty"
    role_long: "Tu es compta-head, responsable comptabilité. Tu supervises compta-factures et compta-paie, valides les écritures, produis les états mensuels."
    skills_initial:
      - {name: monthly-closing, description: "Clôture mensuelle"}
      - {name: weekly-cashflow, description: "Rapport cashflow hebdo"}
  - name: compta-factures
    model: claude-sonnet-4-6
    description_short: "Agent traitement factures"
    role_long: "Tu es compta-factures, tu traites les factures entrantes et sortantes."
    skills_initial:
      - {name: process-invoice, description: "Traite une facture PDF"}
kpis:
  - Délai moyen règlement clients
  - DSO (Days Sales Outstanding)
  - Taux erreur factures
  - Conformité TVA
budget_mensuel: null
ownership: Marty
```

Résultat attendu :

```
Service comptabilite bootstrappé

  Workspace  : ~/octopulse/team-workspace/comptabilite/
  Context    : references/comptabilite-context.md (squelette à remplir)
  Calendrier : calendar/unified-calendar.md (squelette)
  Patches    : CLAUDE.md + univile-context.md mis à jour
  Agents     : 2 agents créés (compta-head, compta-factures)

Checklist post-création pour Marty :
1. [ ] Remplir comptabilite-context.md (chiffres, règles, KPIs, stakeholders)
2. [ ] Remplir calendar/unified-calendar.md
3. [ ] Créer les agents du service (si pas déjà fait) via `/octopulse:create-agent`
4. [ ] Définir les flux directs entre agents du service (patch communication-protocol)
5. [ ] Ajouter les crons KAIROS récurrents du service
6. [ ] Ajouter références métier dans `_references/comptabilite/` si besoin (docs externes)
```

Ce que la skill a créé :
- `team-workspace/comptabilite/` avec toute la structure standard
- `references/comptabilite-context.md` avec KPIs listés et responsable Marty
- 2 agents créés via create-agent chain : `compta-head` (opus, effort high) + `compta-factures` (sonnet)
- Chaque agent a ses skills initiaux bootstrappés
- CLAUDE.md + univile-context.md patchés avec la ligne comptabilité

</examples>

<safety>
- NE PAS créer de service avec le même nom qu'un service existant (drift garanti) — vérification obligatoire étape 1
- NE PAS créer des agents du service en dehors de cette skill — toujours appeler `/octopulse:create-agent` avec `service=<name>`
- Les références métier sensibles (chiffres CA, taux, ratios internes) vont dans `team-workspace/<service>/references/` — JAMAIS dans le prompt des agents (qui serait loggé dans les sessions)
- Ne jamais patcher CLAUDE.md ou univile-context.md sans avoir lu leur contenu actuel d'abord (éviter doublons)
- La synchro VPS→Mac (étape 8) est à sens unique : VPS est la source de vérité
</safety>
