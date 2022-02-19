/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core.data.defaults

import com.scandit.datacapture.core.ui.viewfinder.RectangularViewfinder
import com.scandit.datacapture.core.ui.viewfinder.RectangularViewfinderStyle
import com.scandit.datacapture.core.ui.viewfinder.serialization.toJson
import com.scandit.datacapture.flutter.core.data.SerializableData
import com.scandit.datacapture.flutter.core.utils.hexString
import org.json.JSONObject

class SerializableRectangularViewfinderDefaults(
    private val viewFinder: RectangularViewfinder
) : SerializableData {
    override fun toJson() = JSONObject(
        mapOf(
            FIELD_VIEW_FINDER_DEFAULT_STYLE to viewFinder.style.toJson(),
            FIELD_VIEW_FINDER_STYLES to mapOf(
                RectangularViewfinderStyle.LEGACY.toJson() to
                    createViewfinderDefaults(RectangularViewfinderStyle.LEGACY),
                RectangularViewfinderStyle.ROUNDED.toJson() to
                    createViewfinderDefaults(RectangularViewfinderStyle.ROUNDED),
                RectangularViewfinderStyle.SQUARE.toJson() to
                    createViewfinderDefaults(RectangularViewfinderStyle.SQUARE)
            )
        )
    )

    private fun createViewfinderDefaults(
        style: RectangularViewfinderStyle
    ): Map<String, Any?> {
        return with(RectangularViewfinder(style)) {
            mapOf(
                FIELD_VIEW_FINDER_SIZE to sizeWithUnitAndAspect.toJson(),
                FIELD_VIEW_FINDER_COLOR to color.hexString,
                FIELD_VIEW_FINDER_STYLE to style.toJson(),
                FIELD_VIEW_FINDER_LINE_STYLE to lineStyle.toJson(),
                FIELD_VIEW_FINDER_DIMMING to dimming,
                FIELD_VIEW_FINDER_ANIMATION to animation?.toJson(),
                FIELD_VIEW_FINDER_DISABLED_DIMMING to disabledDimming
            )
        }
    }

    companion object {
        private const val FIELD_VIEW_FINDER_DEFAULT_STYLE = "defaultStyle"
        private const val FIELD_VIEW_FINDER_STYLES = "styles"
        private const val FIELD_VIEW_FINDER_SIZE = "size"
        private const val FIELD_VIEW_FINDER_COLOR = "color"
        private const val FIELD_VIEW_FINDER_STYLE = "style"
        private const val FIELD_VIEW_FINDER_LINE_STYLE = "lineStyle"
        private const val FIELD_VIEW_FINDER_DIMMING = "dimming"
        private const val FIELD_VIEW_FINDER_ANIMATION = "animation"
        private const val FIELD_VIEW_FINDER_DISABLED_DIMMING = "disabledDimming"
    }
}
