import 'package:caloriecounter/models/ingridient.dart';
import 'package:caloriecounter/utils/eatable.dart';
import 'package:flutter/material.dart';

class Recipe with ChangeNotifier implements Eatable {
  String _id = '';
  String _name = '';
  double _totalWeight = 0.0;
  double _totalEnergy = 0.0;
  double _totalProtein = 0.0;
  double _totalCarbohydrates = 0.0;
  double _totalFat = 0.0;
  List<Ingredient> _ingredients = [];
  String _instructions = '';

  void setId(String value) {
    _id = value;
    notifyListeners();
  }

  void setName(String value) {
    _name = value;
    notifyListeners();
  }

  void setTotalWeight(double value) {
    _totalWeight = value;
    notifyListeners();
  }

  void setTotalEnergy(double value) {
    _totalEnergy = value;
    notifyListeners();
  }

  void setTotalProtein(double value) {
    _totalProtein = value;
    notifyListeners();
  }

  void setTotalCarbohydrates(double value) {
    _totalCarbohydrates = value;
    notifyListeners();
  }

  void setTotalFat(double value) {
    _totalFat = value;
    notifyListeners();
  }

  void setIngredients(List<Ingredient> value) {
    _ingredients = value;
    notifyListeners();
  }

  void setInstructions(String value) {
    _instructions = value;
    notifyListeners();
  }

  @override
  String getId() {
    return _id;
  }

  @override
  double getEnergy() {
    return _totalEnergy;
  }

  @override
  String getName() {
    return _name;
  }

  @override
  double getValuePer() {
    return _totalWeight;
  }

  double getTotalProtein() {
    return _totalProtein;
  }

  double getTotalCarbohydrates() {
    return _totalCarbohydrates;
  }

  double getTotalFat() {
    return _totalFat;
  }

  List<Ingredient> getIngredients() {
    return _ingredients;
  }

  String getInstructions() {
    return _instructions;
  }

  Recipe();

  Recipe.full(
    this._id,
    this._name,
    this._totalWeight,
    this._totalEnergy,
    this._totalProtein,
    this._totalCarbohydrates,
    this._totalFat,
    this._instructions,
    this._ingredients,
  );

  Recipe.basic(this._name, this._instructions);
}
