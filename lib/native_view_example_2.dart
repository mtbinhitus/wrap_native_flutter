import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class FirstWidget extends StatefulWidget {
  const FirstWidget({
    Key? key,
  }) : super(key: key);


  @override
  State<StatefulWidget> createState() => _FirstWidgetState();
}

class _FirstWidgetState extends State<FirstWidget> {

  Widget build(BuildContext context) {
    // This is used in the platform side to register the view.
    const String viewType = 'com.example.native_view_example.FirstWidgetPlugin';
    // Pass parameters to the platform side.
    final Map<String, dynamic> creationParams = <String, dynamic>{};

    return AndroidView(
      viewType: viewType,
      layoutDirection: TextDirection.ltr,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
    );
  }

}
