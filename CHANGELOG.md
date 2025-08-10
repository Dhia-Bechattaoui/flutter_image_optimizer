# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.0.3] - 2024-12-19

### Added
- **WASM Compatibility**: Full compatibility with Dart WebAssembly runtime
- **Enhanced Platform Detection**: Improved conditional import system for better cross-platform support
- **Stub Implementations**: Added stub implementations for web/WASM platforms

### Changed
- **Conditional Export Strategy**: Updated export strategy to default to WASM-safe implementations
- **Platform Routing**: Improved platform detection and routing for optimal performance
- **Import Chain**: Restructured import chain to avoid unconditional dart:io imports

### Technical Improvements
- Default to stub implementations on non-IO runtimes (WASM/web)
- Only use dart:io-based implementations when io library is available
- Enhanced conditional import system for better platform compatibility
- Maintained full native functionality while ensuring WASM compatibility

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

### Technical Improvements
- Conditional import implementation for web compatibility
- Maintained full native functionality while adding web support
- All optimization features work seamlessly across platforms

### Added
- Initial project setup
- Basic project structure and documentation

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

### Features
- **Image Optimization**: Compress images while maintaining quality
- **Format Conversion**: Convert between JPEG, PNG, and WebP formats
- **Smart Resizing**: Resize images with optional aspect ratio preservation
- **Quality Control**: Adjustable quality settings for lossy formats
- **Auto-detection**: Intelligent format selection based on image content
- **Performance Metrics**: Detailed optimization statistics and timing

### Supported Formats
- **Input**: JPEG, PNG, WebP, BMP, TIFF, and other common formats
- **Output**: JPEG, PNG, WebP with automatic format selection

### Dependencies
- `image: ^4.1.7` - Core image processing capabilities
- `path_provider: ^2.1.2` - File system access utilities
- `permission_handler: ^11.3.0` - Permission management for file access

---

## Version History

- **0.0.3**: Added WASM compatibility and enhanced platform detection system
- **0.0.2**: Added web platform support and achieved perfect Pana score (160/160)
- **0.0.1**: Initial release with core image optimization functionality

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
