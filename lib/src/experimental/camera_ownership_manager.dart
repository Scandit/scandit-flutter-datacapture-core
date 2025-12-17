/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'package:meta/meta.dart';
import 'package:scandit_flutter_datacapture_core/src/experimental/camera_owner.dart';
import 'package:scandit_flutter_datacapture_core/src/source/camera_position.dart';

class _OwnershipRequest {
  final CameraOwner owner;
  final Completer<bool> completer;

  _OwnershipRequest(this.owner, this.completer);
}

@experimental
class CameraOwnershipManager {
  static CameraOwnershipManager? _instance;

  final Map<CameraPosition, CameraOwner> _owners = {};
  final Map<CameraPosition, List<_OwnershipRequest>> _waitingQueue = {};

  CameraOwnershipManager._();

  static CameraOwnershipManager getInstance() {
    _instance ??= CameraOwnershipManager._();
    return _instance!;
  }

  bool requestOwnership(CameraPosition position, CameraOwner owner) {
    final currentOwner = _owners[position];

    if (currentOwner != null && currentOwner.id != owner.id) {
      return false; // Already owned by someone else
    }

    _owners[position] = owner;
    return true;
  }

  Future<bool> requestOwnershipAsync(CameraPosition position, CameraOwner owner, [int? timeoutMs]) async {
    // Try immediate acquisition first
    if (requestOwnership(position, owner)) {
      return true;
    }

    // If not available, wait in queue
    final completer = Completer<bool>();
    final request = _OwnershipRequest(owner, completer);

    _waitingQueue.putIfAbsent(position, () => []).add(request);

    // Optional timeout
    if (timeoutMs != null && timeoutMs > 0) {
      Timer(Duration(milliseconds: timeoutMs), () {
        _removeFromQueue(position, request);
        if (!completer.isCompleted) {
          completer.complete(false); // Timeout - ownership not acquired
        }
      });
    }

    return completer.future;
  }

  bool releaseOwnership(CameraPosition position, CameraOwner owner) {
    final currentOwner = _owners[position];

    if (currentOwner == null || currentOwner.id != owner.id) {
      return false; // Not the owner
    }

    _owners.remove(position);
    _processWaitingQueue(position);
    return true;
  }

  bool isOwner(CameraPosition position, CameraOwner owner) {
    final currentOwner = _owners[position];
    return currentOwner?.id == owner.id;
  }

  CameraOwner? getCurrentOwner(CameraPosition position) {
    return _owners[position];
  }

  bool checkOwnership(CameraPosition position, CameraOwner owner) {
    return isOwner(position, owner);
  }

  CameraPosition? getOwnedPosition(CameraOwner owner) {
    for (final entry in _owners.entries) {
      if (entry.value.id == owner.id) {
        return entry.key;
      }
    }
    return null;
  }

  List<CameraPosition> getAllOwnedPositions(CameraOwner owner) {
    final positions = <CameraPosition>[];
    for (final entry in _owners.entries) {
      if (entry.value.id == owner.id) {
        positions.add(entry.key);
      }
    }
    return positions;
  }

  void _processWaitingQueue(CameraPosition position) {
    final queue = _waitingQueue[position];
    if (queue == null || queue.isEmpty) {
      return;
    }

    // Give ownership to the first in queue
    final nextRequest = queue.removeAt(0);
    _owners[position] = nextRequest.owner;
    nextRequest.completer.complete(true);

    // Clean up empty queue
    if (queue.isEmpty) {
      _waitingQueue.remove(position);
    }
  }

  void _removeFromQueue(CameraPosition position, _OwnershipRequest requestToRemove) {
    final queue = _waitingQueue[position];
    if (queue == null) return;

    queue.remove(requestToRemove);

    if (queue.isEmpty) {
      _waitingQueue.remove(position);
    }
  }
}
