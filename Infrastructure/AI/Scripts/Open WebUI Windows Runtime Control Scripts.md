---
title: Open WebUI Windows Runtime Control Scripts
domain: Infrastructure/AI
type: Runtime Management Reference
status: Approved
last_updated: 06-AUG-2026
tags: [openwebui, windows, batch, vbscript, runtime-management, local-ai]
---

# Open WebUI Windows Runtime Control Scripts

## Overview
This document contains the complete suite of Windows Batch (`.bat`) and VBScript (`.vbs`) runtime control script templates for running Open WebUI in Simple Interactive, Foreground Attached, Detached Background, and Silent Background modes.

---

## Runtime Environment Variables

| Variable Placeholder | Description | Default Value |
| :--- | :--- | :--- |
| `<INSTALL_DIR>` | Root directory where Open WebUI is installed | `D:\ProgramFiles\AI\OpenWebUI` |
| `<VENV_NAME>` | Python Virtual Environment directory name | `openwebui-env` |
| `<OPENWEBUI_PORT>` | Open WebUI web server port | `8080` or `9090` |

> **Important**
>
> Replace all placeholder values enclosed in angle brackets (`<...>`) with values appropriate for your environment before executing the scripts. The values shown in the table are example defaults and may differ from your installation.

---

## 1. Simple Interactive Start (`01-OpenWebUI-StartSimple.bat`)
Boots Open WebUI directly in standard mode.

```batch
@echo off
echo [INFO] Listening Address: http://localhost:8080
cd /d <INSTALL_DIR>
<VENV_NAME>\Scripts\open-webui.exe serve
```

---

## 2. Foreground Attached Mode (`02-OpenWebUI-StartAttachedMode.bat`)
Runs Open WebUI inside an active console window with real-time logs. Closing the command window terminates the service.

```batch
@echo off
title Open WebUI Launcher (Attached Mode)
color 0A
echo =======================================================
echo          STARTING OPEN WEBUI (ATTACHED MODE)     
echo [INFO] Closing this window will stop the Open WebUI runtime.      
echo =======================================================
echo.

:: 1. Navigate to directory
cd /d <INSTALL_DIR>
if errorlevel 1 (
    color 0C
    echo [ERROR] Target directory <INSTALL_DIR> not found!
    echo.
    pause
    exit /b 1
)

:: 2. Activate virtual environment
if not exist "<VENV_NAME>\Scripts\activate.bat" (
    color 0C
    echo [ERROR] Virtual environment not found at <VENV_NAME>\Scripts\activate.bat
    echo.
    pause
    exit /b 1
)
call <VENV_NAME>\Scripts\activate.bat

:: 3. Launch background monitor to auto-close launcher on port success
start /min cmd /c "timeout /t 3 >nul & :loop & netstat -ano | findstr /C:":<OPENWEBUI_PORT>" | findstr /I "LISTENING" >nul && (taskkill /FI "WINDOWTITLE eq Open WebUI Launcher*" /F >nul 2>&1 & exit) || (timeout /t 2 >nul & goto loop)"

echo [INFO] Starting Open WebUI server on port <OPENWEBUI_PORT>...
echo [INFO] Keep this window open to keep port <OPENWEBUI_PORT> active.
echo [INFO] Closing this window will stop the Open WebUI runtime.
echo.

:: 4. Start Open WebUI in foreground
<VENV_NAME>\Scripts\open-webui.exe serve --port <OPENWEBUI_PORT>

:: 5. Fallback Error Handler
color 0C
echo.
echo =======================================================
echo [ERROR] Open WebUI stopped unexpectedly or failed to start!
echo =======================================================
echo Please review the output messages above for troubleshooting.
echo.
pause
```

---

## 3. Detached Mode - CMD Launcher (`03-OpenWebUI-StartDetachedMode.bat`)
Launches Open WebUI decoupled in the background, logging all output to `openwebui.log`.

