import 'package:chefhospitalityservices/Controllers/auth_controller.dart';
import 'package:chefhospitalityservices/Controllers/profile_controller.dart';
import 'package:chefhospitalityservices/Screens/Navigation_bar/custom_navigation_bar.dart';
import 'package:chefhospitalityservices/Screens/home_screen.dart';
import 'package:chefhospitalityservices/Screens/profile_screen.dart';
import 'package:chefhospitalityservices/Screens/subscription_screen.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    //   SpacelFoodScreen(),
    SubscriptionScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // ✅ FINAL FIX: Both controllers are now created here.
    // This guarantees that any screen inside MainScreen (like Home or Profile)
    // can safely use Get.find() to access them without causing a crash.
    Get.put(ProfileController());
    Get.put(SignupController()); // This line was added
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
