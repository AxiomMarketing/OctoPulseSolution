---
name: forge:production-pipeline
description: Pipeline 4 étapes séquentielles — strategist → art-director → copywriter → qc. Target 48h. Escalade si > 96h.
---

# Pipeline Production 4 étapes

## Quand l'utiliser
- Après acceptation brief (`forge:brief-intake`)
- Pour chaque créative à produire (y compris variantes winners)

## Entrées requises
- Brief accepté (BRF-YYYY-WXX-NN)
- Accès aux 4 sub-agents Forge
- Timeline : target 48h production, hard limit 96h

## Étapes

### Étape 1 — Strategist (0 → 12h)
- **Output** : concept + moodboard + direction narrative
- **Input** : brief + learnings + matrice P×A×F
- **Livrable** : `team-workspace/marketing/forge/concepts/BRF-*-concept.md`
- **Handoff** : vers art-director + copywriter

### Étape 2 — Art Director (12 → 30h) [parallèle copywriter]
- **Output** : visuel final (3 variantes hook)
- **Input** : concept strategist + assets produit
- **Livrable** : `forge/visuals/BRF-*-v1.png` (+ v2, v3)
- **Contraintes** : charte Univile, produit <1s, pas de cadre rouge/doré

### Étape 3 — Copywriter (12 → 30h) [parallèle art-director]
- **Output** : hook (≤40 chars), primary text (≤125 chars), CTA
- **Input** : concept strategist + persona + angle
- **Livrable** : `forge/copy/BRF-*-copy.md`
- **Contraintes** : voix Univile, pas hard-sell générique

### Étape 4 — QC (30 → 42h)
- **Checklist** : voir `forge:qc-checklist`
- **Pass 1** : validation charte + règles Coudac
- **Pass 2** : validation persona + angle cohérence
- **Si FAIL** : renvoi étape 2 ou 3 avec feedback précis
- **Si PASS** : livraison Atlas

### Étape 5 — Livraison (42 → 48h)
- Package : visuel + copy + metadata (BRF ID, hypothèse, persona, angle, format)
- Ad set cible (A/B/C)
- SendMessage → Atlas avec asset prêt
- CC Stratege + Sparky

## Gestion escalade

- **> 72h sans livraison** : alerte interne Forge, revue blockers
- **> 96h sans livraison** : escalade Stratege (ajustement scope ou deadline)
- **QC FAIL 3 fois** : escalade Stratege + revue du brief (peut-être mal cadré)

## Sortie
- Asset livré à Atlas
- Fichier `team-workspace/marketing/forge/delivered/BRF-YYYY-WXX-NN.md`
- Log timings pour KPI weekly-report

## Règles strictes
- **Séquence stricte** étapes 1 → 2/3 → 4 → 5 (pas de saut)
- **Jamais livrer** sans QC passé
- **Un brief = une passe** : si grosses modifs, nouveau brief (pas retouche ad hoc)
- **Pas de vidéo** (phase actuelle — règle Coudac)

## References
- Brief intake : `forge:brief-intake`
- QC checklist : `forge:qc-checklist`
- Sub-agents : `.claude/agents/subs/forge-*.md`
- Règles Coudac : `team-workspace/marketing/references/coudac-12-regles-details.md`
