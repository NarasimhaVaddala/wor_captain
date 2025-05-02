import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wor_captain/BgTask/bg_task.dart';
import 'package:wor_captain/BgTask/overlay_main.dart';
import 'package:wor_captain/core/location.dart';
import 'package:wor_captain/core/socket_instance.dart';
import 'package:wor_captain/feature/drawer_screens/orders/presentation/order_item.dart';
import 'package:wor_captain/feature/rideshare/presentation/components/off_dutty_layour.dart';
import 'package:wor_captain/feature/rideshare/presentation/screens/home_screen.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:wor_captain/permissions/battery_permission.dart';
import 'package:wor_captain/permissions/overlay_permission.dart';

@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OrderOverlayApp(),
    ),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize SocketService to make it globally available
  await SocketService().initialize();

  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });

  await requestBatteryOptimization();
  await requestOverlayPermission();

  await initializeService();
  final prefs = await SharedPreferences.getInstance();
  final bool serviceRunning = prefs.getBool('serviceRunning') ?? false;

  if (serviceRunning) {
    await FlutterBackgroundService().startService();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: GoogleFonts.robotoTextTheme(),
      ),
      home: BlocProvider(
        create: (context) => LocationBloc(),
        child: const HomeScreen(),
      ),
    );
  }
}
