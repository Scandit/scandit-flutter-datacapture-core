/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'control.dart';
import 'common.dart' as common;
import 'data_capture_context.dart';
import 'defaults.dart';
import 'focus_gesture.dart';
import 'function_names.dart';
import 'zoom_gesture.dart';
import 'logo_style.dart';

abstract class DataCaptureOverlay extends common.Serializable {
  final String _type;

  DataCaptureView? get view;

  set view(DataCaptureView? newValue);

  DataCaptureOverlay(this._type);

  @override
  Map<String, dynamic> toMap() {
    return {'type': _type};
  }
}

abstract class DataCaptureViewListener {
  void didChangeSize(DataCaptureView view, common.Size size, common.Orientation orientation);
}

// ignore: must_be_immutable
class DataCaptureView extends StatefulWidget with PrivateDataCaptureView {
  PrivateDataCaptureContext? _dataCaptureContext;

  final EventChannel _viewDidChangeSizeEventChannel = const EventChannel(FunctionNames.eventsChannelName);

  StreamSubscription? _streamSubscription;

  DataCaptureView._(this._dataCaptureContext) : super() {
    _controller = _DataCaptureViewController();
    _dataCaptureContext?.view = this;
  }

  factory DataCaptureView.forContext(DataCaptureContext dataCaptureContext) {
    return DataCaptureView._(dataCaptureContext);
  }

  @override
  State<StatefulWidget> createState() => _DataCaptureViewState();

  DataCaptureContext? get dataCaptureContext {
    return _dataCaptureContext as DataCaptureContext?;
  }

  set dataCaptureContext(DataCaptureContext? newValue) {
    _dataCaptureContext = newValue;

    _dataCaptureContext?.view = this;
    _update();
  }

  common.MarginsWithUnit get scanAreaMargins {
    return _scanAreaMargins;
  }

  set scanAreaMargins(common.MarginsWithUnit newValue) {
    _scanAreaMargins = newValue;
    _update();
  }

  common.PointWithUnit get pointOfInterest {
    return _pointOfInterest;
  }

  set pointOfInterest(common.PointWithUnit newValue) {
    _pointOfInterest = newValue;
    _update();
  }

  common.Anchor get logoAnchor {
    return _logoAnchor;
  }

  set logoAnchor(common.Anchor newValue) {
    _logoAnchor = newValue;
    _update();
  }

  common.PointWithUnit get logoOffset {
    return _logoOffset;
  }

  set logoOffset(common.PointWithUnit newValue) {
    _logoOffset = newValue;
    _update();
  }

  FocusGesture? get focusGesture {
    return _focusGesture;
  }

  set focusGesture(FocusGesture? newValue) {
    _focusGesture = newValue;
    _update();
  }

  ZoomGesture? get zoomGesture {
    return _zoomGesture;
  }

  set zoomGesture(ZoomGesture? newValue) {
    _zoomGesture = newValue;
    _update();
  }

  void setProperty<T>(String name, T value) {
    _properties[name] = value;
  }

  Future<void> addOverlay(DataCaptureOverlay overlay) {
    if (_overlays.contains(overlay)) {
      return Future.value(null);
    }
    _overlays.add(overlay);
    return _update();
  }

  Future<void> removeOverlay(DataCaptureOverlay overlay) {
    if (!_overlays.contains(overlay)) {
      return Future.value(null);
    }
    _overlays.remove(overlay);
    return _update();
  }

  void addListener(DataCaptureViewListener listener) {
    if (_listeners.isEmpty) {
      _registerListener();
    }

    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  void removeListener(DataCaptureViewListener listener) {
    _listeners.remove(listener);

    if (_listeners.isEmpty) {
      _unregisterListener();
    }
  }

  Future<common.Point> viewPointForFramePoint(common.Point point) {
    return _controller._viewPointForFramePoint(point);
  }

  Future<common.Quadrilateral> viewQuadrilateralForFrameQuadrilateral(common.Quadrilateral quadrilateral) {
    return _controller._viewQuadrilateralForFrameQuadrilateral(quadrilateral);
  }

  void _registerListener() {
    _unregisterListener();
    _streamSubscription = _viewDidChangeSizeEventChannel.receiveBroadcastStream().listen((event) {
      var eventJSON = jsonDecode(event as String);
      var eventName = eventJSON['event'] as String;

      if (eventName == FunctionNames.eventDataCaptureViewSizeChanged) {
        var size = common.Size.fromJSON(eventJSON['size']);
        var orientation = common.OrientationDeserializer.fromJSON(eventJSON['orientation']);
        _notifyListenersOfViewDidChangeSize(size, orientation);
      }
    });
  }

  void _unregisterListener() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
  }

  void _notifyListenersOfViewDidChangeSize(common.Size size, common.Orientation orientation) {
    for (var listener in _listeners) {
      listener.didChangeSize(this, size, orientation);
    }
  }

