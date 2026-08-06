---
title: Ollama Windows Runtime Control Scripts
domain: Infrastructure/AI
type: Runtime Management Reference
status: Approved
last_updated: 06-AUG-2026
tags: [ollama, windows, batch, runtime-management, local-ai]
---

# Ollama Windows Runtime Control Scripts

## Overview
This document contains the runtime control scripts used to start and stop Ollama on Windows systems.

---

## Runtime Environment Variables

| Variable Placeholder | Description | Default Value |
| :--- | :--- | :--- |
| `<OLLAMA_PORT>` | Ollama API listening TCP port | `11434` |
| `<OLLAMA_PATH>` | Installation path to desktop application | `%LOCALAPPDATA%\Programs\Ollama\ollama app.exe` |

> **Important**
>
> Replace all placeholder values enclosed in angle brackets (`<...>`) with values appropriate for your environment before executing the scripts. The values shown in the table are example defaults and may differ from your installation.

---

## 1. Start Ollama (`01-Ollama-Start.bat`)
Launches the Ollama desktop tray application in the background and auto-closes after 3 seconds.

```batch
@echo off
title Starting Ollama
echo Starting Ollama runtime...

:: Option 1: Launches the desktop tray app (recommended for Windows GUI)
start "" "%LOCALAPPDATA%\Programs\Ollama\ollama app.exe"

:: Option 2: Alternatively, if installed as CLI only:
:: start /B ollama serve

echo Ollama is starting on http://localhost:11434
timeout /t 3
```

---

## 2. Stop Ollama (`02-Ollama-Stop.bat`)
Safely stops the Ollama runtime and frees all loaded model memory.

```batch
@echo off
title Stopping Ollama
echo Terminating Ollama processes and freeing system RAM...

:: Safely kill all Ollama executable instances
taskkill /F /IM "ollama app.exe" 2>nul
taskkill /F /IM "ollama.exe" 2>nul

echo.
echo Ollama is completely stopped and RAM freed.
timeout /t 3
```
---

## How to Prompt an AI Tool for Ollama Deployment

> *"I am attaching my PKP document `Ollama Windows Runtime Control Scripts.md`. Generate the startup and shutdown scripts for a new Windows PC where Ollama is installed in CLI-only mode on port 11434."*