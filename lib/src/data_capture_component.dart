/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import '../scandit_flutter_datacapture_core.dart';

abstract class DataCaptureComponent implements Serializable {
  final String id;

  DataCaptureComponent(this.id);

  @override
  Map<String, dynamic> toMap() {
    return {'id': id};
  }
}
