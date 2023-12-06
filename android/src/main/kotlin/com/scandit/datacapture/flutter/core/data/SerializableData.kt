/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core.data

import org.json.JSONObject

interface SerializableData {
    fun toJson(): JSONObject
}
