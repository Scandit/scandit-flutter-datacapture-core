/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

// ignore: unnecessary_library_name
library scandit_flutter_datacapture_core;

export 'src/source/camera.dart' show Camera;
export 'src/source/focus_gesture_strategy.dart' show FocusGestureStrategy;
export 'src/source/focus_range.dart' show FocusRange;
export 'src/source/camera_position.dart' show CameraPosition;
export 'src/source/torch_state.dart' show TorchState;
export 'src/source/video_resolution.dart' show VideoResolution;
export 'src/source/camera_settings.dart' show CameraSettings;
export 'src/source/frame_source.dart' show FrameSource, FrameSourceListener, TorchListener;
export 'src/source/frame_source_state.dart' show FrameSourceState;
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
        SizingMode,
        Rect;
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
export 'src/defaults.dart' show BrushDefaults, NativeBrushDefaults, CameraSettingsDefaults;
export 'src/feedback.dart' show Feedback, Sound, Vibration;

export 'src/location_selection.dart' show LocationSelection, RadiusLocationSelection, RectangularLocationSelection;
export 'src/viewfinder.dart'
    show
        RectangularViewfinder,
        AimerViewfinder,
        Viewfinder,
        RectangularViewfinderStyle,
        RectangularViewfinderLineStyle,
        RectangularViewfinderAnimation,
        LaserlineViewfinder;
export 'src/scandit_flutter_datacapture_core.dart' show ScanditFlutterDataCaptureCore;
export 'src/focus_gesture.dart' show FocusGesture, TapToFocus;
export 'src/zoom_gesture.dart' show ZoomGesture, SwipeToZoom;
export 'src/control.dart' show Control, TorchSwitchControl, ZoomSwitchControl;
export 'src/logo_style.dart' show LogoStyle;
export 'src/direction.dart' show Direction, DirectionDeserializer;
export 'src/image_buffer.dart' show ImageBuffer;
export 'src/frame_data.dart' show FrameData, DefaultFrameData;
export 'src/source/image_frame_source.dart' show ImageFrameSource;
export 'src/battery_saving_mode.dart' show BatterySavingMode, BatterySavingModeDeserializer;
export 'src/scan_intention.dart' show ScanIntention, ScanIntentionSerializer;
export 'src/widget_to_base64_converter.dart' show WidgetToBase64Converter;
export 'src/open_source_software_license_info.dart' show OpenSourceSoftwareLicenseInfo;
export 'src/scandit_icon.dart'
    show
        ScanditIcon,
        ScanditIconType,
        ScanditIconBuilder,
        ScanditIconShape,
        ScanditIconShapeSerializer,
        ScanditIconTypeSerializer;
export 'src/text_alignment.dart' show TextAlignment, TextAlignmentSerializer;
export 'src/font_family.dart' show FontFamily, FontFamilySerializer;
