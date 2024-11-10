import 'package:caloriecounter/models/product.dart';
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
                  Product.basic('Cereal with milk', 545, 100),
                  Product.basic('Sausage', 300, 100),
                  Product.basic('Banana', 100, 100)
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
                  Product.basic('Pork chop', 500, 80),
                  Product.basic('Potatoes', 500, 70),
                  Product.basic('Salad', 200, 95)
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
                  Product.basic('Apple pie', 500, 100)
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
                  Product.basic('Grilled Chicken Breast (200g)', 330, 200),
                  Product.basic('Quinoa (1 cup, cooked)', 222, 50),
                  Product.basic('Avocado (1 medium)', 240, 30)
                ],
              ),
            ),
            
          ] 
        ),
      )
      
      
    );
    
  }
  

}