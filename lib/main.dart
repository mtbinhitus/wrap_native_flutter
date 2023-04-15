import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';

import 'native_view_example.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = MethodChannel('com.example.wrap_native_flutter/battery');
  // Get battery level.
  String _batteryLevel = 'Unknown battery level.';

  // Event channel
  static const stream = const EventChannel('com.example.wrap_native_flutter/stream');

  late StreamSubscription _streamSubscription;
  double _currentValue = 0.0;

  void _startListener() {
    _streamSubscription = stream.receiveBroadcastStream().listen(_listenStream);
  }

  void _cancelListener() {
    _streamSubscription.cancel();
    setState(() {
      _currentValue = 0;
    });
  }

  void _listenStream(value) {
    debugPrint("Received From Native:  $value\n");
    setState(() {
      _currentValue = value;
    });
  }

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _getBatteryLevel,
              child: const Text('Get Battery Level'),
            ),
            Text(_batteryLevel),
            // Card(
            //   child: SizedBox(
            //     height: 200,
            //     child: FirstWidget(),
            //   ),
            // ),
            // Card(
            //   child: SizedBox(
            //     height: 200,
            //     child: FirstWidget(),
            //   ),
            // ),
            //Progress bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LinearProgressIndicator(
                value: _currentValue,
                backgroundColor: Colors.blue.shade50,
              ),
            ),
            const SizedBox(
              height: 5,
            ),

            // Value in text
            Text("Received Stream From Native:  $_currentValue".toUpperCase(),
                textAlign: TextAlign.justify),
            const SizedBox(
              height: 50,
            ),

            //Start Btn
            TextButton(
              onPressed: () => _startListener(),
              child: Text("Start Counter".toUpperCase()),
            ),
            const SizedBox(
              height: 50,
            ),

            //Cancel Btn
            TextButton(
              onPressed: () => _cancelListener(),
              child: Text("Cancel Counter".toUpperCase()),
            ),
          ],
        ),
      ),
    );
  }
}
