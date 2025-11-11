import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'optimization_options.dart';
import 'optimization_result.dart';
import 'webp_encoder.dart';

/// Stub implementation for web compatibility
/// This implementation is fully WASM compatible and doesn't import dart:io
class ImageOptimizerStub {
  /// Optimizes an image file with the given options
  ///
  /// **Note**: This method is not available on web platforms.
  /// Use [optimizeBytes] for web compatibility.
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

  /// Optimizes image bytes with the given options (web-compatible)
  static Future<OptimizationResult> optimizeBytes(
    Uint8List inputBytes, {
    OptimizationOptions options = const OptimizationOptions(),
    String? outputPath,
  }) async {
    final stopwatch = Stopwatch()..start();

    try {
      final originalSize = inputBytes.length;
      final optimizedBytes = await _processImageBytes(inputBytes, options);

      stopwatch.stop();

      return OptimizationResult.success(
        outputPath: outputPath ?? 'web_optimized_image',
        originalSize: originalSize,
        optimizedSize: optimizedBytes.length,
        processingTimeMs: stopwatch.elapsedMilliseconds,
      );
    } catch (e) {
      stopwatch.stop();
      return OptimizationResult.failure(
        originalSize: inputBytes.length,
        errorMessage: 'Web optimization failed: $e',
        processingTimeMs: stopwatch.elapsedMilliseconds,
      );
    }
  }

  /// Processes image bytes according to the optimization options
  static Future<Uint8List> _processImageBytes(
    Uint8List inputBytes,
    OptimizationOptions options,
  ) async {
    final image = img.decodeImage(inputBytes);
    if (image == null) {
      throw Exception('Failed to decode image');
    }

    var processedImage = image;

    // Resize if dimensions are specified
    if (options.targetWidth != null || options.targetHeight != null) {
      processedImage = _resizeImage(
        processedImage,
        targetWidth: options.targetWidth,
        targetHeight: options.targetHeight,
        maintainAspectRatio: options.maintainAspectRatio,
      );
    }

    // Encode with maxFileSize enforcement
    return _encodeImageWithMaxSize(processedImage, options);
  }

  /// Resizes an image according to the specified dimensions
  static img.Image _resizeImage(
    img.Image image, {
    int? targetWidth,
    int? targetHeight,
    bool maintainAspectRatio = true,
  }) {
    if (targetWidth == null && targetHeight == null) {
      return image;
    }

    int newWidth = targetWidth ?? image.width;
    int newHeight = targetHeight ?? image.height;

    if (maintainAspectRatio) {
      if (targetWidth != null && targetHeight != null) {
        // Both dimensions specified, fit within bounds
        final aspectRatio = image.width / image.height;
        if (newWidth / newHeight > aspectRatio) {
          newWidth = (newHeight * aspectRatio).round();
        } else {
          newHeight = (newWidth / aspectRatio).round();
        }
      } else if (targetWidth != null) {
        // Only width specified
        newHeight = (targetWidth * image.height / image.width).round();
      } else {
        // Only height specified
        newWidth = (targetHeight! * image.width / image.height).round();
      }
    }

    return img.copyResize(
      image,
      width: newWidth,
      height: newHeight,
      interpolation: img.Interpolation.linear,
    );
  }

  /// Encodes an image according to the optimization options with maxFileSize enforcement
  static Uint8List _encodeImageWithMaxSize(
    img.Image image,
    OptimizationOptions options,
  ) {
    final format = _determineOutputFormat(image, options.outputFormat);

    // If maxFileSize is not specified, use simple encoding
    if (options.maxFileSize == null) {
      return _encodeImage(image, options, format);
    }

    // For PNG format, maxFileSize enforcement is limited
    // PNG is lossless, so we can only resize or convert to JPEG
    if (format == OutputFormat.png) {
      final pngBytes = Uint8List.fromList(img.encodePng(image));
      if (pngBytes.length <= options.maxFileSize!) {
        return pngBytes;
      }
      // PNG exceeds maxFileSize - try resizing first, then convert to JPEG if needed
      // Even if PNG was explicitly requested, we must enforce maxFileSize
      return _encodeImageWithQualityReduction(
        image,
        options.maxFileSize!,
        options.quality,
      );
    }

    // For JPEG and WebP (which falls back to JPEG), use quality reduction
    if (format == OutputFormat.jpeg || format == OutputFormat.webp) {
      return _encodeImageWithQualityReduction(
        image,
        options.maxFileSize!,
        options.quality,
      );
    }

    // For auto format, encode and check size
    Uint8List encodedBytes = _encodeImage(image, options, format);
    if (encodedBytes.length <= options.maxFileSize!) {
      return encodedBytes;
    }

    // If auto-detect chose PNG but it's too large, convert to JPEG with quality reduction
    return _encodeImageWithQualityReduction(
      image,
      options.maxFileSize!,
      options.quality,
    );
  }

