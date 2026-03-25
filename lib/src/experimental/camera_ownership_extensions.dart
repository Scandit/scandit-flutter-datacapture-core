/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:meta/meta.dart';
import 'package:scandit_flutter_datacapture_core/src/source/camera.dart';
import 'package:scandit_flutter_datacapture_core/src/experimental/camera_owner.dart';
import 'package:scandit_flutter_datacapture_core/src/experimental/camera_ownership_manager.dart';
import 'package:scandit_flutter_datacapture_core/src/source/camera_settings.dart';
import 'package:scandit_flutter_datacapture_core/src/source/frame_source_state.dart';
import 'package:scandit_flutter_datacapture_core/src/source/torch_state.dart';

@experimental
extension CameraOwnershipExtensions on Camera {
  /// Switches the camera to the desired state with ownership protection.
  ///
  /// This method ensures that only the current owner of the camera can change
  /// its state. If the provided [owner] is not the current owner, the state
  /// change will be ignored to prevent conflicts between multiple components
  /// trying to control the same camera.
  ///
  /// **RECOMMENDED**: Use [CameraOwnershipHelper] for easier ownership management:
  /// ```dart
  /// final owner = MyFeatureOwner(); // implements CameraOwner
  ///
  /// // Option 1: Use helper to acquire ownership and perform operation
  /// await CameraOwnershipHelper.withCamera<void>(
  ///   CameraPosition.worldFacing,
  ///   owner,
  ///   (camera) async => await camera.switchToDesiredStateProtected(FrameSourceState.on, owner)
  /// );
  ///
  /// // Option 2: Request ownership first, then use camera
  /// final success = await CameraOwnershipHelper.requestOwnership(CameraPosition.worldFacing, owner);
  /// if (success) {
  ///   final camera = CameraOwnershipHelper.getCamera(CameraPosition.worldFacing, owner);
  ///   await camera?.switchToDesiredStateProtected(FrameSourceState.on, owner);
  /// }
  /// ```
  ///
  /// Manual ownership management (not recommended):
  /// ```dart
  /// final camera = Camera.defaultCamera;
  /// final owner = MyFeatureOwner();
  ///
  /// // Manual approach - use CameraOwnershipHelper instead
  /// CameraOwnershipManager.getInstance().requestOwnership(camera.position, owner);
  /// await camera.switchToDesiredStateProtected(FrameSourceState.on, owner);
  /// ```
  ///
  /// **EXPERIMENTAL**: This API is experimental and may change or be removed
  /// in future versions without prior notice.
  ///
  /// Parameters:
  /// - [state]: The desired frame source state to switch to
  /// - [owner]: The camera owner requesting the state change
  Future<void> switchToDesiredStateProtected(FrameSourceState state, CameraOwner owner) async {
    final ownershipManager = CameraOwnershipManager.getInstance();
    final currentOwner = ownershipManager.getCurrentOwner(position);

    if (currentOwner == null) {
      throw Exception('Camera operation denied: No owner for camera at $position');
    }

    if (currentOwner.id != owner.id) {
      throw Exception('Camera operation denied: ${owner.id} does not own camera at $position');
    }

    return switchToDesiredState(state);
  }

