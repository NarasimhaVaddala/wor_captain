import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class OrderHeader extends StatelessWidget {
  const OrderHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Image.asset("assets/images/scooty.png", width: 50, height: 50),
              const SizedBox(width: 10),
              const Text(
                "Scooty",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        Row(
          children: [
            const Icon(Icons.person),
            const SizedBox(width: 10),
            DottedBorder(
              color: Colors.grey,
              strokeWidth: 1.5,
              dashPattern: [5, 3],
              borderType: BorderType.RRect,
              radius: const Radius.circular(10),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    Icon(Icons.star, color: Colors.orange, size: 18),
                    SizedBox(width: 4),
                    Text("4.5",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
