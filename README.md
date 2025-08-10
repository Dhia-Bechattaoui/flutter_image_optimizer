# Flutter Image Optimizer

[![Pub](https://img.shields.io/pub/v/flutter_image_optimizer.svg)](https://pub.dev/packages/flutter_image_optimizer)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.10+-blue.svg)](https://flutter.dev)

A powerful Flutter package for automatic image optimization, compression, and format conversion. Optimize your images to reduce file sizes while maintaining quality, perfect for mobile apps that need to handle images efficiently.

## Features

🚀 **High Performance**: Fast image processing with minimal memory usage
🖼️ **Multiple Formats**: Support for JPEG, PNG, WebP with automatic format detection
📏 **Smart Resizing**: Resize images with optional aspect ratio preservation
⚡ **Quality Control**: Adjustable quality settings for lossy formats
🔍 **Auto-detection**: Intelligent format selection based on image characteristics
📊 **Detailed Metrics**: Comprehensive optimization statistics and timing
🛡️ **Error Handling**: Robust error handling with detailed result reporting

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_image_optimizer: ^0.0.3
```

Then run:

```bash
flutter pub get
```

## Quick Start

```dart
import 'package:flutter_image_optimizer/flutter_image_optimizer.dart';

// Optimize an image file
final result = await ImageOptimizer.optimizeFile(
  '/path/to/image.jpg',
  options: OptimizationOptions(
    quality: 80,
    targetWidth: 800,
    maintainAspectRatio: true,
    outputFormat: OutputFormat.webp,
  ),
);

if (result.success) {
  print('Optimized: ${result.outputPath}');
  print('Size reduction: ${result.sizeReductionPercentage?.toStringAsFixed(1)}%');
} else {
  print('Error: ${result.errorMessage}');
}
```

## Usage Examples

### Basic Image Optimization

```dart
// Simple optimization with default settings
final result = await ImageOptimizer.optimizeFile('/path/to/image.png');

if (result.success) {
  print('Original size: ${result.originalSize} bytes');
  print('Optimized size: ${result.optimizedSize} bytes');
  print('Compression ratio: ${result.compressionRatio?.toStringAsFixed(2)}');
}
```

### Custom Optimization Options

```dart
final options = OptimizationOptions(
  quality: 75,                    // JPEG/WebP quality (0-100)
  targetWidth: 1024,             // Target width
  targetHeight: 768,              // Target height
  maintainAspectRatio: true,      // Preserve aspect ratio
  outputFormat: OutputFormat.auto, // Auto-detect best format
  maxFileSize: 500 * 1024,       // Max 500KB
);

final result = await ImageOptimizer.optimizeFile(
  '/path/to/large_image.jpg',
  options: options,
);
```

### Optimize Image Bytes

```dart
// Optimize image from bytes (e.g., from network or memory)
final imageBytes = await http.get(Uri.parse('https://example.com/image.jpg'));
final result = await ImageOptimizer.optimizeBytes(
  imageBytes.bodyBytes,
  options: OptimizationOptions(
    quality: 85,
    outputFormat: OutputFormat.jpeg,
  ),
);
```

### Batch Processing

```dart
final imagePaths = [
  '/path/to/image1.jpg',
  '/path/to/image2.png',
  '/path/to/image3.webp',
];

final results = await Future.wait(
  imagePaths.map((path) => ImageOptimizer.optimizeFile(path)),
);

for (int i = 0; i < results.length; i++) {
  final result = results[i];
  if (result.success) {
    print('${imagePaths[i]}: ${result.sizeReductionPercentage?.toStringAsFixed(1)}% reduction');
  }
}
```

## API Reference

### ImageOptimizer

The main class providing static methods for image optimization.

#### Methods

- `optimizeFile(String inputPath, {OptimizationOptions? options, String? outputPath})`
- `optimizeBytes(Uint8List inputBytes, {OptimizationOptions? options, String? outputPath})`

### OptimizationOptions

Configuration options for image optimization.

```dart
class OptimizationOptions {
  final int quality;                    // 0-100, default: 85
  final int? targetWidth;              // Target width in pixels
  final int? targetHeight;             // Target height in pixels
  final bool maintainAspectRatio;      // Default: true
  final OutputFormat outputFormat;     // Default: OutputFormat.auto
  final int? maxFileSize;              // Max file size in bytes
}
```

### OutputFormat

Supported output formats:

- `OutputFormat.auto` - Automatically choose the best format
- `OutputFormat.jpeg` - JPEG format (lossy, good for photos)
- `OutputFormat.png` - PNG format (lossless, good for graphics)
- `OutputFormat.webp` - WebP format (modern, efficient)

### OptimizationResult

Result of an optimization operation.

```dart
class OptimizationResult {
  final bool success;                   // Whether optimization succeeded
  final String? outputPath;            // Path to optimized file
  final int originalSize;              // Original file size in bytes
  final int? optimizedSize;            // Optimized file size in bytes
  final double? compressionRatio;      // Size ratio (0.0 to 1.0)
  final String? errorMessage;          // Error message if failed
  final int processingTimeMs;          // Processing time in milliseconds
  
  // Computed properties
  int? get sizeReduction;              // Size reduction in bytes
  double? get sizeReductionPercentage; // Size reduction percentage
}
```

## Performance Tips

1. **Batch Processing**: Use `Future.wait()` for processing multiple images concurrently
2. **Memory Management**: For large images, consider processing in chunks
3. **Format Selection**: Use `OutputFormat.auto` for best results
4. **Quality Settings**: Balance between file size and quality (75-85 is usually optimal)

## Supported Platforms

- ✅ Android
- ✅ iOS
- ✅ macOS
- ✅ Windows
- ✅ Linux
- ✅ Web (with limitations)

## Dependencies

- `image: ^4.1.7` - Core image processing capabilities
- `path_provider: ^2.1.2` - File system access utilities
- `permission_handler: ^11.3.0` - Permission management for file access

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you encounter any issues or have questions, please:

1. Check the [documentation](https://pub.dev/packages/flutter_image_optimizer)
2. Search [existing issues](https://github.com/Dhia-Bechattaoui/flutter_image_optimizer/issues)
3. Create a [new issue](https://github.com/Dhia-Bechattaoui/flutter_image_optimizer/issues/new)

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a detailed history of changes.
