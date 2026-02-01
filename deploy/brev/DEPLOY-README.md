# GSI Partner Enablement Demo — Deployment Guide
## Browser-Accessible from Any Laptop (No GPU Required)

---

## What This Deploys

- **AIRA Backend** (port 3838) — FastAPI service with 3 GSI collections
- **AIRA Frontend** (port 3000) — React web UI for research report generation
- **Hosted NIM APIs** — Nemotron Super 49B v1.5 + Llama 3.3 70B via integrate.api.nvidia.com

No GPU needed. All inference runs on NVIDIA's hosted NIM endpoints.

---

## Path 1: Brev (Recommended — $0.04/hr CPU instance)

### Step 1: Launch Brev Instance

1. Go to https://brev.nvidia.com
2. Create a new environment (CPU instance is fine — cheapest option)
3. SSH into the instance or use the built-in terminal

### Step 2: Clone and Deploy

```bash
# Set your API key
export NVIDIA_API_KEY=nvapi-YOUR-KEY-HERE

# Clone the repo
git clone https://github.com/NVIDIA-AI-Blueprints/aiq-research-assistant.git
cd aiq-research-assistant

# Copy GSI configs into brev deployment
# (Already done if using this repo as-is)

# Run setup
cd deploy/brev
bash setup.sh
```

### Step 3: Access from Any Browser

Open `http://<BREV-INSTANCE-IP>:3000` in any browser.

The Brev console shows your instance IP. Or from the terminal:
```bash
curl -s ifconfig.me  # Shows public IP
```

---

## Path 2: One-Click Brev Launchable

1. Go to https://build.nvidia.com/nvidia/aiq
2. Click **"Deploy on Cloud"** button
3. This launches a pre-configured Brev environment
4. Once running, SSH in and replace configs:

```bash
# Replace the default config with GSI config
cd /app/configs
# Upload gsi-hosted-config.yml as hosted-config.yml
# Restart the backend
docker restart aira-backend
```

Note: The Launchable may provision a GPU instance (more expensive).
The manual Path 1 is cheaper since it uses CPU only.

---

## Path 3: GitHub Codespaces (Free Backup)

### Step 1: Fork the Repo

1. Go to https://github.com/NVIDIA-AI-Blueprints/aiq-research-assistant
2. Click **Fork** to your GitHub account

### Step 2: Open Codespace

1. On your fork, click **Code** → **Codespaces** → **Create codespace**
2. Wait for the environment to build

### Step 3: Deploy Inside Codespace

```bash
# Set API key
export NVIDIA_API_KEY=nvapi-YOUR-KEY-HERE

# Login to NGC and pull images
echo "$NVIDIA_API_KEY" | docker login nvcr.io -u '$oauthtoken' --password-stdin
docker pull nvcr.io/nvidia/blueprint/aira-backend:v1.2.0
docker pull nvcr.io/nvidia/blueprint/aira-frontend:v1.2.0

# Run the lightweight deployment
cd deploy/brev
docker compose up -d
```

### Step 4: Access via Port Forwarding

Codespaces automatically creates forwarded ports:
- Port 3000 → Frontend (public URL auto-generated)
- Port 3838 → Backend

Click the **Ports** tab in the Codespace terminal to see the public URL.

---

## Quick Test Commands

```bash
# Health check
curl http://localhost:3838/aiqhealth

# List GSI collections
curl http://localhost:3838/default_collections

# Generate research queries
curl -X POST http://localhost:3838/generate_query \
  -H "Content-Type: application/json" \
  -d '{
    "topic": "GSI Partner AI Practice Launch",
    "report_organization": "Create a report covering NPN tiers, AI Blueprints, hardware sizing, CoE setup, and GTM timeline.",
    "num_queries": 3,
    "llm_name": "nemotron"
  }'
```

---

## Troubleshooting

**Container won't pull?**
→ Check NGC login: `docker login nvcr.io -u '$oauthtoken' -p $NVIDIA_API_KEY`

**Backend fails to start?**
→ Check logs: `docker logs aira-backend`
→ Verify NVIDIA_API_KEY is set: `echo $NVIDIA_API_KEY`

**Frontend shows "Connection refused"?**
→ Backend might still be starting. Wait 30 seconds.
→ Check: `curl http://localhost:3838/aiqhealth`

**Port not accessible from browser?**
→ Check firewall: Ports 3000 and 3838 must be open
→ On Brev: Check instance security group settings

---

## Cost Estimate

| Platform | Instance | Cost | $25 Budget |
|----------|----------|------|------------|
| Brev CPU | Cheapest tier | ~$0.04-0.50/hr | Days of runtime |
| GitHub Codespaces | 4-core | Free (60hr/mo) | $0 |
| Brev GPU (full RAG) | 4x H100 | ~$24/hr | ~1 hour |

**Recommended: Brev CPU or GitHub Codespaces.**
