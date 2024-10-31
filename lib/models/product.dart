import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  String name = '';
  double valuesPer = 0.0;
  double energy = 0.0;
  double protein = 0.0;
  double carbohydrates = 0.0;
  double fat = 0.0;
  String ownerEmail = "";
  
  void setName(String value) {
    name = value;
    notifyListeners();
  }

  void setValuesPer(double value) {
    valuesPer = value;
    notifyListeners();
  }

  void setEnergy(double value) {
    energy = value;
    notifyListeners();
  }

  void setProtein(double value) {
    protein = value;
    notifyListeners();
  }

  void setCarbohydrates(double value) {
    carbohydrates = value;
    notifyListeners();
  }

  void setFat(double value) {
    fat = value;
    notifyListeners();
  }

    void setOWnerEmail(String value) {
    ownerEmail = value;
    notifyListeners();
  }

}
