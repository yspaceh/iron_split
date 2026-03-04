package com.ironsplit.app

import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    // 定義與 Flutter 端一致的通道名稱
    private val CHANNEL = "com.ironsplit/brightness"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // 註冊 MethodChannel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "setBrightness") {
                val brightness = call.argument<Double>("brightness")
                
                if (brightness != null) {
                    val layoutParams = window.attributes
                    
                    // Android 的亮度設置：
                    // 0.0 到 1.0 代表最暗到最亮
                    // 如果 Flutter 傳來 -1.0，則代表恢復系統預設亮度 (BRIGHTNESS_OVERRIDE_OFF)
                    layoutParams.screenBrightness = brightness.toFloat()
                    window.attributes = layoutParams
                    
                    result.success(null) // 回傳成功
                } else {
                    result.error("INVALID_ARGUMENT", "Brightness value is missing or invalid", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
