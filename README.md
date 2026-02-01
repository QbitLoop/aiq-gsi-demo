# AI-Q GSI Partner Enablement Demo

Lightweight deployment of NVIDIA's [AI-Q Research Assistant](https://github.com/NVIDIA-AI-Blueprints/aiq-research-assistant) Blueprint with custom GSI (Global Systems Integrator) collections.

**No GPU required** — uses hosted NVIDIA NIM APIs.

## Quick Deploy (Brev or any Docker host)

```bash
export NVIDIA_API_KEY=nvapi-YOUR-KEY-HERE
git clone https://github.com/QbitLoop/aiq-gsi-demo.git
cd aiq-gsi-demo/deploy/brev
bash setup.sh
```

Access: `http://<YOUR-IP>:3000`

## What's Included

| File | Purpose |
|------|---------|
| `deploy/brev/docker-compose.yml` | Lightweight no-GPU compose (backend + frontend) |
| `deploy/brev/setup.sh` | One-command setup: NGC login, pull, start, health check |
| `deploy/brev/configs/hosted-config.yml` | GSI config with 3 collections |
| `deploy/brev/DEPLOY-README.md` | Full deployment guide (Brev, Codespaces, manual) |
| `configs/gsi-hosted-config.yml` | Source GSI configuration |

## GSI Collections

1. **GSI_Partner_Enablement** — NPN tiers, AI Blueprints, hardware sizing, CoE setup, GTM timeline
2. **GSI_Competitive_Analysis** — NVIDIA AI Enterprise vs Azure AI / AWS Bedrock / Google Vertex AI
3. **Production_Readiness_Guide** — POC to production: NIM Operator 3.0, Milvus, NeMo Guardrails

## Architecture

- **Backend** (port 3838): AIRA FastAPI service running NeMo Agent Toolkit v1.3
- **Frontend** (port 3000): React web UI for interactive research report generation
- **Models**: Nemotron Super 49B v1.5 (reasoning) + Llama 3.3 70B Instruct (writing)
- **APIs**: integrate.api.nvidia.com/v1 (hosted NIM endpoints)

## Prerequisites

- Docker and Docker Compose
- NVIDIA API key from [build.nvidia.com](https://build.nvidia.com)
- NGC container registry access (same API key)

## Based On

[NVIDIA AI-Q Research Assistant Blueprint](https://github.com/NVIDIA-AI-Blueprints/aiq-research-assistant) — a 5-step agentic research pipeline (Plan, Search, Write, Reflect, Refine) built on NeMo Agent Toolkit.
