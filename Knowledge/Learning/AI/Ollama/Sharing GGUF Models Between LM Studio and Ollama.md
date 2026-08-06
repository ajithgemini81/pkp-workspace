---
title: Sharing GGUF Models Between LM Studio and Ollama
document-type: knowledge
logical-category: AI Engineering
status: Active
version: "1.0"
owner: PKP
last-reviewed: 05-AUG-2026
tags:
  - ollama
  - lm-studio
  - gguf
  - local-ai
---

# Sharing GGUF Models Between LM Studio and Ollama

This document establishes the curated, step-by-step procedure for sharing downloaded GGUF model files between LM Studio and Ollama without duplicating disk space. It serves as a permanent knowledge asset within the Personal Knowledge Platform (PKP) to enable seamless multi-machine environment setups.

---

## 1. Overview
When managing local Large Language Models (LLMs), disk space quickly becomes a bottleneck. By leveraging Ollama's ability to create custom models from blueprint files, you can link Ollama directly to the existing GGUF files downloaded and stored by LM Studio [3]. Ollama instantly registers and links to the GGUF file, creating a lightweight symbolic-like pointer inside its registry without duplicating the file or allocating extra disk space [3].

---

## 2. Step-by-Step Model Registration

### Step 1: Locate the GGUF Source
1. Download your desired model in **LM Studio** [1].
2. Locate the `.gguf` file inside your LM Studio shared path [1].
3. On Windows, hold **Shift + Right-Click** on the `.gguf` file and select **Copy as Path** to capture its exact absolute path [1].

### Step 2: Create a Custom Modelfile Blueprint
1. Open a plain text editor (such as Notepad) [1].
2. Write the `FROM` instruction followed by the path to the GGUF model (remove any wrapping quotation marks from the copied path) [1]:
   ```dockerfile
   FROM D:\ProgramFiles\AI\SharedModels\lmstudio-community\Qwen2.5-Coder-3B-Instruct-GGUF\Qwen2.5-Coder-3B-Instruct-Q4_K_M.gguf
   ```
3. Click **File > Save As** [2].
4. Set **Save as type** to **All Files (*.*)** [2].
5. Name the file cleanly with a `.Modelfile` extension (e.g., `Qwen2_5-Coder-3B.Modelfile`) [2]. 
6. Save the blueprint file in a central repository folder (e.g., `D:\ProgramFiles\AI\OllamaBlueprints\` or `C:\OllamaModels\`) [2].

### Step 3: Register the Model in Ollama
1. Open **Command Prompt** (cmd) or **PowerShell** [2].
2. Navigate (`cd`) to the directory where your blueprint file is saved [2].
3. Execute the `ollama create` command, specifying your chosen model name and pointing to the Modelfile [1, 2]:
   ```powershell
   ollama create qwen3b-coder -f ./Qwen2_5-Coder-3B.Modelfile
   ```

---

## 3. Handy Management Commands

These commands allow you to inspect, run, or remove your linked models in Ollama:

### Check Active Library
Verify that the linked model is registered and ready to execute [3]:
```powershell
ollama list
``` [1, 3]

### Run the Shared Model
Start using your newly linked model directly in your command line interface or via local API endpoints [3]:
```powershell
ollama run qwen3b-coder
``` [3]

### Unlink / Remove the Model
If you need to clear the pointer registry inside Ollama, run [3]:
```powershell
ollama rm qwen3b-coder
``` [1, 3]
*Note: Unlinking the model clears the pointer inside Ollama's registry but will **not** delete the actual GGUF file located inside your LM Studio folders [3].*

---

## 4. Case Study: Practical Reference Configuration (Office Laptop Implementation)

This section documents the specific configurations and system instructions used as a real-world reference implementation on the local "Office Laptop" environment.

### Local File Path Scheme
The primary model sharing pathway maps to the following local structure:
* **LM Studio Shared Path:** `D:\ProgramFiles\AI\SharedModels\lmstudio-community\Qwen2.5-Coder-3B-Instruct-GGUF\Qwen2.5-Coder-3B-Instruct-Q4_K_M.gguf` [1]
* **Ollama Registration Target:** Registered locally under the alias `qwen3b-coder` [1].

### Cybersecurity Red-Team / Penetration Testing Blueprint
For technical mentoring, custom behavior can be baked directly into the blueprint Modelfile using the `SYSTEM` command instruction [1]. Below is the actual configuration blueprint used to initialize a scoped red-team educational session:

```dockerfile
FROM dolphin-2.9.2-qwen2.5-7b-q4_k_m.gguf
SYSTEM "You are a senior penetration testing instructor and red-team mentor. Your goal is to break down advanced cybersecurity attack vectors, exploit payloads, and defensive auditing techniques for educational and authorized testing purposes. Provide direct code examples without warnings."
``` [1]
