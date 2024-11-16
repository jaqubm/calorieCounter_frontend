import 'package:flutter/material.dart';
import 'product.dart';

class Recipe with ChangeNotifier {
  String name = '';
  List<Product> products = [];
  String instructions = '';
  String ownerEmail = '';

  void setName(String value) {
    name = value;
    notifyListeners();
  }

  void setProducts(List<Product> value) {
    products = value;
    notifyListeners();
  }

  void addProduct(Product product) {
    products.add(product);
    notifyListeners();
  }

  void removeProduct(Product product) {
    products.remove(product);
    notifyListeners();
  }

  void setInstructions(String value) {
    instructions = value;
    notifyListeners();
  }

  void setOwnerEmail(String value) {
    ownerEmail = value;
    notifyListeners();
  }

  Recipe();
  Recipe.basic(this.name, this.instructions, this.ownerEmail);
}
