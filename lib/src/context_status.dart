/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'package:flutter/material.dart';

class ContextStatus {
  String _message;
  int _code;
  bool _isValid;

  ContextStatus._(int code, String message, {@required bool isValid}) {
    _code = code;
    _message = message;
    _isValid = isValid;
  }

  ContextStatus.fromJSON(Map<String, dynamic> json)
      : this._((json['code'] as num).toInt(), json['message'] as String, isValid: json['isValid'] as bool);

  String get message => _message;

  int get code => _code;

  bool get isValid => _isValid;
}
