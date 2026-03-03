#!/bin/bash
# =============================================================================
# setup-podman.sh — Configure Podman as Docker Desktop replacement in WSL
# Run once: bash setup-podman.sh
# =============================================================================

set -e

echo "🔧 Installing Podman..."
sudo apt-get update -q
sudo apt-get install -y -q podman podman-docker

echo ""
echo "🔌 Enabling Podman socket..."
systemctl --user enable --now podman.socket

PODMAN_SOCK="/run/user/$(id -u)/podman/podman.sock"

echo ""
echo "🔗 Setting DOCKER_HOST in ~/.bashrc..."
EXPORT_LINE="export DOCKER_HOST=unix://$PODMAN_SOCK"

if grep -q "DOCKER_HOST" ~/.bashrc; then
  echo "  DOCKER_HOST already set in ~/.bashrc — skipping"
else
  echo "" >> ~/.bashrc
  echo "# Podman as Docker replacement" >> ~/.bashrc
  echo "$EXPORT_LINE" >> ~/.bashrc
  echo "  Added to ~/.bashrc"
fi

export DOCKER_HOST="unix://$PODMAN_SOCK"

echo ""
echo "✅ Verifying Podman socket..."
if podman info > /dev/null 2>&1; then
  echo "  Podman is working!"
else
  echo "  ⚠️  Podman socket not responding — try: systemctl --user restart podman.socket"
fi

echo ""
echo "📋 VS Code settings.json — add these lines:"
echo ""
echo '  "dev.containers.dockerPath": "podman",'
echo "  \"dev.containers.dockerSocketPath\": \"$PODMAN_SOCK\""
echo ""
echo "🎉 Done! Restart your terminal, then open VS Code and reopen in container."
