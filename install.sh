#!/bin/bash

# Resource Monitor - Easy Installer/Updater
# Fork maintained by Lusan Sapkota | Original project by Ory0n

EXT_ID="Resource_Monitor@Ory0n"
DEST_DIR="$HOME/.local/share/gnome-shell/extensions/$EXT_ID"
SRC_DIR="Resource_Monitor@Ory0n"

echo "------------------------------------------"
echo "Resource Monitor Installer/Updater"
echo "Fork by Lusan Sapkota (Patched)"
echo "Original creator: Ory0n (Appreciated!)"
echo "------------------------------------------"

# Ensure the extensions directory exists
mkdir -p "$HOME/.local/share/gnome-shell/extensions"

# Check if we are in a git repository
if [ -d ".git" ]; then
    echo "Updating local repository..."
    git pull --quiet
fi

# Check if we are in the correct directory
if [ ! -d "$SRC_DIR" ]; then
    echo "Error: Please run this script from the root of the Resource_Monitor repository."
    exit 1
fi

# Detect if the extension is currently enabled
IS_ENABLED=false
if gnome-extensions list --enabled | grep -q "$EXT_ID"; then
    IS_ENABLED=true
    echo "Detected that the extension is currently enabled. Disabling for update..."
    gnome-extensions disable "$EXT_ID"
    sleep 1
fi

echo "Installing extension to $DEST_DIR ..."
rm -rf "$DEST_DIR" # Clean old install
cp -rf "$SRC_DIR" "$HOME/.local/share/gnome-shell/extensions/"

# Compile schemas
if [ -d "$DEST_DIR/schemas" ]; then
    echo "Compiling GSettings schemas..."
    glib-compile-schemas "$DEST_DIR/schemas/"
fi

# Try to trigger a refresh of the extensions list (best effort)
AUTO_ENABLED=false
if command -v dbus-send >/dev/null; then
    echo "Attempting to refresh GNOME extensions list via D-Bus..."
    dbus-send --type=method_call --dest=org.gnome.Shell /org/gnome/Shell org.gnome.Shell.Extensions.InstallRemoteExtension string 'dummy' >/dev/null 2>&1
    
    # Wait a moment for GNOME to process the refresh
    sleep 2
    
    echo "Attempting to enable extension..."
    if gnome-extensions enable "$EXT_ID" 2>/dev/null; then
        echo "Extension enabled successfully!"
        AUTO_ENABLED=true
    else
        echo "Note: Extension could not be enabled automatically yet (this is normal if GNOME needs a logout/restart)."
        AUTO_ENABLED=false
    fi
fi

echo "------------------------------------------"
echo "SUCCESS: Extension setup completed."
echo "------------------------------------------"

if [ "$AUTO_ENABLED" = false ]; then
    echo ""
    echo "IF THE EXTENSION IS NOT SHOWING:"
    echo ""
    echo "1. Restart GNOME Shell / Logout:"
    echo "   - Wayland: Log out and log back in."
    echo "   - X11: Press Alt+F2, type 'r', and press Enter."
    echo ""
    echo "2. Enable manually (if not already enabled):"
    echo "   gnome-extensions enable $EXT_ID"
    echo "------------------------------------------"
else
    echo ""
    echo "The extension is now active!"
    echo "If you don't see the new features, a logout/restart is still recommended."
    echo "------------------------------------------"
fi