  Future<void> addControl(Control control) {
    if (!_controls.contains(control)) {
      _controls.add(control);
      return _update();
    }
    return Future.value(null);
  }

  Future<void> removeControl(Control control) {
    if (_controls.remove(control)) {
      return _update();
    }
    return Future.value(null);
  }

  set logoStyle(LogoStyle newValue) {
    _logoStyle = newValue;
    _update();
  }

  LogoStyle get logoStyle => _logoStyle;
}

class _DataCaptureViewController {
  final MethodChannel _methodChannel = Defaults.channel;

  _DataCaptureViewController();

  Future<common.Point> _viewPointForFramePoint(common.Point point) {
    var args = jsonEncode(point.toMap());
    return _methodChannel
        .invokeMethod(FunctionNames.viewPointForFramePoint, args)
        .then((value) => common.Point.fromJSON(jsonDecode(value)));
  }

  Future<common.Quadrilateral> _viewQuadrilateralForFrameQuadrilateral(common.Quadrilateral quadrilateral) {
    var args = jsonEncode(quadrilateral.toMap());
    return _methodChannel
        .invokeMethod(FunctionNames.viewQuadrilateralForFrameQuadrilateral, args)
        .then((value) => common.Quadrilateral.fromJSON(jsonDecode(value)));
  }

  Future<void> update(String viewJson) {
    return _methodChannel.invokeMethod(FunctionNames.updateDataCaptureView, viewJson).onError(_onError);
  }

  void _onError(Object? error, StackTrace? stackTrace) {
    if (error == null) return;
    throw error;
  }
}

mixin PrivateDataCaptureView implements common.Serializable {
  common.MarginsWithUnit _scanAreaMargins = Defaults.captureViewDefaults.scanAreaMargins;
  common.PointWithUnit _pointOfInterest = Defaults.captureViewDefaults.pointOfInterest;
  common.Anchor _logoAnchor = Defaults.captureViewDefaults.logoAnchor;
  common.PointWithUnit _logoOffset = Defaults.captureViewDefaults.logoOffset;
  final List<DataCaptureViewListener> _listeners = [];
  final List<Control> _controls = [];
  LogoStyle _logoStyle = Defaults.captureViewDefaults.logoStyle;
  final Map<String, dynamic> _properties = {};
  late _DataCaptureViewController _controller;

  FocusGesture? _focusGesture = Defaults.captureViewDefaults.focusGesture;
  ZoomGesture? _zoomGesture = Defaults.captureViewDefaults.zoomGesture;
  final List<DataCaptureOverlay> _overlays = [];

  void removeAllOverlays() {
    _overlays.clear();
    _update();
  }

  bool _isViewCreated = false;

  Future<void> _update() {
    if (_isViewCreated == false) {
      return Future.value(null);
    }
    var viewJson = jsonEncode(toMap());
    return _controller.update(viewJson);
  }

  @override
  Map<String, dynamic> toMap() {
    var json = <String, dynamic>{
      'scanAreaMargins': _scanAreaMargins.toMap(),
      'pointOfInterest': _pointOfInterest.toMap(),
      'logoAnchor': _logoAnchor.toString(),
      'logoOffset': _logoOffset.toMap(),
      'focusGesture': _focusGesture?.toMap(),
      'zoomGesture': _zoomGesture?.toMap(),
      'controls': _controls.map((e) => e.toMap()).toList(),
      'logoStyle': _logoStyle.toString(),
      'overlays': _overlays.map((overlay) => overlay.toMap()).toList(),
    };

    for (var prop in _properties.entries) {
      json[prop.key] = prop.value;
    }

    return json;
  }
}

class _DataCaptureViewState extends State<DataCaptureView> {
  @override
  Widget build(BuildContext context) {
    const viewType = 'com.scandit.DataCaptureView';

    if (Platform.isAndroid) {
      return PlatformViewLink(
        viewType: viewType,
        surfaceFactory: (context, controller) {
          return AndroidViewSurface(
            controller: controller as AndroidViewController,
            gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
          );
        },
        onCreatePlatformView: (params) {
          return PlatformViewsService.initSurfaceAndroidView(
            id: params.id,
            viewType: viewType,
            layoutDirection: TextDirection.ltr,
            creationParams: {"DataCaptureView": jsonEncode(widget.toMap())},
            creationParamsCodec: const StandardMessageCodec(),
            onFocus: () {
              params.onFocusChanged(true);
            },
          )
            ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
            ..addOnPlatformViewCreatedListener((int id) {
              widget._isViewCreated = true;
            })
            ..create();
        },
      );
    } else {
      return UiKitView(
        viewType: viewType,
        creationParams: {"DataCaptureView": jsonEncode(widget.toMap())},
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (int id) {
          widget._isViewCreated = true;
        },
      );
    }
  }
}
