/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/widgets.dart';

import 'common.dart';
import 'data_capture_context.dart';
import 'defaults.dart';
import 'function_names.dart';
import 'internal/base_controller.dart';
import 'internal/core_plugin_events.dart';
import 'internal/event_stream_extensions.dart';
import 'internal/flutter_event.dart';
import 'internal/generated/core_method_handler.dart';
import 'internal/generated/schema_types.dart' as schema;
import 'internal/generated/schema_types.dart'
    show
        buildTorchSwitchControl,
        buildTorchIcon,
        buildIconState,
        buildMacroModeControl,
        buildMacroIcon,
        buildCameraSwitchControl;
import 'internal/tolerant_payload_parser.dart';
import 'internal/view_attachable.dart';
import 'source/camera.dart';
import 'source/camera_position.dart';
import 'source/frame_source_state.dart';
import 'source/zoom_switch_orientation.dart';
import 'widget_to_base64_converter.dart';

/// Interface for custom controls on top of the data capture view. Controls are restricted to the set of controls provided by the Scandit Data Capture SDK, it is not possible for customers to implement this interface and provide custom control implementations. This interface does not expose any methods or properties, it just serves as a tag for different controls.
///
/// Added in version 6.8.0
abstract class Control extends Serializable {}

/// Control that allows to toggle the torch on and off. The torch switch control hides itself automatically in case the active frame source doesn’t have a torch.
///
/// You can add this control to a view by calling [DataCaptureView.addControl].
///
/// Added in version 6.8.0
class TorchSwitchControl implements Control {
  /// Constructor.
  ///
  /// Added in version 8.3.0
  TorchSwitchControl();

  Image? _torchOffImage;
  String? _torchOffBase64Image;

  Image? _torchOffPressedImage;
  String? _torchOffPressedBase64Image;

  Image? _torchOnImage;
  String? _torchOnBase64Image;

  Image? _torchOnPressedImage;
  String? _torchOnPressedBase64Image;

  /// Accessibility label text used for the control button when the torch is off.
  ///
  /// Added in version 8.3.0
  String? accessibilityLabelWhenOff;
  /// Accessibility hint text used for the control button when the torch is off.
  ///
  /// This property will have no effect when running on Android.
  ///
  /// Added in version 8.3.0
  String? accessibilityHintWhenOff;
  /// Accessibility label text used for the control button when the torch is on.
  ///
  /// Added in version 8.3.0
  String? accessibilityLabelWhenOn;
  /// Accessibility hint text used for the control button when the torch is on.
  ///
  /// This property will have no effect when running on Android.
  ///
  /// Added in version 8.3.0
  String? accessibilityHintWhenOn;

  /// Gets the image encoded as a base64 string used for the control button when the torch is off.
  ///
  /// Added in version 6.8.0
  Image? get torchOffImage => _torchOffImage;
  /// Sets the resource to use for the control button image when the torch is off.
  ///
  /// Added in version 6.8.0
  Future<void> setTorchOffImage(Image? image) async {
    _torchOffImage = image;
    _torchOffBase64Image = await _torchOffImage?.base64String;
  }

  /// Gets the image encoded as a base64 string used for the control button when the torch is off and the button is pressed.
  ///
  /// Added in version 6.8.0
  Image? get torchOffPressedImage => _torchOffPressedImage;
  /// Sets the resource to use for the control button image when the torch is off and the button is pressed.
  ///
  /// Added in version 6.8.0
  Future<void> setTorchOffPressedImage(Image? image) async {
    _torchOffPressedImage = image;
    _torchOffPressedBase64Image = await _torchOffPressedImage?.base64String;
  }

  /// Gets the image encoded in a base64 string used for the control button when the torch is on.
  ///
  /// Added in version 6.8.0
  Image? get torchOnImage => _torchOnImage;
  /// Sets the resource to use for the control button image when the torch is on.
  ///
  /// Added in version 6.8.0
  Future<void> setTorchOnImage(Image? image) async {
    _torchOnImage = image;
    _torchOnBase64Image = await _torchOnImage?.base64String;
  }

