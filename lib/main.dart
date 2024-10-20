import 'package:caloriecounter/screens/LoginScreen.dart';
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
        home: LoginScreen(),
    );
  }
  
}

