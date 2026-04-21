/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:convert';
import 'dart:io';

import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';

import 'common.dart';
import 'function_names.dart';

enum _VibrationType {
  defaultVibration('default'),
  selectionHaptic('selectionHaptic'),
  successHaptic('successHaptic'),
  impactHaptic('impactHaptic'),
  waveForm('waveForm');

  const _VibrationType(this._name);

  @override
  String toString() => _name;

  final String _name;
}

class Vibration implements Serializable {
  final String _type;

  Vibration._(_VibrationType type) : _type = type.toString();

  Vibration() : this._(_VibrationType.defaultVibration);

  static Vibration get defaultVibration => Vibration();

  static Vibration get selectionHapticFeedback => Vibration._(_VibrationType.selectionHaptic);

  static Vibration get successHapticFeedback => Vibration._(_VibrationType.successHaptic);

  static Vibration get impactHapticFeedback => Vibration._(_VibrationType.impactHaptic);

  @override
  Map<String, dynamic> toMap() {
    return {'type': _type};
  }
}

class WaveFormVibration extends Vibration {
  final List<int> _timings;
  final List<int>? _amplitudes;

  WaveFormVibration._(this._timings, this._amplitudes) : super._(_VibrationType.waveForm);

  WaveFormVibration.fromTimings(List<int> timings) : this.fromTimingsAndAmplitudes(timings, null);

  WaveFormVibration.fromTimingsAndAmplitudes(List<int> timings, List<int>? amplitudes) : this._(timings, amplitudes);

  List<int> get timings => _timings;

  List<int>? get amplitudes => _amplitudes;

  @override
  Map<String, dynamic> toMap() {
    if (Platform.isIOS) {
      return Vibration.defaultVibration.toMap();
    }
    Map<String, dynamic> json = super.toMap();
    json['timings'] = timings;
    json['amplitudes'] = amplitudes;
    return json;
  }
}

class Sound implements Serializable {
  final String? _resource;

  Sound(this._resource);

  static Sound get defaultSound => Sound(null);

  Sound.fromJSON(Map<String, dynamic> json) : _resource = json['resource'] as String?;

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
    _controller = _FeedbackController(this);
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
      json['vibration'] = _vibration.toMap();
    }
    if (_sound != null) {
      json['sound'] = _sound.toMap();
    }
    return json;
  }
}

class _FeedbackController extends BaseController {
  final Feedback _feedback;

  _FeedbackController(this._feedback) : super(FunctionNames.methodsChannelName);

  void emit() {
    methodChannel.invokeMethod(FunctionNames.emitFeedbackMethodName, jsonEncode(_feedback.toMap()));
  }
}

extension FeedbackDeserializer on Feedback {
  static Feedback fromJson(Map<String, dynamic> json) {
    Sound? sound;
    Vibration? vibration;

    if (json.containsKey('sound')) {
      var soundMap = json['sound'] as Map;
      if (soundMap.isNotEmpty && soundMap.containsKey('resource')) {
        sound = Sound(soundMap['resource']);
      } else {
        sound = Sound(null);
      }
    }
    if (json.containsKey('vibration')) {
      var vibrationMap = json['vibration'] as Map;
      if (vibrationMap.isNotEmpty && vibrationMap.containsKey('type')) {
        var vibrationType = vibrationMap['type'];
        switch (vibrationType) {
          case 'selectionHaptic':
            vibration = Vibration.selectionHapticFeedback;
            break;
          case 'successHaptic':
            vibration = Vibration.successHapticFeedback;
            break;
          case 'impactHaptic':
            vibration = Vibration.impactHapticFeedback;
            break;
          case 'waveForm':
            vibration = _getWaveFormVibration(vibrationMap);
            break;
          default:
            vibration = Vibration.defaultVibration;
        }
      } else {
        vibration = Vibration.defaultVibration;
      }
    }

    return Feedback(vibration, sound);
  }

  static WaveFormVibration _getWaveFormVibration(Map json) {
    var timings = List<int>.from(json['timings']);
    List<int>? amplitudes;

    if (json.containsKey('amplitudes') && json['amplitudes'] != null) {
      amplitudes = List<int>.from(json['amplitudes']);
    }
    return WaveFormVibration.fromTimingsAndAmplitudes(timings, amplitudes);
  }
}
