#!/bin/bash

# Terra Cloud Functions Deployment Script
set -e

echo "🚀 Starting Terra Cloud Functions deployment..."

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo "❌ Firebase CLI is not installed. Please install it first:"
    echo "npm install -g firebase-tools"
    exit 1
fi

# Check if logged in to Firebase
if ! firebase projects:list &> /dev/null; then
    echo "❌ Not logged in to Firebase. Please run 'firebase login' first."
    exit 1
fi

# Get current project
PROJECT=$(firebase use --active 2>/dev/null || echo "")
if [ -z "$PROJECT" ]; then
    echo "❌ No Firebase project selected. Please run 'firebase use <project-id>' first."
    exit 1
fi

echo "📋 Deploying to project: $PROJECT"

# Install dependencies
echo "📦 Installing dependencies..."
npm ci

# Run tests
echo "🧪 Running tests..."
npm test

# Build TypeScript
echo "🔨 Building TypeScript..."
npm run build

# Check if functions directory exists and has compiled JS files
if [ ! -f "lib/index.js" ]; then
    echo "❌ Build failed - lib/index.js not found"
    exit 1
fi

echo "✅ Build successful"

# Deploy functions
echo "🌟 Deploying functions..."
firebase deploy --only functions --force

echo "✅ Deployment complete!"
echo ""
echo "📊 View your functions at:"
echo "https://console.firebase.google.com/project/$PROJECT/functions"
echo ""
echo "📝 View logs with:"
echo "firebase functions:log"
echo ""
echo "🎉 Terra Cloud Functions are now live!"