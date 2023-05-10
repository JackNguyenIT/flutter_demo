
import 'luan_plugin_platform_interface.dart';

class LuanPlugin {
  Future<String?> getPlatformVersion() {
    return LuanPluginPlatform.instance.getPlatformVersion();
  }
}
