
import 'package:caloriecounter/colors.dart';
import 'package:caloriecounter/widgets/nutritient_chart.dart';
import 'package:flutter/material.dart';

class NutritientBar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NutritientChart(achieved: 2000, goal: 3200, color: const Color.fromARGB(255, 0, 0, 0), size: 70, achievedPostfix: '', additionalText: 'kcal',),
            NutritientChart(achieved: 63, goal: 70, color: AppColors.dontuPieColor2, size: 70, achievedPostfix: 'g', additionalText: 'Protein',),
            NutritientChart(achieved: 150, goal: 180, color: AppColors.dontuPieColor3, size: 70, achievedPostfix: 'g', additionalText: 'Fat',),
            NutritientChart(achieved: 100, goal: 130, color: AppColors.dontuPieColor4, size: 70, achievedPostfix: 'g', additionalText: 'Carbs',),
          ],
        ),
      ),
    );
  }
  
}