```batch
@echo off
title Open WebUI Launcher (Detached Mode)
color 0A
echo =======================================================
echo          STARTING OPEN WEBUI (DETACHED MODE)     
echo [INFO] Open WebUI will run as a detached background process.
echo =======================================================
echo.

:: 1. Navigate to directory
cd /d <INSTALL_DIR>
if errorlevel 1 (
    color 0C
    echo [ERROR] Target directory <INSTALL_DIR> not found!
    echo.
    pause
    exit /b 1
)

:: 2. Verify virtual environment activation script
if not exist "<VENV_NAME>\Scripts\activate.bat" (
    color 0C
    echo [ERROR] Virtual environment not found at <VENV_NAME>\Scripts\activate.bat
    echo.
    pause
    exit /b 1
)

:: 3. Launch Open WebUI in a DECOUPLED background process
echo [INFO] Initializing Open WebUI background daemon...
start /min "" cmd /c "<VENV_NAME>\Scripts\open-webui.exe serve --port <OPENWEBUI_PORT> > openwebui.log 2>&1"

:: 4. Port Verification Loop (Timeout = 30 seconds)
echo [INFO] Waiting for service to bind to http://localhost:<OPENWEBUI_PORT>...
set "ATTEMPTS=0"
set "MAX_ATTEMPTS=15"

:CHECK_PORT
timeout /t 2 /nobreak >nul
set /a ATTEMPTS+=1

netstat -ano | findstr /C:":<OPENWEBUI_PORT>" | findstr /I "LISTENING" >nul 2>&1
if %errorlevel% equ 0 (
    echo.
    echo [SUCCESS] Open WebUI is actively running on http://localhost:<OPENWEBUI_PORT>!
    echo [INFO] Closing launcher window now...
    timeout /t 2 /nobreak >nul
    exit
)

if %ATTEMPTS% lss %MAX_ATTEMPTS% goto CHECK_PORT

:: 5. Error Handler
color 0C
echo.
echo =======================================================
echo [ERROR] Failed to verify Open WebUI runtime on port <OPENWEBUI_PORT>!
echo =======================================================
echo.
echo --- RECENT LOG OUTPUT (openwebui.log) ---
if exist openwebui.log (
    type openwebui.log
) else (
    echo [ERROR] No log file was created.
)
echo ------------------------------------------
echo.
pause
```

---

## 4. Silent VBScript Launcher (`04-OpenWebUI-StartDetachedMode.vbs`)
Recommended for daily silent operation. Launches Open WebUI 100% hidden without flashing CMD windows.

```vbscript
Set WshShell = CreateObject("WScript.Shell")

' Path configuration
strDirectory = "<INSTALL_DIR>"
strExe = strDirectory & "\<VENV_NAME>\Scripts\open-webui.exe"
strLog = strDirectory & "\openwebui.log"
strPort = "<OPENWEBUI_PORT>"

strCommand = "cmd.exe /c """ & strExe & " serve --port " & strPort & " > """ & strLog & """ 2>&1"""

' Launch process completely hidden (0 = SW_HIDE, False = Do not wait)
WshShell.CurrentDirectory = strDirectory
WshShell.Run strCommand, 0, False

Set WshShell = Nothing
```

---

## 5. Stop Open WebUI (`05-OpenWebUI-Stop.bat`)
Terminates all active Open WebUI executable instances.

```batch
@echo off
title Stopping Open WebUI
echo Stopping Open WebUI runtime...

:: Terminate open-webui process safely
taskkill /F /IM open-webui.exe 2>nul

echo.
echo Open WebUI has been stopped.
timeout /t 3
```

---

## Using This Document with AI Tools

When requesting script generation or adaptation, attach this document as a reference and describe your target environment.

### Example Prompt

> I am attaching my PKP document **"Open WebUI Windows Runtime Control Scripts.md"**.
> Use it as the authoritative reference for runtime management.
> Generate the required startup and shutdown scripts for my environment.
> Replace all placeholder values (`<...>`) with values appropriate for my system.
> Preserve the documented runtime management patterns unless I explicitly request changes.