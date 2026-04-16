#!/bin/bash
# KAIROS install/update script.
# Idempotent: safe to re-run after updates.
set -e

KAIROS_DIR="$HOME/octopulse/kairos"
cd "$KAIROS_DIR"

# 1. Ensure venv + deps
if [ ! -d venv ]; then
  python3 -m venv venv
fi
./venv/bin/pip install --quiet --upgrade pip
./venv/bin/pip install --quiet -r requirements.txt

# 2. Install systemd user unit
UNIT_DIR="$HOME/.config/systemd/user"
mkdir -p "$UNIT_DIR"
cp -f systemd/kairos.service "$UNIT_DIR/kairos.service"
systemctl --user daemon-reload

# 3. Enable linger for 24/7 run without login
if ! loginctl show-user "$USER" | grep -q "Linger=yes"; then
  echo "Note: enabling linger requires sudo. Run: sudo loginctl enable-linger $USER"
fi

# 4. Enable service on boot (not started yet — do that manually or via T12)
systemctl --user enable kairos.service

# 5. Add kairos-ctl alias to .bashrc if missing
if ! grep -q "alias kairos-ctl=" "$HOME/.bashrc"; then
  echo "alias kairos-ctl=\"$KAIROS_DIR/kairos-ctl\"" >> "$HOME/.bashrc"
fi

echo "[ok] KAIROS installé."
echo "  Activer: systemctl --user start kairos.service"
echo "  Statut:  ./kairos-ctl status"
echo "  Logs:    journalctl --user-unit=kairos.service -f"
