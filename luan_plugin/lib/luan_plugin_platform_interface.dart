import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'luan_plugin_method_channel.dart';

abstract class LuanPluginPlatform extends PlatformInterface {
  /// Constructs a LuanPluginPlatform.
  LuanPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static LuanPluginPlatform _instance = MethodChannelLuanPlugin();

  /// The default instance of [LuanPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelLuanPlugin].
  static LuanPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [LuanPluginPlatform] when
  /// they register themselves.
  static set instance(LuanPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
