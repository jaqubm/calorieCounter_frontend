import 'package:flutter/material.dart';
import '../models/ingridient.dart';

class IngredientProvider with ChangeNotifier {
  List<Ingredient> _ingredients = [];

  List<Ingredient> get ingredients => _ingredients;

  void addIngredient(Ingredient ingredient) {
    _ingredients.add(ingredient);
    notifyListeners();
  }

  void clearIngredients() {
    _ingredients.clear();
    notifyListeners();
  }
}
