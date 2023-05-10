import 'package:flutter_test/flutter_test.dart';
import 'package:luan_plugin/luan_plugin.dart';
import 'package:luan_plugin/luan_plugin_platform_interface.dart';
import 'package:luan_plugin/luan_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockLuanPluginPlatform
    with MockPlatformInterfaceMixin
    implements LuanPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final LuanPluginPlatform initialPlatform = LuanPluginPlatform.instance;

  test('$MethodChannelLuanPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelLuanPlugin>());
  });

  test('getPlatformVersion', () async {
    LuanPlugin luanPlugin = LuanPlugin();
    MockLuanPluginPlatform fakePlatform = MockLuanPluginPlatform();
    LuanPluginPlatform.instance = fakePlatform;

    expect(await luanPlugin.getPlatformVersion(), '42');
  });
}
