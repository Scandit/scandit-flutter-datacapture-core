/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/event_stream_extensions.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/flutter_event.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/generated/core_method_handler.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/core_plugin_events.dart';

import 'control.dart';
import 'common.dart' as common;
import 'data_capture_context.dart';
import 'defaults.dart';
import 'focus_gesture.dart';
import 'function_names.dart';
import 'internal/generated/schema_types.dart' as schema;
import 'internal/tolerant_payload_parser.dart';
import 'internal/view_attachable.dart';
import 'zoom_gesture.dart';
import 'logo_style.dart';

/// A capture mode overlay is the UI counterpart of capture modes and visualizes the recognition process in the graphical user interface. Overlays highlight objects such as identified barcodes on top of the preview. Overlays may add UI elements to guide the user, such as view finders.
///
/// Capture mode overlays are added to a [DataCaptureView] through [DataCaptureView.addOverlay] and removed again through [DataCaptureView.removeOverlay]. Overlays are associated to the data capture modes they require when they are constructed.
///
/// Overlays are restricted to the set of overlays provided by the Scandit Data Capture SDK, it is not possible for customers to implement this interface and provide custom overlays. This interface does not expose any methods or properties, it just serves as a tag for different overlays.
///
/// Added in version 6.7.0
abstract class DataCaptureOverlay extends common.Serializable {
  final String _type;

  /// The view this data capture overlay is attached to. When the data capture overlay is currently not attached to a view, *null* is returned.
  ///
  /// Added in version 6.7.0
  DataCaptureView? get view;

  /// The view this data capture overlay is attached to. When the data capture overlay is currently not attached to a view, *null* is returned.
  ///
  /// Added in version 6.7.0
  set view(DataCaptureView? newValue);

  DataCaptureOverlay(this._type);

  @override
  Map<String, dynamic> toMap() {
    return {'type': _type};
  }
}

/// Overlay that draws a color across the full view. The overlay fill color can be configured through the [ColorFillOverlay.color] property.
///
/// Added in version 8.7.0
class ColorFillOverlay extends DataCaptureOverlay {
  DataCaptureView? _view;

  Color _color;

  // Default in the body, not the signature: the docs signature collector emits default expressions.
  /// Creates a new [ColorFillOverlay] instance with the specified color. On the JavaScript frameworks and Flutter the parameter is optional and defaults to transparent.
  ///
  /// Added in version 8.7.0
  ColorFillOverlay({Color? color})
      : _color = color ?? const Color(0x00000000),
        super('colorFill');

  /// The fill color for this core capture overlay.
  ///
  /// Added in version 8.7.0
  Color get color => _color;

  /// The fill color for this core capture overlay.
  ///
  /// Added in version 8.7.0
  set color(Color newValue) {
    _color = newValue;
    // The native overlay key is the constant `colorFill:-1`, so only a re-serialized view carries it.
    _view?._update();
  }

  /// The view this data capture overlay is attached to. When the data capture overlay is currently not attached to a view, *null* is returned.
  ///
  /// Added in version 8.7.0
  @override
  DataCaptureView? get view => _view;

  /// The view this data capture overlay is attached to. When the data capture overlay is currently not attached to a view, *null* is returned.
  ///
  /// Added in version 8.7.0
  @override
  set view(DataCaptureView? newValue) {
    _view = newValue;
  }

  @override
  Map<String, dynamic> toMap() {
    return {'type': _type, 'color': common.ColorDeserializer(_color).jsonValue};
  }
}

/// Listener for observing the data capture view. This listener is typically used when you want to react to orientation and size changes, e.g. to adjust view finder and scan area parameters.
///
/// Added in version 6.7.0
abstract class DataCaptureViewListener {
  /// Invoked when the data capture view changes size or orientation.
  ///
  /// Added in version 6.7.0
  void didChangeSize(DataCaptureView view, common.Size size, common.Orientation orientation);
}

/// The capture view is the main UI view to be used together with the data capture context for applications that wish to display a video preview together with additional augmentations such as barcode locations.
///
/// The data capture view itself only displays the preview and shows UI elements to control the camera, such as buttons to switch torch on and off, or a button to switch between front and back facing cameras. Augmentations, such as the locations of identified barcodes are provided by individual overlays. This view will also display errors in case something goes wrong with its context, see the [ContextStatus] for a list of possible errors.
///
/// Unless otherwise specified, methods and properties of this class should only be accessed from the main thread.
///
/// **Related topics**: [Get Started](https://docs.scandit.com/sdks/flutter/barcode-capture/get-started), [MatrixScan Get Started](https://docs.scandit.com/sdks/flutter/matrixscan/get-started), Core Concepts <https://docs.scandit.com/core-concepts>.
///
/// Added in version 6.7.0
class DataCaptureView extends StatefulWidget with PrivateDataCaptureView {
  PrivateDataCaptureContext? get _dataCaptureContext => _mutableConfig.dataCaptureContext;

