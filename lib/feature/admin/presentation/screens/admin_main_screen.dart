import 'package:flutter/material.dart';

import '../widgets/admin_bottom_navigation.dart';
import '../widgets/quick_action_sheet.dart';
import 'dashboard_screen.dart';
import 'finance_screen.dart';
import 'members_screen.dart';
import 'more_screen.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _selectedIndex = 0;

  static const _screens = <Widget>[
    DashboardScreen(),
    MembersScreen(),
    SizedBox.shrink(), // Center action is handled separately.
    FinanceScreen(),
    MoreScreen(),
  ];

  void _onTap(int index) {
    if (index == 2) {
      showQuickActionSheet(context);
      return;
    }
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final screenIndex = _selectedIndex == 0
        ? 0
        : _selectedIndex == 1
            ? 1
            : _selectedIndex == 3
                ? 2
                : 3;

    return Scaffold(
      backgroundColor: AdminColors.page,
      body: IndexedStack(
        index: screenIndex,
        children: const [
          DashboardScreen(),
          MembersScreen(),
          FinanceScreen(),
          MoreScreen(),
        ],
      ),
      bottomNavigationBar: AdminBottomNavigation(
        selectedIndex: _selectedIndex,
        onTap: _onTap,
      ),
    );
  }
}

class AdminColors {
  static const primary = Color(0xFFE93691);
  static const primaryLight = Color(0xFFFFE7F2);
  static const page = Color(0xFFFFF9FC);
  static const text = Color(0xFF17213F);
  static const muted = Color(0xFF78839D);
  static const border = Color(0xFFF0E7EF);
  static const green = Color(0xFF08B77A);
  static const blue = Color(0xFF3478F6);
  static const orange = Color(0xFFF5A623);
  static const red = Color(0xFFEF4444);
}
