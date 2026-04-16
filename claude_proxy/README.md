# Claude Proxy Transparent

Proxy local qui gère automatiquement le fallback entre deux tokens Anthropic en cas de rate limit (429).
Installé sur chaque machine individuellement, il tourne en tâche de fond au démarrage du Mac.

Les tokens API sont stockés dans le **Trousseau macOS** (Keychain) -- aucun secret en clair dans les fichiers.

---

## Prérequis

- macOS
- Python 3 (préinstallé sur Mac)
- Un abonnement Claude avec deux tokens API

---

## Installation

### 1. Créer le projet

```bash
mkdir ~/claude_proxy
cd ~/claude_proxy
```

### 2. Créer et activer l'environnement virtuel

```bash
python3 -m venv venv
source venv/bin/activate
```

### 3. Installer les dépendances

```bash
pip install fastapi uvicorn httpx
```

### 4. Créer le fichier proxy

Placez le fichier `proxy_transparent.py` dans `~/claude_proxy/`.

### 5. Stocker les tokens dans le Trousseau macOS

```bash
security add-generic-password -s claude-proxy -a token-principal -w 'sk-ant-votre-token-principal'
security add-generic-password -s claude-proxy -a token-fallback -w 'sk-ant-votre-token-fallback'
```

Pour vérifier qu'ils sont bien enregistrés :

```bash
security find-generic-password -s claude-proxy -a token-principal -w
security find-generic-password -s claude-proxy -a token-fallback -w
```

> Les tokens sont protégés par le mot de passe de session de l'utilisateur. Ils ne sont visibles dans aucun fichier du projet.

### 6. Configurer le terminal pour utiliser le proxy

```bash
nano ~/.zshrc
```

Ajoutez cette ligne tout à la fin du fichier :

```bash
export ANTHROPIC_BASE_URL="http://127.0.0.1:4000"
```

Sauvegardez (`Ctrl + O`, `Entrée`, `Ctrl + X`), puis appliquez :

```bash
source ~/.zshrc
```

---

## Lancement manuel (pour tester)

```bash
cd ~/claude_proxy
source venv/bin/activate
python proxy_transparent.py
```

Le proxy écoute sur `http://127.0.0.1:4000`.
Ouvrez un autre terminal et lancez `cc` pour utiliser Claude Code.

---

## Lancement automatique au démarrage du Mac

### 1. Créer le service launchd

```bash
nano ~/Library/LaunchAgents/com.claude.proxy.plist
```

Collez ce contenu **en remplaçant `admin` par le nom d'utilisateur de la machine** :

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.claude.proxy</string>

    <key>ProgramArguments</key>
    <array>
        <string>/Users/admin/claude_proxy/venv/bin/python</string>
        <string>/Users/admin/claude_proxy/proxy_transparent.py</string>
    </array>

    <key>RunAtLoad</key>
    <true/>

    <key>KeepAlive</key>
    <true/>

    <key>StandardOutPath</key>
    <string>/Users/admin/Library/Logs/claude_proxy.log</string>
    <key>StandardErrorPath</key>
    <string>/Users/admin/Library/Logs/claude_proxy_error.log</string>
</dict>
</plist>
```

Sauvegardez (`Ctrl + O`, `Entrée`, `Ctrl + X`).

> **Note** : Aucun token dans ce fichier. Le script Python les récupère directement depuis le Trousseau macOS au démarrage.

### 2. Activer le service

```bash
launchctl load ~/Library/LaunchAgents/com.claude.proxy.plist
```

C'est terminé. Le proxy se lance automatiquement à chaque démarrage du Mac.

---

## Commandes utiles

| Action | Commande |
|--------|----------|
| Voir les logs en temps réel | `tail -f ~/Library/Logs/claude_proxy.log` |
| Voir les erreurs | `tail -f ~/Library/Logs/claude_proxy_error.log` |
| Arrêter le service | `launchctl unload ~/Library/LaunchAgents/com.claude.proxy.plist` |
| Redémarrer le service | `launchctl unload ~/Library/LaunchAgents/com.claude.proxy.plist && launchctl load ~/Library/LaunchAgents/com.claude.proxy.plist` |
| Vérifier si le proxy tourne | `curl -s http://127.0.0.1:4000 && echo "OK"` |

---

## Dépannage

### Le proxy ne démarre pas

Recréez l'environnement virtuel :

```bash
cd ~/claude_proxy
rm -rf venv
python3 -m venv venv
source venv/bin/activate
pip install fastapi uvicorn httpx
```

### Erreur "Tokens introuvables"

Vérifiez que les tokens sont dans le Trousseau :

```bash
security find-generic-password -s claude-proxy -a token-principal -w
security find-generic-password -s claude-proxy -a token-fallback -w
```

Si ça ne retourne rien, réajoutez-les (voir étape 5 de l'installation).

### Changer les tokens

1. Supprimez les anciens :
   ```bash
   security delete-generic-password -s claude-proxy -a token-principal
   security delete-generic-password -s claude-proxy -a token-fallback
   ```
2. Ajoutez les nouveaux :
   ```bash
   security add-generic-password -s claude-proxy -a token-principal -w 'nouveau-token'
   security add-generic-password -s claude-proxy -a token-fallback -w 'nouveau-token'
   ```
3. Redémarrez le service :
   ```bash
   launchctl unload ~/Library/LaunchAgents/com.claude.proxy.plist
   launchctl load ~/Library/LaunchAgents/com.claude.proxy.plist
   ```

---

## Déploiement sur une autre machine

1. Copiez `proxy_transparent.py` sur la machine cible dans `~/claude_proxy/`
2. Suivez les étapes d'installation ci-dessus
3. Remplacez `admin` par le nom d'utilisateur local dans le `.plist`
4. Stockez les tokens dans le Trousseau de la machine
