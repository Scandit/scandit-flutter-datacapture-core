/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:meta/meta.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/sdk_logger.dart';
import 'package:scandit_flutter_datacapture_core/src/source/camera.dart';
import 'package:scandit_flutter_datacapture_core/src/experimental/camera_owner.dart';
// ignore: unused_import
import 'package:scandit_flutter_datacapture_core/src/experimental/camera_ownership_extensions.dart'; // Needed for extension methods
import 'package:scandit_flutter_datacapture_core/src/experimental/camera_ownership_manager.dart';
import 'package:scandit_flutter_datacapture_core/src/source/camera_position.dart';

@experimental
class CameraOwnershipHelper {
  static final CameraOwnershipManager _ownershipManager = CameraOwnershipManager.getInstance();

  /// Get camera instance for the owner (only works if you own it)
  static Camera? getCamera(CameraPosition position, CameraOwner owner) {
    // Check ownership
    if (!_ownershipManager.checkOwnership(position, owner)) {
      SdkLogger.info(
        'CameraOwnershipHelper',
        'getCamera',
        'Camera access denied: ${owner.id} does not own camera at $position',
      );
      return null;
    }

    return Camera.atPosition(position);
  }

  /// Safely execute camera operations (only works if you own the camera)
  static Future<T?> withCamera<T>(
    CameraPosition position,
    CameraOwner owner,
    Future<T> Function(Camera camera) operation,
  ) async {
    final camera = getCamera(position, owner);
    if (camera == null) {
      return null;
    }

    try {
      final result = await operation(camera);
      return result;
    } catch (error) {
      SdkLogger.info('CameraOwnershipHelper', 'withCamera', 'Camera operation failed for ${owner.id}: $error');
      rethrow;
    }
  }

  /// Safely execute camera operations (synchronous version)
  static T? withCameraSync<T>(
    CameraPosition position,
    CameraOwner owner,
    T Function(Camera camera) operation,
  ) {
    final camera = getCamera(position, owner);
    if (camera == null) {
      return null;
    }

    try {
      final result = operation(camera);
      return result;
    } catch (error) {
      SdkLogger.info('CameraOwnershipHelper', 'withCameraSync', 'Camera operation failed for ${owner.id}: $error');
      rethrow;
    }
  }

  /// Execute camera operations, waiting for ownership if necessary
  static Future<T?> withCameraWhenAvailable<T>(
    CameraPosition position,
    CameraOwner owner,
    Future<T> Function(Camera camera) operation, [
    int? timeoutMs,
  ]) async {
    // Try to get ownership, wait if necessary
    final acquired = await requestOwnership(position, owner, timeoutMs);
    if (!acquired) {
      SdkLogger.info('CameraOwnershipHelper', 'withCameraWhenAvailable',
          'Could not acquire camera ownership for ${owner.id} within timeout');
      return null;
    }

    final camera = Camera.atPosition(position);
    if (camera == null) {
      SdkLogger.info('CameraOwnershipHelper', 'withCameraWhenAvailable', 'Camera not available at position $position');
      return null;
    }

    try {
      final result = await operation(camera);
      return result;
    } catch (error) {
      SdkLogger.info(
          'CameraOwnershipHelper', 'withCameraWhenAvailable', 'Camera operation failed for ${owner.id}: $error');
      rethrow;
    }
  }

  /// Execute camera operations, waiting for ownership if necessary (synchronous version)
  static Future<T?> withCameraWhenAvailableSync<T>(
    CameraPosition position,
    CameraOwner owner,
    T Function(Camera camera) operation, [
    int? timeoutMs,
  ]) async {
    // Try to get ownership, wait if necessary
    final acquired = await requestOwnership(position, owner, timeoutMs);
    if (!acquired) {
      SdkLogger.info('CameraOwnershipHelper', 'withCameraWhenAvailableSync',
          'Could not acquire camera ownership for ${owner.id} within timeout');
      return null;
    }

    final camera = Camera.atPosition(position);
    if (camera == null) {
      SdkLogger.info(
          'CameraOwnershipHelper', 'withCameraWhenAvailableSync', 'Camera not available at position $position');
      return null;
    }

    try {
      final result = operation(camera);
      return result;
    } catch (error) {
      SdkLogger.info(
          'CameraOwnershipHelper', 'withCameraWhenAvailableSync', 'Camera operation failed for ${owner.id}: $error');
      rethrow;
    }
  }

  /// Request ownership and wait if necessary
  static Future<bool> requestOwnership(
    CameraPosition position,
    CameraOwner owner, [
    int? timeoutMs,
  ]) {
    return _ownershipManager.requestOwnershipAsync(position, owner, timeoutMs);
  }

  /// Release ownership
  static bool releaseOwnership(CameraPosition position, CameraOwner owner) {
    return _ownershipManager.releaseOwnership(position, owner);
  }

  /// Check if owner has ownership
  static bool hasOwnership(CameraPosition position, CameraOwner owner) {
    return _ownershipManager.checkOwnership(position, owner);
  }

  /// Get the camera position currently owned by the owner (if any)
  static CameraPosition? getOwnedPosition(CameraOwner owner) {
    return _ownershipManager.getOwnedPosition(owner);
  }

  /// Get all camera positions currently owned by the owner
  static List<CameraPosition> getAllOwnedPositions(CameraOwner owner) {
    return _ownershipManager.getAllOwnedPositions(owner);
  }

  /// Release ownership of all cameras owned by the owner
  static void releaseAllOwnerships(CameraOwner owner) {
    final ownedPositions = getAllOwnedPositions(owner);
    for (final position in ownedPositions) {
      releaseOwnership(position, owner);
    }
  }
}
