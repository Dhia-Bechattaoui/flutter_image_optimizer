/// Web-specific implementation of platform detection
///
/// This file provides web platform detection that is fully WASM compatible.
/// It will be used when building for web platforms.
class PlatformDetector {
  /// Checks if the current platform is web
  ///
  /// This implementation always returns true for web builds
  static bool get isWeb => true;

  /// Checks if the current platform supports file operations
  ///
  /// Web platforms don't support direct file system access
  static bool get supportsFileOperations => false;

  /// Gets a human-readable description of the current platform
  static String get platformDescription => 'Web (WASM compatible)';
}
