/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

enum ScanIntention {
  manual('manual'),
  smart('smart');

  const ScanIntention(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension ScanIntentionSerializer on ScanIntention {
  static ScanIntention fromJSON(String jsonValue) {
    return ScanIntention.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
