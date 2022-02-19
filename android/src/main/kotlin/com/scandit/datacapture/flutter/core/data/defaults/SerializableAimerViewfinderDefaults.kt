/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core.data.defaults

import com.scandit.datacapture.core.ui.viewfinder.AimerViewfinder
import com.scandit.datacapture.flutter.core.data.SerializableData
import com.scandit.datacapture.flutter.core.utils.hexString
import org.json.JSONObject

class SerializableAimerViewfinderDefaults(
    private val viewFinder: AimerViewfinder
) : SerializableData {
    override fun toJson() = JSONObject(
        mapOf(
            FIELD_VIEW_FINDER_FRAME_COLOR to viewFinder.frameColor.hexString,
            FIELD_VIEW_FINDER_DOT_COLOR to viewFinder.dotColor.hexString
        )
    )

    companion object {
        private const val FIELD_VIEW_FINDER_FRAME_COLOR = "frameColor"
        private const val FIELD_VIEW_FINDER_DOT_COLOR = "dotColor"
    }
}
