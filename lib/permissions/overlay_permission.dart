import 'package:flutter/services.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:developer' as developer;

/// Requests the overlay permission (SYSTEM_ALERT_WINDOW) for displaying windows over other apps.
///
/// Returns `true` if the permission is granted, `false` if denied or an error occurs.
Future<bool> requestOverlayPermission() async {
  try {
    // Check if permission is already granted
    final bool? isGranted = await FlutterOverlayWindow.isPermissionGranted();
    if (isGranted == true) {
      developer.log('Overlay permission already granted');
      return true;
    }

    // Request overlay permission
    final bool? result = await FlutterOverlayWindow.requestPermission();
    if (result == true) {
      developer.log('Overlay permission granted');
      return true;
    }

    // Permission denied, guide user to settings
    developer.log('Overlay permission denied');
    final isMIUI = await _isMIUIDevice();
    if (isMIUI) {
      developer.log('MIUI device detected, prompting for overlay settings');
      await _promptMIUIOverlaySettings();
    } else {
      await _openOverlaySettings();
    }

    // Re-check permission after user interaction
    final bool? finalCheck = await FlutterOverlayWindow.isPermissionGranted();
    final bool granted = finalCheck ?? false;
    developer.log('Overlay permission final status: $granted');
    return granted;
  } catch (e, stackTrace) {
    developer.log('Error requesting overlay permission: $e',
        stackTrace: stackTrace);
    return false;
  }
}

/// Checks if the device is running MIUI.
Future<bool> _isMIUIDevice() async {
  try {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    return androidInfo.manufacturer.toLowerCase().contains('xiaomi');
  } catch (e) {
    developer.log('Error checking device manufacturer: $e');
    return false;
  }
}

/// Opens the standard overlay permission settings screen.
Future<void> _openOverlaySettings() async {
  try {
    const platform = MethodChannel('com.example.wor_captain/permissions');
    await platform.invokeMethod('openOverlaySettings');
  } catch (e) {
    developer.log('Error opening overlay settings: $e');
    // Fallback to app settings if platform channel fails
    await _openAppSettings();
  }
}

/// Prompts the user to enable overlay permission on MIUI devices.
Future<void> _promptMIUIOverlaySettings() async {
  try {
    const platform = MethodChannel('com.example.wor_captain/permissions');
    await platform.invokeMethod('openMIUIOverlaySettings');
  } catch (e) {
    developer.log('Error opening MIUI overlay settings: $e');
    // Fallback to standard overlay settings
    await _openOverlaySettings();
  }
}

/// Opens the app's settings screen as a fallback.
Future<void> _openAppSettings() async {
  try {
    await MethodChannel('com.example.wor_captain/permissions')
        .invokeMethod('openAppSettings');
  } catch (e) {
    developer.log('Error opening app settings: $e');
  }
}
