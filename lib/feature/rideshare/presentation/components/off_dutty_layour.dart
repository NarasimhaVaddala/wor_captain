import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';
import 'dart:async'; // Add for Timer
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class OffDuttyLayour extends StatefulWidget {
  const OffDuttyLayour({Key? key}) : super(key: key);

  @override
  State<OffDuttyLayour> createState() => _OffDuttyLayourState();
}

class _OffDuttyLayourState extends State<OffDuttyLayour> {
  static const String _kPortNameOverlay = 'OVERLAY';
  static const String _kPortNameHome = 'UI';
  final _receivePort = ReceivePort();
  SendPort? homePort;
  String? latestMessageFromOverlay;
  Timer? _timer; // Timer for 5-second overlay trigger

  @override
  void initState() {
    super.initState();
    print("initState called");

    if (homePort != null) {
      print("homePort is already set");
    } else {
      print("homePort is null - registering port");
    }

    final res = IsolateNameServer.registerPortWithName(
      _receivePort.sendPort,
      _kPortNameHome,
    );
    log("$res: OVERLAY");

    _receivePort.listen((message) {
      log("message from OVERLAY: $message");
      setState(() {
        latestMessageFromOverlay = 'Latest Message From Overlay: $message';
      });
    });

    // // Start 10-second timer to show overlay
    // _timer = Timer(const Duration(seconds: 10), () {
    //   print("Timer triggered: Overlay shown after 10 seconds");
    //   _showOverlay();
    // });
    // print("Timer started");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("didChangeDependencies called");
  }

  @override
  void didUpdateWidget(covariant OffDuttyLayour oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("didUpdateWidget called");
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel timer on dispose
    IsolateNameServer.removePortNameMapping(_kPortNameHome);
    print("dispose called and timer cancelled");
    super.dispose();
  }

  Future<void> _startService() async {
    final service = FlutterBackgroundService();
    await service.startService();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('serviceRunning', true);
    print("Background service started");
  }

  void _stopBg() {
    FlutterBackgroundService().invoke("stopService");
    print("Background service stopped");
  }

  void _showOverlay() async {
    if (await FlutterOverlayWindow.isActive()) {
      print("Overlay already active");
      return;
    }

    await FlutterOverlayWindow.showOverlay(
      enableDrag: true,
      overlayTitle: "X-SLAYER",
      overlayContent: 'Overlay Enabled',
      flag: OverlayFlag.defaultFlag,
      visibility: NotificationVisibility.visibilityPublic,
      positionGravity: PositionGravity.auto,
      height: (MediaQuery.of(context).size.height * 0.6).toInt(),
      width: WindowSize.matchParent,
      startPosition: const OverlayPosition(0, -259),
    );
    print("Overlay shown");
  }

  void _closeOverlay() {
    FlutterOverlayWindow.closeOverlay().then(
      (value) => log('STOPPED: value: $value'),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("build method called");
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: _startService,
            child: const Text("Bg Start"),
          ),
          ElevatedButton(
            onPressed: _stopBg,
            child: const Text("Stop Bg"),
          ),
          ElevatedButton(
            onPressed: _showOverlay,
            child: const Text("Show Overlay"),
          ),
          ElevatedButton(
            onPressed: _closeOverlay,
            child: const Text("Close Overlay"),
          ),
          if (latestMessageFromOverlay != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(latestMessageFromOverlay!),
            ),
        ],
      ),
    );
  }
}
