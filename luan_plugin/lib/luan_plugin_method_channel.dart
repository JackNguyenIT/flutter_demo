import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'luan_plugin_platform_interface.dart';

/// An implementation of [LuanPluginPlatform] that uses method channels.
class MethodChannelLuanPlugin extends LuanPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('luan_plugin');

  // final eventChannel = const EventChannel('CHARGING_CHANNEL');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
