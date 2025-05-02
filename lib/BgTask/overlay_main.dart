import 'package:flutter/material.dart';
import 'package:wor_captain/feature/drawer_screens/orders/presentation/order_item.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const OrderOverlayApp());
}

class OrderOverlayApp extends StatefulWidget {
  const OrderOverlayApp({super.key});

  @override
  State<OrderOverlayApp> createState() => _OrderOverlayAppState();
}

class _OrderOverlayAppState extends State<OrderOverlayApp> {
  List<dynamic> _overlayOrders = [];

  @override
  void initState() {
    super.initState();
    // Listen for order data from the main app
    FlutterOverlayWindow.overlayListener.listen((data) {
      if (data is Map) {
        setState(() {
          _overlayOrders = [..._overlayOrders, data];
          print("Overlay received order: $_overlayOrders");
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 69, 63, 43),
          ),
          child: _overlayOrders.isEmpty
              ? const Center(
                  child: Text(
                    "No new orders",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: _overlayOrders.length,
                  itemBuilder: (context, index) {
                    final orderData = _overlayOrders[index];
                    // return OrderItem(
                    //   key: ValueKey(index),
                    //   orderData: orderData,
                    // );
                    return Text("hellow");
                  },
                ),
        ),
      ),
    );
  }
}
