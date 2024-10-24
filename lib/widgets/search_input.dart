import 'package:caloriecounter/colors.dart';
import 'package:flutter/material.dart';

class SearchInput extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;

  SearchInput({
    required this.hintText,
    required this.controller,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: AppColors.searchInputColor,
        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(Icons.search, color: Colors.green[800]),
      ),
      style: TextStyle(
        color: Colors.green[800],
      ),
    );
  }
}
