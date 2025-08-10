/// Configuration options for image optimization
class OptimizationOptions {
  /// Target quality for JPEG images (0-100)
  final int quality;

  /// Target width for the optimized image (null to maintain aspect ratio)
  final int? targetWidth;

  /// Target height for the optimized image (null to maintain aspect ratio)
  final int? targetHeight;

  /// Whether to maintain aspect ratio when resizing
  final bool maintainAspectRatio;

  /// Output format for the optimized image
  final OutputFormat outputFormat;

  /// Maximum file size in bytes (null for no limit)
  final int? maxFileSize;

  const OptimizationOptions({
    this.quality = 85,
    this.targetWidth,
    this.targetHeight,
    this.maintainAspectRatio = true,
    this.outputFormat = OutputFormat.auto,
    this.maxFileSize,
  });

  /// Creates a copy of this object with the given fields replaced
  OptimizationOptions copyWith({
    int? quality,
    int? targetWidth,
    int? targetHeight,
    bool? maintainAspectRatio,
    OutputFormat? outputFormat,
    int? maxFileSize,
  }) {
    return OptimizationOptions(
      quality: quality ?? this.quality,
      targetWidth: targetWidth ?? this.targetWidth,
      targetHeight: targetHeight ?? this.targetHeight,
      maintainAspectRatio: maintainAspectRatio ?? this.maintainAspectRatio,
      outputFormat: outputFormat ?? this.outputFormat,
      maxFileSize: maxFileSize ?? this.maxFileSize,
    );
  }
}

/// Supported output formats for image optimization
enum OutputFormat {
  /// Automatically choose the best format
  auto,

  /// JPEG format
  jpeg,

  /// PNG format
  png,

  /// WebP format
  webp,
}
