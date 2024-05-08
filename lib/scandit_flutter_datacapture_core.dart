/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

library scandit_flutter_datacapture_core;

export 'src/camera.dart'
    show
        Camera,
        CameraPosition,
        CameraSettings,
        FocusRange,
        TorchState,
        VideoResolution,
        FocusGestureStrategy,
        TorchStateDeserializer;
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
export 'src/data_capture_component.dart' show DataCaptureComponent;
export 'src/data_capture_context.dart'
    show
        DataCaptureContext,
        DataCaptureContextCreationOptions,
        DataCaptureContextListener,
        DataCaptureContextSettings,
        DataCaptureMode;
export 'src/data_capture_version.dart' show DataCaptureVersion;
export 'src/data_capture_view.dart' show DataCaptureOverlay, DataCaptureView, DataCaptureViewListener;
export 'src/defaults.dart' show BrushDefaults, NativeBrushDefaults, CameraSettingsDefaults hide Defaults;
export 'src/feedback.dart' show Feedback, Sound, Vibration;
export 'src/frame_source.dart' show FrameSource, FrameSourceListener, FrameSourceState, TorchListener;
export 'src/location_selection.dart' show LocationSelection, RadiusLocationSelection, RectangularLocationSelection;
export 'src/viewfinder.dart'
    show
        LaserlineViewfinder,
        RectangularViewfinder,
        AimerViewfinder,
        Viewfinder,
        RectangularViewfinderStyle,
        RectangularViewfinderLineStyle,
        LaserlineViewfinderStyle,
        RectangularViewfinderAnimation;
export 'src/scandit_flutter_datacapture_core.dart' show ScanditFlutterDataCaptureCore;
export 'src/focus_gesture.dart' show FocusGesture, TapToFocus;
export 'src/zoom_gesture.dart' show ZoomGesture, SwipeToZoom;
export 'src/control.dart' show Control, TorchSwitchControl, ZoomSwitchControl;
export 'src/logo_style.dart' show LogoStyle;
export 'src/direction.dart' show Direction, DirectionDeserializer;
export 'src/image_buffer.dart' show ImageBuffer;
export 'src/frame_data.dart' show FrameData, DefaultFrameData;
export 'src/image_frame_source.dart' show ImageFrameSource;
export 'src/battery_saving_mode.dart' show BatterySavingMode;
export 'src/scan_intention.dart' show ScanIntention, ScanIntentionSerializer;
