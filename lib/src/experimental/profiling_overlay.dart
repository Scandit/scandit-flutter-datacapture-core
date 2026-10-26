/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

import 'package:meta/meta.dart';

import '../data_capture_view.dart';

/// An overlay that draws frame-processing timing information on top of the video preview.
///
/// It displays the overall frame processing time together with per-stage engine timings,
/// which is useful when investigating scanning performance without parsing log output.
/// Add it to a [DataCaptureView] via [DataCaptureView.addOverlay].
///
/// This is a diagnostic aid that mirrors an internal capability of the native SDKs; it is
/// experimental, subject to change, and may be removed in future versions.
@experimental
class ProfilingOverlay extends DataCaptureOverlay {
  DataCaptureView? _view;

  ProfilingOverlay() : super('profilingOverlay');

  @override
  DataCaptureView? get view => _view;

  @override
  set view(DataCaptureView? newValue) {
    _view = newValue;
  }
}
