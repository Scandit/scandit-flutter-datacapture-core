/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

// THIS FILE IS GENERATED. DO NOT EDIT MANUALLY.
// Generator: scripts/bridge_generator/generate.py
// Schema: scripts/bridge_generator/schemas/core.json
//
// ignore_for_file: constant_identifier_names, non_constant_identifier_names
// Wire-format names (schema property/enum-value strings, e.g.
// `number_of_mandatory_instances`, `royal_mail_4state`) are preserved
// verbatim as Dart identifiers for fidelity with the JSON payload; they are
// not renamed to lowerCamelCase.
//
// Typed classes + throwing fromJson/toJson derived from the serialization
// JSON schemas referenced by this module's bridge params. No runtime
// dependency: validation is hand-rolled below, not json_serializable/built_value.
//
// fromJson enforces only the JSON Schema keywords expressible without a
// schema engine: required, type, enum, string const, additionalProperties,
// null-ness, and root-level oneOf (dispatched on the discriminator to the
// matching variant's fromJson).
// NOT enforced -- a payload violating one of these still parses:
//   pattern, minimum/maximum, minLength/maxLength, multipleOf, and
//   property-level oneOf of more than one non-null variant (those
//   properties are typed Object? and left unvalidated).
//
// Each plain object class also gets a top-level `buildX` function: a
// shallow-typed, validation-free map builder for outbound (Dart -> native)
// payloads. It never parses or throws.
//
// THE BUILDER CONTRACT (stated once here; each buildX carries a one-line
// pointer back to it rather than repeating this block 300+ times).
//
// Outbound payloads are deliberately NOT runtime-validated. The generated
// `fromJson` enforces `additionalProperties: false`, so validating outbound
// would turn the next property added to a public model into a customer-facing
// throw. Compile-time named parameters give the shape guarantee instead.
//
// Emit rule -- "key absent" and "key present and null" are DIFFERENT
// instructions to the deserializers, so the builder reproduces exactly what
// the caller asked for and nothing more:
//   - required                -> always written (omitting it would make
//                                `fromJson` throw "missing required property").
//   - optional, non-nullable  -> omitted when null; null means "not set".
//   - optional + nullable     -> written IF AND ONLY IF the caller passed it,
//                                including when what they passed was null.
//
// That last case is why those parameters are typed `Object?` with an `_unset`
// default instead of their schema type: Dart cannot otherwise tell "passed
// null" from "not passed", and the difference is load-bearing. The schema
// declares null a valid value for these (core/data_capture_view.json documents
// `focusGesture` as "Set to null to disable", and the C++ side branches on
// `containsNull` before falling back to the current value for an absent key),
// so writing the key when the caller stayed silent is just as wrong as
// dropping one they set. A blanket "always write" did exactly that and
// disabled every Android DataCaptureView by adding `parentId: null`, which
// `DataCaptureViewCreationData.kt` reads with `has()` + `getInt()`.
//
// Consequence worth knowing: the generated class's own `toJson()` omits an
// optional+nullable key when null, while `buildX` preserves the caller's
// explicit null. The asymmetry is intended -- `toJson` round-trips a parsed
// object (inbound), `buildX` expresses a caller's intent (outbound) -- so
// `fromJson(buildX(k: null)).toJson()` drops `k`.
//
// Nested `$ref`/array-of-`$ref` properties are typed shallowly
// (`Object?`/`List<Object?>`, not the generated nested class): those classes
// duplicate the hand-written public models (e.g. Brush, Color, Viewfinder)
// that callers already hold an already-serialized map for, so the builder
// accepts that map directly instead of requiring the generated type.
//
// PASSTHROUGH CONTRACT for open schemas (no `additionalProperties: false`):
// `fromJson` collects every key not in the declared-property set into
// `additionalProperties`, and `toJson` re-emits them (declared keys win on
// collision), so an undeclared key native adds round-trips losslessly
// instead of being silently dropped. Strict (`additionalProperties: false`)
// classes reject unknown keys instead and carry no such field.
//
// The passthrough set is the EMITTED fields, not every declared name: a
// `hidden` or non-mobile property is declared but gets no field, so only the
// passthrough can carry it back out.
//
// Limits worth knowing:
//   - "Lossless" covers key presence and undeclared values. An explicit null
//     on an optional+nullable DECLARED property is still dropped, per the
//     emit rule above -- that predates this contract and is intended.
//   - Undeclared values are stored verbatim and never validated, so a typed
//     `additionalProperties` sub-schema is not enforced and a malformed
//     nested payload round-trips as-is. `fromJson` validates declared
//     properties only.
//   - `fromJson` wraps the map in `Map.unmodifiable`, so the value semantics
//     the `const` constructor implies hold for the map itself. Nested
//     `Map`/`List` VALUES still alias the input JSON (as `enabledCompositeTypes`
//     already does via `.cast<String>()`), and a hand-constructed instance gets
//     whatever map the caller passed.
//   - `build<Type>()` takes declared properties only and has no passthrough, so
//     a caller that parses with `fromJson` and rebuilds through the builder
//     drops the undeclared keys again. Preserve them by going through the
//     class's own `toJson`, not the builder.
//
// One collision caveat, reachable only by hand-construction: `fromJson` never
// puts an emitted name into the passthrough map, but the const constructor does
// not check. If a caller passes a declared key in `additionalProperties` while
// the matching optional property is null, `toJson` omits the null property and
// the passthrough value is emitted under that declared name. Build these types
// with `fromJson` and the collision cannot arise.

/// Marker for "this optional+nullable argument was not passed", so a builder
/// can tell that apart from an explicit `null`. See the emit rule above.
class _Unset {
  const _Unset();
}

const Object _unset = _Unset();

/// The root data capture context.
class Context {
  final List<Object?>? components;
  final String? deviceName;
  final String? externalId;
  final String? framework;
  final String? frameworkVersion;
  final FrameSource? frameSource;
  final String licenseKey;
  final List<Mode>? modes;
  final ContextSettings? settings;
  final Object? view;

  const Context({
    this.components,
    this.deviceName,
    this.externalId,
    this.framework,
    this.frameworkVersion,
    this.frameSource,
    required this.licenseKey,
    this.modes,
    this.settings,
    this.view,
  });

  factory Context.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('Context: expected a Map');
    }
    const allowedKeys = <String>{
      'components',
      'deviceName',
      'externalId',
      'framework',
      'frameworkVersion',
      'browser',
      'browserVersion',
      'deviceOS',
      'deviceModelName',
      'deviceManufacturer',
      'frameSource',
      'licenseKey',
      'modes',
      'settings',
      'view',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("Context: unknown property '$key'");
      }
    }
    final hasComponents = raw.containsKey('components');
    final componentsRaw = raw['components'];
    List<Object?>? componentsValue;
    if (hasComponents && componentsRaw != null) {
      if (componentsRaw is! List) {
        throw FormatException('Context.components: expected a List');
      }
      componentsValue = componentsRaw.cast<Object?>();
    } else if (hasComponents && componentsRaw == null) {
      throw FormatException('Context.components: null is not allowed');
    }
    final hasDeviceName = raw.containsKey('deviceName');
    final deviceNameRaw = raw['deviceName'];
    String? deviceNameValue;
    if (hasDeviceName && deviceNameRaw != null) {
      if (deviceNameRaw is! String) {
        throw FormatException('Context.deviceName: expected a String');
      }
      deviceNameValue = deviceNameRaw;
    }
    final hasExternalId = raw.containsKey('externalId');
    final externalIdRaw = raw['externalId'];
    String? externalIdValue;
    if (hasExternalId && externalIdRaw != null) {
      if (externalIdRaw is! String) {
        throw FormatException('Context.externalId: expected a String');
      }
      externalIdValue = externalIdRaw;
    } else if (hasExternalId && externalIdRaw == null) {
      throw FormatException('Context.externalId: null is not allowed');
    }
    final hasFramework = raw.containsKey('framework');
    final frameworkRaw = raw['framework'];
    String? frameworkValue;
    if (hasFramework && frameworkRaw != null) {
      if (frameworkRaw is! String ||
          !const <String>[
            'unknown',
            'native',
            'cordova',
            'xamarin',
            'xamarin-forms',
            'react-native',
            'titanium',
            'flutter',
            'capacitor',
            'pega',
            'web',
            '.net'
          ].contains(frameworkRaw)) {
        throw FormatException("Context.framework: unknown enum value '$frameworkRaw'");
      }
      frameworkValue = frameworkRaw;
    } else if (hasFramework && frameworkRaw == null) {
      throw FormatException('Context.framework: null is not allowed');
    }
    final hasFrameworkVersion = raw.containsKey('frameworkVersion');
    final frameworkVersionRaw = raw['frameworkVersion'];
    String? frameworkVersionValue;
    if (hasFrameworkVersion && frameworkVersionRaw != null) {
      if (frameworkVersionRaw is! String) {
        throw FormatException('Context.frameworkVersion: expected a String');
      }
      frameworkVersionValue = frameworkVersionRaw;
    }
    final hasFrameSource = raw.containsKey('frameSource');
    final frameSourceRaw = raw['frameSource'];
    FrameSource? frameSourceValue;
    if (hasFrameSource && frameSourceRaw != null) {
      frameSourceValue = FrameSource.fromJson(frameSourceRaw);
    }
    final hasLicenseKey = raw.containsKey('licenseKey');
    if (!hasLicenseKey) {
      throw FormatException("Context.licenseKey: missing required property");
    }
    final licenseKeyRaw = raw['licenseKey'];
    String? licenseKeyValue;
    if (hasLicenseKey && licenseKeyRaw != null) {
      if (licenseKeyRaw is! String) {
        throw FormatException('Context.licenseKey: expected a String');
      }
      licenseKeyValue = licenseKeyRaw;
    } else if (hasLicenseKey && licenseKeyRaw == null) {
      throw FormatException('Context.licenseKey: null is not allowed');
    }
    final hasModes = raw.containsKey('modes');
    final modesRaw = raw['modes'];
    List<Mode>? modesValue;
    if (hasModes && modesRaw != null) {
      if (modesRaw is! List) {
        throw FormatException('Context.modes: expected a List');
      }
      modesValue = modesRaw.map((item) => Mode.fromJson(item)).toList();
    } else if (hasModes && modesRaw == null) {
      throw FormatException('Context.modes: null is not allowed');
    }
    final hasSettings = raw.containsKey('settings');
    final settingsRaw = raw['settings'];
    ContextSettings? settingsValue;
    if (hasSettings && settingsRaw != null) {
      settingsValue = ContextSettings.fromJson(settingsRaw);
    } else if (hasSettings && settingsRaw == null) {
      throw FormatException('Context.settings: null is not allowed');
    }
    final hasView = raw.containsKey('view');
    final viewRaw = raw['view'];
    Object? viewValue;
    if (hasView && viewRaw != null) {
      viewValue = viewRaw;
    } else if (hasView && viewRaw == null) {
      throw FormatException('Context.view: null is not allowed');
    }
    return Context(
      components: componentsValue,
      deviceName: deviceNameValue,
      externalId: externalIdValue,
      framework: frameworkValue,
      frameworkVersion: frameworkVersionValue,
      frameSource: frameSourceValue,
      licenseKey: licenseKeyValue!,
      modes: modesValue,
      settings: settingsValue,
      view: viewValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (components != null) {
      map['components'] = components;
    }
    if (deviceName != null) {
      map['deviceName'] = deviceName;
    }
    if (externalId != null) {
      map['externalId'] = externalId;
    }
    if (framework != null) {
      map['framework'] = framework;
    }
    if (frameworkVersion != null) {
      map['frameworkVersion'] = frameworkVersion;
    }
    if (frameSource != null) {
      map['frameSource'] = frameSource!.toJson();
    }
    map['licenseKey'] = licenseKey;
    if (modes != null) {
      map['modes'] = modes!.map((item) => item.toJson()).toList();
    }
    if (settings != null) {
      map['settings'] = settings!.toJson();
    }
    if (view != null) {
      map['view'] = view;
    }
    return map;
  }
}

/// Typed builder for the `Context` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildContext({
  List<Object?>? components,
  Object? deviceName = _unset,
  String? externalId,
  String? framework,
  Object? frameworkVersion = _unset,
  Object? frameSource = _unset,
  required String licenseKey,
  List<Object?>? modes,
  Object? settings,
  Object? view,
}) {
  final map = <String, Object?>{};
  if (components != null) {
    map['components'] = components;
  }
  if (!identical(deviceName, _unset)) {
    map['deviceName'] = deviceName;
  }
  if (externalId != null) {
    map['externalId'] = externalId;
  }
  if (framework != null) {
    map['framework'] = framework;
  }
  if (!identical(frameworkVersion, _unset)) {
    map['frameworkVersion'] = frameworkVersion;
  }
  if (!identical(frameSource, _unset)) {
    map['frameSource'] = frameSource;
  }
  map['licenseKey'] = licenseKey;
  if (modes != null) {
    map['modes'] = modes;
  }
  if (settings != null) {
    map['settings'] = settings;
  }
  if (view != null) {
    map['view'] = view;
  }
  return map;
}

/// A frame source, discriminated by the 'type' field.
// NOTE: `abstract class`, not `abstract interface class`. The generated Dart
// must parse under the OLDEST toolchain in CI -- validate-bridge-generator's
// `dart format` runs on an older Dart SDK that does not understand Dart 3.0+
// class modifiers (`interface`, `sealed`, `base`, `final class`,
// `mixin class`). The docs signature collector moved to `analyzer ^7.7.1` in
// SDC-33150 and parses those fine, so it is no longer part of this
// constraint; `dart format` still is. `abstract class` is implementable in
// Dart 2 and 3 alike, so it preserves the same "implement, don't extend"
// contract without the modifier.
abstract class FrameSource {
  Map<String, Object?> toJson();

  factory FrameSource.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('FrameSource: expected a Map');
    }
    final discriminant = raw['type'];
    switch (discriminant) {
      case 'camera':
        return Camera.fromJson(raw);
      case 'image':
        return ImageFrameSource.fromJson(raw);
      case 'sequence':
        return SequenceFrameSource.fromJson(raw);
      default:
        throw FormatException(
          "FrameSource: unknown type '$discriminant'",
        );
    }
  }
}

/// A camera frame source
class Camera implements FrameSource {
  final String type;
  final String? position;
  final String? cameraType;
  final CameraSettings? settings;

  const Camera({
    required this.type,
    this.position,
    this.cameraType,
    this.settings,
  });

  factory Camera.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('Camera: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'position',
      'cameraType',
      'cameraDeviceType',
      'settings',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("Camera: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("Camera.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['camera'].contains(typeRaw)) {
        throw FormatException("Camera.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('Camera.type: null is not allowed');
    }
    final hasPosition = raw.containsKey('position');
    final positionRaw = raw['position'];
    String? positionValue;
    if (hasPosition && positionRaw != null) {
      if (positionRaw is! String || !const <String>['worldFacing', 'userFacing', 'unspecified'].contains(positionRaw)) {
        throw FormatException("Camera.position: unknown enum value '$positionRaw'");
      }
      positionValue = positionRaw;
    } else if (hasPosition && positionRaw == null) {
      throw FormatException('Camera.position: null is not allowed');
    }
    final hasCameraType = raw.containsKey('cameraType');
    final cameraTypeRaw = raw['cameraType'];
    String? cameraTypeValue;
    if (hasCameraType && cameraTypeRaw != null) {
      if (cameraTypeRaw is! String || !const <String>['sparkCapture'].contains(cameraTypeRaw)) {
        throw FormatException("Camera.cameraType: unknown enum value '$cameraTypeRaw'");
      }
      cameraTypeValue = cameraTypeRaw;
    }
    final hasSettings = raw.containsKey('settings');
    final settingsRaw = raw['settings'];
    CameraSettings? settingsValue;
    if (hasSettings && settingsRaw != null) {
      settingsValue = CameraSettings.fromJson(settingsRaw);
    } else if (hasSettings && settingsRaw == null) {
      throw FormatException('Camera.settings: null is not allowed');
    }
    return Camera(
      type: typeValue!,
      position: positionValue,
      cameraType: cameraTypeValue,
      settings: settingsValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (position != null) {
      map['position'] = position;
    }
    if (cameraType != null) {
      map['cameraType'] = cameraType;
    }
    if (settings != null) {
      map['settings'] = settings!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `Camera` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildCamera({
  required String type,
  String? position,
  Object? cameraType = _unset,
  Object? settings,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (position != null) {
    map['position'] = position;
  }
  if (!identical(cameraType, _unset)) {
    map['cameraType'] = cameraType;
  }
  if (settings != null) {
    map['settings'] = settings;
  }
  return map;
}

/// Settings for a camera frame source
class CameraSettings {
  final String? recommendedForMode;
  final String? preferredResolution;
  final String? preferredAspectRatio;
  final double? minFrameRate;
  final double? maxFrameRate;
  final String? preferredFrameRateRange;
  final double? zoomFactor;
  @Deprecated('since 8.4')
  final double? zoomGestureZoomFactor;
  final List<double>? zoomLevels;
  final String? macroMode;
  final int? manualUntilCaptureTimeout;
  final bool? adaptiveExposure;
  final double? torchLevel;
  final FocusSettings? focus;
  final int? api;
  final double? exposureTargetBias;
  final bool? colorCorrection;
  final String? toneMappingCurve;
  final String? noiseReductionMode;
  final String? edgeEnhancementMode;
  final String? regionStrategy;
  final CameraSettingsArbitraryVideoResolution? arbitraryVideoResolution;

  const CameraSettings({
    this.recommendedForMode,
    this.preferredResolution,
    this.preferredAspectRatio,
    this.minFrameRate,
    this.maxFrameRate,
    this.preferredFrameRateRange,
    this.zoomFactor,
    this.zoomGestureZoomFactor,
    this.zoomLevels,
    this.macroMode,
    this.manualUntilCaptureTimeout,
    this.adaptiveExposure,
    this.torchLevel,
    this.focus,
    this.api,
    this.exposureTargetBias,
    this.colorCorrection,
    this.toneMappingCurve,
    this.noiseReductionMode,
    this.edgeEnhancementMode,
    this.regionStrategy,
    this.arbitraryVideoResolution,
  });

  factory CameraSettings.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('CameraSettings: expected a Map');
    }
    const allowedKeys = <String>{
      'recommendedForMode',
      'preferredResolution',
      'preferredAspectRatio',
      'minFrameRate',
      'maxFrameRate',
      'preferredFrameRateRange',
      'zoomFactor',
      'zoomGestureZoomFactor',
      'zoomLevels',
      'macroMode',
      'manualUntilCaptureTimeout',
      'adaptiveExposure',
      'torchLevel',
      'focus',
      'api',
      'usesApi2Features',
      'overwriteWithHighestResolution',
      'exposureTargetBias',
      'colorCorrection',
      'toneMappingCurve',
      'noiseReductionMode',
      'edgeEnhancementMode',
      'regionStrategy',
      'forceAggressiveAutoFocus',
      'arbitraryVideoResolution',
      'enableSensorPixelModeMaximumResolution',
      'closestResolutionTo12MPForFourToThreeAspectRatio',
      'disableManualLensPositionSupportCheck',
      'xcoverInitialLensPosition',
      'cameraId',
      'extendedZoom',
      'exposureDuration',
      'disablePostProcessing',
      'sensorSensitivity',
      'should_run_session_in_standby',
      'should_start_stop_session_in_standby',
      'stage1StandbyDuration',
      'dynamicResolution',
      'dynamicResolutionLowFps',
      'dynamicResolutionMeasuringIntervalMillis',
      'dynamicResolutionLogging',
      'dynamicResolutionReset',
      'streamUseCase',
      'numFramesInCameraApi2FrameDataPool',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("CameraSettings: unknown property '$key'");
      }
    }
    final hasRecommendedForMode = raw.containsKey('recommendedForMode');
    final recommendedForModeRaw = raw['recommendedForMode'];
    String? recommendedForModeValue;
    if (hasRecommendedForMode && recommendedForModeRaw != null) {
      if (recommendedForModeRaw is! String) {
        throw FormatException('CameraSettings.recommendedForMode: expected a String');
      }
      recommendedForModeValue = recommendedForModeRaw;
    } else if (hasRecommendedForMode && recommendedForModeRaw == null) {
      throw FormatException('CameraSettings.recommendedForMode: null is not allowed');
    }
    final hasPreferredResolution = raw.containsKey('preferredResolution');
    final preferredResolutionRaw = raw['preferredResolution'];
    String? preferredResolutionValue;
    if (hasPreferredResolution && preferredResolutionRaw != null) {
      if (preferredResolutionRaw is! String ||
          !const <String>['auto', 'hd', 'fullHd', 'uhd4k', 'maxResolution', 'quadHd']
              .contains(preferredResolutionRaw)) {
        throw FormatException("CameraSettings.preferredResolution: unknown enum value '$preferredResolutionRaw'");
      }
      preferredResolutionValue = preferredResolutionRaw;
    } else if (hasPreferredResolution && preferredResolutionRaw == null) {
      throw FormatException('CameraSettings.preferredResolution: null is not allowed');
    }
    final hasPreferredAspectRatio = raw.containsKey('preferredAspectRatio');
    final preferredAspectRatioRaw = raw['preferredAspectRatio'];
    String? preferredAspectRatioValue;
    if (hasPreferredAspectRatio && preferredAspectRatioRaw != null) {
      if (preferredAspectRatioRaw is! String ||
          !const <String>['auto', 'sixteenToNine', 'fourToThree'].contains(preferredAspectRatioRaw)) {
        throw FormatException("CameraSettings.preferredAspectRatio: unknown enum value '$preferredAspectRatioRaw'");
      }
      preferredAspectRatioValue = preferredAspectRatioRaw;
    } else if (hasPreferredAspectRatio && preferredAspectRatioRaw == null) {
      throw FormatException('CameraSettings.preferredAspectRatio: null is not allowed');
    }
    final hasMinFrameRate = raw.containsKey('minFrameRate');
    final minFrameRateRaw = raw['minFrameRate'];
    double? minFrameRateValue;
    if (hasMinFrameRate && minFrameRateRaw != null) {
      if (minFrameRateRaw is! num) {
        throw FormatException('CameraSettings.minFrameRate: expected a number');
      }
      minFrameRateValue = minFrameRateRaw.toDouble();
    } else if (hasMinFrameRate && minFrameRateRaw == null) {
      throw FormatException('CameraSettings.minFrameRate: null is not allowed');
    }
    final hasMaxFrameRate = raw.containsKey('maxFrameRate');
    final maxFrameRateRaw = raw['maxFrameRate'];
    double? maxFrameRateValue;
    if (hasMaxFrameRate && maxFrameRateRaw != null) {
      if (maxFrameRateRaw is! num) {
        throw FormatException('CameraSettings.maxFrameRate: expected a number');
      }
      maxFrameRateValue = maxFrameRateRaw.toDouble();
    } else if (hasMaxFrameRate && maxFrameRateRaw == null) {
      throw FormatException('CameraSettings.maxFrameRate: null is not allowed');
    }
    final hasPreferredFrameRateRange = raw.containsKey('preferredFrameRateRange');
    final preferredFrameRateRangeRaw = raw['preferredFrameRateRange'];
    String? preferredFrameRateRangeValue;
    if (hasPreferredFrameRateRange && preferredFrameRateRangeRaw != null) {
      if (preferredFrameRateRangeRaw is! String ||
          !const <String>['highestWidest', 'highestNarrowest'].contains(preferredFrameRateRangeRaw)) {
        throw FormatException(
            "CameraSettings.preferredFrameRateRange: unknown enum value '$preferredFrameRateRangeRaw'");
      }
      preferredFrameRateRangeValue = preferredFrameRateRangeRaw;
    } else if (hasPreferredFrameRateRange && preferredFrameRateRangeRaw == null) {
      throw FormatException('CameraSettings.preferredFrameRateRange: null is not allowed');
    }
    final hasZoomFactor = raw.containsKey('zoomFactor');
    final zoomFactorRaw = raw['zoomFactor'];
    double? zoomFactorValue;
    if (hasZoomFactor && zoomFactorRaw != null) {
      if (zoomFactorRaw is! num) {
        throw FormatException('CameraSettings.zoomFactor: expected a number');
      }
      zoomFactorValue = zoomFactorRaw.toDouble();
    } else if (hasZoomFactor && zoomFactorRaw == null) {
      throw FormatException('CameraSettings.zoomFactor: null is not allowed');
    }
    final hasZoomGestureZoomFactor = raw.containsKey('zoomGestureZoomFactor');
    final zoomGestureZoomFactorRaw = raw['zoomGestureZoomFactor'];
    double? zoomGestureZoomFactorValue;
    if (hasZoomGestureZoomFactor && zoomGestureZoomFactorRaw != null) {
      if (zoomGestureZoomFactorRaw is! num) {
        throw FormatException('CameraSettings.zoomGestureZoomFactor: expected a number');
      }
      zoomGestureZoomFactorValue = zoomGestureZoomFactorRaw.toDouble();
    } else if (hasZoomGestureZoomFactor && zoomGestureZoomFactorRaw == null) {
      throw FormatException('CameraSettings.zoomGestureZoomFactor: null is not allowed');
    }
    final hasZoomLevels = raw.containsKey('zoomLevels');
    final zoomLevelsRaw = raw['zoomLevels'];
    List<double>? zoomLevelsValue;
    if (hasZoomLevels && zoomLevelsRaw != null) {
      if (zoomLevelsRaw is! List) {
        throw FormatException('CameraSettings.zoomLevels: expected a List');
      }
      for (final item in zoomLevelsRaw) {
        if (item is! num) {
          throw FormatException('CameraSettings.zoomLevels: expected a List of num');
        }
      }
      zoomLevelsValue = zoomLevelsRaw.map((item) => (item as num).toDouble()).toList();
    } else if (hasZoomLevels && zoomLevelsRaw == null) {
      throw FormatException('CameraSettings.zoomLevels: null is not allowed');
    }
    final hasMacroMode = raw.containsKey('macroMode');
    final macroModeRaw = raw['macroMode'];
    String? macroModeValue;
    if (hasMacroMode && macroModeRaw != null) {
      if (macroModeRaw is! String || !const <String>['auto', 'off', 'on'].contains(macroModeRaw)) {
        throw FormatException("CameraSettings.macroMode: unknown enum value '$macroModeRaw'");
      }
      macroModeValue = macroModeRaw;
    } else if (hasMacroMode && macroModeRaw == null) {
      throw FormatException('CameraSettings.macroMode: null is not allowed');
    }
    final hasManualUntilCaptureTimeout = raw.containsKey('manualUntilCaptureTimeout');
    final manualUntilCaptureTimeoutRaw = raw['manualUntilCaptureTimeout'];
    int? manualUntilCaptureTimeoutValue;
    if (hasManualUntilCaptureTimeout && manualUntilCaptureTimeoutRaw != null) {
      if (manualUntilCaptureTimeoutRaw is! num) {
        throw FormatException('CameraSettings.manualUntilCaptureTimeout: expected a number');
      }
      if (manualUntilCaptureTimeoutRaw != manualUntilCaptureTimeoutRaw.toInt()) {
        throw FormatException('CameraSettings.manualUntilCaptureTimeout: expected an integer');
      }
      manualUntilCaptureTimeoutValue = manualUntilCaptureTimeoutRaw.toInt();
    } else if (hasManualUntilCaptureTimeout && manualUntilCaptureTimeoutRaw == null) {
      throw FormatException('CameraSettings.manualUntilCaptureTimeout: null is not allowed');
    }
    final hasAdaptiveExposure = raw.containsKey('adaptiveExposure');
    final adaptiveExposureRaw = raw['adaptiveExposure'];
    bool? adaptiveExposureValue;
    if (hasAdaptiveExposure && adaptiveExposureRaw != null) {
      if (adaptiveExposureRaw is! bool) {
        throw FormatException('CameraSettings.adaptiveExposure: expected a bool');
      }
      adaptiveExposureValue = adaptiveExposureRaw;
    } else if (hasAdaptiveExposure && adaptiveExposureRaw == null) {
      throw FormatException('CameraSettings.adaptiveExposure: null is not allowed');
    }
    final hasTorchLevel = raw.containsKey('torchLevel');
    final torchLevelRaw = raw['torchLevel'];
    double? torchLevelValue;
    if (hasTorchLevel && torchLevelRaw != null) {
      if (torchLevelRaw is! num) {
        throw FormatException('CameraSettings.torchLevel: expected a number');
      }
      torchLevelValue = torchLevelRaw.toDouble();
    } else if (hasTorchLevel && torchLevelRaw == null) {
      throw FormatException('CameraSettings.torchLevel: null is not allowed');
    }
    final hasFocus = raw.containsKey('focus');
    final focusRaw = raw['focus'];
    FocusSettings? focusValue;
    if (hasFocus && focusRaw != null) {
      focusValue = FocusSettings.fromJson(focusRaw);
    } else if (hasFocus && focusRaw == null) {
      throw FormatException('CameraSettings.focus: null is not allowed');
    }
    final hasApi = raw.containsKey('api');
    final apiRaw = raw['api'];
    int? apiValue;
    if (hasApi && apiRaw != null) {
      if (apiRaw is! num) {
        throw FormatException('CameraSettings.api: expected a number');
      }
      if (apiRaw != apiRaw.toInt()) {
        throw FormatException('CameraSettings.api: expected an integer');
      }
      apiValue = apiRaw.toInt();
    } else if (hasApi && apiRaw == null) {
      throw FormatException('CameraSettings.api: null is not allowed');
    }
    final hasExposureTargetBias = raw.containsKey('exposureTargetBias');
    final exposureTargetBiasRaw = raw['exposureTargetBias'];
    double? exposureTargetBiasValue;
    if (hasExposureTargetBias && exposureTargetBiasRaw != null) {
      if (exposureTargetBiasRaw is! num) {
        throw FormatException('CameraSettings.exposureTargetBias: expected a number');
      }
      exposureTargetBiasValue = exposureTargetBiasRaw.toDouble();
    } else if (hasExposureTargetBias && exposureTargetBiasRaw == null) {
      throw FormatException('CameraSettings.exposureTargetBias: null is not allowed');
    }
    final hasColorCorrection = raw.containsKey('colorCorrection');
    final colorCorrectionRaw = raw['colorCorrection'];
    bool? colorCorrectionValue;
    if (hasColorCorrection && colorCorrectionRaw != null) {
      if (colorCorrectionRaw is! bool) {
        throw FormatException('CameraSettings.colorCorrection: expected a bool');
      }
      colorCorrectionValue = colorCorrectionRaw;
    } else if (hasColorCorrection && colorCorrectionRaw == null) {
      throw FormatException('CameraSettings.colorCorrection: null is not allowed');
    }
    final hasToneMappingCurve = raw.containsKey('toneMappingCurve');
    final toneMappingCurveRaw = raw['toneMappingCurve'];
    String? toneMappingCurveValue;
    if (hasToneMappingCurve && toneMappingCurveRaw != null) {
      if (toneMappingCurveRaw is! String ||
          !const <String>['none', 'gamma22', 'linear', 'srgb'].contains(toneMappingCurveRaw)) {
        throw FormatException("CameraSettings.toneMappingCurve: unknown enum value '$toneMappingCurveRaw'");
      }
      toneMappingCurveValue = toneMappingCurveRaw;
    } else if (hasToneMappingCurve && toneMappingCurveRaw == null) {
      throw FormatException('CameraSettings.toneMappingCurve: null is not allowed');
    }
    final hasNoiseReductionMode = raw.containsKey('noiseReductionMode');
    final noiseReductionModeRaw = raw['noiseReductionMode'];
    String? noiseReductionModeValue;
    if (hasNoiseReductionMode && noiseReductionModeRaw != null) {
      if (noiseReductionModeRaw is! String ||
          !const <String>['off', 'fast', 'highQuality'].contains(noiseReductionModeRaw)) {
        throw FormatException("CameraSettings.noiseReductionMode: unknown enum value '$noiseReductionModeRaw'");
      }
      noiseReductionModeValue = noiseReductionModeRaw;
    } else if (hasNoiseReductionMode && noiseReductionModeRaw == null) {
      throw FormatException('CameraSettings.noiseReductionMode: null is not allowed');
    }
    final hasEdgeEnhancementMode = raw.containsKey('edgeEnhancementMode');
    final edgeEnhancementModeRaw = raw['edgeEnhancementMode'];
    String? edgeEnhancementModeValue;
    if (hasEdgeEnhancementMode && edgeEnhancementModeRaw != null) {
      if (edgeEnhancementModeRaw is! String ||
          !const <String>['off', 'fast', 'highQuality'].contains(edgeEnhancementModeRaw)) {
        throw FormatException("CameraSettings.edgeEnhancementMode: unknown enum value '$edgeEnhancementModeRaw'");
      }
      edgeEnhancementModeValue = edgeEnhancementModeRaw;
    } else if (hasEdgeEnhancementMode && edgeEnhancementModeRaw == null) {
      throw FormatException('CameraSettings.edgeEnhancementMode: null is not allowed');
    }
    final hasRegionStrategy = raw.containsKey('regionStrategy');
    final regionStrategyRaw = raw['regionStrategy'];
    String? regionStrategyValue;
    if (hasRegionStrategy && regionStrategyRaw != null) {
      if (regionStrategyRaw is! String ||
          !const <String>['default', 'point', 'spot', 'area', 'matchWithScanArea'].contains(regionStrategyRaw)) {
        throw FormatException("CameraSettings.regionStrategy: unknown enum value '$regionStrategyRaw'");
      }
      regionStrategyValue = regionStrategyRaw;
    } else if (hasRegionStrategy && regionStrategyRaw == null) {
      throw FormatException('CameraSettings.regionStrategy: null is not allowed');
    }
    final hasArbitraryVideoResolution = raw.containsKey('arbitraryVideoResolution');
    final arbitraryVideoResolutionRaw = raw['arbitraryVideoResolution'];
    CameraSettingsArbitraryVideoResolution? arbitraryVideoResolutionValue;
    if (hasArbitraryVideoResolution && arbitraryVideoResolutionRaw != null) {
      arbitraryVideoResolutionValue = CameraSettingsArbitraryVideoResolution.fromJson(arbitraryVideoResolutionRaw);
    } else if (hasArbitraryVideoResolution && arbitraryVideoResolutionRaw == null) {
      throw FormatException('CameraSettings.arbitraryVideoResolution: null is not allowed');
    }
    return CameraSettings(
      recommendedForMode: recommendedForModeValue,
      preferredResolution: preferredResolutionValue,
      preferredAspectRatio: preferredAspectRatioValue,
      minFrameRate: minFrameRateValue,
      maxFrameRate: maxFrameRateValue,
      preferredFrameRateRange: preferredFrameRateRangeValue,
      zoomFactor: zoomFactorValue,
      zoomGestureZoomFactor: zoomGestureZoomFactorValue,
      zoomLevels: zoomLevelsValue,
      macroMode: macroModeValue,
      manualUntilCaptureTimeout: manualUntilCaptureTimeoutValue,
      adaptiveExposure: adaptiveExposureValue,
      torchLevel: torchLevelValue,
      focus: focusValue,
      api: apiValue,
      exposureTargetBias: exposureTargetBiasValue,
      colorCorrection: colorCorrectionValue,
      toneMappingCurve: toneMappingCurveValue,
      noiseReductionMode: noiseReductionModeValue,
      edgeEnhancementMode: edgeEnhancementModeValue,
      regionStrategy: regionStrategyValue,
      arbitraryVideoResolution: arbitraryVideoResolutionValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (recommendedForMode != null) {
      map['recommendedForMode'] = recommendedForMode;
    }
    if (preferredResolution != null) {
      map['preferredResolution'] = preferredResolution;
    }
    if (preferredAspectRatio != null) {
      map['preferredAspectRatio'] = preferredAspectRatio;
    }
    if (minFrameRate != null) {
      map['minFrameRate'] = minFrameRate;
    }
    if (maxFrameRate != null) {
      map['maxFrameRate'] = maxFrameRate;
    }
    if (preferredFrameRateRange != null) {
      map['preferredFrameRateRange'] = preferredFrameRateRange;
    }
    if (zoomFactor != null) {
      map['zoomFactor'] = zoomFactor;
    }
    if (zoomGestureZoomFactor != null) {
      map['zoomGestureZoomFactor'] = zoomGestureZoomFactor;
    }
    if (zoomLevels != null) {
      map['zoomLevels'] = zoomLevels;
    }
    if (macroMode != null) {
      map['macroMode'] = macroMode;
    }
    if (manualUntilCaptureTimeout != null) {
      map['manualUntilCaptureTimeout'] = manualUntilCaptureTimeout;
    }
    if (adaptiveExposure != null) {
      map['adaptiveExposure'] = adaptiveExposure;
    }
    if (torchLevel != null) {
      map['torchLevel'] = torchLevel;
    }
    if (focus != null) {
      map['focus'] = focus!.toJson();
    }
    if (api != null) {
      map['api'] = api;
    }
    if (exposureTargetBias != null) {
      map['exposureTargetBias'] = exposureTargetBias;
    }
    if (colorCorrection != null) {
      map['colorCorrection'] = colorCorrection;
    }
    if (toneMappingCurve != null) {
      map['toneMappingCurve'] = toneMappingCurve;
    }
    if (noiseReductionMode != null) {
      map['noiseReductionMode'] = noiseReductionMode;
    }
    if (edgeEnhancementMode != null) {
      map['edgeEnhancementMode'] = edgeEnhancementMode;
    }
    if (regionStrategy != null) {
      map['regionStrategy'] = regionStrategy;
    }
    if (arbitraryVideoResolution != null) {
      map['arbitraryVideoResolution'] = arbitraryVideoResolution!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `CameraSettings` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildCameraSettings({
  String? recommendedForMode,
  String? preferredResolution,
  String? preferredAspectRatio,
  double? minFrameRate,
  double? maxFrameRate,
  String? preferredFrameRateRange,
  double? zoomFactor,
  double? zoomGestureZoomFactor,
  List<double>? zoomLevels,
  String? macroMode,
  int? manualUntilCaptureTimeout,
  bool? adaptiveExposure,
  double? torchLevel,
  Object? focus,
  int? api,
  double? exposureTargetBias,
  bool? colorCorrection,
  String? toneMappingCurve,
  String? noiseReductionMode,
  String? edgeEnhancementMode,
  String? regionStrategy,
  Object? arbitraryVideoResolution,
}) {
  final map = <String, Object?>{};
  if (recommendedForMode != null) {
    map['recommendedForMode'] = recommendedForMode;
  }
  if (preferredResolution != null) {
    map['preferredResolution'] = preferredResolution;
  }
  if (preferredAspectRatio != null) {
    map['preferredAspectRatio'] = preferredAspectRatio;
  }
  if (minFrameRate != null) {
    map['minFrameRate'] = minFrameRate;
  }
  if (maxFrameRate != null) {
    map['maxFrameRate'] = maxFrameRate;
  }
  if (preferredFrameRateRange != null) {
    map['preferredFrameRateRange'] = preferredFrameRateRange;
  }
  if (zoomFactor != null) {
    map['zoomFactor'] = zoomFactor;
  }
  if (zoomGestureZoomFactor != null) {
    map['zoomGestureZoomFactor'] = zoomGestureZoomFactor;
  }
  if (zoomLevels != null) {
    map['zoomLevels'] = zoomLevels;
  }
  if (macroMode != null) {
    map['macroMode'] = macroMode;
  }
  if (manualUntilCaptureTimeout != null) {
    map['manualUntilCaptureTimeout'] = manualUntilCaptureTimeout;
  }
  if (adaptiveExposure != null) {
    map['adaptiveExposure'] = adaptiveExposure;
  }
  if (torchLevel != null) {
    map['torchLevel'] = torchLevel;
  }
  if (focus != null) {
    map['focus'] = focus;
  }
  if (api != null) {
    map['api'] = api;
  }
  if (exposureTargetBias != null) {
    map['exposureTargetBias'] = exposureTargetBias;
  }
  if (colorCorrection != null) {
    map['colorCorrection'] = colorCorrection;
  }
  if (toneMappingCurve != null) {
    map['toneMappingCurve'] = toneMappingCurve;
  }
  if (noiseReductionMode != null) {
    map['noiseReductionMode'] = noiseReductionMode;
  }
  if (edgeEnhancementMode != null) {
    map['edgeEnhancementMode'] = edgeEnhancementMode;
  }
  if (regionStrategy != null) {
    map['regionStrategy'] = regionStrategy;
  }
  if (arbitraryVideoResolution != null) {
    map['arbitraryVideoResolution'] = arbitraryVideoResolution;
  }
  return map;
}

///
class FocusSettings {
  final String? range;
  final double? manualLensPosition;
  final bool? shouldPreferSmoothAutoFocus;
  final String? focusStrategy;
  final String? focusGestureStrategy;

  const FocusSettings({
    this.range,
    this.manualLensPosition,
    this.shouldPreferSmoothAutoFocus,
    this.focusStrategy,
    this.focusGestureStrategy,
  });

  factory FocusSettings.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('FocusSettings: expected a Map');
    }
    const allowedKeys = <String>{
      'range',
      'manualLensPosition',
      'shouldPreferSmoothAutoFocus',
      'focusStrategy',
      'focusGestureStrategy',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("FocusSettings: unknown property '$key'");
      }
    }
    final hasRange = raw.containsKey('range');
    final rangeRaw = raw['range'];
    String? rangeValue;
    if (hasRange && rangeRaw != null) {
      if (rangeRaw is! String || !const <String>['full', 'far', 'near'].contains(rangeRaw)) {
        throw FormatException("FocusSettings.range: unknown enum value '$rangeRaw'");
      }
      rangeValue = rangeRaw;
    } else if (hasRange && rangeRaw == null) {
      throw FormatException('FocusSettings.range: null is not allowed');
    }
    final hasManualLensPosition = raw.containsKey('manualLensPosition');
    final manualLensPositionRaw = raw['manualLensPosition'];
    double? manualLensPositionValue;
    if (hasManualLensPosition && manualLensPositionRaw != null) {
      if (manualLensPositionRaw is! num) {
        throw FormatException('FocusSettings.manualLensPosition: expected a number');
      }
      manualLensPositionValue = manualLensPositionRaw.toDouble();
    } else if (hasManualLensPosition && manualLensPositionRaw == null) {
      throw FormatException('FocusSettings.manualLensPosition: null is not allowed');
    }
    final hasShouldPreferSmoothAutoFocus = raw.containsKey('shouldPreferSmoothAutoFocus');
    final shouldPreferSmoothAutoFocusRaw = raw['shouldPreferSmoothAutoFocus'];
    bool? shouldPreferSmoothAutoFocusValue;
    if (hasShouldPreferSmoothAutoFocus && shouldPreferSmoothAutoFocusRaw != null) {
      if (shouldPreferSmoothAutoFocusRaw is! bool) {
        throw FormatException('FocusSettings.shouldPreferSmoothAutoFocus: expected a bool');
      }
      shouldPreferSmoothAutoFocusValue = shouldPreferSmoothAutoFocusRaw;
    } else if (hasShouldPreferSmoothAutoFocus && shouldPreferSmoothAutoFocusRaw == null) {
      throw FormatException('FocusSettings.shouldPreferSmoothAutoFocus: null is not allowed');
    }
    final hasFocusStrategy = raw.containsKey('focusStrategy');
    final focusStrategyRaw = raw['focusStrategy'];
    String? focusStrategyValue;
    if (hasFocusStrategy && focusStrategyRaw != null) {
      if (focusStrategyRaw is! String ||
          !const <String>[
            'auto',
            'onlyOnRequest',
            'forceContinuous',
            'forceRetrigger',
            'retriggerUntilScan',
            'continuousUntilNoScan'
          ].contains(focusStrategyRaw)) {
        throw FormatException("FocusSettings.focusStrategy: unknown enum value '$focusStrategyRaw'");
      }
      focusStrategyValue = focusStrategyRaw;
    } else if (hasFocusStrategy && focusStrategyRaw == null) {
      throw FormatException('FocusSettings.focusStrategy: null is not allowed');
    }
    final hasFocusGestureStrategy = raw.containsKey('focusGestureStrategy');
    final focusGestureStrategyRaw = raw['focusGestureStrategy'];
    String? focusGestureStrategyValue;
    if (hasFocusGestureStrategy && focusGestureStrategyRaw != null) {
      if (focusGestureStrategyRaw is! String ||
          !const <String>['none', 'manual', 'manualUntilCapture', 'autoOnLocation'].contains(focusGestureStrategyRaw)) {
        throw FormatException("FocusSettings.focusGestureStrategy: unknown enum value '$focusGestureStrategyRaw'");
      }
      focusGestureStrategyValue = focusGestureStrategyRaw;
    } else if (hasFocusGestureStrategy && focusGestureStrategyRaw == null) {
      throw FormatException('FocusSettings.focusGestureStrategy: null is not allowed');
    }
    return FocusSettings(
      range: rangeValue,
      manualLensPosition: manualLensPositionValue,
      shouldPreferSmoothAutoFocus: shouldPreferSmoothAutoFocusValue,
      focusStrategy: focusStrategyValue,
      focusGestureStrategy: focusGestureStrategyValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (range != null) {
      map['range'] = range;
    }
    if (manualLensPosition != null) {
      map['manualLensPosition'] = manualLensPosition;
    }
    if (shouldPreferSmoothAutoFocus != null) {
      map['shouldPreferSmoothAutoFocus'] = shouldPreferSmoothAutoFocus;
    }
    if (focusStrategy != null) {
      map['focusStrategy'] = focusStrategy;
    }
    if (focusGestureStrategy != null) {
      map['focusGestureStrategy'] = focusGestureStrategy;
    }
    return map;
  }
}

/// Typed builder for the `FocusSettings` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildFocusSettings({
  String? range,
  double? manualLensPosition,
  bool? shouldPreferSmoothAutoFocus,
  String? focusStrategy,
  String? focusGestureStrategy,
}) {
  final map = <String, Object?>{};
  if (range != null) {
    map['range'] = range;
  }
  if (manualLensPosition != null) {
    map['manualLensPosition'] = manualLensPosition;
  }
  if (shouldPreferSmoothAutoFocus != null) {
    map['shouldPreferSmoothAutoFocus'] = shouldPreferSmoothAutoFocus;
  }
  if (focusStrategy != null) {
    map['focusStrategy'] = focusStrategy;
  }
  if (focusGestureStrategy != null) {
    map['focusGestureStrategy'] = focusGestureStrategy;
  }
  return map;
}

/// Request a specific resolution. The camera will use the closest available resolution to this value.
class CameraSettingsArbitraryVideoResolution {
  final double width;
  final double height;

  const CameraSettingsArbitraryVideoResolution({
    required this.width,
    required this.height,
  });

  factory CameraSettingsArbitraryVideoResolution.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('CameraSettingsArbitraryVideoResolution: expected a Map');
    }
    const allowedKeys = <String>{
      'width',
      'height',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("CameraSettingsArbitraryVideoResolution: unknown property '$key'");
      }
    }
    final hasWidth = raw.containsKey('width');
    if (!hasWidth) {
      throw FormatException("CameraSettingsArbitraryVideoResolution.width: missing required property");
    }
    final widthRaw = raw['width'];
    double? widthValue;
    if (hasWidth && widthRaw != null) {
      if (widthRaw is! num) {
        throw FormatException('CameraSettingsArbitraryVideoResolution.width: expected a number');
      }
      widthValue = widthRaw.toDouble();
    } else if (hasWidth && widthRaw == null) {
      throw FormatException('CameraSettingsArbitraryVideoResolution.width: null is not allowed');
    }
    final hasHeight = raw.containsKey('height');
    if (!hasHeight) {
      throw FormatException("CameraSettingsArbitraryVideoResolution.height: missing required property");
    }
    final heightRaw = raw['height'];
    double? heightValue;
    if (hasHeight && heightRaw != null) {
      if (heightRaw is! num) {
        throw FormatException('CameraSettingsArbitraryVideoResolution.height: expected a number');
      }
      heightValue = heightRaw.toDouble();
    } else if (hasHeight && heightRaw == null) {
      throw FormatException('CameraSettingsArbitraryVideoResolution.height: null is not allowed');
    }
    return CameraSettingsArbitraryVideoResolution(
      width: widthValue!,
      height: heightValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['width'] = width;
    map['height'] = height;
    return map;
  }
}

/// Typed builder for the `CameraSettingsArbitraryVideoResolution` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildCameraSettingsArbitraryVideoResolution({
  required double width,
  required double height,
}) {
  final map = <String, Object?>{};
  map['width'] = width;
  map['height'] = height;
  return map;
}

/// A frame source that feeds a single static image into the capture pipeline.
class ImageFrameSource implements FrameSource {
  final String type;
  final String? id;
  final String image;

  const ImageFrameSource({
    required this.type,
    this.id,
    required this.image,
  });

  factory ImageFrameSource.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('ImageFrameSource: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'id',
      'image',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("ImageFrameSource: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("ImageFrameSource.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['image'].contains(typeRaw)) {
        throw FormatException("ImageFrameSource.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('ImageFrameSource.type: null is not allowed');
    }
    final hasId = raw.containsKey('id');
    final idRaw = raw['id'];
    String? idValue;
    if (hasId && idRaw != null) {
      if (idRaw is! String) {
        throw FormatException('ImageFrameSource.id: expected a String');
      }
      idValue = idRaw;
    } else if (hasId && idRaw == null) {
      throw FormatException('ImageFrameSource.id: null is not allowed');
    }
    final hasImage = raw.containsKey('image');
    if (!hasImage) {
      throw FormatException("ImageFrameSource.image: missing required property");
    }
    final imageRaw = raw['image'];
    String? imageValue;
    if (hasImage && imageRaw != null) {
      if (imageRaw is! String) {
        throw FormatException('ImageFrameSource.image: expected a String');
      }
      imageValue = imageRaw;
    } else if (hasImage && imageRaw == null) {
      throw FormatException('ImageFrameSource.image: null is not allowed');
    }
    return ImageFrameSource(
      type: typeValue!,
      id: idValue,
      image: imageValue!,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (id != null) {
      map['id'] = id;
    }
    map['image'] = image;
    return map;
  }
}

/// Typed builder for the `ImageFrameSource` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildImageFrameSource({
  required String type,
  String? id,
  required String image,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (id != null) {
    map['id'] = id;
  }
  map['image'] = image;
  return map;
}

/// A frame source that processes externally provided frames in the order they are added.
class SequenceFrameSource implements FrameSource {
  final String type;
  final String? id;
  final String position;
  final double? lensPosition;
  final String? desiredState;

  const SequenceFrameSource({
    required this.type,
    this.id,
    required this.position,
    this.lensPosition,
    this.desiredState,
  });

  factory SequenceFrameSource.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('SequenceFrameSource: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'id',
      'position',
      'lensPosition',
      'desiredState',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("SequenceFrameSource: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("SequenceFrameSource.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['sequence'].contains(typeRaw)) {
        throw FormatException("SequenceFrameSource.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('SequenceFrameSource.type: null is not allowed');
    }
    final hasId = raw.containsKey('id');
    final idRaw = raw['id'];
    String? idValue;
    if (hasId && idRaw != null) {
      if (idRaw is! String) {
        throw FormatException('SequenceFrameSource.id: expected a String');
      }
      idValue = idRaw;
    } else if (hasId && idRaw == null) {
      throw FormatException('SequenceFrameSource.id: null is not allowed');
    }
    final hasPosition = raw.containsKey('position');
    if (!hasPosition) {
      throw FormatException("SequenceFrameSource.position: missing required property");
    }
    final positionRaw = raw['position'];
    String? positionValue;
    if (hasPosition && positionRaw != null) {
      if (positionRaw is! String || !const <String>['worldFacing', 'userFacing', 'unspecified'].contains(positionRaw)) {
        throw FormatException("SequenceFrameSource.position: unknown enum value '$positionRaw'");
      }
      positionValue = positionRaw;
    } else if (hasPosition && positionRaw == null) {
      throw FormatException('SequenceFrameSource.position: null is not allowed');
    }
    final hasLensPosition = raw.containsKey('lensPosition');
    final lensPositionRaw = raw['lensPosition'];
    double? lensPositionValue;
    if (hasLensPosition && lensPositionRaw != null) {
      if (lensPositionRaw is! num) {
        throw FormatException('SequenceFrameSource.lensPosition: expected a number');
      }
      lensPositionValue = lensPositionRaw.toDouble();
    } else if (hasLensPosition && lensPositionRaw == null) {
      throw FormatException('SequenceFrameSource.lensPosition: null is not allowed');
    }
    final hasDesiredState = raw.containsKey('desiredState');
    final desiredStateRaw = raw['desiredState'];
    String? desiredStateValue;
    if (hasDesiredState && desiredStateRaw != null) {
      if (desiredStateRaw is! String || !const <String>['on', 'off', 'standby'].contains(desiredStateRaw)) {
        throw FormatException("SequenceFrameSource.desiredState: unknown enum value '$desiredStateRaw'");
      }
      desiredStateValue = desiredStateRaw;
    } else if (hasDesiredState && desiredStateRaw == null) {
      throw FormatException('SequenceFrameSource.desiredState: null is not allowed');
    }
    return SequenceFrameSource(
      type: typeValue!,
      id: idValue,
      position: positionValue!,
      lensPosition: lensPositionValue,
      desiredState: desiredStateValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (id != null) {
      map['id'] = id;
    }
    map['position'] = position;
    if (lensPosition != null) {
      map['lensPosition'] = lensPosition;
    }
    if (desiredState != null) {
      map['desiredState'] = desiredState;
    }
    return map;
  }
}

/// Typed builder for the `SequenceFrameSource` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildSequenceFrameSource({
  required String type,
  String? id,
  required String position,
  double? lensPosition,
  String? desiredState,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (id != null) {
    map['id'] = id;
  }
  map['position'] = position;
  if (lensPosition != null) {
    map['lensPosition'] = lensPosition;
  }
  if (desiredState != null) {
    map['desiredState'] = desiredState;
  }
  return map;
}

/// Discriminated union of all data capture modes. The type field selects the concrete schema.
// NOTE: `abstract class`, not `abstract interface class`. The generated Dart
// must parse under the OLDEST toolchain in CI -- validate-bridge-generator's
// `dart format` runs on an older Dart SDK that does not understand Dart 3.0+
// class modifiers (`interface`, `sealed`, `base`, `final class`,
// `mixin class`). The docs signature collector moved to `analyzer ^7.7.1` in
// SDC-33150 and parses those fine, so it is no longer part of this
// constraint; `dart format` still is. `abstract class` is implementable in
// Dart 2 and 3 alike, so it preserves the same "implement, don't extend"
// contract without the modifier.
abstract class Mode {
  Map<String, Object?> toJson();

  factory Mode.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('Mode: expected a Map');
    }
    final discriminant = raw['type'];
    switch (discriminant) {
      case 'barcodeCapture':
        return BarcodeCapture.fromJson(raw);
      case 'barcodeTracking':
        return BarcodeTracking.fromJson(raw);
      case 'barcodeSelection':
        return BarcodeSelection.fromJson(raw);
      case 'sparkScan':
        return SparkScan.fromJson(raw);
      case 'labelCapture':
        return LabelCapture.fromJson(raw);
      case 'idCapture':
        return IdCapture.fromJson(raw);
      case 'textCapture':
        return TextCapture.fromJson(raw);
      case 'barcodeFind':
        return BarcodeFind.fromJson(raw);
      case 'barcodeAr':
        return BarcodeAr.fromJson(raw);
      case 'barcodePick':
        return BarcodePick.fromJson(raw);
      case 'barcodeCount':
        return BarcodeCount.fromJson(raw);
      case 'barcodeSequence':
        return BarcodeSequence.fromJson(raw);
      default:
        throw FormatException(
          "Mode: unknown type '$discriminant'",
        );
    }
  }
}

/// The barcode capture mode.
class BarcodeCapture implements Mode {
  final String type;
  final BarcodeCaptureFeedback? feedback;
  final BarcodeCaptureSettings? settings;
  final bool? enabled;
  final int? modeId;
  final int? parentId;
  final bool? hasListeners;

  const BarcodeCapture({
    required this.type,
    this.feedback,
    this.settings,
    this.enabled,
    this.modeId,
    this.parentId,
    this.hasListeners,
  });

  factory BarcodeCapture.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('BarcodeCapture: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'feedback',
      'settings',
      'enabled',
      'modeId',
      'parentId',
      'hasListeners',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("BarcodeCapture: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("BarcodeCapture.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['barcodeCapture'].contains(typeRaw)) {
        throw FormatException("BarcodeCapture.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('BarcodeCapture.type: null is not allowed');
    }
    final hasFeedback = raw.containsKey('feedback');
    final feedbackRaw = raw['feedback'];
    BarcodeCaptureFeedback? feedbackValue;
    if (hasFeedback && feedbackRaw != null) {
      feedbackValue = BarcodeCaptureFeedback.fromJson(feedbackRaw);
    } else if (hasFeedback && feedbackRaw == null) {
      throw FormatException('BarcodeCapture.feedback: null is not allowed');
    }
    final hasSettings = raw.containsKey('settings');
    final settingsRaw = raw['settings'];
    BarcodeCaptureSettings? settingsValue;
    if (hasSettings && settingsRaw != null) {
      settingsValue = BarcodeCaptureSettings.fromJson(settingsRaw);
    } else if (hasSettings && settingsRaw == null) {
      throw FormatException('BarcodeCapture.settings: null is not allowed');
    }
    final hasEnabled = raw.containsKey('enabled');
    final enabledRaw = raw['enabled'];
    bool? enabledValue;
    if (hasEnabled && enabledRaw != null) {
      if (enabledRaw is! bool) {
        throw FormatException('BarcodeCapture.enabled: expected a bool');
      }
      enabledValue = enabledRaw;
    } else if (hasEnabled && enabledRaw == null) {
      throw FormatException('BarcodeCapture.enabled: null is not allowed');
    }
    final hasModeId = raw.containsKey('modeId');
    final modeIdRaw = raw['modeId'];
    int? modeIdValue;
    if (hasModeId && modeIdRaw != null) {
      if (modeIdRaw is! num) {
        throw FormatException('BarcodeCapture.modeId: expected a number');
      }
      if (modeIdRaw != modeIdRaw.toInt()) {
        throw FormatException('BarcodeCapture.modeId: expected an integer');
      }
      modeIdValue = modeIdRaw.toInt();
    } else if (hasModeId && modeIdRaw == null) {
      throw FormatException('BarcodeCapture.modeId: null is not allowed');
    }
    final hasParentId = raw.containsKey('parentId');
    final parentIdRaw = raw['parentId'];
    int? parentIdValue;
    if (hasParentId && parentIdRaw != null) {
      if (parentIdRaw is! num) {
        throw FormatException('BarcodeCapture.parentId: expected a number');
      }
      if (parentIdRaw != parentIdRaw.toInt()) {
        throw FormatException('BarcodeCapture.parentId: expected an integer');
      }
      parentIdValue = parentIdRaw.toInt();
    }
    final hasHasListeners = raw.containsKey('hasListeners');
    final hasListenersRaw = raw['hasListeners'];
    bool? hasListenersValue;
    if (hasHasListeners && hasListenersRaw != null) {
      if (hasListenersRaw is! bool) {
        throw FormatException('BarcodeCapture.hasListeners: expected a bool');
      }
      hasListenersValue = hasListenersRaw;
    } else if (hasHasListeners && hasListenersRaw == null) {
      throw FormatException('BarcodeCapture.hasListeners: null is not allowed');
    }
    return BarcodeCapture(
      type: typeValue!,
      feedback: feedbackValue,
      settings: settingsValue,
      enabled: enabledValue,
      modeId: modeIdValue,
      parentId: parentIdValue,
      hasListeners: hasListenersValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (feedback != null) {
      map['feedback'] = feedback!.toJson();
    }
    if (settings != null) {
      map['settings'] = settings!.toJson();
    }
    if (enabled != null) {
      map['enabled'] = enabled;
    }
    if (modeId != null) {
      map['modeId'] = modeId;
    }
    if (parentId != null) {
      map['parentId'] = parentId;
    }
    if (hasListeners != null) {
      map['hasListeners'] = hasListeners;
    }
    return map;
  }
}

/// Typed builder for the `BarcodeCapture` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildBarcodeCapture({
  required String type,
  Object? feedback,
  Object? settings,
  bool? enabled,
  int? modeId,
  Object? parentId = _unset,
  bool? hasListeners,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (feedback != null) {
    map['feedback'] = feedback;
  }
  if (settings != null) {
    map['settings'] = settings;
  }
  if (enabled != null) {
    map['enabled'] = enabled;
  }
  if (modeId != null) {
    map['modeId'] = modeId;
  }
  if (!identical(parentId, _unset)) {
    map['parentId'] = parentId;
  }
  if (hasListeners != null) {
    map['hasListeners'] = hasListeners;
  }
  return map;
}

/// Feedback configuration for barcode capture events.
class BarcodeCaptureFeedback {
  final Feedback? success;

  const BarcodeCaptureFeedback({
    this.success,
  });

  factory BarcodeCaptureFeedback.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('BarcodeCaptureFeedback: expected a Map');
    }
    const allowedKeys = <String>{
      'success',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("BarcodeCaptureFeedback: unknown property '$key'");
      }
    }
    final hasSuccess = raw.containsKey('success');
    final successRaw = raw['success'];
    Feedback? successValue;
    if (hasSuccess && successRaw != null) {
      successValue = Feedback.fromJson(successRaw);
    } else if (hasSuccess && successRaw == null) {
      throw FormatException('BarcodeCaptureFeedback.success: null is not allowed');
    }
    return BarcodeCaptureFeedback(
      success: successValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (success != null) {
      map['success'] = success!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `BarcodeCaptureFeedback` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildBarcodeCaptureFeedback({
  Object? success,
}) {
  final map = <String, Object?>{};
  if (success != null) {
    map['success'] = success;
  }
  return map;
}

/// Audio and haptic feedback for scan events.
class Feedback {
  final Sound? sound;
  final Vibration? vibration;

  const Feedback({
    this.sound,
    this.vibration,
  });

  factory Feedback.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('Feedback: expected a Map');
    }
    const allowedKeys = <String>{
      'sound',
      'vibration',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("Feedback: unknown property '$key'");
      }
    }
    final hasSound = raw.containsKey('sound');
    final soundRaw = raw['sound'];
    Sound? soundValue;
    if (hasSound && soundRaw != null) {
      soundValue = Sound.fromJson(soundRaw);
    }
    final hasVibration = raw.containsKey('vibration');
    final vibrationRaw = raw['vibration'];
    Vibration? vibrationValue;
    if (hasVibration && vibrationRaw != null) {
      vibrationValue = Vibration.fromJson(vibrationRaw);
    }
    return Feedback(
      sound: soundValue,
      vibration: vibrationValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (sound != null) {
      map['sound'] = sound!.toJson();
    }
    if (vibration != null) {
      map['vibration'] = vibration!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `Feedback` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildFeedback({
  Object? sound = _unset,
  Object? vibration = _unset,
}) {
  final map = <String, Object?>{};
  if (!identical(sound, _unset)) {
    map['sound'] = sound;
  }
  if (!identical(vibration, _unset)) {
    map['vibration'] = vibration;
  }
  return map;
}

///
class Sound {
  final String? resource;

  const Sound({
    this.resource,
  });

  factory Sound.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('Sound: expected a Map');
    }
    const allowedKeys = <String>{
      'resource',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("Sound: unknown property '$key'");
      }
    }
    final hasResource = raw.containsKey('resource');
    final resourceRaw = raw['resource'];
    String? resourceValue;
    if (hasResource && resourceRaw != null) {
      if (resourceRaw is! String) {
        throw FormatException('Sound.resource: expected a String');
      }
      resourceValue = resourceRaw;
    } else if (hasResource && resourceRaw == null) {
      throw FormatException('Sound.resource: null is not allowed');
    }
    return Sound(
      resource: resourceValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (resource != null) {
      map['resource'] = resource;
    }
    return map;
  }
}

/// Typed builder for the `Sound` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildSound({
  String? resource,
}) {
  final map = <String, Object?>{};
  if (resource != null) {
    map['resource'] = resource;
  }
  return map;
}

///
class Vibration {
  final String? type;
  final List<int>? timings;
  final List<int>? amplitudes;

  const Vibration({
    this.type,
    this.timings,
    this.amplitudes,
  });

  factory Vibration.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('Vibration: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'timings',
      'amplitudes',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("Vibration: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String ||
          !const <String>[
            'default',
            'selectionHaptic',
            'successHaptic',
            'impactHaptic',
            'impactHapticLight',
            'failureHaptic',
            'waveForm'
          ].contains(typeRaw)) {
        throw FormatException("Vibration.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('Vibration.type: null is not allowed');
    }
    final hasTimings = raw.containsKey('timings');
    final timingsRaw = raw['timings'];
    List<int>? timingsValue;
    if (hasTimings && timingsRaw != null) {
      if (timingsRaw is! List) {
        throw FormatException('Vibration.timings: expected a List');
      }
      for (final item in timingsRaw) {
        if (item is! num) {
          throw FormatException('Vibration.timings: expected a List of num');
        }
        if (item != item.toInt()) {
          throw FormatException('Vibration.timings: expected a List of integers');
        }
      }
      timingsValue = timingsRaw.map((item) => (item as num).toInt()).toList();
    } else if (hasTimings && timingsRaw == null) {
      throw FormatException('Vibration.timings: null is not allowed');
    }
    final hasAmplitudes = raw.containsKey('amplitudes');
    final amplitudesRaw = raw['amplitudes'];
    List<int>? amplitudesValue;
    if (hasAmplitudes && amplitudesRaw != null) {
      if (amplitudesRaw is! List) {
        throw FormatException('Vibration.amplitudes: expected a List');
      }
      for (final item in amplitudesRaw) {
        if (item is! num) {
          throw FormatException('Vibration.amplitudes: expected a List of num');
        }
        if (item != item.toInt()) {
          throw FormatException('Vibration.amplitudes: expected a List of integers');
        }
      }
      amplitudesValue = amplitudesRaw.map((item) => (item as num).toInt()).toList();
    } else if (hasAmplitudes && amplitudesRaw == null) {
      throw FormatException('Vibration.amplitudes: null is not allowed');
    }
    return Vibration(
      type: typeValue,
      timings: timingsValue,
      amplitudes: amplitudesValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (type != null) {
      map['type'] = type;
    }
    if (timings != null) {
      map['timings'] = timings;
    }
    if (amplitudes != null) {
      map['amplitudes'] = amplitudes;
    }
    return map;
  }
}

/// Typed builder for the `Vibration` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildVibration({
  String? type,
  List<int>? timings,
  List<int>? amplitudes,
}) {
  final map = <String, Object?>{};
  if (type != null) {
    map['type'] = type;
  }
  if (timings != null) {
    map['timings'] = timings;
  }
  if (amplitudes != null) {
    map['amplitudes'] = amplitudes;
  }
  return map;
}

/// Settings that configure barcode capture behavior.
class BarcodeCaptureSettings {
  final int? codeDuplicateFilter;
  final SymbologySettings? symbologies;
  final LocationSelection? locationSelection;
  final List<String>? enabledCompositeTypes;
  final ArucoDictionary? arucoDictionary;
  final BatterySavingMode? batterySavingMode;
  final BatterySavingMode? batterySaving;
  final ScanIntention? scanIntention;
  final SelectionMode? selectionMode;

  /// Keys present in the payload that have no emitted field -- undeclared
  /// keys, plus schema-declared properties that are `hidden` or non-mobile and
  /// therefore get no field of their own. Re-emitted by [toJson] so the round
  /// trip is lossless. See the passthrough contract in this file's header.
  final Map<String, Object?> additionalProperties;

  const BarcodeCaptureSettings({
    this.codeDuplicateFilter,
    this.symbologies,
    this.locationSelection,
    this.enabledCompositeTypes,
    this.arucoDictionary,
    this.batterySavingMode,
    this.batterySaving,
    this.scanIntention,
    this.selectionMode,
    this.additionalProperties = const {},
  });

  factory BarcodeCaptureSettings.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('BarcodeCaptureSettings: expected a Map');
    }
    final hasCodeDuplicateFilter = raw.containsKey('codeDuplicateFilter');
    final codeDuplicateFilterRaw = raw['codeDuplicateFilter'];
    int? codeDuplicateFilterValue;
    if (hasCodeDuplicateFilter && codeDuplicateFilterRaw != null) {
      if (codeDuplicateFilterRaw is! num) {
        throw FormatException('BarcodeCaptureSettings.codeDuplicateFilter: expected a number');
      }
      if (codeDuplicateFilterRaw != codeDuplicateFilterRaw.toInt()) {
        throw FormatException('BarcodeCaptureSettings.codeDuplicateFilter: expected an integer');
      }
      codeDuplicateFilterValue = codeDuplicateFilterRaw.toInt();
    } else if (hasCodeDuplicateFilter && codeDuplicateFilterRaw == null) {
      throw FormatException('BarcodeCaptureSettings.codeDuplicateFilter: null is not allowed');
    }
    final hasSymbologies = raw.containsKey('symbologies');
    final symbologiesRaw = raw['symbologies'];
    SymbologySettings? symbologiesValue;
    if (hasSymbologies && symbologiesRaw != null) {
      symbologiesValue = parseSymbologySettings(symbologiesRaw);
    } else if (hasSymbologies && symbologiesRaw == null) {
      throw FormatException('BarcodeCaptureSettings.symbologies: null is not allowed');
    }
    final hasLocationSelection = raw.containsKey('locationSelection');
    final locationSelectionRaw = raw['locationSelection'];
    LocationSelection? locationSelectionValue;
    if (hasLocationSelection && locationSelectionRaw != null) {
      locationSelectionValue = LocationSelection.fromJson(locationSelectionRaw);
    }
    final hasEnabledCompositeTypes = raw.containsKey('enabledCompositeTypes');
    final enabledCompositeTypesRaw = raw['enabledCompositeTypes'];
    List<String>? enabledCompositeTypesValue;
    if (hasEnabledCompositeTypes && enabledCompositeTypesRaw != null) {
      if (enabledCompositeTypesRaw is! List) {
        throw FormatException('BarcodeCaptureSettings.enabledCompositeTypes: expected a List');
      }
      for (final item in enabledCompositeTypesRaw) {
        if (item is! String || !const <String>['a', 'b', 'c'].contains(item)) {
          throw FormatException("BarcodeCaptureSettings.enabledCompositeTypes: unknown enum value '$item'");
        }
      }
      enabledCompositeTypesValue = enabledCompositeTypesRaw.cast<String>();
    } else if (hasEnabledCompositeTypes && enabledCompositeTypesRaw == null) {
      throw FormatException('BarcodeCaptureSettings.enabledCompositeTypes: null is not allowed');
    }
    final hasArucoDictionary = raw.containsKey('arucoDictionary');
    final arucoDictionaryRaw = raw['arucoDictionary'];
    ArucoDictionary? arucoDictionaryValue;
    if (hasArucoDictionary && arucoDictionaryRaw != null) {
      arucoDictionaryValue = ArucoDictionary.fromJson(arucoDictionaryRaw);
    }
    final hasBatterySavingMode = raw.containsKey('batterySavingMode');
    final batterySavingModeRaw = raw['batterySavingMode'];
    BatterySavingMode? batterySavingModeValue;
    if (hasBatterySavingMode && batterySavingModeRaw != null) {
      batterySavingModeValue = (batterySavingModeRaw is! String
          ? (throw FormatException('BarcodeCaptureSettings.batterySavingMode: expected a String for BatterySavingMode'))
          : BatterySavingMode.fromJSON(batterySavingModeRaw));
    } else if (hasBatterySavingMode && batterySavingModeRaw == null) {
      throw FormatException('BarcodeCaptureSettings.batterySavingMode: null is not allowed');
    }
    final hasBatterySaving = raw.containsKey('batterySaving');
    final batterySavingRaw = raw['batterySaving'];
    BatterySavingMode? batterySavingValue;
    if (hasBatterySaving && batterySavingRaw != null) {
      batterySavingValue = (batterySavingRaw is! String
          ? (throw FormatException('BarcodeCaptureSettings.batterySaving: expected a String for BatterySavingMode'))
          : BatterySavingMode.fromJSON(batterySavingRaw));
    } else if (hasBatterySaving && batterySavingRaw == null) {
      throw FormatException('BarcodeCaptureSettings.batterySaving: null is not allowed');
    }
    final hasScanIntention = raw.containsKey('scanIntention');
    final scanIntentionRaw = raw['scanIntention'];
    ScanIntention? scanIntentionValue;
    if (hasScanIntention && scanIntentionRaw != null) {
      scanIntentionValue = (scanIntentionRaw is! String
          ? (throw FormatException('BarcodeCaptureSettings.scanIntention: expected a String for ScanIntention'))
          : ScanIntention.fromJSON(scanIntentionRaw));
    } else if (hasScanIntention && scanIntentionRaw == null) {
      throw FormatException('BarcodeCaptureSettings.scanIntention: null is not allowed');
    }
    final hasSelectionMode = raw.containsKey('selectionMode');
    final selectionModeRaw = raw['selectionMode'];
    SelectionMode? selectionModeValue;
    if (hasSelectionMode && selectionModeRaw != null) {
      selectionModeValue = (selectionModeRaw is! String
          ? (throw FormatException('BarcodeCaptureSettings.selectionMode: expected a String for SelectionMode'))
          : SelectionMode.fromJSON(selectionModeRaw));
    } else if (hasSelectionMode && selectionModeRaw == null) {
      throw FormatException('BarcodeCaptureSettings.selectionMode: null is not allowed');
    }
    const emittedKeys = <String>{
      'codeDuplicateFilter',
      'symbologies',
      'locationSelection',
      'enabledCompositeTypes',
      'arucoDictionary',
      'batterySavingMode',
      'batterySaving',
      'scanIntention',
      'selectionMode',
    };
    final additionalPropertiesCollected = <String, Object?>{};
    for (final key in raw.keys) {
      // A non-String key never matches `emittedKeys` (a Set<String>), so
      // every one of them reaches this throw: an open class rejects
      // non-String keys outright.
      if (!emittedKeys.contains(key)) {
        if (key is! String) {
          throw FormatException('BarcodeCaptureSettings: expected a String key');
        }
        additionalPropertiesCollected[key] = raw[key];
      }
    }
    return BarcodeCaptureSettings(
      codeDuplicateFilter: codeDuplicateFilterValue,
      symbologies: symbologiesValue,
      locationSelection: locationSelectionValue,
      enabledCompositeTypes: enabledCompositeTypesValue,
      arucoDictionary: arucoDictionaryValue,
      batterySavingMode: batterySavingModeValue,
      batterySaving: batterySavingValue,
      scanIntention: scanIntentionValue,
      selectionMode: selectionModeValue,
      additionalProperties: Map.unmodifiable(additionalPropertiesCollected),
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (codeDuplicateFilter != null) {
      map['codeDuplicateFilter'] = codeDuplicateFilter;
    }
    if (symbologies != null) {
      map['symbologies'] = symbologies;
    }
    if (locationSelection != null) {
      map['locationSelection'] = locationSelection!.toJson();
    }
    if (enabledCompositeTypes != null) {
      map['enabledCompositeTypes'] = enabledCompositeTypes;
    }
    if (arucoDictionary != null) {
      map['arucoDictionary'] = arucoDictionary!.toJson();
    }
    if (batterySavingMode != null) {
      map['batterySavingMode'] = batterySavingMode!.toJson();
    }
    if (batterySaving != null) {
      map['batterySaving'] = batterySaving!.toJson();
    }
    if (scanIntention != null) {
      map['scanIntention'] = scanIntention!.toJson();
    }
    if (selectionMode != null) {
      map['selectionMode'] = selectionMode!.toJson();
    }
    for (final entry in additionalProperties.entries) {
      if (!map.containsKey(entry.key)) {
        map[entry.key] = entry.value;
      }
    }
    return map;
  }
}

/// Typed builder for the `BarcodeCaptureSettings` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildBarcodeCaptureSettings({
  int? codeDuplicateFilter,
  SymbologySettings? symbologies,
  Object? locationSelection = _unset,
  List<String>? enabledCompositeTypes,
  Object? arucoDictionary = _unset,
  Object? batterySavingMode,
  Object? batterySaving,
  Object? scanIntention,
  Object? selectionMode,
}) {
  final map = <String, Object?>{};
  if (codeDuplicateFilter != null) {
    map['codeDuplicateFilter'] = codeDuplicateFilter;
  }
  if (symbologies != null) {
    map['symbologies'] = symbologies;
  }
  if (!identical(locationSelection, _unset)) {
    map['locationSelection'] = locationSelection;
  }
  if (enabledCompositeTypes != null) {
    map['enabledCompositeTypes'] = enabledCompositeTypes;
  }
  if (!identical(arucoDictionary, _unset)) {
    map['arucoDictionary'] = arucoDictionary;
  }
  if (batterySavingMode != null) {
    map['batterySavingMode'] = batterySavingMode;
  }
  if (batterySaving != null) {
    map['batterySaving'] = batterySaving;
  }
  if (scanIntention != null) {
    map['scanIntention'] = scanIntention;
  }
  if (selectionMode != null) {
    map['selectionMode'] = selectionMode;
  }
  return map;
}

/// Symbology configuration — either an array of symbology identifiers to enable, or an object mapping each symbology to its detailed configuration.
typedef SymbologySettings = Object;

SymbologySettings parseSymbologySettings(Object? raw) {
  if (raw == null) {
    throw FormatException('SymbologySettings: expected a non-null value');
  }
  return raw;
}

/// A location selection — discriminated union of no, radius, or rectangular selection.
// NOTE: `abstract class`, not `abstract interface class`. The generated Dart
// must parse under the OLDEST toolchain in CI -- validate-bridge-generator's
// `dart format` runs on an older Dart SDK that does not understand Dart 3.0+
// class modifiers (`interface`, `sealed`, `base`, `final class`,
// `mixin class`). The docs signature collector moved to `analyzer ^7.7.1` in
// SDC-33150 and parses those fine, so it is no longer part of this
// constraint; `dart format` still is. `abstract class` is implementable in
// Dart 2 and 3 alike, so it preserves the same "implement, don't extend"
// contract without the modifier.
abstract class LocationSelection {
  Map<String, Object?> toJson();

  factory LocationSelection.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LocationSelection: expected a Map');
    }
    final discriminant = raw['type'];
    switch (discriminant) {
      case 'none':
        return NoLocationSelection.fromJson(raw);
      case 'radius':
        return RadiusLocationSelection.fromJson(raw);
      case 'rectangular':
        return RectangularLocationSelection.fromJson(raw);
      default:
        throw FormatException(
          "LocationSelection: unknown type '$discriminant'",
        );
    }
  }
}

/// No location selection — the full scan area is used.
class NoLocationSelection implements LocationSelection {
  final String type;

  const NoLocationSelection({
    required this.type,
  });

  factory NoLocationSelection.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('NoLocationSelection: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("NoLocationSelection: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("NoLocationSelection.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['none'].contains(typeRaw)) {
        throw FormatException("NoLocationSelection.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('NoLocationSelection.type: null is not allowed');
    }
    return NoLocationSelection(
      type: typeValue!,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    return map;
  }
}

/// Typed builder for the `NoLocationSelection` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildNoLocationSelection({
  required String type,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  return map;
}

/// A circular location selection.
class RadiusLocationSelection implements LocationSelection {
  final String type;
  final UIValue radius;

  const RadiusLocationSelection({
    required this.type,
    required this.radius,
  });

  factory RadiusLocationSelection.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('RadiusLocationSelection: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'radius',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("RadiusLocationSelection: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("RadiusLocationSelection.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['radius'].contains(typeRaw)) {
        throw FormatException("RadiusLocationSelection.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('RadiusLocationSelection.type: null is not allowed');
    }
    final hasRadius = raw.containsKey('radius');
    if (!hasRadius) {
      throw FormatException("RadiusLocationSelection.radius: missing required property");
    }
    final radiusRaw = raw['radius'];
    UIValue? radiusValue;
    if (hasRadius && radiusRaw != null) {
      radiusValue = UIValue.fromJson(radiusRaw);
    } else if (hasRadius && radiusRaw == null) {
      throw FormatException('RadiusLocationSelection.radius: null is not allowed');
    }
    return RadiusLocationSelection(
      type: typeValue!,
      radius: radiusValue!,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    map['radius'] = radius.toJson();
    return map;
  }
}

/// Typed builder for the `RadiusLocationSelection` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildRadiusLocationSelection({
  required String type,
  required Object radius,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  map['radius'] = radius;
  return map;
}

/// A value with a unit for UI measurements.
class UIValue {
  final double? value;
  final String? unit;

  const UIValue({
    this.value,
    this.unit,
  });

  factory UIValue.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('UIValue: expected a Map');
    }
    const allowedKeys = <String>{
      'value',
      'unit',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("UIValue: unknown property '$key'");
      }
    }
    final hasValue = raw.containsKey('value');
    final valueRaw = raw['value'];
    double? valueValue;
    if (hasValue && valueRaw != null) {
      if (valueRaw is! num) {
        throw FormatException('UIValue.value: expected a number');
      }
      valueValue = valueRaw.toDouble();
    } else if (hasValue && valueRaw == null) {
      throw FormatException('UIValue.value: null is not allowed');
    }
    final hasUnit = raw.containsKey('unit');
    final unitRaw = raw['unit'];
    String? unitValue;
    if (hasUnit && unitRaw != null) {
      if (unitRaw is! String || !const <String>['fraction', 'pixel', 'dip'].contains(unitRaw)) {
        throw FormatException("UIValue.unit: unknown enum value '$unitRaw'");
      }
      unitValue = unitRaw;
    } else if (hasUnit && unitRaw == null) {
      throw FormatException('UIValue.unit: null is not allowed');
    }
    return UIValue(
      value: valueValue,
      unit: unitValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (value != null) {
      map['value'] = value;
    }
    if (unit != null) {
      map['unit'] = unit;
    }
    return map;
  }
}

/// Typed builder for the `UIValue` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildUIValue({
  double? value,
  String? unit,
}) {
  final map = <String, Object?>{};
  if (value != null) {
    map['value'] = value;
  }
  if (unit != null) {
    map['unit'] = unit;
  }
  return map;
}

/// A rectangular location selection.
class RectangularLocationSelection implements LocationSelection {
  final String type;
  final UIAspectSize size;

  const RectangularLocationSelection({
    required this.type,
    required this.size,
  });

  factory RectangularLocationSelection.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('RectangularLocationSelection: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'size',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("RectangularLocationSelection: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("RectangularLocationSelection.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['rectangular'].contains(typeRaw)) {
        throw FormatException("RectangularLocationSelection.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('RectangularLocationSelection.type: null is not allowed');
    }
    final hasSize = raw.containsKey('size');
    if (!hasSize) {
      throw FormatException("RectangularLocationSelection.size: missing required property");
    }
    final sizeRaw = raw['size'];
    UIAspectSize? sizeValue;
    if (hasSize && sizeRaw != null) {
      sizeValue = UIAspectSize.fromJson(sizeRaw);
    } else if (hasSize && sizeRaw == null) {
      throw FormatException('RectangularLocationSelection.size: null is not allowed');
    }
    return RectangularLocationSelection(
      type: typeValue!,
      size: sizeValue!,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    map['size'] = size.toJson();
    return map;
  }
}

/// Typed builder for the `RectangularLocationSelection` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildRectangularLocationSelection({
  required String type,
  required Object size,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  map['size'] = size;
  return map;
}

/// A size specification that can be defined by width/height or shorter dimension/aspect ratio.
class UIAspectSize {
  final UIValue? width;
  final UIValue? height;
  final UIValue? shorterDimension;
  final double? aspect;

  const UIAspectSize({
    this.width,
    this.height,
    this.shorterDimension,
    this.aspect,
  });

  factory UIAspectSize.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('UIAspectSize: expected a Map');
    }
    const allowedKeys = <String>{
      'width',
      'height',
      'shorterDimension',
      'aspect',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("UIAspectSize: unknown property '$key'");
      }
    }
    final hasWidth = raw.containsKey('width');
    final widthRaw = raw['width'];
    UIValue? widthValue;
    if (hasWidth && widthRaw != null) {
      widthValue = UIValue.fromJson(widthRaw);
    } else if (hasWidth && widthRaw == null) {
      throw FormatException('UIAspectSize.width: null is not allowed');
    }
    final hasHeight = raw.containsKey('height');
    final heightRaw = raw['height'];
    UIValue? heightValue;
    if (hasHeight && heightRaw != null) {
      heightValue = UIValue.fromJson(heightRaw);
    } else if (hasHeight && heightRaw == null) {
      throw FormatException('UIAspectSize.height: null is not allowed');
    }
    final hasShorterDimension = raw.containsKey('shorterDimension');
    final shorterDimensionRaw = raw['shorterDimension'];
    UIValue? shorterDimensionValue;
    if (hasShorterDimension && shorterDimensionRaw != null) {
      shorterDimensionValue = UIValue.fromJson(shorterDimensionRaw);
    } else if (hasShorterDimension && shorterDimensionRaw == null) {
      throw FormatException('UIAspectSize.shorterDimension: null is not allowed');
    }
    final hasAspect = raw.containsKey('aspect');
    final aspectRaw = raw['aspect'];
    double? aspectValue;
    if (hasAspect && aspectRaw != null) {
      if (aspectRaw is! num) {
        throw FormatException('UIAspectSize.aspect: expected a number');
      }
      aspectValue = aspectRaw.toDouble();
    } else if (hasAspect && aspectRaw == null) {
      throw FormatException('UIAspectSize.aspect: null is not allowed');
    }
    return UIAspectSize(
      width: widthValue,
      height: heightValue,
      shorterDimension: shorterDimensionValue,
      aspect: aspectValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (width != null) {
      map['width'] = width!.toJson();
    }
    if (height != null) {
      map['height'] = height!.toJson();
    }
    if (shorterDimension != null) {
      map['shorterDimension'] = shorterDimension!.toJson();
    }
    if (aspect != null) {
      map['aspect'] = aspect;
    }
    return map;
  }
}

/// Typed builder for the `UIAspectSize` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildUIAspectSize({
  Object? width,
  Object? height,
  Object? shorterDimension,
  double? aspect,
}) {
  final map = <String, Object?>{};
  if (width != null) {
    map['width'] = width;
  }
  if (height != null) {
    map['height'] = height;
  }
  if (shorterDimension != null) {
    map['shorterDimension'] = shorterDimension;
  }
  if (aspect != null) {
    map['aspect'] = aspect;
  }
  return map;
}

/// An ArUco dictionary defined by a preset or by custom markers and marker size.
class ArucoDictionary {
  final String? preset;
  final int? markerSize;
  final List<ArucoMarker>? markers;

  const ArucoDictionary({
    this.preset,
    this.markerSize,
    this.markers,
  });

  factory ArucoDictionary.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('ArucoDictionary: expected a Map');
    }
    const allowedKeys = <String>{
      'preset',
      'markerSize',
      'markers',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("ArucoDictionary: unknown property '$key'");
      }
    }
    final hasPreset = raw.containsKey('preset');
    final presetRaw = raw['preset'];
    String? presetValue;
    if (hasPreset && presetRaw != null) {
      if (presetRaw is! String ||
          !const <String>['4X4_250', '5X5_50', '5X5_100', '5X5_250', '5X5_1000', '5X5_1023', '6X6_250']
              .contains(presetRaw)) {
        throw FormatException("ArucoDictionary.preset: unknown enum value '$presetRaw'");
      }
      presetValue = presetRaw;
    } else if (hasPreset && presetRaw == null) {
      throw FormatException('ArucoDictionary.preset: null is not allowed');
    }
    final hasMarkerSize = raw.containsKey('markerSize');
    final markerSizeRaw = raw['markerSize'];
    int? markerSizeValue;
    if (hasMarkerSize && markerSizeRaw != null) {
      if (markerSizeRaw is! num) {
        throw FormatException('ArucoDictionary.markerSize: expected a number');
      }
      if (markerSizeRaw != markerSizeRaw.toInt()) {
        throw FormatException('ArucoDictionary.markerSize: expected an integer');
      }
      markerSizeValue = markerSizeRaw.toInt();
    } else if (hasMarkerSize && markerSizeRaw == null) {
      throw FormatException('ArucoDictionary.markerSize: null is not allowed');
    }
    final hasMarkers = raw.containsKey('markers');
    final markersRaw = raw['markers'];
    List<ArucoMarker>? markersValue;
    if (hasMarkers && markersRaw != null) {
      if (markersRaw is! List) {
        throw FormatException('ArucoDictionary.markers: expected a List');
      }
      markersValue = markersRaw.map((item) => ArucoMarker.fromJson(item)).toList();
    } else if (hasMarkers && markersRaw == null) {
      throw FormatException('ArucoDictionary.markers: null is not allowed');
    }
    return ArucoDictionary(
      preset: presetValue,
      markerSize: markerSizeValue,
      markers: markersValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (preset != null) {
      map['preset'] = preset;
    }
    if (markerSize != null) {
      map['markerSize'] = markerSize;
    }
    if (markers != null) {
      map['markers'] = markers!.map((item) => item.toJson()).toList();
    }
    return map;
  }
}

/// Typed builder for the `ArucoDictionary` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildArucoDictionary({
  String? preset,
  int? markerSize,
  List<Object?>? markers,
}) {
  final map = <String, Object?>{};
  if (preset != null) {
    map['preset'] = preset;
  }
  if (markerSize != null) {
    map['markerSize'] = markerSize;
  }
  if (markers != null) {
    map['markers'] = markers;
  }
  return map;
}

/// A single ArUco marker defined by its size and binary pixel data.
class ArucoMarker {
  final int? markerSize;
  final String? markerData;

  const ArucoMarker({
    this.markerSize,
    this.markerData,
  });

  factory ArucoMarker.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('ArucoMarker: expected a Map');
    }
    const allowedKeys = <String>{
      'markerSize',
      'markerData',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("ArucoMarker: unknown property '$key'");
      }
    }
    final hasMarkerSize = raw.containsKey('markerSize');
    final markerSizeRaw = raw['markerSize'];
    int? markerSizeValue;
    if (hasMarkerSize && markerSizeRaw != null) {
      if (markerSizeRaw is! num) {
        throw FormatException('ArucoMarker.markerSize: expected a number');
      }
      if (markerSizeRaw != markerSizeRaw.toInt()) {
        throw FormatException('ArucoMarker.markerSize: expected an integer');
      }
      markerSizeValue = markerSizeRaw.toInt();
    } else if (hasMarkerSize && markerSizeRaw == null) {
      throw FormatException('ArucoMarker.markerSize: null is not allowed');
    }
    final hasMarkerData = raw.containsKey('markerData');
    final markerDataRaw = raw['markerData'];
    String? markerDataValue;
    if (hasMarkerData && markerDataRaw != null) {
      if (markerDataRaw is! String) {
        throw FormatException('ArucoMarker.markerData: expected a String');
      }
      markerDataValue = markerDataRaw;
    } else if (hasMarkerData && markerDataRaw == null) {
      throw FormatException('ArucoMarker.markerData: null is not allowed');
    }
    return ArucoMarker(
      markerSize: markerSizeValue,
      markerData: markerDataValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (markerSize != null) {
      map['markerSize'] = markerSize;
    }
    if (markerData != null) {
      map['markerData'] = markerData;
    }
    return map;
  }
}

/// Typed builder for the `ArucoMarker` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildArucoMarker({
  int? markerSize,
  String? markerData,
}) {
  final map = <String, Object?>{};
  if (markerSize != null) {
    map['markerSize'] = markerSize;
  }
  if (markerData != null) {
    map['markerData'] = markerData;
  }
  return map;
}

/// The battery saving mode for the data capture context.
enum BatterySavingMode {
  on$('on'),
  off('off'),
  auto('auto');

  const BatterySavingMode(this.jsonValue);

  final String jsonValue;

  static BatterySavingMode fromJSON(String jsonValue) {
    for (final value in BatterySavingMode.values) {
      if (value.jsonValue == jsonValue) {
        return value;
      }
    }
    throw FormatException("BatterySavingMode: unknown enum value '$jsonValue'");
  }

  String toJson() => jsonValue;
}

/// The scan intention mode controlling when scanning is triggered. The 'smartSelection' value is deprecated since 8.5 (migrated to smart + selectionMode=auto) and scheduled for removal in 9.0, but is still accepted as input.
enum ScanIntention {
  manual('manual'),
  smart('smart'),
  smartSelection('smartSelection');

  const ScanIntention(this.jsonValue);

  final String jsonValue;

  static ScanIntention fromJSON(String jsonValue) {
    for (final value in ScanIntention.values) {
      if (value.jsonValue == jsonValue) {
        return value;
      }
    }
    throw FormatException("ScanIntention: unknown enum value '$jsonValue'");
  }

  String toJson() => jsonValue;
}

/// Controls whether aimed barcodes are selected automatically or held for explicit confirmation.
enum SelectionMode {
  off('off'),
  on$('on'),
  auto('auto');

  const SelectionMode(this.jsonValue);

  final String jsonValue;

  static SelectionMode fromJSON(String jsonValue) {
    for (final value in SelectionMode.values) {
      if (value.jsonValue == jsonValue) {
        return value;
      }
    }
    throw FormatException("SelectionMode: unknown enum value '$jsonValue'");
  }

  String toJson() => jsonValue;
}

/// The barcode tracking mode.
class BarcodeTracking implements Mode {
  final String type;
  final BarcodeTrackingSettings? settings;
  final bool? enabled;
  final int? modeId;
  final bool? hasListeners;
  final int? parentId;

  const BarcodeTracking({
    required this.type,
    this.settings,
    this.enabled,
    this.modeId,
    this.hasListeners,
    this.parentId,
  });

  factory BarcodeTracking.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('BarcodeTracking: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'settings',
      'enabled',
      'modeId',
      'hasListeners',
      'parentId',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("BarcodeTracking: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("BarcodeTracking.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['barcodeTracking'].contains(typeRaw)) {
        throw FormatException("BarcodeTracking.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('BarcodeTracking.type: null is not allowed');
    }
    final hasSettings = raw.containsKey('settings');
    final settingsRaw = raw['settings'];
    BarcodeTrackingSettings? settingsValue;
    if (hasSettings && settingsRaw != null) {
      settingsValue = BarcodeTrackingSettings.fromJson(settingsRaw);
    } else if (hasSettings && settingsRaw == null) {
      throw FormatException('BarcodeTracking.settings: null is not allowed');
    }
    final hasEnabled = raw.containsKey('enabled');
    final enabledRaw = raw['enabled'];
    bool? enabledValue;
    if (hasEnabled && enabledRaw != null) {
      if (enabledRaw is! bool) {
        throw FormatException('BarcodeTracking.enabled: expected a bool');
      }
      enabledValue = enabledRaw;
    } else if (hasEnabled && enabledRaw == null) {
      throw FormatException('BarcodeTracking.enabled: null is not allowed');
    }
    final hasModeId = raw.containsKey('modeId');
    final modeIdRaw = raw['modeId'];
    int? modeIdValue;
    if (hasModeId && modeIdRaw != null) {
      if (modeIdRaw is! num) {
        throw FormatException('BarcodeTracking.modeId: expected a number');
      }
      if (modeIdRaw != modeIdRaw.toInt()) {
        throw FormatException('BarcodeTracking.modeId: expected an integer');
      }
      modeIdValue = modeIdRaw.toInt();
    } else if (hasModeId && modeIdRaw == null) {
      throw FormatException('BarcodeTracking.modeId: null is not allowed');
    }
    final hasHasListeners = raw.containsKey('hasListeners');
    final hasListenersRaw = raw['hasListeners'];
    bool? hasListenersValue;
    if (hasHasListeners && hasListenersRaw != null) {
      if (hasListenersRaw is! bool) {
        throw FormatException('BarcodeTracking.hasListeners: expected a bool');
      }
      hasListenersValue = hasListenersRaw;
    } else if (hasHasListeners && hasListenersRaw == null) {
      throw FormatException('BarcodeTracking.hasListeners: null is not allowed');
    }
    final hasParentId = raw.containsKey('parentId');
    final parentIdRaw = raw['parentId'];
    int? parentIdValue;
    if (hasParentId && parentIdRaw != null) {
      if (parentIdRaw is! num) {
        throw FormatException('BarcodeTracking.parentId: expected a number');
      }
      if (parentIdRaw != parentIdRaw.toInt()) {
        throw FormatException('BarcodeTracking.parentId: expected an integer');
      }
      parentIdValue = parentIdRaw.toInt();
    }
    return BarcodeTracking(
      type: typeValue!,
      settings: settingsValue,
      enabled: enabledValue,
      modeId: modeIdValue,
      hasListeners: hasListenersValue,
      parentId: parentIdValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (settings != null) {
      map['settings'] = settings!.toJson();
    }
    if (enabled != null) {
      map['enabled'] = enabled;
    }
    if (modeId != null) {
      map['modeId'] = modeId;
    }
    if (hasListeners != null) {
      map['hasListeners'] = hasListeners;
    }
    if (parentId != null) {
      map['parentId'] = parentId;
    }
    return map;
  }
}

/// Typed builder for the `BarcodeTracking` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildBarcodeTracking({
  required String type,
  Object? settings,
  bool? enabled,
  int? modeId,
  bool? hasListeners,
  Object? parentId = _unset,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (settings != null) {
    map['settings'] = settings;
  }
  if (enabled != null) {
    map['enabled'] = enabled;
  }
  if (modeId != null) {
    map['modeId'] = modeId;
  }
  if (hasListeners != null) {
    map['hasListeners'] = hasListeners;
  }
  if (!identical(parentId, _unset)) {
    map['parentId'] = parentId;
  }
  return map;
}

/// Settings that configure barcode tracking behavior.
class BarcodeTrackingSettings {
  @Deprecated('since 6.26')
  final String? scenario;
  final SymbologySettings? symbologies;
  final bool? expectOnlyUniqueBarcodes;
  final ArucoDictionary? arucoDictionary;

  /// Keys present in the payload that have no emitted field -- undeclared
  /// keys, plus schema-declared properties that are `hidden` or non-mobile and
  /// therefore get no field of their own. Re-emitted by [toJson] so the round
  /// trip is lossless. See the passthrough contract in this file's header.
  final Map<String, Object?> additionalProperties;

  const BarcodeTrackingSettings({
    this.scenario,
    this.symbologies,
    this.expectOnlyUniqueBarcodes,
    this.arucoDictionary,
    this.additionalProperties = const {},
  });

  factory BarcodeTrackingSettings.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('BarcodeTrackingSettings: expected a Map');
    }
    final hasScenario = raw.containsKey('scenario');
    final scenarioRaw = raw['scenario'];
    String? scenarioValue;
    if (hasScenario && scenarioRaw != null) {
      if (scenarioRaw is! String) {
        throw FormatException('BarcodeTrackingSettings.scenario: expected a String');
      }
      scenarioValue = scenarioRaw;
    } else if (hasScenario && scenarioRaw == null) {
      throw FormatException('BarcodeTrackingSettings.scenario: null is not allowed');
    }
    final hasSymbologies = raw.containsKey('symbologies');
    final symbologiesRaw = raw['symbologies'];
    SymbologySettings? symbologiesValue;
    if (hasSymbologies && symbologiesRaw != null) {
      symbologiesValue = parseSymbologySettings(symbologiesRaw);
    } else if (hasSymbologies && symbologiesRaw == null) {
      throw FormatException('BarcodeTrackingSettings.symbologies: null is not allowed');
    }
    final hasExpectOnlyUniqueBarcodes = raw.containsKey('expectOnlyUniqueBarcodes');
    final expectOnlyUniqueBarcodesRaw = raw['expectOnlyUniqueBarcodes'];
    bool? expectOnlyUniqueBarcodesValue;
    if (hasExpectOnlyUniqueBarcodes && expectOnlyUniqueBarcodesRaw != null) {
      if (expectOnlyUniqueBarcodesRaw is! bool) {
        throw FormatException('BarcodeTrackingSettings.expectOnlyUniqueBarcodes: expected a bool');
      }
      expectOnlyUniqueBarcodesValue = expectOnlyUniqueBarcodesRaw;
    } else if (hasExpectOnlyUniqueBarcodes && expectOnlyUniqueBarcodesRaw == null) {
      throw FormatException('BarcodeTrackingSettings.expectOnlyUniqueBarcodes: null is not allowed');
    }
    final hasArucoDictionary = raw.containsKey('arucoDictionary');
    final arucoDictionaryRaw = raw['arucoDictionary'];
    ArucoDictionary? arucoDictionaryValue;
    if (hasArucoDictionary && arucoDictionaryRaw != null) {
      arucoDictionaryValue = ArucoDictionary.fromJson(arucoDictionaryRaw);
    }
    const emittedKeys = <String>{
      'scenario',
      'symbologies',
      'expectOnlyUniqueBarcodes',
      'arucoDictionary',
    };
    final additionalPropertiesCollected = <String, Object?>{};
    for (final key in raw.keys) {
      // A non-String key never matches `emittedKeys` (a Set<String>), so
      // every one of them reaches this throw: an open class rejects
      // non-String keys outright.
      if (!emittedKeys.contains(key)) {
        if (key is! String) {
          throw FormatException('BarcodeTrackingSettings: expected a String key');
        }
        additionalPropertiesCollected[key] = raw[key];
      }
    }
    return BarcodeTrackingSettings(
      scenario: scenarioValue,
      symbologies: symbologiesValue,
      expectOnlyUniqueBarcodes: expectOnlyUniqueBarcodesValue,
      arucoDictionary: arucoDictionaryValue,
      additionalProperties: Map.unmodifiable(additionalPropertiesCollected),
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (scenario != null) {
      map['scenario'] = scenario;
    }
    if (symbologies != null) {
      map['symbologies'] = symbologies;
    }
    if (expectOnlyUniqueBarcodes != null) {
      map['expectOnlyUniqueBarcodes'] = expectOnlyUniqueBarcodes;
    }
    if (arucoDictionary != null) {
      map['arucoDictionary'] = arucoDictionary!.toJson();
    }
    for (final entry in additionalProperties.entries) {
      if (!map.containsKey(entry.key)) {
        map[entry.key] = entry.value;
      }
    }
    return map;
  }
}

/// Typed builder for the `BarcodeTrackingSettings` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildBarcodeTrackingSettings({
  String? scenario,
  SymbologySettings? symbologies,
  bool? expectOnlyUniqueBarcodes,
  Object? arucoDictionary = _unset,
}) {
  final map = <String, Object?>{};
  if (scenario != null) {
    map['scenario'] = scenario;
  }
  if (symbologies != null) {
    map['symbologies'] = symbologies;
  }
  if (expectOnlyUniqueBarcodes != null) {
    map['expectOnlyUniqueBarcodes'] = expectOnlyUniqueBarcodes;
  }
  if (!identical(arucoDictionary, _unset)) {
    map['arucoDictionary'] = arucoDictionary;
  }
  return map;
}

/// The barcode selection mode for selecting individual barcodes.
class BarcodeSelection implements Mode {
  final String type;
  final BarcodeSelectionFeedback? feedback;
  final BarcodeSelectionSettings? settings;
  final bool? enabled;
  final UIPoint? pointOfInterest;
  final int? modeId;
  final int? parentId;
  final bool? hasListeners;

  const BarcodeSelection({
    required this.type,
    this.feedback,
    this.settings,
    this.enabled,
    this.pointOfInterest,
    this.modeId,
    this.parentId,
    this.hasListeners,
  });

  factory BarcodeSelection.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('BarcodeSelection: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'feedback',
      'settings',
      'enabled',
      'pointOfInterest',
      'modeId',
      'parentId',
      'hasListeners',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("BarcodeSelection: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("BarcodeSelection.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['barcodeSelection'].contains(typeRaw)) {
        throw FormatException("BarcodeSelection.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('BarcodeSelection.type: null is not allowed');
    }
    final hasFeedback = raw.containsKey('feedback');
    final feedbackRaw = raw['feedback'];
    BarcodeSelectionFeedback? feedbackValue;
    if (hasFeedback && feedbackRaw != null) {
      feedbackValue = BarcodeSelectionFeedback.fromJson(feedbackRaw);
    } else if (hasFeedback && feedbackRaw == null) {
      throw FormatException('BarcodeSelection.feedback: null is not allowed');
    }
    final hasSettings = raw.containsKey('settings');
    final settingsRaw = raw['settings'];
    BarcodeSelectionSettings? settingsValue;
    if (hasSettings && settingsRaw != null) {
      settingsValue = BarcodeSelectionSettings.fromJson(settingsRaw);
    } else if (hasSettings && settingsRaw == null) {
      throw FormatException('BarcodeSelection.settings: null is not allowed');
    }
    final hasEnabled = raw.containsKey('enabled');
    final enabledRaw = raw['enabled'];
    bool? enabledValue;
    if (hasEnabled && enabledRaw != null) {
      if (enabledRaw is! bool) {
        throw FormatException('BarcodeSelection.enabled: expected a bool');
      }
      enabledValue = enabledRaw;
    } else if (hasEnabled && enabledRaw == null) {
      throw FormatException('BarcodeSelection.enabled: null is not allowed');
    }
    final hasPointOfInterest = raw.containsKey('pointOfInterest');
    final pointOfInterestRaw = raw['pointOfInterest'];
    UIPoint? pointOfInterestValue;
    if (hasPointOfInterest && pointOfInterestRaw != null) {
      pointOfInterestValue = UIPoint.fromJson(pointOfInterestRaw);
    }
    final hasModeId = raw.containsKey('modeId');
    final modeIdRaw = raw['modeId'];
    int? modeIdValue;
    if (hasModeId && modeIdRaw != null) {
      if (modeIdRaw is! num) {
        throw FormatException('BarcodeSelection.modeId: expected a number');
      }
      if (modeIdRaw != modeIdRaw.toInt()) {
        throw FormatException('BarcodeSelection.modeId: expected an integer');
      }
      modeIdValue = modeIdRaw.toInt();
    } else if (hasModeId && modeIdRaw == null) {
      throw FormatException('BarcodeSelection.modeId: null is not allowed');
    }
    final hasParentId = raw.containsKey('parentId');
    final parentIdRaw = raw['parentId'];
    int? parentIdValue;
    if (hasParentId && parentIdRaw != null) {
      if (parentIdRaw is! num) {
        throw FormatException('BarcodeSelection.parentId: expected a number');
      }
      if (parentIdRaw != parentIdRaw.toInt()) {
        throw FormatException('BarcodeSelection.parentId: expected an integer');
      }
      parentIdValue = parentIdRaw.toInt();
    }
    final hasHasListeners = raw.containsKey('hasListeners');
    final hasListenersRaw = raw['hasListeners'];
    bool? hasListenersValue;
    if (hasHasListeners && hasListenersRaw != null) {
      if (hasListenersRaw is! bool) {
        throw FormatException('BarcodeSelection.hasListeners: expected a bool');
      }
      hasListenersValue = hasListenersRaw;
    } else if (hasHasListeners && hasListenersRaw == null) {
      throw FormatException('BarcodeSelection.hasListeners: null is not allowed');
    }
    return BarcodeSelection(
      type: typeValue!,
      feedback: feedbackValue,
      settings: settingsValue,
      enabled: enabledValue,
      pointOfInterest: pointOfInterestValue,
      modeId: modeIdValue,
      parentId: parentIdValue,
      hasListeners: hasListenersValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (feedback != null) {
      map['feedback'] = feedback!.toJson();
    }
    if (settings != null) {
      map['settings'] = settings!.toJson();
    }
    if (enabled != null) {
      map['enabled'] = enabled;
    }
    if (pointOfInterest != null) {
      map['pointOfInterest'] = pointOfInterest!.toJson();
    }
    if (modeId != null) {
      map['modeId'] = modeId;
    }
    if (parentId != null) {
      map['parentId'] = parentId;
    }
    if (hasListeners != null) {
      map['hasListeners'] = hasListeners;
    }
    return map;
  }
}

/// Typed builder for the `BarcodeSelection` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildBarcodeSelection({
  required String type,
  Object? feedback,
  Object? settings,
  bool? enabled,
  Object? pointOfInterest = _unset,
  int? modeId,
  Object? parentId = _unset,
  bool? hasListeners,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (feedback != null) {
    map['feedback'] = feedback;
  }
  if (settings != null) {
    map['settings'] = settings;
  }
  if (enabled != null) {
    map['enabled'] = enabled;
  }
  if (!identical(pointOfInterest, _unset)) {
    map['pointOfInterest'] = pointOfInterest;
  }
  if (modeId != null) {
    map['modeId'] = modeId;
  }
  if (!identical(parentId, _unset)) {
    map['parentId'] = parentId;
  }
  if (hasListeners != null) {
    map['hasListeners'] = hasListeners;
  }
  return map;
}

/// Feedback configuration for barcode selection events.
class BarcodeSelectionFeedback {
  final Feedback? selection;

  const BarcodeSelectionFeedback({
    this.selection,
  });

  factory BarcodeSelectionFeedback.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('BarcodeSelectionFeedback: expected a Map');
    }
    const allowedKeys = <String>{
      'selection',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("BarcodeSelectionFeedback: unknown property '$key'");
      }
    }
    final hasSelection = raw.containsKey('selection');
    final selectionRaw = raw['selection'];
    Feedback? selectionValue;
    if (hasSelection && selectionRaw != null) {
      selectionValue = Feedback.fromJson(selectionRaw);
    } else if (hasSelection && selectionRaw == null) {
      throw FormatException('BarcodeSelectionFeedback.selection: null is not allowed');
    }
    return BarcodeSelectionFeedback(
      selection: selectionValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (selection != null) {
      map['selection'] = selection!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `BarcodeSelectionFeedback` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildBarcodeSelectionFeedback({
  Object? selection,
}) {
  final map = <String, Object?>{};
  if (selection != null) {
    map['selection'] = selection;
  }
  return map;
}

/// Settings that configure barcode selection behavior.
class BarcodeSelectionSettings {
  final SymbologySettings? symbologies;
  final SelectionType? selectionType;
  final bool? singleBarcodeAutoDetectionEnabled;
  final int? codeDuplicateFilter;
  final bool? tapGestureForSelectionEnabled;
  final bool? swipeGesturesEnabled;

  /// Keys present in the payload that have no emitted field -- undeclared
  /// keys, plus schema-declared properties that are `hidden` or non-mobile and
  /// therefore get no field of their own. Re-emitted by [toJson] so the round
  /// trip is lossless. See the passthrough contract in this file's header.
  final Map<String, Object?> additionalProperties;

  const BarcodeSelectionSettings({
    this.symbologies,
    this.selectionType,
    this.singleBarcodeAutoDetectionEnabled,
    this.codeDuplicateFilter,
    this.tapGestureForSelectionEnabled,
    this.swipeGesturesEnabled,
    this.additionalProperties = const {},
  });

  factory BarcodeSelectionSettings.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('BarcodeSelectionSettings: expected a Map');
    }
    final hasSymbologies = raw.containsKey('symbologies');
    final symbologiesRaw = raw['symbologies'];
    SymbologySettings? symbologiesValue;
    if (hasSymbologies && symbologiesRaw != null) {
      symbologiesValue = parseSymbologySettings(symbologiesRaw);
    } else if (hasSymbologies && symbologiesRaw == null) {
      throw FormatException('BarcodeSelectionSettings.symbologies: null is not allowed');
    }
    final hasSelectionType = raw.containsKey('selectionType');
    final selectionTypeRaw = raw['selectionType'];
    SelectionType? selectionTypeValue;
    if (hasSelectionType && selectionTypeRaw != null) {
      selectionTypeValue = SelectionType.fromJson(selectionTypeRaw);
    } else if (hasSelectionType && selectionTypeRaw == null) {
      throw FormatException('BarcodeSelectionSettings.selectionType: null is not allowed');
    }
    final hasSingleBarcodeAutoDetectionEnabled = raw.containsKey('singleBarcodeAutoDetectionEnabled');
    final singleBarcodeAutoDetectionEnabledRaw = raw['singleBarcodeAutoDetectionEnabled'];
    bool? singleBarcodeAutoDetectionEnabledValue;
    if (hasSingleBarcodeAutoDetectionEnabled && singleBarcodeAutoDetectionEnabledRaw != null) {
      if (singleBarcodeAutoDetectionEnabledRaw is! bool) {
        throw FormatException('BarcodeSelectionSettings.singleBarcodeAutoDetectionEnabled: expected a bool');
      }
      singleBarcodeAutoDetectionEnabledValue = singleBarcodeAutoDetectionEnabledRaw;
    } else if (hasSingleBarcodeAutoDetectionEnabled && singleBarcodeAutoDetectionEnabledRaw == null) {
      throw FormatException('BarcodeSelectionSettings.singleBarcodeAutoDetectionEnabled: null is not allowed');
    }
    final hasCodeDuplicateFilter = raw.containsKey('codeDuplicateFilter');
    final codeDuplicateFilterRaw = raw['codeDuplicateFilter'];
    int? codeDuplicateFilterValue;
    if (hasCodeDuplicateFilter && codeDuplicateFilterRaw != null) {
      if (codeDuplicateFilterRaw is! num) {
        throw FormatException('BarcodeSelectionSettings.codeDuplicateFilter: expected a number');
      }
      if (codeDuplicateFilterRaw != codeDuplicateFilterRaw.toInt()) {
        throw FormatException('BarcodeSelectionSettings.codeDuplicateFilter: expected an integer');
      }
      codeDuplicateFilterValue = codeDuplicateFilterRaw.toInt();
    } else if (hasCodeDuplicateFilter && codeDuplicateFilterRaw == null) {
      throw FormatException('BarcodeSelectionSettings.codeDuplicateFilter: null is not allowed');
    }
    final hasTapGestureForSelectionEnabled = raw.containsKey('tapGestureForSelectionEnabled');
    final tapGestureForSelectionEnabledRaw = raw['tapGestureForSelectionEnabled'];
    bool? tapGestureForSelectionEnabledValue;
    if (hasTapGestureForSelectionEnabled && tapGestureForSelectionEnabledRaw != null) {
      if (tapGestureForSelectionEnabledRaw is! bool) {
        throw FormatException('BarcodeSelectionSettings.tapGestureForSelectionEnabled: expected a bool');
      }
      tapGestureForSelectionEnabledValue = tapGestureForSelectionEnabledRaw;
    } else if (hasTapGestureForSelectionEnabled && tapGestureForSelectionEnabledRaw == null) {
      throw FormatException('BarcodeSelectionSettings.tapGestureForSelectionEnabled: null is not allowed');
    }
    final hasSwipeGesturesEnabled = raw.containsKey('swipeGesturesEnabled');
    final swipeGesturesEnabledRaw = raw['swipeGesturesEnabled'];
    bool? swipeGesturesEnabledValue;
    if (hasSwipeGesturesEnabled && swipeGesturesEnabledRaw != null) {
      if (swipeGesturesEnabledRaw is! bool) {
        throw FormatException('BarcodeSelectionSettings.swipeGesturesEnabled: expected a bool');
      }
      swipeGesturesEnabledValue = swipeGesturesEnabledRaw;
    } else if (hasSwipeGesturesEnabled && swipeGesturesEnabledRaw == null) {
      throw FormatException('BarcodeSelectionSettings.swipeGesturesEnabled: null is not allowed');
    }
    const emittedKeys = <String>{
      'symbologies',
      'selectionType',
      'singleBarcodeAutoDetectionEnabled',
      'codeDuplicateFilter',
      'tapGestureForSelectionEnabled',
      'swipeGesturesEnabled',
    };
    final additionalPropertiesCollected = <String, Object?>{};
    for (final key in raw.keys) {
      // A non-String key never matches `emittedKeys` (a Set<String>), so
      // every one of them reaches this throw: an open class rejects
      // non-String keys outright.
      if (!emittedKeys.contains(key)) {
        if (key is! String) {
          throw FormatException('BarcodeSelectionSettings: expected a String key');
        }
        additionalPropertiesCollected[key] = raw[key];
      }
    }
    return BarcodeSelectionSettings(
      symbologies: symbologiesValue,
      selectionType: selectionTypeValue,
      singleBarcodeAutoDetectionEnabled: singleBarcodeAutoDetectionEnabledValue,
      codeDuplicateFilter: codeDuplicateFilterValue,
      tapGestureForSelectionEnabled: tapGestureForSelectionEnabledValue,
      swipeGesturesEnabled: swipeGesturesEnabledValue,
      additionalProperties: Map.unmodifiable(additionalPropertiesCollected),
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (symbologies != null) {
      map['symbologies'] = symbologies;
    }
    if (selectionType != null) {
      map['selectionType'] = selectionType!.toJson();
    }
    if (singleBarcodeAutoDetectionEnabled != null) {
      map['singleBarcodeAutoDetectionEnabled'] = singleBarcodeAutoDetectionEnabled;
    }
    if (codeDuplicateFilter != null) {
      map['codeDuplicateFilter'] = codeDuplicateFilter;
    }
    if (tapGestureForSelectionEnabled != null) {
      map['tapGestureForSelectionEnabled'] = tapGestureForSelectionEnabled;
    }
    if (swipeGesturesEnabled != null) {
      map['swipeGesturesEnabled'] = swipeGesturesEnabled;
    }
    for (final entry in additionalProperties.entries) {
      if (!map.containsKey(entry.key)) {
        map[entry.key] = entry.value;
      }
    }
    return map;
  }
}

/// Typed builder for the `BarcodeSelectionSettings` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildBarcodeSelectionSettings({
  SymbologySettings? symbologies,
  Object? selectionType,
  bool? singleBarcodeAutoDetectionEnabled,
  int? codeDuplicateFilter,
  bool? tapGestureForSelectionEnabled,
  bool? swipeGesturesEnabled,
}) {
  final map = <String, Object?>{};
  if (symbologies != null) {
    map['symbologies'] = symbologies;
  }
  if (selectionType != null) {
    map['selectionType'] = selectionType;
  }
  if (singleBarcodeAutoDetectionEnabled != null) {
    map['singleBarcodeAutoDetectionEnabled'] = singleBarcodeAutoDetectionEnabled;
  }
  if (codeDuplicateFilter != null) {
    map['codeDuplicateFilter'] = codeDuplicateFilter;
  }
  if (tapGestureForSelectionEnabled != null) {
    map['tapGestureForSelectionEnabled'] = tapGestureForSelectionEnabled;
  }
  if (swipeGesturesEnabled != null) {
    map['swipeGesturesEnabled'] = swipeGesturesEnabled;
  }
  return map;
}

/// Discriminated union of all barcode selection type variants. The type field selects the concrete schema.
// NOTE: `abstract class`, not `abstract interface class`. The generated Dart
// must parse under the OLDEST toolchain in CI -- validate-bridge-generator's
// `dart format` runs on an older Dart SDK that does not understand Dart 3.0+
// class modifiers (`interface`, `sealed`, `base`, `final class`,
// `mixin class`). The docs signature collector moved to `analyzer ^7.7.1` in
// SDC-33150 and parses those fine, so it is no longer part of this
// constraint; `dart format` still is. `abstract class` is implementable in
// Dart 2 and 3 alike, so it preserves the same "implement, don't extend"
// contract without the modifier.
abstract class SelectionType {
  Map<String, Object?> toJson();

  factory SelectionType.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('SelectionType: expected a Map');
    }
    final discriminant = raw['type'];
    switch (discriminant) {
      case 'tapSelection':
        return TapSelection.fromJson(raw);
      case 'aimerSelection':
        return AimerSelection.fromJson(raw);
      default:
        throw FormatException(
          "SelectionType: unknown type '$discriminant'",
        );
    }
  }
}

/// A selection type where the user taps to select barcodes.
class TapSelection implements SelectionType {
  final String type;
  final String? tapBehavior;
  final String? freezeBehavior;
  final bool? shouldFreezeOnDoubleTap;

  const TapSelection({
    required this.type,
    this.tapBehavior,
    this.freezeBehavior,
    this.shouldFreezeOnDoubleTap,
  });

  factory TapSelection.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('TapSelection: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'tapBehavior',
      'freezeBehavior',
      'shouldFreezeOnDoubleTap',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("TapSelection: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("TapSelection.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['tapSelection'].contains(typeRaw)) {
        throw FormatException("TapSelection.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('TapSelection.type: null is not allowed');
    }
    final hasTapBehavior = raw.containsKey('tapBehavior');
    final tapBehaviorRaw = raw['tapBehavior'];
    String? tapBehaviorValue;
    if (hasTapBehavior && tapBehaviorRaw != null) {
      if (tapBehaviorRaw is! String || !const <String>['toggleSelection', 'repeatSelection'].contains(tapBehaviorRaw)) {
        throw FormatException("TapSelection.tapBehavior: unknown enum value '$tapBehaviorRaw'");
      }
      tapBehaviorValue = tapBehaviorRaw;
    } else if (hasTapBehavior && tapBehaviorRaw == null) {
      throw FormatException('TapSelection.tapBehavior: null is not allowed');
    }
    final hasFreezeBehavior = raw.containsKey('freezeBehavior');
    final freezeBehaviorRaw = raw['freezeBehavior'];
    String? freezeBehaviorValue;
    if (hasFreezeBehavior && freezeBehaviorRaw != null) {
      if (freezeBehaviorRaw is! String || !const <String>['manual', 'manualAndAutomatic'].contains(freezeBehaviorRaw)) {
        throw FormatException("TapSelection.freezeBehavior: unknown enum value '$freezeBehaviorRaw'");
      }
      freezeBehaviorValue = freezeBehaviorRaw;
    } else if (hasFreezeBehavior && freezeBehaviorRaw == null) {
      throw FormatException('TapSelection.freezeBehavior: null is not allowed');
    }
    final hasShouldFreezeOnDoubleTap = raw.containsKey('shouldFreezeOnDoubleTap');
    final shouldFreezeOnDoubleTapRaw = raw['shouldFreezeOnDoubleTap'];
    bool? shouldFreezeOnDoubleTapValue;
    if (hasShouldFreezeOnDoubleTap && shouldFreezeOnDoubleTapRaw != null) {
      if (shouldFreezeOnDoubleTapRaw is! bool) {
        throw FormatException('TapSelection.shouldFreezeOnDoubleTap: expected a bool');
      }
      shouldFreezeOnDoubleTapValue = shouldFreezeOnDoubleTapRaw;
    } else if (hasShouldFreezeOnDoubleTap && shouldFreezeOnDoubleTapRaw == null) {
      throw FormatException('TapSelection.shouldFreezeOnDoubleTap: null is not allowed');
    }
    return TapSelection(
      type: typeValue!,
      tapBehavior: tapBehaviorValue,
      freezeBehavior: freezeBehaviorValue,
      shouldFreezeOnDoubleTap: shouldFreezeOnDoubleTapValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (tapBehavior != null) {
      map['tapBehavior'] = tapBehavior;
    }
    if (freezeBehavior != null) {
      map['freezeBehavior'] = freezeBehavior;
    }
    if (shouldFreezeOnDoubleTap != null) {
      map['shouldFreezeOnDoubleTap'] = shouldFreezeOnDoubleTap;
    }
    return map;
  }
}

/// Typed builder for the `TapSelection` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildTapSelection({
  required String type,
  String? tapBehavior,
  String? freezeBehavior,
  bool? shouldFreezeOnDoubleTap,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (tapBehavior != null) {
    map['tapBehavior'] = tapBehavior;
  }
  if (freezeBehavior != null) {
    map['freezeBehavior'] = freezeBehavior;
  }
  if (shouldFreezeOnDoubleTap != null) {
    map['shouldFreezeOnDoubleTap'] = shouldFreezeOnDoubleTap;
  }
  return map;
}

/// A selection type where the user aims at barcodes using the aimer viewfinder.
class AimerSelection implements SelectionType {
  final String type;
  final SelectionStrategy? selectionStrategy;
  final String? aimerBehavior;

  const AimerSelection({
    required this.type,
    this.selectionStrategy,
    this.aimerBehavior,
  });

  factory AimerSelection.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('AimerSelection: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'selectionStrategy',
      'aimerBehavior',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("AimerSelection: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("AimerSelection.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['aimerSelection'].contains(typeRaw)) {
        throw FormatException("AimerSelection.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('AimerSelection.type: null is not allowed');
    }
    final hasSelectionStrategy = raw.containsKey('selectionStrategy');
    final selectionStrategyRaw = raw['selectionStrategy'];
    SelectionStrategy? selectionStrategyValue;
    if (hasSelectionStrategy && selectionStrategyRaw != null) {
      selectionStrategyValue = SelectionStrategy.fromJson(selectionStrategyRaw);
    } else if (hasSelectionStrategy && selectionStrategyRaw == null) {
      throw FormatException('AimerSelection.selectionStrategy: null is not allowed');
    }
    final hasAimerBehavior = raw.containsKey('aimerBehavior');
    final aimerBehaviorRaw = raw['aimerBehavior'];
    String? aimerBehaviorValue;
    if (hasAimerBehavior && aimerBehaviorRaw != null) {
      if (aimerBehaviorRaw is! String ||
          !const <String>['toggleSelection', 'repeatSelection'].contains(aimerBehaviorRaw)) {
        throw FormatException("AimerSelection.aimerBehavior: unknown enum value '$aimerBehaviorRaw'");
      }
      aimerBehaviorValue = aimerBehaviorRaw;
    } else if (hasAimerBehavior && aimerBehaviorRaw == null) {
      throw FormatException('AimerSelection.aimerBehavior: null is not allowed');
    }
    return AimerSelection(
      type: typeValue!,
      selectionStrategy: selectionStrategyValue,
      aimerBehavior: aimerBehaviorValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (selectionStrategy != null) {
      map['selectionStrategy'] = selectionStrategy!.toJson();
    }
    if (aimerBehavior != null) {
      map['aimerBehavior'] = aimerBehavior;
    }
    return map;
  }
}

/// Typed builder for the `AimerSelection` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildAimerSelection({
  required String type,
  Object? selectionStrategy,
  String? aimerBehavior,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (selectionStrategy != null) {
    map['selectionStrategy'] = selectionStrategy;
  }
  if (aimerBehavior != null) {
    map['aimerBehavior'] = aimerBehavior;
  }
  return map;
}

/// Discriminated union of all selection strategy types. The type field selects the concrete schema.
// NOTE: `abstract class`, not `abstract interface class`. The generated Dart
// must parse under the OLDEST toolchain in CI -- validate-bridge-generator's
// `dart format` runs on an older Dart SDK that does not understand Dart 3.0+
// class modifiers (`interface`, `sealed`, `base`, `final class`,
// `mixin class`). The docs signature collector moved to `analyzer ^7.7.1` in
// SDC-33150 and parses those fine, so it is no longer part of this
// constraint; `dart format` still is. `abstract class` is implementable in
// Dart 2 and 3 alike, so it preserves the same "implement, don't extend"
// contract without the modifier.
abstract class SelectionStrategy {
  Map<String, Object?> toJson();

  factory SelectionStrategy.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('SelectionStrategy: expected a Map');
    }
    final discriminant = raw['type'];
    switch (discriminant) {
      case 'manualSelectionStrategy':
        return ManualSelectionStrategy.fromJson(raw);
      case 'autoSelectionStrategy':
        return AutoSelectionStrategy.fromJson(raw);
      default:
        throw FormatException(
          "SelectionStrategy: unknown type '$discriminant'",
        );
    }
  }
}

/// A selection strategy that requires the user to manually select a barcode.
class ManualSelectionStrategy implements SelectionStrategy {
  final String type;

  const ManualSelectionStrategy({
    required this.type,
  });

  factory ManualSelectionStrategy.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('ManualSelectionStrategy: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("ManualSelectionStrategy: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("ManualSelectionStrategy.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['manualSelectionStrategy'].contains(typeRaw)) {
        throw FormatException("ManualSelectionStrategy.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('ManualSelectionStrategy.type: null is not allowed');
    }
    return ManualSelectionStrategy(
      type: typeValue!,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    return map;
  }
}

/// Typed builder for the `ManualSelectionStrategy` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildManualSelectionStrategy({
  required String type,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  return map;
}

/// A selection strategy that automatically selects barcodes.
class AutoSelectionStrategy implements SelectionStrategy {
  final String type;

  const AutoSelectionStrategy({
    required this.type,
  });

  factory AutoSelectionStrategy.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('AutoSelectionStrategy: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("AutoSelectionStrategy: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("AutoSelectionStrategy.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['autoSelectionStrategy'].contains(typeRaw)) {
        throw FormatException("AutoSelectionStrategy.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('AutoSelectionStrategy.type: null is not allowed');
    }
    return AutoSelectionStrategy(
      type: typeValue!,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    return map;
  }
}

/// Typed builder for the `AutoSelectionStrategy` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildAutoSelectionStrategy({
  required String type,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  return map;
}

/// A 2D point with UI value coordinates.
class UIPoint {
  final UIValue x;
  final UIValue y;

  const UIPoint({
    required this.x,
    required this.y,
  });

  factory UIPoint.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('UIPoint: expected a Map');
    }
    const allowedKeys = <String>{
      'x',
      'y',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("UIPoint: unknown property '$key'");
      }
    }
    final hasX = raw.containsKey('x');
    if (!hasX) {
      throw FormatException("UIPoint.x: missing required property");
    }
    final xRaw = raw['x'];
    UIValue? xValue;
    if (hasX && xRaw != null) {
      xValue = UIValue.fromJson(xRaw);
    } else if (hasX && xRaw == null) {
      throw FormatException('UIPoint.x: null is not allowed');
    }
    final hasY = raw.containsKey('y');
    if (!hasY) {
      throw FormatException("UIPoint.y: missing required property");
    }
    final yRaw = raw['y'];
    UIValue? yValue;
    if (hasY && yRaw != null) {
      yValue = UIValue.fromJson(yRaw);
    } else if (hasY && yRaw == null) {
      throw FormatException('UIPoint.y: null is not allowed');
    }
    return UIPoint(
      x: xValue!,
      y: yValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['x'] = x.toJson();
    map['y'] = y.toJson();
    return map;
  }
}

/// Typed builder for the `UIPoint` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildUIPoint({
  required Object x,
  required Object y,
}) {
  final map = <String, Object?>{};
  map['x'] = x;
  map['y'] = y;
  return map;
}

/// The SparkScan barcode capture mode.
class SparkScan implements Mode {
  final String type;
  final SparkScanSettings? settings;
  final bool? isEnabled;
  final bool? hasListeners;

  const SparkScan({
    required this.type,
    this.settings,
    this.isEnabled,
    this.hasListeners,
  });

  factory SparkScan.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('SparkScan: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'settings',
      'isEnabled',
      'hasListeners',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("SparkScan: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("SparkScan.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['sparkScan'].contains(typeRaw)) {
        throw FormatException("SparkScan.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('SparkScan.type: null is not allowed');
    }
    final hasSettings = raw.containsKey('settings');
    final settingsRaw = raw['settings'];
    SparkScanSettings? settingsValue;
    if (hasSettings && settingsRaw != null) {
      settingsValue = SparkScanSettings.fromJson(settingsRaw);
    } else if (hasSettings && settingsRaw == null) {
      throw FormatException('SparkScan.settings: null is not allowed');
    }
    final hasIsEnabled = raw.containsKey('isEnabled');
    final isEnabledRaw = raw['isEnabled'];
    bool? isEnabledValue;
    if (hasIsEnabled && isEnabledRaw != null) {
      if (isEnabledRaw is! bool) {
        throw FormatException('SparkScan.isEnabled: expected a bool');
      }
      isEnabledValue = isEnabledRaw;
    } else if (hasIsEnabled && isEnabledRaw == null) {
      throw FormatException('SparkScan.isEnabled: null is not allowed');
    }
    final hasHasListeners = raw.containsKey('hasListeners');
    final hasListenersRaw = raw['hasListeners'];
    bool? hasListenersValue;
    if (hasHasListeners && hasListenersRaw != null) {
      if (hasListenersRaw is! bool) {
        throw FormatException('SparkScan.hasListeners: expected a bool');
      }
      hasListenersValue = hasListenersRaw;
    } else if (hasHasListeners && hasListenersRaw == null) {
      throw FormatException('SparkScan.hasListeners: null is not allowed');
    }
    return SparkScan(
      type: typeValue!,
      settings: settingsValue,
      isEnabled: isEnabledValue,
      hasListeners: hasListenersValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (settings != null) {
      map['settings'] = settings!.toJson();
    }
    if (isEnabled != null) {
      map['isEnabled'] = isEnabled;
    }
    if (hasListeners != null) {
      map['hasListeners'] = hasListeners;
    }
    return map;
  }
}

/// Typed builder for the `SparkScan` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildSparkScan({
  required String type,
  Object? settings,
  bool? isEnabled,
  bool? hasListeners,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (settings != null) {
    map['settings'] = settings;
  }
  if (isEnabled != null) {
    map['isEnabled'] = isEnabled;
  }
  if (hasListeners != null) {
    map['hasListeners'] = hasListeners;
  }
  return map;
}

/// Settings for the SparkScan barcode capture mode.
class SparkScanSettings {
  final int? codeDuplicateFilter;
  final Object? properties;
  final Object? symbologies;
  @Deprecated('since 6.19')
  final LocationSelection? locationSelection;
  final BatterySavingMode? batterySaving;
  final ScanIntention? scanIntention;
  final SelectionMode? selectionMode;
  final List<CompositeFlag>? enabledCompositeTypes;
  final Object? scanItemDefinitions;

  /// Keys present in the payload that have no emitted field -- undeclared
  /// keys, plus schema-declared properties that are `hidden` or non-mobile and
  /// therefore get no field of their own. Re-emitted by [toJson] so the round
  /// trip is lossless. See the passthrough contract in this file's header.
  final Map<String, Object?> additionalProperties;

  const SparkScanSettings({
    this.codeDuplicateFilter,
    this.properties,
    this.symbologies,
    this.locationSelection,
    this.batterySaving,
    this.scanIntention,
    this.selectionMode,
    this.enabledCompositeTypes,
    this.scanItemDefinitions,
    this.additionalProperties = const {},
  });

  factory SparkScanSettings.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('SparkScanSettings: expected a Map');
    }
    final hasCodeDuplicateFilter = raw.containsKey('codeDuplicateFilter');
    final codeDuplicateFilterRaw = raw['codeDuplicateFilter'];
    int? codeDuplicateFilterValue;
    if (hasCodeDuplicateFilter && codeDuplicateFilterRaw != null) {
      if (codeDuplicateFilterRaw is! num) {
        throw FormatException('SparkScanSettings.codeDuplicateFilter: expected a number');
      }
      if (codeDuplicateFilterRaw != codeDuplicateFilterRaw.toInt()) {
        throw FormatException('SparkScanSettings.codeDuplicateFilter: expected an integer');
      }
      codeDuplicateFilterValue = codeDuplicateFilterRaw.toInt();
    } else if (hasCodeDuplicateFilter && codeDuplicateFilterRaw == null) {
      throw FormatException('SparkScanSettings.codeDuplicateFilter: null is not allowed');
    }
    final hasProperties = raw.containsKey('properties');
    final propertiesRaw = raw['properties'];
    Object? propertiesValue;
    if (hasProperties && propertiesRaw != null) {
      propertiesValue = propertiesRaw;
    } else if (hasProperties && propertiesRaw == null) {
      throw FormatException('SparkScanSettings.properties: null is not allowed');
    }
    final hasSymbologies = raw.containsKey('symbologies');
    final symbologiesRaw = raw['symbologies'];
    Object? symbologiesValue;
    if (hasSymbologies && symbologiesRaw != null) {
      symbologiesValue = symbologiesRaw;
    } else if (hasSymbologies && symbologiesRaw == null) {
      throw FormatException('SparkScanSettings.symbologies: null is not allowed');
    }
    final hasLocationSelection = raw.containsKey('locationSelection');
    final locationSelectionRaw = raw['locationSelection'];
    LocationSelection? locationSelectionValue;
    if (hasLocationSelection && locationSelectionRaw != null) {
      locationSelectionValue = LocationSelection.fromJson(locationSelectionRaw);
    } else if (hasLocationSelection && locationSelectionRaw == null) {
      throw FormatException('SparkScanSettings.locationSelection: null is not allowed');
    }
    final hasBatterySaving = raw.containsKey('batterySaving');
    final batterySavingRaw = raw['batterySaving'];
    BatterySavingMode? batterySavingValue;
    if (hasBatterySaving && batterySavingRaw != null) {
      batterySavingValue = (batterySavingRaw is! String
          ? (throw FormatException('SparkScanSettings.batterySaving: expected a String for BatterySavingMode'))
          : BatterySavingMode.fromJSON(batterySavingRaw));
    } else if (hasBatterySaving && batterySavingRaw == null) {
      throw FormatException('SparkScanSettings.batterySaving: null is not allowed');
    }
    final hasScanIntention = raw.containsKey('scanIntention');
    final scanIntentionRaw = raw['scanIntention'];
    ScanIntention? scanIntentionValue;
    if (hasScanIntention && scanIntentionRaw != null) {
      scanIntentionValue = (scanIntentionRaw is! String
          ? (throw FormatException('SparkScanSettings.scanIntention: expected a String for ScanIntention'))
          : ScanIntention.fromJSON(scanIntentionRaw));
    } else if (hasScanIntention && scanIntentionRaw == null) {
      throw FormatException('SparkScanSettings.scanIntention: null is not allowed');
    }
    final hasSelectionMode = raw.containsKey('selectionMode');
    final selectionModeRaw = raw['selectionMode'];
    SelectionMode? selectionModeValue;
    if (hasSelectionMode && selectionModeRaw != null) {
      selectionModeValue = (selectionModeRaw is! String
          ? (throw FormatException('SparkScanSettings.selectionMode: expected a String for SelectionMode'))
          : SelectionMode.fromJSON(selectionModeRaw));
    } else if (hasSelectionMode && selectionModeRaw == null) {
      throw FormatException('SparkScanSettings.selectionMode: null is not allowed');
    }
    final hasEnabledCompositeTypes = raw.containsKey('enabledCompositeTypes');
    final enabledCompositeTypesRaw = raw['enabledCompositeTypes'];
    List<CompositeFlag>? enabledCompositeTypesValue;
    if (hasEnabledCompositeTypes && enabledCompositeTypesRaw != null) {
      if (enabledCompositeTypesRaw is! List) {
        throw FormatException('SparkScanSettings.enabledCompositeTypes: expected a List');
      }
      enabledCompositeTypesValue = enabledCompositeTypesRaw
          .map((item) => (item is! String
              ? (throw FormatException('SparkScanSettings.enabledCompositeTypes: expected a String for CompositeFlag'))
              : CompositeFlag.fromJSON(item)))
          .toList();
    } else if (hasEnabledCompositeTypes && enabledCompositeTypesRaw == null) {
      throw FormatException('SparkScanSettings.enabledCompositeTypes: null is not allowed');
    }
    final hasScanItemDefinitions = raw.containsKey('scanItemDefinitions');
    final scanItemDefinitionsRaw = raw['scanItemDefinitions'];
    Object? scanItemDefinitionsValue;
    if (hasScanItemDefinitions && scanItemDefinitionsRaw != null) {
      scanItemDefinitionsValue = scanItemDefinitionsRaw;
    }
    const emittedKeys = <String>{
      'codeDuplicateFilter',
      'properties',
      'symbologies',
      'locationSelection',
      'batterySaving',
      'scanIntention',
      'selectionMode',
      'enabledCompositeTypes',
      'scanItemDefinitions',
    };
    final additionalPropertiesCollected = <String, Object?>{};
    for (final key in raw.keys) {
      // A non-String key never matches `emittedKeys` (a Set<String>), so
      // every one of them reaches this throw: an open class rejects
      // non-String keys outright.
      if (!emittedKeys.contains(key)) {
        if (key is! String) {
          throw FormatException('SparkScanSettings: expected a String key');
        }
        additionalPropertiesCollected[key] = raw[key];
      }
    }
    return SparkScanSettings(
      codeDuplicateFilter: codeDuplicateFilterValue,
      properties: propertiesValue,
      symbologies: symbologiesValue,
      locationSelection: locationSelectionValue,
      batterySaving: batterySavingValue,
      scanIntention: scanIntentionValue,
      selectionMode: selectionModeValue,
      enabledCompositeTypes: enabledCompositeTypesValue,
      scanItemDefinitions: scanItemDefinitionsValue,
      additionalProperties: Map.unmodifiable(additionalPropertiesCollected),
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (codeDuplicateFilter != null) {
      map['codeDuplicateFilter'] = codeDuplicateFilter;
    }
    if (properties != null) {
      map['properties'] = properties;
    }
    if (symbologies != null) {
      map['symbologies'] = symbologies;
    }
    if (locationSelection != null) {
      map['locationSelection'] = locationSelection!.toJson();
    }
    if (batterySaving != null) {
      map['batterySaving'] = batterySaving!.toJson();
    }
    if (scanIntention != null) {
      map['scanIntention'] = scanIntention!.toJson();
    }
    if (selectionMode != null) {
      map['selectionMode'] = selectionMode!.toJson();
    }
    if (enabledCompositeTypes != null) {
      map['enabledCompositeTypes'] = enabledCompositeTypes!.map((item) => item.toJson()).toList();
    }
    if (scanItemDefinitions != null) {
      map['scanItemDefinitions'] = scanItemDefinitions;
    }
    for (final entry in additionalProperties.entries) {
      if (!map.containsKey(entry.key)) {
        map[entry.key] = entry.value;
      }
    }
    return map;
  }
}

/// Typed builder for the `SparkScanSettings` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildSparkScanSettings({
  int? codeDuplicateFilter,
  Object? properties,
  Object? symbologies,
  Object? locationSelection,
  Object? batterySaving,
  Object? scanIntention,
  Object? selectionMode,
  List<Object?>? enabledCompositeTypes,
  Object? scanItemDefinitions = _unset,
}) {
  final map = <String, Object?>{};
  if (codeDuplicateFilter != null) {
    map['codeDuplicateFilter'] = codeDuplicateFilter;
  }
  if (properties != null) {
    map['properties'] = properties;
  }
  if (symbologies != null) {
    map['symbologies'] = symbologies;
  }
  if (locationSelection != null) {
    map['locationSelection'] = locationSelection;
  }
  if (batterySaving != null) {
    map['batterySaving'] = batterySaving;
  }
  if (scanIntention != null) {
    map['scanIntention'] = scanIntention;
  }
  if (selectionMode != null) {
    map['selectionMode'] = selectionMode;
  }
  if (enabledCompositeTypes != null) {
    map['enabledCompositeTypes'] = enabledCompositeTypes;
  }
  if (!identical(scanItemDefinitions, _unset)) {
    map['scanItemDefinitions'] = scanItemDefinitions;
  }
  return map;
}

/// Indicates whether a barcode is part of a composite code.
enum CompositeFlag {
  none('none'),
  unknown('unknown'),
  linked('linked'),
  gs1TypeA('gs1TypeA'),
  gs1TypeB('gs1TypeB'),
  gs1TypeC('gs1TypeC');

  const CompositeFlag(this.jsonValue);

  final String jsonValue;

  static CompositeFlag fromJSON(String jsonValue) {
    for (final value in CompositeFlag.values) {
      if (value.jsonValue == jsonValue) {
        return value;
      }
    }
    throw FormatException("CompositeFlag: unknown enum value '$jsonValue'");
  }

  String toJson() => jsonValue;
}

/// The label capture mode.
class LabelCapture implements Mode {
  final String type;
  final LabelCaptureSettings? settings;
  final bool? enabled;
  final LabelCaptureFeedback? feedback;
  final int? modeId;
  final int? parentId;
  final bool? hasListeners;

  const LabelCapture({
    required this.type,
    this.settings,
    this.enabled,
    this.feedback,
    this.modeId,
    this.parentId,
    this.hasListeners,
  });

  factory LabelCapture.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LabelCapture: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'settings',
      'enabled',
      'feedback',
      'modeId',
      'parentId',
      'hasListeners',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("LabelCapture: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("LabelCapture.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['labelCapture'].contains(typeRaw)) {
        throw FormatException("LabelCapture.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('LabelCapture.type: null is not allowed');
    }
    final hasSettings = raw.containsKey('settings');
    final settingsRaw = raw['settings'];
    LabelCaptureSettings? settingsValue;
    if (hasSettings && settingsRaw != null) {
      settingsValue = LabelCaptureSettings.fromJson(settingsRaw);
    } else if (hasSettings && settingsRaw == null) {
      throw FormatException('LabelCapture.settings: null is not allowed');
    }
    final hasEnabled = raw.containsKey('enabled');
    final enabledRaw = raw['enabled'];
    bool? enabledValue;
    if (hasEnabled && enabledRaw != null) {
      if (enabledRaw is! bool) {
        throw FormatException('LabelCapture.enabled: expected a bool');
      }
      enabledValue = enabledRaw;
    } else if (hasEnabled && enabledRaw == null) {
      throw FormatException('LabelCapture.enabled: null is not allowed');
    }
    final hasFeedback = raw.containsKey('feedback');
    final feedbackRaw = raw['feedback'];
    LabelCaptureFeedback? feedbackValue;
    if (hasFeedback && feedbackRaw != null) {
      feedbackValue = LabelCaptureFeedback.fromJson(feedbackRaw);
    } else if (hasFeedback && feedbackRaw == null) {
      throw FormatException('LabelCapture.feedback: null is not allowed');
    }
    final hasModeId = raw.containsKey('modeId');
    final modeIdRaw = raw['modeId'];
    int? modeIdValue;
    if (hasModeId && modeIdRaw != null) {
      if (modeIdRaw is! num) {
        throw FormatException('LabelCapture.modeId: expected a number');
      }
      if (modeIdRaw != modeIdRaw.toInt()) {
        throw FormatException('LabelCapture.modeId: expected an integer');
      }
      modeIdValue = modeIdRaw.toInt();
    } else if (hasModeId && modeIdRaw == null) {
      throw FormatException('LabelCapture.modeId: null is not allowed');
    }
    final hasParentId = raw.containsKey('parentId');
    final parentIdRaw = raw['parentId'];
    int? parentIdValue;
    if (hasParentId && parentIdRaw != null) {
      if (parentIdRaw is! num) {
        throw FormatException('LabelCapture.parentId: expected a number');
      }
      if (parentIdRaw != parentIdRaw.toInt()) {
        throw FormatException('LabelCapture.parentId: expected an integer');
      }
      parentIdValue = parentIdRaw.toInt();
    }
    final hasHasListeners = raw.containsKey('hasListeners');
    final hasListenersRaw = raw['hasListeners'];
    bool? hasListenersValue;
    if (hasHasListeners && hasListenersRaw != null) {
      if (hasListenersRaw is! bool) {
        throw FormatException('LabelCapture.hasListeners: expected a bool');
      }
      hasListenersValue = hasListenersRaw;
    } else if (hasHasListeners && hasListenersRaw == null) {
      throw FormatException('LabelCapture.hasListeners: null is not allowed');
    }
    return LabelCapture(
      type: typeValue!,
      settings: settingsValue,
      enabled: enabledValue,
      feedback: feedbackValue,
      modeId: modeIdValue,
      parentId: parentIdValue,
      hasListeners: hasListenersValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (settings != null) {
      map['settings'] = settings!.toJson();
    }
    if (enabled != null) {
      map['enabled'] = enabled;
    }
    if (feedback != null) {
      map['feedback'] = feedback!.toJson();
    }
    if (modeId != null) {
      map['modeId'] = modeId;
    }
    if (parentId != null) {
      map['parentId'] = parentId;
    }
    if (hasListeners != null) {
      map['hasListeners'] = hasListeners;
    }
    return map;
  }
}

/// Typed builder for the `LabelCapture` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildLabelCapture({
  required String type,
  Object? settings,
  bool? enabled,
  Object? feedback,
  int? modeId,
  Object? parentId = _unset,
  bool? hasListeners,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (settings != null) {
    map['settings'] = settings;
  }
  if (enabled != null) {
    map['enabled'] = enabled;
  }
  if (feedback != null) {
    map['feedback'] = feedback;
  }
  if (modeId != null) {
    map['modeId'] = modeId;
  }
  if (!identical(parentId, _unset)) {
    map['parentId'] = parentId;
  }
  if (hasListeners != null) {
    map['hasListeners'] = hasListeners;
  }
  return map;
}

/// Settings that configure label capture behavior.
class LabelCaptureSettings {
  final LocationSelection? locationSelection;
  final List<LabelDefinition>? labelDefinitions;
  final List<String>? languages;
  final Object? properties;

  const LabelCaptureSettings({
    this.locationSelection,
    this.labelDefinitions,
    this.languages,
    this.properties,
  });

  factory LabelCaptureSettings.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LabelCaptureSettings: expected a Map');
    }
    const allowedKeys = <String>{
      'licenseKey',
      'licensee',
      'locationSelection',
      'labelDefinitions',
      'languages',
      'properties',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("LabelCaptureSettings: unknown property '$key'");
      }
    }
    final hasLocationSelection = raw.containsKey('locationSelection');
    final locationSelectionRaw = raw['locationSelection'];
    LocationSelection? locationSelectionValue;
    if (hasLocationSelection && locationSelectionRaw != null) {
      locationSelectionValue = LocationSelection.fromJson(locationSelectionRaw);
    }
    final hasLabelDefinitions = raw.containsKey('labelDefinitions');
    final labelDefinitionsRaw = raw['labelDefinitions'];
    List<LabelDefinition>? labelDefinitionsValue;
    if (hasLabelDefinitions && labelDefinitionsRaw != null) {
      if (labelDefinitionsRaw is! List) {
        throw FormatException('LabelCaptureSettings.labelDefinitions: expected a List');
      }
      labelDefinitionsValue = labelDefinitionsRaw.map((item) => LabelDefinition.fromJson(item)).toList();
    } else if (hasLabelDefinitions && labelDefinitionsRaw == null) {
      throw FormatException('LabelCaptureSettings.labelDefinitions: null is not allowed');
    }
    final hasLanguages = raw.containsKey('languages');
    final languagesRaw = raw['languages'];
    List<String>? languagesValue;
    if (hasLanguages && languagesRaw != null) {
      if (languagesRaw is! List) {
        throw FormatException('LabelCaptureSettings.languages: expected a List');
      }
      for (final item in languagesRaw) {
        if (item is! String || !const <String>['en', 'es'].contains(item)) {
          throw FormatException("LabelCaptureSettings.languages: unknown enum value '$item'");
        }
      }
      languagesValue = languagesRaw.cast<String>();
    } else if (hasLanguages && languagesRaw == null) {
      throw FormatException('LabelCaptureSettings.languages: null is not allowed');
    }
    final hasProperties = raw.containsKey('properties');
    final propertiesRaw = raw['properties'];
    Object? propertiesValue;
    if (hasProperties && propertiesRaw != null) {
      propertiesValue = propertiesRaw;
    } else if (hasProperties && propertiesRaw == null) {
      throw FormatException('LabelCaptureSettings.properties: null is not allowed');
    }
    return LabelCaptureSettings(
      locationSelection: locationSelectionValue,
      labelDefinitions: labelDefinitionsValue,
      languages: languagesValue,
      properties: propertiesValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (locationSelection != null) {
      map['locationSelection'] = locationSelection!.toJson();
    }
    if (labelDefinitions != null) {
      map['labelDefinitions'] = labelDefinitions!.map((item) => item.toJson()).toList();
    }
    if (languages != null) {
      map['languages'] = languages;
    }
    if (properties != null) {
      map['properties'] = properties;
    }
    return map;
  }
}

/// Typed builder for the `LabelCaptureSettings` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildLabelCaptureSettings({
  Object? locationSelection = _unset,
  List<Object?>? labelDefinitions,
  List<String>? languages,
  Object? properties,
}) {
  final map = <String, Object?>{};
  if (!identical(locationSelection, _unset)) {
    map['locationSelection'] = locationSelection;
  }
  if (labelDefinitions != null) {
    map['labelDefinitions'] = labelDefinitions;
  }
  if (languages != null) {
    map['languages'] = languages;
  }
  if (properties != null) {
    map['properties'] = properties;
  }
  return map;
}

/// Defines the structure of a label to be captured, including its name and constituent field definitions.
class LabelDefinition {
  final String name;
  final String? type;
  final List<LabelFieldDefinition>? fields;
  final String? adaptiveRecognitionMode;

  const LabelDefinition({
    required this.name,
    this.type,
    this.fields,
    this.adaptiveRecognitionMode,
  });

  factory LabelDefinition.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LabelDefinition: expected a Map');
    }
    const allowedKeys = <String>{
      'name',
      'type',
      'fields',
      'adaptiveRecognitionMode',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("LabelDefinition: unknown property '$key'");
      }
    }
    final hasName = raw.containsKey('name');
    if (!hasName) {
      throw FormatException("LabelDefinition.name: missing required property");
    }
    final nameRaw = raw['name'];
    String? nameValue;
    if (hasName && nameRaw != null) {
      if (nameRaw is! String) {
        throw FormatException('LabelDefinition.name: expected a String');
      }
      nameValue = nameRaw;
    } else if (hasName && nameRaw == null) {
      throw FormatException('LabelDefinition.name: null is not allowed');
    }
    final hasType = raw.containsKey('type');
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['vin', 'priceCapture', 'sevenSegment'].contains(typeRaw)) {
        throw FormatException("LabelDefinition.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('LabelDefinition.type: null is not allowed');
    }
    final hasFields = raw.containsKey('fields');
    final fieldsRaw = raw['fields'];
    List<LabelFieldDefinition>? fieldsValue;
    if (hasFields && fieldsRaw != null) {
      if (fieldsRaw is! List) {
        throw FormatException('LabelDefinition.fields: expected a List');
      }
      fieldsValue = fieldsRaw.map((item) => LabelFieldDefinition.fromJson(item)).toList();
    } else if (hasFields && fieldsRaw == null) {
      throw FormatException('LabelDefinition.fields: null is not allowed');
    }
    final hasAdaptiveRecognitionMode = raw.containsKey('adaptiveRecognitionMode');
    final adaptiveRecognitionModeRaw = raw['adaptiveRecognitionMode'];
    String? adaptiveRecognitionModeValue;
    if (hasAdaptiveRecognitionMode && adaptiveRecognitionModeRaw != null) {
      if (adaptiveRecognitionModeRaw is! String ||
          !const <String>['off', 'auto', 'on'].contains(adaptiveRecognitionModeRaw)) {
        throw FormatException(
            "LabelDefinition.adaptiveRecognitionMode: unknown enum value '$adaptiveRecognitionModeRaw'");
      }
      adaptiveRecognitionModeValue = adaptiveRecognitionModeRaw;
    } else if (hasAdaptiveRecognitionMode && adaptiveRecognitionModeRaw == null) {
      throw FormatException('LabelDefinition.adaptiveRecognitionMode: null is not allowed');
    }
    return LabelDefinition(
      name: nameValue!,
      type: typeValue,
      fields: fieldsValue,
      adaptiveRecognitionMode: adaptiveRecognitionModeValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['name'] = name;
    if (type != null) {
      map['type'] = type;
    }
    if (fields != null) {
      map['fields'] = fields!.map((item) => item.toJson()).toList();
    }
    if (adaptiveRecognitionMode != null) {
      map['adaptiveRecognitionMode'] = adaptiveRecognitionMode;
    }
    return map;
  }
}

/// Typed builder for the `LabelDefinition` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildLabelDefinition({
  required String name,
  String? type,
  List<Object?>? fields,
  String? adaptiveRecognitionMode,
}) {
  final map = <String, Object?>{};
  map['name'] = name;
  if (type != null) {
    map['type'] = type;
  }
  if (fields != null) {
    map['fields'] = fields;
  }
  if (adaptiveRecognitionMode != null) {
    map['adaptiveRecognitionMode'] = adaptiveRecognitionMode;
  }
  return map;
}

/// Discriminated union of all label field definition types. The fieldType field selects the concrete schema.
// NOTE: `abstract class`, not `abstract interface class`. The generated Dart
// must parse under the OLDEST toolchain in CI -- validate-bridge-generator's
// `dart format` runs on an older Dart SDK that does not understand Dart 3.0+
// class modifiers (`interface`, `sealed`, `base`, `final class`,
// `mixin class`). The docs signature collector moved to `analyzer ^7.7.1` in
// SDC-33150 and parses those fine, so it is no longer part of this
// constraint; `dart format` still is. `abstract class` is implementable in
// Dart 2 and 3 alike, so it preserves the same "implement, don't extend"
// contract without the modifier.
abstract class LabelFieldDefinition {
  Map<String, Object?> toJson();

  factory LabelFieldDefinition.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LabelFieldDefinition: expected a Map');
    }
    final discriminant = raw['fieldType'];
    switch (discriminant) {
      case 'imeiOneBarcode':
        return ImeiOneBarcodeFieldDefinition.fromJson(raw);
      case 'imeiTwoBarcode':
        return ImeiTwoBarcodeFieldDefinition.fromJson(raw);
      case 'partNumberBarcode':
        return PartNumberBarcodeFieldDefinition.fromJson(raw);
      case 'serialNumberBarcode':
        return SerialNumberBarcodeFieldDefinition.fromJson(raw);
      case 'expiryDateText':
        return ExpiryDateTextFieldDefinition.fromJson(raw);
      case 'packingDateText':
        return PackingDateTextFieldDefinition.fromJson(raw);
      case 'totalPriceText':
        return TotalPriceTextFieldDefinition.fromJson(raw);
      case 'unitPriceText':
        return UnitPriceTextFieldDefinition.fromJson(raw);
      case 'weightText':
        return WeightTextFieldDefinition.fromJson(raw);
      case 'customBarcode':
        return CustomBarcodeLabelFieldDefinition.fromJson(raw);
      case 'customText':
        return CustomTextLabelFieldDefinition.fromJson(raw);
      case 'dateText':
        return DateTextFieldDefinition.fromJson(raw);
      default:
        throw FormatException(
          "LabelFieldDefinition: unknown fieldType '$discriminant'",
        );
    }
  }
}

/// Label field definition for the first IMEI barcode field.
class ImeiOneBarcodeFieldDefinition implements LabelFieldDefinition {
  final String name;
  final int? number_of_mandatory_instances;
  final String fieldType;
  final bool? optional;
  final List<String>? dataTypePatterns;
  final List<String>? patterns;
  final SymbologySettings? symbologies;

  const ImeiOneBarcodeFieldDefinition({
    required this.name,
    this.number_of_mandatory_instances,
    required this.fieldType,
    this.optional,
    this.dataTypePatterns,
    this.patterns,
    this.symbologies,
  });

  factory ImeiOneBarcodeFieldDefinition.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('ImeiOneBarcodeFieldDefinition: expected a Map');
    }
    const allowedKeys = <String>{
      'name',
      'number_of_mandatory_instances',
      'fieldType',
      'optional',
      'dataTypePatterns',
      'patterns',
      'symbologies',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("ImeiOneBarcodeFieldDefinition: unknown property '$key'");
      }
    }
    final hasName = raw.containsKey('name');
    if (!hasName) {
      throw FormatException("ImeiOneBarcodeFieldDefinition.name: missing required property");
    }
    final nameRaw = raw['name'];
    String? nameValue;
    if (hasName && nameRaw != null) {
      if (nameRaw is! String) {
        throw FormatException('ImeiOneBarcodeFieldDefinition.name: expected a String');
      }
      nameValue = nameRaw;
    } else if (hasName && nameRaw == null) {
      throw FormatException('ImeiOneBarcodeFieldDefinition.name: null is not allowed');
    }
    final hasNumber_of_mandatory_instances = raw.containsKey('number_of_mandatory_instances');
    final number_of_mandatory_instancesRaw = raw['number_of_mandatory_instances'];
    int? number_of_mandatory_instancesValue;
    if (hasNumber_of_mandatory_instances && number_of_mandatory_instancesRaw != null) {
      if (number_of_mandatory_instancesRaw is! num) {
        throw FormatException('ImeiOneBarcodeFieldDefinition.number_of_mandatory_instances: expected a number');
      }
      if (number_of_mandatory_instancesRaw != number_of_mandatory_instancesRaw.toInt()) {
        throw FormatException('ImeiOneBarcodeFieldDefinition.number_of_mandatory_instances: expected an integer');
      }
      number_of_mandatory_instancesValue = number_of_mandatory_instancesRaw.toInt();
    }
    final hasFieldType = raw.containsKey('fieldType');
    if (!hasFieldType) {
      throw FormatException("ImeiOneBarcodeFieldDefinition.fieldType: missing required property");
    }
    final fieldTypeRaw = raw['fieldType'];
    String? fieldTypeValue;
    if (hasFieldType && fieldTypeRaw != null) {
      if (fieldTypeRaw is! String || !const <String>['imeiOneBarcode'].contains(fieldTypeRaw)) {
        throw FormatException("ImeiOneBarcodeFieldDefinition.fieldType: unknown enum value '$fieldTypeRaw'");
      }
      fieldTypeValue = fieldTypeRaw;
    } else if (hasFieldType && fieldTypeRaw == null) {
      throw FormatException('ImeiOneBarcodeFieldDefinition.fieldType: null is not allowed');
    }
    final hasOptional = raw.containsKey('optional');
    final optionalRaw = raw['optional'];
    bool? optionalValue;
    if (hasOptional && optionalRaw != null) {
      if (optionalRaw is! bool) {
        throw FormatException('ImeiOneBarcodeFieldDefinition.optional: expected a bool');
      }
      optionalValue = optionalRaw;
    } else if (hasOptional && optionalRaw == null) {
      throw FormatException('ImeiOneBarcodeFieldDefinition.optional: null is not allowed');
    }
    final hasDataTypePatterns = raw.containsKey('dataTypePatterns');
    final dataTypePatternsRaw = raw['dataTypePatterns'];
    List<String>? dataTypePatternsValue;
    if (hasDataTypePatterns && dataTypePatternsRaw != null) {
      if (dataTypePatternsRaw is! List) {
        throw FormatException('ImeiOneBarcodeFieldDefinition.dataTypePatterns: expected a List');
      }
      for (final item in dataTypePatternsRaw) {
        if (item is! String) {
          throw FormatException('ImeiOneBarcodeFieldDefinition.dataTypePatterns: expected a List of String');
        }
      }
      dataTypePatternsValue = dataTypePatternsRaw.cast<String>();
    }
    final hasPatterns = raw.containsKey('patterns');
    final patternsRaw = raw['patterns'];
    List<String>? patternsValue;
    if (hasPatterns && patternsRaw != null) {
      if (patternsRaw is! List) {
        throw FormatException('ImeiOneBarcodeFieldDefinition.patterns: expected a List');
      }
      for (final item in patternsRaw) {
        if (item is! String) {
          throw FormatException('ImeiOneBarcodeFieldDefinition.patterns: expected a List of String');
        }
      }
      patternsValue = patternsRaw.cast<String>();
    }
    final hasSymbologies = raw.containsKey('symbologies');
    final symbologiesRaw = raw['symbologies'];
    SymbologySettings? symbologiesValue;
    if (hasSymbologies && symbologiesRaw != null) {
      symbologiesValue = parseSymbologySettings(symbologiesRaw);
    } else if (hasSymbologies && symbologiesRaw == null) {
      throw FormatException('ImeiOneBarcodeFieldDefinition.symbologies: null is not allowed');
    }
    return ImeiOneBarcodeFieldDefinition(
      name: nameValue!,
      number_of_mandatory_instances: number_of_mandatory_instancesValue,
      fieldType: fieldTypeValue!,
      optional: optionalValue,
      dataTypePatterns: dataTypePatternsValue,
      patterns: patternsValue,
      symbologies: symbologiesValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['name'] = name;
    if (number_of_mandatory_instances != null) {
      map['number_of_mandatory_instances'] = number_of_mandatory_instances;
    }
    map['fieldType'] = fieldType;
    if (optional != null) {
      map['optional'] = optional;
    }
    if (dataTypePatterns != null) {
      map['dataTypePatterns'] = dataTypePatterns;
    }
    if (patterns != null) {
      map['patterns'] = patterns;
    }
    if (symbologies != null) {
      map['symbologies'] = symbologies;
    }
    return map;
  }
}

/// Typed builder for the `ImeiOneBarcodeFieldDefinition` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildImeiOneBarcodeFieldDefinition({
  required String name,
  Object? number_of_mandatory_instances = _unset,
  required String fieldType,
  bool? optional,
  Object? dataTypePatterns = _unset,
  Object? patterns = _unset,
  SymbologySettings? symbologies,
}) {
  final map = <String, Object?>{};
  map['name'] = name;
  if (!identical(number_of_mandatory_instances, _unset)) {
    map['number_of_mandatory_instances'] = number_of_mandatory_instances;
  }
  map['fieldType'] = fieldType;
  if (optional != null) {
    map['optional'] = optional;
  }
  if (!identical(dataTypePatterns, _unset)) {
    map['dataTypePatterns'] = dataTypePatterns;
  }
  if (!identical(patterns, _unset)) {
    map['patterns'] = patterns;
  }
  if (symbologies != null) {
    map['symbologies'] = symbologies;
  }
  return map;
}

/// Label field definition for the second IMEI barcode field.
class ImeiTwoBarcodeFieldDefinition implements LabelFieldDefinition {
  final String name;
  final int? number_of_mandatory_instances;
  final String fieldType;
  final bool? optional;
  final List<String>? dataTypePatterns;
  final List<String>? patterns;
  final SymbologySettings? symbologies;

  const ImeiTwoBarcodeFieldDefinition({
    required this.name,
    this.number_of_mandatory_instances,
    required this.fieldType,
    this.optional,
    this.dataTypePatterns,
    this.patterns,
    this.symbologies,
  });

  factory ImeiTwoBarcodeFieldDefinition.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('ImeiTwoBarcodeFieldDefinition: expected a Map');
    }
    const allowedKeys = <String>{
      'name',
      'number_of_mandatory_instances',
      'fieldType',
      'optional',
      'dataTypePatterns',
      'patterns',
      'symbologies',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("ImeiTwoBarcodeFieldDefinition: unknown property '$key'");
      }
    }
    final hasName = raw.containsKey('name');
    if (!hasName) {
      throw FormatException("ImeiTwoBarcodeFieldDefinition.name: missing required property");
    }
    final nameRaw = raw['name'];
    String? nameValue;
    if (hasName && nameRaw != null) {
      if (nameRaw is! String) {
        throw FormatException('ImeiTwoBarcodeFieldDefinition.name: expected a String');
      }
      nameValue = nameRaw;
    } else if (hasName && nameRaw == null) {
      throw FormatException('ImeiTwoBarcodeFieldDefinition.name: null is not allowed');
    }
    final hasNumber_of_mandatory_instances = raw.containsKey('number_of_mandatory_instances');
    final number_of_mandatory_instancesRaw = raw['number_of_mandatory_instances'];
    int? number_of_mandatory_instancesValue;
    if (hasNumber_of_mandatory_instances && number_of_mandatory_instancesRaw != null) {
      if (number_of_mandatory_instancesRaw is! num) {
        throw FormatException('ImeiTwoBarcodeFieldDefinition.number_of_mandatory_instances: expected a number');
      }
      if (number_of_mandatory_instancesRaw != number_of_mandatory_instancesRaw.toInt()) {
        throw FormatException('ImeiTwoBarcodeFieldDefinition.number_of_mandatory_instances: expected an integer');
      }
      number_of_mandatory_instancesValue = number_of_mandatory_instancesRaw.toInt();
    }
    final hasFieldType = raw.containsKey('fieldType');
    if (!hasFieldType) {
      throw FormatException("ImeiTwoBarcodeFieldDefinition.fieldType: missing required property");
    }
    final fieldTypeRaw = raw['fieldType'];
    String? fieldTypeValue;
    if (hasFieldType && fieldTypeRaw != null) {
      if (fieldTypeRaw is! String || !const <String>['imeiTwoBarcode'].contains(fieldTypeRaw)) {
        throw FormatException("ImeiTwoBarcodeFieldDefinition.fieldType: unknown enum value '$fieldTypeRaw'");
      }
      fieldTypeValue = fieldTypeRaw;
    } else if (hasFieldType && fieldTypeRaw == null) {
      throw FormatException('ImeiTwoBarcodeFieldDefinition.fieldType: null is not allowed');
    }
    final hasOptional = raw.containsKey('optional');
    final optionalRaw = raw['optional'];
    bool? optionalValue;
    if (hasOptional && optionalRaw != null) {
      if (optionalRaw is! bool) {
        throw FormatException('ImeiTwoBarcodeFieldDefinition.optional: expected a bool');
      }
      optionalValue = optionalRaw;
    } else if (hasOptional && optionalRaw == null) {
      throw FormatException('ImeiTwoBarcodeFieldDefinition.optional: null is not allowed');
    }
    final hasDataTypePatterns = raw.containsKey('dataTypePatterns');
    final dataTypePatternsRaw = raw['dataTypePatterns'];
    List<String>? dataTypePatternsValue;
    if (hasDataTypePatterns && dataTypePatternsRaw != null) {
      if (dataTypePatternsRaw is! List) {
        throw FormatException('ImeiTwoBarcodeFieldDefinition.dataTypePatterns: expected a List');
      }
      for (final item in dataTypePatternsRaw) {
        if (item is! String) {
          throw FormatException('ImeiTwoBarcodeFieldDefinition.dataTypePatterns: expected a List of String');
        }
      }
      dataTypePatternsValue = dataTypePatternsRaw.cast<String>();
    }
    final hasPatterns = raw.containsKey('patterns');
    final patternsRaw = raw['patterns'];
    List<String>? patternsValue;
    if (hasPatterns && patternsRaw != null) {
      if (patternsRaw is! List) {
        throw FormatException('ImeiTwoBarcodeFieldDefinition.patterns: expected a List');
      }
      for (final item in patternsRaw) {
        if (item is! String) {
          throw FormatException('ImeiTwoBarcodeFieldDefinition.patterns: expected a List of String');
        }
      }
      patternsValue = patternsRaw.cast<String>();
    }
    final hasSymbologies = raw.containsKey('symbologies');
    final symbologiesRaw = raw['symbologies'];
    SymbologySettings? symbologiesValue;
    if (hasSymbologies && symbologiesRaw != null) {
      symbologiesValue = parseSymbologySettings(symbologiesRaw);
    } else if (hasSymbologies && symbologiesRaw == null) {
      throw FormatException('ImeiTwoBarcodeFieldDefinition.symbologies: null is not allowed');
    }
    return ImeiTwoBarcodeFieldDefinition(
      name: nameValue!,
      number_of_mandatory_instances: number_of_mandatory_instancesValue,
      fieldType: fieldTypeValue!,
      optional: optionalValue,
      dataTypePatterns: dataTypePatternsValue,
      patterns: patternsValue,
      symbologies: symbologiesValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['name'] = name;
    if (number_of_mandatory_instances != null) {
      map['number_of_mandatory_instances'] = number_of_mandatory_instances;
    }
    map['fieldType'] = fieldType;
    if (optional != null) {
      map['optional'] = optional;
    }
    if (dataTypePatterns != null) {
      map['dataTypePatterns'] = dataTypePatterns;
    }
    if (patterns != null) {
      map['patterns'] = patterns;
    }
    if (symbologies != null) {
      map['symbologies'] = symbologies;
    }
    return map;
  }
}

/// Typed builder for the `ImeiTwoBarcodeFieldDefinition` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildImeiTwoBarcodeFieldDefinition({
  required String name,
  Object? number_of_mandatory_instances = _unset,
  required String fieldType,
  bool? optional,
  Object? dataTypePatterns = _unset,
  Object? patterns = _unset,
  SymbologySettings? symbologies,
}) {
  final map = <String, Object?>{};
  map['name'] = name;
  if (!identical(number_of_mandatory_instances, _unset)) {
    map['number_of_mandatory_instances'] = number_of_mandatory_instances;
  }
  map['fieldType'] = fieldType;
  if (optional != null) {
    map['optional'] = optional;
  }
  if (!identical(dataTypePatterns, _unset)) {
    map['dataTypePatterns'] = dataTypePatterns;
  }
  if (!identical(patterns, _unset)) {
    map['patterns'] = patterns;
  }
  if (symbologies != null) {
    map['symbologies'] = symbologies;
  }
  return map;
}

/// Label field definition for a part number barcode field.
class PartNumberBarcodeFieldDefinition implements LabelFieldDefinition {
  final String name;
  final int? number_of_mandatory_instances;
  final String fieldType;
  final bool? optional;
  final List<String>? dataTypePatterns;
  final List<String>? patterns;
  final SymbologySettings? symbologies;

  const PartNumberBarcodeFieldDefinition({
    required this.name,
    this.number_of_mandatory_instances,
    required this.fieldType,
    this.optional,
    this.dataTypePatterns,
    this.patterns,
    this.symbologies,
  });

  factory PartNumberBarcodeFieldDefinition.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('PartNumberBarcodeFieldDefinition: expected a Map');
    }
    const allowedKeys = <String>{
      'name',
      'number_of_mandatory_instances',
      'fieldType',
      'optional',
      'dataTypePatterns',
      'patterns',
      'symbologies',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("PartNumberBarcodeFieldDefinition: unknown property '$key'");
      }
    }
    final hasName = raw.containsKey('name');
    if (!hasName) {
      throw FormatException("PartNumberBarcodeFieldDefinition.name: missing required property");
    }
    final nameRaw = raw['name'];
    String? nameValue;
    if (hasName && nameRaw != null) {
      if (nameRaw is! String) {
        throw FormatException('PartNumberBarcodeFieldDefinition.name: expected a String');
      }
      nameValue = nameRaw;
    } else if (hasName && nameRaw == null) {
      throw FormatException('PartNumberBarcodeFieldDefinition.name: null is not allowed');
    }
    final hasNumber_of_mandatory_instances = raw.containsKey('number_of_mandatory_instances');
    final number_of_mandatory_instancesRaw = raw['number_of_mandatory_instances'];
    int? number_of_mandatory_instancesValue;
    if (hasNumber_of_mandatory_instances && number_of_mandatory_instancesRaw != null) {
      if (number_of_mandatory_instancesRaw is! num) {
        throw FormatException('PartNumberBarcodeFieldDefinition.number_of_mandatory_instances: expected a number');
      }
      if (number_of_mandatory_instancesRaw != number_of_mandatory_instancesRaw.toInt()) {
        throw FormatException('PartNumberBarcodeFieldDefinition.number_of_mandatory_instances: expected an integer');
      }
      number_of_mandatory_instancesValue = number_of_mandatory_instancesRaw.toInt();
    }
    final hasFieldType = raw.containsKey('fieldType');
    if (!hasFieldType) {
      throw FormatException("PartNumberBarcodeFieldDefinition.fieldType: missing required property");
    }
    final fieldTypeRaw = raw['fieldType'];
    String? fieldTypeValue;
    if (hasFieldType && fieldTypeRaw != null) {
      if (fieldTypeRaw is! String || !const <String>['partNumberBarcode'].contains(fieldTypeRaw)) {
        throw FormatException("PartNumberBarcodeFieldDefinition.fieldType: unknown enum value '$fieldTypeRaw'");
      }
      fieldTypeValue = fieldTypeRaw;
    } else if (hasFieldType && fieldTypeRaw == null) {
      throw FormatException('PartNumberBarcodeFieldDefinition.fieldType: null is not allowed');
    }
    final hasOptional = raw.containsKey('optional');
    final optionalRaw = raw['optional'];
    bool? optionalValue;
    if (hasOptional && optionalRaw != null) {
      if (optionalRaw is! bool) {
        throw FormatException('PartNumberBarcodeFieldDefinition.optional: expected a bool');
      }
      optionalValue = optionalRaw;
    } else if (hasOptional && optionalRaw == null) {
      throw FormatException('PartNumberBarcodeFieldDefinition.optional: null is not allowed');
    }
    final hasDataTypePatterns = raw.containsKey('dataTypePatterns');
    final dataTypePatternsRaw = raw['dataTypePatterns'];
    List<String>? dataTypePatternsValue;
    if (hasDataTypePatterns && dataTypePatternsRaw != null) {
      if (dataTypePatternsRaw is! List) {
        throw FormatException('PartNumberBarcodeFieldDefinition.dataTypePatterns: expected a List');
      }
      for (final item in dataTypePatternsRaw) {
        if (item is! String) {
          throw FormatException('PartNumberBarcodeFieldDefinition.dataTypePatterns: expected a List of String');
        }
      }
      dataTypePatternsValue = dataTypePatternsRaw.cast<String>();
    }
    final hasPatterns = raw.containsKey('patterns');
    final patternsRaw = raw['patterns'];
    List<String>? patternsValue;
    if (hasPatterns && patternsRaw != null) {
      if (patternsRaw is! List) {
        throw FormatException('PartNumberBarcodeFieldDefinition.patterns: expected a List');
      }
      for (final item in patternsRaw) {
        if (item is! String) {
          throw FormatException('PartNumberBarcodeFieldDefinition.patterns: expected a List of String');
        }
      }
      patternsValue = patternsRaw.cast<String>();
    }
    final hasSymbologies = raw.containsKey('symbologies');
    final symbologiesRaw = raw['symbologies'];
    SymbologySettings? symbologiesValue;
    if (hasSymbologies && symbologiesRaw != null) {
      symbologiesValue = parseSymbologySettings(symbologiesRaw);
    } else if (hasSymbologies && symbologiesRaw == null) {
      throw FormatException('PartNumberBarcodeFieldDefinition.symbologies: null is not allowed');
    }
    return PartNumberBarcodeFieldDefinition(
      name: nameValue!,
      number_of_mandatory_instances: number_of_mandatory_instancesValue,
      fieldType: fieldTypeValue!,
      optional: optionalValue,
      dataTypePatterns: dataTypePatternsValue,
      patterns: patternsValue,
      symbologies: symbologiesValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['name'] = name;
    if (number_of_mandatory_instances != null) {
      map['number_of_mandatory_instances'] = number_of_mandatory_instances;
    }
    map['fieldType'] = fieldType;
    if (optional != null) {
      map['optional'] = optional;
    }
    if (dataTypePatterns != null) {
      map['dataTypePatterns'] = dataTypePatterns;
    }
    if (patterns != null) {
      map['patterns'] = patterns;
    }
    if (symbologies != null) {
      map['symbologies'] = symbologies;
    }
    return map;
  }
}

/// Typed builder for the `PartNumberBarcodeFieldDefinition` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildPartNumberBarcodeFieldDefinition({
  required String name,
  Object? number_of_mandatory_instances = _unset,
  required String fieldType,
  bool? optional,
  Object? dataTypePatterns = _unset,
  Object? patterns = _unset,
  SymbologySettings? symbologies,
}) {
  final map = <String, Object?>{};
  map['name'] = name;
  if (!identical(number_of_mandatory_instances, _unset)) {
    map['number_of_mandatory_instances'] = number_of_mandatory_instances;
  }
  map['fieldType'] = fieldType;
  if (optional != null) {
    map['optional'] = optional;
  }
  if (!identical(dataTypePatterns, _unset)) {
    map['dataTypePatterns'] = dataTypePatterns;
  }
  if (!identical(patterns, _unset)) {
    map['patterns'] = patterns;
  }
  if (symbologies != null) {
    map['symbologies'] = symbologies;
  }
  return map;
}

/// Label field definition for a serial number barcode field.
class SerialNumberBarcodeFieldDefinition implements LabelFieldDefinition {
  final String name;
  final int? number_of_mandatory_instances;
  final String fieldType;
  final bool? optional;
  final List<String>? dataTypePatterns;
  final List<String>? patterns;
  final SymbologySettings? symbologies;

  const SerialNumberBarcodeFieldDefinition({
    required this.name,
    this.number_of_mandatory_instances,
    required this.fieldType,
    this.optional,
    this.dataTypePatterns,
    this.patterns,
    this.symbologies,
  });

  factory SerialNumberBarcodeFieldDefinition.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('SerialNumberBarcodeFieldDefinition: expected a Map');
    }
    const allowedKeys = <String>{
      'name',
      'number_of_mandatory_instances',
      'fieldType',
      'optional',
      'dataTypePatterns',
      'patterns',
      'symbologies',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("SerialNumberBarcodeFieldDefinition: unknown property '$key'");
      }
    }
    final hasName = raw.containsKey('name');
    if (!hasName) {
      throw FormatException("SerialNumberBarcodeFieldDefinition.name: missing required property");
    }
    final nameRaw = raw['name'];
    String? nameValue;
    if (hasName && nameRaw != null) {
      if (nameRaw is! String) {
        throw FormatException('SerialNumberBarcodeFieldDefinition.name: expected a String');
      }
      nameValue = nameRaw;
    } else if (hasName && nameRaw == null) {
      throw FormatException('SerialNumberBarcodeFieldDefinition.name: null is not allowed');
    }
    final hasNumber_of_mandatory_instances = raw.containsKey('number_of_mandatory_instances');
    final number_of_mandatory_instancesRaw = raw['number_of_mandatory_instances'];
    int? number_of_mandatory_instancesValue;
    if (hasNumber_of_mandatory_instances && number_of_mandatory_instancesRaw != null) {
      if (number_of_mandatory_instancesRaw is! num) {
        throw FormatException('SerialNumberBarcodeFieldDefinition.number_of_mandatory_instances: expected a number');
      }
      if (number_of_mandatory_instancesRaw != number_of_mandatory_instancesRaw.toInt()) {
        throw FormatException('SerialNumberBarcodeFieldDefinition.number_of_mandatory_instances: expected an integer');
      }
      number_of_mandatory_instancesValue = number_of_mandatory_instancesRaw.toInt();
    }
    final hasFieldType = raw.containsKey('fieldType');
    if (!hasFieldType) {
      throw FormatException("SerialNumberBarcodeFieldDefinition.fieldType: missing required property");
    }
    final fieldTypeRaw = raw['fieldType'];
    String? fieldTypeValue;
    if (hasFieldType && fieldTypeRaw != null) {
      if (fieldTypeRaw is! String || !const <String>['serialNumberBarcode'].contains(fieldTypeRaw)) {
        throw FormatException("SerialNumberBarcodeFieldDefinition.fieldType: unknown enum value '$fieldTypeRaw'");
      }
      fieldTypeValue = fieldTypeRaw;
    } else if (hasFieldType && fieldTypeRaw == null) {
      throw FormatException('SerialNumberBarcodeFieldDefinition.fieldType: null is not allowed');
    }
    final hasOptional = raw.containsKey('optional');
    final optionalRaw = raw['optional'];
    bool? optionalValue;
    if (hasOptional && optionalRaw != null) {
      if (optionalRaw is! bool) {
        throw FormatException('SerialNumberBarcodeFieldDefinition.optional: expected a bool');
      }
      optionalValue = optionalRaw;
    } else if (hasOptional && optionalRaw == null) {
      throw FormatException('SerialNumberBarcodeFieldDefinition.optional: null is not allowed');
    }
    final hasDataTypePatterns = raw.containsKey('dataTypePatterns');
    final dataTypePatternsRaw = raw['dataTypePatterns'];
    List<String>? dataTypePatternsValue;
    if (hasDataTypePatterns && dataTypePatternsRaw != null) {
      if (dataTypePatternsRaw is! List) {
        throw FormatException('SerialNumberBarcodeFieldDefinition.dataTypePatterns: expected a List');
      }
      for (final item in dataTypePatternsRaw) {
        if (item is! String) {
          throw FormatException('SerialNumberBarcodeFieldDefinition.dataTypePatterns: expected a List of String');
        }
      }
      dataTypePatternsValue = dataTypePatternsRaw.cast<String>();
    }
    final hasPatterns = raw.containsKey('patterns');
    final patternsRaw = raw['patterns'];
    List<String>? patternsValue;
    if (hasPatterns && patternsRaw != null) {
      if (patternsRaw is! List) {
        throw FormatException('SerialNumberBarcodeFieldDefinition.patterns: expected a List');
      }
      for (final item in patternsRaw) {
        if (item is! String) {
          throw FormatException('SerialNumberBarcodeFieldDefinition.patterns: expected a List of String');
        }
      }
      patternsValue = patternsRaw.cast<String>();
    }
    final hasSymbologies = raw.containsKey('symbologies');
    final symbologiesRaw = raw['symbologies'];
    SymbologySettings? symbologiesValue;
    if (hasSymbologies && symbologiesRaw != null) {
      symbologiesValue = parseSymbologySettings(symbologiesRaw);
    } else if (hasSymbologies && symbologiesRaw == null) {
      throw FormatException('SerialNumberBarcodeFieldDefinition.symbologies: null is not allowed');
    }
    return SerialNumberBarcodeFieldDefinition(
      name: nameValue!,
      number_of_mandatory_instances: number_of_mandatory_instancesValue,
      fieldType: fieldTypeValue!,
      optional: optionalValue,
      dataTypePatterns: dataTypePatternsValue,
      patterns: patternsValue,
      symbologies: symbologiesValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['name'] = name;
    if (number_of_mandatory_instances != null) {
      map['number_of_mandatory_instances'] = number_of_mandatory_instances;
    }
    map['fieldType'] = fieldType;
    if (optional != null) {
      map['optional'] = optional;
    }
    if (dataTypePatterns != null) {
      map['dataTypePatterns'] = dataTypePatterns;
    }
    if (patterns != null) {
      map['patterns'] = patterns;
    }
    if (symbologies != null) {
      map['symbologies'] = symbologies;
    }
    return map;
  }
}

/// Typed builder for the `SerialNumberBarcodeFieldDefinition` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildSerialNumberBarcodeFieldDefinition({
  required String name,
  Object? number_of_mandatory_instances = _unset,
  required String fieldType,
  bool? optional,
  Object? dataTypePatterns = _unset,
  Object? patterns = _unset,
  SymbologySettings? symbologies,
}) {
  final map = <String, Object?>{};
  map['name'] = name;
  if (!identical(number_of_mandatory_instances, _unset)) {
    map['number_of_mandatory_instances'] = number_of_mandatory_instances;
  }
  map['fieldType'] = fieldType;
  if (optional != null) {
    map['optional'] = optional;
  }
  if (!identical(dataTypePatterns, _unset)) {
    map['dataTypePatterns'] = dataTypePatterns;
  }
  if (!identical(patterns, _unset)) {
    map['patterns'] = patterns;
  }
  if (symbologies != null) {
    map['symbologies'] = symbologies;
  }
  return map;
}

/// Label field definition for an expiry date text field.
class ExpiryDateTextFieldDefinition implements LabelFieldDefinition {
  final String name;
  final int? number_of_mandatory_instances;
  final LabelDateFormat? labelDateFormat;
  final String fieldType;
  final bool? optional;
  final List<String>? dataTypePatterns;
  final List<String>? patterns;

  const ExpiryDateTextFieldDefinition({
    required this.name,
    this.number_of_mandatory_instances,
    this.labelDateFormat,
    required this.fieldType,
    this.optional,
    this.dataTypePatterns,
    this.patterns,
  });

  factory ExpiryDateTextFieldDefinition.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('ExpiryDateTextFieldDefinition: expected a Map');
    }
    const allowedKeys = <String>{
      'name',
      'number_of_mandatory_instances',
      'labelDateFormat',
      'fieldType',
      'optional',
      'dataTypePatterns',
      'patterns',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("ExpiryDateTextFieldDefinition: unknown property '$key'");
      }
    }
    final hasName = raw.containsKey('name');
    if (!hasName) {
      throw FormatException("ExpiryDateTextFieldDefinition.name: missing required property");
    }
    final nameRaw = raw['name'];
    String? nameValue;
    if (hasName && nameRaw != null) {
      if (nameRaw is! String) {
        throw FormatException('ExpiryDateTextFieldDefinition.name: expected a String');
      }
      nameValue = nameRaw;
    } else if (hasName && nameRaw == null) {
      throw FormatException('ExpiryDateTextFieldDefinition.name: null is not allowed');
    }
    final hasNumber_of_mandatory_instances = raw.containsKey('number_of_mandatory_instances');
    final number_of_mandatory_instancesRaw = raw['number_of_mandatory_instances'];
    int? number_of_mandatory_instancesValue;
    if (hasNumber_of_mandatory_instances && number_of_mandatory_instancesRaw != null) {
      if (number_of_mandatory_instancesRaw is! num) {
        throw FormatException('ExpiryDateTextFieldDefinition.number_of_mandatory_instances: expected a number');
      }
      if (number_of_mandatory_instancesRaw != number_of_mandatory_instancesRaw.toInt()) {
        throw FormatException('ExpiryDateTextFieldDefinition.number_of_mandatory_instances: expected an integer');
      }
      number_of_mandatory_instancesValue = number_of_mandatory_instancesRaw.toInt();
    }
    final hasLabelDateFormat = raw.containsKey('labelDateFormat');
    final labelDateFormatRaw = raw['labelDateFormat'];
    LabelDateFormat? labelDateFormatValue;
    if (hasLabelDateFormat && labelDateFormatRaw != null) {
      labelDateFormatValue = LabelDateFormat.fromJson(labelDateFormatRaw);
    } else if (hasLabelDateFormat && labelDateFormatRaw == null) {
      throw FormatException('ExpiryDateTextFieldDefinition.labelDateFormat: null is not allowed');
    }
    final hasFieldType = raw.containsKey('fieldType');
    if (!hasFieldType) {
      throw FormatException("ExpiryDateTextFieldDefinition.fieldType: missing required property");
    }
    final fieldTypeRaw = raw['fieldType'];
    String? fieldTypeValue;
    if (hasFieldType && fieldTypeRaw != null) {
      if (fieldTypeRaw is! String || !const <String>['expiryDateText'].contains(fieldTypeRaw)) {
        throw FormatException("ExpiryDateTextFieldDefinition.fieldType: unknown enum value '$fieldTypeRaw'");
      }
      fieldTypeValue = fieldTypeRaw;
    } else if (hasFieldType && fieldTypeRaw == null) {
      throw FormatException('ExpiryDateTextFieldDefinition.fieldType: null is not allowed');
    }
    final hasOptional = raw.containsKey('optional');
    final optionalRaw = raw['optional'];
    bool? optionalValue;
    if (hasOptional && optionalRaw != null) {
      if (optionalRaw is! bool) {
        throw FormatException('ExpiryDateTextFieldDefinition.optional: expected a bool');
      }
      optionalValue = optionalRaw;
    } else if (hasOptional && optionalRaw == null) {
      throw FormatException('ExpiryDateTextFieldDefinition.optional: null is not allowed');
    }
    final hasDataTypePatterns = raw.containsKey('dataTypePatterns');
    final dataTypePatternsRaw = raw['dataTypePatterns'];
    List<String>? dataTypePatternsValue;
    if (hasDataTypePatterns && dataTypePatternsRaw != null) {
      if (dataTypePatternsRaw is! List) {
        throw FormatException('ExpiryDateTextFieldDefinition.dataTypePatterns: expected a List');
      }
      for (final item in dataTypePatternsRaw) {
        if (item is! String) {
          throw FormatException('ExpiryDateTextFieldDefinition.dataTypePatterns: expected a List of String');
        }
      }
      dataTypePatternsValue = dataTypePatternsRaw.cast<String>();
    }
    final hasPatterns = raw.containsKey('patterns');
    final patternsRaw = raw['patterns'];
    List<String>? patternsValue;
    if (hasPatterns && patternsRaw != null) {
      if (patternsRaw is! List) {
        throw FormatException('ExpiryDateTextFieldDefinition.patterns: expected a List');
      }
      for (final item in patternsRaw) {
        if (item is! String) {
          throw FormatException('ExpiryDateTextFieldDefinition.patterns: expected a List of String');
        }
      }
      patternsValue = patternsRaw.cast<String>();
    }
    return ExpiryDateTextFieldDefinition(
      name: nameValue!,
      number_of_mandatory_instances: number_of_mandatory_instancesValue,
      labelDateFormat: labelDateFormatValue,
      fieldType: fieldTypeValue!,
      optional: optionalValue,
      dataTypePatterns: dataTypePatternsValue,
      patterns: patternsValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['name'] = name;
    if (number_of_mandatory_instances != null) {
      map['number_of_mandatory_instances'] = number_of_mandatory_instances;
    }
    if (labelDateFormat != null) {
      map['labelDateFormat'] = labelDateFormat!.toJson();
    }
    map['fieldType'] = fieldType;
    if (optional != null) {
      map['optional'] = optional;
    }
    if (dataTypePatterns != null) {
      map['dataTypePatterns'] = dataTypePatterns;
    }
    if (patterns != null) {
      map['patterns'] = patterns;
    }
    return map;
  }
}

/// Typed builder for the `ExpiryDateTextFieldDefinition` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildExpiryDateTextFieldDefinition({
  required String name,
  Object? number_of_mandatory_instances = _unset,
  Object? labelDateFormat,
  required String fieldType,
  bool? optional,
  Object? dataTypePatterns = _unset,
  Object? patterns = _unset,
}) {
  final map = <String, Object?>{};
  map['name'] = name;
  if (!identical(number_of_mandatory_instances, _unset)) {
    map['number_of_mandatory_instances'] = number_of_mandatory_instances;
  }
  if (labelDateFormat != null) {
    map['labelDateFormat'] = labelDateFormat;
  }
  map['fieldType'] = fieldType;
  if (optional != null) {
    map['optional'] = optional;
  }
  if (!identical(dataTypePatterns, _unset)) {
    map['dataTypePatterns'] = dataTypePatterns;
  }
  if (!identical(patterns, _unset)) {
    map['patterns'] = patterns;
  }
  return map;
}

/// Date-format hint controlling how a date label field is parsed.
class LabelDateFormat {
  final String componentFormat;
  final bool? acceptPartialDates;

  const LabelDateFormat({
    required this.componentFormat,
    this.acceptPartialDates,
  });

  factory LabelDateFormat.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LabelDateFormat: expected a Map');
    }
    const allowedKeys = <String>{
      'componentFormat',
      'acceptPartialDates',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("LabelDateFormat: unknown property '$key'");
      }
    }
    final hasComponentFormat = raw.containsKey('componentFormat');
    if (!hasComponentFormat) {
      throw FormatException("LabelDateFormat.componentFormat: missing required property");
    }
    final componentFormatRaw = raw['componentFormat'];
    String? componentFormatValue;
    if (hasComponentFormat && componentFormatRaw != null) {
      if (componentFormatRaw is! String || !const <String>['dmy', 'mdy', 'ymd'].contains(componentFormatRaw)) {
        throw FormatException("LabelDateFormat.componentFormat: unknown enum value '$componentFormatRaw'");
      }
      componentFormatValue = componentFormatRaw;
    } else if (hasComponentFormat && componentFormatRaw == null) {
      throw FormatException('LabelDateFormat.componentFormat: null is not allowed');
    }
    final hasAcceptPartialDates = raw.containsKey('acceptPartialDates');
    final acceptPartialDatesRaw = raw['acceptPartialDates'];
    bool? acceptPartialDatesValue;
    if (hasAcceptPartialDates && acceptPartialDatesRaw != null) {
      if (acceptPartialDatesRaw is! bool) {
        throw FormatException('LabelDateFormat.acceptPartialDates: expected a bool');
      }
      acceptPartialDatesValue = acceptPartialDatesRaw;
    } else if (hasAcceptPartialDates && acceptPartialDatesRaw == null) {
      throw FormatException('LabelDateFormat.acceptPartialDates: null is not allowed');
    }
    return LabelDateFormat(
      componentFormat: componentFormatValue!,
      acceptPartialDates: acceptPartialDatesValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['componentFormat'] = componentFormat;
    if (acceptPartialDates != null) {
      map['acceptPartialDates'] = acceptPartialDates;
    }
    return map;
  }
}

/// Typed builder for the `LabelDateFormat` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildLabelDateFormat({
  required String componentFormat,
  bool? acceptPartialDates,
}) {
  final map = <String, Object?>{};
  map['componentFormat'] = componentFormat;
  if (acceptPartialDates != null) {
    map['acceptPartialDates'] = acceptPartialDates;
  }
  return map;
}

/// Label field definition for a packing date text field.
class PackingDateTextFieldDefinition implements LabelFieldDefinition {
  final String name;
  final int? number_of_mandatory_instances;
  final LabelDateFormat? labelDateFormat;
  final String fieldType;
  final bool? optional;
  final List<String>? dataTypePatterns;
  final List<String>? patterns;

  const PackingDateTextFieldDefinition({
    required this.name,
    this.number_of_mandatory_instances,
    this.labelDateFormat,
    required this.fieldType,
    this.optional,
    this.dataTypePatterns,
    this.patterns,
  });

  factory PackingDateTextFieldDefinition.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('PackingDateTextFieldDefinition: expected a Map');
    }
    const allowedKeys = <String>{
      'name',
      'number_of_mandatory_instances',
      'labelDateFormat',
      'fieldType',
      'optional',
      'dataTypePatterns',
      'patterns',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("PackingDateTextFieldDefinition: unknown property '$key'");
      }
    }
    final hasName = raw.containsKey('name');
    if (!hasName) {
      throw FormatException("PackingDateTextFieldDefinition.name: missing required property");
    }
    final nameRaw = raw['name'];
    String? nameValue;
    if (hasName && nameRaw != null) {
      if (nameRaw is! String) {
        throw FormatException('PackingDateTextFieldDefinition.name: expected a String');
      }
      nameValue = nameRaw;
    } else if (hasName && nameRaw == null) {
      throw FormatException('PackingDateTextFieldDefinition.name: null is not allowed');
    }
    final hasNumber_of_mandatory_instances = raw.containsKey('number_of_mandatory_instances');
    final number_of_mandatory_instancesRaw = raw['number_of_mandatory_instances'];
    int? number_of_mandatory_instancesValue;
    if (hasNumber_of_mandatory_instances && number_of_mandatory_instancesRaw != null) {
      if (number_of_mandatory_instancesRaw is! num) {
        throw FormatException('PackingDateTextFieldDefinition.number_of_mandatory_instances: expected a number');
      }
      if (number_of_mandatory_instancesRaw != number_of_mandatory_instancesRaw.toInt()) {
        throw FormatException('PackingDateTextFieldDefinition.number_of_mandatory_instances: expected an integer');
      }
      number_of_mandatory_instancesValue = number_of_mandatory_instancesRaw.toInt();
    }
    final hasLabelDateFormat = raw.containsKey('labelDateFormat');
    final labelDateFormatRaw = raw['labelDateFormat'];
    LabelDateFormat? labelDateFormatValue;
    if (hasLabelDateFormat && labelDateFormatRaw != null) {
      labelDateFormatValue = LabelDateFormat.fromJson(labelDateFormatRaw);
    } else if (hasLabelDateFormat && labelDateFormatRaw == null) {
      throw FormatException('PackingDateTextFieldDefinition.labelDateFormat: null is not allowed');
    }
    final hasFieldType = raw.containsKey('fieldType');
    if (!hasFieldType) {
      throw FormatException("PackingDateTextFieldDefinition.fieldType: missing required property");
    }
    final fieldTypeRaw = raw['fieldType'];
    String? fieldTypeValue;
    if (hasFieldType && fieldTypeRaw != null) {
      if (fieldTypeRaw is! String || !const <String>['packingDateText'].contains(fieldTypeRaw)) {
        throw FormatException("PackingDateTextFieldDefinition.fieldType: unknown enum value '$fieldTypeRaw'");
      }
      fieldTypeValue = fieldTypeRaw;
    } else if (hasFieldType && fieldTypeRaw == null) {
      throw FormatException('PackingDateTextFieldDefinition.fieldType: null is not allowed');
    }
    final hasOptional = raw.containsKey('optional');
    final optionalRaw = raw['optional'];
    bool? optionalValue;
    if (hasOptional && optionalRaw != null) {
      if (optionalRaw is! bool) {
        throw FormatException('PackingDateTextFieldDefinition.optional: expected a bool');
      }
      optionalValue = optionalRaw;
    } else if (hasOptional && optionalRaw == null) {
      throw FormatException('PackingDateTextFieldDefinition.optional: null is not allowed');
    }
    final hasDataTypePatterns = raw.containsKey('dataTypePatterns');
    final dataTypePatternsRaw = raw['dataTypePatterns'];
    List<String>? dataTypePatternsValue;
    if (hasDataTypePatterns && dataTypePatternsRaw != null) {
      if (dataTypePatternsRaw is! List) {
        throw FormatException('PackingDateTextFieldDefinition.dataTypePatterns: expected a List');
      }
      for (final item in dataTypePatternsRaw) {
        if (item is! String) {
          throw FormatException('PackingDateTextFieldDefinition.dataTypePatterns: expected a List of String');
        }
      }
      dataTypePatternsValue = dataTypePatternsRaw.cast<String>();
    }
    final hasPatterns = raw.containsKey('patterns');
    final patternsRaw = raw['patterns'];
    List<String>? patternsValue;
    if (hasPatterns && patternsRaw != null) {
      if (patternsRaw is! List) {
        throw FormatException('PackingDateTextFieldDefinition.patterns: expected a List');
      }
      for (final item in patternsRaw) {
        if (item is! String) {
          throw FormatException('PackingDateTextFieldDefinition.patterns: expected a List of String');
        }
      }
      patternsValue = patternsRaw.cast<String>();
    }
    return PackingDateTextFieldDefinition(
      name: nameValue!,
      number_of_mandatory_instances: number_of_mandatory_instancesValue,
      labelDateFormat: labelDateFormatValue,
      fieldType: fieldTypeValue!,
      optional: optionalValue,
      dataTypePatterns: dataTypePatternsValue,
      patterns: patternsValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['name'] = name;
    if (number_of_mandatory_instances != null) {
      map['number_of_mandatory_instances'] = number_of_mandatory_instances;
    }
    if (labelDateFormat != null) {
      map['labelDateFormat'] = labelDateFormat!.toJson();
    }
    map['fieldType'] = fieldType;
    if (optional != null) {
      map['optional'] = optional;
    }
    if (dataTypePatterns != null) {
      map['dataTypePatterns'] = dataTypePatterns;
    }
    if (patterns != null) {
      map['patterns'] = patterns;
    }
    return map;
  }
}

/// Typed builder for the `PackingDateTextFieldDefinition` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildPackingDateTextFieldDefinition({
  required String name,
  Object? number_of_mandatory_instances = _unset,
  Object? labelDateFormat,
  required String fieldType,
  bool? optional,
  Object? dataTypePatterns = _unset,
  Object? patterns = _unset,
}) {
  final map = <String, Object?>{};
  map['name'] = name;
  if (!identical(number_of_mandatory_instances, _unset)) {
    map['number_of_mandatory_instances'] = number_of_mandatory_instances;
  }
  if (labelDateFormat != null) {
    map['labelDateFormat'] = labelDateFormat;
  }
  map['fieldType'] = fieldType;
  if (optional != null) {
    map['optional'] = optional;
  }
  if (!identical(dataTypePatterns, _unset)) {
    map['dataTypePatterns'] = dataTypePatterns;
  }
  if (!identical(patterns, _unset)) {
    map['patterns'] = patterns;
  }
  return map;
}

/// Label field definition for a total price text field.
class TotalPriceTextFieldDefinition implements LabelFieldDefinition {
  final String name;
  final int? number_of_mandatory_instances;
  final String fieldType;
  final bool? optional;
  final List<String>? dataTypePatterns;
  final List<String>? patterns;

  const TotalPriceTextFieldDefinition({
    required this.name,
    this.number_of_mandatory_instances,
    required this.fieldType,
    this.optional,
    this.dataTypePatterns,
    this.patterns,
  });

  factory TotalPriceTextFieldDefinition.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('TotalPriceTextFieldDefinition: expected a Map');
    }
    const allowedKeys = <String>{
      'name',
      'number_of_mandatory_instances',
      'fieldType',
      'optional',
      'dataTypePatterns',
      'patterns',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("TotalPriceTextFieldDefinition: unknown property '$key'");
      }
    }
    final hasName = raw.containsKey('name');
    if (!hasName) {
      throw FormatException("TotalPriceTextFieldDefinition.name: missing required property");
    }
    final nameRaw = raw['name'];
    String? nameValue;
    if (hasName && nameRaw != null) {
      if (nameRaw is! String) {
        throw FormatException('TotalPriceTextFieldDefinition.name: expected a String');
      }
      nameValue = nameRaw;
    } else if (hasName && nameRaw == null) {
      throw FormatException('TotalPriceTextFieldDefinition.name: null is not allowed');
    }
    final hasNumber_of_mandatory_instances = raw.containsKey('number_of_mandatory_instances');
    final number_of_mandatory_instancesRaw = raw['number_of_mandatory_instances'];
    int? number_of_mandatory_instancesValue;
    if (hasNumber_of_mandatory_instances && number_of_mandatory_instancesRaw != null) {
      if (number_of_mandatory_instancesRaw is! num) {
        throw FormatException('TotalPriceTextFieldDefinition.number_of_mandatory_instances: expected a number');
      }
      if (number_of_mandatory_instancesRaw != number_of_mandatory_instancesRaw.toInt()) {
        throw FormatException('TotalPriceTextFieldDefinition.number_of_mandatory_instances: expected an integer');
      }
      number_of_mandatory_instancesValue = number_of_mandatory_instancesRaw.toInt();
    }
    final hasFieldType = raw.containsKey('fieldType');
    if (!hasFieldType) {
      throw FormatException("TotalPriceTextFieldDefinition.fieldType: missing required property");
    }
    final fieldTypeRaw = raw['fieldType'];
    String? fieldTypeValue;
    if (hasFieldType && fieldTypeRaw != null) {
      if (fieldTypeRaw is! String || !const <String>['totalPriceText'].contains(fieldTypeRaw)) {
        throw FormatException("TotalPriceTextFieldDefinition.fieldType: unknown enum value '$fieldTypeRaw'");
      }
      fieldTypeValue = fieldTypeRaw;
    } else if (hasFieldType && fieldTypeRaw == null) {
      throw FormatException('TotalPriceTextFieldDefinition.fieldType: null is not allowed');
    }
    final hasOptional = raw.containsKey('optional');
    final optionalRaw = raw['optional'];
    bool? optionalValue;
    if (hasOptional && optionalRaw != null) {
      if (optionalRaw is! bool) {
        throw FormatException('TotalPriceTextFieldDefinition.optional: expected a bool');
      }
      optionalValue = optionalRaw;
    } else if (hasOptional && optionalRaw == null) {
      throw FormatException('TotalPriceTextFieldDefinition.optional: null is not allowed');
    }
    final hasDataTypePatterns = raw.containsKey('dataTypePatterns');
    final dataTypePatternsRaw = raw['dataTypePatterns'];
    List<String>? dataTypePatternsValue;
    if (hasDataTypePatterns && dataTypePatternsRaw != null) {
      if (dataTypePatternsRaw is! List) {
        throw FormatException('TotalPriceTextFieldDefinition.dataTypePatterns: expected a List');
      }
      for (final item in dataTypePatternsRaw) {
        if (item is! String) {
          throw FormatException('TotalPriceTextFieldDefinition.dataTypePatterns: expected a List of String');
        }
      }
      dataTypePatternsValue = dataTypePatternsRaw.cast<String>();
    }
    final hasPatterns = raw.containsKey('patterns');
    final patternsRaw = raw['patterns'];
    List<String>? patternsValue;
    if (hasPatterns && patternsRaw != null) {
      if (patternsRaw is! List) {
        throw FormatException('TotalPriceTextFieldDefinition.patterns: expected a List');
      }
      for (final item in patternsRaw) {
        if (item is! String) {
          throw FormatException('TotalPriceTextFieldDefinition.patterns: expected a List of String');
        }
      }
      patternsValue = patternsRaw.cast<String>();
    }
    return TotalPriceTextFieldDefinition(
      name: nameValue!,
      number_of_mandatory_instances: number_of_mandatory_instancesValue,
      fieldType: fieldTypeValue!,
      optional: optionalValue,
      dataTypePatterns: dataTypePatternsValue,
      patterns: patternsValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['name'] = name;
    if (number_of_mandatory_instances != null) {
      map['number_of_mandatory_instances'] = number_of_mandatory_instances;
    }
    map['fieldType'] = fieldType;
    if (optional != null) {
      map['optional'] = optional;
    }
    if (dataTypePatterns != null) {
      map['dataTypePatterns'] = dataTypePatterns;
    }
    if (patterns != null) {
      map['patterns'] = patterns;
    }
    return map;
  }
}

/// Typed builder for the `TotalPriceTextFieldDefinition` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildTotalPriceTextFieldDefinition({
  required String name,
  Object? number_of_mandatory_instances = _unset,
  required String fieldType,
  bool? optional,
  Object? dataTypePatterns = _unset,
  Object? patterns = _unset,
}) {
  final map = <String, Object?>{};
  map['name'] = name;
  if (!identical(number_of_mandatory_instances, _unset)) {
    map['number_of_mandatory_instances'] = number_of_mandatory_instances;
  }
  map['fieldType'] = fieldType;
  if (optional != null) {
    map['optional'] = optional;
  }
  if (!identical(dataTypePatterns, _unset)) {
    map['dataTypePatterns'] = dataTypePatterns;
  }
  if (!identical(patterns, _unset)) {
    map['patterns'] = patterns;
  }
  return map;
}

/// Label field definition for a unit price text field.
class UnitPriceTextFieldDefinition implements LabelFieldDefinition {
  final String name;
  final int? number_of_mandatory_instances;
  final String fieldType;
  final bool? optional;
  final List<String>? dataTypePatterns;
  final List<String>? patterns;

  const UnitPriceTextFieldDefinition({
    required this.name,
    this.number_of_mandatory_instances,
    required this.fieldType,
    this.optional,
    this.dataTypePatterns,
    this.patterns,
  });

  factory UnitPriceTextFieldDefinition.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('UnitPriceTextFieldDefinition: expected a Map');
    }
    const allowedKeys = <String>{
      'name',
      'number_of_mandatory_instances',
      'fieldType',
      'optional',
      'dataTypePatterns',
      'patterns',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("UnitPriceTextFieldDefinition: unknown property '$key'");
      }
    }
    final hasName = raw.containsKey('name');
    if (!hasName) {
      throw FormatException("UnitPriceTextFieldDefinition.name: missing required property");
    }
    final nameRaw = raw['name'];
    String? nameValue;
    if (hasName && nameRaw != null) {
      if (nameRaw is! String) {
        throw FormatException('UnitPriceTextFieldDefinition.name: expected a String');
      }
      nameValue = nameRaw;
    } else if (hasName && nameRaw == null) {
      throw FormatException('UnitPriceTextFieldDefinition.name: null is not allowed');
    }
    final hasNumber_of_mandatory_instances = raw.containsKey('number_of_mandatory_instances');
    final number_of_mandatory_instancesRaw = raw['number_of_mandatory_instances'];
    int? number_of_mandatory_instancesValue;
    if (hasNumber_of_mandatory_instances && number_of_mandatory_instancesRaw != null) {
      if (number_of_mandatory_instancesRaw is! num) {
        throw FormatException('UnitPriceTextFieldDefinition.number_of_mandatory_instances: expected a number');
      }
      if (number_of_mandatory_instancesRaw != number_of_mandatory_instancesRaw.toInt()) {
        throw FormatException('UnitPriceTextFieldDefinition.number_of_mandatory_instances: expected an integer');
      }
      number_of_mandatory_instancesValue = number_of_mandatory_instancesRaw.toInt();
    }
    final hasFieldType = raw.containsKey('fieldType');
    if (!hasFieldType) {
      throw FormatException("UnitPriceTextFieldDefinition.fieldType: missing required property");
    }
    final fieldTypeRaw = raw['fieldType'];
    String? fieldTypeValue;
    if (hasFieldType && fieldTypeRaw != null) {
      if (fieldTypeRaw is! String || !const <String>['unitPriceText'].contains(fieldTypeRaw)) {
        throw FormatException("UnitPriceTextFieldDefinition.fieldType: unknown enum value '$fieldTypeRaw'");
      }
      fieldTypeValue = fieldTypeRaw;
    } else if (hasFieldType && fieldTypeRaw == null) {
      throw FormatException('UnitPriceTextFieldDefinition.fieldType: null is not allowed');
    }
    final hasOptional = raw.containsKey('optional');
    final optionalRaw = raw['optional'];
    bool? optionalValue;
    if (hasOptional && optionalRaw != null) {
      if (optionalRaw is! bool) {
        throw FormatException('UnitPriceTextFieldDefinition.optional: expected a bool');
      }
      optionalValue = optionalRaw;
    } else if (hasOptional && optionalRaw == null) {
      throw FormatException('UnitPriceTextFieldDefinition.optional: null is not allowed');
    }
    final hasDataTypePatterns = raw.containsKey('dataTypePatterns');
    final dataTypePatternsRaw = raw['dataTypePatterns'];
    List<String>? dataTypePatternsValue;
    if (hasDataTypePatterns && dataTypePatternsRaw != null) {
      if (dataTypePatternsRaw is! List) {
        throw FormatException('UnitPriceTextFieldDefinition.dataTypePatterns: expected a List');
      }
      for (final item in dataTypePatternsRaw) {
        if (item is! String) {
          throw FormatException('UnitPriceTextFieldDefinition.dataTypePatterns: expected a List of String');
        }
      }
      dataTypePatternsValue = dataTypePatternsRaw.cast<String>();
    }
    final hasPatterns = raw.containsKey('patterns');
    final patternsRaw = raw['patterns'];
    List<String>? patternsValue;
    if (hasPatterns && patternsRaw != null) {
      if (patternsRaw is! List) {
        throw FormatException('UnitPriceTextFieldDefinition.patterns: expected a List');
      }
      for (final item in patternsRaw) {
        if (item is! String) {
          throw FormatException('UnitPriceTextFieldDefinition.patterns: expected a List of String');
        }
      }
      patternsValue = patternsRaw.cast<String>();
    }
    return UnitPriceTextFieldDefinition(
      name: nameValue!,
      number_of_mandatory_instances: number_of_mandatory_instancesValue,
      fieldType: fieldTypeValue!,
      optional: optionalValue,
      dataTypePatterns: dataTypePatternsValue,
      patterns: patternsValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['name'] = name;
    if (number_of_mandatory_instances != null) {
      map['number_of_mandatory_instances'] = number_of_mandatory_instances;
    }
    map['fieldType'] = fieldType;
    if (optional != null) {
      map['optional'] = optional;
    }
    if (dataTypePatterns != null) {
      map['dataTypePatterns'] = dataTypePatterns;
    }
    if (patterns != null) {
      map['patterns'] = patterns;
    }
    return map;
  }
}

/// Typed builder for the `UnitPriceTextFieldDefinition` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildUnitPriceTextFieldDefinition({
  required String name,
  Object? number_of_mandatory_instances = _unset,
  required String fieldType,
  bool? optional,
  Object? dataTypePatterns = _unset,
  Object? patterns = _unset,
}) {
  final map = <String, Object?>{};
  map['name'] = name;
  if (!identical(number_of_mandatory_instances, _unset)) {
    map['number_of_mandatory_instances'] = number_of_mandatory_instances;
  }
  map['fieldType'] = fieldType;
  if (optional != null) {
    map['optional'] = optional;
  }
  if (!identical(dataTypePatterns, _unset)) {
    map['dataTypePatterns'] = dataTypePatterns;
  }
  if (!identical(patterns, _unset)) {
    map['patterns'] = patterns;
  }
  return map;
}

/// Label field definition for a weight text field.
class WeightTextFieldDefinition implements LabelFieldDefinition {
  final String name;
  final int? number_of_mandatory_instances;
  final String fieldType;
  final bool? optional;
  final List<String>? dataTypePatterns;
  final List<String>? patterns;

  const WeightTextFieldDefinition({
    required this.name,
    this.number_of_mandatory_instances,
    required this.fieldType,
    this.optional,
    this.dataTypePatterns,
    this.patterns,
  });

  factory WeightTextFieldDefinition.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('WeightTextFieldDefinition: expected a Map');
    }
    const allowedKeys = <String>{
      'name',
      'number_of_mandatory_instances',
      'fieldType',
      'optional',
      'dataTypePatterns',
      'patterns',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("WeightTextFieldDefinition: unknown property '$key'");
      }
    }
    final hasName = raw.containsKey('name');
    if (!hasName) {
      throw FormatException("WeightTextFieldDefinition.name: missing required property");
    }
    final nameRaw = raw['name'];
    String? nameValue;
    if (hasName && nameRaw != null) {
      if (nameRaw is! String) {
        throw FormatException('WeightTextFieldDefinition.name: expected a String');
      }
      nameValue = nameRaw;
    } else if (hasName && nameRaw == null) {
      throw FormatException('WeightTextFieldDefinition.name: null is not allowed');
    }
    final hasNumber_of_mandatory_instances = raw.containsKey('number_of_mandatory_instances');
    final number_of_mandatory_instancesRaw = raw['number_of_mandatory_instances'];
    int? number_of_mandatory_instancesValue;
    if (hasNumber_of_mandatory_instances && number_of_mandatory_instancesRaw != null) {
      if (number_of_mandatory_instancesRaw is! num) {
        throw FormatException('WeightTextFieldDefinition.number_of_mandatory_instances: expected a number');
      }
      if (number_of_mandatory_instancesRaw != number_of_mandatory_instancesRaw.toInt()) {
        throw FormatException('WeightTextFieldDefinition.number_of_mandatory_instances: expected an integer');
      }
      number_of_mandatory_instancesValue = number_of_mandatory_instancesRaw.toInt();
    }
    final hasFieldType = raw.containsKey('fieldType');
    if (!hasFieldType) {
      throw FormatException("WeightTextFieldDefinition.fieldType: missing required property");
    }
    final fieldTypeRaw = raw['fieldType'];
    String? fieldTypeValue;
    if (hasFieldType && fieldTypeRaw != null) {
      if (fieldTypeRaw is! String || !const <String>['weightText'].contains(fieldTypeRaw)) {
        throw FormatException("WeightTextFieldDefinition.fieldType: unknown enum value '$fieldTypeRaw'");
      }
      fieldTypeValue = fieldTypeRaw;
    } else if (hasFieldType && fieldTypeRaw == null) {
      throw FormatException('WeightTextFieldDefinition.fieldType: null is not allowed');
    }
    final hasOptional = raw.containsKey('optional');
    final optionalRaw = raw['optional'];
    bool? optionalValue;
    if (hasOptional && optionalRaw != null) {
      if (optionalRaw is! bool) {
        throw FormatException('WeightTextFieldDefinition.optional: expected a bool');
      }
      optionalValue = optionalRaw;
    } else if (hasOptional && optionalRaw == null) {
      throw FormatException('WeightTextFieldDefinition.optional: null is not allowed');
    }
    final hasDataTypePatterns = raw.containsKey('dataTypePatterns');
    final dataTypePatternsRaw = raw['dataTypePatterns'];
    List<String>? dataTypePatternsValue;
    if (hasDataTypePatterns && dataTypePatternsRaw != null) {
      if (dataTypePatternsRaw is! List) {
        throw FormatException('WeightTextFieldDefinition.dataTypePatterns: expected a List');
      }
      for (final item in dataTypePatternsRaw) {
        if (item is! String) {
          throw FormatException('WeightTextFieldDefinition.dataTypePatterns: expected a List of String');
        }
      }
      dataTypePatternsValue = dataTypePatternsRaw.cast<String>();
    }
    final hasPatterns = raw.containsKey('patterns');
    final patternsRaw = raw['patterns'];
    List<String>? patternsValue;
    if (hasPatterns && patternsRaw != null) {
      if (patternsRaw is! List) {
        throw FormatException('WeightTextFieldDefinition.patterns: expected a List');
      }
      for (final item in patternsRaw) {
        if (item is! String) {
          throw FormatException('WeightTextFieldDefinition.patterns: expected a List of String');
        }
      }
      patternsValue = patternsRaw.cast<String>();
    }
    return WeightTextFieldDefinition(
      name: nameValue!,
      number_of_mandatory_instances: number_of_mandatory_instancesValue,
      fieldType: fieldTypeValue!,
      optional: optionalValue,
      dataTypePatterns: dataTypePatternsValue,
      patterns: patternsValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['name'] = name;
    if (number_of_mandatory_instances != null) {
      map['number_of_mandatory_instances'] = number_of_mandatory_instances;
    }
    map['fieldType'] = fieldType;
    if (optional != null) {
      map['optional'] = optional;
    }
    if (dataTypePatterns != null) {
      map['dataTypePatterns'] = dataTypePatterns;
    }
    if (patterns != null) {
      map['patterns'] = patterns;
    }
    return map;
  }
}

/// Typed builder for the `WeightTextFieldDefinition` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildWeightTextFieldDefinition({
  required String name,
  Object? number_of_mandatory_instances = _unset,
  required String fieldType,
  bool? optional,
  Object? dataTypePatterns = _unset,
  Object? patterns = _unset,
}) {
  final map = <String, Object?>{};
  map['name'] = name;
  if (!identical(number_of_mandatory_instances, _unset)) {
    map['number_of_mandatory_instances'] = number_of_mandatory_instances;
  }
  map['fieldType'] = fieldType;
  if (optional != null) {
    map['optional'] = optional;
  }
  if (!identical(dataTypePatterns, _unset)) {
    map['dataTypePatterns'] = dataTypePatterns;
  }
  if (!identical(patterns, _unset)) {
    map['patterns'] = patterns;
  }
  return map;
}

/// Label field definition for a custom barcode field.
class CustomBarcodeLabelFieldDefinition implements LabelFieldDefinition {
  final String name;
  final int? number_of_mandatory_instances;
  final String fieldType;
  final bool? optional;
  final List<String>? dataTypePatterns;
  final List<String>? patterns;
  final LabelFieldLocation? location;
  final SymbologySettings? symbologies;

  const CustomBarcodeLabelFieldDefinition({
    required this.name,
    this.number_of_mandatory_instances,
    required this.fieldType,
    this.optional,
    this.dataTypePatterns,
    this.patterns,
    this.location,
    this.symbologies,
  });

  factory CustomBarcodeLabelFieldDefinition.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('CustomBarcodeLabelFieldDefinition: expected a Map');
    }
    const allowedKeys = <String>{
      'name',
      'number_of_mandatory_instances',
      'fieldType',
      'optional',
      'dataTypePatterns',
      'patterns',
      'location',
      'symbologies',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("CustomBarcodeLabelFieldDefinition: unknown property '$key'");
      }
    }
    final hasName = raw.containsKey('name');
    if (!hasName) {
      throw FormatException("CustomBarcodeLabelFieldDefinition.name: missing required property");
    }
    final nameRaw = raw['name'];
    String? nameValue;
    if (hasName && nameRaw != null) {
      if (nameRaw is! String) {
        throw FormatException('CustomBarcodeLabelFieldDefinition.name: expected a String');
      }
      nameValue = nameRaw;
    } else if (hasName && nameRaw == null) {
      throw FormatException('CustomBarcodeLabelFieldDefinition.name: null is not allowed');
    }
    final hasNumber_of_mandatory_instances = raw.containsKey('number_of_mandatory_instances');
    final number_of_mandatory_instancesRaw = raw['number_of_mandatory_instances'];
    int? number_of_mandatory_instancesValue;
    if (hasNumber_of_mandatory_instances && number_of_mandatory_instancesRaw != null) {
      if (number_of_mandatory_instancesRaw is! num) {
        throw FormatException('CustomBarcodeLabelFieldDefinition.number_of_mandatory_instances: expected a number');
      }
      if (number_of_mandatory_instancesRaw != number_of_mandatory_instancesRaw.toInt()) {
        throw FormatException('CustomBarcodeLabelFieldDefinition.number_of_mandatory_instances: expected an integer');
      }
      number_of_mandatory_instancesValue = number_of_mandatory_instancesRaw.toInt();
    }
    final hasFieldType = raw.containsKey('fieldType');
    if (!hasFieldType) {
      throw FormatException("CustomBarcodeLabelFieldDefinition.fieldType: missing required property");
    }
    final fieldTypeRaw = raw['fieldType'];
    String? fieldTypeValue;
    if (hasFieldType && fieldTypeRaw != null) {
      if (fieldTypeRaw is! String || !const <String>['customBarcode'].contains(fieldTypeRaw)) {
        throw FormatException("CustomBarcodeLabelFieldDefinition.fieldType: unknown enum value '$fieldTypeRaw'");
      }
      fieldTypeValue = fieldTypeRaw;
    } else if (hasFieldType && fieldTypeRaw == null) {
      throw FormatException('CustomBarcodeLabelFieldDefinition.fieldType: null is not allowed');
    }
    final hasOptional = raw.containsKey('optional');
    final optionalRaw = raw['optional'];
    bool? optionalValue;
    if (hasOptional && optionalRaw != null) {
      if (optionalRaw is! bool) {
        throw FormatException('CustomBarcodeLabelFieldDefinition.optional: expected a bool');
      }
      optionalValue = optionalRaw;
    } else if (hasOptional && optionalRaw == null) {
      throw FormatException('CustomBarcodeLabelFieldDefinition.optional: null is not allowed');
    }
    final hasDataTypePatterns = raw.containsKey('dataTypePatterns');
    final dataTypePatternsRaw = raw['dataTypePatterns'];
    List<String>? dataTypePatternsValue;
    if (hasDataTypePatterns && dataTypePatternsRaw != null) {
      if (dataTypePatternsRaw is! List) {
        throw FormatException('CustomBarcodeLabelFieldDefinition.dataTypePatterns: expected a List');
      }
      for (final item in dataTypePatternsRaw) {
        if (item is! String) {
          throw FormatException('CustomBarcodeLabelFieldDefinition.dataTypePatterns: expected a List of String');
        }
      }
      dataTypePatternsValue = dataTypePatternsRaw.cast<String>();
    }
    final hasPatterns = raw.containsKey('patterns');
    final patternsRaw = raw['patterns'];
    List<String>? patternsValue;
    if (hasPatterns && patternsRaw != null) {
      if (patternsRaw is! List) {
        throw FormatException('CustomBarcodeLabelFieldDefinition.patterns: expected a List');
      }
      for (final item in patternsRaw) {
        if (item is! String) {
          throw FormatException('CustomBarcodeLabelFieldDefinition.patterns: expected a List of String');
        }
      }
      patternsValue = patternsRaw.cast<String>();
    }
    final hasLocation = raw.containsKey('location');
    final locationRaw = raw['location'];
    LabelFieldLocation? locationValue;
    if (hasLocation && locationRaw != null) {
      locationValue = LabelFieldLocation.fromJson(locationRaw);
    } else if (hasLocation && locationRaw == null) {
      throw FormatException('CustomBarcodeLabelFieldDefinition.location: null is not allowed');
    }
    final hasSymbologies = raw.containsKey('symbologies');
    final symbologiesRaw = raw['symbologies'];
    SymbologySettings? symbologiesValue;
    if (hasSymbologies && symbologiesRaw != null) {
      symbologiesValue = parseSymbologySettings(symbologiesRaw);
    } else if (hasSymbologies && symbologiesRaw == null) {
      throw FormatException('CustomBarcodeLabelFieldDefinition.symbologies: null is not allowed');
    }
    return CustomBarcodeLabelFieldDefinition(
      name: nameValue!,
      number_of_mandatory_instances: number_of_mandatory_instancesValue,
      fieldType: fieldTypeValue!,
      optional: optionalValue,
      dataTypePatterns: dataTypePatternsValue,
      patterns: patternsValue,
      location: locationValue,
      symbologies: symbologiesValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['name'] = name;
    if (number_of_mandatory_instances != null) {
      map['number_of_mandatory_instances'] = number_of_mandatory_instances;
    }
    map['fieldType'] = fieldType;
    if (optional != null) {
      map['optional'] = optional;
    }
    if (dataTypePatterns != null) {
      map['dataTypePatterns'] = dataTypePatterns;
    }
    if (patterns != null) {
      map['patterns'] = patterns;
    }
    if (location != null) {
      map['location'] = location!.toJson();
    }
    if (symbologies != null) {
      map['symbologies'] = symbologies;
    }
    return map;
  }
}

/// Typed builder for the `CustomBarcodeLabelFieldDefinition` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildCustomBarcodeLabelFieldDefinition({
  required String name,
  Object? number_of_mandatory_instances = _unset,
  required String fieldType,
  bool? optional,
  Object? dataTypePatterns = _unset,
  Object? patterns = _unset,
  Object? location,
  SymbologySettings? symbologies,
}) {
  final map = <String, Object?>{};
  map['name'] = name;
  if (!identical(number_of_mandatory_instances, _unset)) {
    map['number_of_mandatory_instances'] = number_of_mandatory_instances;
  }
  map['fieldType'] = fieldType;
  if (optional != null) {
    map['optional'] = optional;
  }
  if (!identical(dataTypePatterns, _unset)) {
    map['dataTypePatterns'] = dataTypePatterns;
  }
  if (!identical(patterns, _unset)) {
    map['patterns'] = patterns;
  }
  if (location != null) {
    map['location'] = location;
  }
  if (symbologies != null) {
    map['symbologies'] = symbologies;
  }
  return map;
}

/// Location of a label field, specified either by type (LabelFieldLocationType) or an explicit bounding rectangle.
class LabelFieldLocation {
  final String? type;
  final Rect? rect;

  const LabelFieldLocation({
    this.type,
    this.rect,
  });

  factory LabelFieldLocation.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LabelFieldLocation: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'rect',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("LabelFieldLocation: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String ||
          !const <String>[
            'topLeft',
            'topRight',
            'bottomRight',
            'bottomLeft',
            'top',
            'right',
            'bottom',
            'left',
            'center',
            'wholeLabel'
          ].contains(typeRaw)) {
        throw FormatException("LabelFieldLocation.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('LabelFieldLocation.type: null is not allowed');
    }
    final hasRect = raw.containsKey('rect');
    final rectRaw = raw['rect'];
    Rect? rectValue;
    if (hasRect && rectRaw != null) {
      rectValue = Rect.fromJson(rectRaw);
    } else if (hasRect && rectRaw == null) {
      throw FormatException('LabelFieldLocation.rect: null is not allowed');
    }
    return LabelFieldLocation(
      type: typeValue,
      rect: rectValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (type != null) {
      map['type'] = type;
    }
    if (rect != null) {
      map['rect'] = rect!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `LabelFieldLocation` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildLabelFieldLocation({
  String? type,
  Object? rect,
}) {
  final map = <String, Object?>{};
  if (type != null) {
    map['type'] = type;
  }
  if (rect != null) {
    map['rect'] = rect;
  }
  return map;
}

/// A rectangle defined by an origin point and a size.
class Rect {
  final RectOrigin origin;
  final RectSize size;

  const Rect({
    required this.origin,
    required this.size,
  });

  factory Rect.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('Rect: expected a Map');
    }
    const allowedKeys = <String>{
      'origin',
      'size',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("Rect: unknown property '$key'");
      }
    }
    final hasOrigin = raw.containsKey('origin');
    if (!hasOrigin) {
      throw FormatException("Rect.origin: missing required property");
    }
    final originRaw = raw['origin'];
    RectOrigin? originValue;
    if (hasOrigin && originRaw != null) {
      originValue = RectOrigin.fromJson(originRaw);
    } else if (hasOrigin && originRaw == null) {
      throw FormatException('Rect.origin: null is not allowed');
    }
    final hasSize = raw.containsKey('size');
    if (!hasSize) {
      throw FormatException("Rect.size: missing required property");
    }
    final sizeRaw = raw['size'];
    RectSize? sizeValue;
    if (hasSize && sizeRaw != null) {
      sizeValue = RectSize.fromJson(sizeRaw);
    } else if (hasSize && sizeRaw == null) {
      throw FormatException('Rect.size: null is not allowed');
    }
    return Rect(
      origin: originValue!,
      size: sizeValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['origin'] = origin.toJson();
    map['size'] = size.toJson();
    return map;
  }
}

/// Typed builder for the `Rect` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildRect({
  required Object origin,
  required Object size,
}) {
  final map = <String, Object?>{};
  map['origin'] = origin;
  map['size'] = size;
  return map;
}

/// The origin of the rectangle.
class RectOrigin {
  final double x;
  final double y;

  const RectOrigin({
    required this.x,
    required this.y,
  });

  factory RectOrigin.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('RectOrigin: expected a Map');
    }
    const allowedKeys = <String>{
      'x',
      'y',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("RectOrigin: unknown property '$key'");
      }
    }
    final hasX = raw.containsKey('x');
    if (!hasX) {
      throw FormatException("RectOrigin.x: missing required property");
    }
    final xRaw = raw['x'];
    double? xValue;
    if (hasX && xRaw != null) {
      if (xRaw is! num) {
        throw FormatException('RectOrigin.x: expected a number');
      }
      xValue = xRaw.toDouble();
    } else if (hasX && xRaw == null) {
      throw FormatException('RectOrigin.x: null is not allowed');
    }
    final hasY = raw.containsKey('y');
    if (!hasY) {
      throw FormatException("RectOrigin.y: missing required property");
    }
    final yRaw = raw['y'];
    double? yValue;
    if (hasY && yRaw != null) {
      if (yRaw is! num) {
        throw FormatException('RectOrigin.y: expected a number');
      }
      yValue = yRaw.toDouble();
    } else if (hasY && yRaw == null) {
      throw FormatException('RectOrigin.y: null is not allowed');
    }
    return RectOrigin(
      x: xValue!,
      y: yValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['x'] = x;
    map['y'] = y;
    return map;
  }
}

/// Typed builder for the `RectOrigin` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildRectOrigin({
  required double x,
  required double y,
}) {
  final map = <String, Object?>{};
  map['x'] = x;
  map['y'] = y;
  return map;
}

/// The size of the rectangle.
class RectSize {
  final double width;
  final double height;

  const RectSize({
    required this.width,
    required this.height,
  });

  factory RectSize.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('RectSize: expected a Map');
    }
    const allowedKeys = <String>{
      'width',
      'height',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("RectSize: unknown property '$key'");
      }
    }
    final hasWidth = raw.containsKey('width');
    if (!hasWidth) {
      throw FormatException("RectSize.width: missing required property");
    }
    final widthRaw = raw['width'];
    double? widthValue;
    if (hasWidth && widthRaw != null) {
      if (widthRaw is! num) {
        throw FormatException('RectSize.width: expected a number');
      }
      widthValue = widthRaw.toDouble();
    } else if (hasWidth && widthRaw == null) {
      throw FormatException('RectSize.width: null is not allowed');
    }
    final hasHeight = raw.containsKey('height');
    if (!hasHeight) {
      throw FormatException("RectSize.height: missing required property");
    }
    final heightRaw = raw['height'];
    double? heightValue;
    if (hasHeight && heightRaw != null) {
      if (heightRaw is! num) {
        throw FormatException('RectSize.height: expected a number');
      }
      heightValue = heightRaw.toDouble();
    } else if (hasHeight && heightRaw == null) {
      throw FormatException('RectSize.height: null is not allowed');
    }
    return RectSize(
      width: widthValue!,
      height: heightValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['width'] = width;
    map['height'] = height;
    return map;
  }
}

/// Typed builder for the `RectSize` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildRectSize({
  required double width,
  required double height,
}) {
  final map = <String, Object?>{};
  map['width'] = width;
  map['height'] = height;
  return map;
}

/// Label field definition for a custom text field.
class CustomTextLabelFieldDefinition implements LabelFieldDefinition {
  final String name;
  final int? number_of_mandatory_instances;
  final String fieldType;
  final bool? optional;
  final List<String>? dataTypePatterns;
  final List<String>? patterns;
  final LabelFieldLocation? location;

  const CustomTextLabelFieldDefinition({
    required this.name,
    this.number_of_mandatory_instances,
    required this.fieldType,
    this.optional,
    this.dataTypePatterns,
    this.patterns,
    this.location,
  });

  factory CustomTextLabelFieldDefinition.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('CustomTextLabelFieldDefinition: expected a Map');
    }
    const allowedKeys = <String>{
      'name',
      'number_of_mandatory_instances',
      'fieldType',
      'optional',
      'dataTypePatterns',
      'patterns',
      'location',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("CustomTextLabelFieldDefinition: unknown property '$key'");
      }
    }
    final hasName = raw.containsKey('name');
    if (!hasName) {
      throw FormatException("CustomTextLabelFieldDefinition.name: missing required property");
    }
    final nameRaw = raw['name'];
    String? nameValue;
    if (hasName && nameRaw != null) {
      if (nameRaw is! String) {
        throw FormatException('CustomTextLabelFieldDefinition.name: expected a String');
      }
      nameValue = nameRaw;
    } else if (hasName && nameRaw == null) {
      throw FormatException('CustomTextLabelFieldDefinition.name: null is not allowed');
    }
    final hasNumber_of_mandatory_instances = raw.containsKey('number_of_mandatory_instances');
    final number_of_mandatory_instancesRaw = raw['number_of_mandatory_instances'];
    int? number_of_mandatory_instancesValue;
    if (hasNumber_of_mandatory_instances && number_of_mandatory_instancesRaw != null) {
      if (number_of_mandatory_instancesRaw is! num) {
        throw FormatException('CustomTextLabelFieldDefinition.number_of_mandatory_instances: expected a number');
      }
      if (number_of_mandatory_instancesRaw != number_of_mandatory_instancesRaw.toInt()) {
        throw FormatException('CustomTextLabelFieldDefinition.number_of_mandatory_instances: expected an integer');
      }
      number_of_mandatory_instancesValue = number_of_mandatory_instancesRaw.toInt();
    }
    final hasFieldType = raw.containsKey('fieldType');
    if (!hasFieldType) {
      throw FormatException("CustomTextLabelFieldDefinition.fieldType: missing required property");
    }
    final fieldTypeRaw = raw['fieldType'];
    String? fieldTypeValue;
    if (hasFieldType && fieldTypeRaw != null) {
      if (fieldTypeRaw is! String || !const <String>['customText'].contains(fieldTypeRaw)) {
        throw FormatException("CustomTextLabelFieldDefinition.fieldType: unknown enum value '$fieldTypeRaw'");
      }
      fieldTypeValue = fieldTypeRaw;
    } else if (hasFieldType && fieldTypeRaw == null) {
      throw FormatException('CustomTextLabelFieldDefinition.fieldType: null is not allowed');
    }
    final hasOptional = raw.containsKey('optional');
    final optionalRaw = raw['optional'];
    bool? optionalValue;
    if (hasOptional && optionalRaw != null) {
      if (optionalRaw is! bool) {
        throw FormatException('CustomTextLabelFieldDefinition.optional: expected a bool');
      }
      optionalValue = optionalRaw;
    } else if (hasOptional && optionalRaw == null) {
      throw FormatException('CustomTextLabelFieldDefinition.optional: null is not allowed');
    }
    final hasDataTypePatterns = raw.containsKey('dataTypePatterns');
    final dataTypePatternsRaw = raw['dataTypePatterns'];
    List<String>? dataTypePatternsValue;
    if (hasDataTypePatterns && dataTypePatternsRaw != null) {
      if (dataTypePatternsRaw is! List) {
        throw FormatException('CustomTextLabelFieldDefinition.dataTypePatterns: expected a List');
      }
      for (final item in dataTypePatternsRaw) {
        if (item is! String) {
          throw FormatException('CustomTextLabelFieldDefinition.dataTypePatterns: expected a List of String');
        }
      }
      dataTypePatternsValue = dataTypePatternsRaw.cast<String>();
    }
    final hasPatterns = raw.containsKey('patterns');
    final patternsRaw = raw['patterns'];
    List<String>? patternsValue;
    if (hasPatterns && patternsRaw != null) {
      if (patternsRaw is! List) {
        throw FormatException('CustomTextLabelFieldDefinition.patterns: expected a List');
      }
      for (final item in patternsRaw) {
        if (item is! String) {
          throw FormatException('CustomTextLabelFieldDefinition.patterns: expected a List of String');
        }
      }
      patternsValue = patternsRaw.cast<String>();
    }
    final hasLocation = raw.containsKey('location');
    final locationRaw = raw['location'];
    LabelFieldLocation? locationValue;
    if (hasLocation && locationRaw != null) {
      locationValue = LabelFieldLocation.fromJson(locationRaw);
    } else if (hasLocation && locationRaw == null) {
      throw FormatException('CustomTextLabelFieldDefinition.location: null is not allowed');
    }
    return CustomTextLabelFieldDefinition(
      name: nameValue!,
      number_of_mandatory_instances: number_of_mandatory_instancesValue,
      fieldType: fieldTypeValue!,
      optional: optionalValue,
      dataTypePatterns: dataTypePatternsValue,
      patterns: patternsValue,
      location: locationValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['name'] = name;
    if (number_of_mandatory_instances != null) {
      map['number_of_mandatory_instances'] = number_of_mandatory_instances;
    }
    map['fieldType'] = fieldType;
    if (optional != null) {
      map['optional'] = optional;
    }
    if (dataTypePatterns != null) {
      map['dataTypePatterns'] = dataTypePatterns;
    }
    if (patterns != null) {
      map['patterns'] = patterns;
    }
    if (location != null) {
      map['location'] = location!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `CustomTextLabelFieldDefinition` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildCustomTextLabelFieldDefinition({
  required String name,
  Object? number_of_mandatory_instances = _unset,
  required String fieldType,
  bool? optional,
  Object? dataTypePatterns = _unset,
  Object? patterns = _unset,
  Object? location,
}) {
  final map = <String, Object?>{};
  map['name'] = name;
  if (!identical(number_of_mandatory_instances, _unset)) {
    map['number_of_mandatory_instances'] = number_of_mandatory_instances;
  }
  map['fieldType'] = fieldType;
  if (optional != null) {
    map['optional'] = optional;
  }
  if (!identical(dataTypePatterns, _unset)) {
    map['dataTypePatterns'] = dataTypePatterns;
  }
  if (!identical(patterns, _unset)) {
    map['patterns'] = patterns;
  }
  if (location != null) {
    map['location'] = location;
  }
  return map;
}

/// Label field definition for a generic date text field.
class DateTextFieldDefinition implements LabelFieldDefinition {
  final String name;
  final int? number_of_mandatory_instances;
  final LabelDateFormat? labelDateFormat;
  final String fieldType;
  final bool? optional;
  final List<String>? dataTypePatterns;
  final List<String>? patterns;

  const DateTextFieldDefinition({
    required this.name,
    this.number_of_mandatory_instances,
    this.labelDateFormat,
    required this.fieldType,
    this.optional,
    this.dataTypePatterns,
    this.patterns,
  });

  factory DateTextFieldDefinition.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('DateTextFieldDefinition: expected a Map');
    }
    const allowedKeys = <String>{
      'name',
      'number_of_mandatory_instances',
      'labelDateFormat',
      'fieldType',
      'optional',
      'dataTypePatterns',
      'patterns',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("DateTextFieldDefinition: unknown property '$key'");
      }
    }
    final hasName = raw.containsKey('name');
    if (!hasName) {
      throw FormatException("DateTextFieldDefinition.name: missing required property");
    }
    final nameRaw = raw['name'];
    String? nameValue;
    if (hasName && nameRaw != null) {
      if (nameRaw is! String) {
        throw FormatException('DateTextFieldDefinition.name: expected a String');
      }
      nameValue = nameRaw;
    } else if (hasName && nameRaw == null) {
      throw FormatException('DateTextFieldDefinition.name: null is not allowed');
    }
    final hasNumber_of_mandatory_instances = raw.containsKey('number_of_mandatory_instances');
    final number_of_mandatory_instancesRaw = raw['number_of_mandatory_instances'];
    int? number_of_mandatory_instancesValue;
    if (hasNumber_of_mandatory_instances && number_of_mandatory_instancesRaw != null) {
      if (number_of_mandatory_instancesRaw is! num) {
        throw FormatException('DateTextFieldDefinition.number_of_mandatory_instances: expected a number');
      }
      if (number_of_mandatory_instancesRaw != number_of_mandatory_instancesRaw.toInt()) {
        throw FormatException('DateTextFieldDefinition.number_of_mandatory_instances: expected an integer');
      }
      number_of_mandatory_instancesValue = number_of_mandatory_instancesRaw.toInt();
    }
    final hasLabelDateFormat = raw.containsKey('labelDateFormat');
    final labelDateFormatRaw = raw['labelDateFormat'];
    LabelDateFormat? labelDateFormatValue;
    if (hasLabelDateFormat && labelDateFormatRaw != null) {
      labelDateFormatValue = LabelDateFormat.fromJson(labelDateFormatRaw);
    } else if (hasLabelDateFormat && labelDateFormatRaw == null) {
      throw FormatException('DateTextFieldDefinition.labelDateFormat: null is not allowed');
    }
    final hasFieldType = raw.containsKey('fieldType');
    if (!hasFieldType) {
      throw FormatException("DateTextFieldDefinition.fieldType: missing required property");
    }
    final fieldTypeRaw = raw['fieldType'];
    String? fieldTypeValue;
    if (hasFieldType && fieldTypeRaw != null) {
      if (fieldTypeRaw is! String || !const <String>['dateText'].contains(fieldTypeRaw)) {
        throw FormatException("DateTextFieldDefinition.fieldType: unknown enum value '$fieldTypeRaw'");
      }
      fieldTypeValue = fieldTypeRaw;
    } else if (hasFieldType && fieldTypeRaw == null) {
      throw FormatException('DateTextFieldDefinition.fieldType: null is not allowed');
    }
    final hasOptional = raw.containsKey('optional');
    final optionalRaw = raw['optional'];
    bool? optionalValue;
    if (hasOptional && optionalRaw != null) {
      if (optionalRaw is! bool) {
        throw FormatException('DateTextFieldDefinition.optional: expected a bool');
      }
      optionalValue = optionalRaw;
    } else if (hasOptional && optionalRaw == null) {
      throw FormatException('DateTextFieldDefinition.optional: null is not allowed');
    }
    final hasDataTypePatterns = raw.containsKey('dataTypePatterns');
    final dataTypePatternsRaw = raw['dataTypePatterns'];
    List<String>? dataTypePatternsValue;
    if (hasDataTypePatterns && dataTypePatternsRaw != null) {
      if (dataTypePatternsRaw is! List) {
        throw FormatException('DateTextFieldDefinition.dataTypePatterns: expected a List');
      }
      for (final item in dataTypePatternsRaw) {
        if (item is! String) {
          throw FormatException('DateTextFieldDefinition.dataTypePatterns: expected a List of String');
        }
      }
      dataTypePatternsValue = dataTypePatternsRaw.cast<String>();
    }
    final hasPatterns = raw.containsKey('patterns');
    final patternsRaw = raw['patterns'];
    List<String>? patternsValue;
    if (hasPatterns && patternsRaw != null) {
      if (patternsRaw is! List) {
        throw FormatException('DateTextFieldDefinition.patterns: expected a List');
      }
      for (final item in patternsRaw) {
        if (item is! String) {
          throw FormatException('DateTextFieldDefinition.patterns: expected a List of String');
        }
      }
      patternsValue = patternsRaw.cast<String>();
    }
    return DateTextFieldDefinition(
      name: nameValue!,
      number_of_mandatory_instances: number_of_mandatory_instancesValue,
      labelDateFormat: labelDateFormatValue,
      fieldType: fieldTypeValue!,
      optional: optionalValue,
      dataTypePatterns: dataTypePatternsValue,
      patterns: patternsValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['name'] = name;
    if (number_of_mandatory_instances != null) {
      map['number_of_mandatory_instances'] = number_of_mandatory_instances;
    }
    if (labelDateFormat != null) {
      map['labelDateFormat'] = labelDateFormat!.toJson();
    }
    map['fieldType'] = fieldType;
    if (optional != null) {
      map['optional'] = optional;
    }
    if (dataTypePatterns != null) {
      map['dataTypePatterns'] = dataTypePatterns;
    }
    if (patterns != null) {
      map['patterns'] = patterns;
    }
    return map;
  }
}

/// Typed builder for the `DateTextFieldDefinition` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildDateTextFieldDefinition({
  required String name,
  Object? number_of_mandatory_instances = _unset,
  Object? labelDateFormat,
  required String fieldType,
  bool? optional,
  Object? dataTypePatterns = _unset,
  Object? patterns = _unset,
}) {
  final map = <String, Object?>{};
  map['name'] = name;
  if (!identical(number_of_mandatory_instances, _unset)) {
    map['number_of_mandatory_instances'] = number_of_mandatory_instances;
  }
  if (labelDateFormat != null) {
    map['labelDateFormat'] = labelDateFormat;
  }
  map['fieldType'] = fieldType;
  if (optional != null) {
    map['optional'] = optional;
  }
  if (!identical(dataTypePatterns, _unset)) {
    map['dataTypePatterns'] = dataTypePatterns;
  }
  if (!identical(patterns, _unset)) {
    map['patterns'] = patterns;
  }
  return map;
}

/// Feedback configuration for label capture events.
class LabelCaptureFeedback {
  final Feedback? success;

  const LabelCaptureFeedback({
    this.success,
  });

  factory LabelCaptureFeedback.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LabelCaptureFeedback: expected a Map');
    }
    const allowedKeys = <String>{
      'success',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("LabelCaptureFeedback: unknown property '$key'");
      }
    }
    final hasSuccess = raw.containsKey('success');
    final successRaw = raw['success'];
    Feedback? successValue;
    if (hasSuccess && successRaw != null) {
      successValue = Feedback.fromJson(successRaw);
    } else if (hasSuccess && successRaw == null) {
      throw FormatException('LabelCaptureFeedback.success: null is not allowed');
    }
    return LabelCaptureFeedback(
      success: successValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (success != null) {
      map['success'] = success!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `LabelCaptureFeedback` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildLabelCaptureFeedback({
  Object? success,
}) {
  final map = <String, Object?>{};
  if (success != null) {
    map['success'] = success;
  }
  return map;
}

/// The ID capture mode.
class IdCapture implements Mode {
  final String type;
  final IdCaptureSettings? settings;
  final bool? enabled;
  final IdCaptureFeedback? feedback;
  final String? externalTransactionId;
  final int? modeId;
  final int? parentId;
  final bool? hasListeners;

  const IdCapture({
    required this.type,
    this.settings,
    this.enabled,
    this.feedback,
    this.externalTransactionId,
    this.modeId,
    this.parentId,
    this.hasListeners,
  });

  factory IdCapture.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('IdCapture: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'settings',
      'enabled',
      'feedback',
      'externalTransactionId',
      'modeId',
      'parentId',
      'hasListeners',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("IdCapture: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("IdCapture.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['idCapture'].contains(typeRaw)) {
        throw FormatException("IdCapture.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('IdCapture.type: null is not allowed');
    }
    final hasSettings = raw.containsKey('settings');
    final settingsRaw = raw['settings'];
    IdCaptureSettings? settingsValue;
    if (hasSettings && settingsRaw != null) {
      settingsValue = IdCaptureSettings.fromJson(settingsRaw);
    } else if (hasSettings && settingsRaw == null) {
      throw FormatException('IdCapture.settings: null is not allowed');
    }
    final hasEnabled = raw.containsKey('enabled');
    final enabledRaw = raw['enabled'];
    bool? enabledValue;
    if (hasEnabled && enabledRaw != null) {
      if (enabledRaw is! bool) {
        throw FormatException('IdCapture.enabled: expected a bool');
      }
      enabledValue = enabledRaw;
    } else if (hasEnabled && enabledRaw == null) {
      throw FormatException('IdCapture.enabled: null is not allowed');
    }
    final hasFeedback = raw.containsKey('feedback');
    final feedbackRaw = raw['feedback'];
    IdCaptureFeedback? feedbackValue;
    if (hasFeedback && feedbackRaw != null) {
      feedbackValue = IdCaptureFeedback.fromJson(feedbackRaw);
    } else if (hasFeedback && feedbackRaw == null) {
      throw FormatException('IdCapture.feedback: null is not allowed');
    }
    final hasExternalTransactionId = raw.containsKey('externalTransactionId');
    final externalTransactionIdRaw = raw['externalTransactionId'];
    String? externalTransactionIdValue;
    if (hasExternalTransactionId && externalTransactionIdRaw != null) {
      if (externalTransactionIdRaw is! String) {
        throw FormatException('IdCapture.externalTransactionId: expected a String');
      }
      externalTransactionIdValue = externalTransactionIdRaw;
    }
    final hasModeId = raw.containsKey('modeId');
    final modeIdRaw = raw['modeId'];
    int? modeIdValue;
    if (hasModeId && modeIdRaw != null) {
      if (modeIdRaw is! num) {
        throw FormatException('IdCapture.modeId: expected a number');
      }
      if (modeIdRaw != modeIdRaw.toInt()) {
        throw FormatException('IdCapture.modeId: expected an integer');
      }
      modeIdValue = modeIdRaw.toInt();
    } else if (hasModeId && modeIdRaw == null) {
      throw FormatException('IdCapture.modeId: null is not allowed');
    }
    final hasParentId = raw.containsKey('parentId');
    final parentIdRaw = raw['parentId'];
    int? parentIdValue;
    if (hasParentId && parentIdRaw != null) {
      if (parentIdRaw is! num) {
        throw FormatException('IdCapture.parentId: expected a number');
      }
      if (parentIdRaw != parentIdRaw.toInt()) {
        throw FormatException('IdCapture.parentId: expected an integer');
      }
      parentIdValue = parentIdRaw.toInt();
    }
    final hasHasListeners = raw.containsKey('hasListeners');
    final hasListenersRaw = raw['hasListeners'];
    bool? hasListenersValue;
    if (hasHasListeners && hasListenersRaw != null) {
      if (hasListenersRaw is! bool) {
        throw FormatException('IdCapture.hasListeners: expected a bool');
      }
      hasListenersValue = hasListenersRaw;
    } else if (hasHasListeners && hasListenersRaw == null) {
      throw FormatException('IdCapture.hasListeners: null is not allowed');
    }
    return IdCapture(
      type: typeValue!,
      settings: settingsValue,
      enabled: enabledValue,
      feedback: feedbackValue,
      externalTransactionId: externalTransactionIdValue,
      modeId: modeIdValue,
      parentId: parentIdValue,
      hasListeners: hasListenersValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (settings != null) {
      map['settings'] = settings!.toJson();
    }
    if (enabled != null) {
      map['enabled'] = enabled;
    }
    if (feedback != null) {
      map['feedback'] = feedback!.toJson();
    }
    if (externalTransactionId != null) {
      map['externalTransactionId'] = externalTransactionId;
    }
    if (modeId != null) {
      map['modeId'] = modeId;
    }
    if (parentId != null) {
      map['parentId'] = parentId;
    }
    if (hasListeners != null) {
      map['hasListeners'] = hasListeners;
    }
    return map;
  }
}

/// Typed builder for the `IdCapture` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildIdCapture({
  required String type,
  Object? settings,
  bool? enabled,
  Object? feedback,
  Object? externalTransactionId = _unset,
  int? modeId,
  Object? parentId = _unset,
  bool? hasListeners,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (settings != null) {
    map['settings'] = settings;
  }
  if (enabled != null) {
    map['enabled'] = enabled;
  }
  if (feedback != null) {
    map['feedback'] = feedback;
  }
  if (!identical(externalTransactionId, _unset)) {
    map['externalTransactionId'] = externalTransactionId;
  }
  if (modeId != null) {
    map['modeId'] = modeId;
  }
  if (!identical(parentId, _unset)) {
    map['parentId'] = parentId;
  }
  if (hasListeners != null) {
    map['hasListeners'] = hasListeners;
  }
  return map;
}

/// Settings for the ID capture mode.
class IdCaptureSettings {
  final ImageToResultSettings? imageToResult;
  final String? anonymizationMode;
  final bool? rejectVoidedIds;
  final bool? rejectExpiredIds;
  final bool? rejectForgedAamvaBarcodes;
  final bool? rejectNotRealIdCompliant;
  final bool? rejectInconsistentData;
  final int? rejectHolderBelowAge;
  final List<String>? rejectPassportTypes;
  final Duration? rejectIdsExpiringIn;
  final bool? decodeBackOfEuropeanDrivingLicense;
  final List<Document>? acceptedDocuments;
  final List<Document>? rejectedDocuments;
  final bool? notifyOnSideCapture;
  final ScannerType? scanner;
  final int? rejectionTimeoutSeconds;
  final String? captureTrigger;
  final Object? anonymizationMap;
  final bool? anonymizeDefaultFields;

  const IdCaptureSettings({
    this.imageToResult,
    this.anonymizationMode,
    this.rejectVoidedIds,
    this.rejectExpiredIds,
    this.rejectForgedAamvaBarcodes,
    this.rejectNotRealIdCompliant,
    this.rejectInconsistentData,
    this.rejectHolderBelowAge,
    this.rejectPassportTypes,
    this.rejectIdsExpiringIn,
    this.decodeBackOfEuropeanDrivingLicense,
    this.acceptedDocuments,
    this.rejectedDocuments,
    this.notifyOnSideCapture,
    this.scanner,
    this.rejectionTimeoutSeconds,
    this.captureTrigger,
    this.anonymizationMap,
    this.anonymizeDefaultFields,
  });

  factory IdCaptureSettings.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('IdCaptureSettings: expected a Map');
    }
    const allowedKeys = <String>{
      'licenseKey',
      'licensee',
      'imageToResult',
      'anonymizationMode',
      'rejectVoidedIds',
      'rejectExpiredIds',
      'rejectForgedAamvaBarcodes',
      'rejectNotRealIdCompliant',
      'rejectInconsistentData',
      'rejectHolderBelowAge',
      'rejectPassportTypes',
      'rejectIdsExpiringIn',
      'decodeBackOfEuropeanDrivingLicense',
      'acceptedDocuments',
      'rejectedDocuments',
      'notifyOnSideCapture',
      'scanner',
      'rejectionTimeoutSeconds',
      'captureTrigger',
      'anonymizationMap',
      'anonymizeDefaultFields',
      'properties',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("IdCaptureSettings: unknown property '$key'");
      }
    }
    final hasImageToResult = raw.containsKey('imageToResult');
    final imageToResultRaw = raw['imageToResult'];
    ImageToResultSettings? imageToResultValue;
    if (hasImageToResult && imageToResultRaw != null) {
      imageToResultValue = ImageToResultSettings.fromJson(imageToResultRaw);
    } else if (hasImageToResult && imageToResultRaw == null) {
      throw FormatException('IdCaptureSettings.imageToResult: null is not allowed');
    }
    final hasAnonymizationMode = raw.containsKey('anonymizationMode');
    final anonymizationModeRaw = raw['anonymizationMode'];
    String? anonymizationModeValue;
    if (hasAnonymizationMode && anonymizationModeRaw != null) {
      if (anonymizationModeRaw is! String ||
          !const <String>['none', 'fieldsOnly', 'imagesOnly', 'fieldsAndImages'].contains(anonymizationModeRaw)) {
        throw FormatException("IdCaptureSettings.anonymizationMode: unknown enum value '$anonymizationModeRaw'");
      }
      anonymizationModeValue = anonymizationModeRaw;
    } else if (hasAnonymizationMode && anonymizationModeRaw == null) {
      throw FormatException('IdCaptureSettings.anonymizationMode: null is not allowed');
    }
    final hasRejectVoidedIds = raw.containsKey('rejectVoidedIds');
    final rejectVoidedIdsRaw = raw['rejectVoidedIds'];
    bool? rejectVoidedIdsValue;
    if (hasRejectVoidedIds && rejectVoidedIdsRaw != null) {
      if (rejectVoidedIdsRaw is! bool) {
        throw FormatException('IdCaptureSettings.rejectVoidedIds: expected a bool');
      }
      rejectVoidedIdsValue = rejectVoidedIdsRaw;
    } else if (hasRejectVoidedIds && rejectVoidedIdsRaw == null) {
      throw FormatException('IdCaptureSettings.rejectVoidedIds: null is not allowed');
    }
    final hasRejectExpiredIds = raw.containsKey('rejectExpiredIds');
    final rejectExpiredIdsRaw = raw['rejectExpiredIds'];
    bool? rejectExpiredIdsValue;
    if (hasRejectExpiredIds && rejectExpiredIdsRaw != null) {
      if (rejectExpiredIdsRaw is! bool) {
        throw FormatException('IdCaptureSettings.rejectExpiredIds: expected a bool');
      }
      rejectExpiredIdsValue = rejectExpiredIdsRaw;
    } else if (hasRejectExpiredIds && rejectExpiredIdsRaw == null) {
      throw FormatException('IdCaptureSettings.rejectExpiredIds: null is not allowed');
    }
    final hasRejectForgedAamvaBarcodes = raw.containsKey('rejectForgedAamvaBarcodes');
    final rejectForgedAamvaBarcodesRaw = raw['rejectForgedAamvaBarcodes'];
    bool? rejectForgedAamvaBarcodesValue;
    if (hasRejectForgedAamvaBarcodes && rejectForgedAamvaBarcodesRaw != null) {
      if (rejectForgedAamvaBarcodesRaw is! bool) {
        throw FormatException('IdCaptureSettings.rejectForgedAamvaBarcodes: expected a bool');
      }
      rejectForgedAamvaBarcodesValue = rejectForgedAamvaBarcodesRaw;
    } else if (hasRejectForgedAamvaBarcodes && rejectForgedAamvaBarcodesRaw == null) {
      throw FormatException('IdCaptureSettings.rejectForgedAamvaBarcodes: null is not allowed');
    }
    final hasRejectNotRealIdCompliant = raw.containsKey('rejectNotRealIdCompliant');
    final rejectNotRealIdCompliantRaw = raw['rejectNotRealIdCompliant'];
    bool? rejectNotRealIdCompliantValue;
    if (hasRejectNotRealIdCompliant && rejectNotRealIdCompliantRaw != null) {
      if (rejectNotRealIdCompliantRaw is! bool) {
        throw FormatException('IdCaptureSettings.rejectNotRealIdCompliant: expected a bool');
      }
      rejectNotRealIdCompliantValue = rejectNotRealIdCompliantRaw;
    } else if (hasRejectNotRealIdCompliant && rejectNotRealIdCompliantRaw == null) {
      throw FormatException('IdCaptureSettings.rejectNotRealIdCompliant: null is not allowed');
    }
    final hasRejectInconsistentData = raw.containsKey('rejectInconsistentData');
    final rejectInconsistentDataRaw = raw['rejectInconsistentData'];
    bool? rejectInconsistentDataValue;
    if (hasRejectInconsistentData && rejectInconsistentDataRaw != null) {
      if (rejectInconsistentDataRaw is! bool) {
        throw FormatException('IdCaptureSettings.rejectInconsistentData: expected a bool');
      }
      rejectInconsistentDataValue = rejectInconsistentDataRaw;
    } else if (hasRejectInconsistentData && rejectInconsistentDataRaw == null) {
      throw FormatException('IdCaptureSettings.rejectInconsistentData: null is not allowed');
    }
    final hasRejectHolderBelowAge = raw.containsKey('rejectHolderBelowAge');
    final rejectHolderBelowAgeRaw = raw['rejectHolderBelowAge'];
    int? rejectHolderBelowAgeValue;
    if (hasRejectHolderBelowAge && rejectHolderBelowAgeRaw != null) {
      if (rejectHolderBelowAgeRaw is! num) {
        throw FormatException('IdCaptureSettings.rejectHolderBelowAge: expected a number');
      }
      if (rejectHolderBelowAgeRaw != rejectHolderBelowAgeRaw.toInt()) {
        throw FormatException('IdCaptureSettings.rejectHolderBelowAge: expected an integer');
      }
      rejectHolderBelowAgeValue = rejectHolderBelowAgeRaw.toInt();
    }
    final hasRejectPassportTypes = raw.containsKey('rejectPassportTypes');
    final rejectPassportTypesRaw = raw['rejectPassportTypes'];
    List<String>? rejectPassportTypesValue;
    if (hasRejectPassportTypes && rejectPassportTypesRaw != null) {
      if (rejectPassportTypesRaw is! List) {
        throw FormatException('IdCaptureSettings.rejectPassportTypes: expected a List');
      }
      for (final item in rejectPassportTypesRaw) {
        if (item is! String ||
            !const <String>[
              'national',
              'emergency',
              'diplomatic',
              'official',
              'refugee',
              'alien',
              'stateless',
              'laissezPasser',
              'military',
              'seafarer',
              'emergencyTravelDocument',
              'unknown'
            ].contains(item)) {
          throw FormatException("IdCaptureSettings.rejectPassportTypes: unknown enum value '$item'");
        }
      }
      rejectPassportTypesValue = rejectPassportTypesRaw.cast<String>();
    } else if (hasRejectPassportTypes && rejectPassportTypesRaw == null) {
      throw FormatException('IdCaptureSettings.rejectPassportTypes: null is not allowed');
    }
    final hasRejectIdsExpiringIn = raw.containsKey('rejectIdsExpiringIn');
    final rejectIdsExpiringInRaw = raw['rejectIdsExpiringIn'];
    Duration? rejectIdsExpiringInValue;
    if (hasRejectIdsExpiringIn && rejectIdsExpiringInRaw != null) {
      rejectIdsExpiringInValue = Duration.fromJson(rejectIdsExpiringInRaw);
    }
    final hasDecodeBackOfEuropeanDrivingLicense = raw.containsKey('decodeBackOfEuropeanDrivingLicense');
    final decodeBackOfEuropeanDrivingLicenseRaw = raw['decodeBackOfEuropeanDrivingLicense'];
    bool? decodeBackOfEuropeanDrivingLicenseValue;
    if (hasDecodeBackOfEuropeanDrivingLicense && decodeBackOfEuropeanDrivingLicenseRaw != null) {
      if (decodeBackOfEuropeanDrivingLicenseRaw is! bool) {
        throw FormatException('IdCaptureSettings.decodeBackOfEuropeanDrivingLicense: expected a bool');
      }
      decodeBackOfEuropeanDrivingLicenseValue = decodeBackOfEuropeanDrivingLicenseRaw;
    } else if (hasDecodeBackOfEuropeanDrivingLicense && decodeBackOfEuropeanDrivingLicenseRaw == null) {
      throw FormatException('IdCaptureSettings.decodeBackOfEuropeanDrivingLicense: null is not allowed');
    }
    final hasAcceptedDocuments = raw.containsKey('acceptedDocuments');
    final acceptedDocumentsRaw = raw['acceptedDocuments'];
    List<Document>? acceptedDocumentsValue;
    if (hasAcceptedDocuments && acceptedDocumentsRaw != null) {
      if (acceptedDocumentsRaw is! List) {
        throw FormatException('IdCaptureSettings.acceptedDocuments: expected a List');
      }
      acceptedDocumentsValue = acceptedDocumentsRaw.map((item) => Document.fromJson(item)).toList();
    } else if (hasAcceptedDocuments && acceptedDocumentsRaw == null) {
      throw FormatException('IdCaptureSettings.acceptedDocuments: null is not allowed');
    }
    final hasRejectedDocuments = raw.containsKey('rejectedDocuments');
    final rejectedDocumentsRaw = raw['rejectedDocuments'];
    List<Document>? rejectedDocumentsValue;
    if (hasRejectedDocuments && rejectedDocumentsRaw != null) {
      if (rejectedDocumentsRaw is! List) {
        throw FormatException('IdCaptureSettings.rejectedDocuments: expected a List');
      }
      rejectedDocumentsValue = rejectedDocumentsRaw.map((item) => Document.fromJson(item)).toList();
    } else if (hasRejectedDocuments && rejectedDocumentsRaw == null) {
      throw FormatException('IdCaptureSettings.rejectedDocuments: null is not allowed');
    }
    final hasNotifyOnSideCapture = raw.containsKey('notifyOnSideCapture');
    final notifyOnSideCaptureRaw = raw['notifyOnSideCapture'];
    bool? notifyOnSideCaptureValue;
    if (hasNotifyOnSideCapture && notifyOnSideCaptureRaw != null) {
      if (notifyOnSideCaptureRaw is! bool) {
        throw FormatException('IdCaptureSettings.notifyOnSideCapture: expected a bool');
      }
      notifyOnSideCaptureValue = notifyOnSideCaptureRaw;
    } else if (hasNotifyOnSideCapture && notifyOnSideCaptureRaw == null) {
      throw FormatException('IdCaptureSettings.notifyOnSideCapture: null is not allowed');
    }
    final hasScanner = raw.containsKey('scanner');
    final scannerRaw = raw['scanner'];
    ScannerType? scannerValue;
    if (hasScanner && scannerRaw != null) {
      scannerValue = ScannerType.fromJson(scannerRaw);
    } else if (hasScanner && scannerRaw == null) {
      throw FormatException('IdCaptureSettings.scanner: null is not allowed');
    }
    final hasRejectionTimeoutSeconds = raw.containsKey('rejectionTimeoutSeconds');
    final rejectionTimeoutSecondsRaw = raw['rejectionTimeoutSeconds'];
    int? rejectionTimeoutSecondsValue;
    if (hasRejectionTimeoutSeconds && rejectionTimeoutSecondsRaw != null) {
      if (rejectionTimeoutSecondsRaw is! num) {
        throw FormatException('IdCaptureSettings.rejectionTimeoutSeconds: expected a number');
      }
      if (rejectionTimeoutSecondsRaw != rejectionTimeoutSecondsRaw.toInt()) {
        throw FormatException('IdCaptureSettings.rejectionTimeoutSeconds: expected an integer');
      }
      rejectionTimeoutSecondsValue = rejectionTimeoutSecondsRaw.toInt();
    } else if (hasRejectionTimeoutSeconds && rejectionTimeoutSecondsRaw == null) {
      throw FormatException('IdCaptureSettings.rejectionTimeoutSeconds: null is not allowed');
    }
    final hasCaptureTrigger = raw.containsKey('captureTrigger');
    final captureTriggerRaw = raw['captureTrigger'];
    String? captureTriggerValue;
    if (hasCaptureTrigger && captureTriggerRaw != null) {
      if (captureTriggerRaw is! String || !const <String>['auto', 'buttonTap'].contains(captureTriggerRaw)) {
        throw FormatException("IdCaptureSettings.captureTrigger: unknown enum value '$captureTriggerRaw'");
      }
      captureTriggerValue = captureTriggerRaw;
    } else if (hasCaptureTrigger && captureTriggerRaw == null) {
      throw FormatException('IdCaptureSettings.captureTrigger: null is not allowed');
    }
    final hasAnonymizationMap = raw.containsKey('anonymizationMap');
    final anonymizationMapRaw = raw['anonymizationMap'];
    Object? anonymizationMapValue;
    if (hasAnonymizationMap && anonymizationMapRaw != null) {
      anonymizationMapValue = anonymizationMapRaw;
    } else if (hasAnonymizationMap && anonymizationMapRaw == null) {
      throw FormatException('IdCaptureSettings.anonymizationMap: null is not allowed');
    }
    final hasAnonymizeDefaultFields = raw.containsKey('anonymizeDefaultFields');
    final anonymizeDefaultFieldsRaw = raw['anonymizeDefaultFields'];
    bool? anonymizeDefaultFieldsValue;
    if (hasAnonymizeDefaultFields && anonymizeDefaultFieldsRaw != null) {
      if (anonymizeDefaultFieldsRaw is! bool) {
        throw FormatException('IdCaptureSettings.anonymizeDefaultFields: expected a bool');
      }
      anonymizeDefaultFieldsValue = anonymizeDefaultFieldsRaw;
    } else if (hasAnonymizeDefaultFields && anonymizeDefaultFieldsRaw == null) {
      throw FormatException('IdCaptureSettings.anonymizeDefaultFields: null is not allowed');
    }
    return IdCaptureSettings(
      imageToResult: imageToResultValue,
      anonymizationMode: anonymizationModeValue,
      rejectVoidedIds: rejectVoidedIdsValue,
      rejectExpiredIds: rejectExpiredIdsValue,
      rejectForgedAamvaBarcodes: rejectForgedAamvaBarcodesValue,
      rejectNotRealIdCompliant: rejectNotRealIdCompliantValue,
      rejectInconsistentData: rejectInconsistentDataValue,
      rejectHolderBelowAge: rejectHolderBelowAgeValue,
      rejectPassportTypes: rejectPassportTypesValue,
      rejectIdsExpiringIn: rejectIdsExpiringInValue,
      decodeBackOfEuropeanDrivingLicense: decodeBackOfEuropeanDrivingLicenseValue,
      acceptedDocuments: acceptedDocumentsValue,
      rejectedDocuments: rejectedDocumentsValue,
      notifyOnSideCapture: notifyOnSideCaptureValue,
      scanner: scannerValue,
      rejectionTimeoutSeconds: rejectionTimeoutSecondsValue,
      captureTrigger: captureTriggerValue,
      anonymizationMap: anonymizationMapValue,
      anonymizeDefaultFields: anonymizeDefaultFieldsValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (imageToResult != null) {
      map['imageToResult'] = imageToResult!.toJson();
    }
    if (anonymizationMode != null) {
      map['anonymizationMode'] = anonymizationMode;
    }
    if (rejectVoidedIds != null) {
      map['rejectVoidedIds'] = rejectVoidedIds;
    }
    if (rejectExpiredIds != null) {
      map['rejectExpiredIds'] = rejectExpiredIds;
    }
    if (rejectForgedAamvaBarcodes != null) {
      map['rejectForgedAamvaBarcodes'] = rejectForgedAamvaBarcodes;
    }
    if (rejectNotRealIdCompliant != null) {
      map['rejectNotRealIdCompliant'] = rejectNotRealIdCompliant;
    }
    if (rejectInconsistentData != null) {
      map['rejectInconsistentData'] = rejectInconsistentData;
    }
    if (rejectHolderBelowAge != null) {
      map['rejectHolderBelowAge'] = rejectHolderBelowAge;
    }
    if (rejectPassportTypes != null) {
      map['rejectPassportTypes'] = rejectPassportTypes;
    }
    if (rejectIdsExpiringIn != null) {
      map['rejectIdsExpiringIn'] = rejectIdsExpiringIn!.toJson();
    }
    if (decodeBackOfEuropeanDrivingLicense != null) {
      map['decodeBackOfEuropeanDrivingLicense'] = decodeBackOfEuropeanDrivingLicense;
    }
    if (acceptedDocuments != null) {
      map['acceptedDocuments'] = acceptedDocuments!.map((item) => item.toJson()).toList();
    }
    if (rejectedDocuments != null) {
      map['rejectedDocuments'] = rejectedDocuments!.map((item) => item.toJson()).toList();
    }
    if (notifyOnSideCapture != null) {
      map['notifyOnSideCapture'] = notifyOnSideCapture;
    }
    if (scanner != null) {
      map['scanner'] = scanner!.toJson();
    }
    if (rejectionTimeoutSeconds != null) {
      map['rejectionTimeoutSeconds'] = rejectionTimeoutSeconds;
    }
    if (captureTrigger != null) {
      map['captureTrigger'] = captureTrigger;
    }
    if (anonymizationMap != null) {
      map['anonymizationMap'] = anonymizationMap;
    }
    if (anonymizeDefaultFields != null) {
      map['anonymizeDefaultFields'] = anonymizeDefaultFields;
    }
    return map;
  }
}

/// Typed builder for the `IdCaptureSettings` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildIdCaptureSettings({
  Object? imageToResult,
  String? anonymizationMode,
  bool? rejectVoidedIds,
  bool? rejectExpiredIds,
  bool? rejectForgedAamvaBarcodes,
  bool? rejectNotRealIdCompliant,
  bool? rejectInconsistentData,
  Object? rejectHolderBelowAge = _unset,
  List<String>? rejectPassportTypes,
  Object? rejectIdsExpiringIn = _unset,
  bool? decodeBackOfEuropeanDrivingLicense,
  List<Object?>? acceptedDocuments,
  List<Object?>? rejectedDocuments,
  bool? notifyOnSideCapture,
  Object? scanner,
  int? rejectionTimeoutSeconds,
  String? captureTrigger,
  Object? anonymizationMap,
  bool? anonymizeDefaultFields,
}) {
  final map = <String, Object?>{};
  if (imageToResult != null) {
    map['imageToResult'] = imageToResult;
  }
  if (anonymizationMode != null) {
    map['anonymizationMode'] = anonymizationMode;
  }
  if (rejectVoidedIds != null) {
    map['rejectVoidedIds'] = rejectVoidedIds;
  }
  if (rejectExpiredIds != null) {
    map['rejectExpiredIds'] = rejectExpiredIds;
  }
  if (rejectForgedAamvaBarcodes != null) {
    map['rejectForgedAamvaBarcodes'] = rejectForgedAamvaBarcodes;
  }
  if (rejectNotRealIdCompliant != null) {
    map['rejectNotRealIdCompliant'] = rejectNotRealIdCompliant;
  }
  if (rejectInconsistentData != null) {
    map['rejectInconsistentData'] = rejectInconsistentData;
  }
  if (!identical(rejectHolderBelowAge, _unset)) {
    map['rejectHolderBelowAge'] = rejectHolderBelowAge;
  }
  if (rejectPassportTypes != null) {
    map['rejectPassportTypes'] = rejectPassportTypes;
  }
  if (!identical(rejectIdsExpiringIn, _unset)) {
    map['rejectIdsExpiringIn'] = rejectIdsExpiringIn;
  }
  if (decodeBackOfEuropeanDrivingLicense != null) {
    map['decodeBackOfEuropeanDrivingLicense'] = decodeBackOfEuropeanDrivingLicense;
  }
  if (acceptedDocuments != null) {
    map['acceptedDocuments'] = acceptedDocuments;
  }
  if (rejectedDocuments != null) {
    map['rejectedDocuments'] = rejectedDocuments;
  }
  if (notifyOnSideCapture != null) {
    map['notifyOnSideCapture'] = notifyOnSideCapture;
  }
  if (scanner != null) {
    map['scanner'] = scanner;
  }
  if (rejectionTimeoutSeconds != null) {
    map['rejectionTimeoutSeconds'] = rejectionTimeoutSeconds;
  }
  if (captureTrigger != null) {
    map['captureTrigger'] = captureTrigger;
  }
  if (anonymizationMap != null) {
    map['anonymizationMap'] = anonymizationMap;
  }
  if (anonymizeDefaultFields != null) {
    map['anonymizeDefaultFields'] = anonymizeDefaultFields;
  }
  return map;
}

/// Settings controlling which images are included in the captured ID result.
class ImageToResultSettings {
  final bool? face;
  final bool? croppedDocument;
  final bool? frame;

  const ImageToResultSettings({
    this.face,
    this.croppedDocument,
    this.frame,
  });

  factory ImageToResultSettings.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('ImageToResultSettings: expected a Map');
    }
    const allowedKeys = <String>{
      'face',
      'croppedDocument',
      'frame',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("ImageToResultSettings: unknown property '$key'");
      }
    }
    final hasFace = raw.containsKey('face');
    final faceRaw = raw['face'];
    bool? faceValue;
    if (hasFace && faceRaw != null) {
      if (faceRaw is! bool) {
        throw FormatException('ImageToResultSettings.face: expected a bool');
      }
      faceValue = faceRaw;
    } else if (hasFace && faceRaw == null) {
      throw FormatException('ImageToResultSettings.face: null is not allowed');
    }
    final hasCroppedDocument = raw.containsKey('croppedDocument');
    final croppedDocumentRaw = raw['croppedDocument'];
    bool? croppedDocumentValue;
    if (hasCroppedDocument && croppedDocumentRaw != null) {
      if (croppedDocumentRaw is! bool) {
        throw FormatException('ImageToResultSettings.croppedDocument: expected a bool');
      }
      croppedDocumentValue = croppedDocumentRaw;
    } else if (hasCroppedDocument && croppedDocumentRaw == null) {
      throw FormatException('ImageToResultSettings.croppedDocument: null is not allowed');
    }
    final hasFrame = raw.containsKey('frame');
    final frameRaw = raw['frame'];
    bool? frameValue;
    if (hasFrame && frameRaw != null) {
      if (frameRaw is! bool) {
        throw FormatException('ImageToResultSettings.frame: expected a bool');
      }
      frameValue = frameRaw;
    } else if (hasFrame && frameRaw == null) {
      throw FormatException('ImageToResultSettings.frame: null is not allowed');
    }
    return ImageToResultSettings(
      face: faceValue,
      croppedDocument: croppedDocumentValue,
      frame: frameValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (face != null) {
      map['face'] = face;
    }
    if (croppedDocument != null) {
      map['croppedDocument'] = croppedDocument;
    }
    if (frame != null) {
      map['frame'] = frame;
    }
    return map;
  }
}

/// Typed builder for the `ImageToResultSettings` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildImageToResultSettings({
  bool? face,
  bool? croppedDocument,
  bool? frame,
}) {
  final map = <String, Object?>{};
  if (face != null) {
    map['face'] = face;
  }
  if (croppedDocument != null) {
    map['croppedDocument'] = croppedDocument;
  }
  if (frame != null) {
    map['frame'] = frame;
  }
  return map;
}

/// A duration expressed in days, months, and years.
class Duration {
  final int? days;
  final int? months;
  final int? years;

  const Duration({
    this.days,
    this.months,
    this.years,
  });

  factory Duration.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('Duration: expected a Map');
    }
    const allowedKeys = <String>{
      'days',
      'months',
      'years',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("Duration: unknown property '$key'");
      }
    }
    final hasDays = raw.containsKey('days');
    final daysRaw = raw['days'];
    int? daysValue;
    if (hasDays && daysRaw != null) {
      if (daysRaw is! num) {
        throw FormatException('Duration.days: expected a number');
      }
      if (daysRaw != daysRaw.toInt()) {
        throw FormatException('Duration.days: expected an integer');
      }
      daysValue = daysRaw.toInt();
    } else if (hasDays && daysRaw == null) {
      throw FormatException('Duration.days: null is not allowed');
    }
    final hasMonths = raw.containsKey('months');
    final monthsRaw = raw['months'];
    int? monthsValue;
    if (hasMonths && monthsRaw != null) {
      if (monthsRaw is! num) {
        throw FormatException('Duration.months: expected a number');
      }
      if (monthsRaw != monthsRaw.toInt()) {
        throw FormatException('Duration.months: expected an integer');
      }
      monthsValue = monthsRaw.toInt();
    } else if (hasMonths && monthsRaw == null) {
      throw FormatException('Duration.months: null is not allowed');
    }
    final hasYears = raw.containsKey('years');
    final yearsRaw = raw['years'];
    int? yearsValue;
    if (hasYears && yearsRaw != null) {
      if (yearsRaw is! num) {
        throw FormatException('Duration.years: expected a number');
      }
      if (yearsRaw != yearsRaw.toInt()) {
        throw FormatException('Duration.years: expected an integer');
      }
      yearsValue = yearsRaw.toInt();
    } else if (hasYears && yearsRaw == null) {
      throw FormatException('Duration.years: null is not allowed');
    }
    return Duration(
      days: daysValue,
      months: monthsValue,
      years: yearsValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (days != null) {
      map['days'] = days;
    }
    if (months != null) {
      map['months'] = months;
    }
    if (years != null) {
      map['years'] = years;
    }
    return map;
  }
}

/// Typed builder for the `Duration` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildDuration({
  int? days,
  int? months,
  int? years,
}) {
  final map = <String, Object?>{};
  if (days != null) {
    map['days'] = days;
  }
  if (months != null) {
    map['months'] = months;
  }
  if (years != null) {
    map['years'] = years;
  }
  return map;
}

/// Describes an identity document type accepted or rejected by ID capture.
class Document {
  final IdCaptureDocumentType? documentType;
  final String? documentSubtype;
  final String? region;

  const Document({
    this.documentType,
    this.documentSubtype,
    this.region,
  });

  factory Document.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('Document: expected a Map');
    }
    const allowedKeys = <String>{
      'documentType',
      'documentSubtype',
      'region',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("Document: unknown property '$key'");
      }
    }
    final hasDocumentType = raw.containsKey('documentType');
    final documentTypeRaw = raw['documentType'];
    IdCaptureDocumentType? documentTypeValue;
    if (hasDocumentType && documentTypeRaw != null) {
      documentTypeValue = (documentTypeRaw is! String
          ? (throw FormatException('Document.documentType: expected a String for IdCaptureDocumentType'))
          : IdCaptureDocumentType.fromJSON(documentTypeRaw));
    } else if (hasDocumentType && documentTypeRaw == null) {
      throw FormatException('Document.documentType: null is not allowed');
    }
    final hasDocumentSubtype = raw.containsKey('documentSubtype');
    final documentSubtypeRaw = raw['documentSubtype'];
    String? documentSubtypeValue;
    if (hasDocumentSubtype && documentSubtypeRaw != null) {
      if (documentSubtypeRaw is! String) {
        throw FormatException('Document.documentSubtype: expected a String');
      }
      documentSubtypeValue = documentSubtypeRaw;
    }
    final hasRegion = raw.containsKey('region');
    final regionRaw = raw['region'];
    String? regionValue;
    if (hasRegion && regionRaw != null) {
      if (regionRaw is! String) {
        throw FormatException('Document.region: expected a String');
      }
      regionValue = regionRaw;
    }
    return Document(
      documentType: documentTypeValue,
      documentSubtype: documentSubtypeValue,
      region: regionValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (documentType != null) {
      map['documentType'] = documentType!.toJson();
    }
    if (documentSubtype != null) {
      map['documentSubtype'] = documentSubtype;
    }
    if (region != null) {
      map['region'] = region;
    }
    return map;
  }
}

/// Typed builder for the `Document` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildDocument({
  Object? documentType,
  Object? documentSubtype = _unset,
  Object? region = _unset,
}) {
  final map = <String, Object?>{};
  if (documentType != null) {
    map['documentType'] = documentType;
  }
  if (!identical(documentSubtype, _unset)) {
    map['documentSubtype'] = documentSubtype;
  }
  if (!identical(region, _unset)) {
    map['region'] = region;
  }
  return map;
}

/// The type of identity document to capture.
enum IdCaptureDocumentType {
  driverLicense('driverLicense'),
  idCard('idCard'),
  passport('passport'),
  visaIcao('visaIcao'),
  residencePermit('residencePermit'),
  healthInsuranceCard('healthInsuranceCard'),
  regionSpecific('regionSpecific'),
  visaLetter('visaLetter');

  const IdCaptureDocumentType(this.jsonValue);

  final String jsonValue;

  static IdCaptureDocumentType fromJSON(String jsonValue) {
    for (final value in IdCaptureDocumentType.values) {
      if (value.jsonValue == jsonValue) {
        return value;
      }
    }
    throw FormatException("IdCaptureDocumentType: unknown enum value '$jsonValue'");
  }

  String toJson() => jsonValue;
}

/// Configuration for the scanner type used in ID capture.
class ScannerType {
  final PhysicalDocumentScanner? physicalDocument;
  final MobileDocumentScanner? mobileDocument;
  final bool? allowCloudScanning;

  const ScannerType({
    this.physicalDocument,
    this.mobileDocument,
    this.allowCloudScanning,
  });

  factory ScannerType.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('ScannerType: expected a Map');
    }
    const allowedKeys = <String>{
      'physicalDocument',
      'mobileDocument',
      'allowCloudScanning',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("ScannerType: unknown property '$key'");
      }
    }
    final hasPhysicalDocument = raw.containsKey('physicalDocument');
    final physicalDocumentRaw = raw['physicalDocument'];
    PhysicalDocumentScanner? physicalDocumentValue;
    if (hasPhysicalDocument && physicalDocumentRaw != null) {
      physicalDocumentValue = PhysicalDocumentScanner.fromJson(physicalDocumentRaw);
    }
    final hasMobileDocument = raw.containsKey('mobileDocument');
    final mobileDocumentRaw = raw['mobileDocument'];
    MobileDocumentScanner? mobileDocumentValue;
    if (hasMobileDocument && mobileDocumentRaw != null) {
      mobileDocumentValue = MobileDocumentScanner.fromJson(mobileDocumentRaw);
    }
    final hasAllowCloudScanning = raw.containsKey('allowCloudScanning');
    final allowCloudScanningRaw = raw['allowCloudScanning'];
    bool? allowCloudScanningValue;
    if (hasAllowCloudScanning && allowCloudScanningRaw != null) {
      if (allowCloudScanningRaw is! bool) {
        throw FormatException('ScannerType.allowCloudScanning: expected a bool');
      }
      allowCloudScanningValue = allowCloudScanningRaw;
    } else if (hasAllowCloudScanning && allowCloudScanningRaw == null) {
      throw FormatException('ScannerType.allowCloudScanning: null is not allowed');
    }
    return ScannerType(
      physicalDocument: physicalDocumentValue,
      mobileDocument: mobileDocumentValue,
      allowCloudScanning: allowCloudScanningValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (physicalDocument != null) {
      map['physicalDocument'] = physicalDocument!.toJson();
    }
    if (mobileDocument != null) {
      map['mobileDocument'] = mobileDocument!.toJson();
    }
    if (allowCloudScanning != null) {
      map['allowCloudScanning'] = allowCloudScanning;
    }
    return map;
  }
}

/// Typed builder for the `ScannerType` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildScannerType({
  Object? physicalDocument = _unset,
  Object? mobileDocument = _unset,
  bool? allowCloudScanning,
}) {
  final map = <String, Object?>{};
  if (!identical(physicalDocument, _unset)) {
    map['physicalDocument'] = physicalDocument;
  }
  if (!identical(mobileDocument, _unset)) {
    map['mobileDocument'] = mobileDocument;
  }
  if (allowCloudScanning != null) {
    map['allowCloudScanning'] = allowCloudScanning;
  }
  return map;
}

/// Configuration for scanning physical identity documents.
class PhysicalDocumentScanner {
  final bool isFull;
  final ScannerTypeOptions options;

  const PhysicalDocumentScanner({
    required this.isFull,
    required this.options,
  });

  factory PhysicalDocumentScanner.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('PhysicalDocumentScanner: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'isFull',
      'options',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("PhysicalDocumentScanner: unknown property '$key'");
      }
    }
    final hasIsFull = raw.containsKey('isFull');
    if (!hasIsFull) {
      throw FormatException("PhysicalDocumentScanner.isFull: missing required property");
    }
    final isFullRaw = raw['isFull'];
    bool? isFullValue;
    if (hasIsFull && isFullRaw != null) {
      if (isFullRaw is! bool) {
        throw FormatException('PhysicalDocumentScanner.isFull: expected a bool');
      }
      isFullValue = isFullRaw;
    } else if (hasIsFull && isFullRaw == null) {
      throw FormatException('PhysicalDocumentScanner.isFull: null is not allowed');
    }
    final hasOptions = raw.containsKey('options');
    if (!hasOptions) {
      throw FormatException("PhysicalDocumentScanner.options: missing required property");
    }
    final optionsRaw = raw['options'];
    ScannerTypeOptions? optionsValue;
    if (hasOptions && optionsRaw != null) {
      optionsValue = ScannerTypeOptions.fromJson(optionsRaw);
    } else if (hasOptions && optionsRaw == null) {
      throw FormatException('PhysicalDocumentScanner.options: null is not allowed');
    }
    return PhysicalDocumentScanner(
      isFull: isFullValue!,
      options: optionsValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['isFull'] = isFull;
    map['options'] = options.toJson();
    return map;
  }
}

/// Typed builder for the `PhysicalDocumentScanner` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildPhysicalDocumentScanner({
  required bool isFull,
  required Object options,
}) {
  final map = <String, Object?>{};
  map['isFull'] = isFull;
  map['options'] = options;
  return map;
}

/// Options controlling which scanning technologies are enabled.
class ScannerTypeOptions {
  final bool barcode;
  final bool machineReadableZone;
  final bool visualInspectionZone;
  final bool? freeFormText;
  final bool? manipulationCheck;

  const ScannerTypeOptions({
    required this.barcode,
    required this.machineReadableZone,
    required this.visualInspectionZone,
    this.freeFormText,
    this.manipulationCheck,
  });

  factory ScannerTypeOptions.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('ScannerTypeOptions: expected a Map');
    }
    const allowedKeys = <String>{
      'barcode',
      'machineReadableZone',
      'visualInspectionZone',
      'freeFormText',
      'manipulationCheck',
      'soloZone',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("ScannerTypeOptions: unknown property '$key'");
      }
    }
    final hasBarcode = raw.containsKey('barcode');
    if (!hasBarcode) {
      throw FormatException("ScannerTypeOptions.barcode: missing required property");
    }
    final barcodeRaw = raw['barcode'];
    bool? barcodeValue;
    if (hasBarcode && barcodeRaw != null) {
      if (barcodeRaw is! bool) {
        throw FormatException('ScannerTypeOptions.barcode: expected a bool');
      }
      barcodeValue = barcodeRaw;
    } else if (hasBarcode && barcodeRaw == null) {
      throw FormatException('ScannerTypeOptions.barcode: null is not allowed');
    }
    final hasMachineReadableZone = raw.containsKey('machineReadableZone');
    if (!hasMachineReadableZone) {
      throw FormatException("ScannerTypeOptions.machineReadableZone: missing required property");
    }
    final machineReadableZoneRaw = raw['machineReadableZone'];
    bool? machineReadableZoneValue;
    if (hasMachineReadableZone && machineReadableZoneRaw != null) {
      if (machineReadableZoneRaw is! bool) {
        throw FormatException('ScannerTypeOptions.machineReadableZone: expected a bool');
      }
      machineReadableZoneValue = machineReadableZoneRaw;
    } else if (hasMachineReadableZone && machineReadableZoneRaw == null) {
      throw FormatException('ScannerTypeOptions.machineReadableZone: null is not allowed');
    }
    final hasVisualInspectionZone = raw.containsKey('visualInspectionZone');
    if (!hasVisualInspectionZone) {
      throw FormatException("ScannerTypeOptions.visualInspectionZone: missing required property");
    }
    final visualInspectionZoneRaw = raw['visualInspectionZone'];
    bool? visualInspectionZoneValue;
    if (hasVisualInspectionZone && visualInspectionZoneRaw != null) {
      if (visualInspectionZoneRaw is! bool) {
        throw FormatException('ScannerTypeOptions.visualInspectionZone: expected a bool');
      }
      visualInspectionZoneValue = visualInspectionZoneRaw;
    } else if (hasVisualInspectionZone && visualInspectionZoneRaw == null) {
      throw FormatException('ScannerTypeOptions.visualInspectionZone: null is not allowed');
    }
    final hasFreeFormText = raw.containsKey('freeFormText');
    final freeFormTextRaw = raw['freeFormText'];
    bool? freeFormTextValue;
    if (hasFreeFormText && freeFormTextRaw != null) {
      if (freeFormTextRaw is! bool) {
        throw FormatException('ScannerTypeOptions.freeFormText: expected a bool');
      }
      freeFormTextValue = freeFormTextRaw;
    } else if (hasFreeFormText && freeFormTextRaw == null) {
      throw FormatException('ScannerTypeOptions.freeFormText: null is not allowed');
    }
    final hasManipulationCheck = raw.containsKey('manipulationCheck');
    final manipulationCheckRaw = raw['manipulationCheck'];
    bool? manipulationCheckValue;
    if (hasManipulationCheck && manipulationCheckRaw != null) {
      if (manipulationCheckRaw is! bool) {
        throw FormatException('ScannerTypeOptions.manipulationCheck: expected a bool');
      }
      manipulationCheckValue = manipulationCheckRaw;
    } else if (hasManipulationCheck && manipulationCheckRaw == null) {
      throw FormatException('ScannerTypeOptions.manipulationCheck: null is not allowed');
    }
    return ScannerTypeOptions(
      barcode: barcodeValue!,
      machineReadableZone: machineReadableZoneValue!,
      visualInspectionZone: visualInspectionZoneValue!,
      freeFormText: freeFormTextValue,
      manipulationCheck: manipulationCheckValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['barcode'] = barcode;
    map['machineReadableZone'] = machineReadableZone;
    map['visualInspectionZone'] = visualInspectionZone;
    if (freeFormText != null) {
      map['freeFormText'] = freeFormText;
    }
    if (manipulationCheck != null) {
      map['manipulationCheck'] = manipulationCheck;
    }
    return map;
  }
}

/// Typed builder for the `ScannerTypeOptions` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildScannerTypeOptions({
  required bool barcode,
  required bool machineReadableZone,
  required bool visualInspectionZone,
  bool? freeFormText,
  bool? manipulationCheck,
}) {
  final map = <String, Object?>{};
  map['barcode'] = barcode;
  map['machineReadableZone'] = machineReadableZone;
  map['visualInspectionZone'] = visualInspectionZone;
  if (freeFormText != null) {
    map['freeFormText'] = freeFormText;
  }
  if (manipulationCheck != null) {
    map['manipulationCheck'] = manipulationCheck;
  }
  return map;
}

/// Configuration for scanning mobile identity documents.
class MobileDocumentScanner {
  final bool? iso180135;
  final bool? ocr;
  final List<MobileDocumentScannerElementsToRetainItem>? elementsToRetain;

  const MobileDocumentScanner({
    this.iso180135,
    this.ocr,
    this.elementsToRetain,
  });

  factory MobileDocumentScanner.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('MobileDocumentScanner: expected a Map');
    }
    const allowedKeys = <String>{
      'iso180135',
      'ocr',
      'elementsToRetain',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("MobileDocumentScanner: unknown property '$key'");
      }
    }
    final hasIso180135 = raw.containsKey('iso180135');
    final iso180135Raw = raw['iso180135'];
    bool? iso180135Value;
    if (hasIso180135 && iso180135Raw != null) {
      if (iso180135Raw is! bool) {
        throw FormatException('MobileDocumentScanner.iso180135: expected a bool');
      }
      iso180135Value = iso180135Raw;
    } else if (hasIso180135 && iso180135Raw == null) {
      throw FormatException('MobileDocumentScanner.iso180135: null is not allowed');
    }
    final hasOcr = raw.containsKey('ocr');
    final ocrRaw = raw['ocr'];
    bool? ocrValue;
    if (hasOcr && ocrRaw != null) {
      if (ocrRaw is! bool) {
        throw FormatException('MobileDocumentScanner.ocr: expected a bool');
      }
      ocrValue = ocrRaw;
    } else if (hasOcr && ocrRaw == null) {
      throw FormatException('MobileDocumentScanner.ocr: null is not allowed');
    }
    final hasElementsToRetain = raw.containsKey('elementsToRetain');
    final elementsToRetainRaw = raw['elementsToRetain'];
    List<MobileDocumentScannerElementsToRetainItem>? elementsToRetainValue;
    if (hasElementsToRetain && elementsToRetainRaw != null) {
      if (elementsToRetainRaw is! List) {
        throw FormatException('MobileDocumentScanner.elementsToRetain: expected a List');
      }
      elementsToRetainValue =
          elementsToRetainRaw.map((item) => MobileDocumentScannerElementsToRetainItem.fromJson(item)).toList();
    } else if (hasElementsToRetain && elementsToRetainRaw == null) {
      throw FormatException('MobileDocumentScanner.elementsToRetain: null is not allowed');
    }
    return MobileDocumentScanner(
      iso180135: iso180135Value,
      ocr: ocrValue,
      elementsToRetain: elementsToRetainValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (iso180135 != null) {
      map['iso180135'] = iso180135;
    }
    if (ocr != null) {
      map['ocr'] = ocr;
    }
    if (elementsToRetain != null) {
      map['elementsToRetain'] = elementsToRetain!.map((item) => item.toJson()).toList();
    }
    return map;
  }
}

/// Typed builder for the `MobileDocumentScanner` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildMobileDocumentScanner({
  bool? iso180135,
  bool? ocr,
  List<Object?>? elementsToRetain,
}) {
  final map = <String, Object?>{};
  if (iso180135 != null) {
    map['iso180135'] = iso180135;
  }
  if (ocr != null) {
    map['ocr'] = ocr;
  }
  if (elementsToRetain != null) {
    map['elementsToRetain'] = elementsToRetain;
  }
  return map;
}

///
class MobileDocumentScannerElementsToRetainItem {
  final String namespace;
  final String field;

  const MobileDocumentScannerElementsToRetainItem({
    required this.namespace,
    required this.field,
  });

  factory MobileDocumentScannerElementsToRetainItem.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('MobileDocumentScannerElementsToRetainItem: expected a Map');
    }
    const allowedKeys = <String>{
      'namespace',
      'field',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("MobileDocumentScannerElementsToRetainItem: unknown property '$key'");
      }
    }
    final hasNamespace = raw.containsKey('namespace');
    if (!hasNamespace) {
      throw FormatException("MobileDocumentScannerElementsToRetainItem.namespace: missing required property");
    }
    final namespaceRaw = raw['namespace'];
    String? namespaceValue;
    if (hasNamespace && namespaceRaw != null) {
      if (namespaceRaw is! String) {
        throw FormatException('MobileDocumentScannerElementsToRetainItem.namespace: expected a String');
      }
      namespaceValue = namespaceRaw;
    } else if (hasNamespace && namespaceRaw == null) {
      throw FormatException('MobileDocumentScannerElementsToRetainItem.namespace: null is not allowed');
    }
    final hasField = raw.containsKey('field');
    if (!hasField) {
      throw FormatException("MobileDocumentScannerElementsToRetainItem.field: missing required property");
    }
    final fieldRaw = raw['field'];
    String? fieldValue;
    if (hasField && fieldRaw != null) {
      if (fieldRaw is! String) {
        throw FormatException('MobileDocumentScannerElementsToRetainItem.field: expected a String');
      }
      fieldValue = fieldRaw;
    } else if (hasField && fieldRaw == null) {
      throw FormatException('MobileDocumentScannerElementsToRetainItem.field: null is not allowed');
    }
    return MobileDocumentScannerElementsToRetainItem(
      namespace: namespaceValue!,
      field: fieldValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['namespace'] = namespace;
    map['field'] = field;
    return map;
  }
}

/// Typed builder for the `MobileDocumentScannerElementsToRetainItem` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildMobileDocumentScannerElementsToRetainItem({
  required String namespace,
  required String field,
}) {
  final map = <String, Object?>{};
  map['namespace'] = namespace;
  map['field'] = field;
  return map;
}

/// Feedback configuration for ID capture events.
class IdCaptureFeedback {
  final Feedback? idCaptured;
  final Feedback? idRejected;

  const IdCaptureFeedback({
    this.idCaptured,
    this.idRejected,
  });

  factory IdCaptureFeedback.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('IdCaptureFeedback: expected a Map');
    }
    const allowedKeys = <String>{
      'idCaptured',
      'idRejected',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("IdCaptureFeedback: unknown property '$key'");
      }
    }
    final hasIdCaptured = raw.containsKey('idCaptured');
    final idCapturedRaw = raw['idCaptured'];
    Feedback? idCapturedValue;
    if (hasIdCaptured && idCapturedRaw != null) {
      idCapturedValue = Feedback.fromJson(idCapturedRaw);
    } else if (hasIdCaptured && idCapturedRaw == null) {
      throw FormatException('IdCaptureFeedback.idCaptured: null is not allowed');
    }
    final hasIdRejected = raw.containsKey('idRejected');
    final idRejectedRaw = raw['idRejected'];
    Feedback? idRejectedValue;
    if (hasIdRejected && idRejectedRaw != null) {
      idRejectedValue = Feedback.fromJson(idRejectedRaw);
    } else if (hasIdRejected && idRejectedRaw == null) {
      throw FormatException('IdCaptureFeedback.idRejected: null is not allowed');
    }
    return IdCaptureFeedback(
      idCaptured: idCapturedValue,
      idRejected: idRejectedValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (idCaptured != null) {
      map['idCaptured'] = idCaptured!.toJson();
    }
    if (idRejected != null) {
      map['idRejected'] = idRejected!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `IdCaptureFeedback` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildIdCaptureFeedback({
  Object? idCaptured,
  Object? idRejected,
}) {
  final map = <String, Object?>{};
  if (idCaptured != null) {
    map['idCaptured'] = idCaptured;
  }
  if (idRejected != null) {
    map['idRejected'] = idRejected;
  }
  return map;
}

/// The text capture mode.
class TextCapture implements Mode {
  final String type;
  final TextCaptureSettings? settings;
  final TextCaptureFeedback? feedback;

  const TextCapture({
    required this.type,
    this.settings,
    this.feedback,
  });

  factory TextCapture.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('TextCapture: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'settings',
      'feedback',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("TextCapture: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("TextCapture.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['textCapture'].contains(typeRaw)) {
        throw FormatException("TextCapture.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('TextCapture.type: null is not allowed');
    }
    final hasSettings = raw.containsKey('settings');
    final settingsRaw = raw['settings'];
    TextCaptureSettings? settingsValue;
    if (hasSettings && settingsRaw != null) {
      settingsValue = TextCaptureSettings.fromJson(settingsRaw);
    } else if (hasSettings && settingsRaw == null) {
      throw FormatException('TextCapture.settings: null is not allowed');
    }
    final hasFeedback = raw.containsKey('feedback');
    final feedbackRaw = raw['feedback'];
    TextCaptureFeedback? feedbackValue;
    if (hasFeedback && feedbackRaw != null) {
      feedbackValue = TextCaptureFeedback.fromJson(feedbackRaw);
    } else if (hasFeedback && feedbackRaw == null) {
      throw FormatException('TextCapture.feedback: null is not allowed');
    }
    return TextCapture(
      type: typeValue!,
      settings: settingsValue,
      feedback: feedbackValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (settings != null) {
      map['settings'] = settings!.toJson();
    }
    if (feedback != null) {
      map['feedback'] = feedback!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `TextCapture` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildTextCapture({
  required String type,
  Object? settings,
  Object? feedback,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (settings != null) {
    map['settings'] = settings;
  }
  if (feedback != null) {
    map['feedback'] = feedback;
  }
  return map;
}

/// Settings for the text capture mode.
class TextCaptureSettings {
  final int? duplicateFilter;
  final String? recognitionDirection;
  final LocationSelection? locationSelection;
  final String? licenseKey;
  final String? licensee;

  const TextCaptureSettings({
    this.duplicateFilter,
    this.recognitionDirection,
    this.locationSelection,
    this.licenseKey,
    this.licensee,
  });

  factory TextCaptureSettings.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('TextCaptureSettings: expected a Map');
    }
    const allowedKeys = <String>{
      'duplicateFilter',
      'recognitionDirection',
      'locationSelection',
      'licenseKey',
      'licensee',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("TextCaptureSettings: unknown property '$key'");
      }
    }
    final hasDuplicateFilter = raw.containsKey('duplicateFilter');
    final duplicateFilterRaw = raw['duplicateFilter'];
    int? duplicateFilterValue;
    if (hasDuplicateFilter && duplicateFilterRaw != null) {
      if (duplicateFilterRaw is! num) {
        throw FormatException('TextCaptureSettings.duplicateFilter: expected a number');
      }
      if (duplicateFilterRaw != duplicateFilterRaw.toInt()) {
        throw FormatException('TextCaptureSettings.duplicateFilter: expected an integer');
      }
      duplicateFilterValue = duplicateFilterRaw.toInt();
    } else if (hasDuplicateFilter && duplicateFilterRaw == null) {
      throw FormatException('TextCaptureSettings.duplicateFilter: null is not allowed');
    }
    final hasRecognitionDirection = raw.containsKey('recognitionDirection');
    final recognitionDirectionRaw = raw['recognitionDirection'];
    String? recognitionDirectionValue;
    if (hasRecognitionDirection && recognitionDirectionRaw != null) {
      if (recognitionDirectionRaw is! String ||
          !const <String>['none', 'horizontal', 'leftToRight', 'rightToLeft', 'vertical', 'topToBottom', 'bottomToTop']
              .contains(recognitionDirectionRaw)) {
        throw FormatException(
            "TextCaptureSettings.recognitionDirection: unknown enum value '$recognitionDirectionRaw'");
      }
      recognitionDirectionValue = recognitionDirectionRaw;
    } else if (hasRecognitionDirection && recognitionDirectionRaw == null) {
      throw FormatException('TextCaptureSettings.recognitionDirection: null is not allowed');
    }
    final hasLocationSelection = raw.containsKey('locationSelection');
    final locationSelectionRaw = raw['locationSelection'];
    LocationSelection? locationSelectionValue;
    if (hasLocationSelection && locationSelectionRaw != null) {
      locationSelectionValue = LocationSelection.fromJson(locationSelectionRaw);
    }
    final hasLicenseKey = raw.containsKey('licenseKey');
    final licenseKeyRaw = raw['licenseKey'];
    String? licenseKeyValue;
    if (hasLicenseKey && licenseKeyRaw != null) {
      if (licenseKeyRaw is! String) {
        throw FormatException('TextCaptureSettings.licenseKey: expected a String');
      }
      licenseKeyValue = licenseKeyRaw;
    } else if (hasLicenseKey && licenseKeyRaw == null) {
      throw FormatException('TextCaptureSettings.licenseKey: null is not allowed');
    }
    final hasLicensee = raw.containsKey('licensee');
    final licenseeRaw = raw['licensee'];
    String? licenseeValue;
    if (hasLicensee && licenseeRaw != null) {
      if (licenseeRaw is! String) {
        throw FormatException('TextCaptureSettings.licensee: expected a String');
      }
      licenseeValue = licenseeRaw;
    } else if (hasLicensee && licenseeRaw == null) {
      throw FormatException('TextCaptureSettings.licensee: null is not allowed');
    }
    return TextCaptureSettings(
      duplicateFilter: duplicateFilterValue,
      recognitionDirection: recognitionDirectionValue,
      locationSelection: locationSelectionValue,
      licenseKey: licenseKeyValue,
      licensee: licenseeValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (duplicateFilter != null) {
      map['duplicateFilter'] = duplicateFilter;
    }
    if (recognitionDirection != null) {
      map['recognitionDirection'] = recognitionDirection;
    }
    if (locationSelection != null) {
      map['locationSelection'] = locationSelection!.toJson();
    }
    if (licenseKey != null) {
      map['licenseKey'] = licenseKey;
    }
    if (licensee != null) {
      map['licensee'] = licensee;
    }
    return map;
  }
}

/// Typed builder for the `TextCaptureSettings` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildTextCaptureSettings({
  int? duplicateFilter,
  String? recognitionDirection,
  Object? locationSelection = _unset,
  String? licenseKey,
  String? licensee,
}) {
  final map = <String, Object?>{};
  if (duplicateFilter != null) {
    map['duplicateFilter'] = duplicateFilter;
  }
  if (recognitionDirection != null) {
    map['recognitionDirection'] = recognitionDirection;
  }
  if (!identical(locationSelection, _unset)) {
    map['locationSelection'] = locationSelection;
  }
  if (licenseKey != null) {
    map['licenseKey'] = licenseKey;
  }
  if (licensee != null) {
    map['licensee'] = licensee;
  }
  return map;
}

/// Feedback configuration for text capture events.
class TextCaptureFeedback {
  final Feedback? success;

  const TextCaptureFeedback({
    this.success,
  });

  factory TextCaptureFeedback.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('TextCaptureFeedback: expected a Map');
    }
    const allowedKeys = <String>{
      'success',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("TextCaptureFeedback: unknown property '$key'");
      }
    }
    final hasSuccess = raw.containsKey('success');
    final successRaw = raw['success'];
    Feedback? successValue;
    if (hasSuccess && successRaw != null) {
      successValue = Feedback.fromJson(successRaw);
    } else if (hasSuccess && successRaw == null) {
      throw FormatException('TextCaptureFeedback.success: null is not allowed');
    }
    return TextCaptureFeedback(
      success: successValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (success != null) {
      map['success'] = success!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `TextCaptureFeedback` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildTextCaptureFeedback({
  Object? success,
}) {
  final map = <String, Object?>{};
  if (success != null) {
    map['success'] = success;
  }
  return map;
}

/// The BarcodeFind capture mode for searching barcodes in a list.
class BarcodeFind implements Mode {
  final String type;
  final BarcodeFindSettings? settings;
  final BarcodeFindFeedback? feedback;
  final bool? enabled;
  final String? itemsToFind;
  final bool? hasBarcodeTransformer;
  final bool? hasListeners;
  final Object? barcodeTransformer;

  const BarcodeFind({
    required this.type,
    this.settings,
    this.feedback,
    this.enabled,
    this.itemsToFind,
    this.hasBarcodeTransformer,
    this.hasListeners,
    this.barcodeTransformer,
  });

  factory BarcodeFind.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('BarcodeFind: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'settings',
      'feedback',
      'enabled',
      'itemsToFind',
      'hasBarcodeTransformer',
      'hasListeners',
      'barcodeTransformer',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("BarcodeFind: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("BarcodeFind.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['barcodeFind'].contains(typeRaw)) {
        throw FormatException("BarcodeFind.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('BarcodeFind.type: null is not allowed');
    }
    final hasSettings = raw.containsKey('settings');
    final settingsRaw = raw['settings'];
    BarcodeFindSettings? settingsValue;
    if (hasSettings && settingsRaw != null) {
      settingsValue = BarcodeFindSettings.fromJson(settingsRaw);
    } else if (hasSettings && settingsRaw == null) {
      throw FormatException('BarcodeFind.settings: null is not allowed');
    }
    final hasFeedback = raw.containsKey('feedback');
    final feedbackRaw = raw['feedback'];
    BarcodeFindFeedback? feedbackValue;
    if (hasFeedback && feedbackRaw != null) {
      feedbackValue = BarcodeFindFeedback.fromJson(feedbackRaw);
    } else if (hasFeedback && feedbackRaw == null) {
      throw FormatException('BarcodeFind.feedback: null is not allowed');
    }
    final hasEnabled = raw.containsKey('enabled');
    final enabledRaw = raw['enabled'];
    bool? enabledValue;
    if (hasEnabled && enabledRaw != null) {
      if (enabledRaw is! bool) {
        throw FormatException('BarcodeFind.enabled: expected a bool');
      }
      enabledValue = enabledRaw;
    } else if (hasEnabled && enabledRaw == null) {
      throw FormatException('BarcodeFind.enabled: null is not allowed');
    }
    final hasItemsToFind = raw.containsKey('itemsToFind');
    final itemsToFindRaw = raw['itemsToFind'];
    String? itemsToFindValue;
    if (hasItemsToFind && itemsToFindRaw != null) {
      if (itemsToFindRaw is! String) {
        throw FormatException('BarcodeFind.itemsToFind: expected a String');
      }
      itemsToFindValue = itemsToFindRaw;
    }
    final hasHasBarcodeTransformer = raw.containsKey('hasBarcodeTransformer');
    final hasBarcodeTransformerRaw = raw['hasBarcodeTransformer'];
    bool? hasBarcodeTransformerValue;
    if (hasHasBarcodeTransformer && hasBarcodeTransformerRaw != null) {
      if (hasBarcodeTransformerRaw is! bool) {
        throw FormatException('BarcodeFind.hasBarcodeTransformer: expected a bool');
      }
      hasBarcodeTransformerValue = hasBarcodeTransformerRaw;
    } else if (hasHasBarcodeTransformer && hasBarcodeTransformerRaw == null) {
      throw FormatException('BarcodeFind.hasBarcodeTransformer: null is not allowed');
    }
    final hasHasListeners = raw.containsKey('hasListeners');
    final hasListenersRaw = raw['hasListeners'];
    bool? hasListenersValue;
    if (hasHasListeners && hasListenersRaw != null) {
      if (hasListenersRaw is! bool) {
        throw FormatException('BarcodeFind.hasListeners: expected a bool');
      }
      hasListenersValue = hasListenersRaw;
    } else if (hasHasListeners && hasListenersRaw == null) {
      throw FormatException('BarcodeFind.hasListeners: null is not allowed');
    }
    final hasBarcodeTransformer = raw.containsKey('barcodeTransformer');
    final barcodeTransformerRaw = raw['barcodeTransformer'];
    Object? barcodeTransformerValue;
    if (hasBarcodeTransformer && barcodeTransformerRaw != null) {
      barcodeTransformerValue = barcodeTransformerRaw;
    }
    return BarcodeFind(
      type: typeValue!,
      settings: settingsValue,
      feedback: feedbackValue,
      enabled: enabledValue,
      itemsToFind: itemsToFindValue,
      hasBarcodeTransformer: hasBarcodeTransformerValue,
      hasListeners: hasListenersValue,
      barcodeTransformer: barcodeTransformerValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (settings != null) {
      map['settings'] = settings!.toJson();
    }
    if (feedback != null) {
      map['feedback'] = feedback!.toJson();
    }
    if (enabled != null) {
      map['enabled'] = enabled;
    }
    if (itemsToFind != null) {
      map['itemsToFind'] = itemsToFind;
    }
    if (hasBarcodeTransformer != null) {
      map['hasBarcodeTransformer'] = hasBarcodeTransformer;
    }
    if (hasListeners != null) {
      map['hasListeners'] = hasListeners;
    }
    if (barcodeTransformer != null) {
      map['barcodeTransformer'] = barcodeTransformer;
    }
    return map;
  }
}

/// Typed builder for the `BarcodeFind` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildBarcodeFind({
  required String type,
  Object? settings,
  Object? feedback,
  bool? enabled,
  Object? itemsToFind = _unset,
  bool? hasBarcodeTransformer,
  bool? hasListeners,
  Object? barcodeTransformer = _unset,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (settings != null) {
    map['settings'] = settings;
  }
  if (feedback != null) {
    map['feedback'] = feedback;
  }
  if (enabled != null) {
    map['enabled'] = enabled;
  }
  if (!identical(itemsToFind, _unset)) {
    map['itemsToFind'] = itemsToFind;
  }
  if (hasBarcodeTransformer != null) {
    map['hasBarcodeTransformer'] = hasBarcodeTransformer;
  }
  if (hasListeners != null) {
    map['hasListeners'] = hasListeners;
  }
  if (!identical(barcodeTransformer, _unset)) {
    map['barcodeTransformer'] = barcodeTransformer;
  }
  return map;
}

/// Settings configuring barcode recognition for BarcodeFind. The closed property set is deliberately the set the wrappers emit, not the wider set the engine tolerates (the scanner deserializer also consumes codeDuplicateFilter); exposing another engine key on this mode means declaring it here first.
class BarcodeFindSettings {
  final SymbologySettings? symbologies;

  const BarcodeFindSettings({
    this.symbologies,
  });

  factory BarcodeFindSettings.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('BarcodeFindSettings: expected a Map');
    }
    const allowedKeys = <String>{
      'symbologies',
      'properties',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("BarcodeFindSettings: unknown property '$key'");
      }
    }
    final hasSymbologies = raw.containsKey('symbologies');
    final symbologiesRaw = raw['symbologies'];
    SymbologySettings? symbologiesValue;
    if (hasSymbologies && symbologiesRaw != null) {
      symbologiesValue = parseSymbologySettings(symbologiesRaw);
    } else if (hasSymbologies && symbologiesRaw == null) {
      throw FormatException('BarcodeFindSettings.symbologies: null is not allowed');
    }
    return BarcodeFindSettings(
      symbologies: symbologiesValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (symbologies != null) {
      map['symbologies'] = symbologies;
    }
    return map;
  }
}

/// Typed builder for the `BarcodeFindSettings` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildBarcodeFindSettings({
  SymbologySettings? symbologies,
}) {
  final map = <String, Object?>{};
  if (symbologies != null) {
    map['symbologies'] = symbologies;
  }
  return map;
}

/// Feedback configuration for BarcodeFind events.
class BarcodeFindFeedback {
  final Feedback? found;
  final Feedback? itemListUpdated;

  const BarcodeFindFeedback({
    this.found,
    this.itemListUpdated,
  });

  factory BarcodeFindFeedback.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('BarcodeFindFeedback: expected a Map');
    }
    const allowedKeys = <String>{
      'found',
      'itemListUpdated',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("BarcodeFindFeedback: unknown property '$key'");
      }
    }
    final hasFound = raw.containsKey('found');
    final foundRaw = raw['found'];
    Feedback? foundValue;
    if (hasFound && foundRaw != null) {
      foundValue = Feedback.fromJson(foundRaw);
    } else if (hasFound && foundRaw == null) {
      throw FormatException('BarcodeFindFeedback.found: null is not allowed');
    }
    final hasItemListUpdated = raw.containsKey('itemListUpdated');
    final itemListUpdatedRaw = raw['itemListUpdated'];
    Feedback? itemListUpdatedValue;
    if (hasItemListUpdated && itemListUpdatedRaw != null) {
      itemListUpdatedValue = Feedback.fromJson(itemListUpdatedRaw);
    } else if (hasItemListUpdated && itemListUpdatedRaw == null) {
      throw FormatException('BarcodeFindFeedback.itemListUpdated: null is not allowed');
    }
    return BarcodeFindFeedback(
      found: foundValue,
      itemListUpdated: itemListUpdatedValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (found != null) {
      map['found'] = found!.toJson();
    }
    if (itemListUpdated != null) {
      map['itemListUpdated'] = itemListUpdated!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `BarcodeFindFeedback` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildBarcodeFindFeedback({
  Object? found,
  Object? itemListUpdated,
}) {
  final map = <String, Object?>{};
  if (found != null) {
    map['found'] = found;
  }
  if (itemListUpdated != null) {
    map['itemListUpdated'] = itemListUpdated;
  }
  return map;
}

/// The BarcodeAR capture mode for augmented reality barcode scanning.
class BarcodeAr implements Mode {
  final String type;
  final BarcodeArSettings? settings;
  final BarcodeArFeedback? feedback;
  final bool? hasModeListener;
  final bool? hasBarcodeFilter;

  const BarcodeAr({
    required this.type,
    this.settings,
    this.feedback,
    this.hasModeListener,
    this.hasBarcodeFilter,
  });

  factory BarcodeAr.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('BarcodeAr: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'settings',
      'feedback',
      'hasModeListener',
      'hasBarcodeFilter',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("BarcodeAr: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("BarcodeAr.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['barcodeAr'].contains(typeRaw)) {
        throw FormatException("BarcodeAr.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('BarcodeAr.type: null is not allowed');
    }
    final hasSettings = raw.containsKey('settings');
    final settingsRaw = raw['settings'];
    BarcodeArSettings? settingsValue;
    if (hasSettings && settingsRaw != null) {
      settingsValue = BarcodeArSettings.fromJson(settingsRaw);
    } else if (hasSettings && settingsRaw == null) {
      throw FormatException('BarcodeAr.settings: null is not allowed');
    }
    final hasFeedback = raw.containsKey('feedback');
    final feedbackRaw = raw['feedback'];
    BarcodeArFeedback? feedbackValue;
    if (hasFeedback && feedbackRaw != null) {
      feedbackValue = BarcodeArFeedback.fromJson(feedbackRaw);
    } else if (hasFeedback && feedbackRaw == null) {
      throw FormatException('BarcodeAr.feedback: null is not allowed');
    }
    final hasHasModeListener = raw.containsKey('hasModeListener');
    final hasModeListenerRaw = raw['hasModeListener'];
    bool? hasModeListenerValue;
    if (hasHasModeListener && hasModeListenerRaw != null) {
      if (hasModeListenerRaw is! bool) {
        throw FormatException('BarcodeAr.hasModeListener: expected a bool');
      }
      hasModeListenerValue = hasModeListenerRaw;
    } else if (hasHasModeListener && hasModeListenerRaw == null) {
      throw FormatException('BarcodeAr.hasModeListener: null is not allowed');
    }
    final hasHasBarcodeFilter = raw.containsKey('hasBarcodeFilter');
    final hasBarcodeFilterRaw = raw['hasBarcodeFilter'];
    bool? hasBarcodeFilterValue;
    if (hasHasBarcodeFilter && hasBarcodeFilterRaw != null) {
      if (hasBarcodeFilterRaw is! bool) {
        throw FormatException('BarcodeAr.hasBarcodeFilter: expected a bool');
      }
      hasBarcodeFilterValue = hasBarcodeFilterRaw;
    } else if (hasHasBarcodeFilter && hasBarcodeFilterRaw == null) {
      throw FormatException('BarcodeAr.hasBarcodeFilter: null is not allowed');
    }
    return BarcodeAr(
      type: typeValue!,
      settings: settingsValue,
      feedback: feedbackValue,
      hasModeListener: hasModeListenerValue,
      hasBarcodeFilter: hasBarcodeFilterValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (settings != null) {
      map['settings'] = settings!.toJson();
    }
    if (feedback != null) {
      map['feedback'] = feedback!.toJson();
    }
    if (hasModeListener != null) {
      map['hasModeListener'] = hasModeListener;
    }
    if (hasBarcodeFilter != null) {
      map['hasBarcodeFilter'] = hasBarcodeFilter;
    }
    return map;
  }
}

/// Typed builder for the `BarcodeAr` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildBarcodeAr({
  required String type,
  Object? settings,
  Object? feedback,
  bool? hasModeListener,
  bool? hasBarcodeFilter,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (settings != null) {
    map['settings'] = settings;
  }
  if (feedback != null) {
    map['feedback'] = feedback;
  }
  if (hasModeListener != null) {
    map['hasModeListener'] = hasModeListener;
  }
  if (hasBarcodeFilter != null) {
    map['hasBarcodeFilter'] = hasBarcodeFilter;
  }
  return map;
}

/// Settings configuring barcode recognition for BarcodeAR.
class BarcodeArSettings {
  final SymbologySettings? symbologies;
  final bool? expectOnlyUniqueBarcodes;

  /// Keys present in the payload that have no emitted field -- undeclared
  /// keys, plus schema-declared properties that are `hidden` or non-mobile and
  /// therefore get no field of their own. Re-emitted by [toJson] so the round
  /// trip is lossless. See the passthrough contract in this file's header.
  final Map<String, Object?> additionalProperties;

  const BarcodeArSettings({
    this.symbologies,
    this.expectOnlyUniqueBarcodes,
    this.additionalProperties = const {},
  });

  factory BarcodeArSettings.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('BarcodeArSettings: expected a Map');
    }
    final hasSymbologies = raw.containsKey('symbologies');
    final symbologiesRaw = raw['symbologies'];
    SymbologySettings? symbologiesValue;
    if (hasSymbologies && symbologiesRaw != null) {
      symbologiesValue = parseSymbologySettings(symbologiesRaw);
    } else if (hasSymbologies && symbologiesRaw == null) {
      throw FormatException('BarcodeArSettings.symbologies: null is not allowed');
    }
    final hasExpectOnlyUniqueBarcodes = raw.containsKey('expectOnlyUniqueBarcodes');
    final expectOnlyUniqueBarcodesRaw = raw['expectOnlyUniqueBarcodes'];
    bool? expectOnlyUniqueBarcodesValue;
    if (hasExpectOnlyUniqueBarcodes && expectOnlyUniqueBarcodesRaw != null) {
      if (expectOnlyUniqueBarcodesRaw is! bool) {
        throw FormatException('BarcodeArSettings.expectOnlyUniqueBarcodes: expected a bool');
      }
      expectOnlyUniqueBarcodesValue = expectOnlyUniqueBarcodesRaw;
    } else if (hasExpectOnlyUniqueBarcodes && expectOnlyUniqueBarcodesRaw == null) {
      throw FormatException('BarcodeArSettings.expectOnlyUniqueBarcodes: null is not allowed');
    }
    const emittedKeys = <String>{
      'symbologies',
      'expectOnlyUniqueBarcodes',
    };
    final additionalPropertiesCollected = <String, Object?>{};
    for (final key in raw.keys) {
      // A non-String key never matches `emittedKeys` (a Set<String>), so
      // every one of them reaches this throw: an open class rejects
      // non-String keys outright.
      if (!emittedKeys.contains(key)) {
        if (key is! String) {
          throw FormatException('BarcodeArSettings: expected a String key');
        }
        additionalPropertiesCollected[key] = raw[key];
      }
    }
    return BarcodeArSettings(
      symbologies: symbologiesValue,
      expectOnlyUniqueBarcodes: expectOnlyUniqueBarcodesValue,
      additionalProperties: Map.unmodifiable(additionalPropertiesCollected),
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (symbologies != null) {
      map['symbologies'] = symbologies;
    }
    if (expectOnlyUniqueBarcodes != null) {
      map['expectOnlyUniqueBarcodes'] = expectOnlyUniqueBarcodes;
    }
    for (final entry in additionalProperties.entries) {
      if (!map.containsKey(entry.key)) {
        map[entry.key] = entry.value;
      }
    }
    return map;
  }
}

/// Typed builder for the `BarcodeArSettings` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildBarcodeArSettings({
  SymbologySettings? symbologies,
  bool? expectOnlyUniqueBarcodes,
}) {
  final map = <String, Object?>{};
  if (symbologies != null) {
    map['symbologies'] = symbologies;
  }
  if (expectOnlyUniqueBarcodes != null) {
    map['expectOnlyUniqueBarcodes'] = expectOnlyUniqueBarcodes;
  }
  return map;
}

/// Feedback configuration for BarcodeAR events.
class BarcodeArFeedback {
  final Feedback? scanned;
  final Feedback? tapped;

  const BarcodeArFeedback({
    this.scanned,
    this.tapped,
  });

  factory BarcodeArFeedback.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('BarcodeArFeedback: expected a Map');
    }
    const allowedKeys = <String>{
      'scanned',
      'tapped',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("BarcodeArFeedback: unknown property '$key'");
      }
    }
    final hasScanned = raw.containsKey('scanned');
    final scannedRaw = raw['scanned'];
    Feedback? scannedValue;
    if (hasScanned && scannedRaw != null) {
      scannedValue = Feedback.fromJson(scannedRaw);
    } else if (hasScanned && scannedRaw == null) {
      throw FormatException('BarcodeArFeedback.scanned: null is not allowed');
    }
    final hasTapped = raw.containsKey('tapped');
    final tappedRaw = raw['tapped'];
    Feedback? tappedValue;
    if (hasTapped && tappedRaw != null) {
      tappedValue = Feedback.fromJson(tappedRaw);
    } else if (hasTapped && tappedRaw == null) {
      throw FormatException('BarcodeArFeedback.tapped: null is not allowed');
    }
    return BarcodeArFeedback(
      scanned: scannedValue,
      tapped: tappedValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (scanned != null) {
      map['scanned'] = scanned!.toJson();
    }
    if (tapped != null) {
      map['tapped'] = tapped!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `BarcodeArFeedback` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildBarcodeArFeedback({
  Object? scanned,
  Object? tapped,
}) {
  final map = <String, Object?>{};
  if (scanned != null) {
    map['scanned'] = scanned;
  }
  if (tapped != null) {
    map['tapped'] = tapped;
  }
  return map;
}

/// The BarcodePick capture mode for picking barcodes from a list.
class BarcodePick implements Mode {
  final String type;
  final BarcodePickSettings? settings;

  const BarcodePick({
    required this.type,
    this.settings,
  });

  factory BarcodePick.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('BarcodePick: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'settings',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("BarcodePick: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("BarcodePick.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['barcodePick'].contains(typeRaw)) {
        throw FormatException("BarcodePick.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('BarcodePick.type: null is not allowed');
    }
    final hasSettings = raw.containsKey('settings');
    final settingsRaw = raw['settings'];
    BarcodePickSettings? settingsValue;
    if (hasSettings && settingsRaw != null) {
      settingsValue = BarcodePickSettings.fromJson(settingsRaw);
    } else if (hasSettings && settingsRaw == null) {
      throw FormatException('BarcodePick.settings: null is not allowed');
    }
    return BarcodePick(
      type: typeValue!,
      settings: settingsValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (settings != null) {
      map['settings'] = settings!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `BarcodePick` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildBarcodePick({
  required String type,
  Object? settings,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (settings != null) {
    map['settings'] = settings;
  }
  return map;
}

/// Settings configuring barcode recognition for BarcodePick.
class BarcodePickSettings {
  final SymbologySettings? symbologies;
  final bool? soundEnabled;
  final bool? hapticEnabled;
  final bool? cachingEnabled;
  final BarcodeFilterSettings? filterSettings;

  /// Keys present in the payload that have no emitted field -- undeclared
  /// keys, plus schema-declared properties that are `hidden` or non-mobile and
  /// therefore get no field of their own. Re-emitted by [toJson] so the round
  /// trip is lossless. See the passthrough contract in this file's header.
  final Map<String, Object?> additionalProperties;

  const BarcodePickSettings({
    this.symbologies,
    this.soundEnabled,
    this.hapticEnabled,
    this.cachingEnabled,
    this.filterSettings,
    this.additionalProperties = const {},
  });

  factory BarcodePickSettings.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('BarcodePickSettings: expected a Map');
    }
    final hasSymbologies = raw.containsKey('symbologies');
    final symbologiesRaw = raw['symbologies'];
    SymbologySettings? symbologiesValue;
    if (hasSymbologies && symbologiesRaw != null) {
      symbologiesValue = parseSymbologySettings(symbologiesRaw);
    } else if (hasSymbologies && symbologiesRaw == null) {
      throw FormatException('BarcodePickSettings.symbologies: null is not allowed');
    }
    final hasSoundEnabled = raw.containsKey('soundEnabled');
    final soundEnabledRaw = raw['soundEnabled'];
    bool? soundEnabledValue;
    if (hasSoundEnabled && soundEnabledRaw != null) {
      if (soundEnabledRaw is! bool) {
        throw FormatException('BarcodePickSettings.soundEnabled: expected a bool');
      }
      soundEnabledValue = soundEnabledRaw;
    } else if (hasSoundEnabled && soundEnabledRaw == null) {
      throw FormatException('BarcodePickSettings.soundEnabled: null is not allowed');
    }
    final hasHapticEnabled = raw.containsKey('hapticEnabled');
    final hapticEnabledRaw = raw['hapticEnabled'];
    bool? hapticEnabledValue;
    if (hasHapticEnabled && hapticEnabledRaw != null) {
      if (hapticEnabledRaw is! bool) {
        throw FormatException('BarcodePickSettings.hapticEnabled: expected a bool');
      }
      hapticEnabledValue = hapticEnabledRaw;
    } else if (hasHapticEnabled && hapticEnabledRaw == null) {
      throw FormatException('BarcodePickSettings.hapticEnabled: null is not allowed');
    }
    final hasCachingEnabled = raw.containsKey('cachingEnabled');
    final cachingEnabledRaw = raw['cachingEnabled'];
    bool? cachingEnabledValue;
    if (hasCachingEnabled && cachingEnabledRaw != null) {
      if (cachingEnabledRaw is! bool) {
        throw FormatException('BarcodePickSettings.cachingEnabled: expected a bool');
      }
      cachingEnabledValue = cachingEnabledRaw;
    } else if (hasCachingEnabled && cachingEnabledRaw == null) {
      throw FormatException('BarcodePickSettings.cachingEnabled: null is not allowed');
    }
    final hasFilterSettings = raw.containsKey('filterSettings');
    final filterSettingsRaw = raw['filterSettings'];
    BarcodeFilterSettings? filterSettingsValue;
    if (hasFilterSettings && filterSettingsRaw != null) {
      filterSettingsValue = BarcodeFilterSettings.fromJson(filterSettingsRaw);
    } else if (hasFilterSettings && filterSettingsRaw == null) {
      throw FormatException('BarcodePickSettings.filterSettings: null is not allowed');
    }
    const emittedKeys = <String>{
      'symbologies',
      'soundEnabled',
      'hapticEnabled',
      'cachingEnabled',
      'filterSettings',
    };
    final additionalPropertiesCollected = <String, Object?>{};
    for (final key in raw.keys) {
      // A non-String key never matches `emittedKeys` (a Set<String>), so
      // every one of them reaches this throw: an open class rejects
      // non-String keys outright.
      if (!emittedKeys.contains(key)) {
        if (key is! String) {
          throw FormatException('BarcodePickSettings: expected a String key');
        }
        additionalPropertiesCollected[key] = raw[key];
      }
    }
    return BarcodePickSettings(
      symbologies: symbologiesValue,
      soundEnabled: soundEnabledValue,
      hapticEnabled: hapticEnabledValue,
      cachingEnabled: cachingEnabledValue,
      filterSettings: filterSettingsValue,
      additionalProperties: Map.unmodifiable(additionalPropertiesCollected),
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (symbologies != null) {
      map['symbologies'] = symbologies;
    }
    if (soundEnabled != null) {
      map['soundEnabled'] = soundEnabled;
    }
    if (hapticEnabled != null) {
      map['hapticEnabled'] = hapticEnabled;
    }
    if (cachingEnabled != null) {
      map['cachingEnabled'] = cachingEnabled;
    }
    if (filterSettings != null) {
      map['filterSettings'] = filterSettings!.toJson();
    }
    for (final entry in additionalProperties.entries) {
      if (!map.containsKey(entry.key)) {
        map[entry.key] = entry.value;
      }
    }
    return map;
  }
}

/// Typed builder for the `BarcodePickSettings` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildBarcodePickSettings({
  SymbologySettings? symbologies,
  bool? soundEnabled,
  bool? hapticEnabled,
  bool? cachingEnabled,
  Object? filterSettings,
}) {
  final map = <String, Object?>{};
  if (symbologies != null) {
    map['symbologies'] = symbologies;
  }
  if (soundEnabled != null) {
    map['soundEnabled'] = soundEnabled;
  }
  if (hapticEnabled != null) {
    map['hapticEnabled'] = hapticEnabled;
  }
  if (cachingEnabled != null) {
    map['cachingEnabled'] = cachingEnabled;
  }
  if (filterSettings != null) {
    map['filterSettings'] = filterSettings;
  }
  return map;
}

/// Settings for filtering out barcodes from scan results.
class BarcodeFilterSettings {
  final List<Symbology>? excludedSymbologies;
  final Object? excludedSymbolCounts;
  final String? excludedCodesRegex;
  final bool? excludeEan13;
  final bool? excludeUpca;

  const BarcodeFilterSettings({
    this.excludedSymbologies,
    this.excludedSymbolCounts,
    this.excludedCodesRegex,
    this.excludeEan13,
    this.excludeUpca,
  });

  factory BarcodeFilterSettings.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('BarcodeFilterSettings: expected a Map');
    }
    const allowedKeys = <String>{
      'excludedSymbologies',
      'excludedSymbolCounts',
      'excludedCodesRegex',
      'excludeEan13',
      'excludeUpca',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("BarcodeFilterSettings: unknown property '$key'");
      }
    }
    final hasExcludedSymbologies = raw.containsKey('excludedSymbologies');
    final excludedSymbologiesRaw = raw['excludedSymbologies'];
    List<Symbology>? excludedSymbologiesValue;
    if (hasExcludedSymbologies && excludedSymbologiesRaw != null) {
      if (excludedSymbologiesRaw is! List) {
        throw FormatException('BarcodeFilterSettings.excludedSymbologies: expected a List');
      }
      excludedSymbologiesValue = excludedSymbologiesRaw
          .map((item) => (item is! String
              ? (throw FormatException('BarcodeFilterSettings.excludedSymbologies: expected a String for Symbology'))
              : Symbology.fromJSON(item)))
          .toList();
    } else if (hasExcludedSymbologies && excludedSymbologiesRaw == null) {
      throw FormatException('BarcodeFilterSettings.excludedSymbologies: null is not allowed');
    }
    final hasExcludedSymbolCounts = raw.containsKey('excludedSymbolCounts');
    final excludedSymbolCountsRaw = raw['excludedSymbolCounts'];
    Object? excludedSymbolCountsValue;
    if (hasExcludedSymbolCounts && excludedSymbolCountsRaw != null) {
      excludedSymbolCountsValue = excludedSymbolCountsRaw;
    } else if (hasExcludedSymbolCounts && excludedSymbolCountsRaw == null) {
      throw FormatException('BarcodeFilterSettings.excludedSymbolCounts: null is not allowed');
    }
    final hasExcludedCodesRegex = raw.containsKey('excludedCodesRegex');
    final excludedCodesRegexRaw = raw['excludedCodesRegex'];
    String? excludedCodesRegexValue;
    if (hasExcludedCodesRegex && excludedCodesRegexRaw != null) {
      if (excludedCodesRegexRaw is! String) {
        throw FormatException('BarcodeFilterSettings.excludedCodesRegex: expected a String');
      }
      excludedCodesRegexValue = excludedCodesRegexRaw;
    } else if (hasExcludedCodesRegex && excludedCodesRegexRaw == null) {
      throw FormatException('BarcodeFilterSettings.excludedCodesRegex: null is not allowed');
    }
    final hasExcludeEan13 = raw.containsKey('excludeEan13');
    final excludeEan13Raw = raw['excludeEan13'];
    bool? excludeEan13Value;
    if (hasExcludeEan13 && excludeEan13Raw != null) {
      if (excludeEan13Raw is! bool) {
        throw FormatException('BarcodeFilterSettings.excludeEan13: expected a bool');
      }
      excludeEan13Value = excludeEan13Raw;
    } else if (hasExcludeEan13 && excludeEan13Raw == null) {
      throw FormatException('BarcodeFilterSettings.excludeEan13: null is not allowed');
    }
    final hasExcludeUpca = raw.containsKey('excludeUpca');
    final excludeUpcaRaw = raw['excludeUpca'];
    bool? excludeUpcaValue;
    if (hasExcludeUpca && excludeUpcaRaw != null) {
      if (excludeUpcaRaw is! bool) {
        throw FormatException('BarcodeFilterSettings.excludeUpca: expected a bool');
      }
      excludeUpcaValue = excludeUpcaRaw;
    } else if (hasExcludeUpca && excludeUpcaRaw == null) {
      throw FormatException('BarcodeFilterSettings.excludeUpca: null is not allowed');
    }
    return BarcodeFilterSettings(
      excludedSymbologies: excludedSymbologiesValue,
      excludedSymbolCounts: excludedSymbolCountsValue,
      excludedCodesRegex: excludedCodesRegexValue,
      excludeEan13: excludeEan13Value,
      excludeUpca: excludeUpcaValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (excludedSymbologies != null) {
      map['excludedSymbologies'] = excludedSymbologies!.map((item) => item.toJson()).toList();
    }
    if (excludedSymbolCounts != null) {
      map['excludedSymbolCounts'] = excludedSymbolCounts;
    }
    if (excludedCodesRegex != null) {
      map['excludedCodesRegex'] = excludedCodesRegex;
    }
    if (excludeEan13 != null) {
      map['excludeEan13'] = excludeEan13;
    }
    if (excludeUpca != null) {
      map['excludeUpca'] = excludeUpca;
    }
    return map;
  }
}

/// Typed builder for the `BarcodeFilterSettings` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildBarcodeFilterSettings({
  List<Object?>? excludedSymbologies,
  Object? excludedSymbolCounts,
  String? excludedCodesRegex,
  bool? excludeEan13,
  bool? excludeUpca,
}) {
  final map = <String, Object?>{};
  if (excludedSymbologies != null) {
    map['excludedSymbologies'] = excludedSymbologies;
  }
  if (excludedSymbolCounts != null) {
    map['excludedSymbolCounts'] = excludedSymbolCounts;
  }
  if (excludedCodesRegex != null) {
    map['excludedCodesRegex'] = excludedCodesRegex;
  }
  if (excludeEan13 != null) {
    map['excludeEan13'] = excludeEan13;
  }
  if (excludeUpca != null) {
    map['excludeUpca'] = excludeUpca;
  }
  return map;
}

/// A barcode symbology identifier.
enum Symbology {
  ean13Upca('ean13Upca'),
  ean8('ean8'),
  upce('upce'),
  code11('code11'),
  code25('code25'),
  code32('code32'),
  code39('code39'),
  code93('code93'),
  code128('code128'),
  interleavedTwoOfFive('interleavedTwoOfFive'),
  qr('qr'),
  microQr('microQr'),
  dataMatrix('dataMatrix'),
  pdf417('pdf417'),
  microPdf417('microPdf417'),
  msiPlessey('msiPlessey'),
  databar('databar'),
  databarLimited('databarLimited'),
  databarExpanded('databarExpanded'),
  codabar('codabar'),
  aztec('aztec'),
  dotcode('dotcode'),
  maxicode('maxicode'),
  kix('kix'),
  royal_mail_4state('royal-mail-4state'),
  lapa4sc('lapa4sc'),
  iata2of5('iata2of5'),
  matrix2of5('matrix2of5'),
  uspsIntelligentMail('uspsIntelligentMail'),
  aruco('aruco'),
  upu_4state('upu-4state'),
  australian_post_4state('australian-post-4state'),
  french_post('french-post'),
  hanXin('hanXin');

  const Symbology(this.jsonValue);

  final String jsonValue;

  static Symbology fromJSON(String jsonValue) {
    for (final value in Symbology.values) {
      if (value.jsonValue == jsonValue) {
        return value;
      }
    }
    throw FormatException("Symbology: unknown enum value '$jsonValue'");
  }

  String toJson() => jsonValue;
}

/// The BarcodeCount capture mode for counting barcodes.
class BarcodeCount implements Mode {
  final String type;
  final BarcodeCountSettings? settings;
  final List<Barcode>? additionalBarcodes;
  final BarcodeCountFeedback? feedback;
  final bool? isEnabled;
  final bool? hasListeners;

  const BarcodeCount({
    required this.type,
    this.settings,
    this.additionalBarcodes,
    this.feedback,
    this.isEnabled,
    this.hasListeners,
  });

  factory BarcodeCount.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('BarcodeCount: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'settings',
      'additionalBarcodes',
      'feedback',
      'isEnabled',
      'hasListeners',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("BarcodeCount: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("BarcodeCount.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['barcodeCount'].contains(typeRaw)) {
        throw FormatException("BarcodeCount.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('BarcodeCount.type: null is not allowed');
    }
    final hasSettings = raw.containsKey('settings');
    final settingsRaw = raw['settings'];
    BarcodeCountSettings? settingsValue;
    if (hasSettings && settingsRaw != null) {
      settingsValue = BarcodeCountSettings.fromJson(settingsRaw);
    } else if (hasSettings && settingsRaw == null) {
      throw FormatException('BarcodeCount.settings: null is not allowed');
    }
    final hasAdditionalBarcodes = raw.containsKey('additionalBarcodes');
    final additionalBarcodesRaw = raw['additionalBarcodes'];
    List<Barcode>? additionalBarcodesValue;
    if (hasAdditionalBarcodes && additionalBarcodesRaw != null) {
      if (additionalBarcodesRaw is! List) {
        throw FormatException('BarcodeCount.additionalBarcodes: expected a List');
      }
      additionalBarcodesValue = additionalBarcodesRaw.map((item) => Barcode.fromJson(item)).toList();
    } else if (hasAdditionalBarcodes && additionalBarcodesRaw == null) {
      throw FormatException('BarcodeCount.additionalBarcodes: null is not allowed');
    }
    final hasFeedback = raw.containsKey('feedback');
    final feedbackRaw = raw['feedback'];
    BarcodeCountFeedback? feedbackValue;
    if (hasFeedback && feedbackRaw != null) {
      feedbackValue = BarcodeCountFeedback.fromJson(feedbackRaw);
    } else if (hasFeedback && feedbackRaw == null) {
      throw FormatException('BarcodeCount.feedback: null is not allowed');
    }
    final hasIsEnabled = raw.containsKey('isEnabled');
    final isEnabledRaw = raw['isEnabled'];
    bool? isEnabledValue;
    if (hasIsEnabled && isEnabledRaw != null) {
      if (isEnabledRaw is! bool) {
        throw FormatException('BarcodeCount.isEnabled: expected a bool');
      }
      isEnabledValue = isEnabledRaw;
    } else if (hasIsEnabled && isEnabledRaw == null) {
      throw FormatException('BarcodeCount.isEnabled: null is not allowed');
    }
    final hasHasListeners = raw.containsKey('hasListeners');
    final hasListenersRaw = raw['hasListeners'];
    bool? hasListenersValue;
    if (hasHasListeners && hasListenersRaw != null) {
      if (hasListenersRaw is! bool) {
        throw FormatException('BarcodeCount.hasListeners: expected a bool');
      }
      hasListenersValue = hasListenersRaw;
    } else if (hasHasListeners && hasListenersRaw == null) {
      throw FormatException('BarcodeCount.hasListeners: null is not allowed');
    }
    return BarcodeCount(
      type: typeValue!,
      settings: settingsValue,
      additionalBarcodes: additionalBarcodesValue,
      feedback: feedbackValue,
      isEnabled: isEnabledValue,
      hasListeners: hasListenersValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (settings != null) {
      map['settings'] = settings!.toJson();
    }
    if (additionalBarcodes != null) {
      map['additionalBarcodes'] = additionalBarcodes!.map((item) => item.toJson()).toList();
    }
    if (feedback != null) {
      map['feedback'] = feedback!.toJson();
    }
    if (isEnabled != null) {
      map['isEnabled'] = isEnabled;
    }
    if (hasListeners != null) {
      map['hasListeners'] = hasListeners;
    }
    return map;
  }
}

/// Typed builder for the `BarcodeCount` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildBarcodeCount({
  required String type,
  Object? settings,
  List<Object?>? additionalBarcodes,
  Object? feedback,
  bool? isEnabled,
  bool? hasListeners,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (settings != null) {
    map['settings'] = settings;
  }
  if (additionalBarcodes != null) {
    map['additionalBarcodes'] = additionalBarcodes;
  }
  if (feedback != null) {
    map['feedback'] = feedback;
  }
  if (isEnabled != null) {
    map['isEnabled'] = isEnabled;
  }
  if (hasListeners != null) {
    map['hasListeners'] = hasListeners;
  }
  return map;
}

/// Settings configuring barcode recognition for BarcodeCount.
class BarcodeCountSettings {
  final SymbologySettings? symbologies;
  final bool? expectOnlyUniqueBarcodes;
  final BarcodeFilterSettings? barcodeFilterSettings;
  final bool? disableModeWhenCaptureListCompleted;
  final bool? mappingEnabled;
  final bool? tapToUncountEnabled;
  final bool? shouldShowUnscannedBarcodes;
  final String? clusteringMode;
  final String? automaticClusteringMethod;
  final int? expectedBarcodesPerCluster;
  final bool? groupScanningEnabled;

  /// Keys present in the payload that have no emitted field -- undeclared
  /// keys, plus schema-declared properties that are `hidden` or non-mobile and
  /// therefore get no field of their own. Re-emitted by [toJson] so the round
  /// trip is lossless. See the passthrough contract in this file's header.
  final Map<String, Object?> additionalProperties;

  const BarcodeCountSettings({
    this.symbologies,
    this.expectOnlyUniqueBarcodes,
    this.barcodeFilterSettings,
    this.disableModeWhenCaptureListCompleted,
    this.mappingEnabled,
    this.tapToUncountEnabled,
    this.shouldShowUnscannedBarcodes,
    this.clusteringMode,
    this.automaticClusteringMethod,
    this.expectedBarcodesPerCluster,
    this.groupScanningEnabled,
    this.additionalProperties = const {},
  });

  factory BarcodeCountSettings.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('BarcodeCountSettings: expected a Map');
    }
    final hasSymbologies = raw.containsKey('symbologies');
    final symbologiesRaw = raw['symbologies'];
    SymbologySettings? symbologiesValue;
    if (hasSymbologies && symbologiesRaw != null) {
      symbologiesValue = parseSymbologySettings(symbologiesRaw);
    } else if (hasSymbologies && symbologiesRaw == null) {
      throw FormatException('BarcodeCountSettings.symbologies: null is not allowed');
    }
    final hasExpectOnlyUniqueBarcodes = raw.containsKey('expectOnlyUniqueBarcodes');
    final expectOnlyUniqueBarcodesRaw = raw['expectOnlyUniqueBarcodes'];
    bool? expectOnlyUniqueBarcodesValue;
    if (hasExpectOnlyUniqueBarcodes && expectOnlyUniqueBarcodesRaw != null) {
      if (expectOnlyUniqueBarcodesRaw is! bool) {
        throw FormatException('BarcodeCountSettings.expectOnlyUniqueBarcodes: expected a bool');
      }
      expectOnlyUniqueBarcodesValue = expectOnlyUniqueBarcodesRaw;
    } else if (hasExpectOnlyUniqueBarcodes && expectOnlyUniqueBarcodesRaw == null) {
      throw FormatException('BarcodeCountSettings.expectOnlyUniqueBarcodes: null is not allowed');
    }
    final hasBarcodeFilterSettings = raw.containsKey('barcodeFilterSettings');
    final barcodeFilterSettingsRaw = raw['barcodeFilterSettings'];
    BarcodeFilterSettings? barcodeFilterSettingsValue;
    if (hasBarcodeFilterSettings && barcodeFilterSettingsRaw != null) {
      barcodeFilterSettingsValue = BarcodeFilterSettings.fromJson(barcodeFilterSettingsRaw);
    } else if (hasBarcodeFilterSettings && barcodeFilterSettingsRaw == null) {
      throw FormatException('BarcodeCountSettings.barcodeFilterSettings: null is not allowed');
    }
    final hasDisableModeWhenCaptureListCompleted = raw.containsKey('disableModeWhenCaptureListCompleted');
    final disableModeWhenCaptureListCompletedRaw = raw['disableModeWhenCaptureListCompleted'];
    bool? disableModeWhenCaptureListCompletedValue;
    if (hasDisableModeWhenCaptureListCompleted && disableModeWhenCaptureListCompletedRaw != null) {
      if (disableModeWhenCaptureListCompletedRaw is! bool) {
        throw FormatException('BarcodeCountSettings.disableModeWhenCaptureListCompleted: expected a bool');
      }
      disableModeWhenCaptureListCompletedValue = disableModeWhenCaptureListCompletedRaw;
    } else if (hasDisableModeWhenCaptureListCompleted && disableModeWhenCaptureListCompletedRaw == null) {
      throw FormatException('BarcodeCountSettings.disableModeWhenCaptureListCompleted: null is not allowed');
    }
    final hasMappingEnabled = raw.containsKey('mappingEnabled');
    final mappingEnabledRaw = raw['mappingEnabled'];
    bool? mappingEnabledValue;
    if (hasMappingEnabled && mappingEnabledRaw != null) {
      if (mappingEnabledRaw is! bool) {
        throw FormatException('BarcodeCountSettings.mappingEnabled: expected a bool');
      }
      mappingEnabledValue = mappingEnabledRaw;
    } else if (hasMappingEnabled && mappingEnabledRaw == null) {
      throw FormatException('BarcodeCountSettings.mappingEnabled: null is not allowed');
    }
    final hasTapToUncountEnabled = raw.containsKey('tapToUncountEnabled');
    final tapToUncountEnabledRaw = raw['tapToUncountEnabled'];
    bool? tapToUncountEnabledValue;
    if (hasTapToUncountEnabled && tapToUncountEnabledRaw != null) {
      if (tapToUncountEnabledRaw is! bool) {
        throw FormatException('BarcodeCountSettings.tapToUncountEnabled: expected a bool');
      }
      tapToUncountEnabledValue = tapToUncountEnabledRaw;
    } else if (hasTapToUncountEnabled && tapToUncountEnabledRaw == null) {
      throw FormatException('BarcodeCountSettings.tapToUncountEnabled: null is not allowed');
    }
    final hasShouldShowUnscannedBarcodes = raw.containsKey('shouldShowUnscannedBarcodes');
    final shouldShowUnscannedBarcodesRaw = raw['shouldShowUnscannedBarcodes'];
    bool? shouldShowUnscannedBarcodesValue;
    if (hasShouldShowUnscannedBarcodes && shouldShowUnscannedBarcodesRaw != null) {
      if (shouldShowUnscannedBarcodesRaw is! bool) {
        throw FormatException('BarcodeCountSettings.shouldShowUnscannedBarcodes: expected a bool');
      }
      shouldShowUnscannedBarcodesValue = shouldShowUnscannedBarcodesRaw;
    } else if (hasShouldShowUnscannedBarcodes && shouldShowUnscannedBarcodesRaw == null) {
      throw FormatException('BarcodeCountSettings.shouldShowUnscannedBarcodes: null is not allowed');
    }
    final hasClusteringMode = raw.containsKey('clusteringMode');
    final clusteringModeRaw = raw['clusteringMode'];
    String? clusteringModeValue;
    if (hasClusteringMode && clusteringModeRaw != null) {
      if (clusteringModeRaw is! String ||
          !const <String>['disabled', 'manual', 'auto', 'autoWithManualCorrection'].contains(clusteringModeRaw)) {
        throw FormatException("BarcodeCountSettings.clusteringMode: unknown enum value '$clusteringModeRaw'");
      }
      clusteringModeValue = clusteringModeRaw;
    } else if (hasClusteringMode && clusteringModeRaw == null) {
      throw FormatException('BarcodeCountSettings.clusteringMode: null is not allowed');
    }
    final hasAutomaticClusteringMethod = raw.containsKey('automaticClusteringMethod');
    final automaticClusteringMethodRaw = raw['automaticClusteringMethod'];
    String? automaticClusteringMethodValue;
    if (hasAutomaticClusteringMethod && automaticClusteringMethodRaw != null) {
      if (automaticClusteringMethodRaw is! String ||
          !const <String>['vicinity', 'label', 'outline'].contains(automaticClusteringMethodRaw)) {
        throw FormatException(
            "BarcodeCountSettings.automaticClusteringMethod: unknown enum value '$automaticClusteringMethodRaw'");
      }
      automaticClusteringMethodValue = automaticClusteringMethodRaw;
    }
    final hasExpectedBarcodesPerCluster = raw.containsKey('expectedBarcodesPerCluster');
    final expectedBarcodesPerClusterRaw = raw['expectedBarcodesPerCluster'];
    int? expectedBarcodesPerClusterValue;
    if (hasExpectedBarcodesPerCluster && expectedBarcodesPerClusterRaw != null) {
      if (expectedBarcodesPerClusterRaw is! num) {
        throw FormatException('BarcodeCountSettings.expectedBarcodesPerCluster: expected a number');
      }
      if (expectedBarcodesPerClusterRaw != expectedBarcodesPerClusterRaw.toInt()) {
        throw FormatException('BarcodeCountSettings.expectedBarcodesPerCluster: expected an integer');
      }
      expectedBarcodesPerClusterValue = expectedBarcodesPerClusterRaw.toInt();
    }
    final hasGroupScanningEnabled = raw.containsKey('groupScanningEnabled');
    final groupScanningEnabledRaw = raw['groupScanningEnabled'];
    bool? groupScanningEnabledValue;
    if (hasGroupScanningEnabled && groupScanningEnabledRaw != null) {
      if (groupScanningEnabledRaw is! bool) {
        throw FormatException('BarcodeCountSettings.groupScanningEnabled: expected a bool');
      }
      groupScanningEnabledValue = groupScanningEnabledRaw;
    } else if (hasGroupScanningEnabled && groupScanningEnabledRaw == null) {
      throw FormatException('BarcodeCountSettings.groupScanningEnabled: null is not allowed');
    }
    const emittedKeys = <String>{
      'symbologies',
      'expectOnlyUniqueBarcodes',
      'barcodeFilterSettings',
      'disableModeWhenCaptureListCompleted',
      'mappingEnabled',
      'tapToUncountEnabled',
      'shouldShowUnscannedBarcodes',
      'clusteringMode',
      'automaticClusteringMethod',
      'expectedBarcodesPerCluster',
      'groupScanningEnabled',
    };
    final additionalPropertiesCollected = <String, Object?>{};
    for (final key in raw.keys) {
      // A non-String key never matches `emittedKeys` (a Set<String>), so
      // every one of them reaches this throw: an open class rejects
      // non-String keys outright.
      if (!emittedKeys.contains(key)) {
        if (key is! String) {
          throw FormatException('BarcodeCountSettings: expected a String key');
        }
        additionalPropertiesCollected[key] = raw[key];
      }
    }
    return BarcodeCountSettings(
      symbologies: symbologiesValue,
      expectOnlyUniqueBarcodes: expectOnlyUniqueBarcodesValue,
      barcodeFilterSettings: barcodeFilterSettingsValue,
      disableModeWhenCaptureListCompleted: disableModeWhenCaptureListCompletedValue,
      mappingEnabled: mappingEnabledValue,
      tapToUncountEnabled: tapToUncountEnabledValue,
      shouldShowUnscannedBarcodes: shouldShowUnscannedBarcodesValue,
      clusteringMode: clusteringModeValue,
      automaticClusteringMethod: automaticClusteringMethodValue,
      expectedBarcodesPerCluster: expectedBarcodesPerClusterValue,
      groupScanningEnabled: groupScanningEnabledValue,
      additionalProperties: Map.unmodifiable(additionalPropertiesCollected),
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (symbologies != null) {
      map['symbologies'] = symbologies;
    }
    if (expectOnlyUniqueBarcodes != null) {
      map['expectOnlyUniqueBarcodes'] = expectOnlyUniqueBarcodes;
    }
    if (barcodeFilterSettings != null) {
      map['barcodeFilterSettings'] = barcodeFilterSettings!.toJson();
    }
    if (disableModeWhenCaptureListCompleted != null) {
      map['disableModeWhenCaptureListCompleted'] = disableModeWhenCaptureListCompleted;
    }
    if (mappingEnabled != null) {
      map['mappingEnabled'] = mappingEnabled;
    }
    if (tapToUncountEnabled != null) {
      map['tapToUncountEnabled'] = tapToUncountEnabled;
    }
    if (shouldShowUnscannedBarcodes != null) {
      map['shouldShowUnscannedBarcodes'] = shouldShowUnscannedBarcodes;
    }
    if (clusteringMode != null) {
      map['clusteringMode'] = clusteringMode;
    }
    if (automaticClusteringMethod != null) {
      map['automaticClusteringMethod'] = automaticClusteringMethod;
    }
    if (expectedBarcodesPerCluster != null) {
      map['expectedBarcodesPerCluster'] = expectedBarcodesPerCluster;
    }
    if (groupScanningEnabled != null) {
      map['groupScanningEnabled'] = groupScanningEnabled;
    }
    for (final entry in additionalProperties.entries) {
      if (!map.containsKey(entry.key)) {
        map[entry.key] = entry.value;
      }
    }
    return map;
  }
}

/// Typed builder for the `BarcodeCountSettings` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildBarcodeCountSettings({
  SymbologySettings? symbologies,
  bool? expectOnlyUniqueBarcodes,
  Object? barcodeFilterSettings,
  bool? disableModeWhenCaptureListCompleted,
  bool? mappingEnabled,
  bool? tapToUncountEnabled,
  bool? shouldShowUnscannedBarcodes,
  String? clusteringMode,
  Object? automaticClusteringMethod = _unset,
  Object? expectedBarcodesPerCluster = _unset,
  bool? groupScanningEnabled,
}) {
  final map = <String, Object?>{};
  if (symbologies != null) {
    map['symbologies'] = symbologies;
  }
  if (expectOnlyUniqueBarcodes != null) {
    map['expectOnlyUniqueBarcodes'] = expectOnlyUniqueBarcodes;
  }
  if (barcodeFilterSettings != null) {
    map['barcodeFilterSettings'] = barcodeFilterSettings;
  }
  if (disableModeWhenCaptureListCompleted != null) {
    map['disableModeWhenCaptureListCompleted'] = disableModeWhenCaptureListCompleted;
  }
  if (mappingEnabled != null) {
    map['mappingEnabled'] = mappingEnabled;
  }
  if (tapToUncountEnabled != null) {
    map['tapToUncountEnabled'] = tapToUncountEnabled;
  }
  if (shouldShowUnscannedBarcodes != null) {
    map['shouldShowUnscannedBarcodes'] = shouldShowUnscannedBarcodes;
  }
  if (clusteringMode != null) {
    map['clusteringMode'] = clusteringMode;
  }
  if (!identical(automaticClusteringMethod, _unset)) {
    map['automaticClusteringMethod'] = automaticClusteringMethod;
  }
  if (!identical(expectedBarcodesPerCluster, _unset)) {
    map['expectedBarcodesPerCluster'] = expectedBarcodesPerCluster;
  }
  if (groupScanningEnabled != null) {
    map['groupScanningEnabled'] = groupScanningEnabled;
  }
  return map;
}

/// A scanned barcode. Serialization only.
class Barcode {
  final Symbology symbology;
  final String data;
  final String rawData;
  final String? addOnData;
  final String? compositeData;
  final String? compositeRawData;
  final List<EncodingRange> encodingRanges;
  final Quadrilateral location;
  final CompositeFlag compositeFlag;
  final bool isGS1DataCarrier;
  final bool isColorInverted;
  final int symbolCount;
  final int frameId;
  final double? pixelsPerElement;
  final StructuredAppendData? structuredAppendData;
  final int? family;
  final int? moduleCountX;
  final int? moduleCountY;
  final String? identifier;

  const Barcode({
    required this.symbology,
    required this.data,
    required this.rawData,
    this.addOnData,
    this.compositeData,
    this.compositeRawData,
    required this.encodingRanges,
    required this.location,
    required this.compositeFlag,
    required this.isGS1DataCarrier,
    required this.isColorInverted,
    required this.symbolCount,
    required this.frameId,
    this.pixelsPerElement,
    this.structuredAppendData,
    this.family,
    this.moduleCountX,
    this.moduleCountY,
    this.identifier,
  });

  factory Barcode.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('Barcode: expected a Map');
    }
    const allowedKeys = <String>{
      'symbology',
      'data',
      'rawData',
      'addOnData',
      'compositeData',
      'compositeRawData',
      'encodingRanges',
      'location',
      'compositeFlag',
      'isGS1DataCarrier',
      'isColorInverted',
      'symbolCount',
      'frameId',
      'pixelsPerElement',
      'structuredAppendData',
      'family',
      'moduleCountX',
      'moduleCountY',
      'identifier',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("Barcode: unknown property '$key'");
      }
    }
    final hasSymbology = raw.containsKey('symbology');
    if (!hasSymbology) {
      throw FormatException("Barcode.symbology: missing required property");
    }
    final symbologyRaw = raw['symbology'];
    Symbology? symbologyValue;
    if (hasSymbology && symbologyRaw != null) {
      symbologyValue = (symbologyRaw is! String
          ? (throw FormatException('Barcode.symbology: expected a String for Symbology'))
          : Symbology.fromJSON(symbologyRaw));
    } else if (hasSymbology && symbologyRaw == null) {
      throw FormatException('Barcode.symbology: null is not allowed');
    }
    final hasData = raw.containsKey('data');
    if (!hasData) {
      throw FormatException("Barcode.data: missing required property");
    }
    final dataRaw = raw['data'];
    String? dataValue;
    if (hasData && dataRaw != null) {
      if (dataRaw is! String) {
        throw FormatException('Barcode.data: expected a String');
      }
      dataValue = dataRaw;
    } else if (hasData && dataRaw == null) {
      throw FormatException('Barcode.data: null is not allowed');
    }
    final hasRawData = raw.containsKey('rawData');
    if (!hasRawData) {
      throw FormatException("Barcode.rawData: missing required property");
    }
    final rawDataRaw = raw['rawData'];
    String? rawDataValue;
    if (hasRawData && rawDataRaw != null) {
      if (rawDataRaw is! String) {
        throw FormatException('Barcode.rawData: expected a String');
      }
      rawDataValue = rawDataRaw;
    } else if (hasRawData && rawDataRaw == null) {
      throw FormatException('Barcode.rawData: null is not allowed');
    }
    final hasAddOnData = raw.containsKey('addOnData');
    final addOnDataRaw = raw['addOnData'];
    String? addOnDataValue;
    if (hasAddOnData && addOnDataRaw != null) {
      if (addOnDataRaw is! String) {
        throw FormatException('Barcode.addOnData: expected a String');
      }
      addOnDataValue = addOnDataRaw;
    }
    final hasCompositeData = raw.containsKey('compositeData');
    final compositeDataRaw = raw['compositeData'];
    String? compositeDataValue;
    if (hasCompositeData && compositeDataRaw != null) {
      if (compositeDataRaw is! String) {
        throw FormatException('Barcode.compositeData: expected a String');
      }
      compositeDataValue = compositeDataRaw;
    }
    final hasCompositeRawData = raw.containsKey('compositeRawData');
    final compositeRawDataRaw = raw['compositeRawData'];
    String? compositeRawDataValue;
    if (hasCompositeRawData && compositeRawDataRaw != null) {
      if (compositeRawDataRaw is! String) {
        throw FormatException('Barcode.compositeRawData: expected a String');
      }
      compositeRawDataValue = compositeRawDataRaw;
    } else if (hasCompositeRawData && compositeRawDataRaw == null) {
      throw FormatException('Barcode.compositeRawData: null is not allowed');
    }
    final hasEncodingRanges = raw.containsKey('encodingRanges');
    if (!hasEncodingRanges) {
      throw FormatException("Barcode.encodingRanges: missing required property");
    }
    final encodingRangesRaw = raw['encodingRanges'];
    List<EncodingRange>? encodingRangesValue;
    if (hasEncodingRanges && encodingRangesRaw != null) {
      if (encodingRangesRaw is! List) {
        throw FormatException('Barcode.encodingRanges: expected a List');
      }
      encodingRangesValue = encodingRangesRaw.map((item) => EncodingRange.fromJson(item)).toList();
    } else if (hasEncodingRanges && encodingRangesRaw == null) {
      throw FormatException('Barcode.encodingRanges: null is not allowed');
    }
    final hasLocation = raw.containsKey('location');
    if (!hasLocation) {
      throw FormatException("Barcode.location: missing required property");
    }
    final locationRaw = raw['location'];
    Quadrilateral? locationValue;
    if (hasLocation && locationRaw != null) {
      locationValue = Quadrilateral.fromJson(locationRaw);
    } else if (hasLocation && locationRaw == null) {
      throw FormatException('Barcode.location: null is not allowed');
    }
    final hasCompositeFlag = raw.containsKey('compositeFlag');
    if (!hasCompositeFlag) {
      throw FormatException("Barcode.compositeFlag: missing required property");
    }
    final compositeFlagRaw = raw['compositeFlag'];
    CompositeFlag? compositeFlagValue;
    if (hasCompositeFlag && compositeFlagRaw != null) {
      compositeFlagValue = (compositeFlagRaw is! String
          ? (throw FormatException('Barcode.compositeFlag: expected a String for CompositeFlag'))
          : CompositeFlag.fromJSON(compositeFlagRaw));
    } else if (hasCompositeFlag && compositeFlagRaw == null) {
      throw FormatException('Barcode.compositeFlag: null is not allowed');
    }
    final hasIsGS1DataCarrier = raw.containsKey('isGS1DataCarrier');
    if (!hasIsGS1DataCarrier) {
      throw FormatException("Barcode.isGS1DataCarrier: missing required property");
    }
    final isGS1DataCarrierRaw = raw['isGS1DataCarrier'];
    bool? isGS1DataCarrierValue;
    if (hasIsGS1DataCarrier && isGS1DataCarrierRaw != null) {
      if (isGS1DataCarrierRaw is! bool) {
        throw FormatException('Barcode.isGS1DataCarrier: expected a bool');
      }
      isGS1DataCarrierValue = isGS1DataCarrierRaw;
    } else if (hasIsGS1DataCarrier && isGS1DataCarrierRaw == null) {
      throw FormatException('Barcode.isGS1DataCarrier: null is not allowed');
    }
    final hasIsColorInverted = raw.containsKey('isColorInverted');
    if (!hasIsColorInverted) {
      throw FormatException("Barcode.isColorInverted: missing required property");
    }
    final isColorInvertedRaw = raw['isColorInverted'];
    bool? isColorInvertedValue;
    if (hasIsColorInverted && isColorInvertedRaw != null) {
      if (isColorInvertedRaw is! bool) {
        throw FormatException('Barcode.isColorInverted: expected a bool');
      }
      isColorInvertedValue = isColorInvertedRaw;
    } else if (hasIsColorInverted && isColorInvertedRaw == null) {
      throw FormatException('Barcode.isColorInverted: null is not allowed');
    }
    final hasSymbolCount = raw.containsKey('symbolCount');
    if (!hasSymbolCount) {
      throw FormatException("Barcode.symbolCount: missing required property");
    }
    final symbolCountRaw = raw['symbolCount'];
    int? symbolCountValue;
    if (hasSymbolCount && symbolCountRaw != null) {
      if (symbolCountRaw is! num) {
        throw FormatException('Barcode.symbolCount: expected a number');
      }
      if (symbolCountRaw != symbolCountRaw.toInt()) {
        throw FormatException('Barcode.symbolCount: expected an integer');
      }
      symbolCountValue = symbolCountRaw.toInt();
    } else if (hasSymbolCount && symbolCountRaw == null) {
      throw FormatException('Barcode.symbolCount: null is not allowed');
    }
    final hasFrameId = raw.containsKey('frameId');
    if (!hasFrameId) {
      throw FormatException("Barcode.frameId: missing required property");
    }
    final frameIdRaw = raw['frameId'];
    int? frameIdValue;
    if (hasFrameId && frameIdRaw != null) {
      if (frameIdRaw is! num) {
        throw FormatException('Barcode.frameId: expected a number');
      }
      if (frameIdRaw != frameIdRaw.toInt()) {
        throw FormatException('Barcode.frameId: expected an integer');
      }
      frameIdValue = frameIdRaw.toInt();
    } else if (hasFrameId && frameIdRaw == null) {
      throw FormatException('Barcode.frameId: null is not allowed');
    }
    final hasPixelsPerElement = raw.containsKey('pixelsPerElement');
    final pixelsPerElementRaw = raw['pixelsPerElement'];
    double? pixelsPerElementValue;
    if (hasPixelsPerElement && pixelsPerElementRaw != null) {
      if (pixelsPerElementRaw is! num) {
        throw FormatException('Barcode.pixelsPerElement: expected a number');
      }
      pixelsPerElementValue = pixelsPerElementRaw.toDouble();
    } else if (hasPixelsPerElement && pixelsPerElementRaw == null) {
      throw FormatException('Barcode.pixelsPerElement: null is not allowed');
    }
    final hasStructuredAppendData = raw.containsKey('structuredAppendData');
    final structuredAppendDataRaw = raw['structuredAppendData'];
    StructuredAppendData? structuredAppendDataValue;
    if (hasStructuredAppendData && structuredAppendDataRaw != null) {
      structuredAppendDataValue = StructuredAppendData.fromJson(structuredAppendDataRaw);
    }
    final hasFamily = raw.containsKey('family');
    final familyRaw = raw['family'];
    int? familyValue;
    if (hasFamily && familyRaw != null) {
      if (familyRaw is! num) {
        throw FormatException('Barcode.family: expected a number');
      }
      if (familyRaw != familyRaw.toInt()) {
        throw FormatException('Barcode.family: expected an integer');
      }
      familyValue = familyRaw.toInt();
    } else if (hasFamily && familyRaw == null) {
      throw FormatException('Barcode.family: null is not allowed');
    }
    final hasModuleCountX = raw.containsKey('moduleCountX');
    final moduleCountXRaw = raw['moduleCountX'];
    int? moduleCountXValue;
    if (hasModuleCountX && moduleCountXRaw != null) {
      if (moduleCountXRaw is! num) {
        throw FormatException('Barcode.moduleCountX: expected a number');
      }
      if (moduleCountXRaw != moduleCountXRaw.toInt()) {
        throw FormatException('Barcode.moduleCountX: expected an integer');
      }
      moduleCountXValue = moduleCountXRaw.toInt();
    } else if (hasModuleCountX && moduleCountXRaw == null) {
      throw FormatException('Barcode.moduleCountX: null is not allowed');
    }
    final hasModuleCountY = raw.containsKey('moduleCountY');
    final moduleCountYRaw = raw['moduleCountY'];
    int? moduleCountYValue;
    if (hasModuleCountY && moduleCountYRaw != null) {
      if (moduleCountYRaw is! num) {
        throw FormatException('Barcode.moduleCountY: expected a number');
      }
      if (moduleCountYRaw != moduleCountYRaw.toInt()) {
        throw FormatException('Barcode.moduleCountY: expected an integer');
      }
      moduleCountYValue = moduleCountYRaw.toInt();
    } else if (hasModuleCountY && moduleCountYRaw == null) {
      throw FormatException('Barcode.moduleCountY: null is not allowed');
    }
    final hasIdentifier = raw.containsKey('identifier');
    final identifierRaw = raw['identifier'];
    String? identifierValue;
    if (hasIdentifier && identifierRaw != null) {
      if (identifierRaw is! String) {
        throw FormatException('Barcode.identifier: expected a String');
      }
      identifierValue = identifierRaw;
    } else if (hasIdentifier && identifierRaw == null) {
      throw FormatException('Barcode.identifier: null is not allowed');
    }
    return Barcode(
      symbology: symbologyValue!,
      data: dataValue!,
      rawData: rawDataValue!,
      addOnData: addOnDataValue,
      compositeData: compositeDataValue,
      compositeRawData: compositeRawDataValue,
      encodingRanges: encodingRangesValue!,
      location: locationValue!,
      compositeFlag: compositeFlagValue!,
      isGS1DataCarrier: isGS1DataCarrierValue!,
      isColorInverted: isColorInvertedValue!,
      symbolCount: symbolCountValue!,
      frameId: frameIdValue!,
      pixelsPerElement: pixelsPerElementValue,
      structuredAppendData: structuredAppendDataValue,
      family: familyValue,
      moduleCountX: moduleCountXValue,
      moduleCountY: moduleCountYValue,
      identifier: identifierValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['symbology'] = symbology.toJson();
    map['data'] = data;
    map['rawData'] = rawData;
    if (addOnData != null) {
      map['addOnData'] = addOnData;
    }
    if (compositeData != null) {
      map['compositeData'] = compositeData;
    }
    if (compositeRawData != null) {
      map['compositeRawData'] = compositeRawData;
    }
    map['encodingRanges'] = encodingRanges.map((item) => item.toJson()).toList();
    map['location'] = location.toJson();
    map['compositeFlag'] = compositeFlag.toJson();
    map['isGS1DataCarrier'] = isGS1DataCarrier;
    map['isColorInverted'] = isColorInverted;
    map['symbolCount'] = symbolCount;
    map['frameId'] = frameId;
    if (pixelsPerElement != null) {
      map['pixelsPerElement'] = pixelsPerElement;
    }
    if (structuredAppendData != null) {
      map['structuredAppendData'] = structuredAppendData!.toJson();
    }
    if (family != null) {
      map['family'] = family;
    }
    if (moduleCountX != null) {
      map['moduleCountX'] = moduleCountX;
    }
    if (moduleCountY != null) {
      map['moduleCountY'] = moduleCountY;
    }
    if (identifier != null) {
      map['identifier'] = identifier;
    }
    return map;
  }
}

/// Typed builder for the `Barcode` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildBarcode({
  required Object symbology,
  required String data,
  required String rawData,
  Object? addOnData = _unset,
  Object? compositeData = _unset,
  String? compositeRawData,
  required List<Object?> encodingRanges,
  required Object location,
  required Object compositeFlag,
  required bool isGS1DataCarrier,
  required bool isColorInverted,
  required int symbolCount,
  required int frameId,
  double? pixelsPerElement,
  Object? structuredAppendData = _unset,
  int? family,
  int? moduleCountX,
  int? moduleCountY,
  String? identifier,
}) {
  final map = <String, Object?>{};
  map['symbology'] = symbology;
  map['data'] = data;
  map['rawData'] = rawData;
  if (!identical(addOnData, _unset)) {
    map['addOnData'] = addOnData;
  }
  if (!identical(compositeData, _unset)) {
    map['compositeData'] = compositeData;
  }
  if (compositeRawData != null) {
    map['compositeRawData'] = compositeRawData;
  }
  map['encodingRanges'] = encodingRanges;
  map['location'] = location;
  map['compositeFlag'] = compositeFlag;
  map['isGS1DataCarrier'] = isGS1DataCarrier;
  map['isColorInverted'] = isColorInverted;
  map['symbolCount'] = symbolCount;
  map['frameId'] = frameId;
  if (pixelsPerElement != null) {
    map['pixelsPerElement'] = pixelsPerElement;
  }
  if (!identical(structuredAppendData, _unset)) {
    map['structuredAppendData'] = structuredAppendData;
  }
  if (family != null) {
    map['family'] = family;
  }
  if (moduleCountX != null) {
    map['moduleCountX'] = moduleCountX;
  }
  if (moduleCountY != null) {
    map['moduleCountY'] = moduleCountY;
  }
  if (identifier != null) {
    map['identifier'] = identifier;
  }
  return map;
}

/// A range of characters within a specific encoding.
class EncodingRange {
  final String ianaName;
  final int startIndex;
  final int endIndex;

  const EncodingRange({
    required this.ianaName,
    required this.startIndex,
    required this.endIndex,
  });

  factory EncodingRange.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('EncodingRange: expected a Map');
    }
    const allowedKeys = <String>{
      'ianaName',
      'startIndex',
      'endIndex',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("EncodingRange: unknown property '$key'");
      }
    }
    final hasIanaName = raw.containsKey('ianaName');
    if (!hasIanaName) {
      throw FormatException("EncodingRange.ianaName: missing required property");
    }
    final ianaNameRaw = raw['ianaName'];
    String? ianaNameValue;
    if (hasIanaName && ianaNameRaw != null) {
      if (ianaNameRaw is! String) {
        throw FormatException('EncodingRange.ianaName: expected a String');
      }
      ianaNameValue = ianaNameRaw;
    } else if (hasIanaName && ianaNameRaw == null) {
      throw FormatException('EncodingRange.ianaName: null is not allowed');
    }
    final hasStartIndex = raw.containsKey('startIndex');
    if (!hasStartIndex) {
      throw FormatException("EncodingRange.startIndex: missing required property");
    }
    final startIndexRaw = raw['startIndex'];
    int? startIndexValue;
    if (hasStartIndex && startIndexRaw != null) {
      if (startIndexRaw is! num) {
        throw FormatException('EncodingRange.startIndex: expected a number');
      }
      if (startIndexRaw != startIndexRaw.toInt()) {
        throw FormatException('EncodingRange.startIndex: expected an integer');
      }
      startIndexValue = startIndexRaw.toInt();
    } else if (hasStartIndex && startIndexRaw == null) {
      throw FormatException('EncodingRange.startIndex: null is not allowed');
    }
    final hasEndIndex = raw.containsKey('endIndex');
    if (!hasEndIndex) {
      throw FormatException("EncodingRange.endIndex: missing required property");
    }
    final endIndexRaw = raw['endIndex'];
    int? endIndexValue;
    if (hasEndIndex && endIndexRaw != null) {
      if (endIndexRaw is! num) {
        throw FormatException('EncodingRange.endIndex: expected a number');
      }
      if (endIndexRaw != endIndexRaw.toInt()) {
        throw FormatException('EncodingRange.endIndex: expected an integer');
      }
      endIndexValue = endIndexRaw.toInt();
    } else if (hasEndIndex && endIndexRaw == null) {
      throw FormatException('EncodingRange.endIndex: null is not allowed');
    }
    return EncodingRange(
      ianaName: ianaNameValue!,
      startIndex: startIndexValue!,
      endIndex: endIndexValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['ianaName'] = ianaName;
    map['startIndex'] = startIndex;
    map['endIndex'] = endIndex;
    return map;
  }
}

/// Typed builder for the `EncodingRange` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildEncodingRange({
  required String ianaName,
  required int startIndex,
  required int endIndex,
}) {
  final map = <String, Object?>{};
  map['ianaName'] = ianaName;
  map['startIndex'] = startIndex;
  map['endIndex'] = endIndex;
  return map;
}

/// A quadrilateral defined by four corner points.
class Quadrilateral {
  final UIPoint topLeft;
  final UIPoint topRight;
  final UIPoint bottomRight;
  final UIPoint bottomLeft;

  const Quadrilateral({
    required this.topLeft,
    required this.topRight,
    required this.bottomRight,
    required this.bottomLeft,
  });

  factory Quadrilateral.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('Quadrilateral: expected a Map');
    }
    const allowedKeys = <String>{
      'topLeft',
      'topRight',
      'bottomRight',
      'bottomLeft',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("Quadrilateral: unknown property '$key'");
      }
    }
    final hasTopLeft = raw.containsKey('topLeft');
    if (!hasTopLeft) {
      throw FormatException("Quadrilateral.topLeft: missing required property");
    }
    final topLeftRaw = raw['topLeft'];
    UIPoint? topLeftValue;
    if (hasTopLeft && topLeftRaw != null) {
      topLeftValue = UIPoint.fromJson(topLeftRaw);
    } else if (hasTopLeft && topLeftRaw == null) {
      throw FormatException('Quadrilateral.topLeft: null is not allowed');
    }
    final hasTopRight = raw.containsKey('topRight');
    if (!hasTopRight) {
      throw FormatException("Quadrilateral.topRight: missing required property");
    }
    final topRightRaw = raw['topRight'];
    UIPoint? topRightValue;
    if (hasTopRight && topRightRaw != null) {
      topRightValue = UIPoint.fromJson(topRightRaw);
    } else if (hasTopRight && topRightRaw == null) {
      throw FormatException('Quadrilateral.topRight: null is not allowed');
    }
    final hasBottomRight = raw.containsKey('bottomRight');
    if (!hasBottomRight) {
      throw FormatException("Quadrilateral.bottomRight: missing required property");
    }
    final bottomRightRaw = raw['bottomRight'];
    UIPoint? bottomRightValue;
    if (hasBottomRight && bottomRightRaw != null) {
      bottomRightValue = UIPoint.fromJson(bottomRightRaw);
    } else if (hasBottomRight && bottomRightRaw == null) {
      throw FormatException('Quadrilateral.bottomRight: null is not allowed');
    }
    final hasBottomLeft = raw.containsKey('bottomLeft');
    if (!hasBottomLeft) {
      throw FormatException("Quadrilateral.bottomLeft: missing required property");
    }
    final bottomLeftRaw = raw['bottomLeft'];
    UIPoint? bottomLeftValue;
    if (hasBottomLeft && bottomLeftRaw != null) {
      bottomLeftValue = UIPoint.fromJson(bottomLeftRaw);
    } else if (hasBottomLeft && bottomLeftRaw == null) {
      throw FormatException('Quadrilateral.bottomLeft: null is not allowed');
    }
    return Quadrilateral(
      topLeft: topLeftValue!,
      topRight: topRightValue!,
      bottomRight: bottomRightValue!,
      bottomLeft: bottomLeftValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['topLeft'] = topLeft.toJson();
    map['topRight'] = topRight.toJson();
    map['bottomRight'] = bottomRight.toJson();
    map['bottomLeft'] = bottomLeft.toJson();
    return map;
  }
}

/// Typed builder for the `Quadrilateral` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildQuadrilateral({
  required Object topLeft,
  required Object topRight,
  required Object bottomRight,
  required Object bottomLeft,
}) {
  final map = <String, Object?>{};
  map['topLeft'] = topLeft;
  map['topRight'] = topRight;
  map['bottomRight'] = bottomRight;
  map['bottomLeft'] = bottomLeft;
  return map;
}

/// Information about a barcode that is part of a structured-append set.
class StructuredAppendData {
  final String barcodeSetId;
  final int scannedSegmentCount;
  final int totalSegmentCount;
  final bool complete;
  final String completeDataRaw;
  final List<EncodingRange> completeDataEncodings;
  final String completeDataUtf8String;

  const StructuredAppendData({
    required this.barcodeSetId,
    required this.scannedSegmentCount,
    required this.totalSegmentCount,
    required this.complete,
    required this.completeDataRaw,
    required this.completeDataEncodings,
    required this.completeDataUtf8String,
  });

  factory StructuredAppendData.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('StructuredAppendData: expected a Map');
    }
    const allowedKeys = <String>{
      'barcodeSetId',
      'scannedSegmentCount',
      'totalSegmentCount',
      'complete',
      'completeDataRaw',
      'completeDataEncodings',
      'completeDataUtf8String',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("StructuredAppendData: unknown property '$key'");
      }
    }
    final hasBarcodeSetId = raw.containsKey('barcodeSetId');
    if (!hasBarcodeSetId) {
      throw FormatException("StructuredAppendData.barcodeSetId: missing required property");
    }
    final barcodeSetIdRaw = raw['barcodeSetId'];
    String? barcodeSetIdValue;
    if (hasBarcodeSetId && barcodeSetIdRaw != null) {
      if (barcodeSetIdRaw is! String) {
        throw FormatException('StructuredAppendData.barcodeSetId: expected a String');
      }
      barcodeSetIdValue = barcodeSetIdRaw;
    } else if (hasBarcodeSetId && barcodeSetIdRaw == null) {
      throw FormatException('StructuredAppendData.barcodeSetId: null is not allowed');
    }
    final hasScannedSegmentCount = raw.containsKey('scannedSegmentCount');
    if (!hasScannedSegmentCount) {
      throw FormatException("StructuredAppendData.scannedSegmentCount: missing required property");
    }
    final scannedSegmentCountRaw = raw['scannedSegmentCount'];
    int? scannedSegmentCountValue;
    if (hasScannedSegmentCount && scannedSegmentCountRaw != null) {
      if (scannedSegmentCountRaw is! num) {
        throw FormatException('StructuredAppendData.scannedSegmentCount: expected a number');
      }
      if (scannedSegmentCountRaw != scannedSegmentCountRaw.toInt()) {
        throw FormatException('StructuredAppendData.scannedSegmentCount: expected an integer');
      }
      scannedSegmentCountValue = scannedSegmentCountRaw.toInt();
    } else if (hasScannedSegmentCount && scannedSegmentCountRaw == null) {
      throw FormatException('StructuredAppendData.scannedSegmentCount: null is not allowed');
    }
    final hasTotalSegmentCount = raw.containsKey('totalSegmentCount');
    if (!hasTotalSegmentCount) {
      throw FormatException("StructuredAppendData.totalSegmentCount: missing required property");
    }
    final totalSegmentCountRaw = raw['totalSegmentCount'];
    int? totalSegmentCountValue;
    if (hasTotalSegmentCount && totalSegmentCountRaw != null) {
      if (totalSegmentCountRaw is! num) {
        throw FormatException('StructuredAppendData.totalSegmentCount: expected a number');
      }
      if (totalSegmentCountRaw != totalSegmentCountRaw.toInt()) {
        throw FormatException('StructuredAppendData.totalSegmentCount: expected an integer');
      }
      totalSegmentCountValue = totalSegmentCountRaw.toInt();
    } else if (hasTotalSegmentCount && totalSegmentCountRaw == null) {
      throw FormatException('StructuredAppendData.totalSegmentCount: null is not allowed');
    }
    final hasComplete = raw.containsKey('complete');
    if (!hasComplete) {
      throw FormatException("StructuredAppendData.complete: missing required property");
    }
    final completeRaw = raw['complete'];
    bool? completeValue;
    if (hasComplete && completeRaw != null) {
      if (completeRaw is! bool) {
        throw FormatException('StructuredAppendData.complete: expected a bool');
      }
      completeValue = completeRaw;
    } else if (hasComplete && completeRaw == null) {
      throw FormatException('StructuredAppendData.complete: null is not allowed');
    }
    final hasCompleteDataRaw = raw.containsKey('completeDataRaw');
    if (!hasCompleteDataRaw) {
      throw FormatException("StructuredAppendData.completeDataRaw: missing required property");
    }
    final completeDataRawRaw = raw['completeDataRaw'];
    String? completeDataRawValue;
    if (hasCompleteDataRaw && completeDataRawRaw != null) {
      if (completeDataRawRaw is! String) {
        throw FormatException('StructuredAppendData.completeDataRaw: expected a String');
      }
      completeDataRawValue = completeDataRawRaw;
    } else if (hasCompleteDataRaw && completeDataRawRaw == null) {
      throw FormatException('StructuredAppendData.completeDataRaw: null is not allowed');
    }
    final hasCompleteDataEncodings = raw.containsKey('completeDataEncodings');
    if (!hasCompleteDataEncodings) {
      throw FormatException("StructuredAppendData.completeDataEncodings: missing required property");
    }
    final completeDataEncodingsRaw = raw['completeDataEncodings'];
    List<EncodingRange>? completeDataEncodingsValue;
    if (hasCompleteDataEncodings && completeDataEncodingsRaw != null) {
      if (completeDataEncodingsRaw is! List) {
        throw FormatException('StructuredAppendData.completeDataEncodings: expected a List');
      }
      completeDataEncodingsValue = completeDataEncodingsRaw.map((item) => EncodingRange.fromJson(item)).toList();
    } else if (hasCompleteDataEncodings && completeDataEncodingsRaw == null) {
      throw FormatException('StructuredAppendData.completeDataEncodings: null is not allowed');
    }
    final hasCompleteDataUtf8String = raw.containsKey('completeDataUtf8String');
    if (!hasCompleteDataUtf8String) {
      throw FormatException("StructuredAppendData.completeDataUtf8String: missing required property");
    }
    final completeDataUtf8StringRaw = raw['completeDataUtf8String'];
    String? completeDataUtf8StringValue;
    if (hasCompleteDataUtf8String && completeDataUtf8StringRaw != null) {
      if (completeDataUtf8StringRaw is! String) {
        throw FormatException('StructuredAppendData.completeDataUtf8String: expected a String');
      }
      completeDataUtf8StringValue = completeDataUtf8StringRaw;
    } else if (hasCompleteDataUtf8String && completeDataUtf8StringRaw == null) {
      throw FormatException('StructuredAppendData.completeDataUtf8String: null is not allowed');
    }
    return StructuredAppendData(
      barcodeSetId: barcodeSetIdValue!,
      scannedSegmentCount: scannedSegmentCountValue!,
      totalSegmentCount: totalSegmentCountValue!,
      complete: completeValue!,
      completeDataRaw: completeDataRawValue!,
      completeDataEncodings: completeDataEncodingsValue!,
      completeDataUtf8String: completeDataUtf8StringValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['barcodeSetId'] = barcodeSetId;
    map['scannedSegmentCount'] = scannedSegmentCount;
    map['totalSegmentCount'] = totalSegmentCount;
    map['complete'] = complete;
    map['completeDataRaw'] = completeDataRaw;
    map['completeDataEncodings'] = completeDataEncodings.map((item) => item.toJson()).toList();
    map['completeDataUtf8String'] = completeDataUtf8String;
    return map;
  }
}

/// Typed builder for the `StructuredAppendData` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildStructuredAppendData({
  required String barcodeSetId,
  required int scannedSegmentCount,
  required int totalSegmentCount,
  required bool complete,
  required String completeDataRaw,
  required List<Object?> completeDataEncodings,
  required String completeDataUtf8String,
}) {
  final map = <String, Object?>{};
  map['barcodeSetId'] = barcodeSetId;
  map['scannedSegmentCount'] = scannedSegmentCount;
  map['totalSegmentCount'] = totalSegmentCount;
  map['complete'] = complete;
  map['completeDataRaw'] = completeDataRaw;
  map['completeDataEncodings'] = completeDataEncodings;
  map['completeDataUtf8String'] = completeDataUtf8String;
  return map;
}

/// Feedback configuration for BarcodeCount events.
class BarcodeCountFeedback {
  final Feedback? success;
  final Feedback? unrecognized;
  final Feedback? failure;

  const BarcodeCountFeedback({
    this.success,
    this.unrecognized,
    this.failure,
  });

  factory BarcodeCountFeedback.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('BarcodeCountFeedback: expected a Map');
    }
    const allowedKeys = <String>{
      'success',
      'unrecognized',
      'failure',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("BarcodeCountFeedback: unknown property '$key'");
      }
    }
    final hasSuccess = raw.containsKey('success');
    final successRaw = raw['success'];
    Feedback? successValue;
    if (hasSuccess && successRaw != null) {
      successValue = Feedback.fromJson(successRaw);
    } else if (hasSuccess && successRaw == null) {
      throw FormatException('BarcodeCountFeedback.success: null is not allowed');
    }
    final hasUnrecognized = raw.containsKey('unrecognized');
    final unrecognizedRaw = raw['unrecognized'];
    Feedback? unrecognizedValue;
    if (hasUnrecognized && unrecognizedRaw != null) {
      unrecognizedValue = Feedback.fromJson(unrecognizedRaw);
    } else if (hasUnrecognized && unrecognizedRaw == null) {
      throw FormatException('BarcodeCountFeedback.unrecognized: null is not allowed');
    }
    final hasFailure = raw.containsKey('failure');
    final failureRaw = raw['failure'];
    Feedback? failureValue;
    if (hasFailure && failureRaw != null) {
      failureValue = Feedback.fromJson(failureRaw);
    } else if (hasFailure && failureRaw == null) {
      throw FormatException('BarcodeCountFeedback.failure: null is not allowed');
    }
    return BarcodeCountFeedback(
      success: successValue,
      unrecognized: unrecognizedValue,
      failure: failureValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (success != null) {
      map['success'] = success!.toJson();
    }
    if (unrecognized != null) {
      map['unrecognized'] = unrecognized!.toJson();
    }
    if (failure != null) {
      map['failure'] = failure!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `BarcodeCountFeedback` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildBarcodeCountFeedback({
  Object? success,
  Object? unrecognized,
  Object? failure,
}) {
  final map = <String, Object?>{};
  if (success != null) {
    map['success'] = success;
  }
  if (unrecognized != null) {
    map['unrecognized'] = unrecognized;
  }
  if (failure != null) {
    map['failure'] = failure;
  }
  return map;
}

/// The BarcodeSequence (MatrixScan Sequence) capture mode for shelf sequencing.
class BarcodeSequence implements Mode {
  final String type;
  final BarcodeSequenceSettings? settings;
  final BarcodeSequenceFeedback? feedback;
  final SequencedShelfModule? shelfSequencingValidationPlanogram;

  const BarcodeSequence({
    required this.type,
    this.settings,
    this.feedback,
    this.shelfSequencingValidationPlanogram,
  });

  factory BarcodeSequence.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('BarcodeSequence: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'settings',
      'feedback',
      'shelfSequencingValidationPlanogram',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("BarcodeSequence: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("BarcodeSequence.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['barcodeSequence'].contains(typeRaw)) {
        throw FormatException("BarcodeSequence.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('BarcodeSequence.type: null is not allowed');
    }
    final hasSettings = raw.containsKey('settings');
    final settingsRaw = raw['settings'];
    BarcodeSequenceSettings? settingsValue;
    if (hasSettings && settingsRaw != null) {
      settingsValue = BarcodeSequenceSettings.fromJson(settingsRaw);
    } else if (hasSettings && settingsRaw == null) {
      throw FormatException('BarcodeSequence.settings: null is not allowed');
    }
    final hasFeedback = raw.containsKey('feedback');
    final feedbackRaw = raw['feedback'];
    BarcodeSequenceFeedback? feedbackValue;
    if (hasFeedback && feedbackRaw != null) {
      feedbackValue = BarcodeSequenceFeedback.fromJson(feedbackRaw);
    } else if (hasFeedback && feedbackRaw == null) {
      throw FormatException('BarcodeSequence.feedback: null is not allowed');
    }
    final hasShelfSequencingValidationPlanogram = raw.containsKey('shelfSequencingValidationPlanogram');
    final shelfSequencingValidationPlanogramRaw = raw['shelfSequencingValidationPlanogram'];
    SequencedShelfModule? shelfSequencingValidationPlanogramValue;
    if (hasShelfSequencingValidationPlanogram && shelfSequencingValidationPlanogramRaw != null) {
      shelfSequencingValidationPlanogramValue = SequencedShelfModule.fromJson(shelfSequencingValidationPlanogramRaw);
    } else if (hasShelfSequencingValidationPlanogram && shelfSequencingValidationPlanogramRaw == null) {
      throw FormatException('BarcodeSequence.shelfSequencingValidationPlanogram: null is not allowed');
    }
    return BarcodeSequence(
      type: typeValue!,
      settings: settingsValue,
      feedback: feedbackValue,
      shelfSequencingValidationPlanogram: shelfSequencingValidationPlanogramValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (settings != null) {
      map['settings'] = settings!.toJson();
    }
    if (feedback != null) {
      map['feedback'] = feedback!.toJson();
    }
    if (shelfSequencingValidationPlanogram != null) {
      map['shelfSequencingValidationPlanogram'] = shelfSequencingValidationPlanogram!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `BarcodeSequence` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildBarcodeSequence({
  required String type,
  Object? settings,
  Object? feedback,
  Object? shelfSequencingValidationPlanogram,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (settings != null) {
    map['settings'] = settings;
  }
  if (feedback != null) {
    map['feedback'] = feedback;
  }
  if (shelfSequencingValidationPlanogram != null) {
    map['shelfSequencingValidationPlanogram'] = shelfSequencingValidationPlanogram;
  }
  return map;
}

/// Settings that configure Barcode Sequence (shelf sequencing) behavior.
class BarcodeSequenceSettings {
  final SymbologySettings? symbologies;
  final int? idleTimeout;
  final int? initialOrderOnShelf;
  final int? initialOrderOnTray;

  /// Keys present in the payload that have no emitted field -- undeclared
  /// keys, plus schema-declared properties that are `hidden` or non-mobile and
  /// therefore get no field of their own. Re-emitted by [toJson] so the round
  /// trip is lossless. See the passthrough contract in this file's header.
  final Map<String, Object?> additionalProperties;

  const BarcodeSequenceSettings({
    this.symbologies,
    this.idleTimeout,
    this.initialOrderOnShelf,
    this.initialOrderOnTray,
    this.additionalProperties = const {},
  });

  factory BarcodeSequenceSettings.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('BarcodeSequenceSettings: expected a Map');
    }
    final hasSymbologies = raw.containsKey('symbologies');
    final symbologiesRaw = raw['symbologies'];
    SymbologySettings? symbologiesValue;
    if (hasSymbologies && symbologiesRaw != null) {
      symbologiesValue = parseSymbologySettings(symbologiesRaw);
    } else if (hasSymbologies && symbologiesRaw == null) {
      throw FormatException('BarcodeSequenceSettings.symbologies: null is not allowed');
    }
    final hasIdleTimeout = raw.containsKey('idleTimeout');
    final idleTimeoutRaw = raw['idleTimeout'];
    int? idleTimeoutValue;
    if (hasIdleTimeout && idleTimeoutRaw != null) {
      if (idleTimeoutRaw is! num) {
        throw FormatException('BarcodeSequenceSettings.idleTimeout: expected a number');
      }
      if (idleTimeoutRaw != idleTimeoutRaw.toInt()) {
        throw FormatException('BarcodeSequenceSettings.idleTimeout: expected an integer');
      }
      idleTimeoutValue = idleTimeoutRaw.toInt();
    } else if (hasIdleTimeout && idleTimeoutRaw == null) {
      throw FormatException('BarcodeSequenceSettings.idleTimeout: null is not allowed');
    }
    final hasInitialOrderOnShelf = raw.containsKey('initialOrderOnShelf');
    final initialOrderOnShelfRaw = raw['initialOrderOnShelf'];
    int? initialOrderOnShelfValue;
    if (hasInitialOrderOnShelf && initialOrderOnShelfRaw != null) {
      if (initialOrderOnShelfRaw is! num) {
        throw FormatException('BarcodeSequenceSettings.initialOrderOnShelf: expected a number');
      }
      if (initialOrderOnShelfRaw != initialOrderOnShelfRaw.toInt()) {
        throw FormatException('BarcodeSequenceSettings.initialOrderOnShelf: expected an integer');
      }
      initialOrderOnShelfValue = initialOrderOnShelfRaw.toInt();
    } else if (hasInitialOrderOnShelf && initialOrderOnShelfRaw == null) {
      throw FormatException('BarcodeSequenceSettings.initialOrderOnShelf: null is not allowed');
    }
    final hasInitialOrderOnTray = raw.containsKey('initialOrderOnTray');
    final initialOrderOnTrayRaw = raw['initialOrderOnTray'];
    int? initialOrderOnTrayValue;
    if (hasInitialOrderOnTray && initialOrderOnTrayRaw != null) {
      if (initialOrderOnTrayRaw is! num) {
        throw FormatException('BarcodeSequenceSettings.initialOrderOnTray: expected a number');
      }
      if (initialOrderOnTrayRaw != initialOrderOnTrayRaw.toInt()) {
        throw FormatException('BarcodeSequenceSettings.initialOrderOnTray: expected an integer');
      }
      initialOrderOnTrayValue = initialOrderOnTrayRaw.toInt();
    } else if (hasInitialOrderOnTray && initialOrderOnTrayRaw == null) {
      throw FormatException('BarcodeSequenceSettings.initialOrderOnTray: null is not allowed');
    }
    const emittedKeys = <String>{
      'symbologies',
      'idleTimeout',
      'initialOrderOnShelf',
      'initialOrderOnTray',
    };
    final additionalPropertiesCollected = <String, Object?>{};
    for (final key in raw.keys) {
      // A non-String key never matches `emittedKeys` (a Set<String>), so
      // every one of them reaches this throw: an open class rejects
      // non-String keys outright.
      if (!emittedKeys.contains(key)) {
        if (key is! String) {
          throw FormatException('BarcodeSequenceSettings: expected a String key');
        }
        additionalPropertiesCollected[key] = raw[key];
      }
    }
    return BarcodeSequenceSettings(
      symbologies: symbologiesValue,
      idleTimeout: idleTimeoutValue,
      initialOrderOnShelf: initialOrderOnShelfValue,
      initialOrderOnTray: initialOrderOnTrayValue,
      additionalProperties: Map.unmodifiable(additionalPropertiesCollected),
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (symbologies != null) {
      map['symbologies'] = symbologies;
    }
    if (idleTimeout != null) {
      map['idleTimeout'] = idleTimeout;
    }
    if (initialOrderOnShelf != null) {
      map['initialOrderOnShelf'] = initialOrderOnShelf;
    }
    if (initialOrderOnTray != null) {
      map['initialOrderOnTray'] = initialOrderOnTray;
    }
    for (final entry in additionalProperties.entries) {
      if (!map.containsKey(entry.key)) {
        map[entry.key] = entry.value;
      }
    }
    return map;
  }
}

/// Typed builder for the `BarcodeSequenceSettings` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildBarcodeSequenceSettings({
  SymbologySettings? symbologies,
  int? idleTimeout,
  int? initialOrderOnShelf,
  int? initialOrderOnTray,
}) {
  final map = <String, Object?>{};
  if (symbologies != null) {
    map['symbologies'] = symbologies;
  }
  if (idleTimeout != null) {
    map['idleTimeout'] = idleTimeout;
  }
  if (initialOrderOnShelf != null) {
    map['initialOrderOnShelf'] = initialOrderOnShelf;
  }
  if (initialOrderOnTray != null) {
    map['initialOrderOnTray'] = initialOrderOnTray;
  }
  return map;
}

/// Feedback configuration for BarcodeSequence events.
class BarcodeSequenceFeedback {
  final Feedback? scanned;
  final Feedback? tapped;

  const BarcodeSequenceFeedback({
    this.scanned,
    this.tapped,
  });

  factory BarcodeSequenceFeedback.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('BarcodeSequenceFeedback: expected a Map');
    }
    const allowedKeys = <String>{
      'scanned',
      'tapped',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("BarcodeSequenceFeedback: unknown property '$key'");
      }
    }
    final hasScanned = raw.containsKey('scanned');
    final scannedRaw = raw['scanned'];
    Feedback? scannedValue;
    if (hasScanned && scannedRaw != null) {
      scannedValue = Feedback.fromJson(scannedRaw);
    } else if (hasScanned && scannedRaw == null) {
      throw FormatException('BarcodeSequenceFeedback.scanned: null is not allowed');
    }
    final hasTapped = raw.containsKey('tapped');
    final tappedRaw = raw['tapped'];
    Feedback? tappedValue;
    if (hasTapped && tappedRaw != null) {
      tappedValue = Feedback.fromJson(tappedRaw);
    } else if (hasTapped && tappedRaw == null) {
      throw FormatException('BarcodeSequenceFeedback.tapped: null is not allowed');
    }
    return BarcodeSequenceFeedback(
      scanned: scannedValue,
      tapped: tappedValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (scanned != null) {
      map['scanned'] = scanned!.toJson();
    }
    if (tapped != null) {
      map['tapped'] = tapped!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `BarcodeSequenceFeedback` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildBarcodeSequenceFeedback({
  Object? scanned,
  Object? tapped,
}) {
  final map = <String, Object?>{};
  if (scanned != null) {
    map['scanned'] = scanned;
  }
  if (tapped != null) {
    map['tapped'] = tapped;
  }
  return map;
}

///
class SequencedShelfModule {
  final List<SequencedTray> trays;

  const SequencedShelfModule({
    required this.trays,
  });

  factory SequencedShelfModule.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('SequencedShelfModule: expected a Map');
    }
    const allowedKeys = <String>{
      'trays',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("SequencedShelfModule: unknown property '$key'");
      }
    }
    final hasTrays = raw.containsKey('trays');
    if (!hasTrays) {
      throw FormatException("SequencedShelfModule.trays: missing required property");
    }
    final traysRaw = raw['trays'];
    List<SequencedTray>? traysValue;
    if (hasTrays && traysRaw != null) {
      if (traysRaw is! List) {
        throw FormatException('SequencedShelfModule.trays: expected a List');
      }
      traysValue = traysRaw.map((item) => SequencedTray.fromJson(item)).toList();
    } else if (hasTrays && traysRaw == null) {
      throw FormatException('SequencedShelfModule.trays: null is not allowed');
    }
    return SequencedShelfModule(
      trays: traysValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['trays'] = trays.map((item) => item.toJson()).toList();
    return map;
  }
}

/// Typed builder for the `SequencedShelfModule` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildSequencedShelfModule({
  required List<Object?> trays,
}) {
  final map = <String, Object?>{};
  map['trays'] = trays;
  return map;
}

///
class SequencedTray {
  final int orderOnShelf;
  final List<SequencedBarcode> barcodes;

  const SequencedTray({
    required this.orderOnShelf,
    required this.barcodes,
  });

  factory SequencedTray.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('SequencedTray: expected a Map');
    }
    const allowedKeys = <String>{
      'orderOnShelf',
      'barcodes',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("SequencedTray: unknown property '$key'");
      }
    }
    final hasOrderOnShelf = raw.containsKey('orderOnShelf');
    if (!hasOrderOnShelf) {
      throw FormatException("SequencedTray.orderOnShelf: missing required property");
    }
    final orderOnShelfRaw = raw['orderOnShelf'];
    int? orderOnShelfValue;
    if (hasOrderOnShelf && orderOnShelfRaw != null) {
      if (orderOnShelfRaw is! num) {
        throw FormatException('SequencedTray.orderOnShelf: expected a number');
      }
      if (orderOnShelfRaw != orderOnShelfRaw.toInt()) {
        throw FormatException('SequencedTray.orderOnShelf: expected an integer');
      }
      orderOnShelfValue = orderOnShelfRaw.toInt();
    } else if (hasOrderOnShelf && orderOnShelfRaw == null) {
      throw FormatException('SequencedTray.orderOnShelf: null is not allowed');
    }
    final hasBarcodes = raw.containsKey('barcodes');
    if (!hasBarcodes) {
      throw FormatException("SequencedTray.barcodes: missing required property");
    }
    final barcodesRaw = raw['barcodes'];
    List<SequencedBarcode>? barcodesValue;
    if (hasBarcodes && barcodesRaw != null) {
      if (barcodesRaw is! List) {
        throw FormatException('SequencedTray.barcodes: expected a List');
      }
      barcodesValue = barcodesRaw.map((item) => SequencedBarcode.fromJson(item)).toList();
    } else if (hasBarcodes && barcodesRaw == null) {
      throw FormatException('SequencedTray.barcodes: null is not allowed');
    }
    return SequencedTray(
      orderOnShelf: orderOnShelfValue!,
      barcodes: barcodesValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['orderOnShelf'] = orderOnShelf;
    map['barcodes'] = barcodes.map((item) => item.toJson()).toList();
    return map;
  }
}

/// Typed builder for the `SequencedTray` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildSequencedTray({
  required int orderOnShelf,
  required List<Object?> barcodes,
}) {
  final map = <String, Object?>{};
  map['orderOnShelf'] = orderOnShelf;
  map['barcodes'] = barcodes;
  return map;
}

/// Planogram input shape of a SequencedBarcode, as parsed by SequencedShelfModule.fromJson. The serialized output shape of the same type (JSONString) is documented in sequenced_barcode.json.
class SequencedBarcode {
  final String data;
  final String symbology;
  final int orderOnTray;

  const SequencedBarcode({
    required this.data,
    required this.symbology,
    required this.orderOnTray,
  });

  factory SequencedBarcode.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('SequencedBarcode: expected a Map');
    }
    const allowedKeys = <String>{
      'data',
      'symbology',
      'orderOnTray',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("SequencedBarcode: unknown property '$key'");
      }
    }
    final hasData = raw.containsKey('data');
    if (!hasData) {
      throw FormatException("SequencedBarcode.data: missing required property");
    }
    final dataRaw = raw['data'];
    String? dataValue;
    if (hasData && dataRaw != null) {
      if (dataRaw is! String) {
        throw FormatException('SequencedBarcode.data: expected a String');
      }
      dataValue = dataRaw;
    } else if (hasData && dataRaw == null) {
      throw FormatException('SequencedBarcode.data: null is not allowed');
    }
    final hasSymbology = raw.containsKey('symbology');
    if (!hasSymbology) {
      throw FormatException("SequencedBarcode.symbology: missing required property");
    }
    final symbologyRaw = raw['symbology'];
    String? symbologyValue;
    if (hasSymbology && symbologyRaw != null) {
      if (symbologyRaw is! String) {
        throw FormatException('SequencedBarcode.symbology: expected a String');
      }
      symbologyValue = symbologyRaw;
    } else if (hasSymbology && symbologyRaw == null) {
      throw FormatException('SequencedBarcode.symbology: null is not allowed');
    }
    final hasOrderOnTray = raw.containsKey('orderOnTray');
    if (!hasOrderOnTray) {
      throw FormatException("SequencedBarcode.orderOnTray: missing required property");
    }
    final orderOnTrayRaw = raw['orderOnTray'];
    int? orderOnTrayValue;
    if (hasOrderOnTray && orderOnTrayRaw != null) {
      if (orderOnTrayRaw is! num) {
        throw FormatException('SequencedBarcode.orderOnTray: expected a number');
      }
      if (orderOnTrayRaw != orderOnTrayRaw.toInt()) {
        throw FormatException('SequencedBarcode.orderOnTray: expected an integer');
      }
      orderOnTrayValue = orderOnTrayRaw.toInt();
    } else if (hasOrderOnTray && orderOnTrayRaw == null) {
      throw FormatException('SequencedBarcode.orderOnTray: null is not allowed');
    }
    return SequencedBarcode(
      data: dataValue!,
      symbology: symbologyValue!,
      orderOnTray: orderOnTrayValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['data'] = data;
    map['symbology'] = symbology;
    map['orderOnTray'] = orderOnTray;
    return map;
  }
}

/// Typed builder for the `SequencedBarcode` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildSequencedBarcode({
  required String data,
  required String symbology,
  required int orderOnTray,
}) {
  final map = <String, Object?>{};
  map['data'] = data;
  map['symbology'] = symbology;
  map['orderOnTray'] = orderOnTray;
  return map;
}

/// Additional (mostly hidden) context settings used only in rare cases.
class ContextSettings {
  final bool? shouldEnableSubscriptionVerifierV2;

  /// Keys present in the payload that have no emitted field -- undeclared
  /// keys, plus schema-declared properties that are `hidden` or non-mobile and
  /// therefore get no field of their own. Re-emitted by [toJson] so the round
  /// trip is lossless. See the passthrough contract in this file's header.
  final Map<String, Object?> additionalProperties;

  const ContextSettings({
    this.shouldEnableSubscriptionVerifierV2,
    this.additionalProperties = const {},
  });

  factory ContextSettings.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('ContextSettings: expected a Map');
    }
    final hasShouldEnableSubscriptionVerifierV2 = raw.containsKey('shouldEnableSubscriptionVerifierV2');
    final shouldEnableSubscriptionVerifierV2Raw = raw['shouldEnableSubscriptionVerifierV2'];
    bool? shouldEnableSubscriptionVerifierV2Value;
    if (hasShouldEnableSubscriptionVerifierV2 && shouldEnableSubscriptionVerifierV2Raw != null) {
      if (shouldEnableSubscriptionVerifierV2Raw is! bool) {
        throw FormatException('ContextSettings.shouldEnableSubscriptionVerifierV2: expected a bool');
      }
      shouldEnableSubscriptionVerifierV2Value = shouldEnableSubscriptionVerifierV2Raw;
    } else if (hasShouldEnableSubscriptionVerifierV2 && shouldEnableSubscriptionVerifierV2Raw == null) {
      throw FormatException('ContextSettings.shouldEnableSubscriptionVerifierV2: null is not allowed');
    }
    const emittedKeys = <String>{
      'shouldEnableSubscriptionVerifierV2',
    };
    final additionalPropertiesCollected = <String, Object?>{};
    for (final key in raw.keys) {
      // A non-String key never matches `emittedKeys` (a Set<String>), so
      // every one of them reaches this throw: an open class rejects
      // non-String keys outright.
      if (!emittedKeys.contains(key)) {
        if (key is! String) {
          throw FormatException('ContextSettings: expected a String key');
        }
        additionalPropertiesCollected[key] = raw[key];
      }
    }
    return ContextSettings(
      shouldEnableSubscriptionVerifierV2: shouldEnableSubscriptionVerifierV2Value,
      additionalProperties: Map.unmodifiable(additionalPropertiesCollected),
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (shouldEnableSubscriptionVerifierV2 != null) {
      map['shouldEnableSubscriptionVerifierV2'] = shouldEnableSubscriptionVerifierV2;
    }
    for (final entry in additionalProperties.entries) {
      if (!map.containsKey(entry.key)) {
        map[entry.key] = entry.value;
      }
    }
    return map;
  }
}

/// Typed builder for the `ContextSettings` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildContextSettings({
  bool? shouldEnableSubscriptionVerifierV2,
}) {
  final map = <String, Object?>{};
  if (shouldEnableSubscriptionVerifierV2 != null) {
    map['shouldEnableSubscriptionVerifierV2'] = shouldEnableSubscriptionVerifierV2;
  }
  return map;
}

/// A 2D point in absolute pixel coordinates. Unlike UIPoint its coordinates carry no unit, because frame and view coordinates are always pixels.
class PixelPoint {
  final double x;
  final double y;

  const PixelPoint({
    required this.x,
    required this.y,
  });

  factory PixelPoint.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('PixelPoint: expected a Map');
    }
    const allowedKeys = <String>{
      'x',
      'y',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("PixelPoint: unknown property '$key'");
      }
    }
    final hasX = raw.containsKey('x');
    if (!hasX) {
      throw FormatException("PixelPoint.x: missing required property");
    }
    final xRaw = raw['x'];
    double? xValue;
    if (hasX && xRaw != null) {
      if (xRaw is! num) {
        throw FormatException('PixelPoint.x: expected a number');
      }
      xValue = xRaw.toDouble();
    } else if (hasX && xRaw == null) {
      throw FormatException('PixelPoint.x: null is not allowed');
    }
    final hasY = raw.containsKey('y');
    if (!hasY) {
      throw FormatException("PixelPoint.y: missing required property");
    }
    final yRaw = raw['y'];
    double? yValue;
    if (hasY && yRaw != null) {
      if (yRaw is! num) {
        throw FormatException('PixelPoint.y: expected a number');
      }
      yValue = yRaw.toDouble();
    } else if (hasY && yRaw == null) {
      throw FormatException('PixelPoint.y: null is not allowed');
    }
    return PixelPoint(
      x: xValue!,
      y: yValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['x'] = x;
    map['y'] = y;
    return map;
  }
}

/// Typed builder for the `PixelPoint` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildPixelPoint({
  required double x,
  required double y,
}) {
  final map = <String, Object?>{};
  map['x'] = x;
  map['y'] = y;
  return map;
}

/// A quadrilateral whose four corners are absolute pixel coordinates. The unitless counterpart of Quadrilateral, used for frame and view geometry.
class PixelQuadrilateral {
  final PixelPoint topLeft;
  final PixelPoint topRight;
  final PixelPoint bottomRight;
  final PixelPoint bottomLeft;

  const PixelQuadrilateral({
    required this.topLeft,
    required this.topRight,
    required this.bottomRight,
    required this.bottomLeft,
  });

  factory PixelQuadrilateral.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('PixelQuadrilateral: expected a Map');
    }
    const allowedKeys = <String>{
      'topLeft',
      'topRight',
      'bottomRight',
      'bottomLeft',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("PixelQuadrilateral: unknown property '$key'");
      }
    }
    final hasTopLeft = raw.containsKey('topLeft');
    if (!hasTopLeft) {
      throw FormatException("PixelQuadrilateral.topLeft: missing required property");
    }
    final topLeftRaw = raw['topLeft'];
    PixelPoint? topLeftValue;
    if (hasTopLeft && topLeftRaw != null) {
      topLeftValue = PixelPoint.fromJson(topLeftRaw);
    } else if (hasTopLeft && topLeftRaw == null) {
      throw FormatException('PixelQuadrilateral.topLeft: null is not allowed');
    }
    final hasTopRight = raw.containsKey('topRight');
    if (!hasTopRight) {
      throw FormatException("PixelQuadrilateral.topRight: missing required property");
    }
    final topRightRaw = raw['topRight'];
    PixelPoint? topRightValue;
    if (hasTopRight && topRightRaw != null) {
      topRightValue = PixelPoint.fromJson(topRightRaw);
    } else if (hasTopRight && topRightRaw == null) {
      throw FormatException('PixelQuadrilateral.topRight: null is not allowed');
    }
    final hasBottomRight = raw.containsKey('bottomRight');
    if (!hasBottomRight) {
      throw FormatException("PixelQuadrilateral.bottomRight: missing required property");
    }
    final bottomRightRaw = raw['bottomRight'];
    PixelPoint? bottomRightValue;
    if (hasBottomRight && bottomRightRaw != null) {
      bottomRightValue = PixelPoint.fromJson(bottomRightRaw);
    } else if (hasBottomRight && bottomRightRaw == null) {
      throw FormatException('PixelQuadrilateral.bottomRight: null is not allowed');
    }
    final hasBottomLeft = raw.containsKey('bottomLeft');
    if (!hasBottomLeft) {
      throw FormatException("PixelQuadrilateral.bottomLeft: missing required property");
    }
    final bottomLeftRaw = raw['bottomLeft'];
    PixelPoint? bottomLeftValue;
    if (hasBottomLeft && bottomLeftRaw != null) {
      bottomLeftValue = PixelPoint.fromJson(bottomLeftRaw);
    } else if (hasBottomLeft && bottomLeftRaw == null) {
      throw FormatException('PixelQuadrilateral.bottomLeft: null is not allowed');
    }
    return PixelQuadrilateral(
      topLeft: topLeftValue!,
      topRight: topRightValue!,
      bottomRight: bottomRightValue!,
      bottomLeft: bottomLeftValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['topLeft'] = topLeft.toJson();
    map['topRight'] = topRight.toJson();
    map['bottomRight'] = bottomRight.toJson();
    map['bottomLeft'] = bottomLeft.toJson();
    return map;
  }
}

/// Typed builder for the `PixelQuadrilateral` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildPixelQuadrilateral({
  required Object topLeft,
  required Object topRight,
  required Object bottomRight,
  required Object bottomLeft,
}) {
  final map = <String, Object?>{};
  map['topLeft'] = topLeft;
  map['topRight'] = topRight;
  map['bottomRight'] = bottomRight;
  map['bottomLeft'] = bottomLeft;
  return map;
}

/// The view that renders the camera feed and overlays for data capture.
class DataCaptureView {
  final int? viewId;
  final int? parentId;
  final UIPoint? pointOfInterest;
  final MarginsWithUnit? scanAreaMargins;
  final Anchor? logoAnchor;
  final UIPoint? logoOffset;
  final bool? logoHidden;
  final LogoStyle? logoStyle;
  final List<Overlay>? overlays;
  final List<Control>? controls;
  final FocusGesture? focusGesture;
  @Deprecated('since 8.4')
  final ZoomGesture? zoomGesture;
  final List<ZoomGesture>? zoomGestures;
  final bool? shouldShowZoomNotification;

  const DataCaptureView({
    this.viewId,
    this.parentId,
    this.pointOfInterest,
    this.scanAreaMargins,
    this.logoAnchor,
    this.logoOffset,
    this.logoHidden,
    this.logoStyle,
    this.overlays,
    this.controls,
    this.focusGesture,
    this.zoomGesture,
    this.zoomGestures,
    this.shouldShowZoomNotification,
  });

  factory DataCaptureView.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('DataCaptureView: expected a Map');
    }
    const allowedKeys = <String>{
      'viewId',
      'parentId',
      'pointOfInterest',
      'scanAreaMargins',
      'logoAnchor',
      'logoOffset',
      'logoHidden',
      'logoStyle',
      'overlays',
      'controls',
      'focusGesture',
      'zoomGesture',
      'zoomGestures',
      'optimizesRendering',
      'shouldShowZoomNotification',
      'properties',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("DataCaptureView: unknown property '$key'");
      }
    }
    final hasViewId = raw.containsKey('viewId');
    final viewIdRaw = raw['viewId'];
    int? viewIdValue;
    if (hasViewId && viewIdRaw != null) {
      if (viewIdRaw is! num) {
        throw FormatException('DataCaptureView.viewId: expected a number');
      }
      if (viewIdRaw != viewIdRaw.toInt()) {
        throw FormatException('DataCaptureView.viewId: expected an integer');
      }
      viewIdValue = viewIdRaw.toInt();
    } else if (hasViewId && viewIdRaw == null) {
      throw FormatException('DataCaptureView.viewId: null is not allowed');
    }
    final hasParentId = raw.containsKey('parentId');
    final parentIdRaw = raw['parentId'];
    int? parentIdValue;
    if (hasParentId && parentIdRaw != null) {
      if (parentIdRaw is! num) {
        throw FormatException('DataCaptureView.parentId: expected a number');
      }
      if (parentIdRaw != parentIdRaw.toInt()) {
        throw FormatException('DataCaptureView.parentId: expected an integer');
      }
      parentIdValue = parentIdRaw.toInt();
    }
    final hasPointOfInterest = raw.containsKey('pointOfInterest');
    final pointOfInterestRaw = raw['pointOfInterest'];
    UIPoint? pointOfInterestValue;
    if (hasPointOfInterest && pointOfInterestRaw != null) {
      pointOfInterestValue = UIPoint.fromJson(pointOfInterestRaw);
    } else if (hasPointOfInterest && pointOfInterestRaw == null) {
      throw FormatException('DataCaptureView.pointOfInterest: null is not allowed');
    }
    final hasScanAreaMargins = raw.containsKey('scanAreaMargins');
    final scanAreaMarginsRaw = raw['scanAreaMargins'];
    MarginsWithUnit? scanAreaMarginsValue;
    if (hasScanAreaMargins && scanAreaMarginsRaw != null) {
      scanAreaMarginsValue = MarginsWithUnit.fromJson(scanAreaMarginsRaw);
    } else if (hasScanAreaMargins && scanAreaMarginsRaw == null) {
      throw FormatException('DataCaptureView.scanAreaMargins: null is not allowed');
    }
    final hasLogoAnchor = raw.containsKey('logoAnchor');
    final logoAnchorRaw = raw['logoAnchor'];
    Anchor? logoAnchorValue;
    if (hasLogoAnchor && logoAnchorRaw != null) {
      logoAnchorValue = (logoAnchorRaw is! String
          ? (throw FormatException('DataCaptureView.logoAnchor: expected a String for Anchor'))
          : Anchor.fromJSON(logoAnchorRaw));
    } else if (hasLogoAnchor && logoAnchorRaw == null) {
      throw FormatException('DataCaptureView.logoAnchor: null is not allowed');
    }
    final hasLogoOffset = raw.containsKey('logoOffset');
    final logoOffsetRaw = raw['logoOffset'];
    UIPoint? logoOffsetValue;
    if (hasLogoOffset && logoOffsetRaw != null) {
      logoOffsetValue = UIPoint.fromJson(logoOffsetRaw);
    } else if (hasLogoOffset && logoOffsetRaw == null) {
      throw FormatException('DataCaptureView.logoOffset: null is not allowed');
    }
    final hasLogoHidden = raw.containsKey('logoHidden');
    final logoHiddenRaw = raw['logoHidden'];
    bool? logoHiddenValue;
    if (hasLogoHidden && logoHiddenRaw != null) {
      if (logoHiddenRaw is! bool) {
        throw FormatException('DataCaptureView.logoHidden: expected a bool');
      }
      logoHiddenValue = logoHiddenRaw;
    } else if (hasLogoHidden && logoHiddenRaw == null) {
      throw FormatException('DataCaptureView.logoHidden: null is not allowed');
    }
    final hasLogoStyle = raw.containsKey('logoStyle');
    final logoStyleRaw = raw['logoStyle'];
    LogoStyle? logoStyleValue;
    if (hasLogoStyle && logoStyleRaw != null) {
      logoStyleValue = (logoStyleRaw is! String
          ? (throw FormatException('DataCaptureView.logoStyle: expected a String for LogoStyle'))
          : LogoStyle.fromJSON(logoStyleRaw));
    } else if (hasLogoStyle && logoStyleRaw == null) {
      throw FormatException('DataCaptureView.logoStyle: null is not allowed');
    }
    final hasOverlays = raw.containsKey('overlays');
    final overlaysRaw = raw['overlays'];
    List<Overlay>? overlaysValue;
    if (hasOverlays && overlaysRaw != null) {
      if (overlaysRaw is! List) {
        throw FormatException('DataCaptureView.overlays: expected a List');
      }
      overlaysValue = overlaysRaw.map((item) => Overlay.fromJson(item)).toList();
    } else if (hasOverlays && overlaysRaw == null) {
      throw FormatException('DataCaptureView.overlays: null is not allowed');
    }
    final hasControls = raw.containsKey('controls');
    final controlsRaw = raw['controls'];
    List<Control>? controlsValue;
    if (hasControls && controlsRaw != null) {
      if (controlsRaw is! List) {
        throw FormatException('DataCaptureView.controls: expected a List');
      }
      controlsValue = controlsRaw.map((item) => Control.fromJson(item)).toList();
    } else if (hasControls && controlsRaw == null) {
      throw FormatException('DataCaptureView.controls: null is not allowed');
    }
    final hasFocusGesture = raw.containsKey('focusGesture');
    final focusGestureRaw = raw['focusGesture'];
    FocusGesture? focusGestureValue;
    if (hasFocusGesture && focusGestureRaw != null) {
      focusGestureValue = FocusGesture.fromJson(focusGestureRaw);
    }
    final hasZoomGesture = raw.containsKey('zoomGesture');
    final zoomGestureRaw = raw['zoomGesture'];
    ZoomGesture? zoomGestureValue;
    if (hasZoomGesture && zoomGestureRaw != null) {
      zoomGestureValue = ZoomGesture.fromJson(zoomGestureRaw);
    }
    final hasZoomGestures = raw.containsKey('zoomGestures');
    final zoomGesturesRaw = raw['zoomGestures'];
    List<ZoomGesture>? zoomGesturesValue;
    if (hasZoomGestures && zoomGesturesRaw != null) {
      if (zoomGesturesRaw is! List) {
        throw FormatException('DataCaptureView.zoomGestures: expected a List');
      }
      zoomGesturesValue = zoomGesturesRaw.map((item) => ZoomGesture.fromJson(item)).toList();
    } else if (hasZoomGestures && zoomGesturesRaw == null) {
      throw FormatException('DataCaptureView.zoomGestures: null is not allowed');
    }
    final hasShouldShowZoomNotification = raw.containsKey('shouldShowZoomNotification');
    final shouldShowZoomNotificationRaw = raw['shouldShowZoomNotification'];
    bool? shouldShowZoomNotificationValue;
    if (hasShouldShowZoomNotification && shouldShowZoomNotificationRaw != null) {
      if (shouldShowZoomNotificationRaw is! bool) {
        throw FormatException('DataCaptureView.shouldShowZoomNotification: expected a bool');
      }
      shouldShowZoomNotificationValue = shouldShowZoomNotificationRaw;
    } else if (hasShouldShowZoomNotification && shouldShowZoomNotificationRaw == null) {
      throw FormatException('DataCaptureView.shouldShowZoomNotification: null is not allowed');
    }
    return DataCaptureView(
      viewId: viewIdValue,
      parentId: parentIdValue,
      pointOfInterest: pointOfInterestValue,
      scanAreaMargins: scanAreaMarginsValue,
      logoAnchor: logoAnchorValue,
      logoOffset: logoOffsetValue,
      logoHidden: logoHiddenValue,
      logoStyle: logoStyleValue,
      overlays: overlaysValue,
      controls: controlsValue,
      focusGesture: focusGestureValue,
      zoomGesture: zoomGestureValue,
      zoomGestures: zoomGesturesValue,
      shouldShowZoomNotification: shouldShowZoomNotificationValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (viewId != null) {
      map['viewId'] = viewId;
    }
    if (parentId != null) {
      map['parentId'] = parentId;
    }
    if (pointOfInterest != null) {
      map['pointOfInterest'] = pointOfInterest!.toJson();
    }
    if (scanAreaMargins != null) {
      map['scanAreaMargins'] = scanAreaMargins!.toJson();
    }
    if (logoAnchor != null) {
      map['logoAnchor'] = logoAnchor!.toJson();
    }
    if (logoOffset != null) {
      map['logoOffset'] = logoOffset!.toJson();
    }
    if (logoHidden != null) {
      map['logoHidden'] = logoHidden;
    }
    if (logoStyle != null) {
      map['logoStyle'] = logoStyle!.toJson();
    }
    if (overlays != null) {
      map['overlays'] = overlays!.map((item) => item.toJson()).toList();
    }
    if (controls != null) {
      map['controls'] = controls!.map((item) => item.toJson()).toList();
    }
    if (focusGesture != null) {
      map['focusGesture'] = focusGesture!.toJson();
    }
    if (zoomGesture != null) {
      map['zoomGesture'] = zoomGesture!.toJson();
    }
    if (zoomGestures != null) {
      map['zoomGestures'] = zoomGestures!.map((item) => item.toJson()).toList();
    }
    if (shouldShowZoomNotification != null) {
      map['shouldShowZoomNotification'] = shouldShowZoomNotification;
    }
    return map;
  }
}

/// Typed builder for the `DataCaptureView` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildDataCaptureView({
  int? viewId,
  Object? parentId = _unset,
  Object? pointOfInterest,
  Object? scanAreaMargins,
  Object? logoAnchor,
  Object? logoOffset,
  bool? logoHidden,
  Object? logoStyle,
  List<Object?>? overlays,
  List<Object?>? controls,
  Object? focusGesture = _unset,
  Object? zoomGesture = _unset,
  List<Object?>? zoomGestures,
  bool? shouldShowZoomNotification,
}) {
  final map = <String, Object?>{};
  if (viewId != null) {
    map['viewId'] = viewId;
  }
  if (!identical(parentId, _unset)) {
    map['parentId'] = parentId;
  }
  if (pointOfInterest != null) {
    map['pointOfInterest'] = pointOfInterest;
  }
  if (scanAreaMargins != null) {
    map['scanAreaMargins'] = scanAreaMargins;
  }
  if (logoAnchor != null) {
    map['logoAnchor'] = logoAnchor;
  }
  if (logoOffset != null) {
    map['logoOffset'] = logoOffset;
  }
  if (logoHidden != null) {
    map['logoHidden'] = logoHidden;
  }
  if (logoStyle != null) {
    map['logoStyle'] = logoStyle;
  }
  if (overlays != null) {
    map['overlays'] = overlays;
  }
  if (controls != null) {
    map['controls'] = controls;
  }
  if (!identical(focusGesture, _unset)) {
    map['focusGesture'] = focusGesture;
  }
  if (!identical(zoomGesture, _unset)) {
    map['zoomGesture'] = zoomGesture;
  }
  if (zoomGestures != null) {
    map['zoomGestures'] = zoomGestures;
  }
  if (shouldShowZoomNotification != null) {
    map['shouldShowZoomNotification'] = shouldShowZoomNotification;
  }
  return map;
}

///
class MarginsWithUnit {
  final UIValue? left;
  final UIValue? top;
  final UIValue? right;
  final UIValue? bottom;

  const MarginsWithUnit({
    this.left,
    this.top,
    this.right,
    this.bottom,
  });

  factory MarginsWithUnit.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('MarginsWithUnit: expected a Map');
    }
    const allowedKeys = <String>{
      'left',
      'top',
      'right',
      'bottom',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("MarginsWithUnit: unknown property '$key'");
      }
    }
    final hasLeft = raw.containsKey('left');
    final leftRaw = raw['left'];
    UIValue? leftValue;
    if (hasLeft && leftRaw != null) {
      leftValue = UIValue.fromJson(leftRaw);
    } else if (hasLeft && leftRaw == null) {
      throw FormatException('MarginsWithUnit.left: null is not allowed');
    }
    final hasTop = raw.containsKey('top');
    final topRaw = raw['top'];
    UIValue? topValue;
    if (hasTop && topRaw != null) {
      topValue = UIValue.fromJson(topRaw);
    } else if (hasTop && topRaw == null) {
      throw FormatException('MarginsWithUnit.top: null is not allowed');
    }
    final hasRight = raw.containsKey('right');
    final rightRaw = raw['right'];
    UIValue? rightValue;
    if (hasRight && rightRaw != null) {
      rightValue = UIValue.fromJson(rightRaw);
    } else if (hasRight && rightRaw == null) {
      throw FormatException('MarginsWithUnit.right: null is not allowed');
    }
    final hasBottom = raw.containsKey('bottom');
    final bottomRaw = raw['bottom'];
    UIValue? bottomValue;
    if (hasBottom && bottomRaw != null) {
      bottomValue = UIValue.fromJson(bottomRaw);
    } else if (hasBottom && bottomRaw == null) {
      throw FormatException('MarginsWithUnit.bottom: null is not allowed');
    }
    return MarginsWithUnit(
      left: leftValue,
      top: topValue,
      right: rightValue,
      bottom: bottomValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (left != null) {
      map['left'] = left!.toJson();
    }
    if (top != null) {
      map['top'] = top!.toJson();
    }
    if (right != null) {
      map['right'] = right!.toJson();
    }
    if (bottom != null) {
      map['bottom'] = bottom!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `MarginsWithUnit` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildMarginsWithUnit({
  Object? left,
  Object? top,
  Object? right,
  Object? bottom,
}) {
  final map = <String, Object?>{};
  if (left != null) {
    map['left'] = left;
  }
  if (top != null) {
    map['top'] = top;
  }
  if (right != null) {
    map['right'] = right;
  }
  if (bottom != null) {
    map['bottom'] = bottom;
  }
  return map;
}

/// A named anchor position within a rectangular area.
enum Anchor {
  topLeft('topLeft'),
  topCenter('topCenter'),
  topRight('topRight'),
  centerLeft('centerLeft'),
  center('center'),
  centerRight('centerRight'),
  bottomLeft('bottomLeft'),
  bottomCenter('bottomCenter'),
  bottomRight('bottomRight');

  const Anchor(this.jsonValue);

  final String jsonValue;

  static Anchor fromJSON(String jsonValue) {
    for (final value in Anchor.values) {
      if (value.jsonValue == jsonValue) {
        return value;
      }
    }
    throw FormatException("Anchor: unknown enum value '$jsonValue'");
  }

  String toJson() => jsonValue;
}

/// The visual style of the Scandit logo shown in a data capture view.
enum LogoStyle {
  minimal('minimal'),
  extended('extended');

  const LogoStyle(this.jsonValue);

  final String jsonValue;

  static LogoStyle fromJSON(String jsonValue) {
    for (final value in LogoStyle.values) {
      if (value.jsonValue == jsonValue) {
        return value;
      }
    }
    throw FormatException("LogoStyle: unknown enum value '$jsonValue'");
  }

  String toJson() => jsonValue;
}

/// Discriminated union of all data capture overlays. The type field selects the concrete schema.
// NOTE: `abstract class`, not `abstract interface class`. The generated Dart
// must parse under the OLDEST toolchain in CI -- validate-bridge-generator's
// `dart format` runs on an older Dart SDK that does not understand Dart 3.0+
// class modifiers (`interface`, `sealed`, `base`, `final class`,
// `mixin class`). The docs signature collector moved to `analyzer ^7.7.1` in
// SDC-33150 and parses those fine, so it is no longer part of this
// constraint; `dart format` still is. `abstract class` is implementable in
// Dart 2 and 3 alike, so it preserves the same "implement, don't extend"
// contract without the modifier.
abstract class Overlay {
  Map<String, Object?> toJson();

  factory Overlay.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('Overlay: expected a Map');
    }
    final discriminant = raw['type'];
    switch (discriminant) {
      case 'barcodeCapture':
        return BarcodeCaptureOverlay.fromJson(raw);
      case 'barcodeTrackingBasic':
        return BarcodeTrackingBasicOverlay.fromJson(raw);
      case 'barcodeTrackingAdvanced':
        return BarcodeTrackingAdvancedOverlay.fromJson(raw);
      case 'barcodeSelectionBasic':
        return BarcodeSelectionBasicOverlay.fromJson(raw);
      case 'labelCaptureBasic':
        return LabelCaptureBasicOverlay.fromJson(raw);
      case 'labelCaptureAdvanced':
        return LabelCaptureAdvancedOverlay.fromJson(raw);
      case 'validationFlow':
        return LabelCaptureValidationFlowOverlay.fromJson(raw);
      case 'receiptScanning':
        return LabelCaptureAdaptiveRecognitionOverlay.fromJson(raw);
      case 'idCapture':
        return IdCaptureOverlay.fromJson(raw);
      case 'textCapture':
        return TextCaptureOverlay.fromJson(raw);
      case 'barcodeCountBasic':
        return BarcodeCountOverlay.fromJson(raw);
      default:
        throw FormatException(
          "Overlay: unknown type '$discriminant'",
        );
    }
  }
}

/// The overlay for barcode capture, rendering location highlights and a viewfinder.
class BarcodeCaptureOverlay implements Overlay {
  final String type;
  final Brush? brush;
  final Brush? selectionBrush;
  final Viewfinder? viewfinder;
  final bool? shouldShowScanAreaGuides;
  final bool? drawLocalizedOnlyBarcodes;
  final bool? shouldRemoveLocationsAfterScan;
  final int? modeId;

  const BarcodeCaptureOverlay({
    required this.type,
    this.brush,
    this.selectionBrush,
    this.viewfinder,
    this.shouldShowScanAreaGuides,
    this.drawLocalizedOnlyBarcodes,
    this.shouldRemoveLocationsAfterScan,
    this.modeId,
  });

  factory BarcodeCaptureOverlay.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('BarcodeCaptureOverlay: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'brush',
      'selectionBrush',
      'viewfinder',
      'shouldShowScanAreaGuides',
      'drawLocalizedOnlyBarcodes',
      'shouldRemoveLocationsAfterScan',
      'modeId',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("BarcodeCaptureOverlay: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("BarcodeCaptureOverlay.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['barcodeCapture'].contains(typeRaw)) {
        throw FormatException("BarcodeCaptureOverlay.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('BarcodeCaptureOverlay.type: null is not allowed');
    }
    final hasBrush = raw.containsKey('brush');
    final brushRaw = raw['brush'];
    Brush? brushValue;
    if (hasBrush && brushRaw != null) {
      brushValue = Brush.fromJson(brushRaw);
    } else if (hasBrush && brushRaw == null) {
      throw FormatException('BarcodeCaptureOverlay.brush: null is not allowed');
    }
    final hasSelectionBrush = raw.containsKey('selectionBrush');
    final selectionBrushRaw = raw['selectionBrush'];
    Brush? selectionBrushValue;
    if (hasSelectionBrush && selectionBrushRaw != null) {
      selectionBrushValue = Brush.fromJson(selectionBrushRaw);
    } else if (hasSelectionBrush && selectionBrushRaw == null) {
      throw FormatException('BarcodeCaptureOverlay.selectionBrush: null is not allowed');
    }
    final hasViewfinder = raw.containsKey('viewfinder');
    final viewfinderRaw = raw['viewfinder'];
    Viewfinder? viewfinderValue;
    if (hasViewfinder && viewfinderRaw != null) {
      viewfinderValue = Viewfinder.fromJson(viewfinderRaw);
    } else if (hasViewfinder && viewfinderRaw == null) {
      throw FormatException('BarcodeCaptureOverlay.viewfinder: null is not allowed');
    }
    final hasShouldShowScanAreaGuides = raw.containsKey('shouldShowScanAreaGuides');
    final shouldShowScanAreaGuidesRaw = raw['shouldShowScanAreaGuides'];
    bool? shouldShowScanAreaGuidesValue;
    if (hasShouldShowScanAreaGuides && shouldShowScanAreaGuidesRaw != null) {
      if (shouldShowScanAreaGuidesRaw is! bool) {
        throw FormatException('BarcodeCaptureOverlay.shouldShowScanAreaGuides: expected a bool');
      }
      shouldShowScanAreaGuidesValue = shouldShowScanAreaGuidesRaw;
    } else if (hasShouldShowScanAreaGuides && shouldShowScanAreaGuidesRaw == null) {
      throw FormatException('BarcodeCaptureOverlay.shouldShowScanAreaGuides: null is not allowed');
    }
    final hasDrawLocalizedOnlyBarcodes = raw.containsKey('drawLocalizedOnlyBarcodes');
    final drawLocalizedOnlyBarcodesRaw = raw['drawLocalizedOnlyBarcodes'];
    bool? drawLocalizedOnlyBarcodesValue;
    if (hasDrawLocalizedOnlyBarcodes && drawLocalizedOnlyBarcodesRaw != null) {
      if (drawLocalizedOnlyBarcodesRaw is! bool) {
        throw FormatException('BarcodeCaptureOverlay.drawLocalizedOnlyBarcodes: expected a bool');
      }
      drawLocalizedOnlyBarcodesValue = drawLocalizedOnlyBarcodesRaw;
    } else if (hasDrawLocalizedOnlyBarcodes && drawLocalizedOnlyBarcodesRaw == null) {
      throw FormatException('BarcodeCaptureOverlay.drawLocalizedOnlyBarcodes: null is not allowed');
    }
    final hasShouldRemoveLocationsAfterScan = raw.containsKey('shouldRemoveLocationsAfterScan');
    final shouldRemoveLocationsAfterScanRaw = raw['shouldRemoveLocationsAfterScan'];
    bool? shouldRemoveLocationsAfterScanValue;
    if (hasShouldRemoveLocationsAfterScan && shouldRemoveLocationsAfterScanRaw != null) {
      if (shouldRemoveLocationsAfterScanRaw is! bool) {
        throw FormatException('BarcodeCaptureOverlay.shouldRemoveLocationsAfterScan: expected a bool');
      }
      shouldRemoveLocationsAfterScanValue = shouldRemoveLocationsAfterScanRaw;
    } else if (hasShouldRemoveLocationsAfterScan && shouldRemoveLocationsAfterScanRaw == null) {
      throw FormatException('BarcodeCaptureOverlay.shouldRemoveLocationsAfterScan: null is not allowed');
    }
    final hasModeId = raw.containsKey('modeId');
    final modeIdRaw = raw['modeId'];
    int? modeIdValue;
    if (hasModeId && modeIdRaw != null) {
      if (modeIdRaw is! num) {
        throw FormatException('BarcodeCaptureOverlay.modeId: expected a number');
      }
      if (modeIdRaw != modeIdRaw.toInt()) {
        throw FormatException('BarcodeCaptureOverlay.modeId: expected an integer');
      }
      modeIdValue = modeIdRaw.toInt();
    } else if (hasModeId && modeIdRaw == null) {
      throw FormatException('BarcodeCaptureOverlay.modeId: null is not allowed');
    }
    return BarcodeCaptureOverlay(
      type: typeValue!,
      brush: brushValue,
      selectionBrush: selectionBrushValue,
      viewfinder: viewfinderValue,
      shouldShowScanAreaGuides: shouldShowScanAreaGuidesValue,
      drawLocalizedOnlyBarcodes: drawLocalizedOnlyBarcodesValue,
      shouldRemoveLocationsAfterScan: shouldRemoveLocationsAfterScanValue,
      modeId: modeIdValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (brush != null) {
      map['brush'] = brush!.toJson();
    }
    if (selectionBrush != null) {
      map['selectionBrush'] = selectionBrush!.toJson();
    }
    if (viewfinder != null) {
      map['viewfinder'] = viewfinder!.toJson();
    }
    if (shouldShowScanAreaGuides != null) {
      map['shouldShowScanAreaGuides'] = shouldShowScanAreaGuides;
    }
    if (drawLocalizedOnlyBarcodes != null) {
      map['drawLocalizedOnlyBarcodes'] = drawLocalizedOnlyBarcodes;
    }
    if (shouldRemoveLocationsAfterScan != null) {
      map['shouldRemoveLocationsAfterScan'] = shouldRemoveLocationsAfterScan;
    }
    if (modeId != null) {
      map['modeId'] = modeId;
    }
    return map;
  }
}

/// Typed builder for the `BarcodeCaptureOverlay` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildBarcodeCaptureOverlay({
  required String type,
  Object? brush,
  Object? selectionBrush,
  Object? viewfinder,
  bool? shouldShowScanAreaGuides,
  bool? drawLocalizedOnlyBarcodes,
  bool? shouldRemoveLocationsAfterScan,
  int? modeId,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (brush != null) {
    map['brush'] = brush;
  }
  if (selectionBrush != null) {
    map['selectionBrush'] = selectionBrush;
  }
  if (viewfinder != null) {
    map['viewfinder'] = viewfinder;
  }
  if (shouldShowScanAreaGuides != null) {
    map['shouldShowScanAreaGuides'] = shouldShowScanAreaGuides;
  }
  if (drawLocalizedOnlyBarcodes != null) {
    map['drawLocalizedOnlyBarcodes'] = drawLocalizedOnlyBarcodes;
  }
  if (shouldRemoveLocationsAfterScan != null) {
    map['shouldRemoveLocationsAfterScan'] = shouldRemoveLocationsAfterScan;
  }
  if (modeId != null) {
    map['modeId'] = modeId;
  }
  return map;
}

/// A brush defining fill and stroke appearance.
class Brush {
  final Fill? fill;
  final Stroke? stroke;

  const Brush({
    this.fill,
    this.stroke,
  });

  factory Brush.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('Brush: expected a Map');
    }
    const allowedKeys = <String>{
      'fill',
      'stroke',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("Brush: unknown property '$key'");
      }
    }
    final hasFill = raw.containsKey('fill');
    final fillRaw = raw['fill'];
    Fill? fillValue;
    if (hasFill && fillRaw != null) {
      fillValue = Fill.fromJson(fillRaw);
    } else if (hasFill && fillRaw == null) {
      throw FormatException('Brush.fill: null is not allowed');
    }
    final hasStroke = raw.containsKey('stroke');
    final strokeRaw = raw['stroke'];
    Stroke? strokeValue;
    if (hasStroke && strokeRaw != null) {
      strokeValue = Stroke.fromJson(strokeRaw);
    } else if (hasStroke && strokeRaw == null) {
      throw FormatException('Brush.stroke: null is not allowed');
    }
    return Brush(
      fill: fillValue,
      stroke: strokeValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (fill != null) {
      map['fill'] = fill!.toJson();
    }
    if (stroke != null) {
      map['stroke'] = stroke!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `Brush` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildBrush({
  Object? fill,
  Object? stroke,
}) {
  final map = <String, Object?>{};
  if (fill != null) {
    map['fill'] = fill;
  }
  if (stroke != null) {
    map['stroke'] = stroke;
  }
  return map;
}

///
class Fill {
  final Color? color;

  const Fill({
    this.color,
  });

  factory Fill.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('Fill: expected a Map');
    }
    const allowedKeys = <String>{
      'color',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("Fill: unknown property '$key'");
      }
    }
    final hasColor = raw.containsKey('color');
    final colorRaw = raw['color'];
    Color? colorValue;
    if (hasColor && colorRaw != null) {
      colorValue = parseColor(colorRaw);
    } else if (hasColor && colorRaw == null) {
      throw FormatException('Fill.color: null is not allowed');
    }
    return Fill(
      color: colorValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (color != null) {
      map['color'] = color;
    }
    return map;
  }
}

/// Typed builder for the `Fill` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildFill({
  Color? color,
}) {
  final map = <String, Object?>{};
  if (color != null) {
    map['color'] = color;
  }
  return map;
}

/// A color expressed as a hex string with an optional # prefix. Accepted formats: RGB, RGBA, RRGGBB, RRGGBBAA (case-insensitive).
typedef Color = String;

Color parseColor(Object? raw) {
  if (raw is! String) {
    throw FormatException('Color: expected a String');
  }
  return raw;
}

///
class Stroke {
  final Color? color;
  final double? width;

  const Stroke({
    this.color,
    this.width,
  });

  factory Stroke.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('Stroke: expected a Map');
    }
    const allowedKeys = <String>{
      'color',
      'width',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("Stroke: unknown property '$key'");
      }
    }
    final hasColor = raw.containsKey('color');
    final colorRaw = raw['color'];
    Color? colorValue;
    if (hasColor && colorRaw != null) {
      colorValue = parseColor(colorRaw);
    } else if (hasColor && colorRaw == null) {
      throw FormatException('Stroke.color: null is not allowed');
    }
    final hasWidth = raw.containsKey('width');
    final widthRaw = raw['width'];
    double? widthValue;
    if (hasWidth && widthRaw != null) {
      if (widthRaw is! num) {
        throw FormatException('Stroke.width: expected a number');
      }
      widthValue = widthRaw.toDouble();
    } else if (hasWidth && widthRaw == null) {
      throw FormatException('Stroke.width: null is not allowed');
    }
    return Stroke(
      color: colorValue,
      width: widthValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (color != null) {
      map['color'] = color;
    }
    if (width != null) {
      map['width'] = width;
    }
    return map;
  }
}

/// Typed builder for the `Stroke` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildStroke({
  Color? color,
  double? width,
}) {
  final map = <String, Object?>{};
  if (color != null) {
    map['color'] = color;
  }
  if (width != null) {
    map['width'] = width;
  }
  return map;
}

/// Discriminated union of all viewfinder types. The type field selects the concrete schema.
// NOTE: `abstract class`, not `abstract interface class`. The generated Dart
// must parse under the OLDEST toolchain in CI -- validate-bridge-generator's
// `dart format` runs on an older Dart SDK that does not understand Dart 3.0+
// class modifiers (`interface`, `sealed`, `base`, `final class`,
// `mixin class`). The docs signature collector moved to `analyzer ^7.7.1` in
// SDC-33150 and parses those fine, so it is no longer part of this
// constraint; `dart format` still is. `abstract class` is implementable in
// Dart 2 and 3 alike, so it preserves the same "implement, don't extend"
// contract without the modifier.
abstract class Viewfinder {
  Map<String, Object?> toJson();

  factory Viewfinder.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('Viewfinder: expected a Map');
    }
    final discriminant = raw['type'];
    switch (discriminant) {
      case 'none':
        return NoneViewfinder.fromJson(raw);
      case 'rectangular':
        return RectangularViewfinder.fromJson(raw);
      case 'laserline':
        return LaserlineViewfinder.fromJson(raw);
      case 'spotlight':
        return SpotlightViewfinder.fromJson(raw);
      case 'aimer':
        return AimerViewfinder.fromJson(raw);
      case 'targetAimer':
        return TargetAimerViewfinder.fromJson(raw);
      default:
        throw FormatException(
          "Viewfinder: unknown type '$discriminant'",
        );
    }
  }
}

/// A viewfinder that renders nothing.
class NoneViewfinder implements Viewfinder {
  final String type;
  final UIPoint? pointOfInterest;

  const NoneViewfinder({
    required this.type,
    this.pointOfInterest,
  });

  factory NoneViewfinder.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('NoneViewfinder: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'pointOfInterest',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("NoneViewfinder: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("NoneViewfinder.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['none'].contains(typeRaw)) {
        throw FormatException("NoneViewfinder.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('NoneViewfinder.type: null is not allowed');
    }
    final hasPointOfInterest = raw.containsKey('pointOfInterest');
    final pointOfInterestRaw = raw['pointOfInterest'];
    UIPoint? pointOfInterestValue;
    if (hasPointOfInterest && pointOfInterestRaw != null) {
      pointOfInterestValue = UIPoint.fromJson(pointOfInterestRaw);
    }
    return NoneViewfinder(
      type: typeValue!,
      pointOfInterest: pointOfInterestValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (pointOfInterest != null) {
      map['pointOfInterest'] = pointOfInterest!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `NoneViewfinder` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildNoneViewfinder({
  required String type,
  Object? pointOfInterest = _unset,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (!identical(pointOfInterest, _unset)) {
    map['pointOfInterest'] = pointOfInterest;
  }
  return map;
}

/// A viewfinder that draws a rectangular frame around the scan area.
class RectangularViewfinder implements Viewfinder {
  final String type;
  final String? style;
  final UIAspectSize? size;
  final Color? color;
  final Color? disabledColor;
  final String? lineStyle;
  final double? dimming;
  final double? disabledDimming;
  final RectangularViewfinderAnimation? animation;
  final UIPoint? pointOfInterest;

  const RectangularViewfinder({
    required this.type,
    this.style,
    this.size,
    this.color,
    this.disabledColor,
    this.lineStyle,
    this.dimming,
    this.disabledDimming,
    this.animation,
    this.pointOfInterest,
  });

  factory RectangularViewfinder.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('RectangularViewfinder: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'style',
      'size',
      'color',
      'disabledColor',
      'lineStyle',
      'dimming',
      'disabledDimming',
      'animation',
      'pointOfInterest',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("RectangularViewfinder: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("RectangularViewfinder.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['rectangular'].contains(typeRaw)) {
        throw FormatException("RectangularViewfinder.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('RectangularViewfinder.type: null is not allowed');
    }
    final hasStyle = raw.containsKey('style');
    final styleRaw = raw['style'];
    String? styleValue;
    if (hasStyle && styleRaw != null) {
      if (styleRaw is! String || !const <String>['rounded', 'square'].contains(styleRaw)) {
        throw FormatException("RectangularViewfinder.style: unknown enum value '$styleRaw'");
      }
      styleValue = styleRaw;
    } else if (hasStyle && styleRaw == null) {
      throw FormatException('RectangularViewfinder.style: null is not allowed');
    }
    final hasSize = raw.containsKey('size');
    final sizeRaw = raw['size'];
    UIAspectSize? sizeValue;
    if (hasSize && sizeRaw != null) {
      sizeValue = UIAspectSize.fromJson(sizeRaw);
    } else if (hasSize && sizeRaw == null) {
      throw FormatException('RectangularViewfinder.size: null is not allowed');
    }
    final hasColor = raw.containsKey('color');
    final colorRaw = raw['color'];
    Color? colorValue;
    if (hasColor && colorRaw != null) {
      colorValue = parseColor(colorRaw);
    } else if (hasColor && colorRaw == null) {
      throw FormatException('RectangularViewfinder.color: null is not allowed');
    }
    final hasDisabledColor = raw.containsKey('disabledColor');
    final disabledColorRaw = raw['disabledColor'];
    Color? disabledColorValue;
    if (hasDisabledColor && disabledColorRaw != null) {
      disabledColorValue = parseColor(disabledColorRaw);
    } else if (hasDisabledColor && disabledColorRaw == null) {
      throw FormatException('RectangularViewfinder.disabledColor: null is not allowed');
    }
    final hasLineStyle = raw.containsKey('lineStyle');
    final lineStyleRaw = raw['lineStyle'];
    String? lineStyleValue;
    if (hasLineStyle && lineStyleRaw != null) {
      if (lineStyleRaw is! String || !const <String>['light', 'bold'].contains(lineStyleRaw)) {
        throw FormatException("RectangularViewfinder.lineStyle: unknown enum value '$lineStyleRaw'");
      }
      lineStyleValue = lineStyleRaw;
    } else if (hasLineStyle && lineStyleRaw == null) {
      throw FormatException('RectangularViewfinder.lineStyle: null is not allowed');
    }
    final hasDimming = raw.containsKey('dimming');
    final dimmingRaw = raw['dimming'];
    double? dimmingValue;
    if (hasDimming && dimmingRaw != null) {
      if (dimmingRaw is! num) {
        throw FormatException('RectangularViewfinder.dimming: expected a number');
      }
      dimmingValue = dimmingRaw.toDouble();
    } else if (hasDimming && dimmingRaw == null) {
      throw FormatException('RectangularViewfinder.dimming: null is not allowed');
    }
    final hasDisabledDimming = raw.containsKey('disabledDimming');
    final disabledDimmingRaw = raw['disabledDimming'];
    double? disabledDimmingValue;
    if (hasDisabledDimming && disabledDimmingRaw != null) {
      if (disabledDimmingRaw is! num) {
        throw FormatException('RectangularViewfinder.disabledDimming: expected a number');
      }
      disabledDimmingValue = disabledDimmingRaw.toDouble();
    } else if (hasDisabledDimming && disabledDimmingRaw == null) {
      throw FormatException('RectangularViewfinder.disabledDimming: null is not allowed');
    }
    final hasAnimation = raw.containsKey('animation');
    final animationRaw = raw['animation'];
    RectangularViewfinderAnimation? animationValue;
    if (hasAnimation && animationRaw != null) {
      animationValue = RectangularViewfinderAnimation.fromJson(animationRaw);
    } else if (hasAnimation && animationRaw == null) {
      throw FormatException('RectangularViewfinder.animation: null is not allowed');
    }
    final hasPointOfInterest = raw.containsKey('pointOfInterest');
    final pointOfInterestRaw = raw['pointOfInterest'];
    UIPoint? pointOfInterestValue;
    if (hasPointOfInterest && pointOfInterestRaw != null) {
      pointOfInterestValue = UIPoint.fromJson(pointOfInterestRaw);
    }
    return RectangularViewfinder(
      type: typeValue!,
      style: styleValue,
      size: sizeValue,
      color: colorValue,
      disabledColor: disabledColorValue,
      lineStyle: lineStyleValue,
      dimming: dimmingValue,
      disabledDimming: disabledDimmingValue,
      animation: animationValue,
      pointOfInterest: pointOfInterestValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (style != null) {
      map['style'] = style;
    }
    if (size != null) {
      map['size'] = size!.toJson();
    }
    if (color != null) {
      map['color'] = color;
    }
    if (disabledColor != null) {
      map['disabledColor'] = disabledColor;
    }
    if (lineStyle != null) {
      map['lineStyle'] = lineStyle;
    }
    if (dimming != null) {
      map['dimming'] = dimming;
    }
    if (disabledDimming != null) {
      map['disabledDimming'] = disabledDimming;
    }
    if (animation != null) {
      map['animation'] = animation!.toJson();
    }
    if (pointOfInterest != null) {
      map['pointOfInterest'] = pointOfInterest!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `RectangularViewfinder` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildRectangularViewfinder({
  required String type,
  String? style,
  Object? size,
  Color? color,
  Color? disabledColor,
  String? lineStyle,
  double? dimming,
  double? disabledDimming,
  Object? animation,
  Object? pointOfInterest = _unset,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (style != null) {
    map['style'] = style;
  }
  if (size != null) {
    map['size'] = size;
  }
  if (color != null) {
    map['color'] = color;
  }
  if (disabledColor != null) {
    map['disabledColor'] = disabledColor;
  }
  if (lineStyle != null) {
    map['lineStyle'] = lineStyle;
  }
  if (dimming != null) {
    map['dimming'] = dimming;
  }
  if (disabledDimming != null) {
    map['disabledDimming'] = disabledDimming;
  }
  if (animation != null) {
    map['animation'] = animation;
  }
  if (!identical(pointOfInterest, _unset)) {
    map['pointOfInterest'] = pointOfInterest;
  }
  return map;
}

///
class RectangularViewfinderAnimation {
  final bool? looping;

  const RectangularViewfinderAnimation({
    this.looping,
  });

  factory RectangularViewfinderAnimation.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('RectangularViewfinderAnimation: expected a Map');
    }
    const allowedKeys = <String>{
      'looping',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("RectangularViewfinderAnimation: unknown property '$key'");
      }
    }
    final hasLooping = raw.containsKey('looping');
    final loopingRaw = raw['looping'];
    bool? loopingValue;
    if (hasLooping && loopingRaw != null) {
      if (loopingRaw is! bool) {
        throw FormatException('RectangularViewfinderAnimation.looping: expected a bool');
      }
      loopingValue = loopingRaw;
    } else if (hasLooping && loopingRaw == null) {
      throw FormatException('RectangularViewfinderAnimation.looping: null is not allowed');
    }
    return RectangularViewfinderAnimation(
      looping: loopingValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (looping != null) {
      map['looping'] = looping;
    }
    return map;
  }
}

/// Typed builder for the `RectangularViewfinderAnimation` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildRectangularViewfinderAnimation({
  bool? looping,
}) {
  final map = <String, Object?>{};
  if (looping != null) {
    map['looping'] = looping;
  }
  return map;
}

/// A viewfinder that draws a horizontal laser line across the scan area.
class LaserlineViewfinder implements Viewfinder {
  final String type;
  final String? style;
  final UIValue? width;
  final Color? enabledColor;
  final Color? disabledColor;
  final UIPoint? pointOfInterest;

  const LaserlineViewfinder({
    required this.type,
    this.style,
    this.width,
    this.enabledColor,
    this.disabledColor,
    this.pointOfInterest,
  });

  factory LaserlineViewfinder.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LaserlineViewfinder: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'style',
      'width',
      'enabledColor',
      'disabledColor',
      'pointOfInterest',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("LaserlineViewfinder: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("LaserlineViewfinder.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['laserline'].contains(typeRaw)) {
        throw FormatException("LaserlineViewfinder.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('LaserlineViewfinder.type: null is not allowed');
    }
    final hasStyle = raw.containsKey('style');
    final styleRaw = raw['style'];
    String? styleValue;
    if (hasStyle && styleRaw != null) {
      if (styleRaw is! String || !const <String>['legacy', 'animated'].contains(styleRaw)) {
        throw FormatException("LaserlineViewfinder.style: unknown enum value '$styleRaw'");
      }
      styleValue = styleRaw;
    } else if (hasStyle && styleRaw == null) {
      throw FormatException('LaserlineViewfinder.style: null is not allowed');
    }
    final hasWidth = raw.containsKey('width');
    final widthRaw = raw['width'];
    UIValue? widthValue;
    if (hasWidth && widthRaw != null) {
      widthValue = UIValue.fromJson(widthRaw);
    } else if (hasWidth && widthRaw == null) {
      throw FormatException('LaserlineViewfinder.width: null is not allowed');
    }
    final hasEnabledColor = raw.containsKey('enabledColor');
    final enabledColorRaw = raw['enabledColor'];
    Color? enabledColorValue;
    if (hasEnabledColor && enabledColorRaw != null) {
      enabledColorValue = parseColor(enabledColorRaw);
    } else if (hasEnabledColor && enabledColorRaw == null) {
      throw FormatException('LaserlineViewfinder.enabledColor: null is not allowed');
    }
    final hasDisabledColor = raw.containsKey('disabledColor');
    final disabledColorRaw = raw['disabledColor'];
    Color? disabledColorValue;
    if (hasDisabledColor && disabledColorRaw != null) {
      disabledColorValue = parseColor(disabledColorRaw);
    } else if (hasDisabledColor && disabledColorRaw == null) {
      throw FormatException('LaserlineViewfinder.disabledColor: null is not allowed');
    }
    final hasPointOfInterest = raw.containsKey('pointOfInterest');
    final pointOfInterestRaw = raw['pointOfInterest'];
    UIPoint? pointOfInterestValue;
    if (hasPointOfInterest && pointOfInterestRaw != null) {
      pointOfInterestValue = UIPoint.fromJson(pointOfInterestRaw);
    }
    return LaserlineViewfinder(
      type: typeValue!,
      style: styleValue,
      width: widthValue,
      enabledColor: enabledColorValue,
      disabledColor: disabledColorValue,
      pointOfInterest: pointOfInterestValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (style != null) {
      map['style'] = style;
    }
    if (width != null) {
      map['width'] = width!.toJson();
    }
    if (enabledColor != null) {
      map['enabledColor'] = enabledColor;
    }
    if (disabledColor != null) {
      map['disabledColor'] = disabledColor;
    }
    if (pointOfInterest != null) {
      map['pointOfInterest'] = pointOfInterest!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `LaserlineViewfinder` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildLaserlineViewfinder({
  required String type,
  String? style,
  Object? width,
  Color? enabledColor,
  Color? disabledColor,
  Object? pointOfInterest = _unset,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (style != null) {
    map['style'] = style;
  }
  if (width != null) {
    map['width'] = width;
  }
  if (enabledColor != null) {
    map['enabledColor'] = enabledColor;
  }
  if (disabledColor != null) {
    map['disabledColor'] = disabledColor;
  }
  if (!identical(pointOfInterest, _unset)) {
    map['pointOfInterest'] = pointOfInterest;
  }
  return map;
}

/// A viewfinder that draws a circular spotlight around the scan area. No current SDK (C++, iOS, Android, Web) deserializes this type; retained as a tombstone for backward-compatible payload validation.
class SpotlightViewfinder implements Viewfinder {
  final String type;
  final UIAspectSize? size;
  final Color? enabledBorderColor;
  final Color? disabledBorderColor;
  final UIPoint? pointOfInterest;

  const SpotlightViewfinder({
    required this.type,
    this.size,
    this.enabledBorderColor,
    this.disabledBorderColor,
    this.pointOfInterest,
  });

  factory SpotlightViewfinder.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('SpotlightViewfinder: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'size',
      'enabledBorderColor',
      'disabledBorderColor',
      'pointOfInterest',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("SpotlightViewfinder: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("SpotlightViewfinder.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['spotlight'].contains(typeRaw)) {
        throw FormatException("SpotlightViewfinder.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('SpotlightViewfinder.type: null is not allowed');
    }
    final hasSize = raw.containsKey('size');
    final sizeRaw = raw['size'];
    UIAspectSize? sizeValue;
    if (hasSize && sizeRaw != null) {
      sizeValue = UIAspectSize.fromJson(sizeRaw);
    } else if (hasSize && sizeRaw == null) {
      throw FormatException('SpotlightViewfinder.size: null is not allowed');
    }
    final hasEnabledBorderColor = raw.containsKey('enabledBorderColor');
    final enabledBorderColorRaw = raw['enabledBorderColor'];
    Color? enabledBorderColorValue;
    if (hasEnabledBorderColor && enabledBorderColorRaw != null) {
      enabledBorderColorValue = parseColor(enabledBorderColorRaw);
    } else if (hasEnabledBorderColor && enabledBorderColorRaw == null) {
      throw FormatException('SpotlightViewfinder.enabledBorderColor: null is not allowed');
    }
    final hasDisabledBorderColor = raw.containsKey('disabledBorderColor');
    final disabledBorderColorRaw = raw['disabledBorderColor'];
    Color? disabledBorderColorValue;
    if (hasDisabledBorderColor && disabledBorderColorRaw != null) {
      disabledBorderColorValue = parseColor(disabledBorderColorRaw);
    } else if (hasDisabledBorderColor && disabledBorderColorRaw == null) {
      throw FormatException('SpotlightViewfinder.disabledBorderColor: null is not allowed');
    }
    final hasPointOfInterest = raw.containsKey('pointOfInterest');
    final pointOfInterestRaw = raw['pointOfInterest'];
    UIPoint? pointOfInterestValue;
    if (hasPointOfInterest && pointOfInterestRaw != null) {
      pointOfInterestValue = UIPoint.fromJson(pointOfInterestRaw);
    }
    return SpotlightViewfinder(
      type: typeValue!,
      size: sizeValue,
      enabledBorderColor: enabledBorderColorValue,
      disabledBorderColor: disabledBorderColorValue,
      pointOfInterest: pointOfInterestValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (size != null) {
      map['size'] = size!.toJson();
    }
    if (enabledBorderColor != null) {
      map['enabledBorderColor'] = enabledBorderColor;
    }
    if (disabledBorderColor != null) {
      map['disabledBorderColor'] = disabledBorderColor;
    }
    if (pointOfInterest != null) {
      map['pointOfInterest'] = pointOfInterest!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `SpotlightViewfinder` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildSpotlightViewfinder({
  required String type,
  Object? size,
  Color? enabledBorderColor,
  Color? disabledBorderColor,
  Object? pointOfInterest = _unset,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (size != null) {
    map['size'] = size;
  }
  if (enabledBorderColor != null) {
    map['enabledBorderColor'] = enabledBorderColor;
  }
  if (disabledBorderColor != null) {
    map['disabledBorderColor'] = disabledBorderColor;
  }
  if (!identical(pointOfInterest, _unset)) {
    map['pointOfInterest'] = pointOfInterest;
  }
  return map;
}

/// A viewfinder that draws an aimer frame and dot at the point of interest.
class AimerViewfinder implements Viewfinder {
  final String type;
  final Color? frameColor;
  final Color? dotColor;
  final UIPoint? pointOfInterest;

  const AimerViewfinder({
    required this.type,
    this.frameColor,
    this.dotColor,
    this.pointOfInterest,
  });

  factory AimerViewfinder.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('AimerViewfinder: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'frameColor',
      'dotColor',
      'pointOfInterest',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("AimerViewfinder: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("AimerViewfinder.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['aimer'].contains(typeRaw)) {
        throw FormatException("AimerViewfinder.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('AimerViewfinder.type: null is not allowed');
    }
    final hasFrameColor = raw.containsKey('frameColor');
    final frameColorRaw = raw['frameColor'];
    Color? frameColorValue;
    if (hasFrameColor && frameColorRaw != null) {
      frameColorValue = parseColor(frameColorRaw);
    } else if (hasFrameColor && frameColorRaw == null) {
      throw FormatException('AimerViewfinder.frameColor: null is not allowed');
    }
    final hasDotColor = raw.containsKey('dotColor');
    final dotColorRaw = raw['dotColor'];
    Color? dotColorValue;
    if (hasDotColor && dotColorRaw != null) {
      dotColorValue = parseColor(dotColorRaw);
    } else if (hasDotColor && dotColorRaw == null) {
      throw FormatException('AimerViewfinder.dotColor: null is not allowed');
    }
    final hasPointOfInterest = raw.containsKey('pointOfInterest');
    final pointOfInterestRaw = raw['pointOfInterest'];
    UIPoint? pointOfInterestValue;
    if (hasPointOfInterest && pointOfInterestRaw != null) {
      pointOfInterestValue = UIPoint.fromJson(pointOfInterestRaw);
    }
    return AimerViewfinder(
      type: typeValue!,
      frameColor: frameColorValue,
      dotColor: dotColorValue,
      pointOfInterest: pointOfInterestValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (frameColor != null) {
      map['frameColor'] = frameColor;
    }
    if (dotColor != null) {
      map['dotColor'] = dotColor;
    }
    if (pointOfInterest != null) {
      map['pointOfInterest'] = pointOfInterest!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `AimerViewfinder` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildAimerViewfinder({
  required String type,
  Color? frameColor,
  Color? dotColor,
  Object? pointOfInterest = _unset,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (frameColor != null) {
    map['frameColor'] = frameColor;
  }
  if (dotColor != null) {
    map['dotColor'] = dotColor;
  }
  if (!identical(pointOfInterest, _unset)) {
    map['pointOfInterest'] = pointOfInterest;
  }
  return map;
}

/// A viewfinder that draws a target aimer with crosshair lines and a circular aimer.
class TargetAimerViewfinder implements Viewfinder {
  final String type;
  final Color? lineColor;
  final double? lineStrokeWidth;
  final Color? aimerColor;
  final UIValue? radius;

  const TargetAimerViewfinder({
    required this.type,
    this.lineColor,
    this.lineStrokeWidth,
    this.aimerColor,
    this.radius,
  });

  factory TargetAimerViewfinder.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('TargetAimerViewfinder: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'lineColor',
      'lineStrokeWidth',
      'aimerColor',
      'radius',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("TargetAimerViewfinder: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("TargetAimerViewfinder.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['targetAimer'].contains(typeRaw)) {
        throw FormatException("TargetAimerViewfinder.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('TargetAimerViewfinder.type: null is not allowed');
    }
    final hasLineColor = raw.containsKey('lineColor');
    final lineColorRaw = raw['lineColor'];
    Color? lineColorValue;
    if (hasLineColor && lineColorRaw != null) {
      lineColorValue = parseColor(lineColorRaw);
    } else if (hasLineColor && lineColorRaw == null) {
      throw FormatException('TargetAimerViewfinder.lineColor: null is not allowed');
    }
    final hasLineStrokeWidth = raw.containsKey('lineStrokeWidth');
    final lineStrokeWidthRaw = raw['lineStrokeWidth'];
    double? lineStrokeWidthValue;
    if (hasLineStrokeWidth && lineStrokeWidthRaw != null) {
      if (lineStrokeWidthRaw is! num) {
        throw FormatException('TargetAimerViewfinder.lineStrokeWidth: expected a number');
      }
      lineStrokeWidthValue = lineStrokeWidthRaw.toDouble();
    } else if (hasLineStrokeWidth && lineStrokeWidthRaw == null) {
      throw FormatException('TargetAimerViewfinder.lineStrokeWidth: null is not allowed');
    }
    final hasAimerColor = raw.containsKey('aimerColor');
    final aimerColorRaw = raw['aimerColor'];
    Color? aimerColorValue;
    if (hasAimerColor && aimerColorRaw != null) {
      aimerColorValue = parseColor(aimerColorRaw);
    } else if (hasAimerColor && aimerColorRaw == null) {
      throw FormatException('TargetAimerViewfinder.aimerColor: null is not allowed');
    }
    final hasRadius = raw.containsKey('radius');
    final radiusRaw = raw['radius'];
    UIValue? radiusValue;
    if (hasRadius && radiusRaw != null) {
      radiusValue = UIValue.fromJson(radiusRaw);
    } else if (hasRadius && radiusRaw == null) {
      throw FormatException('TargetAimerViewfinder.radius: null is not allowed');
    }
    return TargetAimerViewfinder(
      type: typeValue!,
      lineColor: lineColorValue,
      lineStrokeWidth: lineStrokeWidthValue,
      aimerColor: aimerColorValue,
      radius: radiusValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (lineColor != null) {
      map['lineColor'] = lineColor;
    }
    if (lineStrokeWidth != null) {
      map['lineStrokeWidth'] = lineStrokeWidth;
    }
    if (aimerColor != null) {
      map['aimerColor'] = aimerColor;
    }
    if (radius != null) {
      map['radius'] = radius!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `TargetAimerViewfinder` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildTargetAimerViewfinder({
  required String type,
  Color? lineColor,
  double? lineStrokeWidth,
  Color? aimerColor,
  Object? radius,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (lineColor != null) {
    map['lineColor'] = lineColor;
  }
  if (lineStrokeWidth != null) {
    map['lineStrokeWidth'] = lineStrokeWidth;
  }
  if (aimerColor != null) {
    map['aimerColor'] = aimerColor;
  }
  if (radius != null) {
    map['radius'] = radius;
  }
  return map;
}

/// The basic overlay for barcode tracking, rendering brush highlights over tracked barcodes.
class BarcodeTrackingBasicOverlay implements Overlay {
  final String type;
  @Deprecated('since 7.0')
  final Brush? defaultBrush;
  final Brush? brush;
  final bool? shouldShowScanAreaGuides;
  final bool? drawLocalizedOnlyBarcodes;
  final String? style;
  final UIValue? dotRadius;
  final int? modeId;
  final bool? hasListener;

  const BarcodeTrackingBasicOverlay({
    required this.type,
    this.defaultBrush,
    this.brush,
    this.shouldShowScanAreaGuides,
    this.drawLocalizedOnlyBarcodes,
    this.style,
    this.dotRadius,
    this.modeId,
    this.hasListener,
  });

  factory BarcodeTrackingBasicOverlay.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('BarcodeTrackingBasicOverlay: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'defaultBrush',
      'brush',
      'shouldShowScanAreaGuides',
      'drawLocalizedOnlyBarcodes',
      'style',
      'dotRadius',
      'modeId',
      'hasListener',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("BarcodeTrackingBasicOverlay: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("BarcodeTrackingBasicOverlay.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['barcodeTrackingBasic'].contains(typeRaw)) {
        throw FormatException("BarcodeTrackingBasicOverlay.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('BarcodeTrackingBasicOverlay.type: null is not allowed');
    }
    final hasDefaultBrush = raw.containsKey('defaultBrush');
    final defaultBrushRaw = raw['defaultBrush'];
    Brush? defaultBrushValue;
    if (hasDefaultBrush && defaultBrushRaw != null) {
      defaultBrushValue = Brush.fromJson(defaultBrushRaw);
    } else if (hasDefaultBrush && defaultBrushRaw == null) {
      throw FormatException('BarcodeTrackingBasicOverlay.defaultBrush: null is not allowed');
    }
    final hasBrush = raw.containsKey('brush');
    final brushRaw = raw['brush'];
    Brush? brushValue;
    if (hasBrush && brushRaw != null) {
      brushValue = Brush.fromJson(brushRaw);
    } else if (hasBrush && brushRaw == null) {
      throw FormatException('BarcodeTrackingBasicOverlay.brush: null is not allowed');
    }
    final hasShouldShowScanAreaGuides = raw.containsKey('shouldShowScanAreaGuides');
    final shouldShowScanAreaGuidesRaw = raw['shouldShowScanAreaGuides'];
    bool? shouldShowScanAreaGuidesValue;
    if (hasShouldShowScanAreaGuides && shouldShowScanAreaGuidesRaw != null) {
      if (shouldShowScanAreaGuidesRaw is! bool) {
        throw FormatException('BarcodeTrackingBasicOverlay.shouldShowScanAreaGuides: expected a bool');
      }
      shouldShowScanAreaGuidesValue = shouldShowScanAreaGuidesRaw;
    } else if (hasShouldShowScanAreaGuides && shouldShowScanAreaGuidesRaw == null) {
      throw FormatException('BarcodeTrackingBasicOverlay.shouldShowScanAreaGuides: null is not allowed');
    }
    final hasDrawLocalizedOnlyBarcodes = raw.containsKey('drawLocalizedOnlyBarcodes');
    final drawLocalizedOnlyBarcodesRaw = raw['drawLocalizedOnlyBarcodes'];
    bool? drawLocalizedOnlyBarcodesValue;
    if (hasDrawLocalizedOnlyBarcodes && drawLocalizedOnlyBarcodesRaw != null) {
      if (drawLocalizedOnlyBarcodesRaw is! bool) {
        throw FormatException('BarcodeTrackingBasicOverlay.drawLocalizedOnlyBarcodes: expected a bool');
      }
      drawLocalizedOnlyBarcodesValue = drawLocalizedOnlyBarcodesRaw;
    } else if (hasDrawLocalizedOnlyBarcodes && drawLocalizedOnlyBarcodesRaw == null) {
      throw FormatException('BarcodeTrackingBasicOverlay.drawLocalizedOnlyBarcodes: null is not allowed');
    }
    final hasStyle = raw.containsKey('style');
    final styleRaw = raw['style'];
    String? styleValue;
    if (hasStyle && styleRaw != null) {
      if (styleRaw is! String || !const <String>['frame', 'dot'].contains(styleRaw)) {
        throw FormatException("BarcodeTrackingBasicOverlay.style: unknown enum value '$styleRaw'");
      }
      styleValue = styleRaw;
    } else if (hasStyle && styleRaw == null) {
      throw FormatException('BarcodeTrackingBasicOverlay.style: null is not allowed');
    }
    final hasDotRadius = raw.containsKey('dotRadius');
    final dotRadiusRaw = raw['dotRadius'];
    UIValue? dotRadiusValue;
    if (hasDotRadius && dotRadiusRaw != null) {
      dotRadiusValue = UIValue.fromJson(dotRadiusRaw);
    } else if (hasDotRadius && dotRadiusRaw == null) {
      throw FormatException('BarcodeTrackingBasicOverlay.dotRadius: null is not allowed');
    }
    final hasModeId = raw.containsKey('modeId');
    final modeIdRaw = raw['modeId'];
    int? modeIdValue;
    if (hasModeId && modeIdRaw != null) {
      if (modeIdRaw is! num) {
        throw FormatException('BarcodeTrackingBasicOverlay.modeId: expected a number');
      }
      if (modeIdRaw != modeIdRaw.toInt()) {
        throw FormatException('BarcodeTrackingBasicOverlay.modeId: expected an integer');
      }
      modeIdValue = modeIdRaw.toInt();
    } else if (hasModeId && modeIdRaw == null) {
      throw FormatException('BarcodeTrackingBasicOverlay.modeId: null is not allowed');
    }
    final hasHasListener = raw.containsKey('hasListener');
    final hasListenerRaw = raw['hasListener'];
    bool? hasListenerValue;
    if (hasHasListener && hasListenerRaw != null) {
      if (hasListenerRaw is! bool) {
        throw FormatException('BarcodeTrackingBasicOverlay.hasListener: expected a bool');
      }
      hasListenerValue = hasListenerRaw;
    } else if (hasHasListener && hasListenerRaw == null) {
      throw FormatException('BarcodeTrackingBasicOverlay.hasListener: null is not allowed');
    }
    return BarcodeTrackingBasicOverlay(
      type: typeValue!,
      defaultBrush: defaultBrushValue,
      brush: brushValue,
      shouldShowScanAreaGuides: shouldShowScanAreaGuidesValue,
      drawLocalizedOnlyBarcodes: drawLocalizedOnlyBarcodesValue,
      style: styleValue,
      dotRadius: dotRadiusValue,
      modeId: modeIdValue,
      hasListener: hasListenerValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (defaultBrush != null) {
      map['defaultBrush'] = defaultBrush!.toJson();
    }
    if (brush != null) {
      map['brush'] = brush!.toJson();
    }
    if (shouldShowScanAreaGuides != null) {
      map['shouldShowScanAreaGuides'] = shouldShowScanAreaGuides;
    }
    if (drawLocalizedOnlyBarcodes != null) {
      map['drawLocalizedOnlyBarcodes'] = drawLocalizedOnlyBarcodes;
    }
    if (style != null) {
      map['style'] = style;
    }
    if (dotRadius != null) {
      map['dotRadius'] = dotRadius!.toJson();
    }
    if (modeId != null) {
      map['modeId'] = modeId;
    }
    if (hasListener != null) {
      map['hasListener'] = hasListener;
    }
    return map;
  }
}

/// Typed builder for the `BarcodeTrackingBasicOverlay` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildBarcodeTrackingBasicOverlay({
  required String type,
  Object? defaultBrush,
  Object? brush,
  bool? shouldShowScanAreaGuides,
  bool? drawLocalizedOnlyBarcodes,
  String? style,
  Object? dotRadius,
  int? modeId,
  bool? hasListener,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (defaultBrush != null) {
    map['defaultBrush'] = defaultBrush;
  }
  if (brush != null) {
    map['brush'] = brush;
  }
  if (shouldShowScanAreaGuides != null) {
    map['shouldShowScanAreaGuides'] = shouldShowScanAreaGuides;
  }
  if (drawLocalizedOnlyBarcodes != null) {
    map['drawLocalizedOnlyBarcodes'] = drawLocalizedOnlyBarcodes;
  }
  if (style != null) {
    map['style'] = style;
  }
  if (dotRadius != null) {
    map['dotRadius'] = dotRadius;
  }
  if (modeId != null) {
    map['modeId'] = modeId;
  }
  if (hasListener != null) {
    map['hasListener'] = hasListener;
  }
  return map;
}

/// The advanced overlay for barcode tracking, allowing custom views anchored to each tracked barcode.
class BarcodeTrackingAdvancedOverlay implements Overlay {
  final String type;
  final bool? shouldShowScanAreaGuides;
  final int? modeId;
  final bool? hasListener;

  const BarcodeTrackingAdvancedOverlay({
    required this.type,
    this.shouldShowScanAreaGuides,
    this.modeId,
    this.hasListener,
  });

  factory BarcodeTrackingAdvancedOverlay.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('BarcodeTrackingAdvancedOverlay: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'shouldShowScanAreaGuides',
      'modeId',
      'hasListener',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("BarcodeTrackingAdvancedOverlay: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("BarcodeTrackingAdvancedOverlay.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['barcodeTrackingAdvanced'].contains(typeRaw)) {
        throw FormatException("BarcodeTrackingAdvancedOverlay.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('BarcodeTrackingAdvancedOverlay.type: null is not allowed');
    }
    final hasShouldShowScanAreaGuides = raw.containsKey('shouldShowScanAreaGuides');
    final shouldShowScanAreaGuidesRaw = raw['shouldShowScanAreaGuides'];
    bool? shouldShowScanAreaGuidesValue;
    if (hasShouldShowScanAreaGuides && shouldShowScanAreaGuidesRaw != null) {
      if (shouldShowScanAreaGuidesRaw is! bool) {
        throw FormatException('BarcodeTrackingAdvancedOverlay.shouldShowScanAreaGuides: expected a bool');
      }
      shouldShowScanAreaGuidesValue = shouldShowScanAreaGuidesRaw;
    } else if (hasShouldShowScanAreaGuides && shouldShowScanAreaGuidesRaw == null) {
      throw FormatException('BarcodeTrackingAdvancedOverlay.shouldShowScanAreaGuides: null is not allowed');
    }
    final hasModeId = raw.containsKey('modeId');
    final modeIdRaw = raw['modeId'];
    int? modeIdValue;
    if (hasModeId && modeIdRaw != null) {
      if (modeIdRaw is! num) {
        throw FormatException('BarcodeTrackingAdvancedOverlay.modeId: expected a number');
      }
      if (modeIdRaw != modeIdRaw.toInt()) {
        throw FormatException('BarcodeTrackingAdvancedOverlay.modeId: expected an integer');
      }
      modeIdValue = modeIdRaw.toInt();
    } else if (hasModeId && modeIdRaw == null) {
      throw FormatException('BarcodeTrackingAdvancedOverlay.modeId: null is not allowed');
    }
    final hasHasListener = raw.containsKey('hasListener');
    final hasListenerRaw = raw['hasListener'];
    bool? hasListenerValue;
    if (hasHasListener && hasListenerRaw != null) {
      if (hasListenerRaw is! bool) {
        throw FormatException('BarcodeTrackingAdvancedOverlay.hasListener: expected a bool');
      }
      hasListenerValue = hasListenerRaw;
    } else if (hasHasListener && hasListenerRaw == null) {
      throw FormatException('BarcodeTrackingAdvancedOverlay.hasListener: null is not allowed');
    }
    return BarcodeTrackingAdvancedOverlay(
      type: typeValue!,
      shouldShowScanAreaGuides: shouldShowScanAreaGuidesValue,
      modeId: modeIdValue,
      hasListener: hasListenerValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (shouldShowScanAreaGuides != null) {
      map['shouldShowScanAreaGuides'] = shouldShowScanAreaGuides;
    }
    if (modeId != null) {
      map['modeId'] = modeId;
    }
    if (hasListener != null) {
      map['hasListener'] = hasListener;
    }
    return map;
  }
}

/// Typed builder for the `BarcodeTrackingAdvancedOverlay` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildBarcodeTrackingAdvancedOverlay({
  required String type,
  bool? shouldShowScanAreaGuides,
  int? modeId,
  bool? hasListener,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (shouldShowScanAreaGuides != null) {
    map['shouldShowScanAreaGuides'] = shouldShowScanAreaGuides;
  }
  if (modeId != null) {
    map['modeId'] = modeId;
  }
  if (hasListener != null) {
    map['hasListener'] = hasListener;
  }
  return map;
}

/// The basic overlay for barcode selection, rendering brush highlights for tracked, aimed, selecting, and selected barcodes.
class BarcodeSelectionBasicOverlay implements Overlay {
  final String type;
  final Brush? trackedBrush;
  final Brush? aimedBrush;
  final Brush? selectingBrush;
  final Brush? selectedBrush;
  final bool? shouldShowHints;
  final bool? shouldShowScanAreaGuides;
  final Viewfinder? viewfinder;
  final String? style;
  final Color? frozenBackgroundColor;
  final String? textForSelectOrDoubleTapToFreezeHint;
  final String? textForTapToSelectHint;
  final String? textForDoubleTapToUnfreezeHint;
  final String? textForTapAnywhereToSelectHint;
  final String? textForAimToSelectAutoHint;
  final int? modeId;
  final bool? hasAimedBrushProvider;
  final bool? hasTrackedBrushProvider;

  const BarcodeSelectionBasicOverlay({
    required this.type,
    this.trackedBrush,
    this.aimedBrush,
    this.selectingBrush,
    this.selectedBrush,
    this.shouldShowHints,
    this.shouldShowScanAreaGuides,
    this.viewfinder,
    this.style,
    this.frozenBackgroundColor,
    this.textForSelectOrDoubleTapToFreezeHint,
    this.textForTapToSelectHint,
    this.textForDoubleTapToUnfreezeHint,
    this.textForTapAnywhereToSelectHint,
    this.textForAimToSelectAutoHint,
    this.modeId,
    this.hasAimedBrushProvider,
    this.hasTrackedBrushProvider,
  });

  factory BarcodeSelectionBasicOverlay.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('BarcodeSelectionBasicOverlay: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'trackedBrush',
      'aimedBrush',
      'selectingBrush',
      'selectedBrush',
      'shouldShowHints',
      'shouldShowScanAreaGuides',
      'viewfinder',
      'style',
      'frozenBackgroundColor',
      'textForSelectOrDoubleTapToFreezeHint',
      'textForTapToSelectHint',
      'textForDoubleTapToUnfreezeHint',
      'textForTapAnywhereToSelectHint',
      'textForAimToSelectAutoHint',
      'modeId',
      'hasAimedBrushProvider',
      'hasTrackedBrushProvider',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("BarcodeSelectionBasicOverlay: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("BarcodeSelectionBasicOverlay.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['barcodeSelectionBasic'].contains(typeRaw)) {
        throw FormatException("BarcodeSelectionBasicOverlay.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('BarcodeSelectionBasicOverlay.type: null is not allowed');
    }
    final hasTrackedBrush = raw.containsKey('trackedBrush');
    final trackedBrushRaw = raw['trackedBrush'];
    Brush? trackedBrushValue;
    if (hasTrackedBrush && trackedBrushRaw != null) {
      trackedBrushValue = Brush.fromJson(trackedBrushRaw);
    } else if (hasTrackedBrush && trackedBrushRaw == null) {
      throw FormatException('BarcodeSelectionBasicOverlay.trackedBrush: null is not allowed');
    }
    final hasAimedBrush = raw.containsKey('aimedBrush');
    final aimedBrushRaw = raw['aimedBrush'];
    Brush? aimedBrushValue;
    if (hasAimedBrush && aimedBrushRaw != null) {
      aimedBrushValue = Brush.fromJson(aimedBrushRaw);
    } else if (hasAimedBrush && aimedBrushRaw == null) {
      throw FormatException('BarcodeSelectionBasicOverlay.aimedBrush: null is not allowed');
    }
    final hasSelectingBrush = raw.containsKey('selectingBrush');
    final selectingBrushRaw = raw['selectingBrush'];
    Brush? selectingBrushValue;
    if (hasSelectingBrush && selectingBrushRaw != null) {
      selectingBrushValue = Brush.fromJson(selectingBrushRaw);
    } else if (hasSelectingBrush && selectingBrushRaw == null) {
      throw FormatException('BarcodeSelectionBasicOverlay.selectingBrush: null is not allowed');
    }
    final hasSelectedBrush = raw.containsKey('selectedBrush');
    final selectedBrushRaw = raw['selectedBrush'];
    Brush? selectedBrushValue;
    if (hasSelectedBrush && selectedBrushRaw != null) {
      selectedBrushValue = Brush.fromJson(selectedBrushRaw);
    } else if (hasSelectedBrush && selectedBrushRaw == null) {
      throw FormatException('BarcodeSelectionBasicOverlay.selectedBrush: null is not allowed');
    }
    final hasShouldShowHints = raw.containsKey('shouldShowHints');
    final shouldShowHintsRaw = raw['shouldShowHints'];
    bool? shouldShowHintsValue;
    if (hasShouldShowHints && shouldShowHintsRaw != null) {
      if (shouldShowHintsRaw is! bool) {
        throw FormatException('BarcodeSelectionBasicOverlay.shouldShowHints: expected a bool');
      }
      shouldShowHintsValue = shouldShowHintsRaw;
    } else if (hasShouldShowHints && shouldShowHintsRaw == null) {
      throw FormatException('BarcodeSelectionBasicOverlay.shouldShowHints: null is not allowed');
    }
    final hasShouldShowScanAreaGuides = raw.containsKey('shouldShowScanAreaGuides');
    final shouldShowScanAreaGuidesRaw = raw['shouldShowScanAreaGuides'];
    bool? shouldShowScanAreaGuidesValue;
    if (hasShouldShowScanAreaGuides && shouldShowScanAreaGuidesRaw != null) {
      if (shouldShowScanAreaGuidesRaw is! bool) {
        throw FormatException('BarcodeSelectionBasicOverlay.shouldShowScanAreaGuides: expected a bool');
      }
      shouldShowScanAreaGuidesValue = shouldShowScanAreaGuidesRaw;
    } else if (hasShouldShowScanAreaGuides && shouldShowScanAreaGuidesRaw == null) {
      throw FormatException('BarcodeSelectionBasicOverlay.shouldShowScanAreaGuides: null is not allowed');
    }
    final hasViewfinder = raw.containsKey('viewfinder');
    final viewfinderRaw = raw['viewfinder'];
    Viewfinder? viewfinderValue;
    if (hasViewfinder && viewfinderRaw != null) {
      viewfinderValue = Viewfinder.fromJson(viewfinderRaw);
    } else if (hasViewfinder && viewfinderRaw == null) {
      throw FormatException('BarcodeSelectionBasicOverlay.viewfinder: null is not allowed');
    }
    final hasStyle = raw.containsKey('style');
    final styleRaw = raw['style'];
    String? styleValue;
    if (hasStyle && styleRaw != null) {
      if (styleRaw is! String || !const <String>['dot', 'frame'].contains(styleRaw)) {
        throw FormatException("BarcodeSelectionBasicOverlay.style: unknown enum value '$styleRaw'");
      }
      styleValue = styleRaw;
    } else if (hasStyle && styleRaw == null) {
      throw FormatException('BarcodeSelectionBasicOverlay.style: null is not allowed');
    }
    final hasFrozenBackgroundColor = raw.containsKey('frozenBackgroundColor');
    final frozenBackgroundColorRaw = raw['frozenBackgroundColor'];
    Color? frozenBackgroundColorValue;
    if (hasFrozenBackgroundColor && frozenBackgroundColorRaw != null) {
      frozenBackgroundColorValue = parseColor(frozenBackgroundColorRaw);
    } else if (hasFrozenBackgroundColor && frozenBackgroundColorRaw == null) {
      throw FormatException('BarcodeSelectionBasicOverlay.frozenBackgroundColor: null is not allowed');
    }
    final hasTextForSelectOrDoubleTapToFreezeHint = raw.containsKey('textForSelectOrDoubleTapToFreezeHint');
    final textForSelectOrDoubleTapToFreezeHintRaw = raw['textForSelectOrDoubleTapToFreezeHint'];
    String? textForSelectOrDoubleTapToFreezeHintValue;
    if (hasTextForSelectOrDoubleTapToFreezeHint && textForSelectOrDoubleTapToFreezeHintRaw != null) {
      if (textForSelectOrDoubleTapToFreezeHintRaw is! String) {
        throw FormatException('BarcodeSelectionBasicOverlay.textForSelectOrDoubleTapToFreezeHint: expected a String');
      }
      textForSelectOrDoubleTapToFreezeHintValue = textForSelectOrDoubleTapToFreezeHintRaw;
    } else if (hasTextForSelectOrDoubleTapToFreezeHint && textForSelectOrDoubleTapToFreezeHintRaw == null) {
      throw FormatException('BarcodeSelectionBasicOverlay.textForSelectOrDoubleTapToFreezeHint: null is not allowed');
    }
    final hasTextForTapToSelectHint = raw.containsKey('textForTapToSelectHint');
    final textForTapToSelectHintRaw = raw['textForTapToSelectHint'];
    String? textForTapToSelectHintValue;
    if (hasTextForTapToSelectHint && textForTapToSelectHintRaw != null) {
      if (textForTapToSelectHintRaw is! String) {
        throw FormatException('BarcodeSelectionBasicOverlay.textForTapToSelectHint: expected a String');
      }
      textForTapToSelectHintValue = textForTapToSelectHintRaw;
    } else if (hasTextForTapToSelectHint && textForTapToSelectHintRaw == null) {
      throw FormatException('BarcodeSelectionBasicOverlay.textForTapToSelectHint: null is not allowed');
    }
    final hasTextForDoubleTapToUnfreezeHint = raw.containsKey('textForDoubleTapToUnfreezeHint');
    final textForDoubleTapToUnfreezeHintRaw = raw['textForDoubleTapToUnfreezeHint'];
    String? textForDoubleTapToUnfreezeHintValue;
    if (hasTextForDoubleTapToUnfreezeHint && textForDoubleTapToUnfreezeHintRaw != null) {
      if (textForDoubleTapToUnfreezeHintRaw is! String) {
        throw FormatException('BarcodeSelectionBasicOverlay.textForDoubleTapToUnfreezeHint: expected a String');
      }
      textForDoubleTapToUnfreezeHintValue = textForDoubleTapToUnfreezeHintRaw;
    } else if (hasTextForDoubleTapToUnfreezeHint && textForDoubleTapToUnfreezeHintRaw == null) {
      throw FormatException('BarcodeSelectionBasicOverlay.textForDoubleTapToUnfreezeHint: null is not allowed');
    }
    final hasTextForTapAnywhereToSelectHint = raw.containsKey('textForTapAnywhereToSelectHint');
    final textForTapAnywhereToSelectHintRaw = raw['textForTapAnywhereToSelectHint'];
    String? textForTapAnywhereToSelectHintValue;
    if (hasTextForTapAnywhereToSelectHint && textForTapAnywhereToSelectHintRaw != null) {
      if (textForTapAnywhereToSelectHintRaw is! String) {
        throw FormatException('BarcodeSelectionBasicOverlay.textForTapAnywhereToSelectHint: expected a String');
      }
      textForTapAnywhereToSelectHintValue = textForTapAnywhereToSelectHintRaw;
    } else if (hasTextForTapAnywhereToSelectHint && textForTapAnywhereToSelectHintRaw == null) {
      throw FormatException('BarcodeSelectionBasicOverlay.textForTapAnywhereToSelectHint: null is not allowed');
    }
    final hasTextForAimToSelectAutoHint = raw.containsKey('textForAimToSelectAutoHint');
    final textForAimToSelectAutoHintRaw = raw['textForAimToSelectAutoHint'];
    String? textForAimToSelectAutoHintValue;
    if (hasTextForAimToSelectAutoHint && textForAimToSelectAutoHintRaw != null) {
      if (textForAimToSelectAutoHintRaw is! String) {
        throw FormatException('BarcodeSelectionBasicOverlay.textForAimToSelectAutoHint: expected a String');
      }
      textForAimToSelectAutoHintValue = textForAimToSelectAutoHintRaw;
    } else if (hasTextForAimToSelectAutoHint && textForAimToSelectAutoHintRaw == null) {
      throw FormatException('BarcodeSelectionBasicOverlay.textForAimToSelectAutoHint: null is not allowed');
    }
    final hasModeId = raw.containsKey('modeId');
    final modeIdRaw = raw['modeId'];
    int? modeIdValue;
    if (hasModeId && modeIdRaw != null) {
      if (modeIdRaw is! num) {
        throw FormatException('BarcodeSelectionBasicOverlay.modeId: expected a number');
      }
      if (modeIdRaw != modeIdRaw.toInt()) {
        throw FormatException('BarcodeSelectionBasicOverlay.modeId: expected an integer');
      }
      modeIdValue = modeIdRaw.toInt();
    } else if (hasModeId && modeIdRaw == null) {
      throw FormatException('BarcodeSelectionBasicOverlay.modeId: null is not allowed');
    }
    final hasHasAimedBrushProvider = raw.containsKey('hasAimedBrushProvider');
    final hasAimedBrushProviderRaw = raw['hasAimedBrushProvider'];
    bool? hasAimedBrushProviderValue;
    if (hasHasAimedBrushProvider && hasAimedBrushProviderRaw != null) {
      if (hasAimedBrushProviderRaw is! bool) {
        throw FormatException('BarcodeSelectionBasicOverlay.hasAimedBrushProvider: expected a bool');
      }
      hasAimedBrushProviderValue = hasAimedBrushProviderRaw;
    } else if (hasHasAimedBrushProvider && hasAimedBrushProviderRaw == null) {
      throw FormatException('BarcodeSelectionBasicOverlay.hasAimedBrushProvider: null is not allowed');
    }
    final hasHasTrackedBrushProvider = raw.containsKey('hasTrackedBrushProvider');
    final hasTrackedBrushProviderRaw = raw['hasTrackedBrushProvider'];
    bool? hasTrackedBrushProviderValue;
    if (hasHasTrackedBrushProvider && hasTrackedBrushProviderRaw != null) {
      if (hasTrackedBrushProviderRaw is! bool) {
        throw FormatException('BarcodeSelectionBasicOverlay.hasTrackedBrushProvider: expected a bool');
      }
      hasTrackedBrushProviderValue = hasTrackedBrushProviderRaw;
    } else if (hasHasTrackedBrushProvider && hasTrackedBrushProviderRaw == null) {
      throw FormatException('BarcodeSelectionBasicOverlay.hasTrackedBrushProvider: null is not allowed');
    }
    return BarcodeSelectionBasicOverlay(
      type: typeValue!,
      trackedBrush: trackedBrushValue,
      aimedBrush: aimedBrushValue,
      selectingBrush: selectingBrushValue,
      selectedBrush: selectedBrushValue,
      shouldShowHints: shouldShowHintsValue,
      shouldShowScanAreaGuides: shouldShowScanAreaGuidesValue,
      viewfinder: viewfinderValue,
      style: styleValue,
      frozenBackgroundColor: frozenBackgroundColorValue,
      textForSelectOrDoubleTapToFreezeHint: textForSelectOrDoubleTapToFreezeHintValue,
      textForTapToSelectHint: textForTapToSelectHintValue,
      textForDoubleTapToUnfreezeHint: textForDoubleTapToUnfreezeHintValue,
      textForTapAnywhereToSelectHint: textForTapAnywhereToSelectHintValue,
      textForAimToSelectAutoHint: textForAimToSelectAutoHintValue,
      modeId: modeIdValue,
      hasAimedBrushProvider: hasAimedBrushProviderValue,
      hasTrackedBrushProvider: hasTrackedBrushProviderValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (trackedBrush != null) {
      map['trackedBrush'] = trackedBrush!.toJson();
    }
    if (aimedBrush != null) {
      map['aimedBrush'] = aimedBrush!.toJson();
    }
    if (selectingBrush != null) {
      map['selectingBrush'] = selectingBrush!.toJson();
    }
    if (selectedBrush != null) {
      map['selectedBrush'] = selectedBrush!.toJson();
    }
    if (shouldShowHints != null) {
      map['shouldShowHints'] = shouldShowHints;
    }
    if (shouldShowScanAreaGuides != null) {
      map['shouldShowScanAreaGuides'] = shouldShowScanAreaGuides;
    }
    if (viewfinder != null) {
      map['viewfinder'] = viewfinder!.toJson();
    }
    if (style != null) {
      map['style'] = style;
    }
    if (frozenBackgroundColor != null) {
      map['frozenBackgroundColor'] = frozenBackgroundColor;
    }
    if (textForSelectOrDoubleTapToFreezeHint != null) {
      map['textForSelectOrDoubleTapToFreezeHint'] = textForSelectOrDoubleTapToFreezeHint;
    }
    if (textForTapToSelectHint != null) {
      map['textForTapToSelectHint'] = textForTapToSelectHint;
    }
    if (textForDoubleTapToUnfreezeHint != null) {
      map['textForDoubleTapToUnfreezeHint'] = textForDoubleTapToUnfreezeHint;
    }
    if (textForTapAnywhereToSelectHint != null) {
      map['textForTapAnywhereToSelectHint'] = textForTapAnywhereToSelectHint;
    }
    if (textForAimToSelectAutoHint != null) {
      map['textForAimToSelectAutoHint'] = textForAimToSelectAutoHint;
    }
    if (modeId != null) {
      map['modeId'] = modeId;
    }
    if (hasAimedBrushProvider != null) {
      map['hasAimedBrushProvider'] = hasAimedBrushProvider;
    }
    if (hasTrackedBrushProvider != null) {
      map['hasTrackedBrushProvider'] = hasTrackedBrushProvider;
    }
    return map;
  }
}

/// Typed builder for the `BarcodeSelectionBasicOverlay` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildBarcodeSelectionBasicOverlay({
  required String type,
  Object? trackedBrush,
  Object? aimedBrush,
  Object? selectingBrush,
  Object? selectedBrush,
  bool? shouldShowHints,
  bool? shouldShowScanAreaGuides,
  Object? viewfinder,
  String? style,
  Color? frozenBackgroundColor,
  String? textForSelectOrDoubleTapToFreezeHint,
  String? textForTapToSelectHint,
  String? textForDoubleTapToUnfreezeHint,
  String? textForTapAnywhereToSelectHint,
  String? textForAimToSelectAutoHint,
  int? modeId,
  bool? hasAimedBrushProvider,
  bool? hasTrackedBrushProvider,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (trackedBrush != null) {
    map['trackedBrush'] = trackedBrush;
  }
  if (aimedBrush != null) {
    map['aimedBrush'] = aimedBrush;
  }
  if (selectingBrush != null) {
    map['selectingBrush'] = selectingBrush;
  }
  if (selectedBrush != null) {
    map['selectedBrush'] = selectedBrush;
  }
  if (shouldShowHints != null) {
    map['shouldShowHints'] = shouldShowHints;
  }
  if (shouldShowScanAreaGuides != null) {
    map['shouldShowScanAreaGuides'] = shouldShowScanAreaGuides;
  }
  if (viewfinder != null) {
    map['viewfinder'] = viewfinder;
  }
  if (style != null) {
    map['style'] = style;
  }
  if (frozenBackgroundColor != null) {
    map['frozenBackgroundColor'] = frozenBackgroundColor;
  }
  if (textForSelectOrDoubleTapToFreezeHint != null) {
    map['textForSelectOrDoubleTapToFreezeHint'] = textForSelectOrDoubleTapToFreezeHint;
  }
  if (textForTapToSelectHint != null) {
    map['textForTapToSelectHint'] = textForTapToSelectHint;
  }
  if (textForDoubleTapToUnfreezeHint != null) {
    map['textForDoubleTapToUnfreezeHint'] = textForDoubleTapToUnfreezeHint;
  }
  if (textForTapAnywhereToSelectHint != null) {
    map['textForTapAnywhereToSelectHint'] = textForTapAnywhereToSelectHint;
  }
  if (textForAimToSelectAutoHint != null) {
    map['textForAimToSelectAutoHint'] = textForAimToSelectAutoHint;
  }
  if (modeId != null) {
    map['modeId'] = modeId;
  }
  if (hasAimedBrushProvider != null) {
    map['hasAimedBrushProvider'] = hasAimedBrushProvider;
  }
  if (hasTrackedBrushProvider != null) {
    map['hasTrackedBrushProvider'] = hasTrackedBrushProvider;
  }
  return map;
}

/// The basic overlay for label capture, rendering location highlights for label fields.
class LabelCaptureBasicOverlay implements Overlay {
  final String type;
  final FieldBrushes? fieldBrushes;
  final Brush? labelBrush;
  final Viewfinder? viewfinder;
  final bool? shouldShowScanAreaGuides;
  final int? modeId;
  final bool? hasListener;

  const LabelCaptureBasicOverlay({
    required this.type,
    this.fieldBrushes,
    this.labelBrush,
    this.viewfinder,
    this.shouldShowScanAreaGuides,
    this.modeId,
    this.hasListener,
  });

  factory LabelCaptureBasicOverlay.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LabelCaptureBasicOverlay: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'fieldBrushes',
      'labelBrush',
      'viewfinder',
      'shouldShowScanAreaGuides',
      'modeId',
      'hasListener',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("LabelCaptureBasicOverlay: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("LabelCaptureBasicOverlay.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['labelCaptureBasic'].contains(typeRaw)) {
        throw FormatException("LabelCaptureBasicOverlay.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('LabelCaptureBasicOverlay.type: null is not allowed');
    }
    final hasFieldBrushes = raw.containsKey('fieldBrushes');
    final fieldBrushesRaw = raw['fieldBrushes'];
    FieldBrushes? fieldBrushesValue;
    if (hasFieldBrushes && fieldBrushesRaw != null) {
      fieldBrushesValue = FieldBrushes.fromJson(fieldBrushesRaw);
    } else if (hasFieldBrushes && fieldBrushesRaw == null) {
      throw FormatException('LabelCaptureBasicOverlay.fieldBrushes: null is not allowed');
    }
    final hasLabelBrush = raw.containsKey('labelBrush');
    final labelBrushRaw = raw['labelBrush'];
    Brush? labelBrushValue;
    if (hasLabelBrush && labelBrushRaw != null) {
      labelBrushValue = Brush.fromJson(labelBrushRaw);
    } else if (hasLabelBrush && labelBrushRaw == null) {
      throw FormatException('LabelCaptureBasicOverlay.labelBrush: null is not allowed');
    }
    final hasViewfinder = raw.containsKey('viewfinder');
    final viewfinderRaw = raw['viewfinder'];
    Viewfinder? viewfinderValue;
    if (hasViewfinder && viewfinderRaw != null) {
      viewfinderValue = Viewfinder.fromJson(viewfinderRaw);
    } else if (hasViewfinder && viewfinderRaw == null) {
      throw FormatException('LabelCaptureBasicOverlay.viewfinder: null is not allowed');
    }
    final hasShouldShowScanAreaGuides = raw.containsKey('shouldShowScanAreaGuides');
    final shouldShowScanAreaGuidesRaw = raw['shouldShowScanAreaGuides'];
    bool? shouldShowScanAreaGuidesValue;
    if (hasShouldShowScanAreaGuides && shouldShowScanAreaGuidesRaw != null) {
      if (shouldShowScanAreaGuidesRaw is! bool) {
        throw FormatException('LabelCaptureBasicOverlay.shouldShowScanAreaGuides: expected a bool');
      }
      shouldShowScanAreaGuidesValue = shouldShowScanAreaGuidesRaw;
    } else if (hasShouldShowScanAreaGuides && shouldShowScanAreaGuidesRaw == null) {
      throw FormatException('LabelCaptureBasicOverlay.shouldShowScanAreaGuides: null is not allowed');
    }
    final hasModeId = raw.containsKey('modeId');
    final modeIdRaw = raw['modeId'];
    int? modeIdValue;
    if (hasModeId && modeIdRaw != null) {
      if (modeIdRaw is! num) {
        throw FormatException('LabelCaptureBasicOverlay.modeId: expected a number');
      }
      if (modeIdRaw != modeIdRaw.toInt()) {
        throw FormatException('LabelCaptureBasicOverlay.modeId: expected an integer');
      }
      modeIdValue = modeIdRaw.toInt();
    } else if (hasModeId && modeIdRaw == null) {
      throw FormatException('LabelCaptureBasicOverlay.modeId: null is not allowed');
    }
    final hasHasListener = raw.containsKey('hasListener');
    final hasListenerRaw = raw['hasListener'];
    bool? hasListenerValue;
    if (hasHasListener && hasListenerRaw != null) {
      if (hasListenerRaw is! bool) {
        throw FormatException('LabelCaptureBasicOverlay.hasListener: expected a bool');
      }
      hasListenerValue = hasListenerRaw;
    } else if (hasHasListener && hasListenerRaw == null) {
      throw FormatException('LabelCaptureBasicOverlay.hasListener: null is not allowed');
    }
    return LabelCaptureBasicOverlay(
      type: typeValue!,
      fieldBrushes: fieldBrushesValue,
      labelBrush: labelBrushValue,
      viewfinder: viewfinderValue,
      shouldShowScanAreaGuides: shouldShowScanAreaGuidesValue,
      modeId: modeIdValue,
      hasListener: hasListenerValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (fieldBrushes != null) {
      map['fieldBrushes'] = fieldBrushes!.toJson();
    }
    if (labelBrush != null) {
      map['labelBrush'] = labelBrush!.toJson();
    }
    if (viewfinder != null) {
      map['viewfinder'] = viewfinder!.toJson();
    }
    if (shouldShowScanAreaGuides != null) {
      map['shouldShowScanAreaGuides'] = shouldShowScanAreaGuides;
    }
    if (modeId != null) {
      map['modeId'] = modeId;
    }
    if (hasListener != null) {
      map['hasListener'] = hasListener;
    }
    return map;
  }
}

/// Typed builder for the `LabelCaptureBasicOverlay` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildLabelCaptureBasicOverlay({
  required String type,
  Object? fieldBrushes,
  Object? labelBrush,
  Object? viewfinder,
  bool? shouldShowScanAreaGuides,
  int? modeId,
  bool? hasListener,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (fieldBrushes != null) {
    map['fieldBrushes'] = fieldBrushes;
  }
  if (labelBrush != null) {
    map['labelBrush'] = labelBrush;
  }
  if (viewfinder != null) {
    map['viewfinder'] = viewfinder;
  }
  if (shouldShowScanAreaGuides != null) {
    map['shouldShowScanAreaGuides'] = shouldShowScanAreaGuides;
  }
  if (modeId != null) {
    map['modeId'] = modeId;
  }
  if (hasListener != null) {
    map['hasListener'] = hasListener;
  }
  return map;
}

/// Default brushes for different field states.
class FieldBrushes {
  final Brush? captured;
  final Brush? predicted;

  const FieldBrushes({
    this.captured,
    this.predicted,
  });

  factory FieldBrushes.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('FieldBrushes: expected a Map');
    }
    const allowedKeys = <String>{
      'captured',
      'predicted',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("FieldBrushes: unknown property '$key'");
      }
    }
    final hasCaptured = raw.containsKey('captured');
    final capturedRaw = raw['captured'];
    Brush? capturedValue;
    if (hasCaptured && capturedRaw != null) {
      capturedValue = Brush.fromJson(capturedRaw);
    } else if (hasCaptured && capturedRaw == null) {
      throw FormatException('FieldBrushes.captured: null is not allowed');
    }
    final hasPredicted = raw.containsKey('predicted');
    final predictedRaw = raw['predicted'];
    Brush? predictedValue;
    if (hasPredicted && predictedRaw != null) {
      predictedValue = Brush.fromJson(predictedRaw);
    } else if (hasPredicted && predictedRaw == null) {
      throw FormatException('FieldBrushes.predicted: null is not allowed');
    }
    return FieldBrushes(
      captured: capturedValue,
      predicted: predictedValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (captured != null) {
      map['captured'] = captured!.toJson();
    }
    if (predicted != null) {
      map['predicted'] = predicted!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `FieldBrushes` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildFieldBrushes({
  Object? captured,
  Object? predicted,
}) {
  final map = <String, Object?>{};
  if (captured != null) {
    map['captured'] = captured;
  }
  if (predicted != null) {
    map['predicted'] = predicted;
  }
  return map;
}

/// The advanced overlay for label capture, supporting custom AR annotations per label.
class LabelCaptureAdvancedOverlay implements Overlay {
  final String type;
  final bool? shouldShowScanAreaGuides;
  final int? modeId;
  final bool? hasListener;

  const LabelCaptureAdvancedOverlay({
    required this.type,
    this.shouldShowScanAreaGuides,
    this.modeId,
    this.hasListener,
  });

  factory LabelCaptureAdvancedOverlay.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LabelCaptureAdvancedOverlay: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'shouldShowScanAreaGuides',
      'modeId',
      'hasListener',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("LabelCaptureAdvancedOverlay: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("LabelCaptureAdvancedOverlay.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['labelCaptureAdvanced'].contains(typeRaw)) {
        throw FormatException("LabelCaptureAdvancedOverlay.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('LabelCaptureAdvancedOverlay.type: null is not allowed');
    }
    final hasShouldShowScanAreaGuides = raw.containsKey('shouldShowScanAreaGuides');
    final shouldShowScanAreaGuidesRaw = raw['shouldShowScanAreaGuides'];
    bool? shouldShowScanAreaGuidesValue;
    if (hasShouldShowScanAreaGuides && shouldShowScanAreaGuidesRaw != null) {
      if (shouldShowScanAreaGuidesRaw is! bool) {
        throw FormatException('LabelCaptureAdvancedOverlay.shouldShowScanAreaGuides: expected a bool');
      }
      shouldShowScanAreaGuidesValue = shouldShowScanAreaGuidesRaw;
    } else if (hasShouldShowScanAreaGuides && shouldShowScanAreaGuidesRaw == null) {
      throw FormatException('LabelCaptureAdvancedOverlay.shouldShowScanAreaGuides: null is not allowed');
    }
    final hasModeId = raw.containsKey('modeId');
    final modeIdRaw = raw['modeId'];
    int? modeIdValue;
    if (hasModeId && modeIdRaw != null) {
      if (modeIdRaw is! num) {
        throw FormatException('LabelCaptureAdvancedOverlay.modeId: expected a number');
      }
      if (modeIdRaw != modeIdRaw.toInt()) {
        throw FormatException('LabelCaptureAdvancedOverlay.modeId: expected an integer');
      }
      modeIdValue = modeIdRaw.toInt();
    } else if (hasModeId && modeIdRaw == null) {
      throw FormatException('LabelCaptureAdvancedOverlay.modeId: null is not allowed');
    }
    final hasHasListener = raw.containsKey('hasListener');
    final hasListenerRaw = raw['hasListener'];
    bool? hasListenerValue;
    if (hasHasListener && hasListenerRaw != null) {
      if (hasListenerRaw is! bool) {
        throw FormatException('LabelCaptureAdvancedOverlay.hasListener: expected a bool');
      }
      hasListenerValue = hasListenerRaw;
    } else if (hasHasListener && hasListenerRaw == null) {
      throw FormatException('LabelCaptureAdvancedOverlay.hasListener: null is not allowed');
    }
    return LabelCaptureAdvancedOverlay(
      type: typeValue!,
      shouldShowScanAreaGuides: shouldShowScanAreaGuidesValue,
      modeId: modeIdValue,
      hasListener: hasListenerValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (shouldShowScanAreaGuides != null) {
      map['shouldShowScanAreaGuides'] = shouldShowScanAreaGuides;
    }
    if (modeId != null) {
      map['modeId'] = modeId;
    }
    if (hasListener != null) {
      map['hasListener'] = hasListener;
    }
    return map;
  }
}

/// Typed builder for the `LabelCaptureAdvancedOverlay` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildLabelCaptureAdvancedOverlay({
  required String type,
  bool? shouldShowScanAreaGuides,
  int? modeId,
  bool? hasListener,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (shouldShowScanAreaGuides != null) {
    map['shouldShowScanAreaGuides'] = shouldShowScanAreaGuides;
  }
  if (modeId != null) {
    map['modeId'] = modeId;
  }
  if (hasListener != null) {
    map['hasListener'] = hasListener;
  }
  return map;
}

/// The validation flow overlay for label capture, guiding users through manual input of missing or invalid fields.
class LabelCaptureValidationFlowOverlay implements Overlay {
  final String type;
  final bool? shouldHandleKeyboardInsetsInternally;
  final LabelCaptureValidationFlowSettings? settings;
  final int? modeId;
  final bool? hasListener;

  const LabelCaptureValidationFlowOverlay({
    required this.type,
    this.shouldHandleKeyboardInsetsInternally,
    this.settings,
    this.modeId,
    this.hasListener,
  });

  factory LabelCaptureValidationFlowOverlay.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LabelCaptureValidationFlowOverlay: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'shouldHandleKeyboardInsetsInternally',
      'settings',
      'modeId',
      'hasListener',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("LabelCaptureValidationFlowOverlay: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("LabelCaptureValidationFlowOverlay.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['validationFlow'].contains(typeRaw)) {
        throw FormatException("LabelCaptureValidationFlowOverlay.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('LabelCaptureValidationFlowOverlay.type: null is not allowed');
    }
    final hasShouldHandleKeyboardInsetsInternally = raw.containsKey('shouldHandleKeyboardInsetsInternally');
    final shouldHandleKeyboardInsetsInternallyRaw = raw['shouldHandleKeyboardInsetsInternally'];
    bool? shouldHandleKeyboardInsetsInternallyValue;
    if (hasShouldHandleKeyboardInsetsInternally && shouldHandleKeyboardInsetsInternallyRaw != null) {
      if (shouldHandleKeyboardInsetsInternallyRaw is! bool) {
        throw FormatException(
            'LabelCaptureValidationFlowOverlay.shouldHandleKeyboardInsetsInternally: expected a bool');
      }
      shouldHandleKeyboardInsetsInternallyValue = shouldHandleKeyboardInsetsInternallyRaw;
    } else if (hasShouldHandleKeyboardInsetsInternally && shouldHandleKeyboardInsetsInternallyRaw == null) {
      throw FormatException(
          'LabelCaptureValidationFlowOverlay.shouldHandleKeyboardInsetsInternally: null is not allowed');
    }
    final hasSettings = raw.containsKey('settings');
    final settingsRaw = raw['settings'];
    LabelCaptureValidationFlowSettings? settingsValue;
    if (hasSettings && settingsRaw != null) {
      settingsValue = LabelCaptureValidationFlowSettings.fromJson(settingsRaw);
    }
    final hasModeId = raw.containsKey('modeId');
    final modeIdRaw = raw['modeId'];
    int? modeIdValue;
    if (hasModeId && modeIdRaw != null) {
      if (modeIdRaw is! num) {
        throw FormatException('LabelCaptureValidationFlowOverlay.modeId: expected a number');
      }
      if (modeIdRaw != modeIdRaw.toInt()) {
        throw FormatException('LabelCaptureValidationFlowOverlay.modeId: expected an integer');
      }
      modeIdValue = modeIdRaw.toInt();
    } else if (hasModeId && modeIdRaw == null) {
      throw FormatException('LabelCaptureValidationFlowOverlay.modeId: null is not allowed');
    }
    final hasHasListener = raw.containsKey('hasListener');
    final hasListenerRaw = raw['hasListener'];
    bool? hasListenerValue;
    if (hasHasListener && hasListenerRaw != null) {
      if (hasListenerRaw is! bool) {
        throw FormatException('LabelCaptureValidationFlowOverlay.hasListener: expected a bool');
      }
      hasListenerValue = hasListenerRaw;
    } else if (hasHasListener && hasListenerRaw == null) {
      throw FormatException('LabelCaptureValidationFlowOverlay.hasListener: null is not allowed');
    }
    return LabelCaptureValidationFlowOverlay(
      type: typeValue!,
      shouldHandleKeyboardInsetsInternally: shouldHandleKeyboardInsetsInternallyValue,
      settings: settingsValue,
      modeId: modeIdValue,
      hasListener: hasListenerValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (shouldHandleKeyboardInsetsInternally != null) {
      map['shouldHandleKeyboardInsetsInternally'] = shouldHandleKeyboardInsetsInternally;
    }
    if (settings != null) {
      map['settings'] = settings!.toJson();
    }
    if (modeId != null) {
      map['modeId'] = modeId;
    }
    if (hasListener != null) {
      map['hasListener'] = hasListener;
    }
    return map;
  }
}

/// Typed builder for the `LabelCaptureValidationFlowOverlay` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildLabelCaptureValidationFlowOverlay({
  required String type,
  bool? shouldHandleKeyboardInsetsInternally,
  Object? settings = _unset,
  int? modeId,
  bool? hasListener,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (shouldHandleKeyboardInsetsInternally != null) {
    map['shouldHandleKeyboardInsetsInternally'] = shouldHandleKeyboardInsetsInternally;
  }
  if (!identical(settings, _unset)) {
    map['settings'] = settings;
  }
  if (modeId != null) {
    map['modeId'] = modeId;
  }
  if (hasListener != null) {
    map['hasListener'] = hasListener;
  }
  return map;
}

/// Text and placeholder configuration for the label capture validation flow.
class LabelCaptureValidationFlowSettings {
  final String? missingFieldsHint;
  final String? standbyHint;
  final String? validationHint;
  final String? validationError;
  final String? requiredFieldError;
  final String? manualInputButtonText;
  final String? validationFinishButtonText;
  final String? validationRestartButtonText;
  final String? validationPauseButtonText;
  final String? validationAdaptiveScanningText;
  final String? validationScanningText;
  final Object? labelDefinitionsPlaceholders;

  const LabelCaptureValidationFlowSettings({
    this.missingFieldsHint,
    this.standbyHint,
    this.validationHint,
    this.validationError,
    this.requiredFieldError,
    this.manualInputButtonText,
    this.validationFinishButtonText,
    this.validationRestartButtonText,
    this.validationPauseButtonText,
    this.validationAdaptiveScanningText,
    this.validationScanningText,
    this.labelDefinitionsPlaceholders,
  });

  factory LabelCaptureValidationFlowSettings.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LabelCaptureValidationFlowSettings: expected a Map');
    }
    const allowedKeys = <String>{
      'missingFieldsHint',
      'standbyHint',
      'validationHint',
      'validationError',
      'requiredFieldError',
      'manualInputButtonText',
      'validationFinishButtonText',
      'validationRestartButtonText',
      'validationPauseButtonText',
      'validationAdaptiveScanningText',
      'validationScanningText',
      'labelDefinitionsPlaceholders',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("LabelCaptureValidationFlowSettings: unknown property '$key'");
      }
    }
    final hasMissingFieldsHint = raw.containsKey('missingFieldsHint');
    final missingFieldsHintRaw = raw['missingFieldsHint'];
    String? missingFieldsHintValue;
    if (hasMissingFieldsHint && missingFieldsHintRaw != null) {
      if (missingFieldsHintRaw is! String) {
        throw FormatException('LabelCaptureValidationFlowSettings.missingFieldsHint: expected a String');
      }
      missingFieldsHintValue = missingFieldsHintRaw;
    } else if (hasMissingFieldsHint && missingFieldsHintRaw == null) {
      throw FormatException('LabelCaptureValidationFlowSettings.missingFieldsHint: null is not allowed');
    }
    final hasStandbyHint = raw.containsKey('standbyHint');
    final standbyHintRaw = raw['standbyHint'];
    String? standbyHintValue;
    if (hasStandbyHint && standbyHintRaw != null) {
      if (standbyHintRaw is! String) {
        throw FormatException('LabelCaptureValidationFlowSettings.standbyHint: expected a String');
      }
      standbyHintValue = standbyHintRaw;
    } else if (hasStandbyHint && standbyHintRaw == null) {
      throw FormatException('LabelCaptureValidationFlowSettings.standbyHint: null is not allowed');
    }
    final hasValidationHint = raw.containsKey('validationHint');
    final validationHintRaw = raw['validationHint'];
    String? validationHintValue;
    if (hasValidationHint && validationHintRaw != null) {
      if (validationHintRaw is! String) {
        throw FormatException('LabelCaptureValidationFlowSettings.validationHint: expected a String');
      }
      validationHintValue = validationHintRaw;
    } else if (hasValidationHint && validationHintRaw == null) {
      throw FormatException('LabelCaptureValidationFlowSettings.validationHint: null is not allowed');
    }
    final hasValidationError = raw.containsKey('validationError');
    final validationErrorRaw = raw['validationError'];
    String? validationErrorValue;
    if (hasValidationError && validationErrorRaw != null) {
      if (validationErrorRaw is! String) {
        throw FormatException('LabelCaptureValidationFlowSettings.validationError: expected a String');
      }
      validationErrorValue = validationErrorRaw;
    } else if (hasValidationError && validationErrorRaw == null) {
      throw FormatException('LabelCaptureValidationFlowSettings.validationError: null is not allowed');
    }
    final hasRequiredFieldError = raw.containsKey('requiredFieldError');
    final requiredFieldErrorRaw = raw['requiredFieldError'];
    String? requiredFieldErrorValue;
    if (hasRequiredFieldError && requiredFieldErrorRaw != null) {
      if (requiredFieldErrorRaw is! String) {
        throw FormatException('LabelCaptureValidationFlowSettings.requiredFieldError: expected a String');
      }
      requiredFieldErrorValue = requiredFieldErrorRaw;
    } else if (hasRequiredFieldError && requiredFieldErrorRaw == null) {
      throw FormatException('LabelCaptureValidationFlowSettings.requiredFieldError: null is not allowed');
    }
    final hasManualInputButtonText = raw.containsKey('manualInputButtonText');
    final manualInputButtonTextRaw = raw['manualInputButtonText'];
    String? manualInputButtonTextValue;
    if (hasManualInputButtonText && manualInputButtonTextRaw != null) {
      if (manualInputButtonTextRaw is! String) {
        throw FormatException('LabelCaptureValidationFlowSettings.manualInputButtonText: expected a String');
      }
      manualInputButtonTextValue = manualInputButtonTextRaw;
    } else if (hasManualInputButtonText && manualInputButtonTextRaw == null) {
      throw FormatException('LabelCaptureValidationFlowSettings.manualInputButtonText: null is not allowed');
    }
    final hasValidationFinishButtonText = raw.containsKey('validationFinishButtonText');
    final validationFinishButtonTextRaw = raw['validationFinishButtonText'];
    String? validationFinishButtonTextValue;
    if (hasValidationFinishButtonText && validationFinishButtonTextRaw != null) {
      if (validationFinishButtonTextRaw is! String) {
        throw FormatException('LabelCaptureValidationFlowSettings.validationFinishButtonText: expected a String');
      }
      validationFinishButtonTextValue = validationFinishButtonTextRaw;
    } else if (hasValidationFinishButtonText && validationFinishButtonTextRaw == null) {
      throw FormatException('LabelCaptureValidationFlowSettings.validationFinishButtonText: null is not allowed');
    }
    final hasValidationRestartButtonText = raw.containsKey('validationRestartButtonText');
    final validationRestartButtonTextRaw = raw['validationRestartButtonText'];
    String? validationRestartButtonTextValue;
    if (hasValidationRestartButtonText && validationRestartButtonTextRaw != null) {
      if (validationRestartButtonTextRaw is! String) {
        throw FormatException('LabelCaptureValidationFlowSettings.validationRestartButtonText: expected a String');
      }
      validationRestartButtonTextValue = validationRestartButtonTextRaw;
    } else if (hasValidationRestartButtonText && validationRestartButtonTextRaw == null) {
      throw FormatException('LabelCaptureValidationFlowSettings.validationRestartButtonText: null is not allowed');
    }
    final hasValidationPauseButtonText = raw.containsKey('validationPauseButtonText');
    final validationPauseButtonTextRaw = raw['validationPauseButtonText'];
    String? validationPauseButtonTextValue;
    if (hasValidationPauseButtonText && validationPauseButtonTextRaw != null) {
      if (validationPauseButtonTextRaw is! String) {
        throw FormatException('LabelCaptureValidationFlowSettings.validationPauseButtonText: expected a String');
      }
      validationPauseButtonTextValue = validationPauseButtonTextRaw;
    } else if (hasValidationPauseButtonText && validationPauseButtonTextRaw == null) {
      throw FormatException('LabelCaptureValidationFlowSettings.validationPauseButtonText: null is not allowed');
    }
    final hasValidationAdaptiveScanningText = raw.containsKey('validationAdaptiveScanningText');
    final validationAdaptiveScanningTextRaw = raw['validationAdaptiveScanningText'];
    String? validationAdaptiveScanningTextValue;
    if (hasValidationAdaptiveScanningText && validationAdaptiveScanningTextRaw != null) {
      if (validationAdaptiveScanningTextRaw is! String) {
        throw FormatException('LabelCaptureValidationFlowSettings.validationAdaptiveScanningText: expected a String');
      }
      validationAdaptiveScanningTextValue = validationAdaptiveScanningTextRaw;
    } else if (hasValidationAdaptiveScanningText && validationAdaptiveScanningTextRaw == null) {
      throw FormatException('LabelCaptureValidationFlowSettings.validationAdaptiveScanningText: null is not allowed');
    }
    final hasValidationScanningText = raw.containsKey('validationScanningText');
    final validationScanningTextRaw = raw['validationScanningText'];
    String? validationScanningTextValue;
    if (hasValidationScanningText && validationScanningTextRaw != null) {
      if (validationScanningTextRaw is! String) {
        throw FormatException('LabelCaptureValidationFlowSettings.validationScanningText: expected a String');
      }
      validationScanningTextValue = validationScanningTextRaw;
    } else if (hasValidationScanningText && validationScanningTextRaw == null) {
      throw FormatException('LabelCaptureValidationFlowSettings.validationScanningText: null is not allowed');
    }
    final hasLabelDefinitionsPlaceholders = raw.containsKey('labelDefinitionsPlaceholders');
    final labelDefinitionsPlaceholdersRaw = raw['labelDefinitionsPlaceholders'];
    Object? labelDefinitionsPlaceholdersValue;
    if (hasLabelDefinitionsPlaceholders && labelDefinitionsPlaceholdersRaw != null) {
      labelDefinitionsPlaceholdersValue = labelDefinitionsPlaceholdersRaw;
    } else if (hasLabelDefinitionsPlaceholders && labelDefinitionsPlaceholdersRaw == null) {
      throw FormatException('LabelCaptureValidationFlowSettings.labelDefinitionsPlaceholders: null is not allowed');
    }
    return LabelCaptureValidationFlowSettings(
      missingFieldsHint: missingFieldsHintValue,
      standbyHint: standbyHintValue,
      validationHint: validationHintValue,
      validationError: validationErrorValue,
      requiredFieldError: requiredFieldErrorValue,
      manualInputButtonText: manualInputButtonTextValue,
      validationFinishButtonText: validationFinishButtonTextValue,
      validationRestartButtonText: validationRestartButtonTextValue,
      validationPauseButtonText: validationPauseButtonTextValue,
      validationAdaptiveScanningText: validationAdaptiveScanningTextValue,
      validationScanningText: validationScanningTextValue,
      labelDefinitionsPlaceholders: labelDefinitionsPlaceholdersValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (missingFieldsHint != null) {
      map['missingFieldsHint'] = missingFieldsHint;
    }
    if (standbyHint != null) {
      map['standbyHint'] = standbyHint;
    }
    if (validationHint != null) {
      map['validationHint'] = validationHint;
    }
    if (validationError != null) {
      map['validationError'] = validationError;
    }
    if (requiredFieldError != null) {
      map['requiredFieldError'] = requiredFieldError;
    }
    if (manualInputButtonText != null) {
      map['manualInputButtonText'] = manualInputButtonText;
    }
    if (validationFinishButtonText != null) {
      map['validationFinishButtonText'] = validationFinishButtonText;
    }
    if (validationRestartButtonText != null) {
      map['validationRestartButtonText'] = validationRestartButtonText;
    }
    if (validationPauseButtonText != null) {
      map['validationPauseButtonText'] = validationPauseButtonText;
    }
    if (validationAdaptiveScanningText != null) {
      map['validationAdaptiveScanningText'] = validationAdaptiveScanningText;
    }
    if (validationScanningText != null) {
      map['validationScanningText'] = validationScanningText;
    }
    if (labelDefinitionsPlaceholders != null) {
      map['labelDefinitionsPlaceholders'] = labelDefinitionsPlaceholders;
    }
    return map;
  }
}

/// Typed builder for the `LabelCaptureValidationFlowSettings` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildLabelCaptureValidationFlowSettings({
  String? missingFieldsHint,
  String? standbyHint,
  String? validationHint,
  String? validationError,
  String? requiredFieldError,
  String? manualInputButtonText,
  String? validationFinishButtonText,
  String? validationRestartButtonText,
  String? validationPauseButtonText,
  String? validationAdaptiveScanningText,
  String? validationScanningText,
  Object? labelDefinitionsPlaceholders,
}) {
  final map = <String, Object?>{};
  if (missingFieldsHint != null) {
    map['missingFieldsHint'] = missingFieldsHint;
  }
  if (standbyHint != null) {
    map['standbyHint'] = standbyHint;
  }
  if (validationHint != null) {
    map['validationHint'] = validationHint;
  }
  if (validationError != null) {
    map['validationError'] = validationError;
  }
  if (requiredFieldError != null) {
    map['requiredFieldError'] = requiredFieldError;
  }
  if (manualInputButtonText != null) {
    map['manualInputButtonText'] = manualInputButtonText;
  }
  if (validationFinishButtonText != null) {
    map['validationFinishButtonText'] = validationFinishButtonText;
  }
  if (validationRestartButtonText != null) {
    map['validationRestartButtonText'] = validationRestartButtonText;
  }
  if (validationPauseButtonText != null) {
    map['validationPauseButtonText'] = validationPauseButtonText;
  }
  if (validationAdaptiveScanningText != null) {
    map['validationAdaptiveScanningText'] = validationAdaptiveScanningText;
  }
  if (validationScanningText != null) {
    map['validationScanningText'] = validationScanningText;
  }
  if (labelDefinitionsPlaceholders != null) {
    map['labelDefinitionsPlaceholders'] = labelDefinitionsPlaceholders;
  }
  return map;
}

/// The adaptive recognition overlay for label capture, used to scan receipts.
class LabelCaptureAdaptiveRecognitionOverlay implements Overlay {
  final String type;
  final LabelCaptureAdaptiveRecognitionSettings? settings;
  final int? modeId;
  final bool? hasListener;

  const LabelCaptureAdaptiveRecognitionOverlay({
    required this.type,
    this.settings,
    this.modeId,
    this.hasListener,
  });

  factory LabelCaptureAdaptiveRecognitionOverlay.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LabelCaptureAdaptiveRecognitionOverlay: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'settings',
      'modeId',
      'hasListener',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("LabelCaptureAdaptiveRecognitionOverlay: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("LabelCaptureAdaptiveRecognitionOverlay.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['receiptScanning'].contains(typeRaw)) {
        throw FormatException("LabelCaptureAdaptiveRecognitionOverlay.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('LabelCaptureAdaptiveRecognitionOverlay.type: null is not allowed');
    }
    final hasSettings = raw.containsKey('settings');
    final settingsRaw = raw['settings'];
    LabelCaptureAdaptiveRecognitionSettings? settingsValue;
    if (hasSettings && settingsRaw != null) {
      settingsValue = LabelCaptureAdaptiveRecognitionSettings.fromJson(settingsRaw);
    }
    final hasModeId = raw.containsKey('modeId');
    final modeIdRaw = raw['modeId'];
    int? modeIdValue;
    if (hasModeId && modeIdRaw != null) {
      if (modeIdRaw is! num) {
        throw FormatException('LabelCaptureAdaptiveRecognitionOverlay.modeId: expected a number');
      }
      if (modeIdRaw != modeIdRaw.toInt()) {
        throw FormatException('LabelCaptureAdaptiveRecognitionOverlay.modeId: expected an integer');
      }
      modeIdValue = modeIdRaw.toInt();
    } else if (hasModeId && modeIdRaw == null) {
      throw FormatException('LabelCaptureAdaptiveRecognitionOverlay.modeId: null is not allowed');
    }
    final hasHasListener = raw.containsKey('hasListener');
    final hasListenerRaw = raw['hasListener'];
    bool? hasListenerValue;
    if (hasHasListener && hasListenerRaw != null) {
      if (hasListenerRaw is! bool) {
        throw FormatException('LabelCaptureAdaptiveRecognitionOverlay.hasListener: expected a bool');
      }
      hasListenerValue = hasListenerRaw;
    } else if (hasHasListener && hasListenerRaw == null) {
      throw FormatException('LabelCaptureAdaptiveRecognitionOverlay.hasListener: null is not allowed');
    }
    return LabelCaptureAdaptiveRecognitionOverlay(
      type: typeValue!,
      settings: settingsValue,
      modeId: modeIdValue,
      hasListener: hasListenerValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (settings != null) {
      map['settings'] = settings!.toJson();
    }
    if (modeId != null) {
      map['modeId'] = modeId;
    }
    if (hasListener != null) {
      map['hasListener'] = hasListener;
    }
    return map;
  }
}

/// Typed builder for the `LabelCaptureAdaptiveRecognitionOverlay` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildLabelCaptureAdaptiveRecognitionOverlay({
  required String type,
  Object? settings = _unset,
  int? modeId,
  bool? hasListener,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (!identical(settings, _unset)) {
    map['settings'] = settings;
  }
  if (modeId != null) {
    map['modeId'] = modeId;
  }
  if (hasListener != null) {
    map['hasListener'] = hasListener;
  }
  return map;
}

/// Configuration for adaptive recognition, applied to the label capture adaptive recognition overlay.
class LabelCaptureAdaptiveRecognitionSettings {
  final String? processingHint;
  final String? processingHintText;
  final String? resultType;

  const LabelCaptureAdaptiveRecognitionSettings({
    this.processingHint,
    this.processingHintText,
    this.resultType,
  });

  factory LabelCaptureAdaptiveRecognitionSettings.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LabelCaptureAdaptiveRecognitionSettings: expected a Map');
    }
    const allowedKeys = <String>{
      'processingHint',
      'processingHintText',
      'resultType',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("LabelCaptureAdaptiveRecognitionSettings: unknown property '$key'");
      }
    }
    final hasProcessingHint = raw.containsKey('processingHint');
    final processingHintRaw = raw['processingHint'];
    String? processingHintValue;
    if (hasProcessingHint && processingHintRaw != null) {
      if (processingHintRaw is! String) {
        throw FormatException('LabelCaptureAdaptiveRecognitionSettings.processingHint: expected a String');
      }
      processingHintValue = processingHintRaw;
    } else if (hasProcessingHint && processingHintRaw == null) {
      throw FormatException('LabelCaptureAdaptiveRecognitionSettings.processingHint: null is not allowed');
    }
    final hasProcessingHintText = raw.containsKey('processingHintText');
    final processingHintTextRaw = raw['processingHintText'];
    String? processingHintTextValue;
    if (hasProcessingHintText && processingHintTextRaw != null) {
      if (processingHintTextRaw is! String) {
        throw FormatException('LabelCaptureAdaptiveRecognitionSettings.processingHintText: expected a String');
      }
      processingHintTextValue = processingHintTextRaw;
    } else if (hasProcessingHintText && processingHintTextRaw == null) {
      throw FormatException('LabelCaptureAdaptiveRecognitionSettings.processingHintText: null is not allowed');
    }
    final hasResultType = raw.containsKey('resultType');
    final resultTypeRaw = raw['resultType'];
    String? resultTypeValue;
    if (hasResultType && resultTypeRaw != null) {
      if (resultTypeRaw is! String || !const <String>['receipt'].contains(resultTypeRaw)) {
        throw FormatException(
            "LabelCaptureAdaptiveRecognitionSettings.resultType: unknown enum value '$resultTypeRaw'");
      }
      resultTypeValue = resultTypeRaw;
    } else if (hasResultType && resultTypeRaw == null) {
      throw FormatException('LabelCaptureAdaptiveRecognitionSettings.resultType: null is not allowed');
    }
    return LabelCaptureAdaptiveRecognitionSettings(
      processingHint: processingHintValue,
      processingHintText: processingHintTextValue,
      resultType: resultTypeValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (processingHint != null) {
      map['processingHint'] = processingHint;
    }
    if (processingHintText != null) {
      map['processingHintText'] = processingHintText;
    }
    if (resultType != null) {
      map['resultType'] = resultType;
    }
    return map;
  }
}

/// Typed builder for the `LabelCaptureAdaptiveRecognitionSettings` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildLabelCaptureAdaptiveRecognitionSettings({
  String? processingHint,
  String? processingHintText,
  String? resultType,
}) {
  final map = <String, Object?>{};
  if (processingHint != null) {
    map['processingHint'] = processingHint;
  }
  if (processingHintText != null) {
    map['processingHintText'] = processingHintText;
  }
  if (resultType != null) {
    map['resultType'] = resultType;
  }
  return map;
}

/// The overlay for ID capture, rendering a viewfinder adapted to the document layout.
class IdCaptureOverlay implements Overlay {
  final String type;
  final String? idLayout;
  final String? idLayoutStyle;
  final String? idLayoutLineStyle;
  final Brush? capturedBrush;
  final Brush? localizedBrush;
  final Brush? rejectedBrush;
  final bool? showTextHints;
  final String? textHintPosition;
  final String? frontSideTextHint;
  final String? backSideTextHint;
  final String? moveCloserTextHint;
  final String? moveFurtherAwayTextHint;
  final String? tapShutterToScanTextHint;
  final String? lookingForDocumentTextHint;
  final String? holdStillTextHint;
  final int? modeId;

  const IdCaptureOverlay({
    required this.type,
    this.idLayout,
    this.idLayoutStyle,
    this.idLayoutLineStyle,
    this.capturedBrush,
    this.localizedBrush,
    this.rejectedBrush,
    this.showTextHints,
    this.textHintPosition,
    this.frontSideTextHint,
    this.backSideTextHint,
    this.moveCloserTextHint,
    this.moveFurtherAwayTextHint,
    this.tapShutterToScanTextHint,
    this.lookingForDocumentTextHint,
    this.holdStillTextHint,
    this.modeId,
  });

  factory IdCaptureOverlay.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('IdCaptureOverlay: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'idLayout',
      'idLayoutStyle',
      'idLayoutLineStyle',
      'capturedBrush',
      'localizedBrush',
      'rejectedBrush',
      'showTextHints',
      'textHintPosition',
      'frontSideTextHint',
      'backSideTextHint',
      'moveCloserTextHint',
      'moveFurtherAwayTextHint',
      'tapShutterToScanTextHint',
      'lookingForDocumentTextHint',
      'holdStillTextHint',
      'modeId',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("IdCaptureOverlay: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("IdCaptureOverlay.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['idCapture'].contains(typeRaw)) {
        throw FormatException("IdCaptureOverlay.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('IdCaptureOverlay.type: null is not allowed');
    }
    final hasIdLayout = raw.containsKey('idLayout');
    final idLayoutRaw = raw['idLayout'];
    String? idLayoutValue;
    if (hasIdLayout && idLayoutRaw != null) {
      if (idLayoutRaw is! String ||
          !const <String>['td1', 'td2', 'td3', 'mrvA', 'viz', 'pdf417', 'auto', 'none'].contains(idLayoutRaw)) {
        throw FormatException("IdCaptureOverlay.idLayout: unknown enum value '$idLayoutRaw'");
      }
      idLayoutValue = idLayoutRaw;
    } else if (hasIdLayout && idLayoutRaw == null) {
      throw FormatException('IdCaptureOverlay.idLayout: null is not allowed');
    }
    final hasIdLayoutStyle = raw.containsKey('idLayoutStyle');
    final idLayoutStyleRaw = raw['idLayoutStyle'];
    String? idLayoutStyleValue;
    if (hasIdLayoutStyle && idLayoutStyleRaw != null) {
      if (idLayoutStyleRaw is! String || !const <String>['rounded', 'square'].contains(idLayoutStyleRaw)) {
        throw FormatException("IdCaptureOverlay.idLayoutStyle: unknown enum value '$idLayoutStyleRaw'");
      }
      idLayoutStyleValue = idLayoutStyleRaw;
    } else if (hasIdLayoutStyle && idLayoutStyleRaw == null) {
      throw FormatException('IdCaptureOverlay.idLayoutStyle: null is not allowed');
    }
    final hasIdLayoutLineStyle = raw.containsKey('idLayoutLineStyle');
    final idLayoutLineStyleRaw = raw['idLayoutLineStyle'];
    String? idLayoutLineStyleValue;
    if (hasIdLayoutLineStyle && idLayoutLineStyleRaw != null) {
      if (idLayoutLineStyleRaw is! String || !const <String>['light', 'bold'].contains(idLayoutLineStyleRaw)) {
        throw FormatException("IdCaptureOverlay.idLayoutLineStyle: unknown enum value '$idLayoutLineStyleRaw'");
      }
      idLayoutLineStyleValue = idLayoutLineStyleRaw;
    } else if (hasIdLayoutLineStyle && idLayoutLineStyleRaw == null) {
      throw FormatException('IdCaptureOverlay.idLayoutLineStyle: null is not allowed');
    }
    final hasCapturedBrush = raw.containsKey('capturedBrush');
    final capturedBrushRaw = raw['capturedBrush'];
    Brush? capturedBrushValue;
    if (hasCapturedBrush && capturedBrushRaw != null) {
      capturedBrushValue = Brush.fromJson(capturedBrushRaw);
    } else if (hasCapturedBrush && capturedBrushRaw == null) {
      throw FormatException('IdCaptureOverlay.capturedBrush: null is not allowed');
    }
    final hasLocalizedBrush = raw.containsKey('localizedBrush');
    final localizedBrushRaw = raw['localizedBrush'];
    Brush? localizedBrushValue;
    if (hasLocalizedBrush && localizedBrushRaw != null) {
      localizedBrushValue = Brush.fromJson(localizedBrushRaw);
    } else if (hasLocalizedBrush && localizedBrushRaw == null) {
      throw FormatException('IdCaptureOverlay.localizedBrush: null is not allowed');
    }
    final hasRejectedBrush = raw.containsKey('rejectedBrush');
    final rejectedBrushRaw = raw['rejectedBrush'];
    Brush? rejectedBrushValue;
    if (hasRejectedBrush && rejectedBrushRaw != null) {
      rejectedBrushValue = Brush.fromJson(rejectedBrushRaw);
    } else if (hasRejectedBrush && rejectedBrushRaw == null) {
      throw FormatException('IdCaptureOverlay.rejectedBrush: null is not allowed');
    }
    final hasShowTextHints = raw.containsKey('showTextHints');
    final showTextHintsRaw = raw['showTextHints'];
    bool? showTextHintsValue;
    if (hasShowTextHints && showTextHintsRaw != null) {
      if (showTextHintsRaw is! bool) {
        throw FormatException('IdCaptureOverlay.showTextHints: expected a bool');
      }
      showTextHintsValue = showTextHintsRaw;
    } else if (hasShowTextHints && showTextHintsRaw == null) {
      throw FormatException('IdCaptureOverlay.showTextHints: null is not allowed');
    }
    final hasTextHintPosition = raw.containsKey('textHintPosition');
    final textHintPositionRaw = raw['textHintPosition'];
    String? textHintPositionValue;
    if (hasTextHintPosition && textHintPositionRaw != null) {
      if (textHintPositionRaw is! String ||
          !const <String>['aboveViewfinder', 'belowViewfinder'].contains(textHintPositionRaw)) {
        throw FormatException("IdCaptureOverlay.textHintPosition: unknown enum value '$textHintPositionRaw'");
      }
      textHintPositionValue = textHintPositionRaw;
    } else if (hasTextHintPosition && textHintPositionRaw == null) {
      throw FormatException('IdCaptureOverlay.textHintPosition: null is not allowed');
    }
    final hasFrontSideTextHint = raw.containsKey('frontSideTextHint');
    final frontSideTextHintRaw = raw['frontSideTextHint'];
    String? frontSideTextHintValue;
    if (hasFrontSideTextHint && frontSideTextHintRaw != null) {
      if (frontSideTextHintRaw is! String) {
        throw FormatException('IdCaptureOverlay.frontSideTextHint: expected a String');
      }
      frontSideTextHintValue = frontSideTextHintRaw;
    }
    final hasBackSideTextHint = raw.containsKey('backSideTextHint');
    final backSideTextHintRaw = raw['backSideTextHint'];
    String? backSideTextHintValue;
    if (hasBackSideTextHint && backSideTextHintRaw != null) {
      if (backSideTextHintRaw is! String) {
        throw FormatException('IdCaptureOverlay.backSideTextHint: expected a String');
      }
      backSideTextHintValue = backSideTextHintRaw;
    }
    final hasMoveCloserTextHint = raw.containsKey('moveCloserTextHint');
    final moveCloserTextHintRaw = raw['moveCloserTextHint'];
    String? moveCloserTextHintValue;
    if (hasMoveCloserTextHint && moveCloserTextHintRaw != null) {
      if (moveCloserTextHintRaw is! String) {
        throw FormatException('IdCaptureOverlay.moveCloserTextHint: expected a String');
      }
      moveCloserTextHintValue = moveCloserTextHintRaw;
    } else if (hasMoveCloserTextHint && moveCloserTextHintRaw == null) {
      throw FormatException('IdCaptureOverlay.moveCloserTextHint: null is not allowed');
    }
    final hasMoveFurtherAwayTextHint = raw.containsKey('moveFurtherAwayTextHint');
    final moveFurtherAwayTextHintRaw = raw['moveFurtherAwayTextHint'];
    String? moveFurtherAwayTextHintValue;
    if (hasMoveFurtherAwayTextHint && moveFurtherAwayTextHintRaw != null) {
      if (moveFurtherAwayTextHintRaw is! String) {
        throw FormatException('IdCaptureOverlay.moveFurtherAwayTextHint: expected a String');
      }
      moveFurtherAwayTextHintValue = moveFurtherAwayTextHintRaw;
    } else if (hasMoveFurtherAwayTextHint && moveFurtherAwayTextHintRaw == null) {
      throw FormatException('IdCaptureOverlay.moveFurtherAwayTextHint: null is not allowed');
    }
    final hasTapShutterToScanTextHint = raw.containsKey('tapShutterToScanTextHint');
    final tapShutterToScanTextHintRaw = raw['tapShutterToScanTextHint'];
    String? tapShutterToScanTextHintValue;
    if (hasTapShutterToScanTextHint && tapShutterToScanTextHintRaw != null) {
      if (tapShutterToScanTextHintRaw is! String) {
        throw FormatException('IdCaptureOverlay.tapShutterToScanTextHint: expected a String');
      }
      tapShutterToScanTextHintValue = tapShutterToScanTextHintRaw;
    } else if (hasTapShutterToScanTextHint && tapShutterToScanTextHintRaw == null) {
      throw FormatException('IdCaptureOverlay.tapShutterToScanTextHint: null is not allowed');
    }
    final hasLookingForDocumentTextHint = raw.containsKey('lookingForDocumentTextHint');
    final lookingForDocumentTextHintRaw = raw['lookingForDocumentTextHint'];
    String? lookingForDocumentTextHintValue;
    if (hasLookingForDocumentTextHint && lookingForDocumentTextHintRaw != null) {
      if (lookingForDocumentTextHintRaw is! String) {
        throw FormatException('IdCaptureOverlay.lookingForDocumentTextHint: expected a String');
      }
      lookingForDocumentTextHintValue = lookingForDocumentTextHintRaw;
    } else if (hasLookingForDocumentTextHint && lookingForDocumentTextHintRaw == null) {
      throw FormatException('IdCaptureOverlay.lookingForDocumentTextHint: null is not allowed');
    }
    final hasHoldStillTextHint = raw.containsKey('holdStillTextHint');
    final holdStillTextHintRaw = raw['holdStillTextHint'];
    String? holdStillTextHintValue;
    if (hasHoldStillTextHint && holdStillTextHintRaw != null) {
      if (holdStillTextHintRaw is! String) {
        throw FormatException('IdCaptureOverlay.holdStillTextHint: expected a String');
      }
      holdStillTextHintValue = holdStillTextHintRaw;
    } else if (hasHoldStillTextHint && holdStillTextHintRaw == null) {
      throw FormatException('IdCaptureOverlay.holdStillTextHint: null is not allowed');
    }
    final hasModeId = raw.containsKey('modeId');
    final modeIdRaw = raw['modeId'];
    int? modeIdValue;
    if (hasModeId && modeIdRaw != null) {
      if (modeIdRaw is! num) {
        throw FormatException('IdCaptureOverlay.modeId: expected a number');
      }
      if (modeIdRaw != modeIdRaw.toInt()) {
        throw FormatException('IdCaptureOverlay.modeId: expected an integer');
      }
      modeIdValue = modeIdRaw.toInt();
    } else if (hasModeId && modeIdRaw == null) {
      throw FormatException('IdCaptureOverlay.modeId: null is not allowed');
    }
    return IdCaptureOverlay(
      type: typeValue!,
      idLayout: idLayoutValue,
      idLayoutStyle: idLayoutStyleValue,
      idLayoutLineStyle: idLayoutLineStyleValue,
      capturedBrush: capturedBrushValue,
      localizedBrush: localizedBrushValue,
      rejectedBrush: rejectedBrushValue,
      showTextHints: showTextHintsValue,
      textHintPosition: textHintPositionValue,
      frontSideTextHint: frontSideTextHintValue,
      backSideTextHint: backSideTextHintValue,
      moveCloserTextHint: moveCloserTextHintValue,
      moveFurtherAwayTextHint: moveFurtherAwayTextHintValue,
      tapShutterToScanTextHint: tapShutterToScanTextHintValue,
      lookingForDocumentTextHint: lookingForDocumentTextHintValue,
      holdStillTextHint: holdStillTextHintValue,
      modeId: modeIdValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (idLayout != null) {
      map['idLayout'] = idLayout;
    }
    if (idLayoutStyle != null) {
      map['idLayoutStyle'] = idLayoutStyle;
    }
    if (idLayoutLineStyle != null) {
      map['idLayoutLineStyle'] = idLayoutLineStyle;
    }
    if (capturedBrush != null) {
      map['capturedBrush'] = capturedBrush!.toJson();
    }
    if (localizedBrush != null) {
      map['localizedBrush'] = localizedBrush!.toJson();
    }
    if (rejectedBrush != null) {
      map['rejectedBrush'] = rejectedBrush!.toJson();
    }
    if (showTextHints != null) {
      map['showTextHints'] = showTextHints;
    }
    if (textHintPosition != null) {
      map['textHintPosition'] = textHintPosition;
    }
    if (frontSideTextHint != null) {
      map['frontSideTextHint'] = frontSideTextHint;
    }
    if (backSideTextHint != null) {
      map['backSideTextHint'] = backSideTextHint;
    }
    if (moveCloserTextHint != null) {
      map['moveCloserTextHint'] = moveCloserTextHint;
    }
    if (moveFurtherAwayTextHint != null) {
      map['moveFurtherAwayTextHint'] = moveFurtherAwayTextHint;
    }
    if (tapShutterToScanTextHint != null) {
      map['tapShutterToScanTextHint'] = tapShutterToScanTextHint;
    }
    if (lookingForDocumentTextHint != null) {
      map['lookingForDocumentTextHint'] = lookingForDocumentTextHint;
    }
    if (holdStillTextHint != null) {
      map['holdStillTextHint'] = holdStillTextHint;
    }
    if (modeId != null) {
      map['modeId'] = modeId;
    }
    return map;
  }
}

/// Typed builder for the `IdCaptureOverlay` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildIdCaptureOverlay({
  required String type,
  String? idLayout,
  String? idLayoutStyle,
  String? idLayoutLineStyle,
  Object? capturedBrush,
  Object? localizedBrush,
  Object? rejectedBrush,
  bool? showTextHints,
  String? textHintPosition,
  Object? frontSideTextHint = _unset,
  Object? backSideTextHint = _unset,
  String? moveCloserTextHint,
  String? moveFurtherAwayTextHint,
  String? tapShutterToScanTextHint,
  String? lookingForDocumentTextHint,
  String? holdStillTextHint,
  int? modeId,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (idLayout != null) {
    map['idLayout'] = idLayout;
  }
  if (idLayoutStyle != null) {
    map['idLayoutStyle'] = idLayoutStyle;
  }
  if (idLayoutLineStyle != null) {
    map['idLayoutLineStyle'] = idLayoutLineStyle;
  }
  if (capturedBrush != null) {
    map['capturedBrush'] = capturedBrush;
  }
  if (localizedBrush != null) {
    map['localizedBrush'] = localizedBrush;
  }
  if (rejectedBrush != null) {
    map['rejectedBrush'] = rejectedBrush;
  }
  if (showTextHints != null) {
    map['showTextHints'] = showTextHints;
  }
  if (textHintPosition != null) {
    map['textHintPosition'] = textHintPosition;
  }
  if (!identical(frontSideTextHint, _unset)) {
    map['frontSideTextHint'] = frontSideTextHint;
  }
  if (!identical(backSideTextHint, _unset)) {
    map['backSideTextHint'] = backSideTextHint;
  }
  if (moveCloserTextHint != null) {
    map['moveCloserTextHint'] = moveCloserTextHint;
  }
  if (moveFurtherAwayTextHint != null) {
    map['moveFurtherAwayTextHint'] = moveFurtherAwayTextHint;
  }
  if (tapShutterToScanTextHint != null) {
    map['tapShutterToScanTextHint'] = tapShutterToScanTextHint;
  }
  if (lookingForDocumentTextHint != null) {
    map['lookingForDocumentTextHint'] = lookingForDocumentTextHint;
  }
  if (holdStillTextHint != null) {
    map['holdStillTextHint'] = holdStillTextHint;
  }
  if (modeId != null) {
    map['modeId'] = modeId;
  }
  return map;
}

/// Overlay for the text capture mode.
class TextCaptureOverlay implements Overlay {
  final String type;
  final Brush? brush;
  final Viewfinder? viewfinder;
  final bool? shouldShowScanAreaGuides;

  const TextCaptureOverlay({
    required this.type,
    this.brush,
    this.viewfinder,
    this.shouldShowScanAreaGuides,
  });

  factory TextCaptureOverlay.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('TextCaptureOverlay: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'brush',
      'viewfinder',
      'shouldShowScanAreaGuides',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("TextCaptureOverlay: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("TextCaptureOverlay.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['textCapture'].contains(typeRaw)) {
        throw FormatException("TextCaptureOverlay.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('TextCaptureOverlay.type: null is not allowed');
    }
    final hasBrush = raw.containsKey('brush');
    final brushRaw = raw['brush'];
    Brush? brushValue;
    if (hasBrush && brushRaw != null) {
      brushValue = Brush.fromJson(brushRaw);
    } else if (hasBrush && brushRaw == null) {
      throw FormatException('TextCaptureOverlay.brush: null is not allowed');
    }
    final hasViewfinder = raw.containsKey('viewfinder');
    final viewfinderRaw = raw['viewfinder'];
    Viewfinder? viewfinderValue;
    if (hasViewfinder && viewfinderRaw != null) {
      viewfinderValue = Viewfinder.fromJson(viewfinderRaw);
    } else if (hasViewfinder && viewfinderRaw == null) {
      throw FormatException('TextCaptureOverlay.viewfinder: null is not allowed');
    }
    final hasShouldShowScanAreaGuides = raw.containsKey('shouldShowScanAreaGuides');
    final shouldShowScanAreaGuidesRaw = raw['shouldShowScanAreaGuides'];
    bool? shouldShowScanAreaGuidesValue;
    if (hasShouldShowScanAreaGuides && shouldShowScanAreaGuidesRaw != null) {
      if (shouldShowScanAreaGuidesRaw is! bool) {
        throw FormatException('TextCaptureOverlay.shouldShowScanAreaGuides: expected a bool');
      }
      shouldShowScanAreaGuidesValue = shouldShowScanAreaGuidesRaw;
    } else if (hasShouldShowScanAreaGuides && shouldShowScanAreaGuidesRaw == null) {
      throw FormatException('TextCaptureOverlay.shouldShowScanAreaGuides: null is not allowed');
    }
    return TextCaptureOverlay(
      type: typeValue!,
      brush: brushValue,
      viewfinder: viewfinderValue,
      shouldShowScanAreaGuides: shouldShowScanAreaGuidesValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (brush != null) {
      map['brush'] = brush!.toJson();
    }
    if (viewfinder != null) {
      map['viewfinder'] = viewfinder!.toJson();
    }
    if (shouldShowScanAreaGuides != null) {
      map['shouldShowScanAreaGuides'] = shouldShowScanAreaGuides;
    }
    return map;
  }
}

/// Typed builder for the `TextCaptureOverlay` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildTextCaptureOverlay({
  required String type,
  Object? brush,
  Object? viewfinder,
  bool? shouldShowScanAreaGuides,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (brush != null) {
    map['brush'] = brush;
  }
  if (viewfinder != null) {
    map['viewfinder'] = viewfinder;
  }
  if (shouldShowScanAreaGuides != null) {
    map['shouldShowScanAreaGuides'] = shouldShowScanAreaGuides;
  }
  return map;
}

/// The overlay for the BarcodeCount mode.
class BarcodeCountOverlay implements Overlay {
  final String type;
  final String? style;
  final Brush? notInListBrush;
  final Brush? recognizedBrush;
  final Brush? unrecognizedBrush;
  final bool? shouldShowScanAreaGuides;
  final FilterOverlaySettings? filterOverlaySettings;
  final bool? shouldEnableUserGuidance;
  final bool? shouldShowHints;
  final String? colorScheme;
  final String? textForUnscannedBarcodeDetectedHint;
  final String? textForUnrecognizedBarcodesDetectedHint;
  final String? textForWrongBarcodeDetectedHint;
  final String? textForTapShutterToScanHint;
  final String? textForScanningHint;
  final String? textForMoveCloserAndRescanHint;
  final String? textForMoveFurtherAndRescanHint;
  final String? textForTapToUncountHint;
  final String? textForScreenCleanedUpHint;
  final String? textForNewGroupHint;
  final String? textForSwipeToGroupHint;
  final String? textForRescanYellowCodesHint;

  const BarcodeCountOverlay({
    required this.type,
    this.style,
    this.notInListBrush,
    this.recognizedBrush,
    this.unrecognizedBrush,
    this.shouldShowScanAreaGuides,
    this.filterOverlaySettings,
    this.shouldEnableUserGuidance,
    this.shouldShowHints,
    this.colorScheme,
    this.textForUnscannedBarcodeDetectedHint,
    this.textForUnrecognizedBarcodesDetectedHint,
    this.textForWrongBarcodeDetectedHint,
    this.textForTapShutterToScanHint,
    this.textForScanningHint,
    this.textForMoveCloserAndRescanHint,
    this.textForMoveFurtherAndRescanHint,
    this.textForTapToUncountHint,
    this.textForScreenCleanedUpHint,
    this.textForNewGroupHint,
    this.textForSwipeToGroupHint,
    this.textForRescanYellowCodesHint,
  });

  factory BarcodeCountOverlay.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('BarcodeCountOverlay: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'style',
      'notInListBrush',
      'recognizedBrush',
      'unrecognizedBrush',
      'shouldShowScanAreaGuides',
      'filterOverlaySettings',
      'shouldEnableUserGuidance',
      'shouldShowHints',
      'colorScheme',
      'textForUnscannedBarcodeDetectedHint',
      'textForUnrecognizedBarcodesDetectedHint',
      'textForWrongBarcodeDetectedHint',
      'textForTapShutterToScanHint',
      'textForScanningHint',
      'textForMoveCloserAndRescanHint',
      'textForMoveFurtherAndRescanHint',
      'textForTapToUncountHint',
      'textForScreenCleanedUpHint',
      'textForNewGroupHint',
      'textForSwipeToGroupHint',
      'textForRescanYellowCodesHint',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("BarcodeCountOverlay: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("BarcodeCountOverlay.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['barcodeCountBasic'].contains(typeRaw)) {
        throw FormatException("BarcodeCountOverlay.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('BarcodeCountOverlay.type: null is not allowed');
    }
    final hasStyle = raw.containsKey('style');
    final styleRaw = raw['style'];
    String? styleValue;
    if (hasStyle && styleRaw != null) {
      if (styleRaw is! String || !const <String>['icon', 'dot'].contains(styleRaw)) {
        throw FormatException("BarcodeCountOverlay.style: unknown enum value '$styleRaw'");
      }
      styleValue = styleRaw;
    } else if (hasStyle && styleRaw == null) {
      throw FormatException('BarcodeCountOverlay.style: null is not allowed');
    }
    final hasNotInListBrush = raw.containsKey('notInListBrush');
    final notInListBrushRaw = raw['notInListBrush'];
    Brush? notInListBrushValue;
    if (hasNotInListBrush && notInListBrushRaw != null) {
      notInListBrushValue = Brush.fromJson(notInListBrushRaw);
    } else if (hasNotInListBrush && notInListBrushRaw == null) {
      throw FormatException('BarcodeCountOverlay.notInListBrush: null is not allowed');
    }
    final hasRecognizedBrush = raw.containsKey('recognizedBrush');
    final recognizedBrushRaw = raw['recognizedBrush'];
    Brush? recognizedBrushValue;
    if (hasRecognizedBrush && recognizedBrushRaw != null) {
      recognizedBrushValue = Brush.fromJson(recognizedBrushRaw);
    } else if (hasRecognizedBrush && recognizedBrushRaw == null) {
      throw FormatException('BarcodeCountOverlay.recognizedBrush: null is not allowed');
    }
    final hasUnrecognizedBrush = raw.containsKey('unrecognizedBrush');
    final unrecognizedBrushRaw = raw['unrecognizedBrush'];
    Brush? unrecognizedBrushValue;
    if (hasUnrecognizedBrush && unrecognizedBrushRaw != null) {
      unrecognizedBrushValue = Brush.fromJson(unrecognizedBrushRaw);
    } else if (hasUnrecognizedBrush && unrecognizedBrushRaw == null) {
      throw FormatException('BarcodeCountOverlay.unrecognizedBrush: null is not allowed');
    }
    final hasShouldShowScanAreaGuides = raw.containsKey('shouldShowScanAreaGuides');
    final shouldShowScanAreaGuidesRaw = raw['shouldShowScanAreaGuides'];
    bool? shouldShowScanAreaGuidesValue;
    if (hasShouldShowScanAreaGuides && shouldShowScanAreaGuidesRaw != null) {
      if (shouldShowScanAreaGuidesRaw is! bool) {
        throw FormatException('BarcodeCountOverlay.shouldShowScanAreaGuides: expected a bool');
      }
      shouldShowScanAreaGuidesValue = shouldShowScanAreaGuidesRaw;
    } else if (hasShouldShowScanAreaGuides && shouldShowScanAreaGuidesRaw == null) {
      throw FormatException('BarcodeCountOverlay.shouldShowScanAreaGuides: null is not allowed');
    }
    final hasFilterOverlaySettings = raw.containsKey('filterOverlaySettings');
    final filterOverlaySettingsRaw = raw['filterOverlaySettings'];
    FilterOverlaySettings? filterOverlaySettingsValue;
    if (hasFilterOverlaySettings && filterOverlaySettingsRaw != null) {
      filterOverlaySettingsValue = FilterOverlaySettings.fromJson(filterOverlaySettingsRaw);
    } else if (hasFilterOverlaySettings && filterOverlaySettingsRaw == null) {
      throw FormatException('BarcodeCountOverlay.filterOverlaySettings: null is not allowed');
    }
    final hasShouldEnableUserGuidance = raw.containsKey('shouldEnableUserGuidance');
    final shouldEnableUserGuidanceRaw = raw['shouldEnableUserGuidance'];
    bool? shouldEnableUserGuidanceValue;
    if (hasShouldEnableUserGuidance && shouldEnableUserGuidanceRaw != null) {
      if (shouldEnableUserGuidanceRaw is! bool) {
        throw FormatException('BarcodeCountOverlay.shouldEnableUserGuidance: expected a bool');
      }
      shouldEnableUserGuidanceValue = shouldEnableUserGuidanceRaw;
    } else if (hasShouldEnableUserGuidance && shouldEnableUserGuidanceRaw == null) {
      throw FormatException('BarcodeCountOverlay.shouldEnableUserGuidance: null is not allowed');
    }
    final hasShouldShowHints = raw.containsKey('shouldShowHints');
    final shouldShowHintsRaw = raw['shouldShowHints'];
    bool? shouldShowHintsValue;
    if (hasShouldShowHints && shouldShowHintsRaw != null) {
      if (shouldShowHintsRaw is! bool) {
        throw FormatException('BarcodeCountOverlay.shouldShowHints: expected a bool');
      }
      shouldShowHintsValue = shouldShowHintsRaw;
    } else if (hasShouldShowHints && shouldShowHintsRaw == null) {
      throw FormatException('BarcodeCountOverlay.shouldShowHints: null is not allowed');
    }
    final hasColorScheme = raw.containsKey('colorScheme');
    final colorSchemeRaw = raw['colorScheme'];
    String? colorSchemeValue;
    if (hasColorScheme && colorSchemeRaw != null) {
      if (colorSchemeRaw is! String || !const <String>['default', 'accessible'].contains(colorSchemeRaw)) {
        throw FormatException("BarcodeCountOverlay.colorScheme: unknown enum value '$colorSchemeRaw'");
      }
      colorSchemeValue = colorSchemeRaw;
    } else if (hasColorScheme && colorSchemeRaw == null) {
      throw FormatException('BarcodeCountOverlay.colorScheme: null is not allowed');
    }
    final hasTextForUnscannedBarcodeDetectedHint = raw.containsKey('textForUnscannedBarcodeDetectedHint');
    final textForUnscannedBarcodeDetectedHintRaw = raw['textForUnscannedBarcodeDetectedHint'];
    String? textForUnscannedBarcodeDetectedHintValue;
    if (hasTextForUnscannedBarcodeDetectedHint && textForUnscannedBarcodeDetectedHintRaw != null) {
      if (textForUnscannedBarcodeDetectedHintRaw is! String) {
        throw FormatException('BarcodeCountOverlay.textForUnscannedBarcodeDetectedHint: expected a String');
      }
      textForUnscannedBarcodeDetectedHintValue = textForUnscannedBarcodeDetectedHintRaw;
    } else if (hasTextForUnscannedBarcodeDetectedHint && textForUnscannedBarcodeDetectedHintRaw == null) {
      throw FormatException('BarcodeCountOverlay.textForUnscannedBarcodeDetectedHint: null is not allowed');
    }
    final hasTextForUnrecognizedBarcodesDetectedHint = raw.containsKey('textForUnrecognizedBarcodesDetectedHint');
    final textForUnrecognizedBarcodesDetectedHintRaw = raw['textForUnrecognizedBarcodesDetectedHint'];
    String? textForUnrecognizedBarcodesDetectedHintValue;
    if (hasTextForUnrecognizedBarcodesDetectedHint && textForUnrecognizedBarcodesDetectedHintRaw != null) {
      if (textForUnrecognizedBarcodesDetectedHintRaw is! String) {
        throw FormatException('BarcodeCountOverlay.textForUnrecognizedBarcodesDetectedHint: expected a String');
      }
      textForUnrecognizedBarcodesDetectedHintValue = textForUnrecognizedBarcodesDetectedHintRaw;
    } else if (hasTextForUnrecognizedBarcodesDetectedHint && textForUnrecognizedBarcodesDetectedHintRaw == null) {
      throw FormatException('BarcodeCountOverlay.textForUnrecognizedBarcodesDetectedHint: null is not allowed');
    }
    final hasTextForWrongBarcodeDetectedHint = raw.containsKey('textForWrongBarcodeDetectedHint');
    final textForWrongBarcodeDetectedHintRaw = raw['textForWrongBarcodeDetectedHint'];
    String? textForWrongBarcodeDetectedHintValue;
    if (hasTextForWrongBarcodeDetectedHint && textForWrongBarcodeDetectedHintRaw != null) {
      if (textForWrongBarcodeDetectedHintRaw is! String) {
        throw FormatException('BarcodeCountOverlay.textForWrongBarcodeDetectedHint: expected a String');
      }
      textForWrongBarcodeDetectedHintValue = textForWrongBarcodeDetectedHintRaw;
    } else if (hasTextForWrongBarcodeDetectedHint && textForWrongBarcodeDetectedHintRaw == null) {
      throw FormatException('BarcodeCountOverlay.textForWrongBarcodeDetectedHint: null is not allowed');
    }
    final hasTextForTapShutterToScanHint = raw.containsKey('textForTapShutterToScanHint');
    final textForTapShutterToScanHintRaw = raw['textForTapShutterToScanHint'];
    String? textForTapShutterToScanHintValue;
    if (hasTextForTapShutterToScanHint && textForTapShutterToScanHintRaw != null) {
      if (textForTapShutterToScanHintRaw is! String) {
        throw FormatException('BarcodeCountOverlay.textForTapShutterToScanHint: expected a String');
      }
      textForTapShutterToScanHintValue = textForTapShutterToScanHintRaw;
    } else if (hasTextForTapShutterToScanHint && textForTapShutterToScanHintRaw == null) {
      throw FormatException('BarcodeCountOverlay.textForTapShutterToScanHint: null is not allowed');
    }
    final hasTextForScanningHint = raw.containsKey('textForScanningHint');
    final textForScanningHintRaw = raw['textForScanningHint'];
    String? textForScanningHintValue;
    if (hasTextForScanningHint && textForScanningHintRaw != null) {
      if (textForScanningHintRaw is! String) {
        throw FormatException('BarcodeCountOverlay.textForScanningHint: expected a String');
      }
      textForScanningHintValue = textForScanningHintRaw;
    } else if (hasTextForScanningHint && textForScanningHintRaw == null) {
      throw FormatException('BarcodeCountOverlay.textForScanningHint: null is not allowed');
    }
    final hasTextForMoveCloserAndRescanHint = raw.containsKey('textForMoveCloserAndRescanHint');
    final textForMoveCloserAndRescanHintRaw = raw['textForMoveCloserAndRescanHint'];
    String? textForMoveCloserAndRescanHintValue;
    if (hasTextForMoveCloserAndRescanHint && textForMoveCloserAndRescanHintRaw != null) {
      if (textForMoveCloserAndRescanHintRaw is! String) {
        throw FormatException('BarcodeCountOverlay.textForMoveCloserAndRescanHint: expected a String');
      }
      textForMoveCloserAndRescanHintValue = textForMoveCloserAndRescanHintRaw;
    } else if (hasTextForMoveCloserAndRescanHint && textForMoveCloserAndRescanHintRaw == null) {
      throw FormatException('BarcodeCountOverlay.textForMoveCloserAndRescanHint: null is not allowed');
    }
    final hasTextForMoveFurtherAndRescanHint = raw.containsKey('textForMoveFurtherAndRescanHint');
    final textForMoveFurtherAndRescanHintRaw = raw['textForMoveFurtherAndRescanHint'];
    String? textForMoveFurtherAndRescanHintValue;
    if (hasTextForMoveFurtherAndRescanHint && textForMoveFurtherAndRescanHintRaw != null) {
      if (textForMoveFurtherAndRescanHintRaw is! String) {
        throw FormatException('BarcodeCountOverlay.textForMoveFurtherAndRescanHint: expected a String');
      }
      textForMoveFurtherAndRescanHintValue = textForMoveFurtherAndRescanHintRaw;
    } else if (hasTextForMoveFurtherAndRescanHint && textForMoveFurtherAndRescanHintRaw == null) {
      throw FormatException('BarcodeCountOverlay.textForMoveFurtherAndRescanHint: null is not allowed');
    }
    final hasTextForTapToUncountHint = raw.containsKey('textForTapToUncountHint');
    final textForTapToUncountHintRaw = raw['textForTapToUncountHint'];
    String? textForTapToUncountHintValue;
    if (hasTextForTapToUncountHint && textForTapToUncountHintRaw != null) {
      if (textForTapToUncountHintRaw is! String) {
        throw FormatException('BarcodeCountOverlay.textForTapToUncountHint: expected a String');
      }
      textForTapToUncountHintValue = textForTapToUncountHintRaw;
    } else if (hasTextForTapToUncountHint && textForTapToUncountHintRaw == null) {
      throw FormatException('BarcodeCountOverlay.textForTapToUncountHint: null is not allowed');
    }
    final hasTextForScreenCleanedUpHint = raw.containsKey('textForScreenCleanedUpHint');
    final textForScreenCleanedUpHintRaw = raw['textForScreenCleanedUpHint'];
    String? textForScreenCleanedUpHintValue;
    if (hasTextForScreenCleanedUpHint && textForScreenCleanedUpHintRaw != null) {
      if (textForScreenCleanedUpHintRaw is! String) {
        throw FormatException('BarcodeCountOverlay.textForScreenCleanedUpHint: expected a String');
      }
      textForScreenCleanedUpHintValue = textForScreenCleanedUpHintRaw;
    } else if (hasTextForScreenCleanedUpHint && textForScreenCleanedUpHintRaw == null) {
      throw FormatException('BarcodeCountOverlay.textForScreenCleanedUpHint: null is not allowed');
    }
    final hasTextForNewGroupHint = raw.containsKey('textForNewGroupHint');
    final textForNewGroupHintRaw = raw['textForNewGroupHint'];
    String? textForNewGroupHintValue;
    if (hasTextForNewGroupHint && textForNewGroupHintRaw != null) {
      if (textForNewGroupHintRaw is! String) {
        throw FormatException('BarcodeCountOverlay.textForNewGroupHint: expected a String');
      }
      textForNewGroupHintValue = textForNewGroupHintRaw;
    } else if (hasTextForNewGroupHint && textForNewGroupHintRaw == null) {
      throw FormatException('BarcodeCountOverlay.textForNewGroupHint: null is not allowed');
    }
    final hasTextForSwipeToGroupHint = raw.containsKey('textForSwipeToGroupHint');
    final textForSwipeToGroupHintRaw = raw['textForSwipeToGroupHint'];
    String? textForSwipeToGroupHintValue;
    if (hasTextForSwipeToGroupHint && textForSwipeToGroupHintRaw != null) {
      if (textForSwipeToGroupHintRaw is! String) {
        throw FormatException('BarcodeCountOverlay.textForSwipeToGroupHint: expected a String');
      }
      textForSwipeToGroupHintValue = textForSwipeToGroupHintRaw;
    } else if (hasTextForSwipeToGroupHint && textForSwipeToGroupHintRaw == null) {
      throw FormatException('BarcodeCountOverlay.textForSwipeToGroupHint: null is not allowed');
    }
    final hasTextForRescanYellowCodesHint = raw.containsKey('textForRescanYellowCodesHint');
    final textForRescanYellowCodesHintRaw = raw['textForRescanYellowCodesHint'];
    String? textForRescanYellowCodesHintValue;
    if (hasTextForRescanYellowCodesHint && textForRescanYellowCodesHintRaw != null) {
      if (textForRescanYellowCodesHintRaw is! String) {
        throw FormatException('BarcodeCountOverlay.textForRescanYellowCodesHint: expected a String');
      }
      textForRescanYellowCodesHintValue = textForRescanYellowCodesHintRaw;
    } else if (hasTextForRescanYellowCodesHint && textForRescanYellowCodesHintRaw == null) {
      throw FormatException('BarcodeCountOverlay.textForRescanYellowCodesHint: null is not allowed');
    }
    return BarcodeCountOverlay(
      type: typeValue!,
      style: styleValue,
      notInListBrush: notInListBrushValue,
      recognizedBrush: recognizedBrushValue,
      unrecognizedBrush: unrecognizedBrushValue,
      shouldShowScanAreaGuides: shouldShowScanAreaGuidesValue,
      filterOverlaySettings: filterOverlaySettingsValue,
      shouldEnableUserGuidance: shouldEnableUserGuidanceValue,
      shouldShowHints: shouldShowHintsValue,
      colorScheme: colorSchemeValue,
      textForUnscannedBarcodeDetectedHint: textForUnscannedBarcodeDetectedHintValue,
      textForUnrecognizedBarcodesDetectedHint: textForUnrecognizedBarcodesDetectedHintValue,
      textForWrongBarcodeDetectedHint: textForWrongBarcodeDetectedHintValue,
      textForTapShutterToScanHint: textForTapShutterToScanHintValue,
      textForScanningHint: textForScanningHintValue,
      textForMoveCloserAndRescanHint: textForMoveCloserAndRescanHintValue,
      textForMoveFurtherAndRescanHint: textForMoveFurtherAndRescanHintValue,
      textForTapToUncountHint: textForTapToUncountHintValue,
      textForScreenCleanedUpHint: textForScreenCleanedUpHintValue,
      textForNewGroupHint: textForNewGroupHintValue,
      textForSwipeToGroupHint: textForSwipeToGroupHintValue,
      textForRescanYellowCodesHint: textForRescanYellowCodesHintValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (style != null) {
      map['style'] = style;
    }
    if (notInListBrush != null) {
      map['notInListBrush'] = notInListBrush!.toJson();
    }
    if (recognizedBrush != null) {
      map['recognizedBrush'] = recognizedBrush!.toJson();
    }
    if (unrecognizedBrush != null) {
      map['unrecognizedBrush'] = unrecognizedBrush!.toJson();
    }
    if (shouldShowScanAreaGuides != null) {
      map['shouldShowScanAreaGuides'] = shouldShowScanAreaGuides;
    }
    if (filterOverlaySettings != null) {
      map['filterOverlaySettings'] = filterOverlaySettings!.toJson();
    }
    if (shouldEnableUserGuidance != null) {
      map['shouldEnableUserGuidance'] = shouldEnableUserGuidance;
    }
    if (shouldShowHints != null) {
      map['shouldShowHints'] = shouldShowHints;
    }
    if (colorScheme != null) {
      map['colorScheme'] = colorScheme;
    }
    if (textForUnscannedBarcodeDetectedHint != null) {
      map['textForUnscannedBarcodeDetectedHint'] = textForUnscannedBarcodeDetectedHint;
    }
    if (textForUnrecognizedBarcodesDetectedHint != null) {
      map['textForUnrecognizedBarcodesDetectedHint'] = textForUnrecognizedBarcodesDetectedHint;
    }
    if (textForWrongBarcodeDetectedHint != null) {
      map['textForWrongBarcodeDetectedHint'] = textForWrongBarcodeDetectedHint;
    }
    if (textForTapShutterToScanHint != null) {
      map['textForTapShutterToScanHint'] = textForTapShutterToScanHint;
    }
    if (textForScanningHint != null) {
      map['textForScanningHint'] = textForScanningHint;
    }
    if (textForMoveCloserAndRescanHint != null) {
      map['textForMoveCloserAndRescanHint'] = textForMoveCloserAndRescanHint;
    }
    if (textForMoveFurtherAndRescanHint != null) {
      map['textForMoveFurtherAndRescanHint'] = textForMoveFurtherAndRescanHint;
    }
    if (textForTapToUncountHint != null) {
      map['textForTapToUncountHint'] = textForTapToUncountHint;
    }
    if (textForScreenCleanedUpHint != null) {
      map['textForScreenCleanedUpHint'] = textForScreenCleanedUpHint;
    }
    if (textForNewGroupHint != null) {
      map['textForNewGroupHint'] = textForNewGroupHint;
    }
    if (textForSwipeToGroupHint != null) {
      map['textForSwipeToGroupHint'] = textForSwipeToGroupHint;
    }
    if (textForRescanYellowCodesHint != null) {
      map['textForRescanYellowCodesHint'] = textForRescanYellowCodesHint;
    }
    return map;
  }
}

/// Typed builder for the `BarcodeCountOverlay` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildBarcodeCountOverlay({
  required String type,
  String? style,
  Object? notInListBrush,
  Object? recognizedBrush,
  Object? unrecognizedBrush,
  bool? shouldShowScanAreaGuides,
  Object? filterOverlaySettings,
  bool? shouldEnableUserGuidance,
  bool? shouldShowHints,
  String? colorScheme,
  String? textForUnscannedBarcodeDetectedHint,
  String? textForUnrecognizedBarcodesDetectedHint,
  String? textForWrongBarcodeDetectedHint,
  String? textForTapShutterToScanHint,
  String? textForScanningHint,
  String? textForMoveCloserAndRescanHint,
  String? textForMoveFurtherAndRescanHint,
  String? textForTapToUncountHint,
  String? textForScreenCleanedUpHint,
  String? textForNewGroupHint,
  String? textForSwipeToGroupHint,
  String? textForRescanYellowCodesHint,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (style != null) {
    map['style'] = style;
  }
  if (notInListBrush != null) {
    map['notInListBrush'] = notInListBrush;
  }
  if (recognizedBrush != null) {
    map['recognizedBrush'] = recognizedBrush;
  }
  if (unrecognizedBrush != null) {
    map['unrecognizedBrush'] = unrecognizedBrush;
  }
  if (shouldShowScanAreaGuides != null) {
    map['shouldShowScanAreaGuides'] = shouldShowScanAreaGuides;
  }
  if (filterOverlaySettings != null) {
    map['filterOverlaySettings'] = filterOverlaySettings;
  }
  if (shouldEnableUserGuidance != null) {
    map['shouldEnableUserGuidance'] = shouldEnableUserGuidance;
  }
  if (shouldShowHints != null) {
    map['shouldShowHints'] = shouldShowHints;
  }
  if (colorScheme != null) {
    map['colorScheme'] = colorScheme;
  }
  if (textForUnscannedBarcodeDetectedHint != null) {
    map['textForUnscannedBarcodeDetectedHint'] = textForUnscannedBarcodeDetectedHint;
  }
  if (textForUnrecognizedBarcodesDetectedHint != null) {
    map['textForUnrecognizedBarcodesDetectedHint'] = textForUnrecognizedBarcodesDetectedHint;
  }
  if (textForWrongBarcodeDetectedHint != null) {
    map['textForWrongBarcodeDetectedHint'] = textForWrongBarcodeDetectedHint;
  }
  if (textForTapShutterToScanHint != null) {
    map['textForTapShutterToScanHint'] = textForTapShutterToScanHint;
  }
  if (textForScanningHint != null) {
    map['textForScanningHint'] = textForScanningHint;
  }
  if (textForMoveCloserAndRescanHint != null) {
    map['textForMoveCloserAndRescanHint'] = textForMoveCloserAndRescanHint;
  }
  if (textForMoveFurtherAndRescanHint != null) {
    map['textForMoveFurtherAndRescanHint'] = textForMoveFurtherAndRescanHint;
  }
  if (textForTapToUncountHint != null) {
    map['textForTapToUncountHint'] = textForTapToUncountHint;
  }
  if (textForScreenCleanedUpHint != null) {
    map['textForScreenCleanedUpHint'] = textForScreenCleanedUpHint;
  }
  if (textForNewGroupHint != null) {
    map['textForNewGroupHint'] = textForNewGroupHint;
  }
  if (textForSwipeToGroupHint != null) {
    map['textForSwipeToGroupHint'] = textForSwipeToGroupHint;
  }
  if (textForRescanYellowCodesHint != null) {
    map['textForRescanYellowCodesHint'] = textForRescanYellowCodesHint;
  }
  return map;
}

/// Settings for overlay filtering in BarcodeCount.
class FilterOverlaySettings {
  final Brush? brush;
  final String? highlightType;

  const FilterOverlaySettings({
    this.brush,
    this.highlightType,
  });

  factory FilterOverlaySettings.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('FilterOverlaySettings: expected a Map');
    }
    const allowedKeys = <String>{
      'brush',
      'highlightType',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("FilterOverlaySettings: unknown property '$key'");
      }
    }
    final hasBrush = raw.containsKey('brush');
    final brushRaw = raw['brush'];
    Brush? brushValue;
    if (hasBrush && brushRaw != null) {
      brushValue = Brush.fromJson(brushRaw);
    } else if (hasBrush && brushRaw == null) {
      throw FormatException('FilterOverlaySettings.brush: null is not allowed');
    }
    final hasHighlightType = raw.containsKey('highlightType');
    final highlightTypeRaw = raw['highlightType'];
    String? highlightTypeValue;
    if (hasHighlightType && highlightTypeRaw != null) {
      if (highlightTypeRaw is! String || !const <String>['blurred', 'brush'].contains(highlightTypeRaw)) {
        throw FormatException("FilterOverlaySettings.highlightType: unknown enum value '$highlightTypeRaw'");
      }
      highlightTypeValue = highlightTypeRaw;
    } else if (hasHighlightType && highlightTypeRaw == null) {
      throw FormatException('FilterOverlaySettings.highlightType: null is not allowed');
    }
    return FilterOverlaySettings(
      brush: brushValue,
      highlightType: highlightTypeValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (brush != null) {
      map['brush'] = brush!.toJson();
    }
    if (highlightType != null) {
      map['highlightType'] = highlightType;
    }
    return map;
  }
}

/// Typed builder for the `FilterOverlaySettings` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildFilterOverlaySettings({
  Object? brush,
  String? highlightType,
}) {
  final map = <String, Object?>{};
  if (brush != null) {
    map['brush'] = brush;
  }
  if (highlightType != null) {
    map['highlightType'] = highlightType;
  }
  return map;
}

/// Discriminated union of all view controls. The type field selects the concrete schema.
// NOTE: `abstract class`, not `abstract interface class`. The generated Dart
// must parse under the OLDEST toolchain in CI -- validate-bridge-generator's
// `dart format` runs on an older Dart SDK that does not understand Dart 3.0+
// class modifiers (`interface`, `sealed`, `base`, `final class`,
// `mixin class`). The docs signature collector moved to `analyzer ^7.7.1` in
// SDC-33150 and parses those fine, so it is no longer part of this
// constraint; `dart format` still is. `abstract class` is implementable in
// Dart 2 and 3 alike, so it preserves the same "implement, don't extend"
// contract without the modifier.
abstract class Control {
  Map<String, Object?> toJson();

  factory Control.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('Control: expected a Map');
    }
    final discriminant = raw['type'];
    switch (discriminant) {
      case 'torch':
        return TorchSwitchControl.fromJson(raw);
      case 'camera':
        return CameraSwitchControl.fromJson(raw);
      case 'zoom':
        return ZoomSwitchControl.fromJson(raw);
      case 'macro':
        return MacroModeControl.fromJson(raw);
      case 'linearGroup':
        return LinearControlGroup.fromJson(raw);
      default:
        throw FormatException(
          "Control: unknown type '$discriminant'",
        );
    }
  }
}

/// A control that toggles the device torch.
class TorchSwitchControl implements Control {
  final String type;
  final Anchor? anchor;
  final UIPoint? offset;
  final String? contentDescriptionWhenOff;
  final String? contentDescriptionWhenOn;
  final String? accessibilityLabelWhenOff;
  final String? accessibilityLabelWhenOn;
  final String? accessibilityHintWhenOff;
  final String? accessibilityHintWhenOn;
  final TorchIcon? icon;

  const TorchSwitchControl({
    required this.type,
    this.anchor,
    this.offset,
    this.contentDescriptionWhenOff,
    this.contentDescriptionWhenOn,
    this.accessibilityLabelWhenOff,
    this.accessibilityLabelWhenOn,
    this.accessibilityHintWhenOff,
    this.accessibilityHintWhenOn,
    this.icon,
  });

  factory TorchSwitchControl.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('TorchSwitchControl: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'anchor',
      'offset',
      'contentDescriptionWhenOff',
      'contentDescriptionWhenOn',
      'accessibilityLabelWhenOff',
      'accessibilityLabelWhenOn',
      'accessibilityHintWhenOff',
      'accessibilityHintWhenOn',
      'icon',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("TorchSwitchControl: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("TorchSwitchControl.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['torch'].contains(typeRaw)) {
        throw FormatException("TorchSwitchControl.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('TorchSwitchControl.type: null is not allowed');
    }
    final hasAnchor = raw.containsKey('anchor');
    final anchorRaw = raw['anchor'];
    Anchor? anchorValue;
    if (hasAnchor && anchorRaw != null) {
      anchorValue = (anchorRaw is! String
          ? (throw FormatException('TorchSwitchControl.anchor: expected a String for Anchor'))
          : Anchor.fromJSON(anchorRaw));
    } else if (hasAnchor && anchorRaw == null) {
      throw FormatException('TorchSwitchControl.anchor: null is not allowed');
    }
    final hasOffset = raw.containsKey('offset');
    final offsetRaw = raw['offset'];
    UIPoint? offsetValue;
    if (hasOffset && offsetRaw != null) {
      offsetValue = UIPoint.fromJson(offsetRaw);
    } else if (hasOffset && offsetRaw == null) {
      throw FormatException('TorchSwitchControl.offset: null is not allowed');
    }
    final hasContentDescriptionWhenOff = raw.containsKey('contentDescriptionWhenOff');
    final contentDescriptionWhenOffRaw = raw['contentDescriptionWhenOff'];
    String? contentDescriptionWhenOffValue;
    if (hasContentDescriptionWhenOff && contentDescriptionWhenOffRaw != null) {
      if (contentDescriptionWhenOffRaw is! String) {
        throw FormatException('TorchSwitchControl.contentDescriptionWhenOff: expected a String');
      }
      contentDescriptionWhenOffValue = contentDescriptionWhenOffRaw;
    } else if (hasContentDescriptionWhenOff && contentDescriptionWhenOffRaw == null) {
      throw FormatException('TorchSwitchControl.contentDescriptionWhenOff: null is not allowed');
    }
    final hasContentDescriptionWhenOn = raw.containsKey('contentDescriptionWhenOn');
    final contentDescriptionWhenOnRaw = raw['contentDescriptionWhenOn'];
    String? contentDescriptionWhenOnValue;
    if (hasContentDescriptionWhenOn && contentDescriptionWhenOnRaw != null) {
      if (contentDescriptionWhenOnRaw is! String) {
        throw FormatException('TorchSwitchControl.contentDescriptionWhenOn: expected a String');
      }
      contentDescriptionWhenOnValue = contentDescriptionWhenOnRaw;
    } else if (hasContentDescriptionWhenOn && contentDescriptionWhenOnRaw == null) {
      throw FormatException('TorchSwitchControl.contentDescriptionWhenOn: null is not allowed');
    }
    final hasAccessibilityLabelWhenOff = raw.containsKey('accessibilityLabelWhenOff');
    final accessibilityLabelWhenOffRaw = raw['accessibilityLabelWhenOff'];
    String? accessibilityLabelWhenOffValue;
    if (hasAccessibilityLabelWhenOff && accessibilityLabelWhenOffRaw != null) {
      if (accessibilityLabelWhenOffRaw is! String) {
        throw FormatException('TorchSwitchControl.accessibilityLabelWhenOff: expected a String');
      }
      accessibilityLabelWhenOffValue = accessibilityLabelWhenOffRaw;
    } else if (hasAccessibilityLabelWhenOff && accessibilityLabelWhenOffRaw == null) {
      throw FormatException('TorchSwitchControl.accessibilityLabelWhenOff: null is not allowed');
    }
    final hasAccessibilityLabelWhenOn = raw.containsKey('accessibilityLabelWhenOn');
    final accessibilityLabelWhenOnRaw = raw['accessibilityLabelWhenOn'];
    String? accessibilityLabelWhenOnValue;
    if (hasAccessibilityLabelWhenOn && accessibilityLabelWhenOnRaw != null) {
      if (accessibilityLabelWhenOnRaw is! String) {
        throw FormatException('TorchSwitchControl.accessibilityLabelWhenOn: expected a String');
      }
      accessibilityLabelWhenOnValue = accessibilityLabelWhenOnRaw;
    } else if (hasAccessibilityLabelWhenOn && accessibilityLabelWhenOnRaw == null) {
      throw FormatException('TorchSwitchControl.accessibilityLabelWhenOn: null is not allowed');
    }
    final hasAccessibilityHintWhenOff = raw.containsKey('accessibilityHintWhenOff');
    final accessibilityHintWhenOffRaw = raw['accessibilityHintWhenOff'];
    String? accessibilityHintWhenOffValue;
    if (hasAccessibilityHintWhenOff && accessibilityHintWhenOffRaw != null) {
      if (accessibilityHintWhenOffRaw is! String) {
        throw FormatException('TorchSwitchControl.accessibilityHintWhenOff: expected a String');
      }
      accessibilityHintWhenOffValue = accessibilityHintWhenOffRaw;
    } else if (hasAccessibilityHintWhenOff && accessibilityHintWhenOffRaw == null) {
      throw FormatException('TorchSwitchControl.accessibilityHintWhenOff: null is not allowed');
    }
    final hasAccessibilityHintWhenOn = raw.containsKey('accessibilityHintWhenOn');
    final accessibilityHintWhenOnRaw = raw['accessibilityHintWhenOn'];
    String? accessibilityHintWhenOnValue;
    if (hasAccessibilityHintWhenOn && accessibilityHintWhenOnRaw != null) {
      if (accessibilityHintWhenOnRaw is! String) {
        throw FormatException('TorchSwitchControl.accessibilityHintWhenOn: expected a String');
      }
      accessibilityHintWhenOnValue = accessibilityHintWhenOnRaw;
    } else if (hasAccessibilityHintWhenOn && accessibilityHintWhenOnRaw == null) {
      throw FormatException('TorchSwitchControl.accessibilityHintWhenOn: null is not allowed');
    }
    final hasIcon = raw.containsKey('icon');
    final iconRaw = raw['icon'];
    TorchIcon? iconValue;
    if (hasIcon && iconRaw != null) {
      iconValue = TorchIcon.fromJson(iconRaw);
    } else if (hasIcon && iconRaw == null) {
      throw FormatException('TorchSwitchControl.icon: null is not allowed');
    }
    return TorchSwitchControl(
      type: typeValue!,
      anchor: anchorValue,
      offset: offsetValue,
      contentDescriptionWhenOff: contentDescriptionWhenOffValue,
      contentDescriptionWhenOn: contentDescriptionWhenOnValue,
      accessibilityLabelWhenOff: accessibilityLabelWhenOffValue,
      accessibilityLabelWhenOn: accessibilityLabelWhenOnValue,
      accessibilityHintWhenOff: accessibilityHintWhenOffValue,
      accessibilityHintWhenOn: accessibilityHintWhenOnValue,
      icon: iconValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (anchor != null) {
      map['anchor'] = anchor!.toJson();
    }
    if (offset != null) {
      map['offset'] = offset!.toJson();
    }
    if (contentDescriptionWhenOff != null) {
      map['contentDescriptionWhenOff'] = contentDescriptionWhenOff;
    }
    if (contentDescriptionWhenOn != null) {
      map['contentDescriptionWhenOn'] = contentDescriptionWhenOn;
    }
    if (accessibilityLabelWhenOff != null) {
      map['accessibilityLabelWhenOff'] = accessibilityLabelWhenOff;
    }
    if (accessibilityLabelWhenOn != null) {
      map['accessibilityLabelWhenOn'] = accessibilityLabelWhenOn;
    }
    if (accessibilityHintWhenOff != null) {
      map['accessibilityHintWhenOff'] = accessibilityHintWhenOff;
    }
    if (accessibilityHintWhenOn != null) {
      map['accessibilityHintWhenOn'] = accessibilityHintWhenOn;
    }
    if (icon != null) {
      map['icon'] = icon!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `TorchSwitchControl` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildTorchSwitchControl({
  required String type,
  Object? anchor,
  Object? offset,
  String? contentDescriptionWhenOff,
  String? contentDescriptionWhenOn,
  String? accessibilityLabelWhenOff,
  String? accessibilityLabelWhenOn,
  String? accessibilityHintWhenOff,
  String? accessibilityHintWhenOn,
  Object? icon,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (anchor != null) {
    map['anchor'] = anchor;
  }
  if (offset != null) {
    map['offset'] = offset;
  }
  if (contentDescriptionWhenOff != null) {
    map['contentDescriptionWhenOff'] = contentDescriptionWhenOff;
  }
  if (contentDescriptionWhenOn != null) {
    map['contentDescriptionWhenOn'] = contentDescriptionWhenOn;
  }
  if (accessibilityLabelWhenOff != null) {
    map['accessibilityLabelWhenOff'] = accessibilityLabelWhenOff;
  }
  if (accessibilityLabelWhenOn != null) {
    map['accessibilityLabelWhenOn'] = accessibilityLabelWhenOn;
  }
  if (accessibilityHintWhenOff != null) {
    map['accessibilityHintWhenOff'] = accessibilityHintWhenOff;
  }
  if (accessibilityHintWhenOn != null) {
    map['accessibilityHintWhenOn'] = accessibilityHintWhenOn;
  }
  if (icon != null) {
    map['icon'] = icon;
  }
  return map;
}

///
class TorchIcon {
  final IconState? on$;
  final IconState? off;

  const TorchIcon({
    this.on$,
    this.off,
  });

  factory TorchIcon.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('TorchIcon: expected a Map');
    }
    const allowedKeys = <String>{
      'on',
      'off',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("TorchIcon: unknown property '$key'");
      }
    }
    final hasOn$ = raw.containsKey('on');
    final on$Raw = raw['on'];
    IconState? on$Value;
    if (hasOn$ && on$Raw != null) {
      on$Value = IconState.fromJson(on$Raw);
    } else if (hasOn$ && on$Raw == null) {
      throw FormatException('TorchIcon.on: null is not allowed');
    }
    final hasOff = raw.containsKey('off');
    final offRaw = raw['off'];
    IconState? offValue;
    if (hasOff && offRaw != null) {
      offValue = IconState.fromJson(offRaw);
    } else if (hasOff && offRaw == null) {
      throw FormatException('TorchIcon.off: null is not allowed');
    }
    return TorchIcon(
      on$: on$Value,
      off: offValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (on$ != null) {
      map['on'] = on$!.toJson();
    }
    if (off != null) {
      map['off'] = off!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `TorchIcon` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildTorchIcon({
  Object? on$,
  Object? off,
}) {
  final map = <String, Object?>{};
  if (on$ != null) {
    map['on'] = on$;
  }
  if (off != null) {
    map['off'] = off;
  }
  return map;
}

///
class IconState {
  final Object? default$;
  final Object? pressed;

  const IconState({
    this.default$,
    this.pressed,
  });

  factory IconState.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('IconState: expected a Map');
    }
    const allowedKeys = <String>{
      'default',
      'pressed',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("IconState: unknown property '$key'");
      }
    }
    final hasDefault$ = raw.containsKey('default');
    final default$Raw = raw['default'];
    Object? default$Value;
    if (hasDefault$ && default$Raw != null) {
      default$Value = default$Raw;
    } else if (hasDefault$ && default$Raw == null) {
      throw FormatException('IconState.default: null is not allowed');
    }
    final hasPressed = raw.containsKey('pressed');
    final pressedRaw = raw['pressed'];
    Object? pressedValue;
    if (hasPressed && pressedRaw != null) {
      pressedValue = pressedRaw;
    } else if (hasPressed && pressedRaw == null) {
      throw FormatException('IconState.pressed: null is not allowed');
    }
    return IconState(
      default$: default$Value,
      pressed: pressedValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (default$ != null) {
      map['default'] = default$;
    }
    if (pressed != null) {
      map['pressed'] = pressed;
    }
    return map;
  }
}

/// Typed builder for the `IconState` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildIconState({
  Object? default$,
  Object? pressed,
}) {
  final map = <String, Object?>{};
  if (default$ != null) {
    map['default'] = default$;
  }
  if (pressed != null) {
    map['pressed'] = pressed;
  }
  return map;
}

/// A control that switches between the primary and secondary cameras.
class CameraSwitchControl implements Control {
  final String type;
  final Anchor? anchor;
  final UIPoint? offset;
  final String? contentDescriptionWhenUserFacing;
  final String? contentDescriptionWhenWorldFacing;
  final String? accessibilityLabelWhenWorldFacing;
  final String? accessibilityLabelWhenUserFacing;
  final String? accessibilityHintWhenWorldFacing;
  final String? accessibilityHintWhenUserFacing;
  final Camera primaryCamera;
  final Camera secondaryCamera;
  final CameraIcon? icon;

  const CameraSwitchControl({
    required this.type,
    this.anchor,
    this.offset,
    this.contentDescriptionWhenUserFacing,
    this.contentDescriptionWhenWorldFacing,
    this.accessibilityLabelWhenWorldFacing,
    this.accessibilityLabelWhenUserFacing,
    this.accessibilityHintWhenWorldFacing,
    this.accessibilityHintWhenUserFacing,
    required this.primaryCamera,
    required this.secondaryCamera,
    this.icon,
  });

  factory CameraSwitchControl.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('CameraSwitchControl: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'anchor',
      'offset',
      'contentDescriptionWhenUserFacing',
      'contentDescriptionWhenWorldFacing',
      'accessibilityLabelWhenWorldFacing',
      'accessibilityLabelWhenUserFacing',
      'accessibilityHintWhenWorldFacing',
      'accessibilityHintWhenUserFacing',
      'primaryCamera',
      'secondaryCamera',
      'icon',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("CameraSwitchControl: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("CameraSwitchControl.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['camera'].contains(typeRaw)) {
        throw FormatException("CameraSwitchControl.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('CameraSwitchControl.type: null is not allowed');
    }
    final hasAnchor = raw.containsKey('anchor');
    final anchorRaw = raw['anchor'];
    Anchor? anchorValue;
    if (hasAnchor && anchorRaw != null) {
      anchorValue = (anchorRaw is! String
          ? (throw FormatException('CameraSwitchControl.anchor: expected a String for Anchor'))
          : Anchor.fromJSON(anchorRaw));
    } else if (hasAnchor && anchorRaw == null) {
      throw FormatException('CameraSwitchControl.anchor: null is not allowed');
    }
    final hasOffset = raw.containsKey('offset');
    final offsetRaw = raw['offset'];
    UIPoint? offsetValue;
    if (hasOffset && offsetRaw != null) {
      offsetValue = UIPoint.fromJson(offsetRaw);
    } else if (hasOffset && offsetRaw == null) {
      throw FormatException('CameraSwitchControl.offset: null is not allowed');
    }
    final hasContentDescriptionWhenUserFacing = raw.containsKey('contentDescriptionWhenUserFacing');
    final contentDescriptionWhenUserFacingRaw = raw['contentDescriptionWhenUserFacing'];
    String? contentDescriptionWhenUserFacingValue;
    if (hasContentDescriptionWhenUserFacing && contentDescriptionWhenUserFacingRaw != null) {
      if (contentDescriptionWhenUserFacingRaw is! String) {
        throw FormatException('CameraSwitchControl.contentDescriptionWhenUserFacing: expected a String');
      }
      contentDescriptionWhenUserFacingValue = contentDescriptionWhenUserFacingRaw;
    } else if (hasContentDescriptionWhenUserFacing && contentDescriptionWhenUserFacingRaw == null) {
      throw FormatException('CameraSwitchControl.contentDescriptionWhenUserFacing: null is not allowed');
    }
    final hasContentDescriptionWhenWorldFacing = raw.containsKey('contentDescriptionWhenWorldFacing');
    final contentDescriptionWhenWorldFacingRaw = raw['contentDescriptionWhenWorldFacing'];
    String? contentDescriptionWhenWorldFacingValue;
    if (hasContentDescriptionWhenWorldFacing && contentDescriptionWhenWorldFacingRaw != null) {
      if (contentDescriptionWhenWorldFacingRaw is! String) {
        throw FormatException('CameraSwitchControl.contentDescriptionWhenWorldFacing: expected a String');
      }
      contentDescriptionWhenWorldFacingValue = contentDescriptionWhenWorldFacingRaw;
    } else if (hasContentDescriptionWhenWorldFacing && contentDescriptionWhenWorldFacingRaw == null) {
      throw FormatException('CameraSwitchControl.contentDescriptionWhenWorldFacing: null is not allowed');
    }
    final hasAccessibilityLabelWhenWorldFacing = raw.containsKey('accessibilityLabelWhenWorldFacing');
    final accessibilityLabelWhenWorldFacingRaw = raw['accessibilityLabelWhenWorldFacing'];
    String? accessibilityLabelWhenWorldFacingValue;
    if (hasAccessibilityLabelWhenWorldFacing && accessibilityLabelWhenWorldFacingRaw != null) {
      if (accessibilityLabelWhenWorldFacingRaw is! String) {
        throw FormatException('CameraSwitchControl.accessibilityLabelWhenWorldFacing: expected a String');
      }
      accessibilityLabelWhenWorldFacingValue = accessibilityLabelWhenWorldFacingRaw;
    } else if (hasAccessibilityLabelWhenWorldFacing && accessibilityLabelWhenWorldFacingRaw == null) {
      throw FormatException('CameraSwitchControl.accessibilityLabelWhenWorldFacing: null is not allowed');
    }
    final hasAccessibilityLabelWhenUserFacing = raw.containsKey('accessibilityLabelWhenUserFacing');
    final accessibilityLabelWhenUserFacingRaw = raw['accessibilityLabelWhenUserFacing'];
    String? accessibilityLabelWhenUserFacingValue;
    if (hasAccessibilityLabelWhenUserFacing && accessibilityLabelWhenUserFacingRaw != null) {
      if (accessibilityLabelWhenUserFacingRaw is! String) {
        throw FormatException('CameraSwitchControl.accessibilityLabelWhenUserFacing: expected a String');
      }
      accessibilityLabelWhenUserFacingValue = accessibilityLabelWhenUserFacingRaw;
    } else if (hasAccessibilityLabelWhenUserFacing && accessibilityLabelWhenUserFacingRaw == null) {
      throw FormatException('CameraSwitchControl.accessibilityLabelWhenUserFacing: null is not allowed');
    }
    final hasAccessibilityHintWhenWorldFacing = raw.containsKey('accessibilityHintWhenWorldFacing');
    final accessibilityHintWhenWorldFacingRaw = raw['accessibilityHintWhenWorldFacing'];
    String? accessibilityHintWhenWorldFacingValue;
    if (hasAccessibilityHintWhenWorldFacing && accessibilityHintWhenWorldFacingRaw != null) {
      if (accessibilityHintWhenWorldFacingRaw is! String) {
        throw FormatException('CameraSwitchControl.accessibilityHintWhenWorldFacing: expected a String');
      }
      accessibilityHintWhenWorldFacingValue = accessibilityHintWhenWorldFacingRaw;
    } else if (hasAccessibilityHintWhenWorldFacing && accessibilityHintWhenWorldFacingRaw == null) {
      throw FormatException('CameraSwitchControl.accessibilityHintWhenWorldFacing: null is not allowed');
    }
    final hasAccessibilityHintWhenUserFacing = raw.containsKey('accessibilityHintWhenUserFacing');
    final accessibilityHintWhenUserFacingRaw = raw['accessibilityHintWhenUserFacing'];
    String? accessibilityHintWhenUserFacingValue;
    if (hasAccessibilityHintWhenUserFacing && accessibilityHintWhenUserFacingRaw != null) {
      if (accessibilityHintWhenUserFacingRaw is! String) {
        throw FormatException('CameraSwitchControl.accessibilityHintWhenUserFacing: expected a String');
      }
      accessibilityHintWhenUserFacingValue = accessibilityHintWhenUserFacingRaw;
    } else if (hasAccessibilityHintWhenUserFacing && accessibilityHintWhenUserFacingRaw == null) {
      throw FormatException('CameraSwitchControl.accessibilityHintWhenUserFacing: null is not allowed');
    }
    final hasPrimaryCamera = raw.containsKey('primaryCamera');
    if (!hasPrimaryCamera) {
      throw FormatException("CameraSwitchControl.primaryCamera: missing required property");
    }
    final primaryCameraRaw = raw['primaryCamera'];
    Camera? primaryCameraValue;
    if (hasPrimaryCamera && primaryCameraRaw != null) {
      primaryCameraValue = Camera.fromJson(primaryCameraRaw);
    } else if (hasPrimaryCamera && primaryCameraRaw == null) {
      throw FormatException('CameraSwitchControl.primaryCamera: null is not allowed');
    }
    final hasSecondaryCamera = raw.containsKey('secondaryCamera');
    if (!hasSecondaryCamera) {
      throw FormatException("CameraSwitchControl.secondaryCamera: missing required property");
    }
    final secondaryCameraRaw = raw['secondaryCamera'];
    Camera? secondaryCameraValue;
    if (hasSecondaryCamera && secondaryCameraRaw != null) {
      secondaryCameraValue = Camera.fromJson(secondaryCameraRaw);
    } else if (hasSecondaryCamera && secondaryCameraRaw == null) {
      throw FormatException('CameraSwitchControl.secondaryCamera: null is not allowed');
    }
    final hasIcon = raw.containsKey('icon');
    final iconRaw = raw['icon'];
    CameraIcon? iconValue;
    if (hasIcon && iconRaw != null) {
      iconValue = CameraIcon.fromJson(iconRaw);
    } else if (hasIcon && iconRaw == null) {
      throw FormatException('CameraSwitchControl.icon: null is not allowed');
    }
    return CameraSwitchControl(
      type: typeValue!,
      anchor: anchorValue,
      offset: offsetValue,
      contentDescriptionWhenUserFacing: contentDescriptionWhenUserFacingValue,
      contentDescriptionWhenWorldFacing: contentDescriptionWhenWorldFacingValue,
      accessibilityLabelWhenWorldFacing: accessibilityLabelWhenWorldFacingValue,
      accessibilityLabelWhenUserFacing: accessibilityLabelWhenUserFacingValue,
      accessibilityHintWhenWorldFacing: accessibilityHintWhenWorldFacingValue,
      accessibilityHintWhenUserFacing: accessibilityHintWhenUserFacingValue,
      primaryCamera: primaryCameraValue!,
      secondaryCamera: secondaryCameraValue!,
      icon: iconValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (anchor != null) {
      map['anchor'] = anchor!.toJson();
    }
    if (offset != null) {
      map['offset'] = offset!.toJson();
    }
    if (contentDescriptionWhenUserFacing != null) {
      map['contentDescriptionWhenUserFacing'] = contentDescriptionWhenUserFacing;
    }
    if (contentDescriptionWhenWorldFacing != null) {
      map['contentDescriptionWhenWorldFacing'] = contentDescriptionWhenWorldFacing;
    }
    if (accessibilityLabelWhenWorldFacing != null) {
      map['accessibilityLabelWhenWorldFacing'] = accessibilityLabelWhenWorldFacing;
    }
    if (accessibilityLabelWhenUserFacing != null) {
      map['accessibilityLabelWhenUserFacing'] = accessibilityLabelWhenUserFacing;
    }
    if (accessibilityHintWhenWorldFacing != null) {
      map['accessibilityHintWhenWorldFacing'] = accessibilityHintWhenWorldFacing;
    }
    if (accessibilityHintWhenUserFacing != null) {
      map['accessibilityHintWhenUserFacing'] = accessibilityHintWhenUserFacing;
    }
    map['primaryCamera'] = primaryCamera.toJson();
    map['secondaryCamera'] = secondaryCamera.toJson();
    if (icon != null) {
      map['icon'] = icon!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `CameraSwitchControl` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildCameraSwitchControl({
  required String type,
  Object? anchor,
  Object? offset,
  String? contentDescriptionWhenUserFacing,
  String? contentDescriptionWhenWorldFacing,
  String? accessibilityLabelWhenWorldFacing,
  String? accessibilityLabelWhenUserFacing,
  String? accessibilityHintWhenWorldFacing,
  String? accessibilityHintWhenUserFacing,
  required Object primaryCamera,
  required Object secondaryCamera,
  Object? icon,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (anchor != null) {
    map['anchor'] = anchor;
  }
  if (offset != null) {
    map['offset'] = offset;
  }
  if (contentDescriptionWhenUserFacing != null) {
    map['contentDescriptionWhenUserFacing'] = contentDescriptionWhenUserFacing;
  }
  if (contentDescriptionWhenWorldFacing != null) {
    map['contentDescriptionWhenWorldFacing'] = contentDescriptionWhenWorldFacing;
  }
  if (accessibilityLabelWhenWorldFacing != null) {
    map['accessibilityLabelWhenWorldFacing'] = accessibilityLabelWhenWorldFacing;
  }
  if (accessibilityLabelWhenUserFacing != null) {
    map['accessibilityLabelWhenUserFacing'] = accessibilityLabelWhenUserFacing;
  }
  if (accessibilityHintWhenWorldFacing != null) {
    map['accessibilityHintWhenWorldFacing'] = accessibilityHintWhenWorldFacing;
  }
  if (accessibilityHintWhenUserFacing != null) {
    map['accessibilityHintWhenUserFacing'] = accessibilityHintWhenUserFacing;
  }
  map['primaryCamera'] = primaryCamera;
  map['secondaryCamera'] = secondaryCamera;
  if (icon != null) {
    map['icon'] = icon;
  }
  return map;
}

///
class CameraIcon {
  final CameraSwitchControlIconState? primaryCamera;
  final CameraSwitchControlIconState? secondaryCamera;

  const CameraIcon({
    this.primaryCamera,
    this.secondaryCamera,
  });

  factory CameraIcon.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('CameraIcon: expected a Map');
    }
    const allowedKeys = <String>{
      'primaryCamera',
      'secondaryCamera',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("CameraIcon: unknown property '$key'");
      }
    }
    final hasPrimaryCamera = raw.containsKey('primaryCamera');
    final primaryCameraRaw = raw['primaryCamera'];
    CameraSwitchControlIconState? primaryCameraValue;
    if (hasPrimaryCamera && primaryCameraRaw != null) {
      primaryCameraValue = CameraSwitchControlIconState.fromJson(primaryCameraRaw);
    } else if (hasPrimaryCamera && primaryCameraRaw == null) {
      throw FormatException('CameraIcon.primaryCamera: null is not allowed');
    }
    final hasSecondaryCamera = raw.containsKey('secondaryCamera');
    final secondaryCameraRaw = raw['secondaryCamera'];
    CameraSwitchControlIconState? secondaryCameraValue;
    if (hasSecondaryCamera && secondaryCameraRaw != null) {
      secondaryCameraValue = CameraSwitchControlIconState.fromJson(secondaryCameraRaw);
    } else if (hasSecondaryCamera && secondaryCameraRaw == null) {
      throw FormatException('CameraIcon.secondaryCamera: null is not allowed');
    }
    return CameraIcon(
      primaryCamera: primaryCameraValue,
      secondaryCamera: secondaryCameraValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (primaryCamera != null) {
      map['primaryCamera'] = primaryCamera!.toJson();
    }
    if (secondaryCamera != null) {
      map['secondaryCamera'] = secondaryCamera!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `CameraIcon` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildCameraIcon({
  Object? primaryCamera,
  Object? secondaryCamera,
}) {
  final map = <String, Object?>{};
  if (primaryCamera != null) {
    map['primaryCamera'] = primaryCamera;
  }
  if (secondaryCamera != null) {
    map['secondaryCamera'] = secondaryCamera;
  }
  return map;
}

///
class CameraSwitchControlIconState {
  final Object? default$;
  final Object? pressed;

  const CameraSwitchControlIconState({
    this.default$,
    this.pressed,
  });

  factory CameraSwitchControlIconState.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('CameraSwitchControlIconState: expected a Map');
    }
    const allowedKeys = <String>{
      'default',
      'pressed',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("CameraSwitchControlIconState: unknown property '$key'");
      }
    }
    final hasDefault$ = raw.containsKey('default');
    final default$Raw = raw['default'];
    Object? default$Value;
    if (hasDefault$ && default$Raw != null) {
      default$Value = default$Raw;
    } else if (hasDefault$ && default$Raw == null) {
      throw FormatException('CameraSwitchControlIconState.default: null is not allowed');
    }
    final hasPressed = raw.containsKey('pressed');
    final pressedRaw = raw['pressed'];
    Object? pressedValue;
    if (hasPressed && pressedRaw != null) {
      pressedValue = pressedRaw;
    } else if (hasPressed && pressedRaw == null) {
      throw FormatException('CameraSwitchControlIconState.pressed: null is not allowed');
    }
    return CameraSwitchControlIconState(
      default$: default$Value,
      pressed: pressedValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (default$ != null) {
      map['default'] = default$;
    }
    if (pressed != null) {
      map['pressed'] = pressed;
    }
    return map;
  }
}

/// Typed builder for the `CameraSwitchControlIconState` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildCameraSwitchControlIconState({
  Object? default$,
  Object? pressed,
}) {
  final map = <String, Object?>{};
  if (default$ != null) {
    map['default'] = default$;
  }
  if (pressed != null) {
    map['pressed'] = pressed;
  }
  return map;
}

/// A control that allows the user to switch between zoom levels.
class ZoomSwitchControl implements Control {
  final String type;
  final Anchor? anchor;
  final UIPoint? offset;
  final String? orientation;
  final bool? isAlwaysExpanded;
  final bool? isExpanded;
  final String? accessibilityLabel;
  final String? accessibilityHint;
  @Deprecated('since 8.4')
  final String? contentDescriptionWhenZoomOff;
  @Deprecated('since 8.4')
  final String? contentDescriptionWhenZoomOn;
  @Deprecated('since 8.4')
  final ZoomIcon? icon;

  const ZoomSwitchControl({
    required this.type,
    this.anchor,
    this.offset,
    this.orientation,
    this.isAlwaysExpanded,
    this.isExpanded,
    this.accessibilityLabel,
    this.accessibilityHint,
    this.contentDescriptionWhenZoomOff,
    this.contentDescriptionWhenZoomOn,
    this.icon,
  });

  factory ZoomSwitchControl.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('ZoomSwitchControl: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'anchor',
      'offset',
      'orientation',
      'isAlwaysExpanded',
      'isExpanded',
      'accessibilityLabel',
      'accessibilityHint',
      'contentDescriptionWhenZoomOff',
      'contentDescriptionWhenZoomOn',
      'icon',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("ZoomSwitchControl: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("ZoomSwitchControl.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['zoom'].contains(typeRaw)) {
        throw FormatException("ZoomSwitchControl.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('ZoomSwitchControl.type: null is not allowed');
    }
    final hasAnchor = raw.containsKey('anchor');
    final anchorRaw = raw['anchor'];
    Anchor? anchorValue;
    if (hasAnchor && anchorRaw != null) {
      anchorValue = (anchorRaw is! String
          ? (throw FormatException('ZoomSwitchControl.anchor: expected a String for Anchor'))
          : Anchor.fromJSON(anchorRaw));
    } else if (hasAnchor && anchorRaw == null) {
      throw FormatException('ZoomSwitchControl.anchor: null is not allowed');
    }
    final hasOffset = raw.containsKey('offset');
    final offsetRaw = raw['offset'];
    UIPoint? offsetValue;
    if (hasOffset && offsetRaw != null) {
      offsetValue = UIPoint.fromJson(offsetRaw);
    } else if (hasOffset && offsetRaw == null) {
      throw FormatException('ZoomSwitchControl.offset: null is not allowed');
    }
    final hasOrientation = raw.containsKey('orientation');
    final orientationRaw = raw['orientation'];
    String? orientationValue;
    if (hasOrientation && orientationRaw != null) {
      if (orientationRaw is! String || !const <String>['default', 'horizontal', 'vertical'].contains(orientationRaw)) {
        throw FormatException("ZoomSwitchControl.orientation: unknown enum value '$orientationRaw'");
      }
      orientationValue = orientationRaw;
    } else if (hasOrientation && orientationRaw == null) {
      throw FormatException('ZoomSwitchControl.orientation: null is not allowed');
    }
    final hasIsAlwaysExpanded = raw.containsKey('isAlwaysExpanded');
    final isAlwaysExpandedRaw = raw['isAlwaysExpanded'];
    bool? isAlwaysExpandedValue;
    if (hasIsAlwaysExpanded && isAlwaysExpandedRaw != null) {
      if (isAlwaysExpandedRaw is! bool) {
        throw FormatException('ZoomSwitchControl.isAlwaysExpanded: expected a bool');
      }
      isAlwaysExpandedValue = isAlwaysExpandedRaw;
    } else if (hasIsAlwaysExpanded && isAlwaysExpandedRaw == null) {
      throw FormatException('ZoomSwitchControl.isAlwaysExpanded: null is not allowed');
    }
    final hasIsExpanded = raw.containsKey('isExpanded');
    final isExpandedRaw = raw['isExpanded'];
    bool? isExpandedValue;
    if (hasIsExpanded && isExpandedRaw != null) {
      if (isExpandedRaw is! bool) {
        throw FormatException('ZoomSwitchControl.isExpanded: expected a bool');
      }
      isExpandedValue = isExpandedRaw;
    } else if (hasIsExpanded && isExpandedRaw == null) {
      throw FormatException('ZoomSwitchControl.isExpanded: null is not allowed');
    }
    final hasAccessibilityLabel = raw.containsKey('accessibilityLabel');
    final accessibilityLabelRaw = raw['accessibilityLabel'];
    String? accessibilityLabelValue;
    if (hasAccessibilityLabel && accessibilityLabelRaw != null) {
      if (accessibilityLabelRaw is! String) {
        throw FormatException('ZoomSwitchControl.accessibilityLabel: expected a String');
      }
      accessibilityLabelValue = accessibilityLabelRaw;
    } else if (hasAccessibilityLabel && accessibilityLabelRaw == null) {
      throw FormatException('ZoomSwitchControl.accessibilityLabel: null is not allowed');
    }
    final hasAccessibilityHint = raw.containsKey('accessibilityHint');
    final accessibilityHintRaw = raw['accessibilityHint'];
    String? accessibilityHintValue;
    if (hasAccessibilityHint && accessibilityHintRaw != null) {
      if (accessibilityHintRaw is! String) {
        throw FormatException('ZoomSwitchControl.accessibilityHint: expected a String');
      }
      accessibilityHintValue = accessibilityHintRaw;
    } else if (hasAccessibilityHint && accessibilityHintRaw == null) {
      throw FormatException('ZoomSwitchControl.accessibilityHint: null is not allowed');
    }
    final hasContentDescriptionWhenZoomOff = raw.containsKey('contentDescriptionWhenZoomOff');
    final contentDescriptionWhenZoomOffRaw = raw['contentDescriptionWhenZoomOff'];
    String? contentDescriptionWhenZoomOffValue;
    if (hasContentDescriptionWhenZoomOff && contentDescriptionWhenZoomOffRaw != null) {
      if (contentDescriptionWhenZoomOffRaw is! String) {
        throw FormatException('ZoomSwitchControl.contentDescriptionWhenZoomOff: expected a String');
      }
      contentDescriptionWhenZoomOffValue = contentDescriptionWhenZoomOffRaw;
    } else if (hasContentDescriptionWhenZoomOff && contentDescriptionWhenZoomOffRaw == null) {
      throw FormatException('ZoomSwitchControl.contentDescriptionWhenZoomOff: null is not allowed');
    }
    final hasContentDescriptionWhenZoomOn = raw.containsKey('contentDescriptionWhenZoomOn');
    final contentDescriptionWhenZoomOnRaw = raw['contentDescriptionWhenZoomOn'];
    String? contentDescriptionWhenZoomOnValue;
    if (hasContentDescriptionWhenZoomOn && contentDescriptionWhenZoomOnRaw != null) {
      if (contentDescriptionWhenZoomOnRaw is! String) {
        throw FormatException('ZoomSwitchControl.contentDescriptionWhenZoomOn: expected a String');
      }
      contentDescriptionWhenZoomOnValue = contentDescriptionWhenZoomOnRaw;
    } else if (hasContentDescriptionWhenZoomOn && contentDescriptionWhenZoomOnRaw == null) {
      throw FormatException('ZoomSwitchControl.contentDescriptionWhenZoomOn: null is not allowed');
    }
    final hasIcon = raw.containsKey('icon');
    final iconRaw = raw['icon'];
    ZoomIcon? iconValue;
    if (hasIcon && iconRaw != null) {
      iconValue = ZoomIcon.fromJson(iconRaw);
    } else if (hasIcon && iconRaw == null) {
      throw FormatException('ZoomSwitchControl.icon: null is not allowed');
    }
    return ZoomSwitchControl(
      type: typeValue!,
      anchor: anchorValue,
      offset: offsetValue,
      orientation: orientationValue,
      isAlwaysExpanded: isAlwaysExpandedValue,
      isExpanded: isExpandedValue,
      accessibilityLabel: accessibilityLabelValue,
      accessibilityHint: accessibilityHintValue,
      contentDescriptionWhenZoomOff: contentDescriptionWhenZoomOffValue,
      contentDescriptionWhenZoomOn: contentDescriptionWhenZoomOnValue,
      icon: iconValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (anchor != null) {
      map['anchor'] = anchor!.toJson();
    }
    if (offset != null) {
      map['offset'] = offset!.toJson();
    }
    if (orientation != null) {
      map['orientation'] = orientation;
    }
    if (isAlwaysExpanded != null) {
      map['isAlwaysExpanded'] = isAlwaysExpanded;
    }
    if (isExpanded != null) {
      map['isExpanded'] = isExpanded;
    }
    if (accessibilityLabel != null) {
      map['accessibilityLabel'] = accessibilityLabel;
    }
    if (accessibilityHint != null) {
      map['accessibilityHint'] = accessibilityHint;
    }
    if (contentDescriptionWhenZoomOff != null) {
      map['contentDescriptionWhenZoomOff'] = contentDescriptionWhenZoomOff;
    }
    if (contentDescriptionWhenZoomOn != null) {
      map['contentDescriptionWhenZoomOn'] = contentDescriptionWhenZoomOn;
    }
    if (icon != null) {
      map['icon'] = icon!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `ZoomSwitchControl` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildZoomSwitchControl({
  required String type,
  Object? anchor,
  Object? offset,
  String? orientation,
  bool? isAlwaysExpanded,
  bool? isExpanded,
  String? accessibilityLabel,
  String? accessibilityHint,
  String? contentDescriptionWhenZoomOff,
  String? contentDescriptionWhenZoomOn,
  Object? icon,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (anchor != null) {
    map['anchor'] = anchor;
  }
  if (offset != null) {
    map['offset'] = offset;
  }
  if (orientation != null) {
    map['orientation'] = orientation;
  }
  if (isAlwaysExpanded != null) {
    map['isAlwaysExpanded'] = isAlwaysExpanded;
  }
  if (isExpanded != null) {
    map['isExpanded'] = isExpanded;
  }
  if (accessibilityLabel != null) {
    map['accessibilityLabel'] = accessibilityLabel;
  }
  if (accessibilityHint != null) {
    map['accessibilityHint'] = accessibilityHint;
  }
  if (contentDescriptionWhenZoomOff != null) {
    map['contentDescriptionWhenZoomOff'] = contentDescriptionWhenZoomOff;
  }
  if (contentDescriptionWhenZoomOn != null) {
    map['contentDescriptionWhenZoomOn'] = contentDescriptionWhenZoomOn;
  }
  if (icon != null) {
    map['icon'] = icon;
  }
  return map;
}

///
class ZoomIcon {
  final ZoomSwitchControlIconState? zoomedOut;
  final ZoomSwitchControlIconState? zoomedIn;

  const ZoomIcon({
    this.zoomedOut,
    this.zoomedIn,
  });

  factory ZoomIcon.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('ZoomIcon: expected a Map');
    }
    const allowedKeys = <String>{
      'zoomedOut',
      'zoomedIn',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("ZoomIcon: unknown property '$key'");
      }
    }
    final hasZoomedOut = raw.containsKey('zoomedOut');
    final zoomedOutRaw = raw['zoomedOut'];
    ZoomSwitchControlIconState? zoomedOutValue;
    if (hasZoomedOut && zoomedOutRaw != null) {
      zoomedOutValue = ZoomSwitchControlIconState.fromJson(zoomedOutRaw);
    } else if (hasZoomedOut && zoomedOutRaw == null) {
      throw FormatException('ZoomIcon.zoomedOut: null is not allowed');
    }
    final hasZoomedIn = raw.containsKey('zoomedIn');
    final zoomedInRaw = raw['zoomedIn'];
    ZoomSwitchControlIconState? zoomedInValue;
    if (hasZoomedIn && zoomedInRaw != null) {
      zoomedInValue = ZoomSwitchControlIconState.fromJson(zoomedInRaw);
    } else if (hasZoomedIn && zoomedInRaw == null) {
      throw FormatException('ZoomIcon.zoomedIn: null is not allowed');
    }
    return ZoomIcon(
      zoomedOut: zoomedOutValue,
      zoomedIn: zoomedInValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (zoomedOut != null) {
      map['zoomedOut'] = zoomedOut!.toJson();
    }
    if (zoomedIn != null) {
      map['zoomedIn'] = zoomedIn!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `ZoomIcon` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildZoomIcon({
  Object? zoomedOut,
  Object? zoomedIn,
}) {
  final map = <String, Object?>{};
  if (zoomedOut != null) {
    map['zoomedOut'] = zoomedOut;
  }
  if (zoomedIn != null) {
    map['zoomedIn'] = zoomedIn;
  }
  return map;
}

///
class ZoomSwitchControlIconState {
  final Object? default$;
  final Object? pressed;

  const ZoomSwitchControlIconState({
    this.default$,
    this.pressed,
  });

  factory ZoomSwitchControlIconState.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('ZoomSwitchControlIconState: expected a Map');
    }
    const allowedKeys = <String>{
      'default',
      'pressed',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("ZoomSwitchControlIconState: unknown property '$key'");
      }
    }
    final hasDefault$ = raw.containsKey('default');
    final default$Raw = raw['default'];
    Object? default$Value;
    if (hasDefault$ && default$Raw != null) {
      default$Value = default$Raw;
    } else if (hasDefault$ && default$Raw == null) {
      throw FormatException('ZoomSwitchControlIconState.default: null is not allowed');
    }
    final hasPressed = raw.containsKey('pressed');
    final pressedRaw = raw['pressed'];
    Object? pressedValue;
    if (hasPressed && pressedRaw != null) {
      pressedValue = pressedRaw;
    } else if (hasPressed && pressedRaw == null) {
      throw FormatException('ZoomSwitchControlIconState.pressed: null is not allowed');
    }
    return ZoomSwitchControlIconState(
      default$: default$Value,
      pressed: pressedValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (default$ != null) {
      map['default'] = default$;
    }
    if (pressed != null) {
      map['pressed'] = pressed;
    }
    return map;
  }
}

/// Typed builder for the `ZoomSwitchControlIconState` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildZoomSwitchControlIconState({
  Object? default$,
  Object? pressed,
}) {
  final map = <String, Object?>{};
  if (default$ != null) {
    map['default'] = default$;
  }
  if (pressed != null) {
    map['pressed'] = pressed;
  }
  return map;
}

/// A control that toggles macro (close-range) focus mode.
class MacroModeControl implements Control {
  final String type;
  final Anchor? anchor;
  final UIPoint? offset;
  final MacroIcon? icon;

  const MacroModeControl({
    required this.type,
    this.anchor,
    this.offset,
    this.icon,
  });

  factory MacroModeControl.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('MacroModeControl: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'anchor',
      'offset',
      'icon',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("MacroModeControl: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("MacroModeControl.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['macro'].contains(typeRaw)) {
        throw FormatException("MacroModeControl.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('MacroModeControl.type: null is not allowed');
    }
    final hasAnchor = raw.containsKey('anchor');
    final anchorRaw = raw['anchor'];
    Anchor? anchorValue;
    if (hasAnchor && anchorRaw != null) {
      anchorValue = (anchorRaw is! String
          ? (throw FormatException('MacroModeControl.anchor: expected a String for Anchor'))
          : Anchor.fromJSON(anchorRaw));
    } else if (hasAnchor && anchorRaw == null) {
      throw FormatException('MacroModeControl.anchor: null is not allowed');
    }
    final hasOffset = raw.containsKey('offset');
    final offsetRaw = raw['offset'];
    UIPoint? offsetValue;
    if (hasOffset && offsetRaw != null) {
      offsetValue = UIPoint.fromJson(offsetRaw);
    } else if (hasOffset && offsetRaw == null) {
      throw FormatException('MacroModeControl.offset: null is not allowed');
    }
    final hasIcon = raw.containsKey('icon');
    final iconRaw = raw['icon'];
    MacroIcon? iconValue;
    if (hasIcon && iconRaw != null) {
      iconValue = MacroIcon.fromJson(iconRaw);
    } else if (hasIcon && iconRaw == null) {
      throw FormatException('MacroModeControl.icon: null is not allowed');
    }
    return MacroModeControl(
      type: typeValue!,
      anchor: anchorValue,
      offset: offsetValue,
      icon: iconValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (anchor != null) {
      map['anchor'] = anchor!.toJson();
    }
    if (offset != null) {
      map['offset'] = offset!.toJson();
    }
    if (icon != null) {
      map['icon'] = icon!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `MacroModeControl` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildMacroModeControl({
  required String type,
  Object? anchor,
  Object? offset,
  Object? icon,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (anchor != null) {
    map['anchor'] = anchor;
  }
  if (offset != null) {
    map['offset'] = offset;
  }
  if (icon != null) {
    map['icon'] = icon;
  }
  return map;
}

///
class MacroIcon {
  final MacroModeControlIconState? auto;
  final MacroModeControlIconState? on$;
  final MacroModeControlIconState? off;

  const MacroIcon({
    this.auto,
    this.on$,
    this.off,
  });

  factory MacroIcon.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('MacroIcon: expected a Map');
    }
    const allowedKeys = <String>{
      'auto',
      'on',
      'off',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("MacroIcon: unknown property '$key'");
      }
    }
    final hasAuto = raw.containsKey('auto');
    final autoRaw = raw['auto'];
    MacroModeControlIconState? autoValue;
    if (hasAuto && autoRaw != null) {
      autoValue = parseMacroModeControlIconState(autoRaw);
    } else if (hasAuto && autoRaw == null) {
      throw FormatException('MacroIcon.auto: null is not allowed');
    }
    final hasOn$ = raw.containsKey('on');
    final on$Raw = raw['on'];
    MacroModeControlIconState? on$Value;
    if (hasOn$ && on$Raw != null) {
      on$Value = parseMacroModeControlIconState(on$Raw);
    } else if (hasOn$ && on$Raw == null) {
      throw FormatException('MacroIcon.on: null is not allowed');
    }
    final hasOff = raw.containsKey('off');
    final offRaw = raw['off'];
    MacroModeControlIconState? offValue;
    if (hasOff && offRaw != null) {
      offValue = parseMacroModeControlIconState(offRaw);
    } else if (hasOff && offRaw == null) {
      throw FormatException('MacroIcon.off: null is not allowed');
    }
    return MacroIcon(
      auto: autoValue,
      on$: on$Value,
      off: offValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (auto != null) {
      map['auto'] = auto;
    }
    if (on$ != null) {
      map['on'] = on$;
    }
    if (off != null) {
      map['off'] = off;
    }
    return map;
  }
}

/// Typed builder for the `MacroIcon` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildMacroIcon({
  MacroModeControlIconState? auto,
  MacroModeControlIconState? on$,
  MacroModeControlIconState? off,
}) {
  final map = <String, Object?>{};
  if (auto != null) {
    map['auto'] = auto;
  }
  if (on$ != null) {
    map['on'] = on$;
  }
  if (off != null) {
    map['off'] = off;
  }
  return map;
}

///
typedef MacroModeControlIconState = Object;

MacroModeControlIconState parseMacroModeControlIconState(Object? raw) {
  if (raw == null) {
    throw FormatException('MacroModeControlIconState: expected a non-null value');
  }
  return raw;
}

/// A control that groups other controls in a horizontal or vertical line.
class LinearControlGroup implements Control {
  final String type;
  final Anchor? anchor;
  final UIPoint? offset;
  final String? orientation;
  final UIValue? spacing;
  final List<Object?>? childControls;

  const LinearControlGroup({
    required this.type,
    this.anchor,
    this.offset,
    this.orientation,
    this.spacing,
    this.childControls,
  });

  factory LinearControlGroup.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LinearControlGroup: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'anchor',
      'offset',
      'orientation',
      'spacing',
      'childControls',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("LinearControlGroup: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("LinearControlGroup.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['linearGroup'].contains(typeRaw)) {
        throw FormatException("LinearControlGroup.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('LinearControlGroup.type: null is not allowed');
    }
    final hasAnchor = raw.containsKey('anchor');
    final anchorRaw = raw['anchor'];
    Anchor? anchorValue;
    if (hasAnchor && anchorRaw != null) {
      anchorValue = (anchorRaw is! String
          ? (throw FormatException('LinearControlGroup.anchor: expected a String for Anchor'))
          : Anchor.fromJSON(anchorRaw));
    } else if (hasAnchor && anchorRaw == null) {
      throw FormatException('LinearControlGroup.anchor: null is not allowed');
    }
    final hasOffset = raw.containsKey('offset');
    final offsetRaw = raw['offset'];
    UIPoint? offsetValue;
    if (hasOffset && offsetRaw != null) {
      offsetValue = UIPoint.fromJson(offsetRaw);
    } else if (hasOffset && offsetRaw == null) {
      throw FormatException('LinearControlGroup.offset: null is not allowed');
    }
    final hasOrientation = raw.containsKey('orientation');
    final orientationRaw = raw['orientation'];
    String? orientationValue;
    if (hasOrientation && orientationRaw != null) {
      if (orientationRaw is! String || !const <String>['vertical', 'horizontal'].contains(orientationRaw)) {
        throw FormatException("LinearControlGroup.orientation: unknown enum value '$orientationRaw'");
      }
      orientationValue = orientationRaw;
    } else if (hasOrientation && orientationRaw == null) {
      throw FormatException('LinearControlGroup.orientation: null is not allowed');
    }
    final hasSpacing = raw.containsKey('spacing');
    final spacingRaw = raw['spacing'];
    UIValue? spacingValue;
    if (hasSpacing && spacingRaw != null) {
      spacingValue = UIValue.fromJson(spacingRaw);
    } else if (hasSpacing && spacingRaw == null) {
      throw FormatException('LinearControlGroup.spacing: null is not allowed');
    }
    final hasChildControls = raw.containsKey('childControls');
    final childControlsRaw = raw['childControls'];
    List<Object?>? childControlsValue;
    if (hasChildControls && childControlsRaw != null) {
      if (childControlsRaw is! List) {
        throw FormatException('LinearControlGroup.childControls: expected a List');
      }
      childControlsValue = childControlsRaw.cast<Object?>();
    } else if (hasChildControls && childControlsRaw == null) {
      throw FormatException('LinearControlGroup.childControls: null is not allowed');
    }
    return LinearControlGroup(
      type: typeValue!,
      anchor: anchorValue,
      offset: offsetValue,
      orientation: orientationValue,
      spacing: spacingValue,
      childControls: childControlsValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (anchor != null) {
      map['anchor'] = anchor!.toJson();
    }
    if (offset != null) {
      map['offset'] = offset!.toJson();
    }
    if (orientation != null) {
      map['orientation'] = orientation;
    }
    if (spacing != null) {
      map['spacing'] = spacing!.toJson();
    }
    if (childControls != null) {
      map['childControls'] = childControls;
    }
    return map;
  }
}

/// Typed builder for the `LinearControlGroup` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildLinearControlGroup({
  required String type,
  Object? anchor,
  Object? offset,
  String? orientation,
  Object? spacing,
  List<Object?>? childControls,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (anchor != null) {
    map['anchor'] = anchor;
  }
  if (offset != null) {
    map['offset'] = offset;
  }
  if (orientation != null) {
    map['orientation'] = orientation;
  }
  if (spacing != null) {
    map['spacing'] = spacing;
  }
  if (childControls != null) {
    map['childControls'] = childControls;
  }
  return map;
}

/// A focus gesture that triggers single-shot autofocus on tap.
class FocusGesture {
  final String type;
  final bool? showUIIndicator;

  const FocusGesture({
    required this.type,
    this.showUIIndicator,
  });

  factory FocusGesture.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('FocusGesture: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'showUIIndicator',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("FocusGesture: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("FocusGesture.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['tapToFocus'].contains(typeRaw)) {
        throw FormatException("FocusGesture.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('FocusGesture.type: null is not allowed');
    }
    final hasShowUIIndicator = raw.containsKey('showUIIndicator');
    final showUIIndicatorRaw = raw['showUIIndicator'];
    bool? showUIIndicatorValue;
    if (hasShowUIIndicator && showUIIndicatorRaw != null) {
      if (showUIIndicatorRaw is! bool) {
        throw FormatException('FocusGesture.showUIIndicator: expected a bool');
      }
      showUIIndicatorValue = showUIIndicatorRaw;
    } else if (hasShowUIIndicator && showUIIndicatorRaw == null) {
      throw FormatException('FocusGesture.showUIIndicator: null is not allowed');
    }
    return FocusGesture(
      type: typeValue!,
      showUIIndicator: showUIIndicatorValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (showUIIndicator != null) {
      map['showUIIndicator'] = showUIIndicator;
    }
    return map;
  }
}

/// Typed builder for the `FocusGesture` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildFocusGesture({
  required String type,
  bool? showUIIndicator,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (showUIIndicator != null) {
    map['showUIIndicator'] = showUIIndicator;
  }
  return map;
}

/// A zoom gesture for the data capture view.
class ZoomGesture {
  final String type;

  const ZoomGesture({
    required this.type,
  });

  factory ZoomGesture.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('ZoomGesture: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("ZoomGesture: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("ZoomGesture.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['swipeToZoom', 'pinchToZoom'].contains(typeRaw)) {
        throw FormatException("ZoomGesture.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('ZoomGesture.type: null is not allowed');
    }
    return ZoomGesture(
      type: typeValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    return map;
  }
}

/// Typed builder for the `ZoomGesture` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildZoomGesture({
  required String type,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  return map;
}

/// Notifies the listener that the frame source's state changed.
class FrameSourceListenerOnStateChanged {
  final String state;
  final String? cameraPosition;
  final String event;

  const FrameSourceListenerOnStateChanged({
    required this.state,
    this.cameraPosition,
    required this.event,
  });

  factory FrameSourceListenerOnStateChanged.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('FrameSourceListenerOnStateChanged: expected a Map');
    }
    const allowedKeys = <String>{
      'state',
      'cameraPosition',
      'event',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("FrameSourceListenerOnStateChanged: unknown property '$key'");
      }
    }
    final hasState = raw.containsKey('state');
    if (!hasState) {
      throw FormatException("FrameSourceListenerOnStateChanged.state: missing required property");
    }
    final stateRaw = raw['state'];
    String? stateValue;
    if (hasState && stateRaw != null) {
      if (stateRaw is! String ||
          !const <String>[
            'on',
            'off',
            'starting',
            'stopping',
            'standby',
            'bootingUp',
            'wakingUp',
            'goingToSleep',
            'shuttingDown'
          ].contains(stateRaw)) {
        throw FormatException("FrameSourceListenerOnStateChanged.state: unknown enum value '$stateRaw'");
      }
      stateValue = stateRaw;
    } else if (hasState && stateRaw == null) {
      throw FormatException('FrameSourceListenerOnStateChanged.state: null is not allowed');
    }
    final hasCameraPosition = raw.containsKey('cameraPosition');
    final cameraPositionRaw = raw['cameraPosition'];
    String? cameraPositionValue;
    if (hasCameraPosition && cameraPositionRaw != null) {
      if (cameraPositionRaw is! String ||
          !const <String>['worldFacing', 'userFacing', 'unspecified'].contains(cameraPositionRaw)) {
        throw FormatException(
            "FrameSourceListenerOnStateChanged.cameraPosition: unknown enum value '$cameraPositionRaw'");
      }
      cameraPositionValue = cameraPositionRaw;
    }
    final hasEvent = raw.containsKey('event');
    if (!hasEvent) {
      throw FormatException("FrameSourceListenerOnStateChanged.event: missing required property");
    }
    final eventRaw = raw['event'];
    String? eventValue;
    if (hasEvent && eventRaw != null) {
      if (eventRaw is! String || !const <String>['FrameSourceListener.onStateChanged'].contains(eventRaw)) {
        throw FormatException("FrameSourceListenerOnStateChanged.event: unknown enum value '$eventRaw'");
      }
      eventValue = eventRaw;
    } else if (hasEvent && eventRaw == null) {
      throw FormatException('FrameSourceListenerOnStateChanged.event: null is not allowed');
    }
    return FrameSourceListenerOnStateChanged(
      state: stateValue!,
      cameraPosition: cameraPositionValue,
      event: eventValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['state'] = state;
    if (cameraPosition != null) {
      map['cameraPosition'] = cameraPosition;
    }
    map['event'] = event;
    return map;
  }
}

/// Typed builder for the `FrameSourceListenerOnStateChanged` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildFrameSourceListenerOnStateChanged({
  required String state,
  Object? cameraPosition = _unset,
  required String event,
}) {
  final map = <String, Object?>{};
  map['state'] = state;
  if (!identical(cameraPosition, _unset)) {
    map['cameraPosition'] = cameraPosition;
  }
  map['event'] = event;
  return map;
}

/// Notifies the listener that the torch state changed.
class TorchListenerOnTorchStateChanged {
  final String state;
  final String event;

  const TorchListenerOnTorchStateChanged({
    required this.state,
    required this.event,
  });

  factory TorchListenerOnTorchStateChanged.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('TorchListenerOnTorchStateChanged: expected a Map');
    }
    const allowedKeys = <String>{
      'state',
      'event',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("TorchListenerOnTorchStateChanged: unknown property '$key'");
      }
    }
    final hasState = raw.containsKey('state');
    if (!hasState) {
      throw FormatException("TorchListenerOnTorchStateChanged.state: missing required property");
    }
    final stateRaw = raw['state'];
    String? stateValue;
    if (hasState && stateRaw != null) {
      if (stateRaw is! String || !const <String>['on', 'off', 'auto'].contains(stateRaw)) {
        throw FormatException("TorchListenerOnTorchStateChanged.state: unknown enum value '$stateRaw'");
      }
      stateValue = stateRaw;
    } else if (hasState && stateRaw == null) {
      throw FormatException('TorchListenerOnTorchStateChanged.state: null is not allowed');
    }
    final hasEvent = raw.containsKey('event');
    if (!hasEvent) {
      throw FormatException("TorchListenerOnTorchStateChanged.event: missing required property");
    }
    final eventRaw = raw['event'];
    String? eventValue;
    if (hasEvent && eventRaw != null) {
      if (eventRaw is! String || !const <String>['TorchListener.onTorchStateChanged'].contains(eventRaw)) {
        throw FormatException("TorchListenerOnTorchStateChanged.event: unknown enum value '$eventRaw'");
      }
      eventValue = eventRaw;
    } else if (hasEvent && eventRaw == null) {
      throw FormatException('TorchListenerOnTorchStateChanged.event: null is not allowed');
    }
    return TorchListenerOnTorchStateChanged(
      state: stateValue!,
      event: eventValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['state'] = state;
    map['event'] = event;
    return map;
  }
}

/// Typed builder for the `TorchListenerOnTorchStateChanged` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildTorchListenerOnTorchStateChanged({
  required String state,
  required String event,
}) {
  final map = <String, Object?>{};
  map['state'] = state;
  map['event'] = event;
  return map;
}

/// Notifies the listener that the camera's zoom level changed.
class ZoomListenerOnZoomLevelChanged {
  final double oldZoomLevel;
  final double newZoomLevel;
  final String event;

  const ZoomListenerOnZoomLevelChanged({
    required this.oldZoomLevel,
    required this.newZoomLevel,
    required this.event,
  });

  factory ZoomListenerOnZoomLevelChanged.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('ZoomListenerOnZoomLevelChanged: expected a Map');
    }
    const allowedKeys = <String>{
      'oldZoomLevel',
      'newZoomLevel',
      'event',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("ZoomListenerOnZoomLevelChanged: unknown property '$key'");
      }
    }
    final hasOldZoomLevel = raw.containsKey('oldZoomLevel');
    if (!hasOldZoomLevel) {
      throw FormatException("ZoomListenerOnZoomLevelChanged.oldZoomLevel: missing required property");
    }
    final oldZoomLevelRaw = raw['oldZoomLevel'];
    double? oldZoomLevelValue;
    if (hasOldZoomLevel && oldZoomLevelRaw != null) {
      if (oldZoomLevelRaw is! num) {
        throw FormatException('ZoomListenerOnZoomLevelChanged.oldZoomLevel: expected a number');
      }
      oldZoomLevelValue = oldZoomLevelRaw.toDouble();
    } else if (hasOldZoomLevel && oldZoomLevelRaw == null) {
      throw FormatException('ZoomListenerOnZoomLevelChanged.oldZoomLevel: null is not allowed');
    }
    final hasNewZoomLevel = raw.containsKey('newZoomLevel');
    if (!hasNewZoomLevel) {
      throw FormatException("ZoomListenerOnZoomLevelChanged.newZoomLevel: missing required property");
    }
    final newZoomLevelRaw = raw['newZoomLevel'];
    double? newZoomLevelValue;
    if (hasNewZoomLevel && newZoomLevelRaw != null) {
      if (newZoomLevelRaw is! num) {
        throw FormatException('ZoomListenerOnZoomLevelChanged.newZoomLevel: expected a number');
      }
      newZoomLevelValue = newZoomLevelRaw.toDouble();
    } else if (hasNewZoomLevel && newZoomLevelRaw == null) {
      throw FormatException('ZoomListenerOnZoomLevelChanged.newZoomLevel: null is not allowed');
    }
    final hasEvent = raw.containsKey('event');
    if (!hasEvent) {
      throw FormatException("ZoomListenerOnZoomLevelChanged.event: missing required property");
    }
    final eventRaw = raw['event'];
    String? eventValue;
    if (hasEvent && eventRaw != null) {
      if (eventRaw is! String || !const <String>['ZoomListener.onZoomLevelChanged'].contains(eventRaw)) {
        throw FormatException("ZoomListenerOnZoomLevelChanged.event: unknown enum value '$eventRaw'");
      }
      eventValue = eventRaw;
    } else if (hasEvent && eventRaw == null) {
      throw FormatException('ZoomListenerOnZoomLevelChanged.event: null is not allowed');
    }
    return ZoomListenerOnZoomLevelChanged(
      oldZoomLevel: oldZoomLevelValue!,
      newZoomLevel: newZoomLevelValue!,
      event: eventValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['oldZoomLevel'] = oldZoomLevel;
    map['newZoomLevel'] = newZoomLevel;
    map['event'] = event;
    return map;
  }
}

/// Typed builder for the `ZoomListenerOnZoomLevelChanged` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildZoomListenerOnZoomLevelChanged({
  required double oldZoomLevel,
  required double newZoomLevel,
  required String event,
}) {
  final map = <String, Object?>{};
  map['oldZoomLevel'] = oldZoomLevel;
  map['newZoomLevel'] = newZoomLevel;
  map['event'] = event;
  return map;
}

/// Notifies the listener that the macro mode changed. iOS-only: CoreModule deliberately no-ops this on Android (macro mode is not available there).
class MacroModeListenerOnMacroModeChanged {
  final String macroMode;
  final String event;

  const MacroModeListenerOnMacroModeChanged({
    required this.macroMode,
    required this.event,
  });

  factory MacroModeListenerOnMacroModeChanged.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('MacroModeListenerOnMacroModeChanged: expected a Map');
    }
    const allowedKeys = <String>{
      'macroMode',
      'event',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("MacroModeListenerOnMacroModeChanged: unknown property '$key'");
      }
    }
    final hasMacroMode = raw.containsKey('macroMode');
    if (!hasMacroMode) {
      throw FormatException("MacroModeListenerOnMacroModeChanged.macroMode: missing required property");
    }
    final macroModeRaw = raw['macroMode'];
    String? macroModeValue;
    if (hasMacroMode && macroModeRaw != null) {
      if (macroModeRaw is! String || !const <String>['on', 'off', 'auto'].contains(macroModeRaw)) {
        throw FormatException("MacroModeListenerOnMacroModeChanged.macroMode: unknown enum value '$macroModeRaw'");
      }
      macroModeValue = macroModeRaw;
    } else if (hasMacroMode && macroModeRaw == null) {
      throw FormatException('MacroModeListenerOnMacroModeChanged.macroMode: null is not allowed');
    }
    final hasEvent = raw.containsKey('event');
    if (!hasEvent) {
      throw FormatException("MacroModeListenerOnMacroModeChanged.event: missing required property");
    }
    final eventRaw = raw['event'];
    String? eventValue;
    if (hasEvent && eventRaw != null) {
      if (eventRaw is! String || !const <String>['MacroModeListener.onMacroModeChanged'].contains(eventRaw)) {
        throw FormatException("MacroModeListenerOnMacroModeChanged.event: unknown enum value '$eventRaw'");
      }
      eventValue = eventRaw;
    } else if (hasEvent && eventRaw == null) {
      throw FormatException('MacroModeListenerOnMacroModeChanged.event: null is not allowed');
    }
    return MacroModeListenerOnMacroModeChanged(
      macroMode: macroModeValue!,
      event: eventValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['macroMode'] = macroMode;
    map['event'] = event;
    return map;
  }
}

/// Typed builder for the `MacroModeListenerOnMacroModeChanged` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildMacroModeListenerOnMacroModeChanged({
  required String macroMode,
  required String event,
}) {
  final map = <String, Object?>{};
  map['macroMode'] = macroMode;
  map['event'] = event;
  return map;
}

/// Notifies the listener that the data capture context started observing.
class DataCaptureContextListenerOnObservationStarted {
  final String? licenseInfo;
  final String event;

  const DataCaptureContextListenerOnObservationStarted({
    this.licenseInfo,
    required this.event,
  });

  factory DataCaptureContextListenerOnObservationStarted.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('DataCaptureContextListenerOnObservationStarted: expected a Map');
    }
    const allowedKeys = <String>{
      'licenseInfo',
      'event',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("DataCaptureContextListenerOnObservationStarted: unknown property '$key'");
      }
    }
    final hasLicenseInfo = raw.containsKey('licenseInfo');
    if (!hasLicenseInfo) {
      throw FormatException("DataCaptureContextListenerOnObservationStarted.licenseInfo: missing required property");
    }
    final licenseInfoRaw = raw['licenseInfo'];
    String? licenseInfoValue;
    if (hasLicenseInfo && licenseInfoRaw != null) {
      if (licenseInfoRaw is! String) {
        throw FormatException('DataCaptureContextListenerOnObservationStarted.licenseInfo: expected a String');
      }
      licenseInfoValue = licenseInfoRaw;
    }
    final hasEvent = raw.containsKey('event');
    if (!hasEvent) {
      throw FormatException("DataCaptureContextListenerOnObservationStarted.event: missing required property");
    }
    final eventRaw = raw['event'];
    String? eventValue;
    if (hasEvent && eventRaw != null) {
      if (eventRaw is! String ||
          !const <String>['DataCaptureContextListener.onObservationStarted'].contains(eventRaw)) {
        throw FormatException("DataCaptureContextListenerOnObservationStarted.event: unknown enum value '$eventRaw'");
      }
      eventValue = eventRaw;
    } else if (hasEvent && eventRaw == null) {
      throw FormatException('DataCaptureContextListenerOnObservationStarted.event: null is not allowed');
    }
    return DataCaptureContextListenerOnObservationStarted(
      licenseInfo: licenseInfoValue,
      event: eventValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['licenseInfo'] = licenseInfo;
    map['event'] = event;
    return map;
  }
}

/// Typed builder for the `DataCaptureContextListenerOnObservationStarted` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildDataCaptureContextListenerOnObservationStarted({
  required String? licenseInfo,
  required String event,
}) {
  final map = <String, Object?>{};
  map['licenseInfo'] = licenseInfo;
  map['event'] = event;
  return map;
}

/// Notifies the listener that the data capture context's status changed. Also emitted synthetically by FrameworksDataCaptureContextListener.notifyCameraPermissionDenied() with a hand-built status JSON (code 1032).
class DataCaptureContextListenerOnStatusChanged {
  final String status;
  final String event;

  const DataCaptureContextListenerOnStatusChanged({
    required this.status,
    required this.event,
  });

  factory DataCaptureContextListenerOnStatusChanged.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('DataCaptureContextListenerOnStatusChanged: expected a Map');
    }
    const allowedKeys = <String>{
      'status',
      'event',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("DataCaptureContextListenerOnStatusChanged: unknown property '$key'");
      }
    }
    final hasStatus = raw.containsKey('status');
    if (!hasStatus) {
      throw FormatException("DataCaptureContextListenerOnStatusChanged.status: missing required property");
    }
    final statusRaw = raw['status'];
    String? statusValue;
    if (hasStatus && statusRaw != null) {
      if (statusRaw is! String) {
        throw FormatException('DataCaptureContextListenerOnStatusChanged.status: expected a String');
      }
      statusValue = statusRaw;
    } else if (hasStatus && statusRaw == null) {
      throw FormatException('DataCaptureContextListenerOnStatusChanged.status: null is not allowed');
    }
    final hasEvent = raw.containsKey('event');
    if (!hasEvent) {
      throw FormatException("DataCaptureContextListenerOnStatusChanged.event: missing required property");
    }
    final eventRaw = raw['event'];
    String? eventValue;
    if (hasEvent && eventRaw != null) {
      if (eventRaw is! String || !const <String>['DataCaptureContextListener.onStatusChanged'].contains(eventRaw)) {
        throw FormatException("DataCaptureContextListenerOnStatusChanged.event: unknown enum value '$eventRaw'");
      }
      eventValue = eventRaw;
    } else if (hasEvent && eventRaw == null) {
      throw FormatException('DataCaptureContextListenerOnStatusChanged.event: null is not allowed');
    }
    return DataCaptureContextListenerOnStatusChanged(
      status: statusValue!,
      event: eventValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['status'] = status;
    map['event'] = event;
    return map;
  }
}

/// Typed builder for the `DataCaptureContextListenerOnStatusChanged` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildDataCaptureContextListenerOnStatusChanged({
  required String status,
  required String event,
}) {
  final map = <String, Object?>{};
  map['status'] = status;
  map['event'] = event;
  return map;
}

/// Notifies the listener that the context's active frame source changed. Unlike FrameSourceListener.onStateChanged this reports the change itself rather than a state transition, so it is emitted even when neither camera changes state -- which is what makes a switch taken while the camera is off observable at all.
class DataCaptureContextListenerOnFrameSourceChanged {
  final String? cameraPosition;
  final String event;

  const DataCaptureContextListenerOnFrameSourceChanged({
    this.cameraPosition,
    required this.event,
  });

  factory DataCaptureContextListenerOnFrameSourceChanged.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('DataCaptureContextListenerOnFrameSourceChanged: expected a Map');
    }
    const allowedKeys = <String>{
      'cameraPosition',
      'event',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("DataCaptureContextListenerOnFrameSourceChanged: unknown property '$key'");
      }
    }
    final hasCameraPosition = raw.containsKey('cameraPosition');
    final cameraPositionRaw = raw['cameraPosition'];
    String? cameraPositionValue;
    if (hasCameraPosition && cameraPositionRaw != null) {
      if (cameraPositionRaw is! String ||
          !const <String>['worldFacing', 'userFacing', 'unspecified'].contains(cameraPositionRaw)) {
        throw FormatException(
            "DataCaptureContextListenerOnFrameSourceChanged.cameraPosition: unknown enum value '$cameraPositionRaw'");
      }
      cameraPositionValue = cameraPositionRaw;
    }
    final hasEvent = raw.containsKey('event');
    if (!hasEvent) {
      throw FormatException("DataCaptureContextListenerOnFrameSourceChanged.event: missing required property");
    }
    final eventRaw = raw['event'];
    String? eventValue;
    if (hasEvent && eventRaw != null) {
      if (eventRaw is! String ||
          !const <String>['DataCaptureContextListener.onFrameSourceChanged'].contains(eventRaw)) {
        throw FormatException("DataCaptureContextListenerOnFrameSourceChanged.event: unknown enum value '$eventRaw'");
      }
      eventValue = eventRaw;
    } else if (hasEvent && eventRaw == null) {
      throw FormatException('DataCaptureContextListenerOnFrameSourceChanged.event: null is not allowed');
    }
    return DataCaptureContextListenerOnFrameSourceChanged(
      cameraPosition: cameraPositionValue,
      event: eventValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (cameraPosition != null) {
      map['cameraPosition'] = cameraPosition;
    }
    map['event'] = event;
    return map;
  }
}

/// Typed builder for the `DataCaptureContextListenerOnFrameSourceChanged` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildDataCaptureContextListenerOnFrameSourceChanged({
  Object? cameraPosition = _unset,
  required String event,
}) {
  final map = <String, Object?>{};
  if (!identical(cameraPosition, _unset)) {
    map['cameraPosition'] = cameraPosition;
  }
  map['event'] = event;
  return map;
}

/// Notifies the listener that the data capture view's size changed.
class DataCaptureViewListenerOnSizeChanged {
  final int viewId;
  final DataCaptureViewListenerOnSizeChangedSize size;
  final String orientation;
  final String event;

  const DataCaptureViewListenerOnSizeChanged({
    required this.viewId,
    required this.size,
    required this.orientation,
    required this.event,
  });

  factory DataCaptureViewListenerOnSizeChanged.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('DataCaptureViewListenerOnSizeChanged: expected a Map');
    }
    const allowedKeys = <String>{
      'viewId',
      'size',
      'orientation',
      'event',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("DataCaptureViewListenerOnSizeChanged: unknown property '$key'");
      }
    }
    final hasViewId = raw.containsKey('viewId');
    if (!hasViewId) {
      throw FormatException("DataCaptureViewListenerOnSizeChanged.viewId: missing required property");
    }
    final viewIdRaw = raw['viewId'];
    int? viewIdValue;
    if (hasViewId && viewIdRaw != null) {
      if (viewIdRaw is! num) {
        throw FormatException('DataCaptureViewListenerOnSizeChanged.viewId: expected a number');
      }
      if (viewIdRaw != viewIdRaw.toInt()) {
        throw FormatException('DataCaptureViewListenerOnSizeChanged.viewId: expected an integer');
      }
      viewIdValue = viewIdRaw.toInt();
    } else if (hasViewId && viewIdRaw == null) {
      throw FormatException('DataCaptureViewListenerOnSizeChanged.viewId: null is not allowed');
    }
    final hasSize = raw.containsKey('size');
    if (!hasSize) {
      throw FormatException("DataCaptureViewListenerOnSizeChanged.size: missing required property");
    }
    final sizeRaw = raw['size'];
    DataCaptureViewListenerOnSizeChangedSize? sizeValue;
    if (hasSize && sizeRaw != null) {
      sizeValue = DataCaptureViewListenerOnSizeChangedSize.fromJson(sizeRaw);
    } else if (hasSize && sizeRaw == null) {
      throw FormatException('DataCaptureViewListenerOnSizeChanged.size: null is not allowed');
    }
    final hasOrientation = raw.containsKey('orientation');
    if (!hasOrientation) {
      throw FormatException("DataCaptureViewListenerOnSizeChanged.orientation: missing required property");
    }
    final orientationRaw = raw['orientation'];
    String? orientationValue;
    if (hasOrientation && orientationRaw != null) {
      if (orientationRaw is! String ||
          !const <String>['unknown', 'portrait', 'portraitUpsideDown', 'landscapeLeft', 'landscapeRight']
              .contains(orientationRaw)) {
        throw FormatException("DataCaptureViewListenerOnSizeChanged.orientation: unknown enum value '$orientationRaw'");
      }
      orientationValue = orientationRaw;
    } else if (hasOrientation && orientationRaw == null) {
      throw FormatException('DataCaptureViewListenerOnSizeChanged.orientation: null is not allowed');
    }
    final hasEvent = raw.containsKey('event');
    if (!hasEvent) {
      throw FormatException("DataCaptureViewListenerOnSizeChanged.event: missing required property");
    }
    final eventRaw = raw['event'];
    String? eventValue;
    if (hasEvent && eventRaw != null) {
      if (eventRaw is! String || !const <String>['DataCaptureViewListener.onSizeChanged'].contains(eventRaw)) {
        throw FormatException("DataCaptureViewListenerOnSizeChanged.event: unknown enum value '$eventRaw'");
      }
      eventValue = eventRaw;
    } else if (hasEvent && eventRaw == null) {
      throw FormatException('DataCaptureViewListenerOnSizeChanged.event: null is not allowed');
    }
    return DataCaptureViewListenerOnSizeChanged(
      viewId: viewIdValue!,
      size: sizeValue!,
      orientation: orientationValue!,
      event: eventValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['viewId'] = viewId;
    map['size'] = size.toJson();
    map['orientation'] = orientation;
    map['event'] = event;
    return map;
  }
}

/// Typed builder for the `DataCaptureViewListenerOnSizeChanged` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildDataCaptureViewListenerOnSizeChanged({
  required int viewId,
  required Object size,
  required String orientation,
  required String event,
}) {
  final map = <String, Object?>{};
  map['viewId'] = viewId;
  map['size'] = size;
  map['orientation'] = orientation;
  map['event'] = event;
  return map;
}

/// The new size of the view, in pixels. A genuine nested object, not a serialized JSON string: Android sends Int width/height, iOS sends CGFloat.
class DataCaptureViewListenerOnSizeChangedSize {
  final double width;
  final double height;

  const DataCaptureViewListenerOnSizeChangedSize({
    required this.width,
    required this.height,
  });

  factory DataCaptureViewListenerOnSizeChangedSize.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('DataCaptureViewListenerOnSizeChangedSize: expected a Map');
    }
    const allowedKeys = <String>{
      'width',
      'height',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("DataCaptureViewListenerOnSizeChangedSize: unknown property '$key'");
      }
    }
    final hasWidth = raw.containsKey('width');
    if (!hasWidth) {
      throw FormatException("DataCaptureViewListenerOnSizeChangedSize.width: missing required property");
    }
    final widthRaw = raw['width'];
    double? widthValue;
    if (hasWidth && widthRaw != null) {
      if (widthRaw is! num) {
        throw FormatException('DataCaptureViewListenerOnSizeChangedSize.width: expected a number');
      }
      widthValue = widthRaw.toDouble();
    } else if (hasWidth && widthRaw == null) {
      throw FormatException('DataCaptureViewListenerOnSizeChangedSize.width: null is not allowed');
    }
    final hasHeight = raw.containsKey('height');
    if (!hasHeight) {
      throw FormatException("DataCaptureViewListenerOnSizeChangedSize.height: missing required property");
    }
    final heightRaw = raw['height'];
    double? heightValue;
    if (hasHeight && heightRaw != null) {
      if (heightRaw is! num) {
        throw FormatException('DataCaptureViewListenerOnSizeChangedSize.height: expected a number');
      }
      heightValue = heightRaw.toDouble();
    } else if (hasHeight && heightRaw == null) {
      throw FormatException('DataCaptureViewListenerOnSizeChangedSize.height: null is not allowed');
    }
    return DataCaptureViewListenerOnSizeChangedSize(
      width: widthValue!,
      height: heightValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['width'] = width;
    map['height'] = height;
    return map;
  }
}

/// Typed builder for the `DataCaptureViewListenerOnSizeChangedSize` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildDataCaptureViewListenerOnSizeChangedSize({
  required double width,
  required double height,
}) {
  final map = <String, Object?>{};
  map['width'] = width;
  map['height'] = height;
  return map;
}

/// Notifies the listener that the focus gesture was performed.
class FocusGestureListenerOnFocusGesture {
  final int viewId;
  final String focusGesture;
  final String point;
  final String event;

  const FocusGestureListenerOnFocusGesture({
    required this.viewId,
    required this.focusGesture,
    required this.point,
    required this.event,
  });

  factory FocusGestureListenerOnFocusGesture.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('FocusGestureListenerOnFocusGesture: expected a Map');
    }
    const allowedKeys = <String>{
      'viewId',
      'focusGesture',
      'point',
      'event',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("FocusGestureListenerOnFocusGesture: unknown property '$key'");
      }
    }
    final hasViewId = raw.containsKey('viewId');
    if (!hasViewId) {
      throw FormatException("FocusGestureListenerOnFocusGesture.viewId: missing required property");
    }
    final viewIdRaw = raw['viewId'];
    int? viewIdValue;
    if (hasViewId && viewIdRaw != null) {
      if (viewIdRaw is! num) {
        throw FormatException('FocusGestureListenerOnFocusGesture.viewId: expected a number');
      }
      if (viewIdRaw != viewIdRaw.toInt()) {
        throw FormatException('FocusGestureListenerOnFocusGesture.viewId: expected an integer');
      }
      viewIdValue = viewIdRaw.toInt();
    } else if (hasViewId && viewIdRaw == null) {
      throw FormatException('FocusGestureListenerOnFocusGesture.viewId: null is not allowed');
    }
    final hasFocusGesture = raw.containsKey('focusGesture');
    if (!hasFocusGesture) {
      throw FormatException("FocusGestureListenerOnFocusGesture.focusGesture: missing required property");
    }
    final focusGestureRaw = raw['focusGesture'];
    String? focusGestureValue;
    if (hasFocusGesture && focusGestureRaw != null) {
      if (focusGestureRaw is! String) {
        throw FormatException('FocusGestureListenerOnFocusGesture.focusGesture: expected a String');
      }
      focusGestureValue = focusGestureRaw;
    } else if (hasFocusGesture && focusGestureRaw == null) {
      throw FormatException('FocusGestureListenerOnFocusGesture.focusGesture: null is not allowed');
    }
    final hasPoint = raw.containsKey('point');
    if (!hasPoint) {
      throw FormatException("FocusGestureListenerOnFocusGesture.point: missing required property");
    }
    final pointRaw = raw['point'];
    String? pointValue;
    if (hasPoint && pointRaw != null) {
      if (pointRaw is! String) {
        throw FormatException('FocusGestureListenerOnFocusGesture.point: expected a String');
      }
      pointValue = pointRaw;
    } else if (hasPoint && pointRaw == null) {
      throw FormatException('FocusGestureListenerOnFocusGesture.point: null is not allowed');
    }
    final hasEvent = raw.containsKey('event');
    if (!hasEvent) {
      throw FormatException("FocusGestureListenerOnFocusGesture.event: missing required property");
    }
    final eventRaw = raw['event'];
    String? eventValue;
    if (hasEvent && eventRaw != null) {
      if (eventRaw is! String || !const <String>['FocusGestureListener.onFocusGesture'].contains(eventRaw)) {
        throw FormatException("FocusGestureListenerOnFocusGesture.event: unknown enum value '$eventRaw'");
      }
      eventValue = eventRaw;
    } else if (hasEvent && eventRaw == null) {
      throw FormatException('FocusGestureListenerOnFocusGesture.event: null is not allowed');
    }
    return FocusGestureListenerOnFocusGesture(
      viewId: viewIdValue!,
      focusGesture: focusGestureValue!,
      point: pointValue!,
      event: eventValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['viewId'] = viewId;
    map['focusGesture'] = focusGesture;
    map['point'] = point;
    map['event'] = event;
    return map;
  }
}

/// Typed builder for the `FocusGestureListenerOnFocusGesture` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildFocusGestureListenerOnFocusGesture({
  required int viewId,
  required String focusGesture,
  required String point,
  required String event,
}) {
  final map = <String, Object?>{};
  map['viewId'] = viewId;
  map['focusGesture'] = focusGesture;
  map['point'] = point;
  map['event'] = event;
  return map;
}

/// Notifies the listener that the zoom-in gesture was performed.
class ZoomGestureListenerOnZoomInGesture {
  final int viewId;
  final String zoomGesture;
  final String event;

  const ZoomGestureListenerOnZoomInGesture({
    required this.viewId,
    required this.zoomGesture,
    required this.event,
  });

  factory ZoomGestureListenerOnZoomInGesture.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('ZoomGestureListenerOnZoomInGesture: expected a Map');
    }
    const allowedKeys = <String>{
      'viewId',
      'zoomGesture',
      'event',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("ZoomGestureListenerOnZoomInGesture: unknown property '$key'");
      }
    }
    final hasViewId = raw.containsKey('viewId');
    if (!hasViewId) {
      throw FormatException("ZoomGestureListenerOnZoomInGesture.viewId: missing required property");
    }
    final viewIdRaw = raw['viewId'];
    int? viewIdValue;
    if (hasViewId && viewIdRaw != null) {
      if (viewIdRaw is! num) {
        throw FormatException('ZoomGestureListenerOnZoomInGesture.viewId: expected a number');
      }
      if (viewIdRaw != viewIdRaw.toInt()) {
        throw FormatException('ZoomGestureListenerOnZoomInGesture.viewId: expected an integer');
      }
      viewIdValue = viewIdRaw.toInt();
    } else if (hasViewId && viewIdRaw == null) {
      throw FormatException('ZoomGestureListenerOnZoomInGesture.viewId: null is not allowed');
    }
    final hasZoomGesture = raw.containsKey('zoomGesture');
    if (!hasZoomGesture) {
      throw FormatException("ZoomGestureListenerOnZoomInGesture.zoomGesture: missing required property");
    }
    final zoomGestureRaw = raw['zoomGesture'];
    String? zoomGestureValue;
    if (hasZoomGesture && zoomGestureRaw != null) {
      if (zoomGestureRaw is! String) {
        throw FormatException('ZoomGestureListenerOnZoomInGesture.zoomGesture: expected a String');
      }
      zoomGestureValue = zoomGestureRaw;
    } else if (hasZoomGesture && zoomGestureRaw == null) {
      throw FormatException('ZoomGestureListenerOnZoomInGesture.zoomGesture: null is not allowed');
    }
    final hasEvent = raw.containsKey('event');
    if (!hasEvent) {
      throw FormatException("ZoomGestureListenerOnZoomInGesture.event: missing required property");
    }
    final eventRaw = raw['event'];
    String? eventValue;
    if (hasEvent && eventRaw != null) {
      if (eventRaw is! String || !const <String>['ZoomGestureListener.onZoomInGesture'].contains(eventRaw)) {
        throw FormatException("ZoomGestureListenerOnZoomInGesture.event: unknown enum value '$eventRaw'");
      }
      eventValue = eventRaw;
    } else if (hasEvent && eventRaw == null) {
      throw FormatException('ZoomGestureListenerOnZoomInGesture.event: null is not allowed');
    }
    return ZoomGestureListenerOnZoomInGesture(
      viewId: viewIdValue!,
      zoomGesture: zoomGestureValue!,
      event: eventValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['viewId'] = viewId;
    map['zoomGesture'] = zoomGesture;
    map['event'] = event;
    return map;
  }
}

/// Typed builder for the `ZoomGestureListenerOnZoomInGesture` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildZoomGestureListenerOnZoomInGesture({
  required int viewId,
  required String zoomGesture,
  required String event,
}) {
  final map = <String, Object?>{};
  map['viewId'] = viewId;
  map['zoomGesture'] = zoomGesture;
  map['event'] = event;
  return map;
}

/// Notifies the listener that the zoom-out gesture was performed.
class ZoomGestureListenerOnZoomOutGesture {
  final int viewId;
  final String zoomGesture;
  final String event;

  const ZoomGestureListenerOnZoomOutGesture({
    required this.viewId,
    required this.zoomGesture,
    required this.event,
  });

  factory ZoomGestureListenerOnZoomOutGesture.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('ZoomGestureListenerOnZoomOutGesture: expected a Map');
    }
    const allowedKeys = <String>{
      'viewId',
      'zoomGesture',
      'event',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("ZoomGestureListenerOnZoomOutGesture: unknown property '$key'");
      }
    }
    final hasViewId = raw.containsKey('viewId');
    if (!hasViewId) {
      throw FormatException("ZoomGestureListenerOnZoomOutGesture.viewId: missing required property");
    }
    final viewIdRaw = raw['viewId'];
    int? viewIdValue;
    if (hasViewId && viewIdRaw != null) {
      if (viewIdRaw is! num) {
        throw FormatException('ZoomGestureListenerOnZoomOutGesture.viewId: expected a number');
      }
      if (viewIdRaw != viewIdRaw.toInt()) {
        throw FormatException('ZoomGestureListenerOnZoomOutGesture.viewId: expected an integer');
      }
      viewIdValue = viewIdRaw.toInt();
    } else if (hasViewId && viewIdRaw == null) {
      throw FormatException('ZoomGestureListenerOnZoomOutGesture.viewId: null is not allowed');
    }
    final hasZoomGesture = raw.containsKey('zoomGesture');
    if (!hasZoomGesture) {
      throw FormatException("ZoomGestureListenerOnZoomOutGesture.zoomGesture: missing required property");
    }
    final zoomGestureRaw = raw['zoomGesture'];
    String? zoomGestureValue;
    if (hasZoomGesture && zoomGestureRaw != null) {
      if (zoomGestureRaw is! String) {
        throw FormatException('ZoomGestureListenerOnZoomOutGesture.zoomGesture: expected a String');
      }
      zoomGestureValue = zoomGestureRaw;
    } else if (hasZoomGesture && zoomGestureRaw == null) {
      throw FormatException('ZoomGestureListenerOnZoomOutGesture.zoomGesture: null is not allowed');
    }
    final hasEvent = raw.containsKey('event');
    if (!hasEvent) {
      throw FormatException("ZoomGestureListenerOnZoomOutGesture.event: missing required property");
    }
    final eventRaw = raw['event'];
    String? eventValue;
    if (hasEvent && eventRaw != null) {
      if (eventRaw is! String || !const <String>['ZoomGestureListener.onZoomOutGesture'].contains(eventRaw)) {
        throw FormatException("ZoomGestureListenerOnZoomOutGesture.event: unknown enum value '$eventRaw'");
      }
      eventValue = eventRaw;
    } else if (hasEvent && eventRaw == null) {
      throw FormatException('ZoomGestureListenerOnZoomOutGesture.event: null is not allowed');
    }
    return ZoomGestureListenerOnZoomOutGesture(
      viewId: viewIdValue!,
      zoomGesture: zoomGestureValue!,
      event: eventValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['viewId'] = viewId;
    map['zoomGesture'] = zoomGesture;
    map['event'] = event;
    return map;
  }
}

/// Typed builder for the `ZoomGestureListenerOnZoomOutGesture` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildZoomGestureListenerOnZoomOutGesture({
  required int viewId,
  required String zoomGesture,
  required String event,
}) {
  final map = <String, Object?>{};
  map['viewId'] = viewId;
  map['zoomGesture'] = zoomGesture;
  map['event'] = event;
  return map;
}

/// Typed event dispatch for `FrameSourceListener`: parses the raw payload
/// for [eventName] into its matching generated type. Throws
/// [ArgumentError] for an event name this listener doesn't declare, and
/// [FormatException] (via the target type's `fromJson`) on a payload shape
/// mismatch -- mirrors `parseFrameSourceListenerEvent` in schemaTypes.ts.
dynamic parseFrameSourceListenerEvent(String eventName, Object? raw) {
  switch (eventName) {
    case 'onStateChanged':
      return FrameSourceListenerOnStateChanged.fromJson(raw);
    default:
      throw ArgumentError("FrameSourceListener: unknown event '$eventName'");
  }
}

/// Typed event dispatch for `TorchListener`: parses the raw payload
/// for [eventName] into its matching generated type. Throws
/// [ArgumentError] for an event name this listener doesn't declare, and
/// [FormatException] (via the target type's `fromJson`) on a payload shape
/// mismatch -- mirrors `parseTorchListenerEvent` in schemaTypes.ts.
dynamic parseTorchListenerEvent(String eventName, Object? raw) {
  switch (eventName) {
    case 'onTorchStateChanged':
      return TorchListenerOnTorchStateChanged.fromJson(raw);
    default:
      throw ArgumentError("TorchListener: unknown event '$eventName'");
  }
}

/// Typed event dispatch for `ZoomListener`: parses the raw payload
/// for [eventName] into its matching generated type. Throws
/// [ArgumentError] for an event name this listener doesn't declare, and
/// [FormatException] (via the target type's `fromJson`) on a payload shape
/// mismatch -- mirrors `parseZoomListenerEvent` in schemaTypes.ts.
dynamic parseZoomListenerEvent(String eventName, Object? raw) {
  switch (eventName) {
    case 'onZoomLevelChanged':
      return ZoomListenerOnZoomLevelChanged.fromJson(raw);
    default:
      throw ArgumentError("ZoomListener: unknown event '$eventName'");
  }
}

/// Typed event dispatch for `MacroModeListener`: parses the raw payload
/// for [eventName] into its matching generated type. Throws
/// [ArgumentError] for an event name this listener doesn't declare, and
/// [FormatException] (via the target type's `fromJson`) on a payload shape
/// mismatch -- mirrors `parseMacroModeListenerEvent` in schemaTypes.ts.
dynamic parseMacroModeListenerEvent(String eventName, Object? raw) {
  switch (eventName) {
    case 'onMacroModeChanged':
      return MacroModeListenerOnMacroModeChanged.fromJson(raw);
    default:
      throw ArgumentError("MacroModeListener: unknown event '$eventName'");
  }
}

/// Typed event dispatch for `DataCaptureContextListener`: parses the raw payload
/// for [eventName] into its matching generated type. Throws
/// [ArgumentError] for an event name this listener doesn't declare, and
/// [FormatException] (via the target type's `fromJson`) on a payload shape
/// mismatch -- mirrors `parseDataCaptureContextListenerEvent` in schemaTypes.ts.
dynamic parseDataCaptureContextListenerEvent(String eventName, Object? raw) {
  switch (eventName) {
    case 'onObservationStarted':
      return DataCaptureContextListenerOnObservationStarted.fromJson(raw);
    case 'onStatusChanged':
      return DataCaptureContextListenerOnStatusChanged.fromJson(raw);
    case 'onFrameSourceChanged':
      return DataCaptureContextListenerOnFrameSourceChanged.fromJson(raw);
    default:
      throw ArgumentError("DataCaptureContextListener: unknown event '$eventName'");
  }
}

/// Typed event dispatch for `DataCaptureViewListener`: parses the raw payload
/// for [eventName] into its matching generated type. Throws
/// [ArgumentError] for an event name this listener doesn't declare, and
/// [FormatException] (via the target type's `fromJson`) on a payload shape
/// mismatch -- mirrors `parseDataCaptureViewListenerEvent` in schemaTypes.ts.
dynamic parseDataCaptureViewListenerEvent(String eventName, Object? raw) {
  switch (eventName) {
    case 'onSizeChanged':
      return DataCaptureViewListenerOnSizeChanged.fromJson(raw);
    default:
      throw ArgumentError("DataCaptureViewListener: unknown event '$eventName'");
  }
}

/// Typed event dispatch for `FocusGestureListener`: parses the raw payload
/// for [eventName] into its matching generated type. Throws
/// [ArgumentError] for an event name this listener doesn't declare, and
/// [FormatException] (via the target type's `fromJson`) on a payload shape
/// mismatch -- mirrors `parseFocusGestureListenerEvent` in schemaTypes.ts.
dynamic parseFocusGestureListenerEvent(String eventName, Object? raw) {
  switch (eventName) {
    case 'onFocusGesture':
      return FocusGestureListenerOnFocusGesture.fromJson(raw);
    default:
      throw ArgumentError("FocusGestureListener: unknown event '$eventName'");
  }
}

/// Typed event dispatch for `ZoomGestureListener`: parses the raw payload
/// for [eventName] into its matching generated type. Throws
/// [ArgumentError] for an event name this listener doesn't declare, and
/// [FormatException] (via the target type's `fromJson`) on a payload shape
/// mismatch -- mirrors `parseZoomGestureListenerEvent` in schemaTypes.ts.
dynamic parseZoomGestureListenerEvent(String eventName, Object? raw) {
  switch (eventName) {
    case 'onZoomInGesture':
      return ZoomGestureListenerOnZoomInGesture.fromJson(raw);
    case 'onZoomOutGesture':
      return ZoomGestureListenerOnZoomOutGesture.fromJson(raw);
    default:
      throw ArgumentError("ZoomGestureListener: unknown event '$eventName'");
  }
}
