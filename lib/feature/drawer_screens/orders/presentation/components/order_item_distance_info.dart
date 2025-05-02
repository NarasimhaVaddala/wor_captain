import 'package:flutter/material.dart';

class OrderDistanceInfo extends StatelessWidget {
  const OrderDistanceInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _DistanceBlock(title: "Pickup Distance", value: "1.2 KM"),
        _DistanceBlock(title: "Drop Distance", value: "1.2 KM"),
      ],
    );
  }
}

class _DistanceBlock extends StatelessWidget {
  final String title;
  final String value;
  const _DistanceBlock({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 92, 93, 93),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
