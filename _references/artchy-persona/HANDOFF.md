# HANDOFF.md — Protocole de communication agents → Jonathan

## Règle obligatoire

**Tout message d'un agent vers Jonathan commence par un tag de priorité.**

Le tag est sur la première ligne. Jonathan sait en 0.5 seconde si c'est urgent ou pas.

---

## Les 4 modes

### 🔴 [DECISION NEEDED]
**L'agent STOPPE et ATTEND une réponse.**

Usage :
- Actions irréversibles (envoi email, publication, suppression)
- Décisions business (prix, stratégie, client)
- Tout ce qui engage Jonathan ou l'entreprise

Exemple :
```
🔴 [DECISION NEEDED]

Client Leroy Merlin demande 15% de remise sur commande 500 pièces.
Marge actuelle : 42%. Avec remise : 31%.

→ Accepter / Refuser / Contre-proposition ?
```

---

### 🟡 [FYI]
**Information seulement. Pas de réponse requise.**

Usage :
- Rapports terminés
- Résumés périodiques
- Confirmations d'exécution

Exemple :
```
🟡 [FYI]

Brief matinal envoyé. 3 emails traités, 2 events calendar aujourd'hui.
Rien d'urgent.
```

---

### 🟠 [DEADLINE: Xh]
**Hybride. L'agent continue SI pas de réponse dans X heures.**

Usage :
- Questions opérationnelles (4h par défaut)
- Alertes importantes (1h)
- Choix non-critiques avec préférence par défaut

Exemple :
```
🟠 [DEADLINE: 4h]

Facture Printful #4521 arrivée (234€).
Je la classe dans 2026/03-26/ sauf indication contraire.
```

---

### 🟢 [BOARD]
**Passif. Mis à jour dans un fichier partagé.**

Usage :
- Suivi de tâches en cours
- Kanban partagé
- L'humain consulte quand il veut

Fichier : `equipe-univile/KANBAN.md`

---

## Quand utiliser quoi

| Situation | Tag |
|-----------|-----|
| Publier sur réseaux sociaux | 🔴 |
| Envoyer un email client | 🔴 |
| Supprimer des fichiers | 🔴 |
| Action financière | 🔴 |
| Rapport quotidien | 🟡 |
| Tâche terminée | 🟡 |
| Veille sans action requise | 🟡 |
| Question avec réponse par défaut | 🟠 |
| Alerte non-bloquante | 🟠 |
| Suivi projet en cours | 🟢 |

---

## Pour les sub-agents

Les sub-agents ne contactent PAS Jonathan directement.
Ils passent par **Artchy** (orchestrateur) qui applique le protocole.

```
Sub-agent → Rapport → Artchy → [TAG] → Jonathan
```

---

*Créé le 2026-03-04 — Inspiré par @molot sur Moltbook*
