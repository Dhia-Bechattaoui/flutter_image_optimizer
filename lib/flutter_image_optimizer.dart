library;

/// Flutter Image Optimizer
///
/// A powerful Flutter package for automatic image optimization, compression,
/// and format conversion. Optimize your images to reduce file sizes while
/// maintaining quality, perfect for mobile apps that need to handle images efficiently.
///
/// Supports multiple platforms: iOS, Android, Web, Windows, macOS, and Linux.
///
/// Example:
/// ```dart
/// import 'package:flutter_image_optimizer/flutter_image_optimizer.dart';
///
/// final result = await ImageOptimizer.optimizeFile(
///   '/path/to/image.jpg',
///   options: OptimizationOptions(quality: 80),
/// );
/// ```

export 'src/image_optimizer.dart';
export 'src/optimization_options.dart';
export 'src/optimization_result.dart';
