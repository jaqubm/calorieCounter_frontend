import 'package:caloriecounter/models/dish_element.dart';
import 'package:caloriecounter/models/dish_response.dart';
import 'package:caloriecounter/models/product.dart';
import 'package:caloriecounter/models/recipe.dart';
import 'package:caloriecounter/services/dish_service.dart';
import 'package:caloriecounter/utils/eatable.dart';
import 'package:flutter/material.dart';

class DishProvider with ChangeNotifier {
  List<Recipe> _recipes = [];
  List<Product> _products = [];
  Map<String, List<Eatable>> _dishesData = {};

  bool _isLoading = false;

  List<Recipe> get recipes => _recipes;
  List<Product> get products => _products;
  Map<String, List<Eatable>> get dishesData => _dishesData;
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

  Future<void> deleteDishData(String entryId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await DishService().deleteDishData(entryId);
    } catch (e) {
      print("Error deleting dish data: $e");
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

            if (foundProduct.getId() == "") {
              final Recipe foundRecipe = _recipes.firstWhere(
              (recipe) => recipe.getId() == meal.entryId,
              orElse: () => Recipe()
             );

             if (foundRecipe.getId() != "") {
                Recipe entryRecipe = Recipe.asEntry(id: meal.id, name: foundRecipe.getName(), 
                energy: foundRecipe.getEnergy(), protein: foundRecipe.getTotalProtein(),
                carbohydrates: foundRecipe.getTotalCarbohydrates(), fat: foundRecipe.getTotalFat(), isOwner: foundRecipe.getIsOwner(),
                entryId: meal.entryId);

                _dishesData[mealKey]!.add(entryRecipe);
              }

              if (foundRecipe.getId() == "") {
                break;
              }
              
            }

            if (foundProduct.getId() != "") {
              Product entryProduct = Product.full(id: meal.id, name: foundProduct.getName(), 
              valuesPer: foundProduct.getValuePer(), energy: foundProduct.getEnergy(), protein: foundProduct.getProtein(),
              carbohydrates: foundProduct.getCarbohydrates(), fat: foundProduct.getFat(), isOwner: foundProduct.getIsOwner(),
              entryId: meal.entryId);

              _dishesData[mealKey]!.add(entryProduct);
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
