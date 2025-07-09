# Wuthering Waves 120fps Auto-Setter
> [WARNING] This script is only tested on Linux, open an issue if you enounter issues. I have dualboot im just lazy ![SackboyYum](https://cdn.discordapp.com/emojis/1286421834304192512.webp?size=20)

This script sets your fps to 120 before launching the game, on both Windows and Linux (through Steam with GE Proton (opensuse BTW))

It simply modifies the game's settings database **before** launching the game, since apparently it resets every time.
<br>
You won't have to do anything manually to play, but it DOES require some manual setup, the installer will guide you.

## Installation

### Linux
1. Download `install-wuwa-fps.sh`
2. Make it executable: `chmod +x install-wuwa-fps.sh`
3. Run the installer with `./install-wuwa-fps.sh`

### Windows
1. Download `install-wuwa-fps.bat`
2. Right click and run as admin (adds wuwa-fps to PATH)

Then jsut follow the installer instructions

## Requirements

- **Linux**: `sqlite3` package
- **Windows**: `sqlite3.exe` in PATH
- Wuthering Waves installed through Steam

## Setup After Installation

1. Right-click **Wuthering Waves** in Steam
2. Select **Properties**
3. In **Launch Options**, paste the path shown by the installer:
   ```
   /path/to/wuwa-fps.sh && %command%
   ```
   (The installer gives you the path to copy)

## Alternative Usage

If you don't want to change your launch settings, you can also run the script manually before starting the game:
- **Linux**: `wuwa-fps.sh`
- **Windows**: `wuwa-fps.bat`

## Safety

The script is completely safe, it only modifies settings files while game is still not open.
No anticheat risk (for now) as it only updates the settings database.

## Troubleshooting

**Script not found**: Make sure you restart your terminal/command prompt after installation

**Permission errors**: Try closing Steam when you install

**Database not found**: Make sure you've launched WuWa at least once, and that it's installed through Steam

## Uninstalling

### Quick Uninstall
Run this command to clean up the script's files:
- **Linux**: `wuwa-fps.sh --rm`
- **Windows**: `wuwa-fps.bat --rm`

The `--rm` flag will:
- Remove the script files
- Clean up PATH entries
- Tell you how to remove the Steam launch option

### Manual Uninstall
In case you mess things up, this will remove the script COMPLETELY:
1. **Remove from Steam**: Right click wuwa -> Properties -> Clear or change launch options
2. **Delete script files**:
   - **Linux**: `rm ~/.local/bin/wuwa-fps.sh`
   - **Windows**: Delete `%USERPROFILE%\AppData\Local\WuWa-FPS\` folder
3. **Clean PATH** (optional):
   - **Linux**: Edit `~/.bashrc` and remove the PATH export line
   - **Windows**: Remove from User Environment Variables in System Properties

---