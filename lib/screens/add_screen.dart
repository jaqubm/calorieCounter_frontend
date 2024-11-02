

import 'package:caloriecounter/colors.dart';
import 'package:flutter/material.dart';

class AddScreen extends StatefulWidget {
  final String dishName;
  final List<Map<String, dynamic>> ingredients;

  AddScreen({
    required this.dishName,
    required this.ingredients
  });

  @override
  State<StatefulWidget> createState() {
     return _AddScreenState(this.dishName, this.ingredients);
  }
  
}

class _AddScreenState extends State<AddScreen> {
  final String dishName;
  final List<Map<String, dynamic>> ingredients;

  _AddScreenState(this.dishName, this.ingredients);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(dishName),
      ),

      
    );
  }

}