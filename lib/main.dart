import 'package:caloriecounter/providers/dish_provider.dart';
import 'package:caloriecounter/providers/nutritient_bar_provider.dart';
import 'package:caloriecounter/providers/product_provider.dart';
import 'package:caloriecounter/providers/recipe_provider.dart';
import 'package:caloriecounter/services/auth_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => RecipeProvider()),
        ChangeNotifierProvider(create: (_) => DishProvider()),
        ChangeNotifierProvider(create: (_) => NutritientProvider()),
      ],
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
