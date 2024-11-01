import 'package:caloriecounter/models/product.dart';
import 'package:caloriecounter/services/auth_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  runApp(
    ChangeNotifierProvider(
      create: (context) => Product(),
      child: CalorieCounterApp(),
    ),
  );
}

class CalorieCounterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthChecker(),
    );
  }
}
