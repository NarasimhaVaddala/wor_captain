import 'package:flutter/material.dart';
import 'package:wor_captain/feature/drawer_screens/orders/presentation/components/order_count_down_timer.dart';
import 'package:wor_captain/feature/drawer_screens/orders/presentation/components/order_item_distance_info.dart';
import 'package:wor_captain/feature/drawer_screens/orders/presentation/components/order_item_divider.dart';
import 'package:wor_captain/feature/drawer_screens/orders/presentation/components/order_item_header.dart';
import 'package:wor_captain/feature/drawer_screens/orders/presentation/components/order_item_route_info.dart';

class OrderItem extends StatelessWidget {
  final dynamic orderData; // Add orderData parameter

  const OrderItem({super.key, this.orderData});

  @override
  Widget build(BuildContext context) {
    final sizes = MediaQuery.of(context).size;

    return Container(
      width: sizes.width,
      height: 400,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: const Column(
        children: [
          Padding(
            padding: EdgeInsets.all(25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OrderHeader(),
                SizedBox(height: 20),
                OrderRouteInfo(),
              ],
            ),
          ),
          OrderDivider(),
          OrderDistanceInfo(),
          CountdownTimer(durationInSeconds: 30),
        ],
      ),
    );
  }
}
