import 'dart:typed_data';
import 'optimization_options.dart';
import 'optimization_result.dart';
import 'platform_detector.dart';

// Conditional import exposes a unified implementation symbol `impl`.
// On web/WASM, this imports `image_optimizer_web.dart` (no dart:io).
// On native (io), this imports `image_optimizer_native_impl.dart` (uses dart:io).
import 'image_optimizer_web.dart'
    if (dart.library.io) 'image_optimizer_native_impl.dart' as impl;

/// Cross-platform image optimization facade.
class ImageOptimizer {
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

  static bool get isFileOptimizationSupported =>
      PlatformDetector.supportsFileOperations;

  static bool get isWeb => PlatformDetector.isWeb;

  static String get platformType => PlatformDetector.platformDescription;
}
