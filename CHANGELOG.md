# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2025-01-11

### Added
- **Perfect Pana Score**: Achieved 160/160 points for package quality
- **Library Documentation**: Added comprehensive library-level documentation
- **Constructor Documentation**: Added documentation for all public constructors
- **Image Preview**: Added image preview and dimensions display in example app
- **Format Detection**: Added automatic format detection for output files

### Changed
- **SDK Requirements**: Updated Dart SDK to >=3.8.0 and Flutter to >=3.32.0
- **Package Metadata**: Added topics (flutter, image, optimization, compression, webp)
- **Funding Information**: Added GitHub Sponsors funding link
- **PNG maxFileSize Enforcement**: Improved PNG maxFileSize enforcement to convert to JPEG when needed
- **Code Formatting**: Applied Dart formatter to all source files

### Fixed
- **PNG maxFileSize Bug**: Fixed issue where PNG format with maxFileSize wasn't properly enforced
- **Linting Issues**: Fixed all linting warnings and formatting issues
- **Documentation Coverage**: Achieved 100% API documentation coverage
- **Static Analysis**: Resolved all static analysis issues for perfect score

## [0.0.3] - 2024-12-19

### Added
- **WASM Compatibility**: Full compatibility with Dart WebAssembly runtime
- **Enhanced Platform Detection**: Improved conditional import system for better cross-platform support
- **Stub Implementations**: Added stub implementations for web/WASM platforms

### Changed
- **Conditional Export Strategy**: Updated export strategy to default to WASM-safe implementations
- **Platform Routing**: Improved platform detection and routing for optimal performance
- **Import Chain**: Restructured import chain to avoid unconditional dart:io imports

### Fixed
- **WASM Runtime Issues**: Resolved package compatibility with Dart WebAssembly runtime
- **Platform Support**: Ensured all 6 platforms (iOS, Android, Web, Windows, macOS, Linux) are fully supported
- **Import Dependencies**: Eliminated unconditional dart:io imports that caused WASM compatibility issues

## [0.0.2] - 2024-08-10

### Added
- **Web Platform Support**: Full compatibility with Flutter Web
- **Conditional Imports**: Smart platform detection for dart:io compatibility
- **Universal Platform Coverage**: Now supports all 6 platforms (iOS, Android, Web, Windows, macOS, Linux)
- **Perfect Pana Score**: Achieved 160/160 points for package quality

### Changed
- **Enhanced Platform Compatibility**: Resolved dart:io web compatibility issues
- **Improved Package Structure**: Better conditional import handling for cross-platform support

## [0.0.1] - 2024-08-10

### Added
- Initial release of Flutter Image Optimizer package
- Core `ImageOptimizer` class with static optimization methods
- `OptimizationOptions` class for configurable optimization parameters
- `OptimizationResult` class for detailed optimization results
- Support for multiple output formats (JPEG, PNG, WebP)
- Automatic format detection based on image characteristics
- Image resizing with aspect ratio preservation
- Quality control for lossy formats
- File and byte-based optimization methods
- Comprehensive error handling and result reporting
- Processing time measurement
- File size reduction statistics

[Unreleased]: https://github.com/Dhia-Bechattaoui/flutter_image_optimizer/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/Dhia-Bechattaoui/flutter_image_optimizer/compare/v0.0.3...v0.1.0
[0.0.3]: https://github.com/Dhia-Bechattaoui/flutter_image_optimizer/compare/v0.0.2...v0.0.3
[0.0.2]: https://github.com/Dhia-Bechattaoui/flutter_image_optimizer/compare/v0.0.1...v0.0.2
[0.0.1]: https://github.com/Dhia-Bechattaoui/flutter_image_optimizer/releases/tag/v0.0.1
