import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text("Off Duty Layout"),
      ),
      body: const NewOffDutyLayout(),
    ),
  ));
}

class NewOffDutyLayout extends StatefulWidget {
  const NewOffDutyLayout({super.key});

  @override
  State<NewOffDutyLayout> createState() => _NewOffDutyLayoutState();
}

class _NewOffDutyLayoutState extends State<NewOffDutyLayout>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _controller = AnimationController(
      duration: const Duration(seconds: 1), // Duration for one complete switch
      vsync: this,
    );

    // Define the animation (moving from left to right)
    _animation = Tween<double>(begin: 0.0, end: 60.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Loop the animation continuously
    _controller.repeat(
        reverse: true); // Reverse will make it move back and forth
  }

  @override
  void dispose() {
    _controller
        .dispose(); // Dispose the controller when widget is removed from tree
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 70,
            height: 50,
            child: Stack(
              children: [
                // Background Circle (Static)
                Positioned(
                  left: 0,
                  child: Container(
                    width: 60,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                // White Knob (Animated)
                Positioned(
                  left: _animation.value, // Animate the white knob
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Text(
            "Good Afternoon Partner - Driver",
            style: TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 8),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              children: [
                TextSpan(text: "Switch "),
                TextSpan(
                  text: "oOn Duty",
                  style: TextStyle(color: Colors.pink),
                ),
                TextSpan(text: " to Start Earning"),
              ],
            ),
          ),
          const SizedBox(height: 35),
          Image.asset(
            'assets/images/wor-logo.png',
            width: screenWidth * 0.6,
            height: 200,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
