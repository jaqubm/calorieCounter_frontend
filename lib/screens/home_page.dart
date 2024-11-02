import 'package:caloriecounter/screens/home_screen.dart';
import 'package:caloriecounter/screens/products_screen.dart';
import 'package:caloriecounter/screens/profile_screen.dart';
import 'package:caloriecounter/screens/recipes_screen.dart';
import 'package:caloriecounter/widgets/bottom_navigation_bar.dart';
import 'package:caloriecounter/widgets/nutritient_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static final int homeScreenIndex = 0;
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    RecipesScreen(),
    ProductsScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: _screens[_currentIndex]
          ),
          if (_currentIndex == homeScreenIndex) 
            NutritientBar(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
