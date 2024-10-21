import 'package:flutter/material.dart';

import '../widgets/dish_section.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: MealCard(
          mealType: 'Breakfast',
          totalCalories: 945,
          ingredients: [
            {'name': 'Cereal with milk', 'calories': 545},
            {'name': 'Sausage', 'calories': 300},
            {'name': 'Banana', 'calories': 100},
          ],
        ),
    );
  }
}