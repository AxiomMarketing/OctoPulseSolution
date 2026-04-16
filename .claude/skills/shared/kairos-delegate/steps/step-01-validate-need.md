---
name: step-01-validate-need
description: Decision tree — KAIROS est-il le bon outil ? Sinon abort avec guidance
prev_step: steps/step-00-init.md
next_step: steps/step-02-collect-inputs.md
---

# Step 1: Valider le besoin (Decision Tree)

## MANDATORY EXECUTION RULES (READ FIRST):

- 🛑 NEVER skip le decision tree (c'est le garde-fou contre abuse KAIROS)
- 🛑 NEVER dire "utilise KAIROS" par défaut — souvent un autre outil est mieux
- ✅ ALWAYS appliquer les 5 questions du tree dans l'ordre
- ✅ ALWAYS rediriger vers le bon outil si KAIROS n'est pas approprié
- 📋 YOU ARE A DECISION GATE
- 💬 FOCUS sur : est-ce que KAIROS est le bon choix ?
- 🚫 FORBIDDEN de procéder si la réponse est "autre outil"

## EXECUTION PROTOCOLS:

- 🎯 Parcourir les 5 questions, stocker les réponses dans state
- 💾 Écrire `validation_result: proceed | abort_with_guidance` dans state JSON
- 📖 Si abort : produire message guidance clair pour le caller
- 🚫 FORBIDDEN de charger step-02 si validation_result != "proceed"

## CONTEXT BOUNDARIES:

- Variables disponibles : `{caller_agent}`, `{target_agent}`, `{prompt}`, `{priority}`
- Pas d'info business métier encore (ça arrive step-02)
- Le caller peut avoir mal jugé son besoin — on re-vérifie

## YOUR TASK:

Appliquer un decision tree de 5 questions pour valider que KAIROS est l'outil approprié. Si non, abort le workflow avec redirection vers le bon outil.

---

## EXECUTION SEQUENCE:

### Decision Tree (ordonné)

Parcourir les questions dans l'ordre. Dès qu'une réponse redirige vers un autre outil → abort.

**Q1. L'action est-elle immédiate ET que tu fais toi-même ?**
- Oui → **ABORT**. Tu n'as pas besoin de KAIROS. Fais-la directement dans ta session.
- Non → Q2

**Q2. L'action est-elle immédiate mais qu'un AUTRE agent doit faire, ET tu as besoin du résultat MAINTENANT (bloquant pour ton travail) ?**
- Oui → **ABORT**. Utilise le tool `Agent` directement (synchrone).
- Non → Q3

**Q3. L'action est-elle RÉCURRENTE (chaque jour, chaque lundi, chaque 1er du mois...) ?**
- Oui → **ABORT**. Pas un trigger ponctuel. Demande à Sparky d'ajouter un cron dans `~/octopulse/kairos/config.yml` (modification persistante, review humaine).
- Non → Q4

**Q4. Est-ce un événement FUTUR CONNU dans le calendrier métier (fête, campagne saisonnière, deadline) ?**
- Oui → **ABORT**. Édite `~/octopulse/team-workspace/<service>/references/calendrier-evenements.md` — KAIROS générera les alertes lead-time J-45/J-30/J-14 automatiquement.
- Non → Q5

**Q5. Est-ce une action PONCTUELLE, DIFFÉRÉE (heures/jours), CROSS-AGENT, NON-BLOQUANTE pour ton travail actuel ?**
- Oui → **PROCEED**. KAIROS est le bon outil.
- Non → **ABORT avec message "cas non couvert, clarifier l'intention"**.

### Implémentation

```python
import json, sys

state = json.load(open(state_file))
caller = state["caller_agent"]
target = state["target_agent"]
prompt = state["prompt"]
priority = state["priority"]

# Questions inférées depuis le contexte (l'agent invokes donc on suppose qu'il est passé à travers)
# Mais on valide explicitement via inputs ou inférence

# Heuristiques :
# - Si le caller a besoin du résultat dans la même session → Q2 devrait dire oui → abort
# - Si priority=critical → normalement Q5 (ponctuel urgent non-bloquant)
# - Si target_agent = caller_agent → Q1 oui → abort (self-trigger Pattern 4.1)

# Check Q1 : self-trigger = Pattern 4.1
if target == caller:
    state["validation_result"] = "abort_with_guidance"
    state["abort_reason"] = "self_trigger"
    state["abort_guidance"] = f"{caller} ne peut pas se trigger soi-même (Pattern Sentinel 4.1 Répétition). Fais l'action directement."
    json.dump(state, open(state_file, "w"), indent=2)
    sys.exit(1)

# Check Q3 : patterns cron-ish dans le prompt
cron_keywords = ["chaque jour", "chaque lundi", "quotidien", "hebdo", "mensuel", "tous les", "every day", "weekly"]
if any(kw in prompt.lower() for kw in cron_keywords):
    state["validation_result"] = "abort_with_guidance"
    state["abort_reason"] = "should_be_cron"
    state["abort_guidance"] = f"Cette action semble récurrente. Demande à Sparky d'ajouter un cron dans kairos/config.yml au lieu d'un trigger réactif."
    json.dump(state, open(state_file, "w"), indent=2)
    sys.exit(1)

# Check Q4 : event calendaire dans le prompt
event_keywords = ["fête des mères", "black friday", "noël", "saint-valentin", "event du ", "dans 45j", "dans 30j"]
if any(kw in prompt.lower() for kw in event_keywords):
    state["validation_result"] = "abort_with_guidance"
    state["abort_reason"] = "should_be_calendar"
    state["abort_guidance"] = f"Action liée à un événement calendaire. Édite calendrier-evenements.md — KAIROS générera les alertes J-X automatiquement."
    json.dump(state, open(state_file, "w"), indent=2)
    sys.exit(1)

# Sinon : proceed
state["validation_result"] = "proceed"
state["stepsCompleted"].append(1)
json.dump(state, open(state_file, "w"), indent=2)
print("PROCEED: KAIROS approprié")
```

### Si abort

Afficher au caller :
```
❌ KAIROS pas approprié pour cette action.

Raison : {abort_reason}
Guidance : {abort_guidance}

Pas de trigger déposé. Utilise le bon outil.
```

Puis exit le workflow (ne pas charger step-02).

---

## SUCCESS METRICS:

✅ Decision tree parcouru dans l'ordre
✅ `validation_result` écrit dans state (proceed | abort_with_guidance)
✅ Si abort : raison + guidance claire fournies au caller
✅ Si proceed : step-02 chargé

## FAILURE MODES:

❌ Skip du decision tree → agents utilisent KAIROS pour tout, inflation triggers, Sentinel Pattern 4.9
❌ Détection faible (tous les prompts passent) → pas de garde-fou effective
❌ Détection trop agressive (faux positifs bloquent des vrais cas) → agent frustré → contourne le skill
❌ Ne pas écrire `abort_guidance` → caller ne sait pas quoi faire

## VALIDATION PROTOCOLS:

- Les 5 questions sont en ordre : Q1 court-circuite Q2, etc.
- Self-trigger = auto-abort (jamais légitime)
- Keywords cron/event = heuristique rapide, pas parfaite (l'agent peut override si sûr)
- Guidance = actionable, pas juste "non"

---

## NEXT STEP:

Si `validation_result == "proceed"` → load `./step-02-collect-inputs.md`
Sinon → workflow terminé avec message d'abort.

<critical>
Remember: ce step est le filtre anti-abuse. Un KAIROS pour tout = pas de KAIROS. Mieux vaut refuser un cas limite que laisser passer 10 abus.
</critical>
