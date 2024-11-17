import 'package:caloriecounter/utils/eatable.dart';
import 'package:flutter/material.dart';
import 'product.dart';

class Recipe with ChangeNotifier implements Eatable {
  String _name = '';
  double _valuesPer = 0.0;
  double _energy = 0.0;
  List<Product> _products = [];
  String _instructions = '';
  String _ownerEmail = '';

  void setName(String value) {
    _name = value;
    notifyListeners();
  }

  void setProducts(List<Product> value) {
    _products = value;
    notifyListeners();
  }

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void removeProduct(Product product) {
    _products.remove(product);
    notifyListeners();
  }

  void setInstructions(String value) {
    _instructions = value;
    notifyListeners();
  }

  void setOwnerEmail(String value) {
    _ownerEmail = value;
    notifyListeners();
  }

  Recipe();
  Recipe.basic(this._name, this._instructions, this._ownerEmail);
  
 @override
  double getEnergy() {
    return _energy;
  }
  
  @override
  String getName() {
    return _name;
  }
  
  @override
  double getValuePer() {
    return _valuesPer;
  }
  
  @override
  String getOwnerEmail() {
    return _ownerEmail;
  }
  
  List<Product> getProducts(){
    return _products;
  }

  String getInstructions(){
    return _instructions;
  }
}
