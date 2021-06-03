/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:flutter/services.dart';

import 'common.dart';
import 'defaults.dart';
import 'function_names.dart';

enum _VibrationType { defaultVibration, selectionHaptic, successHaptic }

extension _VibrationTypeSerializer on _VibrationType {
  String get jsonValue => _jsonValue();

  String _jsonValue() {
    switch (this) {
      case _VibrationType.defaultVibration:
        return 'default';
      case _VibrationType.selectionHaptic:
        return 'selectionHaptic';
      case _VibrationType.successHaptic:
        return 'successHaptic';
      default:
        throw Exception("Missing Json Value for '$this' vibration type");
    }
  }
}

class Vibration implements Serializable {
  final String _type;

  Vibration._(_VibrationType type) : _type = type.jsonValue;

  Vibration() : this._(_VibrationType.defaultVibration);

  static Vibration get defaultVibration => Vibration();

  static Vibration get selectionHapticFeedback => Vibration._(_VibrationType.selectionHaptic);

  static Vibration get successHapticFeedback => Vibration._(_VibrationType.successHaptic);

  @override
  Map<String, String> toMap() {
    return {'type': _type};
  }
}

class Sound implements Serializable {
  final String? _resource;

  Sound(this._resource);

  static Sound get defaultSound => Sound(null);

  @override
  Map<String, dynamic> toMap() {
    var json = <String, dynamic>{};
    if (_resource != null) {
      json['resource'] = _resource;
    }
    return json;
  }
}

class Feedback implements Serializable {
  final Vibration? _vibration;
  final Sound? _sound;
  late _FeedbackController _controller;

  Feedback(this._vibration, this._sound) {
    _controller = _FeedbackController.forFeedback(this);
  }

  static Feedback get defaultFeedback => Feedback(Vibration.defaultVibration, Sound.defaultSound);

  Vibration? get vibration => _vibration;

  Sound? get sound => _sound;

  void emit() {
    _controller.emit();
  }

  @override
  Map<String, dynamic> toMap() {
    var json = <String, dynamic>{};
    if (_vibration != null) {
      json['vibration'] = _vibration?.toMap();
    }
    if (_sound != null) {
      json['sound'] = _sound?.toMap();
    }
    return json;
  }
}

class _FeedbackController {
  final MethodChannel _methodChannel;
  final Feedback _feedback;

  _FeedbackController._(this._methodChannel, this._feedback);

  _FeedbackController.forFeedback(Feedback feedback) : this._(Defaults.channel, feedback);

  void emit() {
    _methodChannel.invokeMethod(FunctionNames.emitFeedbackMethodName, jsonEncode(_feedback.toMap()));
  }
}
