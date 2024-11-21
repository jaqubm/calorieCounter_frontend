import 'package:caloriecounter/providers/dish_products_provider.dart';
import 'package:caloriecounter/providers/ingridient_provider.dart';
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
        ChangeNotifierProvider(create: (_) => DishProductProvider()),
        ChangeNotifierProvider(create: (_) => IngredientProvider()),

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
