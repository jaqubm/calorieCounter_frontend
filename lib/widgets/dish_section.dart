import 'package:flutter/material.dart';
import 'package:caloriecounter/colors.dart';

class MealCard extends StatelessWidget {
  final String mealType;
  final int totalCalories;
  final List<Map<String, dynamic>> ingredients;

  MealCard({
    required this.mealType,
    required this.totalCalories,
    required this.ingredients,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Card(
        shape: RoundedRectangleBorder (
          borderRadius: BorderRadius.circular(20),
        ),
        color: Color(0xFFFFFFFF),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(14.0),
                  
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(
                          mealType,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      

                      Text(
                        totalCalories.toString() + " kcal",
                        style: TextStyle(
                          color: AppColors.grayTextColor,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                 
                ),
              ),
              
             ...ingredients.map((ingredient) {
                final ingredientName = ingredient['name'];
                final ingredientCalories = ingredient['calories'];

                return Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                        ingredientName,
                          style: TextStyle(
                            fontSize: 13
                          ),
                        )
                      ),

                    Text(
                      ingredientCalories.toString() + " kcal",
                      style: TextStyle(
                        fontSize: 13
                      ),
                    ),
                      
                  ],
                ),
              );
             })
            ],
            
          ),
        
      )
    );  
  }
}

