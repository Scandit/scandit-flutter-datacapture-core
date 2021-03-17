/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

library scandit_flutter_datacapture_core;

export 'src/camera.dart'
    show Camera, CameraPosition, CameraSettings, FocusRange, TorchState, VideoResolution, FocusGestureStrategy;
export 'src/common.dart'
    show
        Anchor,
        AnchorDeserializer,
        Brush,
        ColorDeserializer,
        CompositeFlag,
        CompositeFlagDeserializer,
        DoubleWithUnit,
        MarginsWithUnit,
        MeasureUnit,
        Orientation,
        OrientationDeserializer,
        Point,
        PointWithUnit,
        Quadrilateral,
        Serializable,
        Size,
        SizeWithUnit,
        SizeWithUnitAndAspect,
        SizeWithAspect,
        SizingMode;
export 'src/context_status.dart' show ContextStatus;
export 'src/data_capture_context.dart'
    show
        DataCaptureContext,
        DataCaptureContextCreationOptions,
        DataCaptureContextListener,
        DataCaptureContextSettings,
        DataCaptureMode;
export 'src/data_capture_version.dart' show DataCaptureVersion;
export 'src/data_capture_view.dart' show DataCaptureOverlay, DataCaptureView, DataCaptureViewListener;
export 'src/defaults.dart' show BrushDefaults, CameraSettingsDefaults hide Defaults;
export 'src/feedback.dart' show Feedback, Sound, Vibration;
export 'src/frame_source.dart' show FrameSource, FrameSourceListener, FrameSourceState;
export 'src/location_selection.dart' show LocationSelection, RadiusLocationSelection, RectangularLocationSelection;
export 'src/viewfinder.dart' show LaserlineViewfinder, RectangularViewfinder, AimerViewfinder, Viewfinder;
export 'src/scandit_flutter_datacapture_core.dart' show ScanditFlutterDataCaptureCore;
export 'src/focus_gesture.dart' show FocusGesture, TapToFocus;
export 'src/zoom_gesture.dart' show ZoomGesture, SwipeToZoom;
