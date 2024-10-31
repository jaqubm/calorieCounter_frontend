import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:caloriecounter/models/product.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProductService {
  final backendUrl = dotenv.env['BACKEND_URL']!; 

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(backendUrl + "/Product/GetList"));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
