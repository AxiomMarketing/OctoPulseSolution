---
name: forge:qc-checklist
description: Checklist QC Forge finale avant livraison Atlas — 24 points sur 8 blocs. 2 passes obligatoires.
---

# QC Checklist Finale

## Quand l'utiliser
- Étape 4 du pipeline `forge:production-pipeline`
- Avant TOUTE livraison à Atlas (aucune exception)

## Entrées requises
- Asset visuel final
- Copy final (hook + primary text + CTA)
- Brief source (BRF-YYYY-WXX-NN)
- Persona + angle + format ciblés

## Checklist (24 points, 8 blocs)

### 1. Charte graphique (3 points)
- [ ] AUCUN cadre rouge (anti-drift de marque)
- [ ] AUCUN cadre doré (anti-drift)
- [ ] Palette Univile respectée (#001f4d / #c75146 / #2E6B4F / blanc galerie)

### 2. Produit visible (3 points)
- [ ] Produit visible dès la 1ère seconde (règle Coudac #9)
- [ ] Pas de teasing narratif
- [ ] Produit = centre de composition OU minimum 40% de surface

### 3. Mobile readability (3 points)
- [ ] Texte lisible mobile (police ≥ 24pt équivalent)
- [ ] Contraste AA minimum
- [ ] Aucun détail critique sous safe zone Instagram

### 4. Copy (3 points)
- [ ] Primary text ≤ 125 chars (sinon coupé sur feed)
- [ ] Hook ≤ 40 chars, first-line grabs attention
- [ ] CTA clair et unique (pas de double CTA)

### 5. Persona cohérence (3 points)
- [ ] Visuel correspond à Marie / Julien / Christiane (âge, ethnie, style de vie)
- [ ] Ton du copy correspond au persona
- [ ] Bénéfice mis en avant = celui du persona, pas générique

### 6. Coudac compliance (3 points)
- [ ] Pas de vidéo (phase actuelle)
- [ ] Pas de retargeting (phase actuelle)
- [ ] Angle déclaré = angle effectivement incarné (pas de drift angle)

### 7. V2 readiness (3 points)
- [ ] Variante hook prête (rotation frequency)
- [ ] Variante visuel prête (si saturation à J+7)
- [ ] Variante copy prête

### 8. Traçabilité (3 points)
- [ ] Metadata BRF ID + hypothèse + persona + angle + format inclus
- [ ] Ad set cible spécifié (A Broad / B LAL / C Test)
- [ ] Source inspiration (si winner organique réutilisé ou variant d'un winner)

## Passes QC

### Pass 1 (20min) — compliance technique
Tous points blocs 1-4 doivent être ✅

### Pass 2 (30min) — cohérence stratégique
Tous points blocs 5-8 doivent être ✅

### Verdict
- **24/24** → PASS, livraison Atlas
- **22-23/24** → ajustement mineur si point non-bloquant
- **< 22/24** → FAIL, retour art-director ou copywriter avec feedback précis

## Sortie
- Checklist signée dans `team-workspace/marketing/forge/qc/BRF-*-qc.md`
- Si PASS : livraison Atlas via `forge:production-pipeline` étape 5
- Si FAIL : retour + motif + 1 seul cycle de retake autorisé

## Règles strictes
- **Aucun bypass** possible (même pressure Stratege)
- **2 passes obligatoires**, pas 1
- **Traçabilité** : toujours conserver la checklist signée
- **Si FAIL 3 fois** même brief → escalade Stratege (brief mal cadré)

## References
- Pipeline : `forge:production-pipeline`
- Charte : `team-workspace/marketing/references/` (palette définie projet_univile)
- Règles Coudac : `team-workspace/marketing/references/coudac-12-regles-details.md`
- Sub-agent QC : `.claude/agents/subs/forge-qc.md`
