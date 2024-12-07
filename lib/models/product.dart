import 'package:caloriecounter/utils/eatable.dart';
import 'package:flutter/material.dart';

class Product with ChangeNotifier implements Eatable {
  String _id = '';
  String _name = '';
  double _valuesPer = 0.0;
  double _energy = 0.0;
  double _protein = 0.0;
  double _carbohydrates = 0.0;
  double _fat = 0.0;
  bool _isOwner = false;
  String? _entryId = '';

  void setId(String value) {
    _id = value;
    notifyListeners();
  }


  void setName(String value) {
    _name = value;
    notifyListeners();
  }

  void setEntryId(String value) {
    _entryId = value;
    notifyListeners();
  }

  void setValuesPer(double value) {
    _valuesPer = value;
    notifyListeners();
  }

  void setEnergy(double value) {
    _energy = value;
    notifyListeners();
  }

  void setProtein(double value) {
    _protein = value;
    notifyListeners();
  }

  void setCarbohydrates(double value) {
    _carbohydrates = value;
    notifyListeners();
  }

  void setFat(double value) {
    _fat = value;
    notifyListeners();
  }

    void setIsOwnerEmail(bool value) {
    _isOwner = value;
    notifyListeners();
  }

  Product();
  Product.basic(this._name, this._energy, this._valuesPer);

  Product.full({
    String id = '',
    required String name,
    double valuesPer = 0.0,
    double energy = 0.0,
    double protein = 0.0,
    double carbohydrates = 0.0,
    double fat = 0.0,
    bool isOwner = false,
    String? entryId,
  })  : _id = id,
        _name = name,
        _valuesPer = valuesPer,
        _energy = energy,
        _protein = protein,
        _carbohydrates = carbohydrates,
        _fat = fat,
        _isOwner = isOwner,
        _entryId = entryId;
  
  @override
  String getId() {
    return _id;
  }

  @override
  String? getEntryId() {
    return _entryId;
  }

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
  bool getIsOwner() {
    return _isOwner;
  }

  double getProtein(){
    return _protein;
  }

  double getCarbohydrates(){
    return _carbohydrates;
  }

  double getFat(){
    return _fat;
  }

}
