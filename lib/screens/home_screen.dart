import 'package:caloriecounter/colors.dart';
import 'package:caloriecounter/widgets/nutritient_chart.dart';
import 'package:flutter/material.dart';

import '../widgets/dish_section.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
 
}

class HomeScreenState extends State<HomeScreen> {
  DateTime selectedDay = DateTime.now();

  void _selectPrevioiusDay(){
    setState(() {
      selectedDay = selectedDay.subtract(Duration(days: 1));
    });
  }

  void _selectNextDay(){
    setState(() {
      selectedDay = selectedDay.add(Duration(days: 1));
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:  Text(DateFormat('EEEE, MMM d').format(selectedDay)),
        centerTitle: true,
        leading: IconButton(
          onPressed: _selectPrevioiusDay,
          icon: Icon(Icons.arrow_back)
        ),
        actions: [
          IconButton(
            onPressed: _selectNextDay, 
            icon: Icon(Icons.arrow_forward)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: MealCard(
                mealType: 'Breakfast',
                totalCalories: 945,
                ingredients: [
                  {'name': 'Cereal with milk', 'calories': 545},
                  {'name': 'Sausage', 'calories': 300},
                  {'name': 'Banana', 'calories': 100},
                ],
              ),
            ),

            SizedBox(height: 16.0),

            Align(
              alignment: Alignment.center,
              child: MealCard(
                mealType: 'Lunch',
                totalCalories: 1200,
                ingredients: [
                  {'name': 'Pork chop', 'calories': 500},
                  {'name': 'Potatoes', 'calories': 500},
                  {'name': 'Salad', 'calories': 200},
                ],
              ),
            ),

            SizedBox(height: 16.0),

            Align(
              alignment: Alignment.center,
              child: MealCard(
                mealType: 'Dessert',
                totalCalories: 500,
                ingredients: [
                  {'name': 'Apple pie', 'calories': 500},
                ],
              ),
            ),

            SizedBox(height: 16.0),

            Align(
              alignment: Alignment.center,
              child: MealCard(
                mealType: 'Dinner',
                totalCalories: 792,
                ingredients: [
                  {'name': 'Grilled Chicken Breast (200g)', 'calories': 330},
                  {'name': 'Quinoa (1 cup, cooked)', 'calories': 222},
                  {'name': 'Avocado (1 medium)', 'calories': 240},
                ],
              ),
            ),
            
          ] 
        ),
      )
      
      
    );
    
  }
  

}