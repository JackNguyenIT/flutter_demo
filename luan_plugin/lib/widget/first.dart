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
    widget.onFirstWidgetWidgetCreated?.call(FirstWidgetController._(id));
  }
}

class FirstWidgetController {
  FirstWidgetController._(int id)
      : _channel = MethodChannel('plugins/first_widget_$id');

  final MethodChannel _channel;

  Future<void> ping() async {
    return _channel.invokeMethod('ping');
  }
}