  /// Gets the image encoded as a base64 string used for the control button when the torch is on and the button is pressed.
  ///
  /// Added in version 6.8.0
  Image? get torchOnPressedImage => _torchOnPressedImage;
  /// Sets the resource to use for the control button image when the torch is on and the button is pressed.
  ///
  /// Added in version 6.8.0
  Future<void> setTorchOnPressedImage(Image? image) async {
    _torchOnPressedImage = image;
    _torchOnPressedBase64Image = await _torchOnPressedImage?.base64String;
  }

  @override
  Map<String, dynamic> toMap() {
    return buildTorchSwitchControl(
      type: 'torch',
      icon: buildTorchIcon(
        on$: buildIconState(default$: _torchOnBase64Image, pressed: _torchOnPressedBase64Image),
        off: buildIconState(default$: _torchOffBase64Image, pressed: _torchOffPressedBase64Image),
      ),
      accessibilityLabelWhenOff: accessibilityLabelWhenOff,
      accessibilityHintWhenOff: accessibilityHintWhenOff,
      accessibilityLabelWhenOn: accessibilityLabelWhenOn,
      accessibilityHintWhenOn: accessibilityHintWhenOn,
    );
  }
}

/// Macro mode control is only functional on iOS. On Android it has no native backing, so adding it to a view has no effect.
///
/// Control that allows to switch between the available macro modes ([MacroMode]). The control hides itself automatically in case the active frame source doesn’t support macro mode.
///
/// You can add this control to a view by calling [DataCaptureView.addControl].
///
/// Added in version 8.6.0
class MacroModeControl implements Control {
  /// Constructors a new macro mode control.
  ///
  /// Added in version 8.6.0
  MacroModeControl();

  String? _autoBase64Image = Defaults.macroModeControlDefaults.autoBase64Image;
  String? _offBase64Image = Defaults.macroModeControlDefaults.offBase64Image;
  String? _onBase64Image = Defaults.macroModeControlDefaults.onBase64Image;

  /// Accessibility label text used for the control button when the macro mode is auto.
  ///
  /// Added in version 8.6.0
  String? accessibilityLabelWhenAuto = Defaults.macroModeControlDefaults.accessibilityLabelWhenAuto;
  /// Accessibility hint text used for the control button when the macro mode is auto.
  ///
  /// Added in version 8.6.0
  String? accessibilityHintWhenAuto = Defaults.macroModeControlDefaults.accessibilityHintWhenAuto;
  /// Accessibility label text used for the control button when the macro mode is off.
  ///
  /// Added in version 8.6.0
  String? accessibilityLabelWhenOff = Defaults.macroModeControlDefaults.accessibilityLabelWhenOff;
  /// Accessibility hint text used for the control button when the macro mode is off.
  ///
  /// Added in version 8.6.0
  String? accessibilityHintWhenOff = Defaults.macroModeControlDefaults.accessibilityHintWhenOff;
  /// Accessibility label text used for the control button when the macro mode is on.
  ///
  /// Added in version 8.6.0
  String? accessibilityLabelWhenOn = Defaults.macroModeControlDefaults.accessibilityLabelWhenOn;
  /// Accessibility hint text used for the control button when the macro mode is on.
  ///
  /// Added in version 8.6.0
  String? accessibilityHintWhenOn = Defaults.macroModeControlDefaults.accessibilityHintWhenOn;

  /// The default image used for the control button when the macro mode is auto.
  ///
  /// Added in version 8.6.0
  static Image? get defaultAutoImage => _imageFromBase64(Defaults.macroModeControlDefaults.autoBase64Image);
  /// The default image used for the control button when the macro mode is off.
  ///
  /// Added in version 8.6.0
  static Image? get defaultOffImage => _imageFromBase64(Defaults.macroModeControlDefaults.offBase64Image);
  /// The default image used for the control button when the macro mode is on.
  ///
  /// Added in version 8.6.0
  static Image? get defaultOnImage => _imageFromBase64(Defaults.macroModeControlDefaults.onBase64Image);

