/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

/// Holds information on the current context status. This information is available to data capture context listeners (see didChangeStatus() method). The initial context status will always be Unknown (0) but change very quickly to either Success (1) or an error (2+, see below).
///
/// Added in version 6.7.0
class ContextStatus {
  String _message;
  int _code;
  late bool _isValid;

  ContextStatus._(this._code, this._message, {required bool isValid}) {
    _isValid = isValid;
  }

  ContextStatus.fromJSON(Map<String, dynamic> json)
      : this._((json['code'] as num).toInt(), json['message'] as String, isValid: json['isValid'] as bool);

  /// A human readable representation of the current context status, containing more information about potential issues. In case there are no issues ([ContextStatus.isValid] is *true*), the message is empty.
  ///
  /// Added in version 6.7.0
  String get message => _message;

  /// The context status code.
  ///
  /// Added in version 6.7.0
  int get code => _code;

  /// Whether the context is valid.
  ///
  /// Added in version 6.7.0
  bool get isValid => _isValid;
}
