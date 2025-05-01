import 'package:flutter/material.dart';
import 'package:wor_captain/feature/rideshare/presentation/components/drawer_navigation.dart';
import 'package:wor_captain/feature/rideshare/presentation/components/home_screen_appbar.dart';
import 'package:wor_captain/feature/rideshare/presentation/components/off_dutty_layour.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // For drawer control

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: RoundedAppBar(
          onMenuTap: () => _scaffoldKey.currentState?.openDrawer()),
      drawer: const DrawerNavigation(),
      body: const OffDuttyLayour(),
    );
  }
}
