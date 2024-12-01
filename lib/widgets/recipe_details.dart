import 'package:caloriecounter/utils/formatters.dart';
import 'package:flutter/material.dart';
import 'package:caloriecounter/models/recipe.dart';

class RecipeDetails extends StatelessWidget {
  final Recipe? recipe;

  RecipeDetails({this.recipe});

  @override
  Widget build(BuildContext context) {
    if (recipe == null) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Weight:', recipe!.getValuePer()),
        _buildDetailRow('Energy:', recipe!.getEnergy()),
        _buildDetailRow('Protein:', recipe!.getTotalProtein()),
        _buildDetailRow('Carbohydrates:', recipe!.getTotalCarbohydrates()),
        _buildDetailRow('Fat:', recipe!.getTotalFat()),
      ],
    );
  }

  Widget _buildDetailRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Text(
            Formatters.formatDouble(value) + " g", 
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
