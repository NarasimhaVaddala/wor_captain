import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final int durationInSeconds;
  const CountdownTimer({super.key, required this.durationInSeconds});

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  int get _remainingSeconds =>
      (widget.durationInSeconds * (1 - _controller.value)).ceil();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.durationInSeconds),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _ActionButton(
            icon: Icons.close,
            label: 'Close',
            iconColor: Colors.red,
            backgroundColor: Colors.grey.shade200,
            onTap: () {
              // Handle close action
            },
          ),
          const SizedBox(width: 20),
          _TimerCircle(
            progressValue: 1.0 - _controller.value,
            remainingSeconds: _remainingSeconds,
          ),
          const SizedBox(width: 20),
          _ActionButton(
            icon: Icons.check,
            label: 'Accept',
            iconColor: Colors.white,
            backgroundColor: const Color(0xFFFF6600),
            onTap: () {
              // Handle accept action
            },
          ),
        ],
      ),
    );
  }
}

// Timer circle with countdown
class _TimerCircle extends StatelessWidget {
  final double progressValue;
  final int remainingSeconds;

  const _TimerCircle({
    required this.progressValue,
    required this.remainingSeconds,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 50,
          width: 50,
          child: CircularProgressIndicator(
            value: progressValue,
            backgroundColor: Colors.grey.shade300,
            valueColor: const AlwaysStoppedAnimation(Colors.orange),
            strokeWidth: 4,
          ),
        ),
        Text(
          remainingSeconds.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

// Reusable action button with icon and label
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final Color backgroundColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: iconColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
