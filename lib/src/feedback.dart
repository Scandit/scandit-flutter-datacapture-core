/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:convert';
import 'dart:io';

import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/generated/core_method_handler.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/generated/schema_types.dart'
    show buildFeedback, buildSound;

import 'common.dart';
import 'function_names.dart';

enum _VibrationType {
  defaultVibration('default'),
  selectionHaptic('selectionHaptic'),
  successHaptic('successHaptic'),
  failureHaptic('failureHaptic'),
  impactHaptic('impactHaptic'),
  waveForm('waveForm');

  const _VibrationType(this._name);

  @override
  String toString() => _name;

  final String _name;
}

/// A vibration, to be emitted for example when a code has been successfully scanned.
///
/// Added in version 6.7.0
class Vibration implements Serializable {
  final String _type;

  Vibration._(_VibrationType type) : _type = type.toString();

  /// Creates a new Vibration object.
  ///
  /// Added in version 6.7.0
  Vibration() : this._(_VibrationType.defaultVibration);

  /// The default vibration for a successful scan.
  ///
  /// Added in version 6.7.0
  static Vibration get defaultVibration => Vibration();

  /// It creates haptics to indicate a change in selection. In particular it uses UISelectionFeedbackGenerator. Please note that if the device does not have the Taptic Engine, no vibration will be emitted.
  ///
  /// Only available on iOS.
  ///
  /// Added in version 6.7.0
  static Vibration get selectionHapticFeedback => Vibration._(_VibrationType.selectionHaptic);

  /// It creates haptics to communicate successes. This is a notification feedback type, indicating that a task has completed successfully. In particular it uses UINotificationFeedbackGenerator with type UINotificationFeedbackTypeSuccess. Please note that if the device does not have the Taptic Engine, no vibration will be emitted.
  ///
  /// Only available on iOS.
  ///
  /// Added in version 6.7.0
  static Vibration get successHapticFeedback => Vibration._(_VibrationType.successHaptic);

  /// It creates haptics to communicate failures. This is a notification feedback type, indicating that a task has failed. In particular it uses UINotificationFeedbackGenerator with type UINotificationFeedbackTypeError. Please note that if the device does not have the Taptic Engine, no vibration will be emitted.
  ///
  /// Only available on iOS.
  ///
  /// Added in version 8.5.0
  static Vibration get failureHapticFeedback => Vibration._(_VibrationType.failureHaptic);

  /// It creates haptics to communicate impact. In particular it uses UIImpactFeedbackGenerator. Please note that if the device does not have the Taptic Engine, no vibration will be emitted.
  ///
  /// Only available on iOS.
  ///
  /// Added in version 6.19.0
  static Vibration get impactHapticFeedback => Vibration._(_VibrationType.impactHaptic);

  @override
  Map<String, dynamic> toMap() {
    return {'type': _type};
  }
}

/// A wave form vibration, to be emitted for example when a code has been successfully scanned.
///
/// The `timings` array must be non-empty. If `amplitudes` is provided, it must contain the same number of elements as `timings`.
///
/// Added in version 6.19.0
class WaveFormVibration extends Vibration {
  final List<int> _timings;
  final List<int>? _amplitudes;

  WaveFormVibration._(this._timings, this._amplitudes) : super._(_VibrationType.waveForm);

  WaveFormVibration.fromTimings(List<int> timings) : this.fromTimingsAndAmplitudes(timings, null);

  /// Creates a new WaveFormVibration object with timings and amplitudes.
  ///
  /// Added in version 6.19.0
  WaveFormVibration.fromTimingsAndAmplitudes(List<int> timings, List<int>? amplitudes) : this._(timings, amplitudes);

  /// Returns the timings of the WaveFormVibration.
  ///
  /// Added in version 6.19.0
  List<int> get timings => _timings;

  /// Returns the amplitudes of the WaveFormVibration.
  ///
  /// Added in version 6.19.0
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

/// A sound, to be played for example when a code has been successfully scanned.
///
/// Added in version 6.7.0
class Sound implements Serializable {
  final String? _resource;

  Sound(this._resource);

  /// The default beep sound for a successful scan.
  ///
  /// Added in version 6.7.0
  static Sound get defaultSound => Sound(null);

  Sound.fromJSON(Map<String, dynamic> json) : _resource = json['resource'] as String?;

  @override
  Map<String, dynamic> toMap() {
    return buildSound(resource: _resource);
  }
}

/// A feedback consisting of a sound and vibration, for example to be provided by a device when a code has been successfully scanned.
///
/// Added in version 6.7.0
class Feedback implements Serializable {
  final Vibration? _vibration;
  final Sound? _sound;
  late _FeedbackController _controller;

  /// Creates a Feedback that emits the given vibration and plays the given sound.
  ///
  /// Added in version 6.7.0
  Feedback(this._vibration, this._sound) {
    _controller = _FeedbackController(this);
  }

  /// The default feedback consisting of a default sound and a default vibration.
  ///
  /// Added in version 6.7.0
  static Feedback get defaultFeedback => Feedback(Vibration.defaultVibration, Sound.defaultSound);

  /// The vibration to be emitted when a feedback is required. If *null*, no vibration is emitted. This property is further influenced by the device’s ring mode: the device may not vibrate even if this property is properly set to a non-*null* instance.
  ///
  /// Added in version 6.7.0
  Vibration? get vibration => _vibration;

  /// The sound to be played when a feedback is required. If *null*, no sound is played. Depending on the device’s ring mode and/or volume settings, no sound may be played even if this property is properly set to a non-*null* instance.
  ///
  /// Added in version 6.7.0
  Sound? get sound => _sound;

  /// Emits the feedback defined by this object. This method is further influenced by the device’s ring mode and/or volume settings - check [Feedback.sound] and [Feedback.vibration] for more details.
  ///
  /// Added in version 6.7.0
  void emit() {
    _controller.emit();
  }

  @override
  Map<String, dynamic> toMap() {
    return buildFeedback(vibration: _vibration?.toMap(), sound: _sound?.toMap());
  }
}

class _FeedbackController extends BaseController {
  final Feedback _feedback;
  late final CoreMethodHandler coreMethodHandler;

  _FeedbackController(this._feedback) : super(FunctionNames.methodsChannelName) {
    coreMethodHandler = CoreMethodHandler(methodChannel);
  }
  void emit() {
    coreMethodHandler.emitFeedback(feedbackJson: jsonEncode(_feedback.toMap()));
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
          case 'failureHaptic':
            vibration = Vibration.failureHapticFeedback;
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
