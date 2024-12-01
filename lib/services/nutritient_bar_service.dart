
import 'dart:convert';

import 'package:caloriecounter/models/goals.dart';
import 'package:caloriecounter/services/auth_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class NutritientBarService {
  final backendUrl = dotenv.env['BACKEND_URL']!;
  final AuthService authService = AuthService();
  

  Future<Goals> fetchGoalsData() async {
    final idToken = await authService.getToken();
    final response = await http.get(
      Uri.parse('$backendUrl/User/Get'),
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      Goals goals = Goals.fromJson(jsonData);
      return goals;
    } else {
      throw Exception('Failed to load goals');
    }
  }

  Future<void> editGoals(Goals goals) async {
    final idToken = await authService.getToken();
    final response = await http.put(
      Uri.parse('$backendUrl/User/UpdateGoals'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
      body: json.encode({
        'energy': goals.energy,
        'protein': goals.protein,
        'carbohydrates': goals.carbohydrates,
        'fat': goals.fat,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to save goals. Server responded with status: ${response.body}');
    }
  }

}