  set _dataCaptureContext(PrivateDataCaptureContext? newValue) => _mutableConfig.dataCaptureContext = newValue;

  // ignore: use_super_parameters - docs wants it written this way
  /// Initializes a new data capture view with configurable parameters following Flutter’s declarative widget pattern. This constructor allows you to configure all view properties at construction time.
  ///
  /// All parameters except `dataCaptureContext` are optional and will use default values if not provided.
  ///
  /// The view automatically reacts to parameter changes when rebuilt with different values, updating the native layer accordingly.
  ///
  /// **Parameters:**
  ///
  /// - `dataCaptureContext` (required): The data capture context to associate with this view.
  /// - `scanAreaMargins`: The margins to use for the scan area. Defaults to zero margins.
  /// - `pointOfInterest`: The point of interest for focus and recognition optimization. Defaults to the center of the view.
  /// - `logoAnchor`: The anchor point for positioning the Scandit logo. Defaults to [Anchor.bottomRight].
  /// - `logoOffset`: The offset applied to the logo relative to its anchor. Defaults to zero offset.
  /// - `focusGesture`: The gesture used to focus. Defaults to [TapToFocus].
  /// - `zoomGesture`: *Deprecated since 8.4.* The gesture used to zoom. Use `zoomGestures` instead.
  /// - `zoomGestures`: The gestures used to zoom. Defaults to [[SwipeToZoom], [PinchToZoom]]. Set to an empty list if no zoom gesture is desired. Takes precedence over `zoomGesture`.
  /// - `logoStyle`: The style of the logo. Defaults to the extended “Scanning By Scandit” style.
  /// - `controls`: A list of controls to add to the view (e.g., [TorchSwitchControl]). Defaults to no controls.
  /// - `overlays`: A list of overlays to add to the view (e.g., BarcodeCaptureOverlay, BarcodeBatchBasicOverlay). Defaults to no overlays.
  /// - `key`: An optional key to use for this widget, following Flutter’s widget identity system.
  ///
  /// ```dart
  /// // Minimal usage
  /// DataCaptureView(
  ///   dataCaptureContext: context,
  /// )
  ///
  /// // With custom configuration
  /// DataCaptureView(
  ///   dataCaptureContext: context,
  ///   scanAreaMargins: MarginsWithUnit(
  ///     left: DoubleWithUnit(0.1, MeasureUnit.fraction),
  ///     right: DoubleWithUnit(0.1, MeasureUnit.fraction),
  ///     top: DoubleWithUnit(0.2, MeasureUnit.fraction),
  ///     bottom: DoubleWithUnit(0.2, MeasureUnit.fraction),
  ///   ),
  ///   controls: [TorchSwitchControl()],
  ///   overlays: [
  ///     BarcodeCaptureOverlay(barcodeCapture),
  ///   ],
  ///   focusGesture: TapToFocus(),
  ///   zoomGestures: [SwipeToZoom(), PinchToZoom()],
  ///   logoStyle: LogoStyle.minimal,
  ///   logoAnchor: Anchor.bottomRight,
  /// )
  /// ```
  ///
  /// Added in version 8.2.0
  DataCaptureView({
    required DataCaptureContext dataCaptureContext,
    common.MarginsWithUnit? scanAreaMargins,
    common.PointWithUnit? pointOfInterest,
    common.Anchor? logoAnchor,
    common.PointWithUnit? logoOffset,
    FocusGesture? focusGesture,
    ZoomGesture? zoomGesture,
    List<ZoomGesture>? zoomGestures,
    LogoStyle? logoStyle,
    bool? shouldShowZoomNotification,
    List<Control>? controls,
    List<DataCaptureOverlay>? overlays,
    Key? key,
  }) : super(key: key) {
    // Before anything is attached, so a rejection leaves no overlay or context pointing here.
    var duplicateColorFill = _duplicateColorFillOverlayError(overlays ?? const []);
    if (duplicateColorFill != null) throw duplicateColorFill;
    _dataCaptureContext = dataCaptureContext;
    _dataCaptureContext?.view = this;
    if (scanAreaMargins != null) _scanAreaMargins = scanAreaMargins;
    if (pointOfInterest != null) _pointOfInterest = pointOfInterest;
    if (logoAnchor != null) _logoAnchor = logoAnchor;
    if (logoOffset != null) _logoOffset = logoOffset;
    if (focusGesture != null) _focusGesture = focusGesture;
    // zoomGestures takes precedence; fall back to wrapping singular zoomGesture
    if (zoomGestures != null) {
      _zoomGestures = List.of(zoomGestures);
    } else if (zoomGesture != null) {
      _zoomGestures = [zoomGesture];
    }
    if (logoStyle != null) _logoStyle = logoStyle;
    if (shouldShowZoomNotification != null) _shouldShowZoomNotification = shouldShowZoomNotification;
    if (controls != null) {
      _controls.addAll(controls);
      // Constructor controls need the registration addControl performs, or a ViewAttachable
      // control never receives onViewInitialized and whatever it sets up never starts.
      for (final control in controls) {
        if (control is ViewAttachable) registerAttachable(control as ViewAttachable);
      }
    }
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
    for (final gesture in _zoomGestures) {
      registerAttachable(gesture);
    }
  }