  /// Apply settings only if the owner has ownership
  ///
  /// This method ensures that only the current owner of the camera can change
  /// its state. If the provided [owner] is not the current owner, the state
  /// change will be ignored to prevent conflicts between multiple components
  /// trying to control the same camera.
  ///
  /// **RECOMMENDED**: Use [CameraOwnershipHelper] for easier ownership management:
  /// ```dart
  /// final owner = MyFeatureOwner(); // implements CameraOwner
  ///
  /// // Option 1: Use helper to acquire ownership and perform operation
  /// await CameraOwnershipHelper.withCamera<void>(
  ///   CameraPosition.worldFacing,
  ///   owner,
  ///   (camera) async => await camera.applySettingsProtected(cameraSettings, owner)
  /// );
  ///
  /// // Option 2: Request ownership first, then use camera
  /// final success = await CameraOwnershipHelper.requestOwnership(CameraPosition.worldFacing, owner);
  /// if (success) {
  ///   final camera = CameraOwnershipHelper.getCamera(CameraPosition.worldFacing, owner);
  ///   await camera?.applySettingsProtected(cameraSettings, owner);
  /// }
  /// ```
  ///
  /// Manual ownership management (not recommended):
  /// ```dart
  /// final camera = Camera.defaultCamera;
  /// final owner = MyFeatureOwner();
  ///
  /// // Manual approach - use CameraOwnershipHelper instead
  /// CameraOwnershipManager.getInstance().requestOwnership(camera.position, owner);
  /// await camera.applySettingsProtected(cameraSettings, owner);
  /// ```
  ///
  /// **EXPERIMENTAL**: This API is experimental and may change or be removed
  /// in future versions without prior notice.
  ///
  /// Parameters:
  /// - [settings]: The desired camera settings to apply
  /// - [owner]: The camera owner requesting the state change
  Future<void> applySettingsProtected(CameraSettings settings, CameraOwner owner) async {
    final ownershipManager = CameraOwnershipManager.getInstance();
    final currentOwner = ownershipManager.getCurrentOwner(position);

    if (currentOwner == null) {
      throw Exception('Camera operation denied: No owner for camera at $position');
    }

    if (currentOwner.id != owner.id) {
      throw Exception('Camera operation denied: ${owner.id} does not own camera at $position');
    }

    return applySettings(settings);
  }

  /// Set desired torch state only if the owner has ownership
  ///
  /// This method ensures that only the current owner of the camera can change
  /// its state. If the provided [owner] is not the current owner, the state
  /// change will be ignored to prevent conflicts between multiple components
  /// trying to control the same camera.
  ///
  /// **RECOMMENDED**: Use [CameraOwnershipHelper] for easier ownership management:
  /// ```dart
  /// final owner = MyFeatureOwner(); // implements CameraOwner
  ///
  /// // Option 1: Use helper to acquire ownership and perform operation
  /// await CameraOwnershipHelper.withCamera<void>(
  ///   CameraPosition.worldFacing,
  ///   owner,
  ///   (camera) async => await camera.setDesiredTorchStateProtected(TorchState.on, owner)
  /// );
  ///
  /// // Option 2: Request ownership first, then use camera
  /// final success = await CameraOwnershipHelper.requestOwnership(CameraPosition.worldFacing, owner);
  /// if (success) {
  ///   final camera = CameraOwnershipHelper.getCamera(CameraPosition.worldFacing, owner);
  ///   await camera?.setDesiredTorchStateProtected(TorchState.on, owner);
  /// }
  /// ```
  ///
  /// Manual ownership management (not recommended):
  /// ```dart
  /// final camera = Camera.defaultCamera;
  /// final owner = MyFeatureOwner();
  ///
  /// // Manual approach - use CameraOwnershipHelper instead
  /// CameraOwnershipManager.getInstance().requestOwnership(camera.position, owner);
  /// await camera.setDesiredTorchStateProtected(TorchState.on, owner);
  /// ```
  ///
  /// **EXPERIMENTAL**: This API is experimental and may change or be removed
  /// in future versions without prior notice.
  ///
  /// Parameters:
  /// - [state]: The desired torch state to set
  /// - [owner]: The camera owner requesting the state change
  void setDesiredTorchStateProtected(TorchState state, CameraOwner owner) {
    final ownershipManager = CameraOwnershipManager.getInstance();
    final currentOwner = ownershipManager.getCurrentOwner(position);

    if (currentOwner == null) {
      throw Exception('Camera operation denied: No owner for camera at $position');
    }

    if (currentOwner.id != owner.id) {
      throw Exception('Camera operation denied: ${owner.id} does not own camera at $position');
    }

    desiredTorchState = state;
  }

  /// Check if the camera is owned by the specified owner
  bool isOwnedBy(CameraOwner owner) {
    final ownershipManager = CameraOwnershipManager.getInstance();
    return ownershipManager.isOwner(position, owner);
  }

  /// Get the current owner of this camera
  CameraOwner? get currentOwner {
    final ownershipManager = CameraOwnershipManager.getInstance();
    return ownershipManager.getCurrentOwner(position);
  }
}
