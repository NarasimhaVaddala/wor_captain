import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class OrderRouteInfo extends StatelessWidget {
  const OrderRouteInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 20,
          child: Column(
            children: [
              const Icon(Icons.my_location, color: Colors.green),
              SizedBox(
                height: 40,
                child: DottedBorder(
                  color: Colors.grey,
                  strokeWidth: 1.5,
                  dashPattern: [4, 3],
                  padding: EdgeInsets.zero,
                  strokeCap: StrokeCap.round,
                  customPath: (size) => Path()
                    ..moveTo(size.width / 2, 0)
                    ..lineTo(size.width / 2, size.height),
                  child: Container(),
                ),
              ),
              const Icon(Icons.location_on, color: Colors.red),
            ],
          ),
        ),
        const SizedBox(width: 20),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Pickup: MG Road, Bangalore",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              Text("Pickup: MG Road, Bangalore",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                      color: Color.fromARGB(255, 78, 80, 79))),
              SizedBox(height: 30),
              Text("Drop: Indiranagar, Bangalore",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              Text("Drop: Indiranagar, Bangalore",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                      color: Color.fromARGB(255, 78, 80, 79))),
            ],
          ),
        ),
      ],
    );
  }
}
