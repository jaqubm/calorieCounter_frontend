import 'package:caloriecounter/models/product.dart';
import 'package:caloriecounter/models/recipe.dart';
import 'package:caloriecounter/services/dish_service.dart';
import 'package:flutter/material.dart';

class DishProvider with ChangeNotifier {
  List<Recipe> _recipes = [];
  List<Product> _products = [];
  bool _isLoading = false;

  List<Recipe> get recipes => _recipes;
  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> addRecipe() async {
    _isLoading = true;
    notifyListeners();

    try {
      _recipes = await DishService().fetchDishRecipes();

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
      _recipes = await DishService().fetchDishRecipes();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

   Future<void> fetchDataConnectedWithDish(DateTime selectedDay, String dishName) async {
    _isLoading = true;
    notifyListeners();
    try {
      DishService dishService = DishService();
      _recipes = await dishService.fetchRecipesConnectedWithDish(selectedDay, dishName);
      _products = await dishService.fetchProductsConnectedWithDish(selectedDay, dishName);

    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  
}