  factory DataCaptureView.forContext(DataCaptureContext dataCaptureContext) {
    return DataCaptureView(dataCaptureContext: dataCaptureContext);
  }

  /// Implemented from [StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html). Called by the Flutter framework.
  ///
  /// Added in version 6.7.0
  @override
  State<StatefulWidget> createState() => _DataCaptureViewState();

  /// The data capture context of this capture view. This property must be set to an instance of the data capture context for this view to display anything.
  ///
  /// When the capture context is attached to a data capture view, it is removed from any other data capture view it was attached to.
  ///
  /// Added in version 6.7.0
  DataCaptureContext? get dataCaptureContext {
    return _dataCaptureContext as DataCaptureContext?;
  }

  /// The data capture context of this capture view. This property must be set to an instance of the data capture context for this view to display anything.
  ///
  /// When the capture context is attached to a data capture view, it is removed from any other data capture view it was attached to.
  ///
  /// Added in version 6.7.0
  set dataCaptureContext(DataCaptureContext? newValue) {
    _dataCaptureContext = newValue;

    _dataCaptureContext?.view = this;
    _update();
  }

  /// The margins to use for the scan area. The margins are measured from the border of the data capture view and allow to specify a region around the border that is excluded from scanning.
  ///
  /// By default, the margins are zero and the scanning happens in the visible part of the preview.
  ///
  /// On iOS, the scan area also excludes the left and right safe area insets of the view: on each side, the larger of the margin and the inset applies. This property keeps returning the margins that were set.
  ///
  /// Added in version 6.7.0
  common.MarginsWithUnit get scanAreaMargins {
    return _scanAreaMargins;
  }

  /// The margins to use for the scan area. The margins are measured from the border of the data capture view and allow to specify a region around the border that is excluded from scanning.
  ///
  /// By default, the margins are zero and the scanning happens in the visible part of the preview.
  ///
  /// On iOS, the scan area also excludes the left and right safe area insets of the view: on each side, the larger of the margin and the inset applies. This property keeps returning the margins that were set.
  ///
  /// Added in version 6.7.0
  set scanAreaMargins(common.MarginsWithUnit newValue) {
    _scanAreaMargins = newValue;
    _update();
  }

  /// The point of interest of this data capture view. By default, the point of interest is centered in the data capture view. The point of interest is used to control the *center of attention* for the following subsystems:
  ///
  /// - Auto focus and exposure metering of the camera.
  /// - Location selections ([LocationSelection]) for capture modes that support them. When no location selection is set, the point of interest defines the location at which the recognition optimizes for reading codes/text/etc.
  /// - Rendered viewfinders ([Viewfinder]).
  ///
  /// The point of interest can be overwritten by individual capture modes such as [BarcodeCapture]. The overwriting point of interest only affects the center of the location selection and viewfinder of said mode, it does not affect the auto focus or exposure metering of the camera.
  ///
  /// Added in version 6.7.0
  common.PointWithUnit get pointOfInterest {
    return _pointOfInterest;
  }

  /// The point of interest of this data capture view. By default, the point of interest is centered in the data capture view. The point of interest is used to control the *center of attention* for the following subsystems:
  ///
  /// - Auto focus and exposure metering of the camera.
  /// - Location selections ([LocationSelection]) for capture modes that support them. When no location selection is set, the point of interest defines the location at which the recognition optimizes for reading codes/text/etc.
  /// - Rendered viewfinders ([Viewfinder]).
  ///
  /// The point of interest can be overwritten by individual capture modes such as [BarcodeCapture]. The overwriting point of interest only affects the center of the location selection and viewfinder of said mode, it does not affect the auto focus or exposure metering of the camera.
  ///
  /// Added in version 6.7.0
  set pointOfInterest(common.PointWithUnit newValue) {
    _pointOfInterest = newValue;
    _update();
  }

