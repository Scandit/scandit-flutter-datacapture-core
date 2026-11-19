/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

class ContextStatus {
  String _message;
  int _code;
  late bool _isValid;

  ContextStatus._(this._code, this._message, {required bool isValid}) {
    _isValid = isValid;
  }

  ContextStatus.fromJSON(Map<String, dynamic> json)
      : this._((json['code'] as num).toInt(), json['message'] as String, isValid: json['isValid'] as bool);

  String get message => _message;

  int get code => _code;

  bool get isValid => _isValid;
}
