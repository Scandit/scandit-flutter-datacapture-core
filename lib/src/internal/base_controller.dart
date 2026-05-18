import 'dart:developer' as developer;
import 'package:flutter/services.dart';

abstract class BaseController {
  final MethodChannel methodChannel;

  BaseController(String methodChannelName) : methodChannel = MethodChannel(methodChannelName);

  void onError(Object? error, StackTrace? stackTrace) {
    if (error == null) return;
    developer.log(error.toString());
    throw error;
  }

  void dispose() {
    methodChannel.setMethodCallHandler(null);
  }
}
