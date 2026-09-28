/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

import 'flutter_event.dart';

extension EventStreamExtensions on Stream<dynamic> {
  Stream<FlutterEvent> asFlutterEvents() {
    return map((event) => FlutterEvent.tryParse(event)).where((event) => event != null).cast<FlutterEvent>();
  }

  Stream<FlutterEvent> forMode(int modeId) {
    return asFlutterEvents().where((event) => event.isForMode(modeId));
  }

  Stream<FlutterEvent> forView(int viewId) {
    return asFlutterEvents().where((event) => event.isForView(viewId));
  }
}

extension FlutterEventStreamExtensions on Stream<FlutterEvent> {
  Stream<FlutterEvent> whereMode(int modeId) {
    return where((event) => event.isForMode(modeId));
  }

  Stream<FlutterEvent> whereView(int viewId) {
    return where((event) => event.isForView(viewId));
  }

  Stream<FlutterEvent> whereEvent(String eventName) {
    return where((event) => event.isEvent(eventName));
  }
}
