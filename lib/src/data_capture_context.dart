/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';

import 'open_source_software_license_info.dart';
import 'common.dart';
import 'context_status.dart';
import 'data_capture_component.dart';
import 'data_capture_view.dart';
import 'defaults.dart';
import 'frame_source.dart';
import 'function_names.dart';

abstract class DataCaptureContextCreationOptions {
  String? deviceName;
}

abstract class DataCaptureMode implements Serializable {
  DataCaptureContext? _context;
  bool get isEnabled;
  set isEnabled(bool newValue);
  DataCaptureContext? get context => _context;
}

class DataCaptureContextSettings implements Serializable {
  final Map<String, dynamic> _settings = <String, dynamic>{};

  DataCaptureContextSettings();

  void setProperty<T>(String name, T value) {
    _settings[name] = value;
  }

  T getProperty<T>(String name) {
    return _settings[name] as T;
  }

  @override
  Map<String, dynamic> toMap() {
    return _settings;
  }
}

enum Expiration {
  available('available'),
  perpetual('perpetual'),
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

class LicenseInfo {
  final Expiration _expiration;
  Expiration get expiration => _expiration;

  final DateTime? _date;
  DateTime? get date => _date;

  LicenseInfo._(this._expiration, this._date);

  factory LicenseInfo.fromJSON(Map<String, dynamic> json) {
    var expiration = ExpirationDeserializer.expirationFromJSON(json['expirationDateStatus'] as String);
    var date = expiration == Expiration.available
        ? DateTime.fromMillisecondsSinceEpoch((json['expirationDate'] as num).toInt() * 1000, isUtc: true)
        : null;
    return LicenseInfo._(expiration, date);
  }
}

class DataCaptureContext with PrivateDataCaptureContext implements Serializable {
  static final DataCaptureContext _instance = DataCaptureContext._internal();

  DataCaptureContext._internal()
      : _licenseKey = '',
        _deviceName = null,
        _settings = DataCaptureContextSettings() {
    _controller = _DataCaptureContextController(this);
  }

  FrameSource? _frameSource;
  String _licenseKey = '';
  String? _deviceName;
  LicenseInfo? _licenseInfo;
  DataCaptureContextSettings _settings = DataCaptureContextSettings();

  FrameSource? get frameSource => _frameSource;

  Future<void> setFrameSource(FrameSource frameSource) {
    _frameSource?.context = null;
    _frameSource = frameSource;
    _frameSource?.context = this;
    return update();
  }

  LicenseInfo? get licenseInfo => _licenseInfo;

  static String get deviceId => Defaults.deviceId;

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

  factory DataCaptureContext.forLicenseKeyWithSettings(String licenseKey, DataCaptureContextSettings? settings) {
    DataCaptureContext.initialize(licenseKey, settings: settings);
    return _instance;
  }

  static DataCaptureContext get sharedInstance => _instance;

  Future<void> addMode(DataCaptureMode mode) {
    if (!modes.contains(mode)) {
      mode._context = this;
      modes.add(mode);
      return _controller.addModeToContext(mode);
    }
    return Future.value(null);
  }

  Future<void> setMode(DataCaptureMode mode) async {
    if (modes.isNotEmpty) {
      await removeAllModes();
    }
    mode._context = this;
    modes.add(mode);
    await _controller.addModeToContext(mode);
  }

  Future<void> removeCurrentMode() async {
    if (modes.isNotEmpty) {
      await removeMode(modes.first);
    }
  }

  Future<void> removeMode(DataCaptureMode mode) {
    if (modes.contains(mode) && modes.remove(mode)) {
      mode._context = null;
      return _controller.removeModeFromContext(mode);
    }
    return Future.value(null);
  }

  Future<void> removeAllModes() {
    for (var element in modes) {
      element._context = null;
    }
    modes.clear();
    return _controller.removeAllModes();
  }

  void addListener(DataCaptureContextListener listener) {
    if (_listeners.isEmpty) {
      _controller.initSubscribers();
    }

    if (_listeners.contains(listener)) {
      return;
    }
    _listeners.add(listener);
  }

  void removeListener(DataCaptureContextListener listener) {
    _listeners.remove(listener);
    if (_listeners.isEmpty) {
      _controller.cancelSubscribers();
    }
  }

  static Future<OpenSourceSoftwareLicenseInfo> getOpenSourceSoftwareLicenseInfo() {
    return Defaults.channel
        .invokeMethod(FunctionNames.getOpenSourceSoftwareLicenseInfo)
        .then((value) => OpenSourceSoftwareLicenseInfo(value));
  }

  @Deprecated('Deprecated. No need to add the component to the DataCaptureContext in oder to use it.')
  Future<void> addComponent(DataCaptureComponent component) {
    return Future.value(null);
  }

  Future<void> applySettings(DataCaptureContextSettings settings) {
    _settings = settings;
    return update();
  }

