// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:luan_plugin/widget/first.dart';

class PlatformChannel extends StatefulWidget {
  const PlatformChannel({super.key});

  @override
  State<PlatformChannel> createState() => _PlatformChannelState();
}

class _PlatformChannelState extends State<PlatformChannel> {
  static const MethodChannel methodChannel =
      MethodChannel('com.example.test.hello/battery');
  static const EventChannel eventChannel =
      EventChannel('com.example.test.hello/charging');

  String _batteryLevel = 'Battery level: unknown.';
  String _chargingStatus = 'Battery status: unknown.';

  StreamSubscription? eventStream;

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int? result =
          await methodChannel.invokeMethod('getBatteryLevel', "hehe");
      batteryLevel = 'Battery level: $result%.';
    } on PlatformException catch (e) {
      if (e.code == 'NO_BATTERY') {
        batteryLevel = 'No battery.';
      } else {
        batteryLevel = 'Failed to get battery level.';
      }
    }
    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  @override
  void initState() {
    super.initState();
    eventStream = eventChannel
        .receiveBroadcastStream("Luan")
        .listen(_onEvent, onError: _onError);
  }

  @override
  void dispose() {
    eventStream?.cancel();
    eventStream = null;
    super.dispose();
  }

  void _onEvent(Object? event) {
    setState(() {
      print("object $event");
      _chargingStatus =
          "Battery status: ${event == 'charging' ? '' : 'dis'}charging.";
    });
  }

  void _onError(Object error) {
    setState(() {
      _chargingStatus = 'Battery status: unknown.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Card(child: SizedBox(height: 200, child: FirstWidget())),
              ),
              Text(_batteryLevel, key: const Key('Battery level label')),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _getBatteryLevel,
                  child: const Text('Refresh'),
                ),
              ),
            ],
          ),
          Text(_chargingStatus),
        ],
      ),
    );
  }
}
