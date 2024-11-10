import 'package:caloriecounter/models/product.dart';
import 'package:caloriecounter/services/dish_products_service.dart';
import 'package:flutter/material.dart';

class DishProductProvider with ChangeNotifier {
  List<Product> _ingredients = [];
  bool _isLoading = false;

  List<Product> get ingredients => _ingredients;
  bool get isLoading => _isLoading;

  void searchProducts(String query, List<Product> ingredients) {
    _isLoading = true;
    notifyListeners();
    if (query.isEmpty) {
      _ingredients = ingredients;
    } else {
      _ingredients = DishProductsService().searchProducts(query, ingredients);
            
    }
    _isLoading = false;
    notifyListeners();
  }
}