  /// The button image displayed when the macro mode is auto.
  ///
  /// Added in version 8.6.0
  Image? get autoImage => _imageFromBase64(_autoBase64Image);
  /// The button image displayed when the macro mode is auto.
  ///
  /// Added in version 8.6.0
  set autoImage(Image? newValue) => _autoBase64Image = _base64FromImage(newValue, (v) => _autoBase64Image = v);

  /// The button image displayed when the macro mode is off.
  ///
  /// Added in version 8.6.0
  Image? get offImage => _imageFromBase64(_offBase64Image);
  /// The button image displayed when the macro mode is off.
  ///
  /// Added in version 8.6.0
  set offImage(Image? newValue) => _offBase64Image = _base64FromImage(newValue, (v) => _offBase64Image = v);

  /// The button image displayed when the macro mode is on.
  ///
  /// Added in version 8.6.0
  Image? get onImage => _imageFromBase64(_onBase64Image);
  /// The button image displayed when the macro mode is on.
  ///
  /// Added in version 8.6.0
  set onImage(Image? newValue) => _onBase64Image = _base64FromImage(newValue, (v) => _onBase64Image = v);

  // A Flutter Image can only be rendered to bytes asynchronously in the general
  // case, but the common path — app-provided bytes and the native default icons,
  // which both arrive as Image.memory — already holds the encoded bytes, so we
  // encode those synchronously and avoid a race where toMap() serializes a stale
  // value before an async conversion completes. Asset/network-backed images
  // (rare for control icons) fall back to the async render path.
  static String? _base64FromImage(Image? image, void Function(String?) onConverted) {
    if (image == null) {
      return null;
    }
    final provider = image.image;
    if (provider is MemoryImage) {
      return base64Encode(provider.bytes);
    }
    image.base64String.then(onConverted);
    return null;
  }

  static Image? _imageFromBase64(String? base64) {
    if (base64 == null || base64.isEmpty) {
      return null;
    }
    // Remove whitespaces to avoid errors when decoding.
    return Image.memory(base64Decode(base64.replaceAll(RegExp(r'\s+'), '')));
  }

  @override
  Map<String, dynamic> toMap() {
    var json = buildMacroModeControl(
      type: 'macro',
      icon: buildMacroIcon(
        auto: _autoBase64Image,
        off: _offBase64Image,
        on$: _onBase64Image,
      ),
    );
    // The six accessibility strings below are appended by hand because
    // core/macro_mode_control.json does not model them - buildMacroModeControl only
    // accepts type/anchor/offset/icon (schema gap, SDC-33435). This is the same
    // situation as ImageFrameSource.toMap, NOT a builder that exists and went
    // unused: sibling TorchSwitchControl models its accessibility keys, so the
    // asymmetry is the schema's, not an oversight here. Closing it needs schema
    // work, not a call-site change.
    if (accessibilityLabelWhenAuto != null) {
      json['accessibilityLabelWhenAuto'] = accessibilityLabelWhenAuto;
    }
    if (accessibilityHintWhenAuto != null) {
      json['accessibilityHintWhenAuto'] = accessibilityHintWhenAuto;
    }
    if (accessibilityLabelWhenOff != null) {
      json['accessibilityLabelWhenOff'] = accessibilityLabelWhenOff;
    }
    if (accessibilityHintWhenOff != null) {
      json['accessibilityHintWhenOff'] = accessibilityHintWhenOff;
    }
    if (accessibilityLabelWhenOn != null) {
      json['accessibilityLabelWhenOn'] = accessibilityLabelWhenOn;
    }
    if (accessibilityHintWhenOn != null) {
      json['accessibilityHintWhenOn'] = accessibilityHintWhenOn;
    }
    return json;
  }
}

