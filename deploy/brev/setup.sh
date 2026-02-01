#!/bin/bash
# ============================================================
# AIRA GSI Demo — Brev Setup Script
# No GPU needed — uses hosted NVIDIA NIM APIs
# ============================================================
set -e

echo "=== AIRA GSI Partner Enablement Demo Setup ==="
echo ""

# Step 1: Check for NVIDIA_API_KEY
if [ -z "$NVIDIA_API_KEY" ]; then
    echo "ERROR: NVIDIA_API_KEY not set."
    echo "Run: export NVIDIA_API_KEY=nvapi-YOUR-KEY-HERE"
    exit 1
fi
echo "[1/5] NVIDIA_API_KEY set ✓"

# Step 2: Login to NGC Container Registry
echo "[2/5] Logging into NGC Container Registry..."
echo "$NVIDIA_API_KEY" | docker login nvcr.io -u '$oauthtoken' --password-stdin
echo "NGC login ✓"

# Step 3: Pull containers (no GPU needed)
echo "[3/5] Pulling AIRA containers..."
docker pull nvcr.io/nvidia/blueprint/aira-backend:v1.2.0
docker pull nvcr.io/nvidia/blueprint/aira-frontend:v1.2.0
echo "Containers pulled ✓"

# Step 4: Start services
echo "[4/5] Starting AIRA GSI demo..."
cd "$(dirname "$0")"
docker compose up -d
echo "Services starting..."

# Step 5: Wait for backend health
echo "[5/5] Waiting for backend to start..."
for i in {1..30}; do
    if curl -s http://localhost:3838/aiqhealth 2>/dev/null | grep -q "OK"; then
        echo ""
        echo "========================================="
        echo "  AIRA GSI Demo is LIVE!"
        echo "========================================="
        echo ""
        echo "  Frontend: http://$(hostname -I 2>/dev/null | awk '{print $1}' || echo 'localhost'):3000"
        echo "  Backend:  http://$(hostname -I 2>/dev/null | awk '{print $1}' || echo 'localhost'):3838"
        echo "  Health:   http://localhost:3838/aiqhealth"
        echo ""
        echo "  Collections: GSI_Partner_Enablement"
        echo "               GSI_Competitive_Analysis"
        echo "               Production_Readiness_Guide"
        echo ""
        echo "  Models:   Nemotron Super 49B v1.5 (reasoning)"
        echo "            Llama 3.3 70B Instruct (writing)"
        echo "  NIM APIs: integrate.api.nvidia.com/v1"
        echo "========================================="
        exit 0
    fi
    printf "."
    sleep 2
done

echo ""
echo "Backend didn't respond in 60s. Check logs:"
echo "  docker logs aira-backend"
