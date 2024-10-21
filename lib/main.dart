import 'package:caloriecounter/screens/home_screen.dart';
import 'package:caloriecounter/screens/login_screen.dart';
import 'package:caloriecounter/screens/products_screen.dart';
import 'package:caloriecounter/screens/profile_screen.dart';
import 'package:caloriecounter/screens/recipes_screen.dart';
import 'package:caloriecounter/services/auth_checker.dart';
import 'package:caloriecounter/widgets/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  runApp(CalorieCounterApp());
}

class CalorieCounterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
        home: AuthChecker(),
    );
  }
}
