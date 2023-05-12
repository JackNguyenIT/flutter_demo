package com.example.luan_plugin.view

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.widget.Button
import com.example.luan_plugin.R
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class FirstWidget internal constructor(context: Context, id: Int, messenger: BinaryMessenger) :
    PlatformView,
    MethodChannel.MethodCallHandler {
    private val view: View
    private val methodChannel: MethodChannel
    private val eventChannel: EventChannel

    override fun getView(): View {
        return view
    }

    init {
        view = LayoutInflater.from(context).inflate(R.layout.first_widget, null, false)
        methodChannel = MethodChannel(messenger, "plugins/first_widget_$id")
        methodChannel.setMethodCallHandler(this)
        eventChannel = EventChannel(messenger, "plugins/first_widget_event_$id")
        eventChannel.setStreamHandler(
            object :
                EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    createAction(events)
                }

                override fun onCancel(arguments: Any?) {

                }
            })
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


    private fun createAction(events: EventChannel.EventSink?) {
        getView().findViewById<Button>(R.id.bt).setOnClickListener {
            events?.success("bt_action")
        }
    }

}