  @override
  Map<String, dynamic> toMap() {
    var json = <String, dynamic>{
      'licenseKey': _licenseKey,
      'deviceName': _deviceName,
      'framework': 'flutter',
      'frameworkVersion': _getFrameworkVersion(),
      'frameSource': _frameSource?.toMap(),
      'settings': _settings.toMap(),
    };
    return json;
  }

  String _getFrameworkVersion() {
    try {
      return Platform.version.split(' ').first;
    } on Exception {
      return 'undefined';
    }
  }
}

abstract class DataCaptureContextListener {
  void didChangeStatus(DataCaptureContext context, ContextStatus contextStatus);
  void didStartObservingContext(DataCaptureContext context);
}

mixin PrivateDataCaptureContext {
  late _DataCaptureContextController _controller;
  final List<DataCaptureMode> modes = [];
  final List<DataCaptureContextListener> _listeners = [];

  PrivateDataCaptureView? view;

  Future<void> update() async {
    return _controller.updateContextFromJSON();
  }
}

class _DataCaptureContextController {
  final DataCaptureContext context;
  final MethodChannel methodChannel = Defaults.channel;

  final EventChannel _contextEventsChannel = const EventChannel(FunctionNames.eventsChannelName);
  StreamSubscription? _contextEventsSubscription;

  PrivateDataCaptureContext get _privateContext {
    return context;
  }

  _DataCaptureContextController(this.context);

  Future<void> initialize() {
    var encoded = jsonEncode(context.toMap());
    return methodChannel.invokeMethod(FunctionNames.createContextFromJSONMethodName, encoded).catchError((error) {
      _notifyListenersOfDeserializationError(error, "Init - $encoded");
    });
  }

  Future<void> updateContextFromJSON() {
    var encoded = jsonEncode(context.toMap());
    return methodChannel
        .invokeMethod(FunctionNames.updateContextFromJSONMethodName, encoded)
        // ignore: unnecessary_lambdas
        .catchError((error) {
      _notifyListenersOfDeserializationError(error, "Update - $encoded");
    });
  }

  Future<void> addModeToContext(DataCaptureMode mode) {
    var encoded = jsonEncode(mode.toMap());
    return methodChannel
        .invokeMethod(FunctionNames.addModeToContext, encoded)
        // ignore: unnecessary_lambdas
        .catchError((error) {
      _notifyListenersOfDeserializationError(error, "AddMode - $encoded");
    });
  }

  Future<void> removeModeFromContext(DataCaptureMode mode) {
    var encoded = jsonEncode(mode.toMap());
    return methodChannel
        .invokeMethod(FunctionNames.removeModeFromContext, encoded)
        // ignore: unnecessary_lambdas
        .catchError((error) {
      _notifyListenersOfDeserializationError(error, "RemoveMode - $encoded");
    });
  }

  Future<void> removeAllModes() {
    return methodChannel
        .invokeMethod(FunctionNames.removeAllModesFromContext)
        // ignore: unnecessary_lambdas
        .catchError((error) {
      _notifyListenersOfDeserializationError(error, "RemoveAllModes");
    });
  }

  void _notifyListenersOfDidChangeStatus(ContextStatus contextStatus) {
    for (var listener in _privateContext._listeners) {
      listener.didChangeStatus(context, contextStatus);
    }
  }

  void _notifyListenersOfDeserializationError(PlatformException error, String json) {
    _notifyListenersOfDidChangeStatus(ContextStatus.fromJSON({
      "message": error.message,
      "code": int.parse(error.code),
      "isValid": false,
    }));
  }

  void _notifyListenersOfObservationStarted() {
    for (var listener in _privateContext._listeners) {
      listener.didStartObservingContext(_privateContext as DataCaptureContext);
    }
  }

  void initSubscribers() {
    _contextEventsSubscription = _contextEventsChannel.receiveBroadcastStream().listen((event) {
      var eventJSON = jsonDecode(event);
      var eventName = eventJSON['event'] as String;

      if (eventName == FunctionNames.eventDataCaptureContextObservationStarted) {
        Map<String, dynamic>? licenseInfoJSON =
            eventJSON.containsKey('licenseInfo') ? jsonDecode(eventJSON['licenseInfo']) : null;
        context._licenseInfo = licenseInfoJSON == null ? null : LicenseInfo.fromJSON(licenseInfoJSON);
        _notifyListenersOfObservationStarted();
      }

      if (eventName == FunctionNames.eventDataCaptureContextOnStatusChanged) {
        Map<String, dynamic> statusInfo = jsonDecode(eventJSON['status']);
        var status = ContextStatus.fromJSON(statusInfo);
        _notifyListenersOfDidChangeStatus(status);
      }
    });
  }

  void cancelSubscribers() {
    _contextEventsSubscription?.cancel();
    _contextEventsSubscription = null;
  }
}
