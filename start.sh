#!/bin/bash
# BioSignal Scanner — one-command Docker start (Mac / Linux)

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── 1. Check Docker is installed ─────────────────────────────────────────────
if ! command -v docker &>/dev/null; then
    echo ""
    echo "ERROR: Docker is not installed."
    echo "Download Docker Desktop from: https://www.docker.com/products/docker-desktop"
    echo ""
    exit 1
fi

if ! docker info &>/dev/null; then
    echo ""
    echo "ERROR: Docker is installed but not running."
    echo "Please start Docker Desktop and try again."
    echo ""
    exit 1
fi

# ── 2. Check .env exists ──────────────────────────────────────────────────────
if [ ! -f "$SCRIPT_DIR/.env" ]; then
    echo ""
    echo "No .env file found. Creating from template..."
    cp "$SCRIPT_DIR/.env.example" "$SCRIPT_DIR/.env"
    echo ""
    echo "⚠️  ACTION REQUIRED:"
    echo "    Open .env and set your ANTHROPIC_API_KEY, then run this script again."
    echo ""
    echo "    nano $SCRIPT_DIR/.env"
    echo ""
    exit 1
fi

if grep -q "your_anthropic_api_key_here" "$SCRIPT_DIR/.env"; then
    echo ""
    echo "⚠️  ACTION REQUIRED:"
    echo "    Your ANTHROPIC_API_KEY in .env has not been set yet."
    echo "    Open .env, replace 'your_anthropic_api_key_here' with your real key, then run again."
    echo ""
    exit 1
fi

# ── 3. Start everything ───────────────────────────────────────────────────────
echo ""
echo "Starting BioSignal Scanner..."
echo "First build takes 5–10 minutes (TensorFlow + DeepFace are large)."
echo "Subsequent starts take ~30 seconds."
echo ""

docker compose -f "$SCRIPT_DIR/docker-compose.yml" up --build

echo ""
echo "─────────────────────────────────────────"
echo "  App:  http://localhost:3000"
echo "  API:  http://localhost:8000"
echo "─────────────────────────────────────────"
