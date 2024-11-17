import 'dart:convert';
import 'package:caloriecounter/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:caloriecounter/models/product.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProductService {
  final backendUrl = dotenv.env['BACKEND_URL']!;
  final AuthService authService = AuthService();

  Future<List<Product>> fetchProducts() async {
    final idToken = await authService.getToken();
    final response = await http.get(
      Uri.parse('$backendUrl/Product/GetList'),
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => _parseProduct(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    final idToken = await authService.getToken();
    final response = await http.get(
      Uri.parse('$backendUrl/Product/Search/$query'),
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => _parseProduct(json)).toList();
    } else {
      throw Exception('Failed to search products');
    }
  }

  Future<void> addProduct(Product product) async {
    final idToken = await authService.getToken();
    final response = await http.post(
      Uri.parse('$backendUrl/Product/Create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
      body: json.encode({
        'name': product.getName(),
        'valuesPer': product.getValuePer(),
        'energy': product.getEnergy(),
        'protein': product.getProtein(),
        'carbohydrates': product.getCarbohydrates(),
        'fat': product.getFat(),
        'ownerEmail': product.getOwnerEmail(),
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to add product. Server responded with status: ${response.body}');
    }
  }

  Product _parseProduct(Map<String, dynamic> json) {
    Product product = Product();
    product.setName(json['name'] ?? '');
    product.setValuesPer((json['valuesPer'] as num?)?.toDouble() ?? 0.0);
    product.setEnergy((json['energy'] as num?)?.toDouble() ?? 0.0);
    product.setProtein((json['protein'] as num?)?.toDouble() ?? 0.0);
    product
        .setCarbohydrates((json['carbohydrates'] as num?)?.toDouble() ?? 0.0);
    product.setFat((json['fat'] as num?)?.toDouble() ?? 0.0);
    return product;
  }
}
