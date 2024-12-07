
import 'dart:convert';

import 'package:caloriecounter/models/dish_element.dart';
import 'package:caloriecounter/models/dish_response.dart';
import 'package:caloriecounter/models/product.dart';
import 'package:caloriecounter/models/recipe.dart';
import 'package:caloriecounter/services/auth_service.dart';
import 'package:caloriecounter/services/product_service.dart';
import 'package:caloriecounter/services/recipe_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;


class DishService {
  final backendUrl = dotenv.env['BACKEND_URL']!;
  final AuthService authService = AuthService();
  

  Future<void> addDishData(DishElement dishElement) async {
    final idToken = await authService.getToken();
    final response = await http.post(
      Uri.parse('$backendUrl/UserEntries/Add'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
      body: json.encode({
        'entryType': dishElement.entryType,
        "entryId": dishElement.entryId,
        "date": dishElement.date,
        "mealType": dishElement.mealType,
        "weight": dishElement.weight
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to dish data. Server responded with status: ${response.body}');
    }
  }

  Future<void> deleteDishData(String entryId) async {
    final idToken = await authService.getToken();
    final response = await http.delete(
      Uri.parse('$backendUrl/UserEntries/Delete/${entryId}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to dish data. Server responded with status: ${response.body}');
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

  Future<Recipe?> fetchRecipeById(String recipeId) async {
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
    } else if (response.statusCode != 404) {
      throw Exception('Failed to load recipes');
    } else {
      return null;
    }
  }

  Future<List<Recipe>> fetchRecipesConnectedWithDish(DateTime selectedDay, String? dishName) async {
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
      List<DishResponse> dishResponse = data.map((json) => parseDishInfo(json)).toList();
      List<Recipe> dishInfo = [];
      for (var recipe in dishResponse) {
        if (dishName == null || recipe.mealType == dishName){
          Recipe? recipeById = await fetchRecipeById(recipe.entryId);
          if (recipeById != null){
             dishInfo.add(recipeById);
          }
        }
        
      }
      return dishInfo;
    } 

    return [];
  }

  Future<Product?> fetchProductById(String recipeId) async {
    final idToken = await authService.getToken();
    final response = await http.get(
      Uri.parse('$backendUrl/Product/Get/${recipeId}'),
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      return ProductService.parseProduct(jsonData);
    } else {
      return null;
    }
  }

  Future<List<Product>> fetchProductsConnectedWithDish(DateTime selectedDay, String? dishName) async {
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
      List<DishResponse> dishResponse = data.map((json) => parseDishInfo(json)).toList();
      List<Product> dishInfo = [];
      for (var recipe in dishResponse) {
        if (dishName == null || recipe.mealType == dishName){
          Product? productById = await fetchProductById(recipe.entryId);
          if (productById != null) {
            dishInfo.add(productById);
          }
        }
  
      }
      return dishInfo;
    } 
    return [];
  }

  Future<List<DishResponse>> fetchDishData(DateTime selectedDay) async {
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
      List<DishResponse> dishResponse = data.map((json) => parseDishInfo(json)).toList();
      return dishResponse;

    }

    return List.empty();
  }

  static DishResponse parseDishInfo(Map<String, dynamic> json) {

    return DishResponse.full(
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