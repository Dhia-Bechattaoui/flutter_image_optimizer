import 'dart:typed_data';
import 'optimization_options.dart';
import 'optimization_result.dart';

/// Common interface for image optimization implementations
///
/// This interface ensures that both web and native implementations
/// provide the same methods, making the package WASM compatible.
abstract class ImageOptimizerInterface {
  /// Optimizes an image file with the given options
  static Future<OptimizationResult> optimizeFile(
    String inputPath, {
    OptimizationOptions options = const OptimizationOptions(),
    String? outputPath,
  }) async {
    throw UnsupportedError('optimizeFile not implemented');
  }

  /// Optimizes image bytes with the given options
  static Future<OptimizationResult> optimizeBytes(
    Uint8List inputBytes, {
    OptimizationOptions options = const OptimizationOptions(),
    String? outputPath,
  }) async {
    throw UnsupportedError('optimizeBytes not implemented');
  }
}
