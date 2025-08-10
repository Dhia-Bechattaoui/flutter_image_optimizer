import 'dart:typed_data';
import 'optimization_options.dart';
import 'optimization_result.dart';

/// Stub implementation of ImageOptimizerNative for web platforms
///
/// This file provides stub implementations that throw UnsupportedError
/// when called on web platforms, ensuring WASM compatibility.
class ImageOptimizerNative {
  /// Optimizes an image file with the given options
  ///
  /// This method is not available on web platforms
  static Future<OptimizationResult> optimizeFile(
    String inputPath, {
    OptimizationOptions options = const OptimizationOptions(),
    String? outputPath,
  }) async {
    throw UnsupportedError(
      'File optimization is not supported on web platforms. '
      'Use optimizeBytes() instead for web compatibility.',
    );
  }

  /// Optimizes image bytes with the given options
  ///
  /// This method is not available on web platforms
  static Future<OptimizationResult> optimizeBytes(
    Uint8List inputBytes, {
    OptimizationOptions options = const OptimizationOptions(),
    String? outputPath,
  }) async {
    throw UnsupportedError(
      'Byte optimization is not supported on web platforms. '
      'Use the web-specific implementation instead.',
    );
  }
}
