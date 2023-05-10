package com.example.luan_plugin.view

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import com.example.luan_plugin.R
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class FirstWidget internal constructor(context: Context, id: Int, messenger: BinaryMessenger) :
    PlatformView,
    MethodChannel.MethodCallHandler {
    private val view: View
    private val methodChannel: MethodChannel

    override fun getView(): View {
        return view
    }

    init {
        view = LayoutInflater.from(context).inflate(R.layout.first_widget, null, false)
        methodChannel = MethodChannel(messenger, "plugins/first_widget_$id")
        methodChannel.setMethodCallHandler(this)
    }

    override fun onMethodCall(methodCall: MethodCall, result: MethodChannel.Result) {
        when (methodCall.method) {
            "ping" -> ping(methodCall, result)
            else -> result.notImplemented()
        }
    }

    private fun ping(methodCall: MethodCall, result: MethodChannel.Result) {
        result.success(null)
    }

    override fun dispose() {
    }
}