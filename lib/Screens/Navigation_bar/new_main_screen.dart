import 'package:chefhospitalityservices/Controllers/auth_controller.dart';
import 'package:chefhospitalityservices/Controllers/profile_controller.dart';

import 'package:chefhospitalityservices/Screens/AlaCarteScreen.dart';
import 'package:chefhospitalityservices/Screens/Navigation_bar/custom_navigation_bar.dart';
import 'package:chefhospitalityservices/Screens/home_screen.dart';
import 'package:chefhospitalityservices/Screens/profile_screen.dart';
import 'package:chefhospitalityservices/Screens/subscription_screen.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // ============================================================
  // SELECTED TAB
  // ============================================================

  int _selectedIndex = 0;

  // ============================================================
  // SCREENS
  // ============================================================

  late final List<Widget> _widgetOptions;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    // ----------------------------------------------------------
    // CONTROLLERS
    // ----------------------------------------------------------

    if (!Get.isRegistered<ProfileController>()) {
      Get.put(
        ProfileController(),
      );
    }

    if (!Get.isRegistered<SignupController>()) {
      Get.put(
        SignupController(),
      );
    }

    // ----------------------------------------------------------
    // MAIN SCREENS
    // ----------------------------------------------------------

    _widgetOptions = [
      HomeScreen(),
      const AlaCarteScreen(),
      SubscriptionScreen(),
      const ProfileScreen(),
    ];
  }

  // ============================================================
  // CHANGE TAB
  // ============================================================

  void _onItemTapped(
    int index,
  ) {
    if (_selectedIndex == index) {
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF8),

      // ========================================================
      // SCREEN
      // ========================================================

      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),

      // ========================================================
      // BOTTOM NAVIGATION
      // ========================================================

      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