mixin PrivateZoomSwitchControl on ViewAttachable {
  _ZoomSwitchController? _controller;

  @override
  void onViewInitialized(int viewId) {
    _controller = _ZoomSwitchController(viewId);
  }

  @override
  void onDetachFromView() {
    _controller = null;
    super.onDetachFromView();
  }
}

/// Control that allows switching between configurable camera zoom levels. The available zoom levels are filtered based on the camera hardware capabilities.
///
/// You can add this control to a view by calling [DataCaptureView.addControl].
///
/// Added in version 6.10.0
class ZoomSwitchControl with ViewAttachable, PrivateZoomSwitchControl implements Control {
  // v2 properties
  /// The orientation of the zoom switch control. Defaults to ZoomSwitchOrientation.defaultOrientation.
  ///
  /// Added in version 8.4.0
  ZoomSwitchOrientation orientation = Defaults.zoomSwitchControlDefaults.orientation;
  /// When *true*, the control is always shown in its expanded state, displaying all zoom levels regardless of user interaction, and [ZoomSwitchControl.isExpanded] is always *true*. When *false*, the control can be collapsed. Defaults to *false*.
  ///
  /// Added in version 8.4.0
  bool isAlwaysExpanded = Defaults.zoomSwitchControlDefaults.isAlwaysExpanded;
  /// Whether the control is currently expanded, showing all zoom levels. Can be set programmatically to expand or collapse the control. When [ZoomSwitchControl.isAlwaysExpanded] is *true*, this property always returns *true* and setting it has no effect.
  ///
  /// Added in version 8.4.0
  bool isExpanded = Defaults.zoomSwitchControlDefaults.isExpanded;
  /// The accessibility label. The placeholder `<level>` is replaced with the zoom factor of each button. Defaults to `"Zoom <level>"`.
  ///
  /// Added in version 8.4.0
  String accessibilityLabel = Defaults.zoomSwitchControlDefaults.accessibilityLabel;
  /// The accessibility hint. Defaults to `"Adjusts the camera zoom level"`.
  ///
  /// This property will have no effect when running on Android.
  ///
  /// Added in version 8.4.0
  String accessibilityHint = Defaults.zoomSwitchControlDefaults.accessibilityHint;

  double _selectedZoomLevel = 1.0;
  /// The currently selected zoom level.
  ///
  /// Added in version 8.4.0
  double get selectedZoomLevel => _selectedZoomLevel;

  // v1 deprecated image properties
  Image? _zoomedOutImage;
  String? _zoomedOutBase64Image;

  Image? _zoomedOutPressedImage;
  String? _zoomedOutPressedBase64Image;

  Image? _zoomedInImage;
  String? _zoomedInBase64Image;

  Image? _zoomedInPressedImage;
  String? _zoomedInPressedBase64Image;

  /// Content description text used for the control button when zoomed out (Android only).
  ///
  /// This property is only used on Android. For iOS, use [ZoomSwitchControl.accessibilityLabelWhenZoomedOut] instead.
  ///
  /// Added in version 8.3.0
  @Deprecated('Use accessibilityLabel instead.')
  String? contentDescriptionWhenZoomedOut;
  /// Content description text used for the control button when zoomed in (Android only).
  ///
  /// This property is only used on Android. For iOS, use [ZoomSwitchControl.accessibilityLabelWhenZoomedIn] instead.
  ///
  /// Added in version 8.3.0
  @Deprecated('Use accessibilityLabel instead.')
  String? contentDescriptionWhenZoomedIn;
  /// Accessibility label text used for the control button when zoomed out (iOS only).
  ///
  /// This property is only used on iOS. For Android, use [ZoomSwitchControl.contentDescriptionWhenZoomedOut] instead.
  ///
  /// Added in version 8.3.0
  @Deprecated('Use accessibilityLabel instead.')
  String? accessibilityLabelWhenZoomedOut;
  /// Accessibility label text used for the control button when zoomed in (iOS only).
  ///
  /// This property is only used on iOS. For Android, use [ZoomSwitchControl.contentDescriptionWhenZoomedIn] instead.
  ///
  /// Added in version 8.3.0
  @Deprecated('Use accessibilityLabel instead.')
  String? accessibilityLabelWhenZoomedIn;
  /// Accessibility hint text used for the control button when zoomed out.
  ///
  /// This property is only used on iOS. Android does not have an equivalent accessibility hint concept.
  ///
  /// Added in version 8.3.0
  @Deprecated('Use accessibilityHint instead.')
  String? accessibilityHintWhenZoomedOut;
  /// Accessibility hint text used for the control button when zoomed in.
  ///
  /// This property is only used on iOS. Android does not have an equivalent accessibility hint concept.
  ///
  /// Added in version 8.3.0
  @Deprecated('Use accessibilityHint instead.')
  String? accessibilityHintWhenZoomedIn;

