#!/bin/bash

# Terra Cloud Functions Local Testing Script
set -e

echo "🧪 Starting local testing for Terra Cloud Functions..."

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo "❌ Firebase CLI is not installed. Please install it first:"
    echo "npm install -g firebase-tools"
    exit 1
fi

# Install dependencies
echo "📦 Installing dependencies..."
npm ci

# Build TypeScript
echo "🔨 Building TypeScript..."
npm run build

# Check if build was successful
if [ ! -f "lib/index.js" ]; then
    echo "❌ Build failed - lib/index.js not found"
    exit 1
fi

echo "✅ Build successful"

# Run unit tests
echo "🧪 Running unit tests..."
npm test

# Start emulators in background
echo "🚀 Starting Firebase emulators..."
firebase emulators:start --only functions,firestore,storage &
EMULATOR_PID=$!

# Wait for emulators to start
echo "⏳ Waiting for emulators to start..."
sleep 10

# Function to cleanup emulators on exit
cleanup() {
    echo "🛑 Stopping emulators..."
    kill $EMULATOR_PID 2>/dev/null || true
    exit
}
trap cleanup EXIT INT TERM

# Test if emulators are running
if ! curl -s http://localhost:4000 > /dev/null; then
    echo "❌ Emulators failed to start"
    exit 1
fi

echo "✅ Emulators are running!"
echo ""
echo "🌐 Emulator UI: http://localhost:4000"
echo "⚡ Functions: http://localhost:5001"
echo "🔥 Firestore: http://localhost:8080"
echo "📦 Storage: http://localhost:9199"
echo ""
echo "🧪 You can now test your functions locally."
echo "Press Ctrl+C to stop the emulators."

# Keep the script running
wait $EMULATOR_PID