  /// The anchor point to use for positioning the “Scanning By Scandit” logo. By default the logo is placed in the lower-right corner of the scan area ([Anchor.bottomRight]).
  ///
  /// To shift the logo relative to the anchor position, use the [DataCaptureView.logoOffset] property.
  ///
  /// This property has no effect when the logo is drawn by one of the viewfinders.
  ///
  /// Added in version 6.7.0
  common.Anchor get logoAnchor {
    return _logoAnchor;
  }

  /// The anchor point to use for positioning the “Scanning By Scandit” logo. By default the logo is placed in the lower-right corner of the scan area ([Anchor.bottomRight]).
  ///
  /// To shift the logo relative to the anchor position, use the [DataCaptureView.logoOffset] property.
  ///
  /// This property has no effect when the logo is drawn by one of the viewfinders.
  ///
  /// Added in version 6.7.0
  set logoAnchor(common.Anchor newValue) {
    _logoAnchor = newValue;
    _update();
  }

  /// The offset applied to the “Scanning By Scandit” logo relative to the logo anchor ([DataCaptureView.logoAnchor]). When specified in pixels ([MeasureUnit.pixel]) or device-independent pixels ([MeasureUnit.dip]), the offset is used as-is. When specified as a fraction ([MeasureUnit.fraction]), the offset is computed relative to the view size minus the scan area margins. For example, a value of 0.1 for the x-coordinate will set the offset to be 10% of the view width minus the left and right margins.
  ///
  /// This property has no effect when the logo is drawn by one of the viewfinders.
  ///
  /// Added in version 6.7.0
  common.PointWithUnit get logoOffset {
    return _logoOffset;
  }

  /// The offset applied to the “Scanning By Scandit” logo relative to the logo anchor ([DataCaptureView.logoAnchor]). When specified in pixels ([MeasureUnit.pixel]) or device-independent pixels ([MeasureUnit.dip]), the offset is used as-is. When specified as a fraction ([MeasureUnit.fraction]), the offset is computed relative to the view size minus the scan area margins. For example, a value of 0.1 for the x-coordinate will set the offset to be 10% of the view width minus the left and right margins.
  ///
  /// This property has no effect when the logo is drawn by one of the viewfinders.
  ///
  /// Added in version 6.7.0
  set logoOffset(common.PointWithUnit newValue) {
    _logoOffset = newValue;
    _update();
  }

  /// The gesture used to focus. Defaults to [TapToFocus]. Set to *null* if no focus gesture is desired.
  ///
  /// Added in version 6.7.0
  FocusGesture? get focusGesture {
    return _focusGesture;
  }

  /// The gesture used to focus. Defaults to [TapToFocus]. Set to *null* if no focus gesture is desired.
  ///
  /// Added in version 6.7.0
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

  /// The gestures used to zoom. Defaults to [[SwipeToZoom], [PinchToZoom]]. Set to empty array if no zoom gesture is desired.
  ///
  /// Added in version 8.4.0
  List<ZoomGesture> get zoomGestures {
    return _zoomGestures;
  }

  /// The gestures used to zoom. Defaults to [[SwipeToZoom], [PinchToZoom]]. Set to empty array if no zoom gesture is desired.
  ///
  /// Added in version 8.4.0
  set zoomGestures(List<ZoomGesture> newValue) {
    for (final gesture in _zoomGestures) {
      unregisterAttachable(gesture);
    }
    _zoomGestures = List.of(newValue);
    for (final gesture in _zoomGestures) {
      registerAttachable(gesture);
    }
    _update();
  }

  /// @deprecated Use [zoomGestures] instead. Will be removed in a future version.
  ///
  /// The gesture used to zoom. Defaults to [SwipeToZoom]. Set to *null* if no zoom gesture is desired.
  ///
  /// Added in version 6.7.0
  ZoomGesture? get zoomGesture {
    return _zoomGesture;
  }

  /// @deprecated Use [zoomGestures] instead. Will be removed in a future version.
  ///
  /// The gesture used to zoom. Defaults to [SwipeToZoom]. Set to *null* if no zoom gesture is desired.
  ///
  /// Added in version 6.7.0
  set zoomGesture(ZoomGesture? newValue) {
    zoomGestures = newValue != null ? [newValue] : [];
  }

  /// Sets a custom property on this data capture view. This function is for internal use. Any features and functionality offered through this method can and will vanish without public notice from one version to the next.
  ///
  /// Added in version 7.0.0
  void setProperty<T>(String name, T value) {
    _properties[name] = value;
  }

