import 'dart:typed_data';
import 'package:image/image.dart' as img;

// Conditional import for FFI (only on native platforms)
import 'webp_encoder_stub.dart'
    if (dart.library.ffi) 'webp_encoder_native.dart'
    as webp_impl;

/// WebP encoder that attempts to encode images to WebP format
/// Falls back to JPEG encoding if WebP encoding is not available
class WebPEncoder {
  /// Check if WebP encoding is available
  static bool get isAvailable => webp_impl.WebPEncoder.isAvailable;

  /// Encode image to WebP format
  /// Returns WebP bytes if encoding succeeds, otherwise returns null
  static Uint8List? encodeWebP(img.Image image, {int quality = 80}) {
    return webp_impl.WebPEncoder.encodeWebP(image, quality: quality);
  }
}
