/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

/// Extension on String to provide image creation utilities for the Scandit SDK
extension ScanditImageExtensions on String {
  /// Creates an Image widget from either a base64-encoded string or a file path.
  ///
  /// Automatically detects the source type:
  /// - If the source starts with common file path patterns (/), treats it as a file path
  /// - If the source contains base64 padding (=) or is valid base64, treats it as base64
  /// - Optimizes loading with error handling for both cases
  ///
  /// Returns null if the source is empty or if both methods fail.
  Image? toImage() {
    if (isEmpty) return null;

    try {
      if (_isFilePath()) {
        // Normalize potential file:// URIs
        String path = this;
        if (startsWith('file://')) {
          try {
            path = Uri.parse(this).toFilePath();
          } catch (_) {
            path = replaceFirst('file://', '');
          }
        }
        final file = File(path);
        if (file.existsSync()) {
          return Image.file(
            file,
            errorBuilder: (context, error, stackTrace) {
              // Fallback to base64 if file loading fails
              return _createImageFromBase64();
            },
          );
        }
      }

      // Try as base64
      return _createImageFromBase64();
    } catch (e) {
      // Return null if both methods fail
      return null;
    }
  }

  /// Determines if this string represents a file path
  bool _isFilePath() {
    // Check for common file path patterns
    return startsWith('/') ||
        startsWith('file://') ||
        contains('\\') || // Windows paths
        (length > 1 && this[1] == ':'); // Windows drive letters
  }

  /// Creates an Image from this base64 string with error handling
  Image _createImageFromBase64() {
    try {
      final bytes = base64Decode(this);
      return Image.memory(
        bytes,
        errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
      );
    } on FormatException {
      return Image(
        image: MemoryImage(Uint8List.fromList([0])),
        errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
      );
    }
  }
}

/// Extension on nullable String for image creation
extension ScanditNullableImageExtensions on String? {
  /// Creates an Image widget from either a base64-encoded string or a file path.
  /// Returns null if the source is null, empty, or if both methods fail.
  Image? toImage() {
    return this?.toImage();
  }
}
