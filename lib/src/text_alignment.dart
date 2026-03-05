/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

enum TextAlignment {
  left('left'),
  right('right'),
  center('center'),
  start('start'),
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
