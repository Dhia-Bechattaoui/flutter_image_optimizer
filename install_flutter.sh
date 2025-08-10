#!/bin/bash

# Flutter Image Optimizer - Development Environment Setup Script
# This script helps install Flutter and set up the development environment

echo "🚀 Setting up Flutter development environment for flutter_image_optimizer..."

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "📦 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "✅ Homebrew is already installed"
fi

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "📱 Installing Flutter..."
    brew install --cask flutter
else
    echo "✅ Flutter is already installed"
fi

# Check if Dart is installed
if ! command -v dart &> /dev/null; then
    echo "🎯 Installing Dart..."
    brew install dart
else
    echo "✅ Dart is already installed"
fi

# Verify installations
echo "🔍 Verifying installations..."

if command -v flutter &> /dev/null; then
    echo "✅ Flutter version:"
    flutter --version
else
    echo "❌ Flutter installation failed"
    exit 1
fi

if command -v dart &> /dev/null; then
    echo "✅ Dart version:"
    dart --version
else
    echo "❌ Dart installation failed"
    exit 1
fi

# Set up the project
echo "📁 Setting up the project..."
cd "$(dirname "$0")"

# Install dependencies
echo "📦 Installing project dependencies..."
flutter pub get

# Run analysis
echo "🔍 Running code analysis..."
flutter analyze

# Run tests
echo "🧪 Running tests..."
flutter test

echo "🎉 Setup complete! You can now:"
echo "  - Run 'flutter pub get' to install dependencies"
echo "  - Run 'flutter test' to run tests"
echo "  - Run 'flutter analyze' to check code quality"
echo "  - Run 'cd example && flutter run' to run the example app"
echo "  - Run 'dart run pana .' to analyze the package with Pana"
