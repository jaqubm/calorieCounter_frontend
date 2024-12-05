import 'package:caloriecounter/models/dish_element.dart';
import 'package:caloriecounter/models/dish_response.dart';
import 'package:caloriecounter/models/product.dart';
import 'package:caloriecounter/models/recipe.dart';
import 'package:caloriecounter/services/dish_service.dart';
import 'package:flutter/material.dart';

class DishProvider with ChangeNotifier {
  List<Recipe> _recipes = [];
  List<Product> _products = [];
  Map<String, List<Product>> _dishesData = {};

  bool _isLoading = false;

  List<Recipe> get recipes => _recipes;
  List<Product> get products => _products;
  Map<String, List<Product>> get dishesData => _dishesData;
  bool get isLoading => _isLoading;

  Future<void> addDishData(DishElement dishElement) async {
    _isLoading = true;
    notifyListeners();

    try {
      await DishService().addDishData(dishElement);
    } catch (e) {
      print("Error adding dish data: $e");
    } finally {
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

   Future<void> fetchDataConnectedWithDish(DateTime selectedDay, String? dishName) async {
    _isLoading = true;
    notifyListeners();
    try {
      DishService dishService = DishService();
      _recipes = await dishService.fetchRecipesConnectedWithDish(selectedDay, dishName);
      _products = await dishService.fetchProductsConnectedWithDish(selectedDay, dishName);
      List<DishResponse> dishesResponse = await dishService.fetchDishData(selectedDay);
      _dishesData = {};

      Map<String, List<DishResponse>> groupedByMealType = {};

      for (var dish in dishesResponse) {
        if (!groupedByMealType.containsKey(dish.mealType)) {
          groupedByMealType[dish.mealType] = [];
        }
        groupedByMealType[dish.mealType]!.add(dish);
      }

      for (var mealKey in groupedByMealType.keys) {
        if (groupedByMealType[mealKey] != null) {
          _dishesData[mealKey] = [];

          for (var meal in groupedByMealType[mealKey]!) {
           final Product foundProduct = _products.firstWhere(
              (product) => product.getId() == meal.entryId,
              orElse: () => Product()
            );

            if (foundProduct.getId() != "") {
              _dishesData[mealKey]!.add(foundProduct);
            }
            
          }
        }
      }

    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  
}
