import 'dart:developer' as developer;
import 'package:flutter/services.dart';

import 'logging/logging_method_channel.dart';

abstract class BaseController {
  final MethodChannel methodChannel;

  BaseController(String methodChannelName) : methodChannel = LoggingMethodChannel(methodChannelName);

  Never onError(Object error, StackTrace stackTrace) {
    developer.log(error.toString());
    Error.throwWithStackTrace(error, stackTrace);
  }

  void dispose() {
    methodChannel.setMethodCallHandler(null);
  }
}
