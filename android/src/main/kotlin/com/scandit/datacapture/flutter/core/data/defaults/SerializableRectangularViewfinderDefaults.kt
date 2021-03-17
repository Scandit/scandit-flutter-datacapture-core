/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core.data.defaults

import com.scandit.datacapture.core.ui.viewfinder.RectangularViewfinder
import com.scandit.datacapture.flutter.core.data.SerializableData
import com.scandit.datacapture.flutter.core.utils.hexString
import org.json.JSONObject

class SerializableRectangularViewfinderDefaults(
    private val viewFinder: RectangularViewfinder
) : SerializableData {
    override fun toJson() = JSONObject(
        mapOf(
            FIELD_VIEW_FINDER_SIZE to viewFinder.sizeWithUnitAndAspect.toJson(),
            FIELD_VIEW_FINDER_COLOR to viewFinder.color.hexString
        )
    )

    companion object {
        private const val FIELD_VIEW_FINDER_SIZE = "size"
        private const val FIELD_VIEW_FINDER_COLOR = "color"
    }
}
