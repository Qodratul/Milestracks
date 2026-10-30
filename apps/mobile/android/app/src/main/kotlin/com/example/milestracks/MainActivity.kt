package com.example.milestracks

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import java.time.ZoneId

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.milestracks/storage")
            .setMethodCallHandler { call, result ->
                if (call.method == "getApplicationSupportDirectory") {
                    result.success(filesDir.absolutePath)
                } else {
                    result.notImplemented()
                }
            }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.milestracks/device")
            .setMethodCallHandler { call, result ->
                if (call.method == "getIanaTimezone") {
                    result.success(ZoneId.systemDefault().id)
                } else {
                    result.notImplemented()
                }
            }
    }
}
