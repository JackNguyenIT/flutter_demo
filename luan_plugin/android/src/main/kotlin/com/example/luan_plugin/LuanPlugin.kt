package com.example.luan_plugin

import android.content.BroadcastReceiver
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build
import android.util.Log
import androidx.annotation.NonNull
import com.example.luan_plugin.view.FirstWidgetFactory
import io.flutter.embedding.android.FlutterActivity

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** LuanPlugin */
class LuanPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var eventChanel: EventChannel
    private var binding: FlutterPlugin.FlutterPluginBinding? = null
    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        binding = flutterPluginBinding
        flutterPluginBinding.platformViewRegistry.registerViewFactory(
            "plugins/first_widget",
            FirstWidgetFactory(flutterPluginBinding.binaryMessenger)
        )
        eventChanel = EventChannel(flutterPluginBinding.binaryMessenger, CHARGING_CHANNEL)

        eventChanel.setStreamHandler(
            object :
                EventChannel.StreamHandler {
                private var chargingStateChangeReceiver: BroadcastReceiver? = null
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    Log.d("Jack", "onListen $arguments")
                    chargingStateChangeReceiver = createChargingStateChangeReceiver(events)
                    binding?.applicationContext?.registerReceiver(
                        chargingStateChangeReceiver, IntentFilter(Intent.ACTION_BATTERY_CHANGED)
                    )
                }

                override fun onCancel(arguments: Any?) {
                    binding?.applicationContext?.unregisterReceiver(chargingStateChangeReceiver)
                    chargingStateChangeReceiver = null
                }
            })

        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "luan_plugin")
        channel.setMethodCallHandler(this)


        MethodChannel(
            flutterPluginBinding.binaryMessenger,
            BATTERY_CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method.equals("getBatteryLevel")) {
                Log.d("Jack", "start call ${call.arguments}")
                val batteryLevel = getBatteryLevel()
                if (batteryLevel != -1) {
                    result.success(batteryLevel)
                } else {
                    result.error("UNAVAILABLE", "Battery level not available.", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        eventChanel.setStreamHandler(null)
    }

    private fun createChargingStateChangeReceiver(events: EventChannel.EventSink?): BroadcastReceiver {
        return object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent) {
                val status: Int = intent.getIntExtra(BatteryManager.EXTRA_STATUS, -1)
                if (status == BatteryManager.BATTERY_STATUS_UNKNOWN) {
                    events?.error("UNAVAILABLE", "Charging status unavailable", null)
                } else {
                    val isCharging = status == BatteryManager.BATTERY_STATUS_CHARGING ||
                            status == BatteryManager.BATTERY_STATUS_FULL
                    events?.success(if (isCharging) "charging" else "discharging")
                }
            }
        }
    }

    private fun getBatteryLevel(): Int {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            val batteryManager: BatteryManager =
                binding?.applicationContext?.getSystemService(FlutterActivity.BATTERY_SERVICE) as BatteryManager
            batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        } else {
            val intent = ContextWrapper(binding?.applicationContext).registerReceiver(
                null,
                IntentFilter(Intent.ACTION_BATTERY_CHANGED)
            )
            intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 /
                    intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
        }
    }

    companion object {
        const val BATTERY_CHANNEL = "com.example.test.hello/battery"
        const val CHARGING_CHANNEL = "com.example.test.hello/charging"
    }
}
