import 'package:permission_handler/permission_handler.dart';

Future<bool> requestBatteryOptimization() async {
  try {
    if (await Permission.ignoreBatteryOptimizations.isGranted) {
      return true;
    }

    if (await Permission.ignoreBatteryOptimizations.isDenied) {
      PermissionStatus status =
          await Permission.ignoreBatteryOptimizations.request();

      if (status.isGranted) {
        return true;
      } else {
        if (status.isPermanentlyDenied) {
          await openAppSettings();
        }
        return false;
      }
    }

    return false;
  } catch (e, stackTrace) {
    print("Error in requestBatteryOptimization: $e");
    print("Stack trace: $stackTrace");
    return false;
  }
}
