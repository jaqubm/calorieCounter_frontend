import 'package:flutter/material.dart';
import 'package:caloriecounter/models/recipe.dart';
import 'package:caloriecounter/services/recipe_service.dart';

class RecipeProvider with ChangeNotifier {
  List<Recipe> _recipes = [];
  bool _isLoading = false;

  List<Recipe> get recipes => _recipes;
  bool get isLoading => _isLoading;

  Future<void> fetchRecipes() async {
    _isLoading = true;
    notifyListeners();
    try {
      _recipes = await RecipeService().fetchRecipes();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchRecipes(String query) async {
    if (query.isEmpty) {
      await fetchRecipes();
    } else {
      _isLoading = true;
      notifyListeners();
      try {
        _recipes = await RecipeService().searchRecipes(query);
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }
}
