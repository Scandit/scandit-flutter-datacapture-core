/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

/// Defines the alignment of the text in its view.
///
/// Added in version 7.1.0
enum TextAlignment {
  /// Align the text on the left edge of the view.
  ///
  /// Added in version 7.1.0
  left('left'),
  /// Align the text on the right edge of the view.
  ///
  /// Added in version 7.1.0
  right('right'),
  /// Align the text in the center of the view.
  ///
  /// Added in version 7.1.0
  center('center'),
  /// Align the text on the leading edge of the view.
  ///
  /// Added in version 7.1.0
  start('start'),
  /// Align the text on the trailing edge of the view.
  ///
  /// Added in version 7.1.0
  end('end');

  const TextAlignment(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension TextAlignmentSerializer on TextAlignment {
  static TextAlignment fromJSON(String jsonValue) {
    return TextAlignment.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
