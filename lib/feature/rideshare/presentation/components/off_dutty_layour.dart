import 'package:flutter/material.dart';

class OffDuttyLayour extends StatelessWidget {
  const OffDuttyLayour({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min, // Keeps column at minimum height
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Good Afternoon Partner"),
        ],
      ),
    );
  }
}
