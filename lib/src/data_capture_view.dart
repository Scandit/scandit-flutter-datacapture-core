/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/event_stream_extensions.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/generated/core_method_handler.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/core_plugin_events.dart';

import 'control.dart';
import 'common.dart' as common;
import 'data_capture_context.dart';
import 'defaults.dart';
import 'focus_gesture.dart';
import 'function_names.dart';
import 'internal/view_attachable.dart';
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

  // ignore: use_super_parameters - docs wants it written this way
  DataCaptureView({
    required DataCaptureContext dataCaptureContext,
    common.MarginsWithUnit? scanAreaMargins,
    common.PointWithUnit? pointOfInterest,
    common.Anchor? logoAnchor,
    common.PointWithUnit? logoOffset,
    FocusGesture? focusGesture,
    ZoomGesture? zoomGesture,
    LogoStyle? logoStyle,
    bool? shouldShowZoomNotification,
    List<Control>? controls,
    List<DataCaptureOverlay>? overlays,
    Key? key,
  })  : _dataCaptureContext = dataCaptureContext,
        super(key: key) {
    _dataCaptureContext?.view = this;
    if (scanAreaMargins != null) _scanAreaMargins = scanAreaMargins;
    if (pointOfInterest != null) _pointOfInterest = pointOfInterest;
    if (logoAnchor != null) _logoAnchor = logoAnchor;
    if (logoOffset != null) _logoOffset = logoOffset;
    if (focusGesture != null) _focusGesture = focusGesture;
    if (zoomGesture != null) _zoomGesture = zoomGesture;
    if (logoStyle != null) _logoStyle = logoStyle;
    if (shouldShowZoomNotification != null) _shouldShowZoomNotification = shouldShowZoomNotification;
    if (controls != null) _controls.addAll(controls);
    if (overlays != null) {
      for (var overlay in overlays) {
        _overlays.add(overlay);
        overlay.view = this;
      }
    }
    // Register the focusGesture (either provided or default) as an attachable
    if (_focusGesture != null) {
      registerAttachable(_focusGesture!);
    }
    if (_zoomGesture != null) {
      registerAttachable(_zoomGesture!);
    }
  }

  factory DataCaptureView.forContext(DataCaptureContext dataCaptureContext) {
    return DataCaptureView(dataCaptureContext: dataCaptureContext);
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
    if (_focusGesture != null) {
      unregisterAttachable(_focusGesture!);
    }
    _focusGesture = newValue;
    if (newValue != null) {
      registerAttachable(newValue);
    }
    _update();
  }

  ZoomGesture? get zoomGesture {
    return _zoomGesture;
  }

  set zoomGesture(ZoomGesture? newValue) {
    if (_zoomGesture != null) {
      unregisterAttachable(_zoomGesture!);
    }
    _zoomGesture = newValue;
    if (newValue != null) {
      registerAttachable(newValue);
    }
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
    overlay.view = this;
    return _update();
  }

  Future<void> removeOverlay(DataCaptureOverlay overlay) {
    if (!_overlays.contains(overlay)) {
      return Future.value(null);
    }
    _overlays.remove(overlay);
    overlay.view = null;
    return _update();
  }

  void addListener(DataCaptureViewListener listener) {
    if (_listeners.isEmpty) {
      _controller?._registerListener();
    }

    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  void removeListener(DataCaptureViewListener listener) {
    _listeners.remove(listener);

    if (_listeners.isEmpty) {
      _controller?._unregisterListener();
    }
  }

  Future<common.Point> viewPointForFramePoint(common.Point point) {
    return _controller?.viewPointForFramePoint(point) ?? Future.error(Exception('DataCaptureView not initialized'));
  }

  Future<common.Quadrilateral> viewQuadrilateralForFrameQuadrilateral(common.Quadrilateral quadrilateral) {
    return _controller?.viewQuadrilateralForFrameQuadrilateral(quadrilateral) ??
        Future.error(Exception('DataCaptureView not initialized'));
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

  bool get shouldShowZoomNotification {
    return _shouldShowZoomNotification;
  }

  set shouldShowZoomNotification(bool newValue) {
    _shouldShowZoomNotification = newValue;
    _update();
  }
}

class _DataCaptureViewController extends BaseController {
  late final CoreMethodHandler coreMethodHandler;
  StreamSubscription? _streamSubscription;

  final int _viewId;

  final DataCaptureView _view;

  _DataCaptureViewController(this._viewId, this._view) : super(FunctionNames.methodsChannelName) {
    coreMethodHandler = CoreMethodHandler(methodChannel);
  }

  void _registerListener() {
    _unregisterListener();

    _streamSubscription = CorePluginEvents.coreEventStream.asFlutterEvents().forView(_viewId).listen((event) {
      if (event.isEvent(FunctionNames.eventDataCaptureViewSizeChanged)) {
        var size = common.Size.fromJSON(event.payload['size']);
        var orientation = common.OrientationDeserializer.fromJSON(event.payload['orientation']);
        _notifyListenersOfViewDidChangeSize(size, orientation);
      }
    });
  }

  void _unregisterListener() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
  }

  void _notifyListenersOfViewDidChangeSize(common.Size size, common.Orientation orientation) {
    for (var listener in _view._listeners) {
      listener.didChangeSize(_view, size, orientation);
    }
  }

  Future<common.Point> viewPointForFramePoint(common.Point point) {
    return coreMethodHandler
        .viewPointForFramePoint(viewId: _viewId, pointJson: jsonEncode(point.toMap()))
        .then((value) => common.Point.fromJSON(jsonDecode(value)));
  }

  Future<common.Quadrilateral> viewQuadrilateralForFrameQuadrilateral(common.Quadrilateral quadrilateral) {
    return coreMethodHandler
        .viewQuadrilateralForFrameQuadrilateral(viewId: _viewId, quadrilateralJson: jsonEncode(quadrilateral.toMap()))
        .then((value) => common.Quadrilateral.fromJSON(jsonDecode(value)));
  }

  Future<void> update(String viewJson) {
    return coreMethodHandler.updateDataCaptureView(viewJson: viewJson).onError(_onError);
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
  bool _shouldShowZoomNotification = Defaults.captureViewDefaults.shouldShowZoomNotification ?? true;
  final Map<String, dynamic> _properties = {};

  _DataCaptureViewController? _controller;

  FocusGesture? _focusGesture = Defaults.captureViewDefaults.focusGesture;
  ZoomGesture? _zoomGesture = Defaults.captureViewDefaults.zoomGesture;
  final List<DataCaptureOverlay> _overlays = [];

  final List<ViewAttachable> _attachables = [];

  /// Registers a [ViewAttachable] component with this view.
  ///
  /// If the view is already initialized, [ViewAttachable.onViewInitialized]
  /// will be called immediately. Otherwise, it will be called when
  /// the view's controller is ready.
  void registerAttachable(ViewAttachable attachable) {
    if (_attachables.contains(attachable)) return;

    _attachables.add(attachable);
    attachable.onAttachToView(this as DataCaptureView);

    if (_controller != null) {
      attachable.onViewInitialized(viewId);
    }
  }

  /// Unregisters a [ViewAttachable] component from this view.
  void unregisterAttachable(ViewAttachable attachable) {
    if (_attachables.remove(attachable)) {
      attachable.onDetachFromView();
    }
  }

  /// Called when the view's controller is initialized.
  /// Notifies all registered attachables that the viewId is available.
  void _initializeAttachables() {
    for (final attachable in _attachables) {
      attachable.onViewInitialized(viewId);
    }
  }

  void removeAllOverlays() {
    _overlays.clear();
    _update();
  }

  bool _isViewCreated = false;

  Future<void> _update() {
    if (!_isViewCreated) {
      return Future.value(null);
    }
    var viewJson = jsonEncode(toMap());
    return _controller?.update(viewJson) ?? Future.value(null);
  }

  void _onViewCreated() {
    _isViewCreated = true;
    _update();
  }

  int get viewId => _controller?._viewId ?? -1;

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
      'shouldShowZoomNotification': _shouldShowZoomNotification,
      'overlays': _overlays.map((overlay) => overlay.toMap()).toList(),
      'viewId': _controller?._viewId ?? 0,
    };

    for (var prop in _properties.entries) {
      json[prop.key] = prop.value;
    }

    return json;
  }
}

