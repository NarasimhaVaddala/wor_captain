import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class OrderDivider extends StatelessWidget {
  const OrderDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 2,
      width: width,
      child: DottedBorder(
        color: Colors.grey,
        strokeWidth: 1.5,
        dashPattern: [4, 3],
        padding: EdgeInsets.zero,
        strokeCap: StrokeCap.round,
        customPath: (size) => Path()
          ..moveTo(0, size.height / 2)
          ..lineTo(size.width, size.height / 2),
        child: Container(),
      ),
    );
  }
}
