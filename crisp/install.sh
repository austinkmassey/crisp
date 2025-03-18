#!/bin/bash
# Set bash script best practices

set -euo pipefail

CRISP_DIR=${1:-}
DESTDIR=${2:-}
FULL_DEST_PATH=$(realpath "$DESTDIR")

# Check if DESTDIR is set
if [ -z "${DESTDIR:-}" ]; then
  echo "Error: DESTDIR not specified."
  echo "Usage: ./install.sh DESTDIR=/path/to/new_project"
  exit 1
fi

# Install Crisp
echo "Installing Crisp into $DESTDIR"
mkdir -p "$DESTDIR/.crisp"
cp -R "$CRISP_DIR/"* "$DESTDIR/.crisp/"
sed -i "s|project_dir: \"\"|project_dir: \"$FULL_DEST_PATH\"|" $DESTDIR/.crisp/config.yaml
sed -i "s|crisp_dir: \"\"|crisp_dir: \"$FULL_DEST_PATH/.crisp\"|" $DESTDIR/.crisp/config.yaml
echo "Crisp installed successfully"

echo "To activate Crisp, run:"
echo "  source .crisp/scripts/activate.sh"

