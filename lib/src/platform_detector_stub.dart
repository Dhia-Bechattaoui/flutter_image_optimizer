/// Stub implementation of platform detection for native platforms
///
/// This file provides a default implementation that assumes native platform.
/// It will be replaced by web-specific implementations when building for web.
class PlatformDetector {
  /// Checks if the current platform is web
  ///
  /// Default implementation assumes native platform
  static bool get isWeb => false;

  /// Checks if the current platform supports file operations
  ///
  /// Default implementation assumes native platform
  static bool get supportsFileOperations => true;

  /// Gets a human-readable description of the current platform
  static String get platformDescription =>
      'Native (iOS, Android, Windows, macOS, Linux)';
}
