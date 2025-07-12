#!/bin/bash
set -e

echo "=== WuWa-FPS Installer ==="
echo

if ! command -v sqlite3 &> /dev/null; then
    echo "Error: sqlite3 is required but not installed."
    echo "Please install it first:"
    echo "  Ubuntu/Debian: sudo apt install sqlite3"
    echo "  Arch: sudo pacman -S sqlite"
    echo "  Fedora: sudo dnf install sqlite"
    exit 1
fi

STEAM_ROOT=""
if [ -d "$HOME/.local/share/Steam" ]; then
    STEAM_ROOT="$HOME/.local/share/Steam"
elif [ -d "$HOME/.steam" ]; then
    STEAM_ROOT="$HOME/.steam"
else
    echo "Error: Could not find Steam installation directory."
    echo "Please make sure Steam is installed."
    exit 1
fi

WUWA_DIR="$STEAM_ROOT/steamapps/common/Wuthering Waves"
if [ ! -d "$WUWA_DIR" ]; then
    echo "Error: Wuthering Waves not found in Steam library."
    echo "Expected location: $WUWA_DIR"
    echo "Please install Wuthering Waves through Steam first."
    exit 1
fi

echo "Found Wuthering Waves at: $WUWA_DIR"

SCRIPT_DIR="$HOME/.local/bin"
SCRIPT_PATH="$SCRIPT_DIR/wuwa-fps.sh"

mkdir -p "$SCRIPT_DIR"

cat > "$SCRIPT_PATH" << 'EOF'
#!/bin/bash
# This script was generated with https://github.com/hireri/wuwa-fps
# It sets CustomFrameRate to 120 before launching the game

if [ "$1" = "--rm" ]; then
    echo "=== Uninstalling Wuwa-FPS ==="
    echo
    
    # Drop the trigger
    if [ -f "$DB_PATH" ]; then
        sqlite3 "$DB_PATH" "
        DROP TRIGGER IF EXISTS prevent_custom_frame_rate_update;
        UPDATE LocalStorage SET value = 60 WHERE key = 'CustomFrameRate';
        " 2>/dev/null || true
        echo "✓ Reset to 60 FPS"
    fi

    # Remove this script
    SCRIPT_PATH="$HOME/.local/bin/wuwa-fps.sh"
    if [ -f "$SCRIPT_PATH" ]; then
        rm "$SCRIPT_PATH"
        echo "✓ Removed script: $SCRIPT_PATH"
    fi
    
    # Clean up PATH from .bashrc
    if [ -f "$HOME/.bashrc" ]; then
        sed -i '/export PATH=.*\.local\/bin.*PATH/d' "$HOME/.bashrc"
        echo "✓ Cleaned PATH from .bashrc"
    fi
    
    echo
    echo "Manual step required:"
    echo "1. In Steam, right-click Wuthering Waves → Properties"
    echo "2. Clear the Launch Options field"
    echo
    echo "Uninstall complete!"
    exit 0
fi

DB_PATH="$HOME/.local/share/Steam/steamapps/common/Wuthering Waves/Client/Saved/LocalStorage/LocalStorage.db"

if [ -f "$DB_PATH" ]; then
    if sqlite3 "$DB_PATH" "
    DROP TRIGGER IF EXISTS prevent_custom_frame_rate_update;
    CREATE TRIGGER prevent_custom_frame_rate_update
    AFTER UPDATE OF value ON LocalStorage
    WHEN NEW.key = 'CustomFrameRate'
    BEGIN
        UPDATE LocalStorage SET value = 120 WHERE key = 'CustomFrameRate';
    END;
    INSERT OR REPLACE INTO LocalStorage (key, value) VALUES ('CustomFrameRate', 120);
    " 2>/dev/null; then
        echo "✓ FPS setting updated with persistent trigger"
    else
        echo "⚠ Could not update FPS setting (game may be running)"
    fi
fi
EOF

chmod +x "$SCRIPT_PATH"

echo "✓ Created FPS script at: $SCRIPT_PATH"

if [[ ":$PATH:" != *":$SCRIPT_DIR:"* ]]; then
    echo "Adding $SCRIPT_DIR to PATH..."
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    echo "✓ Added to PATH (restart terminal or run: source ~/.bashrc)"
fi

echo
echo "=== Installation Complete! ==="
echo
echo "To use:"
echo "1. In Steam, right-click Wuthering Waves → Properties"
echo "2. In Launch Options, enter:"
echo "   $SCRIPT_PATH && %command%"
echo
echo "Alternative: You can also run 'wuwa-fps.sh' manually before starting the game"
echo
echo "The script will automatically set your frame rate to 120fps before each launch!"