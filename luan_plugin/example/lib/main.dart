import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:luan_plugin/luan_plugin.dart';
import 'package:luan_plugin/widget/first.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _luanPlugin = LuanPlugin();

  static const EventChannel eventChannel =
      EventChannel('com.example.test.hello/charging');

  @override
  void initState() {
    super.initState();
    initPlatformState();
    eventChannel
        .receiveBroadcastStream("Luan")
        .listen(_onEvent, onError: _onError);
  }

  void _onEvent(Object? event) {
    print("onEven $event");
  }

  void _onError(Object error) {
    print("_onError $error");
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _luanPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              const Card(
                child: SizedBox(
                  height: 200,
                  child: FirstWidget(),
                ),
              ),
              Text('Running on: $_platformVersion\n'),
            ],
          ),
        ),
      ),
    );
  }
}
