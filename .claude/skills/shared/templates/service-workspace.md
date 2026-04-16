# Structure team-workspace d'un service OctoPulse

Quand un nouveau service métier est créé via `/octopulse:create-service`, le bootstrap crée :

```
team-workspace/<service>/
├── briefs/
│   ├── inbox/              # Missions en attente (SPK-YYYY-MM-DD-NNN.md)
│   └── done/               # Missions complétées
├── reports/
│   ├── sparky-consolidations/  # Consolidations quotidiennes Sparky
│   ├── <agent>-daily/           # Rapports quotidiens par agent master
│   ├── <agent>-weekly/          # Rapports hebdo
│   └── <agent>-monthly/         # Rapports mensuels
├── calendar/
│   └── unified-calendar.md     # Calendrier unifié du service
├── decisions/
│   └── YYYY-MM-DD.md            # Log décisions Marty pour ce service
├── references/
│   ├── <service>-context.md    # Contexte métier (chiffres, règles, vocab)
│   ├── personas.md              # Si applicable (clients, fournisseurs, etc.)
│   └── kpis.md                  # KPIs suivis
└── assets/                      # Ressources binaires (images, PDFs, etc.)
```

## Règles

- Chaque service a son propre namespace sous `team-workspace/`
- Les agents du service écrivent dans leur propre sous-dossier reports/
- Sparky consolide cross-service si mission transversale
- Les `references/` sont maintenues par le service lui-même
