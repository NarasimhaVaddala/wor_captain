import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wor_captain/core/location.dart';
import 'package:wor_captain/feature/rideshare/presentation/components/drawer_navigation.dart';
import 'package:wor_captain/feature/rideshare/presentation/components/home_map.dart';
import 'package:wor_captain/feature/rideshare/presentation/components/home_screen_appbar.dart';
import 'package:wor_captain/feature/rideshare/presentation/screens/realtime_order.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Automatically fetch location when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationBloc>().add(FetchLocation());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: RoundedAppBar(
        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: const DrawerNavigation(),
      body: const Stack(
        children: [
          Positioned.fill(
            child: HomeMap(),
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: RealTimeOrder(),
          ),
        ],
      ),
    );
  }
}
