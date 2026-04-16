# Trail of Bits Hardening — Couche 2

Source: https://github.com/trailofbits/claude-code-config (cloned 2026-04-15)

## Patterns kept (appliques dans ~/.claude/settings.json)

### Deny rules integrees depuis ToB settings.json
- `Bash(rm -rf *)` — suppression recursive globale
- `Bash(rm -fr *)` — variante flag order
- `Bash(mkfs *)` — formatage filesystem
- `Bash(dd *)` — ecriture raw device (elargi depuis `dd if=* of=/dev/sd*`)
- `Bash(wget *|bash*)` et `Bash(wget *| bash*)` — pipe download-to-shell (injection remote)
- `Bash(git push --force*)` — force push generique
- `Bash(git push *--force*)` — variante flag order
- `Bash(git reset --hard*)` — reset destructif
- `Edit(~/.ssh/**)` — protection ecriture cles SSH
- `Read(~/.ssh/**)` — protection lecture cles SSH
- `Read(~/.gnupg/**)` — cles GPG
- `Read(~/.aws/**)` — credentials AWS
- `Read(~/.azure/**)` — credentials Azure
- `Read(~/.config/gh/**)` — tokens GitHub CLI
- `Read(~/.git-credentials)` — credentials git stockes
- `Read(~/.docker/config.json)` — registry tokens Docker
- `Read(~/.kube/**)` — kubeconfig Kubernetes

### Deny rules custom OctoPulse (ajoutees en sus de ToB)
- `Bash(rm -rf /*)` — suppression racine systeme
- `Bash(rm -rf ~)` — suppression home
- `Bash(rm -rf $HOME)` — idem via variable
- `Bash(:(){ :|:& };:)` — fork bomb
- `Bash(dd if=* of=/dev/sd*)` — ecriture disque ciblee (version specifique)
- `Bash(mkfs.*)` — formatage avec dot-wildcard
- `Bash(chmod -R 000 /)` — suppression permissions root
- `Bash(git push --force origin main)` — force push main
- `Bash(git push --force origin master)` — force push master
- `Bash(DROP DATABASE*)` — destruction DB SQL
- `Bash(DROP TABLE octopulse*)` — destruction tables OctoPulse

### Hook PreToolUse (pattern ToB — NON integre, voir ci-dessous)
ToB utilise un hook PreToolUse Bash inline qui detecte les commandes dangereuses via regex sur le JSON stdin.

## Patterns skipped + raisons

| Pattern | Raison |
|---------|--------|
| `Bash(sudo *)` | VPS OctoPulse necessite sudo pour certaines operations systeme agents (apt, systemctl). Couvert partiellement par les deny regles specifiques. |
| Hook PreToolUse regex inline | Pattern trop verbeux (commande shell inline dans JSON), maintenance difficile. Les deny rules couvrent les cas les plus critiques sans hook supplementaire. |
| Read credential patterns macOS (Keychains, MetaMask, etc.) | Specifiques macOS, non pertinents sur VPS Ubuntu. |
| `Read(~/.npmrc)`, `Read(~/.pypirc)`, etc. | Non pertinents pour le workflow OctoPulse actuel — agents n'ont pas besoin d'acces publish npm/pypi. Peut etre ajoute si needed. |
| StatusLine hook | Feature UI optionnelle, pas de valeur securite directe. |
