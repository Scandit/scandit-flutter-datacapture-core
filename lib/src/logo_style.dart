/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

enum LogoStyle {
  extended('extended'),
  minimal('minimal');

  const LogoStyle(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension LogoStyleDeserializer on LogoStyle {
  static LogoStyle fromJSON(String jsonValue) {
    return LogoStyle.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