  /// Adds the overlay to this data capture view. If the overlay is already part of this view, the call has no effect.
  ///
  /// Added in version 6.7.0
  Future<void> addOverlay(DataCaptureOverlay overlay) {
    if (_overlays.contains(overlay)) {
      return Future.value(null);
    }
    var duplicateColorFill = _duplicateColorFillOverlayError([overlay]);
    if (duplicateColorFill != null) {
      return Future.error(duplicateColorFill);
    }
    _overlays.add(overlay);
    overlay.view = this;
    return _update();
  }

  // A second instance would displace the first under that same constant key, and become unremovable.
  StateError? _duplicateColorFillOverlayError(Iterable<DataCaptureOverlay> incoming) {
    var total = _overlays.whereType<ColorFillOverlay>().length + incoming.whereType<ColorFillOverlay>().length;
    if (total <= 1) {
      return null;
    }
    return StateError('A DataCaptureView can hold only one ColorFillOverlay. '
        'Remove the existing one before adding another, or change its color in place.');
  }

  /// Removes overlay from this data capture view. If the overlay is not part of this view, the call has no effect.
  ///
  /// Added in version 6.7.0
  Future<void> removeOverlay(DataCaptureOverlay overlay) {
    if (!_overlays.contains(overlay)) {
      return Future.value(null);
    }
    _overlays.remove(overlay);
    overlay.view = null;
    return _update();
  }

  /// Adds the listener to this data capture view.
  ///
  /// In case the same listener is already observing this instance, calling this method will not add the listener again.
  ///
  /// Added in version 6.7.0
  void addListener(DataCaptureViewListener listener) {
    if (_listeners.isEmpty) {
      _controller?._registerListener();
    }

    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  /// Removes a previously added listener from this data capture view.
  ///
  /// In case the listener is not currently observing this instance, calling this method has no effect.
  ///
  /// Added in version 6.7.0
  void removeListener(DataCaptureViewListener listener) {
    _listeners.remove(listener);

    if (_listeners.isEmpty) {
      _controller?._unregisterListener();
    }
  }

  /// Converts a point in the coordinate system of the last visible frame and maps it to a coordinate in the view.
  ///
  /// This method is thread-safe and can be called from any thread.
  ///
  /// Added in version 6.7.0
  Future<common.Point> viewPointForFramePoint(common.Point point) {
    return _controller?.viewPointForFramePoint(point) ?? Future.error(Exception('DataCaptureView not initialized'));
  }

  /// Converts a quadrilateral in the coordinate system of the last visible frame and maps it to a coordinate in the view.
  ///
  /// Added in version 6.7.0
  Future<common.Quadrilateral> viewQuadrilateralForFrameQuadrilateral(common.Quadrilateral quadrilateral) {
    return _controller?.viewQuadrilateralForFrameQuadrilateral(quadrilateral) ??
        Future.error(Exception('DataCaptureView not initialized'));
  }

  /// Adds the control to the data capture view. In case multiple controls get added, the order in which [DataCaptureView.addControl] gets called determines how the controls are going to be laid out. If the control is already part of this view, the call has no effect.
  ///
  /// If the control was previously added with [DataCaptureView.addControlWithAnchorAndOffset], this call drops that anchor and offset and restores the control’s default placement. Re-declaring the same control instance through the view’s `controls` constructor parameter keeps its placement instead; a control rebuilt as a new instance is placed by default.
  ///
  /// Added in version 6.8.0
  Future<void> addControl(Control control) {
    return _addControl(control, null);
  }

  /// Adds the control to the data capture view at the specified anchor and with the given offset. Only one control per type can be added at any point in time, trying to add a second instance of the same control type will result in the first one being removed. Adding a control at an anchor already taken will replace the previous control there. The offset x will move the control away from the border of the data capture view horizontally, which means that controls anchored on the left will move to the right and vice-versa. Controls anchored in the center horizontally will also move to the right. The offset y will move the control away from the border of the data capture view vertically, which means that controls anchored on the top will move downward and controls anchored to the bottom will move upward. Controls anchored in the center vertically will also move upward.
  ///
  /// Added in version 8.7.0
  Future<void> addControlWithAnchorAndOffset(Control control, common.Anchor anchor, common.PointWithUnit offset) {
    return _addControl(control, _ControlPlacement(anchor, offset));
  }

  Future<void> _addControl(Control control, _ControlPlacement? placement) {
    var isNew = !_controls.contains(control);
    // Adding without a placement drops any placement the control carried, so a plain
    // addControl never leaves a stale anchor/offset behind on an already-added control.
    var placementChanged = placement != null || _controlPlacements.remove(control) != null;
    if (placement != null) _controlPlacements[control] = placement;
    if (isNew) {
      _controls.add(control);
      if (control is ViewAttachable) registerAttachable(control as ViewAttachable);
    }
    if (isNew || placementChanged) return _update();
    return Future.value(null);
  }

  /// Removes the previously added control from data capture view. If the control is not part of this view, the call has no effect.
  ///
  /// Added in version 6.8.0
  Future<void> removeControl(Control control) {
    _controlPlacements.remove(control);
    if (_controls.remove(control)) {
      if (control is ViewAttachable) unregisterAttachable(control as ViewAttachable);
      return _update();
    }
    return Future.value(null);
  }

  /// The style of the logo which can be either the default extended “Scanning By Scandit” or a minimal “Scandit”.
  ///
  /// This property has no effect when the logo is drawn by one of the viewfinders.
  ///
  /// Added in version 6.8.0
  set logoStyle(LogoStyle newValue) {
    _logoStyle = newValue;
    _update();
  }

  /// The style of the logo which can be either the default extended “Scanning By Scandit” or a minimal “Scandit”.
  ///
  /// This property has no effect when the logo is drawn by one of the viewfinders.
  ///
  /// Added in version 6.8.0
  LogoStyle get logoStyle => _logoStyle;

  /// When enabled, the data capture view may display notifications to inform users about update in zoom level. Defaults to *true*.
  ///
  /// Added in version 8.3.0
  bool get shouldShowZoomNotification {
    return _shouldShowZoomNotification;
  }

  /// When enabled, the data capture view may display notifications to inform users about update in zoom level. Defaults to *true*.
  ///
  /// Added in version 8.3.0
  set shouldShowZoomNotification(bool newValue) {
    _shouldShowZoomNotification = newValue;
    _update();
  }
}

class _ControlPlacement {
  final common.Anchor anchor;
  final common.PointWithUnit offset;

