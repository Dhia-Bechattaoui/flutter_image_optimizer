// Conditional export for native implementation.
// Default to the stub (WASM/html-safe) implementation, and only use the
// dart:io-based implementation when the io library is available.
export 'image_optimizer_native_stub.dart'
    if (dart.library.io) 'image_optimizer_native_impl.dart';
