import 'dart:typed_data';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'optimization_options.dart';
import 'optimization_result.dart';

/// Native implementation selected via conditional import (io only).
class ImageOptimizerPlatform {
  /// Optimizes an image file with the given options
  static Future<OptimizationResult> optimizeFile(
    String inputPath, {
    OptimizationOptions options = const OptimizationOptions(),
    String? outputPath,
  }) async {
    final stopwatch = Stopwatch()..start();

    try {
      final inputFile = File(inputPath);
      if (!await inputFile.exists()) {
        stopwatch.stop();
        return OptimizationResult.failure(
          originalSize: 0,
          errorMessage: 'Input file does not exist: $inputPath',
          processingTimeMs: stopwatch.elapsedMilliseconds,
        );
      }

      final originalSize = await inputFile.length();
      final inputBytes = await inputFile.readAsBytes();

      final optimizedBytes = await _processImageBytes(inputBytes, options);

      // Use provided output path or generate one
      final finalOutputPath =
          outputPath ?? _generateOutputPath(inputPath, options);
      final outputFile = File(finalOutputPath);
      await outputFile.writeAsBytes(optimizedBytes);

      stopwatch.stop();

      return OptimizationResult.success(
        outputPath: finalOutputPath,
        originalSize: originalSize,
        optimizedSize: optimizedBytes.length,
        processingTimeMs: stopwatch.elapsedMilliseconds,
      );
    } catch (e) {
      stopwatch.stop();
      return OptimizationResult.failure(
        originalSize: 0,
        errorMessage: 'Optimization failed: $e',
        processingTimeMs: stopwatch.elapsedMilliseconds,
      );
    }
  }

  /// Optimizes image bytes with the given options
  static Future<OptimizationResult> optimizeBytes(
    Uint8List inputBytes, {
    OptimizationOptions options = const OptimizationOptions(),
    String? outputPath,
  }) async {
    final stopwatch = Stopwatch()..start();

    try {
      final originalSize = inputBytes.length;
      final optimizedBytes = await _processImageBytes(inputBytes, options);

      String? finalOutputPath;
      if (outputPath != null) {
        final outputFile = File(outputPath);
        await outputFile.writeAsBytes(optimizedBytes);
        finalOutputPath = outputPath;
      }

      stopwatch.stop();

      // If no output path was provided, we can't create a success result
      // since OptimizationResult.success requires a non-null outputPath
      if (finalOutputPath == null) {
        return OptimizationResult.failure(
          originalSize: originalSize,
          errorMessage: 'No output path provided for byte optimization',
          processingTimeMs: stopwatch.elapsedMilliseconds,
        );
      }

      return OptimizationResult.success(
        outputPath: finalOutputPath,
        originalSize: originalSize,
        optimizedSize: optimizedBytes.length,
        processingTimeMs: stopwatch.elapsedMilliseconds,
      );
    } catch (e) {
      stopwatch.stop();
      return OptimizationResult.failure(
        originalSize: inputBytes.length,
        errorMessage: 'Optimization failed: $e',
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

    return _encodeImage(processedImage, options);
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

  /// Encodes an image according to the optimization options
  static Uint8List _encodeImage(
    img.Image image,
    OptimizationOptions options,
  ) {
    final format = _determineOutputFormat(image, options.outputFormat);

    switch (format) {
      case OutputFormat.jpeg:
        return Uint8List.fromList(
          img.encodeJpg(image, quality: options.quality),
        );
      case OutputFormat.png:
        return Uint8List.fromList(img.encodePng(image));
      case OutputFormat.webp:
        // WebP encoding is not available in this version, fall back to JPEG
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

  /// Generates an output path for the optimized image
  static String _generateOutputPath(
      String inputPath, OptimizationOptions options) {
    final inputFile = File(inputPath);
    final directory = inputFile.parent.path;
    final nameWithoutExtension =
        inputFile.path.split(RegExp(r'[/\\]')).last.split('.').first;

    String extension;
    switch (options.outputFormat) {
      case OutputFormat.jpeg:
        extension = 'jpg';
        break;
      case OutputFormat.png:
        extension = 'png';
        break;
      case OutputFormat.webp:
        extension = 'webp';
        break;
      case OutputFormat.auto:
        extension = inputFile.path.split('.').last;
        break;
    }

    return '$directory${Platform.pathSeparator}${nameWithoutExtension}_optimized.$extension';
  }
}
