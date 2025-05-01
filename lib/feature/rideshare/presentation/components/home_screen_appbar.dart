import 'package:flutter/material.dart';

class RoundedAppBar extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback onMenuTap;

  const RoundedAppBar({super.key, required this.onMenuTap});

  @override
  State<RoundedAppBar> createState() => _RoundedAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _RoundedAppBarState extends State<RoundedAppBar> {
  bool isOnDuty = false;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 1,
              offset: Offset(0, 1),
            )
          ],
        ),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: widget.onMenuTap,
          ),
          centerTitle: true,
          title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isOnDuty ? "On Duty" : "Off Duty",
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(width: 8),
                Switch(
                  value: isOnDuty,
                  onChanged: (val) {
                    setState(() {
                      isOnDuty = val;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.location_on,
                    color: Color.fromARGB(255, 233, 50, 50)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
