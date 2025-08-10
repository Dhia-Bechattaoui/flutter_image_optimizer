#!/bin/bash

# Flutter Image Optimizer - Package Analysis Script
# This script analyzes the package with Pana and provides recommendations

echo "🔍 Analyzing flutter_image_optimizer package with Pana..."

# Check if pana is installed
if ! command -v pana &> /dev/null; then
    echo "📦 Installing Pana..."
    dart pub global activate pana
else
    echo "✅ Pana is already installed"
fi

# Run Pana analysis
echo "📊 Running Pana analysis..."
pana . --no-warning

echo ""
echo "📋 Pana Analysis Complete!"
echo ""
echo "🎯 To achieve a full 160/160 score, ensure you have:"
echo ""
echo "📚 Documentation (40 points):"
echo "  ✅ README.md with comprehensive content"
echo "  ✅ CHANGELOG.md following Keep a Changelog format"
echo "  ✅ API documentation in code"
echo "  ✅ Example code and usage"
echo ""
echo "🧪 Testing (30 points):"
echo "  ✅ Unit tests with good coverage"
echo "  ✅ Integration tests if applicable"
echo "  ✅ Test files in test/ directory"
echo ""
echo "🔧 Code Quality (30 points):"
echo "  ✅ analysis_options.yaml configured"
echo "  ✅ No linter warnings or errors"
echo "  ✅ Proper null safety usage"
echo "  ✅ Clean, readable code"
echo ""
echo "📦 Package Structure (30 points):"
echo "  ✅ Proper pubspec.yaml configuration"
echo "  ✅ Correct directory structure"
echo "  ✅ Example app in example/ directory"
echo "  ✅ Proper exports in main library file"
echo ""
echo "🌐 Platform Support (30 points):"
echo "  ✅ Cross-platform compatibility"
echo "  ✅ Proper platform-specific code if needed"
echo "  ✅ Web support considerations"
echo ""
echo "📱 Flutter Integration (0 points - bonus for Flutter packages):"
echo "  ✅ Proper Flutter SDK constraints"
echo "  ✅ Flutter-specific features if applicable"
echo ""
echo "🚀 Next steps:"
echo "  1. Install Flutter: ./install_flutter.sh"
echo "  2. Install dependencies: flutter pub get"
echo "  3. Fix any linter issues: flutter analyze"
echo "  4. Run tests: flutter test"
echo "  5. Re-run Pana analysis: pana ."
echo ""
echo "💡 Tips for high scores:"
echo "  - Ensure all tests pass"
echo "  - Fix all linter warnings"
echo "  - Add comprehensive documentation"
echo "  - Include practical examples"
echo "  - Follow Flutter best practices"
