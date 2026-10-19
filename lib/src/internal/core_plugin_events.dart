/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

import 'package:flutter/services.dart';

class CorePluginEvents {
  static Stream coreEventStream = _getCoreStream();

  static Stream _getCoreStream() {
    return const EventChannel('com.scandit.datacapture.core/event_channel').receiveBroadcastStream();
  }
}