  _ControlPlacement(this.anchor, this.offset);
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
        _handleSizeChanged(event);
      }
    });
  }

  void _handleSizeChanged(FlutterEvent event) {
    final payload = parsePayloadTolerantly<schema.DataCaptureViewListenerOnSizeChanged>(
      event.payload,
      (raw) => schema.DataCaptureViewListenerOnSizeChanged.fromJson(raw),
      (raw) {
        final map = raw is Map ? raw : const <String, dynamic>{};
        if (map['size'] is! Map || map['orientation'] is! String) return null;
        final sizeMap = map['size'] as Map;
        if (sizeMap['width'] is! num || sizeMap['height'] is! num) return null;
        return schema.DataCaptureViewListenerOnSizeChanged(
          viewId: map['viewId'] is int ? map['viewId'] as int : _viewId,
          size: schema.DataCaptureViewListenerOnSizeChangedSize(
            width: (sizeMap['width'] as num).toDouble(),
            height: (sizeMap['height'] as num).toDouble(),
          ),
          orientation: map['orientation'] as String,
          event: FunctionNames.eventDataCaptureViewSizeChanged,
        );
      },
      'onSizeChanged',
      'DataCaptureViewController',
    );
    if (payload == null) return;

    try {
      var size = common.Size(payload.size.width, payload.size.height);
      var orientation = common.OrientationDeserializer.fromJSON(payload.orientation);
      _notifyListenersOfViewDidChangeSize(size, orientation);
    } catch (error) {
      developer.log('DataCaptureViewController onSizeChanged: payload declined: $error');
    }
  }

  void _unregisterListener() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
  }

  @override
  void dispose() {
    _unregisterListener();
    super.dispose();
  }

  void _notifyListenersOfViewDidChangeSize(common.Size size, common.Orientation orientation) {
    for (var listener in _view._listeners) {
      listener.didChangeSize(_view, size, orientation);
    }
  }

  Future<common.Point> viewPointForFramePoint(common.Point point) {
    return coreMethodHandler.viewPointForFramePoint(viewId: _viewId, pointJson: jsonEncode(point.toMap())).then((
      value,
    ) {
      var validated = schema.PixelPoint.fromJson(jsonDecode(value));
      return common.Point(validated.x, validated.y);
    });
  }

  Future<common.Quadrilateral> viewQuadrilateralForFrameQuadrilateral(common.Quadrilateral quadrilateral) {
    return coreMethodHandler
        .viewQuadrilateralForFrameQuadrilateral(viewId: _viewId, quadrilateralJson: jsonEncode(quadrilateral.toMap()))
        .then((value) {
      var validated = schema.PixelQuadrilateral.fromJson(jsonDecode(value));
      return common.Quadrilateral(
        common.Point(validated.topLeft.x, validated.topLeft.y),
        common.Point(validated.topRight.x, validated.topRight.y),
        common.Point(validated.bottomRight.x, validated.bottomRight.y),
        common.Point(validated.bottomLeft.x, validated.bottomLeft.y),
      );
    });
  }

  Future<void> update(String viewJson) {
    return coreMethodHandler.updateDataCaptureView(viewJson: viewJson).onError(_onError);
  }

  void _onError(Object? error, StackTrace? stackTrace) {
    if (error == null) return;
    throw error;
  }
}

