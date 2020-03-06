package com.janek

import android.os.Bundle
import com.flowkey.uikit.UIKitActivity

class MainActivity: UIKitActivity() {
    companion object {
        init {
            System.loadLibrary("raspi-alarm")
        }
    }
}
