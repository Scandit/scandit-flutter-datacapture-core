/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core.utils

import java.util.*

val Int.hexString: String
    get() {
        val hex = String.format(Locale.getDefault(), "%08X", this)
        return "#" + // dart is expecting the color in format #RRGGBBAA, we need to move the alpha.
            hex.substring(2) + // RRGGBB
            hex.substring(0, 2) // AA
    }
