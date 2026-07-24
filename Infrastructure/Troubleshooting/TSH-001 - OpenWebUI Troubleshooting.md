# Open WebUI Troubleshooting Guide

This guide provides a step-by-step process for diagnosing and fixing access issues with Open WebUI running inside a Debian LXC container on Proxmox VE.

---

## Quick Reference & Root Cause Checklist

Common reasons for `ERR_CONNECTION_REFUSED` or inaccessible web pages:
1. Navigating to `localhost` on the client PC instead of using the container’s LAN IP.
2. Target port mismatch (Open WebUI Docker typically maps host port `3000` to container port `8080`).
3. The Docker container or background system service has exited or is stopped.
4. Host network/LXC firewall blocking incoming traffic.

---

## Step 1: Client URL Verification

Ensure you are invoking the container's explicit IP address from your browser rather than `localhost`.

1. Get your Open WebUI LXC IP address from the Proxmox summary page (e.g., `192.168.50.113`).
2. Open your web browser and navigate to:
   ```text
   http://<OPENWEBUI_LXC_IP>:3000
   ```
   > **Note:** If you configured host network mode or custom port mapping during deployment, try port `8080` if `3000` fails to connect.

---

## Step 2: Docker Container Diagnostics (Primary Setup)

If you deployed Open WebUI as a Docker container inside the LXC, follow these steps:

### 2.1 Check Active and Stopped Containers
Log into your Open WebUI LXC console (`root@open-webui:~#`) and list all containers:

```bash
# Check running containers
docker ps

# Check ALL containers (including exited/stopped)
docker ps -a
```

### 2.2 Start and Fix Container Runtime State
If `docker ps -a` shows `STATUS: Exited`:

1. **Start the container:**
   ```bash
   docker start open-webui
   ```
   *(Replace `open-webui` with your container ID or name if different).*

2. **Configure restart policy:**
   * **Auto-start on boot:**
     ```bash
     docker update --restart unless-stopped open-webui
     ```
   * **Manual start only (to preserve RAM on low-spec hardware):**
     ```bash
     docker update --restart no open-webui
     ```

3. **Inspect real-time logs if the container fails to remain UP:**
   ```bash
   docker logs -f open-webui --tail 50
   ```

---

## Step 3: Native Service Diagnostics (Fallback / Alternative Setup)

If `docker ps -a` yields no containers, Open WebUI was installed directly onto the LXC OS (e.g., via Python venv or a systemd daemon).

### 3.1 Check systemd Services
Run the following commands in the LXC shell:

```bash
# Search for active or inactive WebUI services
systemctl list-units --type=service | grep -i webui

# Check status of the open-webui service
systemctl status open-webui
```

### 3.2 Start/Restart System Service
If a matching service exists (`open-webui`, `openwebui`, or `webui`):

```bash
# Start the service
systemctl start open-webui

# Enable launch on boot
systemctl enable open-webui
```

### 3.3 Check Application Directory (Native Python Deployment)
If no systemd service is active, check if the application files reside in `/opt` or `/root`:

```bash
# Locate application directories
ls -la /opt/open-webui /root/open-webui 2>/dev/null
```

---

## Step 4: Port & Network Binding Verification

To verify that the application process is listening on the network interfaces inside the LXC:

1. **Check open sockets:**
   ```bash
   ss -tulpn | grep -E '3000|8080'
   ```
   You should see output indicating a process bound to `0.0.0.0:3000` or `:::3000`.

2. **Test local HTTP response inside the LXC:**
   ```bash
   curl -I http://127.0.0.1:3000
   ```
   A successful service returns `HTTP/1.1 200 OK` or `HTTP/1.1 302 Found`.

---

## Step 5: Documenting Intentional Service Shutdowns

If you regularly stop services to optimize CPU/RAM utilization on low-power hosts (e.g., Intel i5-6500T), keep track of stopped containers using these techniques:

### Option A: Shell Alias on Host / LXC
Add a quick alias to your `~/.bashrc` to quickly audit exited containers:
```bash
echo "alias stopped-containers='docker ps -a --filter status=exited'" >> ~/.bashrc
source ~/.bashrc
```

### Option B: Home Assistant Dashboard Note
Keep a simple **Markdown Card** on your Home Assistant Admin dashboard listing on-demand services:

```yaml
type: markdown
title: On-Demand Services Log
content: |
  * **Open WebUI (LXC 113):** Stopped intentionally.
    * *Start Command:* `pct exec 113 -- docker start open-webui`
    * *Access:* `http://192.168.x.x:3000`
```
