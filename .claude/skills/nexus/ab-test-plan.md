---
name: nexus:ab-test-plan
description: Format plan A/B test standardisé — hypothèse, variants, metrics, duration, sample size, stop criteria. Template réutilisable.
---

# Plan A/B Test Standardisé

## Quand l'utiliser
- Préparation de tout test CRO (`nexus:cro-testing`)
- Template pour documenter tests avant lancement
- Partage avec Stratege/Funnel si test impacte cross-canal

## Template complet

```markdown
# TST-YYYY-NN — [titre court]

## Contexte
**Observation** : [friction / opportunité détectée]
**Source** : [audit tunnel / GA4 / Atlas signal / Fairing]
**Data baseline** :
- CVR actuel : X%
- Volume visiteurs/sem : Y
- AOV : Z€

## Hypothèse
**"Si on [change X], alors [métrique Y] +Z% car [rationnel]"**

Rationnel détaillé : [2-3 phrases]

## Variants

### Variant A (Control)
- [description actuelle]
- Screenshot / URL

### Variant B (Challenger)
- [description du changement — **1 seule variable**]
- Screenshot mockup
- Effort dev : X heures

## Métriques

### Primaire
- **CVR checkout completion** (target : +10% relatif)

### Secondaires
- AOV (doit rester stable ou augmenter)
- Time on page
- Bounce rate
- Revenue per visitor (RPV)

### Guardrails
- Si variant B fait chuter AOV > 15% → kill même si CVR OK

## Sample Size

- MDE : +10% relatif
- Power : 80%
- Significance : 95%
- **Sample requis par variant** : X visiteurs (calculé via calculator)
- Trafic hebdo estimé : Y visiteurs
- **Duration estimée** : Z semaines

## Durée

- **Min** : 2 semaines
- **Max** : 4 semaines
- **Cycles hebdo complets** (jamais couper un lundi)

## Audience

- 100% du trafic pertinent (ou subset si pertinent, ex. mobile only)
- Split 50/50
- Exclure : traffic interne, bots, referrals suspects

## Stop Criteria

- ✅ Sample size atteint ET significance > 95% → conclure
- ❌ Sample size atteint, pas de significance → inconclusif
- 🛑 Variant B catastrophique (CVR -20% sig après 48h stable) → kill

## Coordination

- [ ] Stratege informé (si impact attribution paid)
- [ ] Funnel informé (cross-check data)
- [ ] Keeper informé (si impact post-purchase)
- [ ] Validation charte Univile (si changement visuel)
- [ ] Validation Marty (si refonte > page unique)

## Planning

- Lancement : YYYY-MM-DD
- Check mi-parcours : YYYY-MM-DD
- Fin prévue : YYYY-MM-DD
- Conclusion attendue : YYYY-MM-DD

## Responsable

- Nexus (pilotage)
- Dev/CMS : [qui implémente]
- Sub-agent involved : [si applicable]
```

## Étapes d'utilisation

1. **Dupliquer ce template** pour chaque nouveau test
2. **Remplir TOUTES les sections** avant lancement (sinon test mal cadré)
3. **Validation Nexus** puis Stratege/Marty si impact cross-canal
4. **Logger** : `team-workspace/marketing/nexus/tests/TST-YYYY-NN.md`
5. **Lancement** uniquement après plan complet
6. **Conclusion** : remplir section résultat + encoder learning

## Règles strictes
- **Jamais lancer** sans plan complet
- **1 variable par test**
- **Sample size calculé** à l'avance (pas à l'arrache)
- **Stop criteria définis avant** lancement (pas après pour justifier)
- **Coordination** cross-Master obligatoire si impact hors tunnel

## References
- CRO testing : `nexus:cro-testing`
- Audit : `nexus:tunnel-audit`
- Landing opt : `nexus:landing-optimization`
