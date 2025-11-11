import 'dart:typed_data';
import 'optimization_options.dart';
import 'optimization_result.dart';
import 'platform_detector.dart';

// Conditional import exposes a unified implementation symbol `impl`.
// On web/WASM, this imports `image_optimizer_web.dart` (no dart:io).
// On native (io), this imports `image_optimizer_native_impl.dart` (uses dart:io).
import 'image_optimizer_web.dart'
    if (dart.library.io) 'image_optimizer_native_impl.dart'
    as impl;

/// Cross-platform image optimization facade.
///
/// This class provides a unified interface for image optimization across all
/// supported platforms (Android, iOS, Web, Windows, macOS, Linux).
///
/// The class automatically selects the appropriate implementation based on the
/// current platform and provides methods for both file-based and byte-based
/// image optimization.
///
/// This class cannot be instantiated. Use the static methods instead.
class ImageOptimizer {
  /// Private constructor to prevent instantiation.
  ImageOptimizer._();

  /// Optimizes an image file on the local filesystem.
  ///
  /// [inputPath] should be the path to the input image file.
  /// [options] provides configuration for the optimization process.
  /// [outputPath] is optional - if not provided, a temporary file will be created.
  ///
  /// Returns a [Future<OptimizationResult>] containing the optimization results.
  ///
  /// Example:
  /// ```dart
  /// final result = await ImageOptimizer.optimizeFile(
  ///   '/path/to/image.jpg',
  ///   options: OptimizationOptions(quality: 80),
  /// );
  /// ```
  static Future<OptimizationResult> optimizeFile(
    String inputPath, {
    OptimizationOptions options = const OptimizationOptions(),
    String? outputPath,
  }) {
    return impl.ImageOptimizerPlatform.optimizeFile(
      inputPath,
      options: options,
      outputPath: outputPath,
    );
  }

  /// Optimizes image data from bytes (e.g., from network or memory).
  ///
  /// [inputBytes] should contain the raw image data.
  /// [options] provides configuration for the optimization process.
  /// [outputPath] is optional - if not provided, a temporary file will be created.
  ///
  /// Returns a [Future<OptimizationResult>] containing the optimization results.
  ///
  /// Example:
  /// ```dart
  /// final imageBytes = await http.get(Uri.parse('https://example.com/image.jpg'));
  /// final result = await ImageOptimizer.optimizeBytes(
  ///   imageBytes.bodyBytes,
  ///   options: OptimizationOptions(quality: 85),
  /// );
  /// ```
  static Future<OptimizationResult> optimizeBytes(
    Uint8List inputBytes, {
    OptimizationOptions options = const OptimizationOptions(),
    String? outputPath,
  }) {
    return impl.ImageOptimizerPlatform.optimizeBytes(
      inputBytes,
      options: options,
      outputPath: outputPath,
    );
  }

  /// Whether file-based optimization is supported on the current platform.
  ///
  /// Returns `true` if the platform supports file system operations,
  /// `false` otherwise (e.g., on web platforms).
  static bool get isFileOptimizationSupported =>
      PlatformDetector.supportsFileOperations;

  /// Whether the current platform is web-based.
  ///
  /// Returns `true` if running on web, `false` for native platforms.
  static bool get isWeb => PlatformDetector.isWeb;

  /// A human-readable description of the current platform.
  ///
  /// Returns a string describing the platform (e.g., "Android", "iOS", "Web").
  static String get platformType => PlatformDetector.platformDescription;
}