class _MutableViewConfig {
  common.MarginsWithUnit scanAreaMargins = Defaults.captureViewDefaults.scanAreaMargins;
  common.PointWithUnit pointOfInterest = Defaults.captureViewDefaults.pointOfInterest;
  common.Anchor logoAnchor = Defaults.captureViewDefaults.logoAnchor;
  common.PointWithUnit logoOffset = Defaults.captureViewDefaults.logoOffset;
  LogoStyle logoStyle = Defaults.captureViewDefaults.logoStyle;
  bool shouldShowZoomNotification = Defaults.captureViewDefaults.shouldShowZoomNotification ?? true;
  FocusGesture? focusGesture = Defaults.captureViewDefaults.focusGesture;
  List<ZoomGesture> zoomGestures = List.of(Defaults.captureViewDefaults.zoomGestures);
  PrivateDataCaptureContext? dataCaptureContext;
  _DataCaptureViewController? controller;
  bool isViewCreated = false;
}

mixin PrivateDataCaptureView implements common.Serializable {
  // A StatefulWidget may not declare non-final instance fields (must_be_immutable),
  // so the mutable view configuration lives in this final holder.
  final _MutableViewConfig _mutableConfig = _MutableViewConfig();

  final List<DataCaptureViewListener> _listeners = [];
  final List<Control> _controls = [];

  // Placement (anchor/offset) is keyed by control identity, not stored on Control: the four
  // implementations don't share a base toMap(), so a shared field would mean editing each one.
  final Map<Control, _ControlPlacement> _controlPlacements = Map.identity();
  final Map<String, dynamic> _properties = {};

  common.MarginsWithUnit get _scanAreaMargins => _mutableConfig.scanAreaMargins;

  set _scanAreaMargins(common.MarginsWithUnit newValue) => _mutableConfig.scanAreaMargins = newValue;

  common.PointWithUnit get _pointOfInterest => _mutableConfig.pointOfInterest;

  set _pointOfInterest(common.PointWithUnit newValue) => _mutableConfig.pointOfInterest = newValue;

  common.Anchor get _logoAnchor => _mutableConfig.logoAnchor;

  set _logoAnchor(common.Anchor newValue) => _mutableConfig.logoAnchor = newValue;

  common.PointWithUnit get _logoOffset => _mutableConfig.logoOffset;

  set _logoOffset(common.PointWithUnit newValue) => _mutableConfig.logoOffset = newValue;

  LogoStyle get _logoStyle => _mutableConfig.logoStyle;

  set _logoStyle(LogoStyle newValue) => _mutableConfig.logoStyle = newValue;

  bool get _shouldShowZoomNotification => _mutableConfig.shouldShowZoomNotification;

  set _shouldShowZoomNotification(bool newValue) => _mutableConfig.shouldShowZoomNotification = newValue;

  _DataCaptureViewController? get _controller => _mutableConfig.controller;

  set _controller(_DataCaptureViewController? newValue) => _mutableConfig.controller = newValue;

  FocusGesture? get _focusGesture => _mutableConfig.focusGesture;

  set _focusGesture(FocusGesture? newValue) => _mutableConfig.focusGesture = newValue;

  List<ZoomGesture> get _zoomGestures => _mutableConfig.zoomGestures;

  set _zoomGestures(List<ZoomGesture> newValue) => _mutableConfig.zoomGestures = newValue;

  ZoomGesture? get _zoomGesture => _zoomGestures.isNotEmpty ? _zoomGestures.first : null;
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
      // Ownership check, as in _detachAttachables: an attachable can be registered with two
      // live views, and only the one that built the live controller may tear it down.
      if (identical(attachable.attachedView, this)) {
        attachable.onDetachFromView();
      }
    }
  }

  /// Called when the view's controller is initialized.
  /// Notifies all registered attachables that the viewId is available.
  void _initializeAttachables() {
    for (final attachable in _attachables) {
      // Unconditional, so the view that builds the controller is the view that owns it.
      attachable.onAttachToView(this as DataCaptureView);
      attachable.onViewInitialized(viewId);
    }
  }

  /// Moves control attachments across a rebuild: the new widget has its own `_attachables`
  /// while the State and native view persist. A control passed unchanged is carried over rather
  /// than rebuilt every frame.
  void _adoptAttachablesFrom(PrivateDataCaptureView oldWidget, int viewId) {
    // Attach before detach: both loops can name the same control, and the context refcount is
    // shared, so detaching first would drop it to zero in between.
    for (final attachable in _attachableControls) {
      final carriedOver = oldWidget._attachables.contains(attachable);
      attachable.onAttachToView(this as DataCaptureView);
      if (!carriedOver) {
        attachable.onViewInitialized(viewId);
      }
    }
    for (final attachable in oldWidget._attachableControls) {
      if (!_attachables.contains(attachable) && identical(attachable.attachedView, oldWidget)) {
        attachable.onDetachFromView();
      }
    }
  }

  /// Carries anchor/offset across a rebuild for controls this widget still holds. Placement has
  /// no constructor parameter, so without this a control the parent re-declares in `controls:`
  /// would keep its membership and silently lose the placement set on the previous widget.
  void _adoptControlPlacementsFrom(PrivateDataCaptureView oldWidget) {
    for (final control in _controls) {
      final placement = oldWidget._controlPlacements[control];
      if (placement != null) _controlPlacements.putIfAbsent(control, () => placement);
    }
  }

  /// The attachables this view's own `controls` contribute — the only ones whose teardown it
  /// drives. Gestures are excluded: the defaults are process-wide instances (`Defaults
  /// .captureViewDefaults` is static) shared by every live view, so no view may tear one down.
  Iterable<ViewAttachable> get _attachableControls =>
      _controls.whereType<ViewAttachable>().where((a) => _attachables.contains(a));

  /// Releases per-view resources when the view goes away. Registration is left in place, so a
  /// remounted view re-attaches in [_initializeAttachables].
  void _detachAttachables() {
    for (final attachable in _attachableControls) {
      if (identical(attachable.attachedView, this)) {
        attachable.onDetachFromView();
      }
    }
  }

  void removeAllOverlays() {
    // Detach as removeOverlay does; a stale back-reference keeps re-serializing this view.
    for (var overlay in _overlays) {
      overlay.view = null;
    }
    _overlays.clear();
    _update();
  }

  // The macro mode control only exists on iOS; the Android control
  // deserializer rejects the 'macro' type, which aborts the whole view
  // deserialization and leaves the camera preview blank (SDC-33291).
  //
  // Uses defaultTargetPlatform rather than Platform.isIOS (the convention
  // elsewhere in this file) so tests can simulate both platforms via
  // debugDefaultTargetPlatformOverride; dart:io's Platform is not mockable.
  Iterable<Control> get _serializableControls => defaultTargetPlatform == TargetPlatform.iOS
      ? _controls
      : _controls.where((control) => control is! MacroModeControl);

  Map<String, dynamic> _serializeControl(Control control) {
    var json = control.toMap();
    var placement = _controlPlacements[control];
    if (placement != null) {
      json['anchor'] = placement.anchor.toString();
      json['offset'] = placement.offset.toMap();
    }
    return json;
  }

  bool get _isViewCreated => _mutableConfig.isViewCreated;

  set _isViewCreated(bool newValue) => _mutableConfig.isViewCreated = newValue;

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
    var json = schema.buildDataCaptureView(
      scanAreaMargins: _scanAreaMargins.toMap(),
      pointOfInterest: _pointOfInterest.toMap(),
      logoAnchor: _logoAnchor.toString(),
      logoOffset: _logoOffset.toMap(),
      focusGesture: _focusGesture?.toMap(),
      zoomGesture: _zoomGesture?.toMap(),
      zoomGestures: _zoomGestures.map((e) => e.toMap()).toList(),
      controls: _serializableControls.map(_serializeControl).toList(),
      logoStyle: _logoStyle.toString(),
      shouldShowZoomNotification: _shouldShowZoomNotification,
      overlays: _overlays.map((overlay) => overlay.toMap()).toList(),
      viewId: _controller?._viewId ?? 0,
    );

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

    widget._controller = _controller;

    // Must follow the controller assignment above: adopting initializes this widget's new
    // attachables, and they resolve the viewId through the controller.
    if (!identical(oldWidget, widget)) {
      widget._adoptAttachablesFrom(oldWidget, _viewId);
      widget._adoptControlPlacementsFrom(oldWidget);
    }

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
        // The constructor registered it before this widget had a controller, so it was never initialized.
        if (overlay is ViewAttachable && !oldWidget._overlays.contains(overlay)) {
          (overlay as ViewAttachable).onViewInitialized(_viewId);
        }
      }
      widget._update();
    }
  }

  @override
  void dispose() {
    widget._detachAttachables();
    _controller.dispose();
    super.dispose();
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
