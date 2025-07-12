@echo off
setlocal enabledelayedexpansion

echo === WuWa-FPS Installer ===
echo.

where sqlite3.exe >nul 2>&1
if errorlevel 1 (
    echo Error: sqlite3.exe not found in PATH.
    echo.
    echo You need to install SQLite command-line tools:
    echo 1. Download from: https://www.sqlite.org/download.html
    echo 2. Extract sqlite3.exe to a folder in your PATH
    echo 3. Or place it in the same folder as this installer
    echo.
    pause
    exit /b 1
)

set "STEAM_ROOT="
if exist "%ProgramFiles(x86)%\Steam" (
    set "STEAM_ROOT=%ProgramFiles(x86)%\Steam"
) else if exist "%ProgramFiles%\Steam" (
    set "STEAM_ROOT=%ProgramFiles%\Steam"
) else if exist "C:\Steam" (
    set "STEAM_ROOT=C:\Steam"
) else (
    echo Error: Could not find Steam installation.
    echo Please make sure Steam is installed.
    pause
    exit /b 1
)

set "WUWA_DIR=!STEAM_ROOT!\steamapps\common\Wuthering Waves"
if not exist "!WUWA_DIR!" (
    echo Error: Wuthering Waves not found in Steam library.
    echo Expected location: !WUWA_DIR!
    echo Please install Wuthering Waves through Steam first.
    pause
    exit /b 1
)

echo Found Wuthering Waves at: !WUWA_DIR!
echo.

set "SCRIPT_DIR=%USERPROFILE%\AppData\Local\WuWa-FPS"
set "SCRIPT_PATH=!SCRIPT_DIR!\wuwa-fps.bat"

if not exist "!SCRIPT_DIR!" mkdir "!SCRIPT_DIR!"

