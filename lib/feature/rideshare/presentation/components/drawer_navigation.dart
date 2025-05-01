import 'package:flutter/material.dart';

class DrawerNavigation extends StatelessWidget {
  const DrawerNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: const [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('Menu', style: TextStyle(color: Colors.white)),
          ),
          ListTile(title: Text('Profile')),
          ListTile(title: Text('Settings')),
          ListTile(title: Text('Logout')),
        ],
      ),
    );
  }
}
