/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:scandit_flutter_datacapture_core/src/frame_data_settings.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/core_plugin_events.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/event_stream_extensions.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/flutter_event.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/generated/core_method_handler.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/generated/schema_types.dart' as schema;
import 'package:scandit_flutter_datacapture_core/src/internal/logging/logging_method_channel.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/tolerant_payload_parser.dart';
import 'package:scandit_flutter_datacapture_core/src/source/camera.dart';
import 'package:scandit_flutter_datacapture_core/src/source/camera_position.dart';
import 'package:scandit_flutter_datacapture_core/src/source/frame_source.dart';
import 'package:scandit_flutter_datacapture_core/src/source/frame_source_state.dart';

import 'open_source_software_license_info.dart';
import 'common.dart';
import 'context_status.dart';
import 'data_capture_view.dart';
import 'defaults.dart';
import 'function_names.dart';

/// Added in version 6.7.0
abstract class DataCaptureContextCreationOptions {
  /// The device name allows to optionally identify the device with a user-provided name. This name is then associated with unique identifier of the device and displayed in the online dashboard.
  ///
  /// Added in version 6.7.0
  String? deviceName;
}

/// Capture modes are restricted to the set of data captures modes provided by the Scandit Data Capture SDK. It is not available for implementing custom data capture modes.
///
/// Capture modes need to be associated with a data capture context ([DataCaptureContext]) after they have been created using [DataCaptureContext.addMode]. Modes can be removed again using [DataCaptureContext.removeMode].
///
/// A data capture context can only be associated with one mode at a time. If multiple modes are associated with the same context, the context will not process any frames and report an error.
///
/// **Usage Sample**
///
/// Because the [DataCaptureMode] cannot be instantiated directly, the example below uses the [BarcodeCapture] to illustrate a typical usage of capture modes. Other capture modes will work very similarly. The typical steps are:
///
/// 1. Configure the capture mode by first creating settings.
/// 2. Instantiate the capture mode and associate with the context and the settings.
/// 3. Registering a mode-specific listener (not shown).
///
/// Todoadd this to the sample
///
/// 1. Enabling recognition by setting the [DataCaptureMode.isEnabled] property to *true*.
///
/// ```dart
/// var dataCaptureContext = ...;
/// var settings = BarcodeCaptureSettings();
/// settings.enableSymbology(Symbology.qr, true);
/// var barcodeCapture = BarcodeCapture.forContext(dataCaptureContext, settings);
/// // Capture modes are enabled by default. The next line is not strictly necessary and
/// // is only listed to make you aware of the possibility to enable/disable modes.
/// barcodeCapture.isEnabled = true;
/// ```
///
/// Added in version 6.7.0
abstract class DataCaptureMode implements Serializable {
  DataCaptureContext? _context;
  /// *True* if this data capture mode is enabled, *false* if not. Only enabled capture modes are processing frames.
  ///
  /// Changing this property from *false* to *true* causes this data capture mode to start processing frames.
  ///
  /// Changing this property from *true* to *false* causes this data capture mode to stop processing frames. The effect is immediate: no more frames will be processed *after* the change. However, if a frame is currently being processed, this frame will be completely processed and deliver any results/callbacks to the registered listeners. When changing this property from one of the listener callbacks that is called as a result of processing the frame, no more frames will be processed after that.
  ///
  /// Note that this property only affects the data capture and does not affect the [FrameSource]’s state.
  ///
  /// By default, this property is *true*.
  ///
  /// Added in version 6.7.0
  bool get isEnabled;
  /// *True* if this data capture mode is enabled, *false* if not. Only enabled capture modes are processing frames.
  ///
  /// Changing this property from *false* to *true* causes this data capture mode to start processing frames.
  ///
  /// Changing this property from *true* to *false* causes this data capture mode to stop processing frames. The effect is immediate: no more frames will be processed *after* the change. However, if a frame is currently being processed, this frame will be completely processed and deliver any results/callbacks to the registered listeners. When changing this property from one of the listener callbacks that is called as a result of processing the frame, no more frames will be processed after that.
  ///
  /// Note that this property only affects the data capture and does not affect the [FrameSource]’s state.
  ///
  /// By default, this property is *true*.
  ///
  /// Added in version 6.7.0
  set isEnabled(bool newValue);
  /// The context this data capture mode is attached to. When the data capture mode is currently not attached to a context, *null* is returned.
  ///
  /// Added in version 6.7.0
  DataCaptureContext? get context => _context;
}

