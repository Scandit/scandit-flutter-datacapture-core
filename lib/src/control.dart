/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:flutter/widgets.dart';

import 'common.dart';
import 'defaults.dart';
import 'function_names.dart';
import 'internal/base_controller.dart';
import 'internal/generated/core_method_handler.dart';
import 'internal/view_attachable.dart';
import 'source/zoom_switch_orientation.dart';
import 'widget_to_base64_converter.dart';

abstract class Control extends Serializable {}

class TorchSwitchControl implements Control {
  TorchSwitchControl();

  Image? _torchOffImage;
  String? _torchOffBase64Image;

  Image? _torchOffPressedImage;
  String? _torchOffPressedBase64Image;

  Image? _torchOnImage;
  String? _torchOnBase64Image;

  Image? _torchOnPressedImage;
  String? _torchOnPressedBase64Image;

  String? accessibilityLabelWhenOff;
  String? accessibilityHintWhenOff;
  String? accessibilityLabelWhenOn;
  String? accessibilityHintWhenOn;

  Image? get torchOffImage => _torchOffImage;
  Future<void> setTorchOffImage(Image? image) async {
    _torchOffImage = image;
    _torchOffBase64Image = await _torchOffImage?.base64String;
  }

  Image? get torchOffPressedImage => _torchOffPressedImage;
  Future<void> setTorchOffPressedImage(Image? image) async {
    _torchOffPressedImage = image;
    _torchOffPressedBase64Image = await _torchOffPressedImage?.base64String;
  }

  Image? get torchOnImage => _torchOnImage;
  Future<void> setTorchOnImage(Image? image) async {
    _torchOnImage = image;
    _torchOnBase64Image = await _torchOnImage?.base64String;
  }

  Image? get torchOnPressedImage => _torchOnPressedImage;
  Future<void> setTorchOnPressedImage(Image? image) async {
    _torchOnPressedImage = image;
    _torchOnPressedBase64Image = await _torchOnPressedImage?.base64String;
  }

  @override
  Map<String, dynamic> toMap() {
    var json = <String, dynamic>{
      'type': 'torch',
      'icon': {
        'on': {'default': _torchOnBase64Image, 'pressed': _torchOnPressedBase64Image},
        'off': {'default': _torchOffBase64Image, 'pressed': _torchOffPressedBase64Image}
      }
    };
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

class ZoomSwitchControl with ViewAttachable, PrivateZoomSwitchControl implements Control {
  // v2 properties
  ZoomSwitchOrientation orientation = Defaults.zoomSwitchControlDefaults.orientation;
  bool isAlwaysExpanded = Defaults.zoomSwitchControlDefaults.isAlwaysExpanded;
  bool isExpanded = Defaults.zoomSwitchControlDefaults.isExpanded;
  String accessibilityLabel = Defaults.zoomSwitchControlDefaults.accessibilityLabel;
  String accessibilityHint = Defaults.zoomSwitchControlDefaults.accessibilityHint;

  double _selectedZoomLevel = 1.0;
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

  @Deprecated('Use accessibilityLabel instead.')
  String? contentDescriptionWhenZoomedOut;
  @Deprecated('Use accessibilityLabel instead.')
  String? contentDescriptionWhenZoomedIn;
  @Deprecated('Use accessibilityLabel instead.')
  String? accessibilityLabelWhenZoomedOut;
  @Deprecated('Use accessibilityLabel instead.')
  String? accessibilityLabelWhenZoomedIn;
  @Deprecated('Use accessibilityHint instead.')
  String? accessibilityHintWhenZoomedOut;
  @Deprecated('Use accessibilityHint instead.')
  String? accessibilityHintWhenZoomedIn;

  ZoomSwitchControl();

  @Deprecated('Use CameraSettings.zoomLevels instead.')
  Image? get zoomedOutImage => _zoomedOutImage;
  @Deprecated('Use CameraSettings.zoomLevels instead.')
  Future<void> setZoomedOutImage(Image? image) async {
    _zoomedOutImage = image;
    _zoomedOutBase64Image = await image?.base64String;
  }

  @Deprecated('Use CameraSettings.zoomLevels instead.')
  Image? get zoomedOutPressedImage => _zoomedOutPressedImage;
  @Deprecated('Use CameraSettings.zoomLevels instead.')
  Future<void> setZoomedOutPressedImage(Image? image) async {
    _zoomedOutPressedImage = image;
    _zoomedOutPressedBase64Image = await image?.base64String;
  }

  @Deprecated('Use CameraSettings.zoomLevels instead.')
  Image? get zoomedInImage => _zoomedInImage;
  @Deprecated('Use CameraSettings.zoomLevels instead.')
  Future<void> setZoomedInImage(Image? image) async {
    _zoomedInImage = image;
    _zoomedInBase64Image = await image?.base64String;
  }

  @Deprecated('Use CameraSettings.zoomLevels instead.')
  Image? get zoomedInPressedImage => _zoomedInPressedImage;
  @Deprecated('Use CameraSettings.zoomLevels instead.')
  Future<void> setZoomedInPressedImage(Image? image) async {
    _zoomedInPressedImage = image;
    _zoomedInPressedBase64Image = await image?.base64String;
  }

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
