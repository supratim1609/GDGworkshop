#!/bin/bash
echo "🔥 Setting up Firebase for Project: fluttergdgdemoapp..."

# 1. Activate FlutterFire CLI
echo "📦 Activating FlutterFire CLI..."
dart pub global activate flutterfire_cli

# 2. Configure App (Force Re-config)
echo "⚙️ Configuring Firebase Options..."
# Try to run it. If it fails (e.g. not logged in), prompt user.
export PATH="$PATH":"$HOME/.pub-cache/bin"
flutterfire configure --project=fluttergdgdemoapp --platforms=android,ios,macos,web --yes

if [ $? -ne 0 ]; then
    echo "⚠️  Auto-configuration failed. You might need to login."
    echo "👉 Run: firebase login"
    echo "👉 Then run this script again."
    exit 1
fi

echo "✅ Firebase Configured Successfully!"
