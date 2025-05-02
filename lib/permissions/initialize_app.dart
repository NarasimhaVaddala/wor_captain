import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:wor_captain/BgTask/bg_task.dart';

import 'package:wor_captain/permissions/battery_permission.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initializeApp() async {
  try {
    // Ensure Flutter bindings are initialized
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize permissions
    await _initializePermissions();

    // Initialize background service
    await initializeService();

    // Check and start background service if previously running
    await _initializeBackgroundService();
  } catch (e, stackTrace) {
    debugPrint('Error during app initialization: $e');
    debugPrint('Stack trace: $stackTrace');
    // Optionally log to Crashlytics or another service
  }
}

/// Requests necessary permissions (notification and battery optimization).
Future<void> _initializePermissions() async {
  // Request notification permission
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  // Request battery optimization permission
  final batteryPermission = await requestBatteryOptimization();
  debugPrint('Battery optimization permission: $batteryPermission');
}

/// Initializes and starts the background service if it was previously running.
Future<void> _initializeBackgroundService() async {
  final prefs = await SharedPreferences.getInstance();
  final bool serviceRunning = prefs.getBool('serviceRunning') ?? false;

  if (serviceRunning) {
    await FlutterBackgroundService().startService();
  }
}
