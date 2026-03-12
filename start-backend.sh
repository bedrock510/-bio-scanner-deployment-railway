#!/bin/bash
# BioSignal Scanner — Backend Setup & Run Script

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Setting up BioSignal Scanner Backend..."

# Create virtual environment if it doesn't exist
if [ ! -d "$SCRIPT_DIR/.venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv "$SCRIPT_DIR/.venv"
fi

source "$SCRIPT_DIR/.venv/bin/activate"

echo "Installing dependencies..."
pip install -r "$SCRIPT_DIR/backend/requirements.txt"

# Check for .env file
if [ ! -f "$SCRIPT_DIR/.env" ]; then
    echo ""
    echo "⚠️  No .env file found. Copying from .env.example..."
    cp "$SCRIPT_DIR/.env.example" "$SCRIPT_DIR/.env"
    echo "⚠️  Please edit .env and add your ANTHROPIC_API_KEY, then run this script again."
    echo ""
    exit 1
fi

echo ""
echo "Starting FastAPI server on http://localhost:8000"
echo "Note: First run may take 1-2 minutes as TensorFlow initializes."
echo ""

cd "$SCRIPT_DIR/backend"
uvicorn main:app --reload --host 0.0.0.0 --port 8000
