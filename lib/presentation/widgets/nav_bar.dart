import 'package:expenses_tracking_app/presentation/screens/add_expenses_screen.dart';
import 'package:expenses_tracking_app/presentation/screens/home_screen.dart';
import 'package:expenses_tracking_app/presentation/screens/stats_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class MainNavBar extends StatefulWidget {
  const MainNavBar({super.key});

  @override
  State<MainNavBar> createState() => _MainNavBarState();
}

class _MainNavBarState extends State<MainNavBar> {
  final PersistentTabController _controller = PersistentTabController(
    initialIndex: 0,
  );

  List<Widget> _buildScreens() => [
    HomeScreen(),
    const AddExpensesScreen(),
    const StatsScreen(),
  ];

  List<PersistentBottomNavBarItem> _navBarsItems() => [
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.house_fill, size: 30),
      activeColorPrimary: const Color(0xFF69AEA9),
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.add, color: Colors.white),
      activeColorPrimary: const Color(0xFF1E605B),
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.chart_bar_alt_fill, size: 30),
      activeColorPrimary: const Color(0xFF69AEA9),
      inactiveColorPrimary: Colors.grey,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      //navBarHeight: 50,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineToSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      navBarStyle: NavBarStyle.style15,
    );
  }
}
