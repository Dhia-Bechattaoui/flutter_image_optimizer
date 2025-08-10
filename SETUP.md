# Flutter Image Optimizer - Setup Guide

This guide will help you set up the development environment and achieve a full Pana score of 160/160.

## Prerequisites

- macOS (for this setup guide)
- Terminal access
- Internet connection

## Quick Setup

### Option 1: Automated Setup (Recommended)

Run the automated setup script:

```bash
./install_flutter.sh
```

This script will:
- Install Homebrew (if not present)
- Install Flutter and Dart
- Set up the project dependencies
- Run initial analysis and tests

### Option 2: Manual Setup

If you prefer to install manually, follow these steps:

#### 1. Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### 2. Install Flutter

```bash
brew install --cask flutter
```

#### 3. Install Dart

```bash
brew install dart
```

#### 4. Verify Installation

```bash
flutter --version
dart --version
```

## Project Setup

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Run Code Analysis

```bash
flutter analyze
```

### 3. Run Tests

```bash
flutter test
```

### 4. Run Example App

```bash
cd example
flutter run
```

## Achieving Full Pana Score (160/160)

### Pana Analysis

Pana is a tool that analyzes Dart packages and provides a score based on various criteria. To achieve a full score:

```bash
# Install Pana
dart pub global activate pana

# Run analysis
pana . --no-warning
```

### Score Breakdown

#### Documentation (40 points)
- ✅ **README.md**: Comprehensive documentation with examples
- ✅ **CHANGELOG.md**: Following Keep a Changelog format
- ✅ **API Documentation**: Inline documentation for all public APIs
- ✅ **Examples**: Working example app and code samples

#### Testing (30 points)
- ✅ **Unit Tests**: Tests for all classes and methods
- ✅ **Test Coverage**: High test coverage percentage
- ✅ **Test Organization**: Well-structured test files

#### Code Quality (30 points)
- ✅ **Analysis Options**: Proper `analysis_options.yaml` configuration
- ✅ **Linting**: No linter warnings or errors
- ✅ **Null Safety**: Proper null safety implementation
- ✅ **Code Style**: Following Dart style guidelines

#### Package Structure (30 points)
- ✅ **pubspec.yaml**: Proper package configuration
- ✅ **Directory Structure**: Correct Flutter package layout
- ✅ **Example App**: Functional example application
- ✅ **Library Exports**: Proper exports in main library file

#### Platform Support (30 points)
- ✅ **Cross-Platform**: Works on multiple platforms
- ✅ **Platform-Specific Code**: Proper platform handling
- ✅ **Web Support**: Web compatibility considerations

## Project Structure

```
flutter_image_optimizer/
├── lib/
│   ├── flutter_image_optimizer.dart    # Main library file
│   └── src/
│       ├── image_optimizer.dart        # Core optimization logic
│       ├── optimization_options.dart   # Configuration options
│       └── optimization_result.dart    # Result data classes
├── test/
│   └── flutter_image_optimizer_test.dart
├── example/
│   ├── lib/
│   │   └── main.dart
│   └── pubspec.yaml
├── pubspec.yaml                        # Package configuration
├── analysis_options.yaml               # Analysis configuration
├── README.md                           # Package documentation
├── CHANGELOG.md                        # Version history
├── LICENSE                             # MIT License
├── CONTRIBUTING.md                     # Contribution guidelines
├── .gitignore                          # Git ignore rules
├── install_flutter.sh                  # Flutter installation script
├── analyze_package.sh                  # Pana analysis script
└── SETUP.md                            # This file
```

## Development Workflow

### 1. Make Changes

Edit the source files in the `lib/` directory.

### 2. Run Analysis

```bash
flutter analyze
```

### 3. Run Tests

```bash
flutter test
```

### 4. Check Pana Score

```bash
./analyze_package.sh
```

### 5. Commit Changes

```bash
git add .
git commit -m "feat: add new optimization feature"
```

## Common Issues and Solutions

### Flutter Not Found

If Flutter is not in your PATH:

```bash
export PATH="$PATH:$HOME/flutter/bin"
```

Add this to your `~/.zshrc` or `~/.bash_profile` for persistence.

### Dependencies Not Found

If you get import errors:

```bash
flutter clean
flutter pub get
```

### Analysis Errors

Fix linter issues:

```bash
flutter analyze
dart fix --apply
```

### Test Failures

Run tests with verbose output:

```bash
flutter test --verbose
```

## Publishing to pub.dev

### 1. Verify Package

```bash
flutter pub publish --dry-run
```

### 2. Publish Package

```bash
flutter pub publish
```

### 3. Verify Pana Score

After publishing, check your package score on pub.dev.

## Support

If you encounter issues:

1. Check this setup guide
2. Run `./analyze_package.sh` for diagnostics
3. Check Flutter documentation
4. Open an issue on GitHub

## Next Steps

1. ✅ Complete the setup
2. ✅ Run initial analysis
3. ✅ Fix any issues found
4. ✅ Achieve full Pana score
5. ✅ Publish to pub.dev

Good luck with your Flutter Image Optimizer package! 🚀
