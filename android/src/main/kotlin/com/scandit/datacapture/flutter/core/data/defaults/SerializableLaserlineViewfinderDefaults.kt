/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core.data.defaults

import com.scandit.datacapture.core.common.geometry.toJson
import com.scandit.datacapture.core.ui.viewfinder.LaserlineViewfinder
import com.scandit.datacapture.flutter.core.data.SerializableData
import com.scandit.datacapture.flutter.core.utils.hexString
import org.json.JSONObject

class SerializableLaserlineViewfinderDefaults(
    private val viewFinder: LaserlineViewfinder
) : SerializableData {
    override fun toJson(): JSONObject = JSONObject(
        mapOf(
            FIELD_VIEW_FINDER_WIDTH to viewFinder.width.toJson(),
            FIELD_VIEW_FINDER_ENABLED_COLOR to viewFinder.enabledColor.hexString,
            FIELD_VIEW_FINDER_DISABLED_COLOR to viewFinder.disabledColor.hexString
        )
    )

    companion object {
        private const val FIELD_VIEW_FINDER_WIDTH = "width"
        private const val FIELD_VIEW_FINDER_ENABLED_COLOR = "enabledColor"
        private const val FIELD_VIEW_FINDER_DISABLED_COLOR = "disabledColor"
    }
}