(
echo @echo off
echo REM This script was generated with https://github.com/hireri/wuwa-fps
echo REM It creates a persistent 120 FPS setting with complete game settings
echo.
echo REM Check for uninstall flag
echo if "%%1"=="--rm" ^(
echo     echo === Uninstalling Wuwa-FPS ===
echo     echo.
echo     
echo     REM Try Steam path first, then local appdata path
echo     set "DB_PATH_STEAM=!WUWA_DIR!\Client\Saved\LocalStorage\LocalStorage.db"
echo     set "DB_PATH_LOCAL=%%LOCALAPPDATA%%\WutheringWaves\Client\Saved\LocalStorage\LocalStorage.db"
echo     set "CONFIG_PATH=!WUWA_DIR!\Client\Saved\Config\WindowsNoEditor\GameUserSettings.ini"
echo     
echo     if exist "%%DB_PATH_STEAM%%" ^(
echo         sqlite3.exe "%%DB_PATH_STEAM%%" "DROP TRIGGER IF EXISTS prevent_custom_frame_rate_update; UPDATE LocalStorage SET value = 2 WHERE key = 'CustomFrameRate'; DELETE FROM LocalStorage WHERE key IN ('MenuData', 'PlayMenuInfo');" 2^^^>nul
echo         echo ✓ Removed FPS settings from Steam database
echo     ^)
echo     
echo     if exist "%%DB_PATH_LOCAL%%" ^(
echo         sqlite3.exe "%%DB_PATH_LOCAL%%" "DROP TRIGGER IF EXISTS prevent_custom_frame_rate_update; UPDATE LocalStorage SET value = 2 WHERE key = 'CustomFrameRate'; DELETE FROM LocalStorage WHERE key IN ('MenuData', 'PlayMenuInfo');" 2^^^>nul
echo         echo ✓ Removed FPS settings from local database
echo     ^)
echo     
echo     REM Reset config file
echo     if exist "%%CONFIG_PATH%%" ^(
echo         powershell -Command "^(Get-Content '%%CONFIG_PATH%%'^) -replace 'FrameRateLimit=120', 'FrameRateLimit=60' | Set-Content '%%CONFIG_PATH%%'" 2^^^>nul
echo         echo ✓ Reset config file frame rate limit
echo     ^)
echo     
echo     REM Remove script directory
echo     set "SCRIPT_DIR=%%USERPROFILE%%\AppData\Local\WuWa-FPS"
echo     if exist "%%SCRIPT_DIR%%" ^(
echo         rmdir /s /q "%%SCRIPT_DIR%%"
echo         echo ✓ Removed script directory: %%SCRIPT_DIR%%
echo     ^)
echo     
echo     REM Clean up PATH
echo     for /f "tokens=2*" %%%%A in ^('reg query "HKCU\Environment" /v PATH 2^^^>nul'^) do set "USER_PATH=%%%%B"
echo     if not "%%USER_PATH%%"=="" ^(
echo         set "USER_PATH=%%USER_PATH:;%%USERPROFILE%%\AppData\Local\WuWa-FPS=%%"
echo         set "USER_PATH=%%USER_PATH:%%USERPROFILE%%\AppData\Local\WuWa-FPS;=%%"
echo         set "USER_PATH=%%USER_PATH:%%USERPROFILE%%\AppData\Local\WuWa-FPS=%%"
echo         reg add "HKCU\Environment" /v PATH /t REG_EXPAND_SZ /d "%%USER_PATH%%" /f ^^^>nul
echo         echo ✓ Cleaned PATH from user environment
echo     ^)
echo     
echo     echo.
echo     echo Manual step required:
echo     echo 1. In Steam, right-click Wuthering Waves ^^^> Properties
echo     echo 2. Clear the Launch Options field
echo     echo.
echo     echo Uninstall complete!
echo     pause
echo     exit /b 0
echo ^)
echo.
echo REM Try Steam path first, then local appdata path
echo set "DB_PATH_STEAM=!WUWA_DIR!\Client\Saved\LocalStorage\LocalStorage.db"
echo set "DB_PATH_LOCAL=%%LOCALAPPDATA%%\WutheringWaves\Client\Saved\LocalStorage\LocalStorage.db"
echo set "CONFIG_PATH=!WUWA_DIR!\Client\Saved\Config\WindowsNoEditor\GameUserSettings.ini"
echo set "DB_PATH="
echo.
echo if exist "%%DB_PATH_STEAM%%" ^(
echo     set "DB_PATH=%%DB_PATH_STEAM%%"
echo     echo Using Steam database location
echo ^) else if exist "%%DB_PATH_LOCAL%%" ^(
echo     set "DB_PATH=%%DB_PATH_LOCAL%%"
echo     echo Using local AppData database location
echo ^) else ^(
echo     echo ⚠ Warning: Database not found - game may need to be launched once first
echo     echo Expected locations:
echo     echo   - %%DB_PATH_STEAM%%
echo     echo   - %%DB_PATH_LOCAL%%
echo     goto :end
echo ^)
echo.
echo REM Create the MenuData and PlayMenuInfo JSON structures
echo set MENU_DATA={"___MetaType___": "___Map___", "Content": [[1, 100], [2, 100], [3, 100], [4, 100], [5, 0], [6, 0], [7, -0.4658685302734375], [10, 3], [11, 3], [20, 0], [21, 0], [22, 0], [23, 0], [24, 0], [25, 0], [26, 0], [27, 0], [28, 0], [29, 0], [30, 0], [31, 0], [32, 0], [33, 0], [34, 0], [35, 0], [36, 0], [37, 0], [38, 0], [39, 0], [40, 0], [41, 0], [42, 0], [43, 0], [44, 0], [45, 0], [46, 0], [47, 0], [48, 0], [49, 0], [50, 0], [51, 1], [52, 1], [53, 0], [54, 3], [55, 1], [56, 2], [57, 1], [58, 1], [59, 1], [61, 0], [62, 0], [63, 1], [64, 1], [65, 0], [66, 0], [67, 3], [68, 2], [69, 100], [70, 100], [79, 1], [81, 0], [82, 1], [83, 1], [84, 0], [85, 0], [87, 0], [88, 0], [89, 50], [90, 50], [91, 50], [92, 50], [93, 1], [99, 0], [100, 30], [101, 0], [102, 1], [103, 0], [104, 50], [105, 0], [106, 0.3], [107, 0], [112, 0], [113, 0], [114, 0], [115, 0], [116, 0], [117, 0], [118, 0], [119, 0], [120, 0], [121, 1], [122, 1], [123, 0], [130, 0], [131, 0], [132, 1], [135, 1], [133, 0]]}
echo.
echo set PLAY_MENU_INFO={"1": 100, "2": 100, "3": 100, "4": 100, "5": 0, "6": 0, "7": -0.4658685302734375, "10": 3, "11": 3, "20": 0, "21": 0, "22": 0, "23": 0, "24": 0, "25": 0, "26": 0, "27": 0, "28": 0, "29": 0, "30": 0, "31": 0, "32": 0, "33": 0, "34": 0, "35": 0, "36": 0, "37": 0, "38": 0, "39": 0, "40": 0, "41": 0, "42": 0, "43": 0, "44": 0, "45": 0, "46": 0, "47": 0, "48": 0, "49": 0, "50": 0, "51": 1, "52": 1, "53": 0, "54": 3, "55": 1, "56": 2, "57": 1, "58": 1, "59": 1, "61": 0, "62": 0, "63": 1, "64": 1, "65": 0, "66": 0, "67": 3, "68": 2, "69": 100, "70": 100, "79": 1, "81": 0, "82": 1, "83": 1, "84": 0, "85": 0, "87": 0, "88": 0, "89": 50, "90": 50, "91": 50, "92": 50, "93": 1, "99": 0, "100": 30, "101": 0, "102": 1, "103": 0, "104": 50, "105": 0, "106": 0.3, "107": 0, "112": 0, "113": 0, "114": 0, "115": 0, "116": 0, "117": 0, "118": 0, "119": 0, "120": 0, "121": 1, "122": 1, "123": 0, "130": 0, "131": 0, "132": 1}
echo.
echo REM Apply the database changes
echo sqlite3.exe "%%DB_PATH%%" "DROP TRIGGER IF EXISTS prevent_custom_frame_rate_update; CREATE TRIGGER prevent_custom_frame_rate_update AFTER UPDATE OF value ON LocalStorage WHEN NEW.key = 'CustomFrameRate' BEGIN UPDATE LocalStorage SET value = 120 WHERE key = 'CustomFrameRate'; END; UPDATE LocalStorage SET value = '120' WHERE key = 'CustomFrameRate'; DELETE FROM LocalStorage WHERE key IN ('MenuData', 'PlayMenuInfo'); INSERT INTO LocalStorage (key, value^) VALUES ('MenuData', '%%MENU_DATA%%'^); INSERT INTO LocalStorage (key, value^) VALUES ('PlayMenuInfo', '%%PLAY_MENU_INFO%%'^);" 2^>nul
echo.
echo if errorlevel 1 ^(
echo     echo ⚠ Could not update FPS setting (game may be running^)
echo ^) else ^(
echo     echo ✓ Applied 120 FPS with persistent trigger protection
echo     echo ✓ Applied optimized graphics settings
echo     echo ✓ FPS will remain at 120 even after changing graphics settings
echo ^)
echo.
echo REM Update config file if it exists
echo if exist "%%CONFIG_PATH%%" ^(
echo     powershell -Command "$content = Get-Content '%%CONFIG_PATH%%' -Raw; if ($content -match 'FrameRateLimit=') { $content = $content -replace 'FrameRateLimit=.*', 'FrameRateLimit=120' } elseif ($content -match '\[/Script/Engine\.GameUserSettings\]') { $content = $content -replace '(\[/Script/Engine\.GameUserSettings\])', '$1`nFrameRateLimit=120' } else { $content += \"`n[/Script/Engine.GameUserSettings]`nFrameRateLimit=120\" }; Set-Content -Path '%%CONFIG_PATH%%' -Value $content" 2^^^>nul
echo     if not errorlevel 1 echo ✓ Updated config file frame rate limit
echo ^)
echo.
echo :end
echo echo ⚠ IMPORTANT: Disable VSync in-game and in your GPU control panel
echo echo ⚠ for the FPS unlock to take effect properly
) > "!SCRIPT_PATH!"