  /// Initializes a new ZoomSwitchControl.
  ///
  /// Added in version 8.3.0
  ZoomSwitchControl();

  /// The button image displayed when the zoom level is set to 1x.
  ///
  /// Added in version 6.10.0
  @Deprecated('Use CameraSettings.zoomLevels instead.')
  Image? get zoomedOutImage => _zoomedOutImage;
  /// The button image resource displayed when the zoom level is set to 1x.
  ///
  /// Added in version 6.10.0
  @Deprecated('Use CameraSettings.zoomLevels instead.')
  Future<void> setZoomedOutImage(Image? image) async {
    _zoomedOutImage = image;
    _zoomedOutBase64Image = await image?.base64String;
  }

  /// The button image displayed when the zoom level is set to 1x and the button is pressed.
  ///
  /// Added in version 6.10.0
  @Deprecated('Use CameraSettings.zoomLevels instead.')
  Image? get zoomedOutPressedImage => _zoomedOutPressedImage;
  /// The button image resource displayed when the zoom level is set to 1x and the button is pressed.
  ///
  /// Added in version 6.10.0
  @Deprecated('Use CameraSettings.zoomLevels instead.')
  Future<void> setZoomedOutPressedImage(Image? image) async {
    _zoomedOutPressedImage = image;
    _zoomedOutPressedBase64Image = await image?.base64String;
  }

  /// The button image displayed when the zoom level is set to 2x.
  ///
  /// Added in version 6.10.0
  @Deprecated('Use CameraSettings.zoomLevels instead.')
  Image? get zoomedInImage => _zoomedInImage;
  /// The button image resource displayed when the zoom level is set to 2x.
  ///
  /// Added in version 6.10.0
  @Deprecated('Use CameraSettings.zoomLevels instead.')
  Future<void> setZoomedInImage(Image? image) async {
    _zoomedInImage = image;
    _zoomedInBase64Image = await image?.base64String;
  }

  /// The button image displayed when the zoom level is set to 2x and pressed.
  ///
  /// Added in version 6.10.0
  @Deprecated('Use CameraSettings.zoomLevels instead.')
  Image? get zoomedInPressedImage => _zoomedInPressedImage;
  /// The button image resource displayed when the zoom level is set to 2x and pressed.
  ///
  /// Added in version 6.10.0
  @Deprecated('Use CameraSettings.zoomLevels instead.')
  Future<void> setZoomedInPressedImage(Image? image) async {
    _zoomedInPressedImage = image;
    _zoomedInPressedBase64Image = await image?.base64String;
  }

