/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

import 'frame_source.dart';
import 'common.dart';
import 'defaults.dart';
import 'data_capture_view.dart';
import 'context_status.dart';
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
  final Map<String, dynamic> _settings = {};

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

enum Expiration { available, perpetual, notAvailable }

extension ExpirationDeserializer on Expiration {
  static Expiration expirationFromJSON(String jsonValue) {
    switch (jsonValue) {
      case 'available':
        return Expiration.available;
      case 'perpetual':
        return Expiration.perpetual;
      case 'notAvailable':
        return Expiration.notAvailable;
      default:
        throw Exception("Missing Expiration for '$jsonValue'");
    }
  }
}

class LicenseInfo {
  final Expiration _expiration;
  Expiration get expiration => _expiration;

  final DateTime? _date;
  DateTime? get date => _date;

  LicenseInfo._(this._expiration, this._date);

  @visibleForTesting
  factory LicenseInfo.fromJSON(Map<String, dynamic> json) {
    var expiration = ExpirationDeserializer.expirationFromJSON(json['expirationDateStatus'] as String);
    var date = expiration == Expiration.available
        ? DateTime.fromMillisecondsSinceEpoch((json['expirationDate'] as num).toInt() * 1000, isUtc: true)
        : null;
    return LicenseInfo._(expiration, date);
  }
}

class DataCaptureContext with PrivateDataCaptureContext implements Serializable {
  FrameSource? _frameSource;
  String _licenseKey;
  String? _deviceName;
  LicenseInfo? _licenseInfo;
  DataCaptureContextSettings _settings;

  FrameSource? get frameSource => _frameSource;

  Future<void> setFrameSource(FrameSource frameSource) {
    _frameSource?.context = null;
    _frameSource = frameSource;
    _frameSource?.context = this;
    return update();
  }

  LicenseInfo? get licenseInfo => _licenseInfo;

  DataCaptureContext._(this._licenseKey, this._deviceName, this._settings);

  DataCaptureContext.forLicenseKey(String licenseKey) : this._(licenseKey, null, DataCaptureContextSettings());

  factory DataCaptureContext.forLicenseKeyWithOptions(String licenseKey, DataCaptureContextCreationOptions? options) {
    var deviceName = (options == null || options.deviceName == null) ? '' : options.deviceName;
    return DataCaptureContext._(licenseKey, deviceName, DataCaptureContextSettings());
  }

  factory DataCaptureContext.forLicenseKeyWithSettings(String licenseKey, DataCaptureContextSettings? settings) {
    return DataCaptureContext._(licenseKey, null, settings ?? DataCaptureContextSettings());
  }

  void addMode(DataCaptureMode mode) {
    if (!modes.contains(mode)) {
      modes.add(mode);
      mode._context = this;
      update();
    }
  }

  void removeMode(DataCaptureMode mode) {
    if (modes.contains(mode) && modes.remove(mode)) {
      mode._context = null;
      update();
    }
  }

  void removeAllModes() {
    for (var element in modes) {
      element._context = null;
    }
    modes.clear();
    update();
  }

  void addListener(DataCaptureContextListener listener) {
    if (_listeners.isEmpty) {
      _controller?.initSubscribers();
    }

    if (_listeners.contains(listener)) {
      return;
    }
    _listeners.add(listener);
  }

  void removeListener(DataCaptureContextListener listener) {
    _listeners.remove(listener);
    if (_listeners.isEmpty) {
      _controller?.cancelSubscribers();
    }
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
      'modes': modes.map((mode) => mode.toMap()).toList(),
      'view': view?.toMap(),
      'settings': _settings.toMap(),
    };
    return json;
  }

  String _getFrameworkVersion() {
    try {
      return Platform.version.split(' ').first;
    } on Exception catch (e) {
      print(e);
      return 'undefined';
    }
  }
}

abstract class DataCaptureContextListener {
  void didChangeStatus(DataCaptureContext context, ContextStatus contextStatus);
  void didStartObservingContext(DataCaptureContext context);
}

mixin PrivateDataCaptureContext {
  _DataCaptureContextController? _controller;
  final List<DataCaptureMode> modes = [];
  final List<DataCaptureContextListener> _listeners = [];

  DataCaptureView? view;

  void initialize() {
    if (_controller != null) {
      return;
    }
    _controller = _DataCaptureContextController(this as DataCaptureContext, Defaults.channel);
  }

  Future<void> update() async {
    return _controller?.updateContextFromJSON() ?? Future<void>.value();
  }
}

class _DataCaptureContextController {
  final DataCaptureContext context;
  final MethodChannel methodChannel;

  final EventChannel _didStartObservingContextEventChannel =
      const EventChannel('com.scandit.datacapture.core.event/datacapture_context#didStartObservingContext');
  StreamSubscription? _didStartObservingContextSubscription;

  final EventChannel _contextStatusEventChannel =
      const EventChannel('com.scandit.datacapture.core.event/datacapture_context#didChangeStatus');
  StreamSubscription? _contextStatusSubscription;

  PrivateDataCaptureContext get _privateContext {
    return context;
  }

  _DataCaptureContextController(this.context, this.methodChannel) {
    _initialize();
  }

  Future<void> _initialize() {
    var encoded = jsonEncode(context.toMap());
    try {
      return methodChannel.invokeMethod(FunctionNames.createContextFromJSONMethodName, encoded);
    } on PlatformException catch (e) {
      _notifyListenersOfDeserializationError(e);
    }
    return Future.value();
  }

  Future<void> updateContextFromJSON() {
    var encoded = jsonEncode(context.toMap());
    return methodChannel
        .invokeMethod(FunctionNames.updateContextFromJSONMethodName, encoded)
        // ignore: unnecessary_lambdas
        .catchError((error) => _notifyListenersOfDeserializationError(error));
  }

  void _notifyListenersOfDidChangeStatus(ContextStatus contextStatus) {
    for (var listener in _privateContext._listeners) {
      listener.didChangeStatus(context, contextStatus);
    }
  }

  void _notifyListenersOfDeserializationError(PlatformException error) {
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
    _contextStatusSubscription = _contextStatusEventChannel.receiveBroadcastStream().listen((statusJSON) {
      Map<String, dynamic> payload = jsonDecode(statusJSON as String);
      Map<String, dynamic> statusInfo = jsonDecode(payload['status']);
      var status = ContextStatus.fromJSON(statusInfo);
      _notifyListenersOfDidChangeStatus(status);
    });
    _didStartObservingContextSubscription =
        _didStartObservingContextEventChannel.receiveBroadcastStream().listen((event) {
      Map<String, dynamic> payload = jsonDecode(event);
      Map<String, dynamic>? licenseInfoJSON =
          payload.containsKey('licenseInfo') ? jsonDecode(payload['licenseInfo']) : null;
      context._licenseInfo = licenseInfoJSON == null ? null : LicenseInfo.fromJSON(licenseInfoJSON);
      _notifyListenersOfObservationStarted();
    });
  }

  void cancelSubscribers() {
    _didStartObservingContextSubscription?.cancel();
    _didStartObservingContextSubscription = null;
    _contextStatusSubscription?.cancel();
    _contextStatusSubscription = null;
  }
}
