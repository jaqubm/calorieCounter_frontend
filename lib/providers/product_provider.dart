import 'package:flutter/material.dart';
import 'package:caloriecounter/models/product.dart';
import 'package:caloriecounter/services/product_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();
    try {
      _products = await ProductService().fetchProducts();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      await fetchProducts();
    } else {
      _isLoading = true;
      notifyListeners();
      try {
        _products = await ProductService().searchProducts(query);
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }
}
