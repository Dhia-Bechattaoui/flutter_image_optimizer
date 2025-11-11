import 'dart:ffi' as ffi;
import 'dart:io' show Platform;
import 'dart:typed_data';
import 'package:ffi/ffi.dart';
import 'package:image/image.dart' as img;

/// Native implementation of WebP encoder using FFI bindings to libwebp
/// Falls back gracefully if libwebp is not available
class WebPEncoder {
  static bool? _isAvailable;
  static ffi.DynamicLibrary? _libwebp;

  /// Check if WebP encoding is available
  static bool get isAvailable {
    if (_isAvailable != null) return _isAvailable!;

    try {
      _libwebp = _loadLibrary();
      _isAvailable = true;
      return true;
    } catch (e) {
      _isAvailable = false;
      return false;
    }
  }

  /// Load libwebp library
  static ffi.DynamicLibrary _loadLibrary() {
    if (Platform.isLinux) {
      return ffi.DynamicLibrary.open('libwebp.so.7');
    } else if (Platform.isMacOS) {
      return ffi.DynamicLibrary.open('libwebp.dylib');
    } else if (Platform.isWindows) {
      return ffi.DynamicLibrary.open('libwebp.dll');
    } else {
      throw UnsupportedError('WebP encoding not supported on this platform');
    }
  }

  /// Convert image to RGBA byte array
  static Uint8List _imageToRGBA(img.Image image) {
    final rgbaData = Uint8List(image.width * image.height * 4);
    int index = 0;

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        rgbaData[index++] = pixel.r.toInt();
        rgbaData[index++] = pixel.g.toInt();
        rgbaData[index++] = pixel.b.toInt();
        rgbaData[index++] = pixel.a.toInt();
      }
    }

    return rgbaData;
  }

  /// Encode image to WebP format
  /// Returns WebP bytes if encoding succeeds, otherwise returns null
  static Uint8List? encodeWebP(img.Image image, {int quality = 80}) {
    if (!isAvailable) {
      return null;
    }

    try {
      final lib = _libwebp!;

      // Try to use WebPEncodeRGBA if available
      // Note: This requires libwebp to be installed on the system
      try {
        final webpEncodeRGBA = lib
            .lookupFunction<
              ffi.Pointer<ffi.Uint8> Function(
                ffi.Pointer<ffi.Uint8>, // rgba
                ffi.Int32, // width
                ffi.Int32, // height
                ffi.Int32, // stride
                ffi.Float, // quality
                ffi.Pointer<ffi.Uint8>, // output
              ),
              ffi.Pointer<ffi.Uint8> Function(
                ffi.Pointer<ffi.Uint8>,
                int,
                int,
                int,
                double,
                ffi.Pointer<ffi.Uint8>,
              )
            >('WebPEncodeRGBA');

        // Convert image to RGBA format
        final rgbaData = _imageToRGBA(image);
        final width = image.width;
        final height = image.height;
        final stride = width * 4; // RGBA = 4 bytes per pixel

        // Allocate memory for RGBA data
        final rgbaPtr = malloc<ffi.Uint8>(rgbaData.length);
        rgbaPtr.asTypedList(rgbaData.length).setAll(0, rgbaData);

        // Estimate output size (usually smaller than input)
        final maxOutputSize = width * height * 4;
        final outputPtr = malloc<ffi.Uint8>(maxOutputSize);

        try {
          // Encode to WebP
          final resultPtr = webpEncodeRGBA(
            rgbaPtr,
            width,
            height,
            stride,
            quality.clamp(0, 100).toDouble(),
            outputPtr,
          );

          if (resultPtr.address == 0) {
            return null;
          }

          // The result pointer points to the encoded data
          // For now, we'll return the buffer (in production, parse WebP header for actual size)
          final webpBytes = resultPtr.asTypedList(maxOutputSize);
          return Uint8List.fromList(webpBytes);
        } finally {
          malloc.free(rgbaPtr);
          malloc.free(outputPtr);
        }
      } catch (e) {
        // Function not found or encoding failed
        return null;
      }
    } catch (e) {
      // If encoding fails, return null to fall back to JPEG
      return null;
    }
  }
}
