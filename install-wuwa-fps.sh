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
# It sets CustomFrameRate to 120 and applies necessary game settings before launching

if [ "$1" = "--rm" ]; then
    echo "=== Uninstalling Wuwa-FPS ==="
    echo
    
    DB_PATH="$HOME/.local/share/Steam/steamapps/common/Wuthering Waves/Client/Saved/LocalStorage/LocalStorage.db"
    CONFIG_PATH="$HOME/.local/share/Steam/steamapps/common/Wuthering Waves/Client/Saved/Config/WindowsNoEditor/GameUserSettings.ini"
    
    # Drop the trigger and reset settings
    if [ -f "$DB_PATH" ]; then
        sqlite3 "$DB_PATH" "
        DROP TRIGGER IF EXISTS prevent_custom_frame_rate_update;
        UPDATE LocalStorage SET value = 2 WHERE key = 'CustomFrameRate';
        DELETE FROM LocalStorage WHERE key IN ('MenuData', 'PlayMenuInfo');
        " 2>/dev/null || true
        echo "✓ Reset to 60 FPS and cleared custom settings"
    fi
    
    # Reset config file
    if [ -f "$CONFIG_PATH" ]; then
        sed -i 's/FrameRateLimit=120/FrameRateLimit=60/' "$CONFIG_PATH" 2>/dev/null || true
        echo "✓ Reset config file frame rate limit"
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
CONFIG_PATH="$HOME/.local/share/Steam/steamapps/common/Wuthering Waves/Client/Saved/Config/WindowsNoEditor/GameUserSettings.ini"

if [ -f "$DB_PATH" ]; then
    # Create MenuData JSON (matches Python version exactly)
    MENU_DATA='{"___MetaType___": "___Map___", "Content": [[1, 100], [2, 100], [3, 100], [4, 100], [5, 0], [6, 0], [7, -0.4658685302734375], [10, 3], [11, 3], [20, 0], [21, 0], [22, 0], [23, 0], [24, 0], [25, 0], [26, 0], [27, 0], [28, 0], [29, 0], [30, 0], [31, 0], [32, 0], [33, 0], [34, 0], [35, 0], [36, 0], [37, 0], [38, 0], [39, 0], [40, 0], [41, 0], [42, 0], [43, 0], [44, 0], [45, 0], [46, 0], [47, 0], [48, 0], [49, 0], [50, 0], [51, 1], [52, 1], [53, 0], [54, 3], [55, 1], [56, 2], [57, 1], [58, 1], [59, 1], [61, 0], [62, 0], [63, 1], [64, 1], [65, 0], [66, 0], [67, 3], [68, 2], [69, 100], [70, 100], [79, 1], [81, 0], [82, 1], [83, 1], [84, 0], [85, 0], [87, 0], [88, 0], [89, 50], [90, 50], [91, 50], [92, 50], [93, 1], [99, 0], [100, 30], [101, 0], [102, 1], [103, 0], [104, 50], [105, 0], [106, 0.3], [107, 0], [112, 0], [113, 0], [114, 0], [115, 0], [116, 0], [117, 0], [118, 0], [119, 0], [120, 0], [121, 1], [122, 1], [123, 0], [130, 0], [131, 0], [132, 1], [135, 1], [133, 0]]}'
    
    # Create PlayMenuInfo JSON (matches Python version exactly)
    PLAY_MENU_INFO='{"1": 100, "2": 100, "3": 100, "4": 100, "5": 0, "6": 0, "7": -0.4658685302734375, "10": 3, "11": 3, "20": 0, "21": 0, "22": 0, "23": 0, "24": 0, "25": 0, "26": 0, "27": 0, "28": 0, "29": 0, "30": 0, "31": 0, "32": 0, "33": 0, "34": 0, "35": 0, "36": 0, "37": 0, "38": 0, "39": 0, "40": 0, "41": 0, "42": 0, "43": 0, "44": 0, "45": 0, "46": 0, "47": 0, "48": 0, "49": 0, "50": 0, "51": 1, "52": 1, "53": 0, "54": 3, "55": 1, "56": 2, "57": 1, "58": 1, "59": 1, "61": 0, "62": 0, "63": 1, "64": 1, "65": 0, "66": 0, "67": 3, "68": 2, "69": 100, "70": 100, "79": 1, "81": 0, "82": 1, "83": 1, "84": 0, "85": 0, "87": 0, "88": 0, "89": 50, "90": 50, "91": 50, "92": 50, "93": 1, "99": 0, "100": 30, "101": 0, "102": 1, "103": 0, "104": 50, "105": 0, "106": 0.3, "107": 0, "112": 0, "113": 0, "114": 0, "115": 0, "116": 0, "117": 0, "118": 0, "119": 0, "120": 0, "121": 1, "122": 1, "123": 0, "130": 0, "131": 0, "132": 1}'

    if sqlite3 "$DB_PATH" "
    -- Drop existing trigger
    DROP TRIGGER IF EXISTS prevent_custom_frame_rate_update;
    
    -- Create trigger to prevent game from changing FPS back
    CREATE TRIGGER prevent_custom_frame_rate_update
    AFTER UPDATE OF value ON LocalStorage
    WHEN NEW.key = 'CustomFrameRate'
    BEGIN
        UPDATE LocalStorage SET value = 120 WHERE key = 'CustomFrameRate';
    END;
    
    -- Set the FPS value
    UPDATE LocalStorage SET value = '120' WHERE key = 'CustomFrameRate';
    
    -- Delete old settings for clean state
    DELETE FROM LocalStorage WHERE key IN ('MenuData', 'PlayMenuInfo');
    
    -- Insert the required settings data
    INSERT INTO LocalStorage (key, value) VALUES ('MenuData', '$MENU_DATA');
    INSERT INTO LocalStorage (key, value) VALUES ('PlayMenuInfo', '$PLAY_MENU_INFO');
    " 2>/dev/null; then
        echo "✓ FPS setting updated with persistent trigger and game settings"
    else
        echo "⚠ Could not update FPS setting (game may be running)"
    fi
    
    # Update config file if it exists
    if [ -f "$CONFIG_PATH" ]; then
        # Check if FrameRateLimit exists, if not add it under [/Script/Engine.GameUserSettings]
        if grep -q "FrameRateLimit=" "$CONFIG_PATH"; then
            sed -i 's/FrameRateLimit=.*/FrameRateLimit=120/' "$CONFIG_PATH"
        else
            # Add FrameRateLimit under the GameUserSettings section
            if grep -q "\[/Script/Engine.GameUserSettings\]" "$CONFIG_PATH"; then
                sed -i '/\[\/Script\/Engine\.GameUserSettings\]/a FrameRateLimit=120' "$CONFIG_PATH"
            else
                echo -e "\n[/Script/Engine.GameUserSettings]\nFrameRateLimit=120" >> "$CONFIG_PATH"
            fi
        fi
        echo "✓ Updated config file frame rate limit"
    fi
else
    echo "⚠ LocalStorage database not found. Run the game at least once first."
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
echo "The script will automatically set your frame rate to 120fps with proper game settings!"
echo
echo "To uninstall: wuwa-fps.sh --rm"