/// Holds settings related to the data capture context.
///
/// Added in version 6.7.0
class DataCaptureContextSettings implements Serializable {
  final Map<String, dynamic> _settings = <String, dynamic>{};

  /// Gets or sets the frame data settings for the data capture context. These settings control how frame data is handled, including image quality, file system caching, and automatic rotation.
  ///
  /// Added in version 7.5.0
  FrameDataSettings frameDataSettings = FrameDataSettings();

  /// Creates a new settings object with the default values.
  ///
  /// Added in version 6.7.0
  DataCaptureContextSettings();

  /// Sets a property to the provided value. Use this method to set properties that are not yet part of a stable API. Properties set through this method may or may not be used or change in a future release.
  ///
  /// Added in version 6.7.0
  void setProperty<T>(String name, T value) {
    _settings[name] = value;
  }

  /// Retrieves the value of a previously set property.
  ///
  /// Added in version 6.7.0
  T getProperty<T>(String name) {
    return _settings[name] as T;
  }

  /// Returns a new [FrameDataSettingsBuilder] instance configured with the current frame data settings. This provides a fluent interface for modifying frame data settings using the builder pattern.
  ///
  /// The following example shows how to configure frame data settings using the builder pattern:
  ///
  /// ```dart
  /// final dataCaptureContextSettings = DataCaptureContextSettings();
  /// dataCaptureContextSettings.frameDataSettingsBuilder()
  ///   ..enableAutoRotate(true)
  ///   ..enableFileSystemCache(true)
  ///   ..setImageQuality(70);
  /// final dataCaptureContext = DataCaptureContext.forLicenseKeyWithSettings(
  ///   '-- ENTER YOUR SCANDIT LICENSE KEY HERE --',
  ///   dataCaptureContextSettings
  /// );
  /// ```
  ///
  /// Added in version 7.5.0
  FrameDataSettingsBuilder frameDataSettingsBuilder() {
    return FrameDataSettingsBuilder(frameDataSettings);
  }

  @override
  Map<String, dynamic> toMap() {
    _settings["frameDataSettings"] = frameDataSettings.toMap();
    return _settings;
  }
}

/// States representing different expiration types.
///
/// Added in version 6.7.0
enum Expiration {
  /// An expiration date is available.
  ///
  /// Added in version 6.7.0
  available('available'),
  /// The license is perpetual and as such there is no expiration date.
  ///
  /// Added in version 6.7.0
  perpetual('perpetual'),
  /// No information about the expiration date is available for this license type.
  ///
  /// Added in version 6.7.0
  notAvailable('notAvailable');