  /// Selects the given zoom level, clamped to the range supported by the camera hardware. Returns the actual zoom level that was applied.
  ///
  /// Added in version 8.4.0
  Future<double> selectZoomLevel(double zoomLevel) async {
    final result = await _controller?.selectZoomLevel(zoomLevel) ?? -1.0;
    _selectedZoomLevel = result;
    return result;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'zoom',
      'orientation': orientation.toString(),
      'isAlwaysExpanded': isAlwaysExpanded,
      'isExpanded': isExpanded,
      'accessibilityLabel': accessibilityLabel,
      'accessibilityHint': accessibilityHint,
      'icon': {
        'zoomedOut': {'default': _zoomedOutBase64Image, 'pressed': _zoomedOutPressedBase64Image},
        'zoomedIn': {'default': _zoomedInBase64Image, 'pressed': _zoomedInPressedBase64Image}
      },
      // ignore: deprecated_member_use_from_same_package
      if (contentDescriptionWhenZoomedOut != null) 'contentDescriptionWhenZoomedOut': contentDescriptionWhenZoomedOut,
      // ignore: deprecated_member_use_from_same_package
      if (contentDescriptionWhenZoomedIn != null) 'contentDescriptionWhenZoomedIn': contentDescriptionWhenZoomedIn,
      // ignore: deprecated_member_use_from_same_package
      if (accessibilityLabelWhenZoomedOut != null) 'accessibilityLabelWhenZoomedOut': accessibilityLabelWhenZoomedOut,
      // ignore: deprecated_member_use_from_same_package
      if (accessibilityLabelWhenZoomedIn != null) 'accessibilityLabelWhenZoomedIn': accessibilityLabelWhenZoomedIn,
      // ignore: deprecated_member_use_from_same_package
      if (accessibilityHintWhenZoomedOut != null) 'accessibilityHintWhenZoomedOut': accessibilityHintWhenZoomedOut,
      // ignore: deprecated_member_use_from_same_package
      if (accessibilityHintWhenZoomedIn != null) 'accessibilityHintWhenZoomedIn': accessibilityHintWhenZoomedIn,
    };
  }
}

class _ZoomSwitchController extends BaseController {
  final int _viewId;
  late final CoreMethodHandler _coreMethodHandler;

  _ZoomSwitchController(this._viewId) : super(FunctionNames.methodsChannelName) {
    _coreMethodHandler = CoreMethodHandler(methodChannel);
  }

  Future<double> selectZoomLevel(double zoomLevel) {
    return _coreMethodHandler.selectZoomLevel(viewId: _viewId, zoomLevel: zoomLevel).then((v) => v.toDouble());
  }
}

mixin PrivateCameraSwitchControl on ViewAttachable {
  _CameraSwitchController? _controller;

  Camera get _primaryCamera;
  Camera get _secondaryCamera;

  @override
  void onViewInitialized(int viewId) {
    // Dispose first: re-initializing without a detach would leak the event subscription.
    _controller?.dispose();
    _controller = _CameraSwitchController(_primaryCamera, _secondaryCamera, attachedView?.dataCaptureContext);
  }

  @override
  void onDetachFromView() {
    _controller?.dispose();
    _controller = null;
    super.onDetachFromView();
  }
}

/// Control that allows to switch between a primary and a secondary camera.
///
/// You can add this control to a view by calling [DataCaptureView.addControl].
///
/// Adding a camera switch control to a view sets the primary camera as the view’s context frame source.
///
/// Added in version 8.7.0
class CameraSwitchControl with ViewAttachable, PrivateCameraSwitchControl implements Control {
  /// The primary camera. Calling [DataCaptureView.addControl] sets this camera as the view’s context frame source.
  ///
  /// Added in version 8.7.0
  final Camera primaryCamera;
  /// The secondary camera.
  ///
  /// Added in version 8.7.0
  final Camera secondaryCamera;

  /// Accessibility label text used for the button when the user facing camera is selected.
  ///
  /// Added in version 8.7.0
  String? accessibilityLabelWhenUserFacing;
  /// Accessibility label text used for the button when the world facing camera is selected.
  ///
  /// Added in version 8.7.0
  String? accessibilityLabelWhenWorldFacing;

  /// Initializes a CameraSwitchControl with two cameras.
  ///
  /// Added in version 8.7.0
  CameraSwitchControl(this.primaryCamera, this.secondaryCamera);

  @override
  Camera get _primaryCamera => primaryCamera;
  @override
  Camera get _secondaryCamera => secondaryCamera;

