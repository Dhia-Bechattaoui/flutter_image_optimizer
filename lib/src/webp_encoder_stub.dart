import 'dart:typed_data';
import 'package:image/image.dart' as img;

/// Stub implementation of WebP encoder (for web platforms)
/// Always returns false for availability and null for encoding
class WebPEncoder {
  static bool get isAvailable => false;

  static Uint8List? encodeWebP(img.Image image, {int quality = 80}) {
    return null; // WebP encoding not available on this platform
  }
}
