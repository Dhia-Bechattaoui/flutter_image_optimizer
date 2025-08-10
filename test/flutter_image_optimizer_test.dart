import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_image_optimizer/flutter_image_optimizer.dart';

void main() {
  group('OptimizationOptions', () {
    test('should create with default values', () {
      const options = OptimizationOptions();

      expect(options.quality, equals(85));
      expect(options.targetWidth, isNull);
      expect(options.targetHeight, isNull);
      expect(options.maintainAspectRatio, isTrue);
      expect(options.outputFormat, equals(OutputFormat.auto));
      expect(options.maxFileSize, isNull);
    });

    test('should create with custom values', () {
      const options = OptimizationOptions(
        quality: 75,
        targetWidth: 800,
        targetHeight: 600,
        maintainAspectRatio: false,
        outputFormat: OutputFormat.webp,
        maxFileSize: 1024 * 1024,
      );

      expect(options.quality, equals(75));
      expect(options.targetWidth, equals(800));
      expect(options.targetHeight, equals(600));
      expect(options.maintainAspectRatio, isFalse);
      expect(options.outputFormat, equals(OutputFormat.webp));
      expect(options.maxFileSize, equals(1024 * 1024));
    });

    test('should create copy with modified values', () {
      const original = OptimizationOptions(quality: 80);
      final modified = original.copyWith(quality: 90, targetWidth: 1024);

      expect(modified.quality, equals(90));
      expect(modified.targetWidth, equals(1024));
      expect(modified.targetHeight, isNull);
      expect(modified.maintainAspectRatio, isTrue);
      expect(modified.outputFormat, equals(OutputFormat.auto));
      expect(modified.maxFileSize, isNull);
    });
  });

  group('OptimizationResult', () {
    test('should create successful result', () {
      final result = OptimizationResult.success(
        outputPath: '/path/to/optimized.jpg',
        originalSize: 1000000,
        optimizedSize: 500000,
        processingTimeMs: 150,
      );

      expect(result.success, isTrue);
      expect(result.outputPath, equals('/path/to/optimized.jpg'));
      expect(result.originalSize, equals(1000000));
      expect(result.optimizedSize, equals(500000));
      expect(result.compressionRatio, equals(0.5));
      expect(result.errorMessage, isNull);
      expect(result.processingTimeMs, equals(150));
      expect(result.sizeReduction, equals(500000));
      expect(result.sizeReductionPercentage, equals(50.0));
    });

    test('should create failed result', () {
      final result = OptimizationResult.failure(
        originalSize: 1000000,
        errorMessage: 'File not found',
        processingTimeMs: 50,
      );

      expect(result.success, isFalse);
      expect(result.outputPath, isNull);
      expect(result.originalSize, equals(1000000));
      expect(result.optimizedSize, isNull);
      expect(result.compressionRatio, isNull);
      expect(result.errorMessage, equals('File not found'));
      expect(result.processingTimeMs, equals(50));
      expect(result.sizeReduction, isNull);
      expect(result.sizeReductionPercentage, isNull);
    });

    test('should calculate size reduction correctly', () {
      final result = OptimizationResult.success(
        outputPath: '/path/to/optimized.jpg',
        originalSize: 2000000,
        optimizedSize: 800000,
        processingTimeMs: 200,
      );

      expect(result.sizeReduction, equals(1200000));
      expect(result.sizeReductionPercentage, equals(60.0));
    });

    test('should handle zero original size', () {
      final result = OptimizationResult.success(
        outputPath: '/path/to/optimized.jpg',
        originalSize: 0,
        optimizedSize: 0,
        processingTimeMs: 100,
      );

      expect(result.compressionRatio, equals(1.0));
      expect(result.sizeReduction, equals(0));
      expect(result.sizeReductionPercentage, equals(0.0));
    });
  });

  group('OutputFormat', () {
    test('should have correct values', () {
      expect(OutputFormat.auto.index, equals(0));
      expect(OutputFormat.jpeg.index, equals(1));
      expect(OutputFormat.png.index, equals(2));
      expect(OutputFormat.webp.index, equals(3));
    });
  });

  group('ImageOptimizer', () {
    // Note: These tests would require actual image files and proper setup
    // In a real scenario, you'd want to create test images and mock file operations

    test('should have static methods', () {
      expect(ImageOptimizer.optimizeFile, isNotNull);
      expect(ImageOptimizer.optimizeBytes, isNotNull);
    });
  });
}