class _DataCaptureViewState extends State<DataCaptureView> {
  final int _viewId = Random().nextInt(0x7FFFFFFF);

  late _DataCaptureViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = _DataCaptureViewController(_viewId, widget);
    widget._controller = _controller;
    widget._initializeAttachables();
  }

  @override
  void didUpdateWidget(DataCaptureView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget._dataCaptureContext != widget._dataCaptureContext) {
      oldWidget._dataCaptureContext?.view = null;
      widget._dataCaptureContext?.view = widget;
      widget._update();
    }

    if (oldWidget._scanAreaMargins != widget._scanAreaMargins) {
      widget._update();
    }

    if (oldWidget._pointOfInterest != widget._pointOfInterest) {
      widget._update();
    }

    if (oldWidget._logoAnchor != widget._logoAnchor) {
      widget._update();
    }

    if (oldWidget._logoOffset != widget._logoOffset) {
      widget._update();
    }

    if (oldWidget._focusGesture != widget._focusGesture) {
      widget._update();
    }

    if (oldWidget._zoomGesture != widget._zoomGesture) {
      widget._update();
    }

    if (oldWidget._logoStyle != widget._logoStyle) {
      widget._update();
    }

    if (oldWidget._shouldShowZoomNotification != widget._shouldShowZoomNotification) {
      widget._update();
    }

    if (oldWidget._controls != widget._controls) {
      widget._update();
    }

    if (oldWidget._overlays != widget._overlays) {
      for (var overlay in oldWidget._overlays) {
        overlay.view = null;
      }
      for (var overlay in widget._overlays) {
        overlay.view = widget;
      }
      widget._update();
    }
  }

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
            creationParams: {'DataCaptureView': jsonEncode(widget.toMap())},
            creationParamsCodec: const StandardMessageCodec(),
            onFocus: () {
              params.onFocusChanged(true);
            },
          )
            ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
            ..addOnPlatformViewCreatedListener((int id) {
              widget._onViewCreated();
            })
            ..create();
        },
      );
    } else {
      return UiKitView(
        viewType: viewType,
        creationParams: {'DataCaptureView': jsonEncode(widget.toMap())},
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (int id) {
          widget._onViewCreated();
        },
      );
    }
  }
}