  /// Encodes an image with iterative quality reduction to meet maxFileSize
  static Uint8List _encodeImageWithQualityReduction(
    img.Image image,
    int maxFileSize,
    int initialQuality, {
    int recursionDepth = 0,
  }) {
    // Prevent infinite recursion
    if (recursionDepth > 10) {
      // Return smallest possible image
      final smallestImage = img.copyResize(image, width: 50, height: 50);
      return Uint8List.fromList(img.encodeJpg(smallestImage, quality: 1));
    }

    int quality = initialQuality;
    Uint8List? bestResult;
    int bestSize = 0;

    // Try reducing quality in steps until we meet the size requirement
    // Allow quality to go as low as 1 for very small file sizes
    while (quality >= 1) {
      final encoded = Uint8List.fromList(
        img.encodeJpg(image, quality: quality),
      );

      if (encoded.length <= maxFileSize) {
        return encoded;
      }

      // Keep track of the best result (closest to maxFileSize)
      if (bestResult == null || encoded.length < bestSize) {
        bestResult = encoded;
        bestSize = encoded.length;
      }

      // Reduce quality more aggressively based on how far we are from target
      if (encoded.length > maxFileSize * 10) {
        quality -= 20; // Very far, reduce aggressively
      } else if (encoded.length > maxFileSize * 5) {
        quality -= 15;
      } else if (encoded.length > maxFileSize * 2) {
        quality -= 10;
      } else {
        quality -= 2; // Close to target, reduce slowly
      }
    }

    // If we couldn't meet the requirement, try resizing the image
    if (bestResult != null && bestResult.length > maxFileSize) {
      final aspectRatio = image.width / image.height;

      // Calculate target dimensions based on file size ratio
      double resizeFactor = 0.5; // Start with 50% reduction

      // If we're very far from target, resize more aggressively
      if (bestSize > maxFileSize * 5) {
        resizeFactor = 0.3;
      } else if (bestSize > maxFileSize * 2) {
        resizeFactor = 0.4;
      } else {
        resizeFactor = 0.6;
      }

      int newWidth = (image.width * resizeFactor).round();
      int newHeight = (newWidth / aspectRatio).round();

      // Allow resizing to very small sizes if needed (minimum 32x32)
      if (newWidth >= 32 && newHeight >= 32) {
        final resizedImage = img.copyResize(
          image,
          width: newWidth,
          height: newHeight,
          interpolation: img.Interpolation.linear,
        );
        return _encodeImageWithQualityReduction(
          resizedImage,
          maxFileSize,
          initialQuality,
          recursionDepth: recursionDepth + 1,
        );
      }
    }

    // Return best result even if it exceeds maxFileSize
    return bestResult ?? Uint8List.fromList(img.encodeJpg(image, quality: 1));
  }

  /// Encodes an image according to the optimization options
  static Uint8List _encodeImage(
    img.Image image,
    OptimizationOptions options,
    OutputFormat format,
  ) {
    switch (format) {
      case OutputFormat.jpeg:
        return Uint8List.fromList(
          img.encodeJpg(image, quality: options.quality),
        );
      case OutputFormat.png:
        return Uint8List.fromList(img.encodePng(image));
      case OutputFormat.webp:
        // Try to encode as WebP, fall back to JPEG if WebP encoding is not available
        final webpBytes = WebPEncoder.encodeWebP(
          image,
          quality: options.quality,
        );
        if (webpBytes != null) {
          return webpBytes;
        }
        // Fall back to JPEG with optimized settings if WebP encoding is not available
        return Uint8List.fromList(
          img.encodeJpg(image, quality: options.quality),
        );
      case OutputFormat.auto:
        // Auto-detect best format based on image characteristics
        if (_hasTransparency(image)) {
          return Uint8List.fromList(img.encodePng(image));
        } else {
          return Uint8List.fromList(
            img.encodeJpg(image, quality: options.quality),
          );
        }
    }
  }

  /// Determines the output format for encoding
  static OutputFormat _determineOutputFormat(
    img.Image image,
    OutputFormat preferredFormat,
  ) {
    if (preferredFormat != OutputFormat.auto) {
      return preferredFormat;
    }

    // Auto-detect based on image characteristics
    if (_hasTransparency(image)) {
      return OutputFormat.png;
    } else {
      return OutputFormat.jpeg;
    }
  }

  /// Checks if an image has transparency
  static bool _hasTransparency(img.Image image) {
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        // Check if pixel has alpha channel and if it's less than 255
        if (pixel.a < 255) {
          return true;
        }
      }
    }
    return false;
  }
}
