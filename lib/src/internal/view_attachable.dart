/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

import '../data_capture_view.dart';

/// Mixin for components that need to be notified of view lifecycle events.
///
/// Implement this for any component that requires the viewId for native communication.
/// The lifecycle is:
/// 1. [onAttachToView] - Called when the component is associated with a view
/// 2. [onViewInitialized] - Called when the view's controller is ready and viewId is available
/// 3. [onDetachFromView] - Called when the component is detached from the view
///
/// Example usage:
/// ```dart
/// class MyComponent with ViewAttachable {
///   @override
///   void onViewInitialized(int viewId) {
///     // Setup native communication using viewId
///   }
///
///   @override
///   void onDetachFromView() {
///     // Cleanup native resources
///   }
/// }
/// ```
mixin ViewAttachable {
  DataCaptureView? _attachedView;

  /// The view this component is currently attached to, if any.
  DataCaptureView? get attachedView => _attachedView;

  /// Called when the component is associated with a view.
  ///
  /// Note: The viewId may not be available yet at this point.
  /// Use [onViewInitialized] for operations that require the viewId.
  void onAttachToView(DataCaptureView view) {
    _attachedView = view;
  }

  /// Called when the view's controller is initialized and viewId is available.
  ///
  /// Override this method to setup native communication channels or other
  /// operations that require the viewId.
  void onViewInitialized(int viewId);

  /// Called when the component is detached from the view.
  ///
  /// Override this method to cleanup native resources and subscriptions.
  void onDetachFromView() {
    _attachedView = null;
  }
}
