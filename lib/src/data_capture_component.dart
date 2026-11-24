/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import '../scandit_flutter_datacapture_core.dart';

/// Added in version 6.7.0
abstract class DataCaptureComponent implements Serializable {
  /// An ID for the component, currently only assignable during deserialization.
  ///
  /// Added in version 6.7.0
  final String id;

  DataCaptureComponent(this.id);

  @override
  Map<String, dynamic> toMap() {
    return {'id': id};
  }
}