  @override
  Map<String, dynamic> toMap() {
    return buildCameraSwitchControl(
      type: 'camera',
      primaryCamera: primaryCamera.toMap(),
      secondaryCamera: secondaryCamera.toMap(),
      // Platform-split at the native deserializers: iOS reads accessibilityLabelWhen*, Android
      // contentDescriptionWhen*, so each property feeds both keys.
      accessibilityLabelWhenUserFacing: accessibilityLabelWhenUserFacing,
      contentDescriptionWhenUserFacing: accessibilityLabelWhenUserFacing,
      accessibilityLabelWhenWorldFacing: accessibilityLabelWhenWorldFacing,
      contentDescriptionWhenWorldFacing: accessibilityLabelWhenWorldFacing,
    );
  }
}

class _CameraSwitchController {
  final Camera _primaryCamera;
  final Camera _secondaryCamera;

  /// Held rather than re-resolved, so the release targets the object the retain was taken on.
  final PrivateDataCaptureContext? _retainedContext;

  StreamSubscription? _sub;

  _CameraSwitchController(this._primaryCamera, this._secondaryCamera, DataCaptureContext? context)
      : _retainedContext = context {
    // The context adopts the switch itself, but only while its event subscription is open, and
    // that opens on demand. Retain it while this control is attached.
    _retainedContext?.retainContextEvents();
    _subscribe();
  }

  void _subscribe() {
    if (_sub != null) return;
    _sub = CorePluginEvents.coreEventStream.asFlutterEvents().listen((event) {
      if (event.isEvent(FunctionNames.eventFrameSourceStateChanged)) {
        _handleFrameSourceStateChanged(event);
      }
    });
  }

  /// Mirrors onto the reported camera the state native put it in. State only — which camera the
  /// context points at is the context's job, from onFrameSourceChanged. This event carries
  /// cameraPosition, which is all that is needed to attribute a state to its camera.
  void _handleFrameSourceStateChanged(FlutterEvent event) {
    final payload = parsePayloadTolerantly<schema.FrameSourceListenerOnStateChanged>(
      event.payload,
      (raw) => schema.FrameSourceListenerOnStateChanged.fromJson(raw),
      (raw) {
        final map = raw is Map ? raw : const <String, dynamic>{};
        if (map['state'] is! String) return null;
        return schema.FrameSourceListenerOnStateChanged(
          state: map['state'] as String,
          cameraPosition: map['cameraPosition'] is String ? map['cameraPosition'] as String : null,
          event: FunctionNames.eventFrameSourceStateChanged,
        );
      },
      'onStateChanged',
      'CameraSwitchController',
    );
    if (payload == null || payload.cameraPosition == null) return;

    final FrameSourceState state;
    final CameraPosition cameraPosition;
    try {
      state = FrameSourceState.fromJSON(payload.state);
      cameraPosition = CameraPosition.fromJSON(payload.cameraPosition!);
    } catch (e) {
      developer.log('CameraSwitchController onStateChanged: unrecognised state or cameraPosition: $e');
      return;
    }

    // A transition state must never become a desiredState: native asserts
    // !isTransition(desiredState) and aborts, which crashed the app on SDC-21252. `off` is
    // settled but also excluded — a camera reports it whenever it stops, including a restart the
    // app asked to end in `on`. The outgoing camera's `off` is set by DataCaptureContext instead.
    if (state != FrameSourceState.on && state != FrameSourceState.standby) return;

    final Camera reportedCamera;
    if (cameraPosition == _primaryCamera.position) {
      reportedCamera = _primaryCamera;
    } else if (cameraPosition == _secondaryCamera.position) {
      reportedCamera = _secondaryCamera;
    } else {
      return;
    }

    // Unconditional, including for the camera Dart already holds active: adding the control
    // starts the primary camera on Android, so an `on` legitimately arrives for it.
    reportedCamera.adoptDesiredState(state);
  }

  void dispose() {
    _sub?.cancel();
    _sub = null;
    _retainedContext?.releaseContextEvents();
  }
}