echo ✓ Created FPS script at: !SCRIPT_PATH!

set "USER_PATH="
for /f "tokens=2*" %%A in ('reg query "HKCU\Environment" /v PATH 2^>nul') do set "USER_PATH=%%B"

if "!USER_PATH!" == "" (
    reg add "HKCU\Environment" /v PATH /t REG_EXPAND_SZ /d "!SCRIPT_DIR!" /f >nul
    echo ✓ Added script directory to user PATH
) else (
    echo !USER_PATH! | find /i "!SCRIPT_DIR!" >nul
    if errorlevel 1 (
        reg add "HKCU\Environment" /v PATH /t REG_EXPAND_SZ /d "!USER_PATH!;!SCRIPT_DIR!" /f >nul
        echo ✓ Added script directory to user PATH
    ) else (
        echo ✓ Script directory already in PATH
    )
)

echo.
echo === Installation Complete! ===
echo.
echo To use:
echo 1. In Steam, right-click Wuthering Waves ^> Properties
echo 2. In Launch Options, enter:
echo    "!SCRIPT_PATH!" ^&^& %%command%%
echo.
echo Alternative: You can also run 'wuwa-fps.bat' from command prompt
echo.
echo The script will automatically set your frame rate to 120fps with optimized settings!
echo.
echo To uninstall: wuwa-fps.bat --rm
echo.
echo Note: You may need to restart your command prompt for PATH changes to take effect.
echo.
pause