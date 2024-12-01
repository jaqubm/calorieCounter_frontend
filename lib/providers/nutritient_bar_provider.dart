import 'package:caloriecounter/models/goals.dart';
import 'package:caloriecounter/services/nutritient_bar_service.dart';
import 'package:flutter/material.dart';

class NutritientProvider with ChangeNotifier {

  Goals _goals = Goals(0, 0, 0, 0);
  bool _isLoading = true;

  Goals get goals => _goals;
  bool get isLoading => _isLoading;

  NutritientProvider() {
    fetchGoals();
  }

  Future<void> fetchGoals() async {
    _isLoading = true;
    notifyListeners();

    try {
      _goals = await NutritientBarService().fetchGoalsData();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }
}