  const Expiration(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension ExpirationDeserializer on Expiration {
  static Expiration expirationFromJSON(String jsonValue) {
    return Expiration.values.firstWhere((element) => element.toString() == jsonValue);
  }
}

/// A capture mode that a license key can grant access to.
///
/// Added in version 8.7.0
enum CaptureMode {
  /// Barcode Capture.
  ///
  /// Added in version 8.7.0
  barcodeCapture,
  /// Barcode Batch (MatrixScan).
  ///
  /// Added in version 8.7.0
  barcodeBatch,
  /// Barcode Count.
  ///
  /// Added in version 8.7.0
  barcodeCount,
  /// Barcode Find.
  ///
  /// Added in version 8.7.0
  barcodeFind,
  /// Barcode Pick.
  ///
  /// Added in version 8.7.0
  barcodePick,
  /// Barcode Selection.
  ///
  /// Added in version 8.7.0
  barcodeSelection,
  /// SparkScan.
  ///
  /// Added in version 8.7.0
  sparkScan,
  /// ID Capture.
  ///
  /// Added in version 8.7.0
  idCapture,
  /// Label Capture.
  ///
  /// Added in version 8.7.0
  labelCapture,
  /// Parser.
  ///
  /// Added in version 8.7.0
  parser,
  /// Text Capture.
  ///
  /// Added in version 8.7.0
  textCapture,
}

/// Contains information about the license for which a context was created.
///
/// Added in version 6.7.0
class LicenseInfo {
  final Expiration _expiration;
  /// The license’s expiration. This information is not made available for all license types.
  ///
  /// Added in version 6.7.0
  Expiration get expiration => _expiration;

  final DateTime? _date;
  /// The expiration date of the license.
  ///
  /// Added in version 6.7.0
  DateTime? get date => _date;

  final Set<CaptureMode> _allowedModes;
  /// The capture modes that the license key allows.
  ///
  /// Added in version 8.7.0
  Set<CaptureMode> get allowedModes => _allowedModes;

  LicenseInfo._(this._expiration, this._date, this._allowedModes);

  factory LicenseInfo.fromJSON(Map<String, dynamic> json) {
    var expiration = ExpirationDeserializer.expirationFromJSON(json['expirationDateStatus'] as String);
    var date = expiration == Expiration.available
        ? DateTime.fromMillisecondsSinceEpoch((json['expirationDate'] as num).toInt() * 1000, isUtc: true)
        : null;
    // Native omits the key when the set is empty; unknown modes from a newer native SDK are skipped.
    var byName = CaptureMode.values.asNameMap();
    var allowedModes = ((json['allowedModes'] as List<dynamic>?) ?? const []).map((mode) => byName[mode]).nonNulls;
    return LicenseInfo._(expiration, date, Set.unmodifiable(allowedModes));
  }
}

/// Data capture context is the main class for running data capture related tasks. The context manages one or more capture modes ([DataCaptureMode]), such as [BarcodeCapture] that perform the recognition. The context itself acts as a scheduler, but does not provide any interfaces for configuring data capture capabilities. Configuration and result handling is handled by the data capture modes directly.
///
/// A data capture context has exactly one frame source (typically a built-in camera ([Camera])). The frame source delivers the frames on which the capture modes should perform recognition on. When a new capture context is created, it’s frame source is *null* and must be initialized for recognition to work.
///
/// Typically a [DataCaptureView] is used to visualize the ongoing data capture process on screen together with one or more overlays ([DataCaptureOverlay]). However it’s also possible to use the data capture context without a view to perform off-screen processing.
///
/// **Related topics**: [Get Started](https://docs.scandit.com/sdks/flutter/barcode-capture/get-started), [MatrixScan Get Started](https://docs.scandit.com/sdks/flutter/matrixscan/get-started), Core Concepts <https://docs.scandit.com/core-concepts>.
///
/// Added in version 6.7.0
class DataCaptureContext with PrivateDataCaptureContext implements Serializable {
  static final DataCaptureContext _instance = DataCaptureContext._internal();

  DataCaptureContext._internal()
      : _licenseKey = '',
        _deviceName = null,
        _settings = DataCaptureContextSettings() {
    _controller = _DataCaptureContextController(this);
  }

  String _licenseKey = '';
  String? _deviceName;
  LicenseInfo? _licenseInfo;
  DataCaptureContextSettings _settings = DataCaptureContextSettings();

  /// Readonly attribute to get the current frame source. To change the frame source use setFrameSource().
  ///
  /// Added in version 6.7.0
  FrameSource? get frameSource => _frameSource;

  /// Sets the frame source of this data capture context.
  ///
  /// Frame sources produce frames to be processed by the data capture context. The user typically doesn’t create their own frame sources, but use one of the frame sources provided by the Scandit Data Capture SDK. Typical frame sources are web cams, or built-in cameras of a mobile device.
  ///
  /// Setting the frame source to *null* will effectively stop recognition of this capture context.
  ///
  /// Added in version 6.7.0
  Future<void> setFrameSource(FrameSource? frameSource) {
    _frameSource?.context = null;
    _frameSource = frameSource;
    _frameSource?.context = this;
    return update();
  }

  /// Information about the license the context was created for.
  ///
  /// This value is available with a small delay. To make sure it is available, set a listener and as soon as DataCaptureContextListener.didStartObservingContext() was called, it is available.
  ///
  /// Added in version 6.7.0
  LicenseInfo? get licenseInfo => _licenseInfo;

  /// The unique identifier of the device as used by the Scandit Data Capture SDK. This identifier does not contain any device identifying information that would be usable outside of the context of the Scandit Data Capture SDK itself.
  ///
  /// Added in version 6.18.0
  static String get deviceId => Defaults.deviceId;

  /// Initializes the singleton context instance with the provided license key, and returns the same instance.
  ///
  /// Added in version 7.2.0
  static Future<DataCaptureContext> initialize(
    String licenseKey, {
    DataCaptureContextCreationOptions? options,
    DataCaptureContextSettings? settings,
  }) async {
    _instance._licenseKey = licenseKey;
    _instance._deviceName = options?.deviceName;
    _instance._settings = settings ?? DataCaptureContextSettings();
    await _instance._controller.initialize();

    return _instance;
  }

  factory DataCaptureContext.forLicenseKey(String licenseKey) {
    DataCaptureContext.initialize(licenseKey);
    return _instance;
  }

  factory DataCaptureContext.forLicenseKeyWithOptions(String licenseKey, DataCaptureContextCreationOptions? options) {
    DataCaptureContext.initialize(licenseKey, options: options);
    return _instance;
  }

  /// Constructs a data capture context with the provided license key and optional settings.
  ///
  /// Added in version 6.7.0
  factory DataCaptureContext.forLicenseKeyWithSettings(String licenseKey, DataCaptureContextSettings? settings) {
    DataCaptureContext.initialize(licenseKey, settings: settings);
    return _instance;
  }

  /// Holds the singleton instance of DataCaptureContext, which is managed by Scandit Data Capture SDK. This instance is unusable until properly configured.
  ///
  /// To configure the instance, call [DataCaptureContext.initialize].
  ///
  /// Added in version 7.2.0
  static DataCaptureContext get sharedInstance => _instance;

  /// Adds the specified data capture mode to this capture context. Please note that it is not possible to add a mode associated with a context to a different context. If the mode is already associated with this context, this call has no effect.
  ///
  /// A data capture context can only be associated with one mode at a time. If multiple modes are associated with the same context, the context will not process any frames and report an error.
  ///
  /// Added in version 6.7.0
  Future<void> addMode(DataCaptureMode mode) async {
    if (_modes.contains(mode)) {
      return;
    }

    _modes.add(mode);
    await _controller.addModeToContext(mode);
    mode._context = this;
  }

  /// Sets the specified data capture mode as the active mode of this capture context. Please note that it is not possible to add a mode associated with a context to a different context. If the mode is already associated with this context, this call has no effect.
  ///
  /// A data capture context can only be associated with one mode at a time. If a new mode is associated with the context, the previous mode will be replaced by the new one.
  ///
  /// Added in version 7.2.0
  Future<void> setMode(DataCaptureMode mode) async {
    // Remove all modes first to avoid conflicts
    await removeAllModes();
    // Add the new mode
    _modes.add(mode);
    await _controller.addModeToContext(mode);
    mode._context = this;
  }

  /// Removes the currently active mode from this capture context. If the context has no capture mode associated to it, this call has no effect.
  ///
  /// Added in version 7.2.0
  Future<void> removeCurrentMode() async {
    if (_modes.isEmpty) {
      return;
    }

    if (_modes.length > 1) {
      developer.log(
        'Warning: removeCurrentMode() called with multiple modes active. Consider using removeMode() for specific mode removal. Only the first mode will be removed.',
        name: 'DataCaptureContext',
      );
    }

    final mode = _modes.first;
    _modes.remove(mode);
    mode._context = null;
    await _controller.removeModeFromContext(mode);
  }

  /// Removes the mode from this capture context. If the capture mode is currently not associated to the context, this call has no effect.
  ///
  /// Added in version 6.7.0
  Future<void> removeMode(DataCaptureMode mode) async {
    if (!_modes.remove(mode)) {
      return;
    }

    mode._context = null;
    await _controller.removeModeFromContext(mode);
  }

  /// Removes all modes from this capture context. If there currently are no captures modes associated to the context, this call has no effect.
  ///
  /// Added in version 6.7.0
  Future<void> removeAllModes() async {
    if (_modes.isEmpty) {
      return;
    }

    _clearAllModes();
    await _controller.removeAllModes();
  }

  void _clearAllModes() {
    for (final mode in _modes) {
      mode._context = null;
    }
    _modes.clear();
  }

  /// Adds the listener to this data capture context. Context listeners receive events when new data capture modes are added, or the frame source changes.
  ///
  /// In case the same listener is already observing this instance, calling this method will not add the listener again.
  ///
  /// Added in version 6.7.0
  void addListener(DataCaptureContextListener listener) {
    _controller.initSubscribers();

    if (_listeners.contains(listener)) {
      return;
    }
    _listeners.add(listener);
  }

  /// Removes a previously added listener from this data capture context.
  ///
  /// In case the listener is not currently observing this instance, calling this method has no effect.
  ///
  /// Added in version 6.7.0
  void removeListener(DataCaptureContextListener listener) {
    _listeners.remove(listener);
    _cancelSubscribersIfUnused();
  }

  /// The license text and attributions for all third party software used by the Scandit SDK.
  ///
  /// Added in version 7.0.0
  static Future<OpenSourceSoftwareLicenseInfo> getOpenSourceSoftwareLicenseInfo() {
    var coreMethodHandler = CoreMethodHandler(const LoggingMethodChannel(FunctionNames.methodsChannelName));
    return coreMethodHandler.getOpenSourceSoftwareLicenseInfo().then((value) => OpenSourceSoftwareLicenseInfo(value));
  }

  /// Applies the given settings to the data capture context.
  ///
  /// Added in version 6.7.0
  Future<void> applySettings(DataCaptureContextSettings settings) {
    _settings = settings;
    return update();
  }

  @override
  Map<String, dynamic> toMap() {
    return schema.buildContext(
      licenseKey: _licenseKey,
      deviceName: _deviceName,
      framework: 'flutter',
      frameworkVersion: _getFrameworkVersion(),
      frameSource: _frameSource?.toMap(),
      settings: _settings.toMap(),
    );
  }

  String _getFrameworkVersion() {
    try {
      return Platform.version.split(' ').first;
    } on Exception {
      return 'undefined';
    }
  }
}

/// Interface for observing/listening to mode and status changes of a data capture context.
///
/// To observe changes of the data capture context, one or more [DataCaptureContextListener] may be added. These listeners provide hooks into different parts of the data capture context.
///
/// Added in version 6.7.0
abstract class DataCaptureContextListener {
  /// Called when a context status changed.
  ///
  /// Added in version 6.7.0
  void didChangeStatus(DataCaptureContext context, ContextStatus contextStatus);
  /// Called when the listener has been added to the data capture context and is from now on receiving events.
  ///
  /// Added in version 6.7.0
  void didStartObservingContext(DataCaptureContext context);
}

mixin PrivateDataCaptureContext {
  late _DataCaptureContextController _controller;
  final List<DataCaptureMode> _modes = [];
  final List<DataCaptureContextListener> _listeners = [];
  int _internalEventSubscribers = 0;
  FrameSource? _frameSource;

  List<DataCaptureMode> get modes => List.unmodifiable(_modes);

  PrivateDataCaptureView? view;

  Future<void> update() async {
    return _controller.updateContextFromJSON();
  }

  /// Keeps the event subscription open for internal state-keeping no app listener asks for.
  /// Refcounted against [DataCaptureContext.addListener], so neither side cancels what the
  /// other still needs.
  @internal
  void retainContextEvents() {
    _internalEventSubscribers++;
    _controller.initSubscribers();
  }

  @internal
  void releaseContextEvents() {
    if (_internalEventSubscribers > 0) _internalEventSubscribers--;
    _cancelSubscribersIfUnused();
  }

  void _cancelSubscribersIfUnused() {
    if (_listeners.isEmpty && _internalEventSubscribers == 0) {
      _controller.cancelSubscribers();
    }
  }

  // Repoints frameSource/context as setFrameSource does, but without the native update():
  // native is already in this state, so re-serializing it would be redundant and could fail.
  @internal
  void adoptActiveFrameSource(FrameSource newFrameSource) {
    if (identical(_frameSource, newFrameSource)) return;
    _frameSource?.context = null;
    _frameSource = newFrameSource;
    _frameSource?.context = this as DataCaptureContext;
  }
}

class _DataCaptureContextController extends BaseController {
  final DataCaptureContext context;
  late final CoreMethodHandler coreMethodHandler;

  StreamSubscription? _contextEventsSubscription;

  PrivateDataCaptureContext get _privateContext {
    return context;
  }

  _DataCaptureContextController(this.context) : super(FunctionNames.methodsChannelName) {
    coreMethodHandler = CoreMethodHandler(methodChannel);
  }

  Future<void> initialize() async {
    var encoded = jsonEncode(context.toMap());
    try {
      await coreMethodHandler.createContextFromJson(contextJson: encoded);
    } catch (error) {
      if (error is PlatformException) {
        _notifyListenersOfDeserializationError(error, "Init - $encoded");
      }
    }
  }

  Future<void> updateContextFromJSON() async {
    var encoded = jsonEncode(context.toMap());
    try {
      await coreMethodHandler.updateContextFromJson(contextJson: encoded);
    } catch (error) {
      if (error is PlatformException) {
        _notifyListenersOfDeserializationError(error, "Update - $encoded");
      }
    }
  }

  Future<void> addModeToContext(DataCaptureMode mode) async {
    var encoded = jsonEncode(mode.toMap());
    try {
      await coreMethodHandler.addModeToContext(modeJson: encoded);
    } catch (error) {
      if (error is PlatformException) {
        _notifyListenersOfDeserializationError(error, "AddMode - $encoded");
      }
    }
  }

  Future<void> removeModeFromContext(DataCaptureMode mode) async {
    var encoded = jsonEncode(mode.toMap());
    try {
      await coreMethodHandler.removeModeFromContext(modeJson: encoded);
    } catch (error) {
      if (error is PlatformException) {
        _notifyListenersOfDeserializationError(error, "RemoveMode - $encoded");
      }
    }
  }

  Future<void> removeAllModes() async {
    try {
      await coreMethodHandler.removeAllModes();
    } catch (error) {
      if (error is PlatformException) {
        _notifyListenersOfDeserializationError(error, "RemoveAllModes");
      }
    }
  }

  @override
  void dispose() {
    cancelSubscribers();
    super.dispose();
  }

  void _notifyListenersOfDidChangeStatus(ContextStatus contextStatus) {
    for (var listener in _privateContext._listeners) {
      listener.didChangeStatus(context, contextStatus);
    }
  }

  void _notifyListenersOfDeserializationError(PlatformException error, String json) {
    _notifyListenersOfDidChangeStatus(
      ContextStatus.fromJSON({"message": error.message, "code": int.parse(error.code), "isValid": false}),
    );
  }

  void _notifyListenersOfObservationStarted() {
    for (var listener in _privateContext._listeners) {
      listener.didStartObservingContext(_privateContext as DataCaptureContext);
    }
  }

  void initSubscribers() {
    if (_contextEventsSubscription != null) return;

    // Android enables the native listener at plugin registration; iOS never did, so every
    // gated context event was dropped there. Not paired with an unsubscribe: native
    // enable/disable is one global, non-refcounted flag.
    coreMethodHandler.subscribeContextListener();

    _contextEventsSubscription = CorePluginEvents.coreEventStream.asFlutterEvents().listen((event) {
      if (event.isEvent(FunctionNames.eventDataCaptureContextObservationStarted)) {
        _handleObservationStarted(event);
      }

      if (event.isEvent(FunctionNames.eventDataCaptureContextOnStatusChanged)) {
        _handleStatusChanged(event);
      }

      if (event.isEvent(FunctionNames.eventDataCaptureContextOnFrameSourceChanged)) {
        _handleFrameSourceChanged(event);
      }
    });
  }

  /// Adopts a frame-source change native made itself, from the event that reports the change
  /// rather than a switch inferred from state. Native emits it before it starts the incoming
  /// camera, so the repoint lands first and that camera's didChangeState is delivered; and it
  /// does not depend on any state changing, so an off-tap is observed too.
  void _handleFrameSourceChanged(FlutterEvent event) {
    final payload = parsePayloadTolerantly<schema.DataCaptureContextListenerOnFrameSourceChanged>(
      event.payload,
      (raw) => schema.DataCaptureContextListenerOnFrameSourceChanged.fromJson(raw),
      (raw) {
        final map = raw is Map ? raw : const <String, dynamic>{};
        return schema.DataCaptureContextListenerOnFrameSourceChanged(
          cameraPosition: map['cameraPosition'] is String ? map['cameraPosition'] as String : null,
          event: FunctionNames.eventDataCaptureContextOnFrameSourceChanged,
        );
      },
      'onFrameSourceChanged',
      'DataCaptureContextController',
    );
    if (payload == null) return;

    // Absent or null means the new frame source is not a Camera: nothing to repoint to, and
    // every non-camera path is framework-driven, so Dart already knows.
    final positionJson = payload.cameraPosition;
    if (positionJson == null) return;

    final CameraPosition position;
    try {
      position = CameraPosition.fromJSON(positionJson);
    } catch (error) {
      logPayloadIssueOnce(
          'DataCaptureContextController', 'onFrameSourceChanged', 'unrecognised cameraPosition: $error');
      return;
    }

    final newActiveCamera = PrivateCamera.instanceAtPosition(position);
    if (newActiveCamera == null) return;

    final previousFrameSource = _privateContext._frameSource;
    if (identical(previousFrameSource, newActiveCamera)) return;

    // No native round-trip: setFrameSource would re-serialize a switch native already made.
    _privateContext.adoptActiveFrameSource(newActiveCamera);

    // Both platforms switch the outgoing camera off first, so its desiredState must follow, or
    // Camera.toMap serializes the stale `on` into every later context update.
    if (previousFrameSource is Camera) {
      previousFrameSource.adoptDesiredState(FrameSourceState.off);
    }
  }

  void _handleObservationStarted(FlutterEvent event) {
    // `event.payload` itself throws FormatException on an undecodable envelope, and it is
    // evaluated as an argument -- outside any guard the tolerant parser could apply. This event
    // must never be suppressed by a payload problem (an app waiting on a callback that never
    // arrives cannot observe the failure), so degrade to an empty map and let the tolerant
    // fallback below carry it through to the notification (SDC-32670).
    Map<String, dynamic> rawPayload;
    try {
      rawPayload = event.payload;
    } catch (e) {
      logPayloadIssueOnce(
          'DataCaptureContextController', 'onObservationStarted', 'undecodable payload envelope, notifying anyway: $e');
      rawPayload = const <String, dynamic>{};
    }

    final payload = parsePayloadTolerantly<schema.DataCaptureContextListenerOnObservationStarted>(
      rawPayload,
      (raw) => schema.DataCaptureContextListenerOnObservationStarted.fromJson(raw),
      (raw) {
        final map = raw is Map ? raw : const <String, dynamic>{};
        return schema.DataCaptureContextListenerOnObservationStarted(
          licenseInfo: map['licenseInfo'] is String ? map['licenseInfo'] as String : null,
          event: FunctionNames.eventDataCaptureContextObservationStarted,
        );
      },
      'onObservationStarted',
      'DataCaptureContextController',
    );
    if (payload == null) return;

    try {
      Map<String, dynamic>? licenseInfoJSON = payload.licenseInfo != null ? jsonDecode(payload.licenseInfo!) : null;
      context._licenseInfo = licenseInfoJSON == null ? null : LicenseInfo.fromJSON(licenseInfoJSON);
    } catch (error) {
      logPayloadIssueOnce('DataCaptureContextController', 'licenseInfo', 'licenseInfo payload declined: $error');
      context._licenseInfo = null;
    }
    _notifyListenersOfObservationStarted();
  }

  void _handleStatusChanged(FlutterEvent event) {
    final payload = parsePayloadTolerantly<schema.DataCaptureContextListenerOnStatusChanged>(
      event.payload,
      (raw) => schema.DataCaptureContextListenerOnStatusChanged.fromJson(raw),
      (raw) {
        final map = raw is Map ? raw : const <String, dynamic>{};
        if (map['status'] is! String) return null;
        return schema.DataCaptureContextListenerOnStatusChanged(
          status: map['status'] as String,
          event: FunctionNames.eventDataCaptureContextOnStatusChanged,
        );
      },
      'onStatusChanged',
      'DataCaptureContextController',
    );
    if (payload == null) return;

    try {
      Map<String, dynamic> statusInfo = jsonDecode(payload.status);
      var status = ContextStatus.fromJSON(statusInfo);
      _notifyListenersOfDidChangeStatus(status);
    } catch (error) {
      logPayloadIssueOnce('DataCaptureContextController', 'status', 'status payload declined: $error');
    }
  }

  void cancelSubscribers() {
    _contextEventsSubscription?.cancel();
    _contextEventsSubscription = null;
  }
}
