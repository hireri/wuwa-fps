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
echo REM It sets CustomFrameRate to 120 before launching the game
echo.
echo REM Check for uninstall flag
echo if "%%1"=="--rm" ^(
echo     echo === Uninstalling WuWa 120fps Auto-Setter ===
echo     echo.
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
echo         reg add "HKCU\Environment" /v PATH /t REG_EXPAND_SZ /d "%%USER_PATH%%" ^^^>nul
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
echo set "DB_PATH=%%LOCALAPPDATA%%\WutheringWaves\Client\Saved\LocalStorage\LocalStorage.db"
echo.
echo if exist "%%DB_PATH%%" ^(
echo     sqlite3.exe "%%DB_PATH%%" "UPDATE LocalStorage SET value = '120' WHERE key = 'CustomFrameRate';" 2^>nul
echo ^)
) > "!SCRIPT_PATH!"

echo ✓ Created FPS script at: !SCRIPT_PATH!

set "USER_PATH="
for /f "tokens=2*" %%A in ('reg query "HKCU\Environment" /v PATH 2^>nul') do set "USER_PATH=%%B"

if "!USER_PATH!" == "" (
    reg add "HKCU\Environment" /v PATH /t REG_EXPAND_SZ /d "!SCRIPT_DIR!" >nul
    echo ✓ Added script directory to user PATH
) else (
    echo !USER_PATH! | find /i "!SCRIPT_DIR!" >nul
    if errorlevel 1 (
        reg add "HKCU\Environment" /v PATH /t REG_EXPAND_SZ /d "!USER_PATH!;!SCRIPT_DIR!" >nul
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
echo The script will automatically set your frame rate to 120fps before each launch!
echo.
echo Note: You may need to restart your command prompt for PATH changes to take effect.
echo.
pause