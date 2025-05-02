import 'package:flutter/material.dart';
import 'package:wor_captain/core/socket_instance.dart';
import 'package:wor_captain/feature/drawer_screens/orders/presentation/order_item.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class RealTimeOrder extends StatefulWidget {
  const RealTimeOrder({super.key});

  @override
  State<RealTimeOrder> createState() => _RealTimeOrderState();
}

class _RealTimeOrderState extends State<RealTimeOrder>
    with WidgetsBindingObserver {
  List<dynamic> _orders = [];

  bool _isAppInForeground = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    final socketService = SocketService();

    if (socketService.isConnected) {
      socketService.on("new-order", _handleNewOrder);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _isAppInForeground = state == AppLifecycleState.resumed;
      print("AppLifecycleState: $state, isForeground: $_isAppInForeground");
    });
  }

  void _handleNewOrder(dynamic data) {
    if (_isAppInForeground) {
      // App is in foreground: update UI
      setState(() {
        _orders = List.from(_orders)..add(data);
        print("New order added (foreground): $_orders");
      });
    } else {
      // App is in background: show overlay
      _showOverlay();
      print("New order received in background, showing overlay: $data");
    }
  }

  Future<void> _showOverlay() async {
    if (await FlutterOverlayWindow.isActive()) return;
    await FlutterOverlayWindow.showOverlay(
      enableDrag: true,
      overlayTitle: "New Order",
      overlayContent: 'New order received',
      flag: OverlayFlag.defaultFlag,
      visibility: NotificationVisibility.visibilityPublic,
      positionGravity: PositionGravity.auto,
      height: 600, // Adjust based on device
      width: WindowSize.matchParent,
      startPosition: const OverlayPosition(0, -259),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    SocketService().socket.off("new-order", _handleNewOrder);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizes = MediaQuery.of(context).size;
    return Container(
      width: sizes.width,
      height: sizes.height * 0.88,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 69, 63, 43),
      ),
      child: _orders.isEmpty
          ? const Center(
              child: Text(
                "No orders yet",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          : ListView.builder(
              key: UniqueKey(), // Force rebuild
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final orderData = _orders[index];
                print("Rendering OrderItem $index: $orderData");
                return OrderItem(
                  key: ValueKey("order_$index"), // Unique key per item
                  orderData: orderData,
                );
              },
            ),
    );
  }
}
