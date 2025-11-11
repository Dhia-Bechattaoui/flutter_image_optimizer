/// Result of an image optimization operation
class OptimizationResult {
  /// Whether the optimization was successful
  final bool success;

  /// Path to the optimized image file
  final String? outputPath;

  /// Original file size in bytes
  final int originalSize;

  /// Optimized file size in bytes
  final int? optimizedSize;

  /// Compression ratio (0.0 to 1.0, where 1.0 means no compression)
  final double? compressionRatio;

  /// Error message if optimization failed
  final String? errorMessage;

  /// Processing time in milliseconds
  final int processingTimeMs;

  /// Creates a new [OptimizationResult] instance.
  ///
  /// Prefer using [OptimizationResult.success] or [OptimizationResult.failure]
  /// factory constructors instead of this constructor directly.
  const OptimizationResult({
    required this.success,
    this.outputPath,
    required this.originalSize,
    this.optimizedSize,
    this.compressionRatio,
    this.errorMessage,
    required this.processingTimeMs,
  });

  /// Creates a successful optimization result
  factory OptimizationResult.success({
    required String outputPath,
    required int originalSize,
    required int optimizedSize,
    required int processingTimeMs,
  }) {
    double? compressionRatio;
    if (originalSize > 0) {
      compressionRatio = optimizedSize / originalSize;
    } else if (optimizedSize == 0) {
      compressionRatio = 1.0; // Both are 0, consider it no compression
    } else {
      compressionRatio =
          0.0; // Original is 0 but optimized is not, consider it full compression
    }

    return OptimizationResult(
      success: true,
      outputPath: outputPath,
      originalSize: originalSize,
      optimizedSize: optimizedSize,
      compressionRatio: compressionRatio,
      processingTimeMs: processingTimeMs,
    );
  }

  /// Creates a failed optimization result
  factory OptimizationResult.failure({
    required int originalSize,
    required String errorMessage,
    required int processingTimeMs,
  }) {
    return OptimizationResult(
      success: false,
      originalSize: originalSize,
      errorMessage: errorMessage,
      processingTimeMs: processingTimeMs,
    );
  }

  /// File size reduction in bytes
  int? get sizeReduction {
    if (optimizedSize == null) return null;
    return originalSize - optimizedSize!;
  }

  /// File size reduction percentage
  double? get sizeReductionPercentage {
    if (optimizedSize == null) return null;
    if (originalSize == 0) {
      return optimizedSize == 0
          ? 0.0
          : null; // 0% reduction if both are 0, null if original is 0 but optimized is not
    }
    return ((originalSize - optimizedSize!) / originalSize) * 100;
  }

  @override
  String toString() {
    if (success) {
      return 'OptimizationResult(success: true, '
          'originalSize: ${originalSize}bytes, '
          'optimizedSize: ${optimizedSize}bytes, '
          'compressionRatio: ${compressionRatio?.toStringAsFixed(2)}, '
          'processingTime: ${processingTimeMs}ms)';
    } else {
      return 'OptimizationResult(success: false, '
          'error: $errorMessage, '
          'processingTime: ${processingTimeMs}ms)';
    }
  }
}
