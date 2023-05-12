import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef FirstWidgetCreatedCallback = void Function(
    FirstWidgetController controller);

class FirstWidget extends StatefulWidget {
  const FirstWidget({
    super.key,
    this.onFirstWidgetWidgetCreated,
  });

  final FirstWidgetCreatedCallback? onFirstWidgetWidgetCreated;

  @override
  State<StatefulWidget> createState() => _FirstWidgetState();
}

class _FirstWidgetState extends State<FirstWidget> {
  FirstWidgetController? controller;

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'plugins/first_widget',
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
    return const Text('iOS platform version is not implemented yet.');
  }

  void _onPlatformViewCreated(int id) {
    controller = FirstWidgetController._(id);
    widget.onFirstWidgetWidgetCreated?.call(controller!);
  }

  @override
  void dispose() {
    controller?.close();
    super.dispose();
  }
}

class FirstWidgetController {
  FirstWidgetController._(int id)
      : _channel = MethodChannel('plugins/first_widget_$id'),
        _eventChannel = EventChannel('plugins/first_widget_event_$id') {
    print("luan init $id");
    eventStream = _eventChannel
        .receiveBroadcastStream("Luan")
        .listen(_onEvent, onError: _onError);
  }

  final MethodChannel _channel;
  final EventChannel _eventChannel;
  StreamSubscription? eventStream;

  Future<void> ping() async {
    return _channel.invokeMethod('ping');
  }

  void _onEvent(Object? event) {
    print("First widget onEven $event");
  }

  void _onError(Object error) {
    print("First widget _onError $error");
  }

  void close() {
    eventStream?.cancel();
    eventStream = null;
  }
}
