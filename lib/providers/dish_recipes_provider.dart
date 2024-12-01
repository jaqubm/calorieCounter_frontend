import 'package:caloriecounter/models/recipe.dart';
import 'package:caloriecounter/services/dish_recipes_service.dart';
import 'package:flutter/material.dart';

class DishRecipeProvider with ChangeNotifier {
  List<Recipe> _recipes = [];
  bool _isLoading = false;

  List<Recipe> get recipes => _recipes;
  bool get isLoading => _isLoading;

  Future<void> addRecipe() async {
    _isLoading = true;
    notifyListeners();

    try {
      _recipes = await DishRecipesService().fetchDishRecipes();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDishRecipes() async {
    _isLoading = true;
    notifyListeners();
    try {
      _recipes = await DishRecipesService().fetchDishRecipes();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

   Future<void> fetchRecipesConnectedWithDish(DateTime selectedDay, String dishName) async {
    _isLoading = true;
    notifyListeners();
    try {
      _recipes = await DishRecipesService().fetchRecipesConnectedWithDish(selectedDay, dishName);

    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  
}
