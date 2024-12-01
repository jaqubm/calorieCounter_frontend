import 'dart:convert';

import 'package:caloriecounter/models/ingridient.dart';
import 'package:caloriecounter/models/recipe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:caloriecounter/services/auth_service.dart';
import 'package:http/http.dart' as http;

class RecipeService {
  final backendUrl = dotenv.env['BACKEND_URL']!;
  final AuthService authService = AuthService();

  Future<List<Recipe>> fetchRecipes() async {
    final idToken = await authService.getToken();
    final response = await http.get(
      Uri.parse('$backendUrl/Recipe/GetListOfRecipes'),
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => _parseRecipe(json)).toList();
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  Future<List<Recipe>> searchRecipes(String query) async {
    final idToken = await authService.getToken();
    final response = await http.get(
      Uri.parse('$backendUrl/Recipe/Search/$query'),
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => _parseRecipe(json)).toList();
    } else {
      throw Exception('Failed to search recipes');
    }
  }

  Future<void> addRecipe(Recipe recipe) async {
    final idToken = await authService.getToken();
    final response = await http.post(
      Uri.parse('$backendUrl/Recipe/Create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
      body: json.encode({
        'name': recipe.getName(),
        'instructions': recipe.getInstructions(),
        'productsList': recipe
            .getIngredients()
            .map((ingredient) => ingredient.toJson())
            .toList()
      }),
    );
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to add recipe. Server responded with: ${response.body}');
    }
  }

    Future<void> updateRecipe(Recipe recipe) async {
    final idToken = await authService.getToken();
    final response = await http.put(
      Uri.parse('$backendUrl/Recipe/Update/${recipe.getId()}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
      body: json.encode({
        'name': recipe.getName(),
        'instructions': recipe.getInstructions(),
        'productsList': recipe
            .getIngredients()
            .map((ingredient) => ingredient.toJson())
            .toList()
      }),
    );
    if (response.statusCode != 200) {
if (response.statusCode != 200) {
  print('Response status code: ${response.statusCode}');
  print('Response body: ${response.body}');
  throw Exception('Failed to update recipe');
}    }
  }

  Recipe _parseRecipe(Map<String, dynamic> json) {
    List<Ingredient> ingredients = (json['recipeProducts'] as List<dynamic>)
        .map((item) => Ingredient(
              productId: item['productId'],
              name: item['productName'],
              weight: item['weight'].toDouble(),
            ))
        .toList();

    return Recipe.full(
      json['id'] ?? '',
      json['name'] ?? '',
      json['totalWeight']?.toDouble() ?? 0.0,
      json['totalEnergy']?.toDouble() ?? 0.0,
      json['totalProtein']?.toDouble() ?? 0.0,
      json['totalCarbohydrates']?.toDouble() ?? 0.0,
      json['totalFat']?.toDouble() ?? 0.0,
      json['instructions'] ?? '',
      json['isOwner'] ?? false,
      ingredients,
    );
  }
}
