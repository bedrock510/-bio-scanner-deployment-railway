#!/bin/bash
# BioSignal Scanner — Frontend Setup & Run Script

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Setting up BioSignal Scanner Frontend..."

cd "$SCRIPT_DIR/frontend"

if [ ! -d "node_modules" ]; then
    echo "Installing npm dependencies..."
    npm install
fi

echo ""
echo "Starting React development server at http://localhost:5173"
echo ""

npm run dev
