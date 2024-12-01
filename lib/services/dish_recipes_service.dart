
import 'dart:convert';

import 'package:caloriecounter/models/dish_recipe.dart';
import 'package:caloriecounter/models/dish_recipe_response.dart';
import 'package:caloriecounter/models/recipe.dart';
import 'package:caloriecounter/services/auth_service.dart';
import 'package:caloriecounter/services/recipe_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;


class DishRecipesService {
  final backendUrl = dotenv.env['BACKEND_URL']!;
  final AuthService authService = AuthService();
  

  Future<void> addRecipe(DishRecipe dishRecipe) async {
    final idToken = await authService.getToken();
    final response = await http.post(
      Uri.parse('$backendUrl/UserEntries/Add'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
      body: json.encode({
        'entryType': dishRecipe.entryType,
        "entryId": dishRecipe.entryId,
        "date": dishRecipe.date,
        "mealType": dishRecipe.mealType,
        "weight": dishRecipe.weight
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to save goals. Server responded with status: ${response.body}');
    }
  }

  Future<List<Recipe>> fetchDishRecipes() async {
    final idToken = await authService.getToken();
    final response = await http.get(
      Uri.parse('$backendUrl/Recipe/GetListOfRecipes'),
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => RecipeService.parseRecipe(json)).toList();
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  Future<Recipe> fetchRecipeById(String recipeId) async {
    final idToken = await authService.getToken();
    final response = await http.get(
      Uri.parse('$backendUrl/Recipe/Get/${recipeId}'),
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      return RecipeService.parseRecipe(jsonData);
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  Future<List<Recipe>> fetchRecipesConnectedWithDish(DateTime selectedDay, String dishName) async {
    String beginDate = DateTime(selectedDay.year, selectedDay.month, selectedDay.day).toUtc().toIso8601String();
    String endDate = DateTime(selectedDay.year, selectedDay.month, selectedDay.day, 23, 59).toUtc().toIso8601String();

    final idToken = await authService.getToken();
    final response = await http.get(
      Uri.parse('$backendUrl/UserEntries/Get?startDate=${beginDate}&endDate=${endDate}'),
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      List<DishRecipeResponse> dishRecipeResponse = data.map((json) => parseDishRecipe(json)).toList();
      List<Recipe> recipes = [];
      for (var recipe in dishRecipeResponse) {
        if (recipe.mealType == dishName){
          Recipe recipeById = await fetchRecipeById(recipe.entryId);
          recipes.add(recipeById);
        }
        
      }
      return recipes;
    } else {
      throw Exception('Failed to fetch recipes');
    }
  }

  static DishRecipeResponse parseDishRecipe(Map<String, dynamic> json) {

    return DishRecipeResponse.full(
      json['id'] ?? '',
      json['entryType'] ?? '',
      json['entryId'] ?? '',
      json['entryName']?? '',
      json['date'] ?? '',
      json['mealType'] ?? '',
      json['weight']?.toDouble() ?? 0.0,
    );
  }
}