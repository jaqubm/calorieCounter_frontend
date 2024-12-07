import 'package:caloriecounter/providers/dish_provider.dart';
import 'package:caloriecounter/screens/add_screen.dart';
import 'package:caloriecounter/utils/eatable.dart';
import 'package:flutter/material.dart';
import 'package:caloriecounter/colors.dart';
import 'package:provider/provider.dart';

class MealCard extends StatelessWidget {
  final String mealType;
  final int totalCalories;
  final List<Eatable> ingredients;
  final DateTime selectedDay;

  MealCard({
    required this.mealType,
    required this.totalCalories,
    required this.ingredients,
    required this.selectedDay
  });

  @override
  Widget build(BuildContext context) {
    void _onEditProduct(BuildContext context) async {
      final dishRecipeProvider = Provider.of<DishProvider>(context, listen: false);
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddScreen(dishName: mealType, selectedDay: selectedDay)),
      ); 
      
      await dishRecipeProvider.fetchDataConnectedWithDish(selectedDay, null); 
    }

    void _onDeleteProduct(BuildContext context, String? entryId) async {
      if (entryId == null) {
        return;
      }
      
      await _deleteEntry(context, entryId);
    }

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
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          iconSize: 30.0,
                          padding: EdgeInsets.all(8.0),
                          icon: Icon(Icons.add_circle_outline),
                          onPressed: () => _onEditProduct(context),
                        ),
                      ),
                    ],
                  ),
                 
                ),
              ),
              
             ...ingredients.map((ingredient) {
                final ingredientName = ingredient.getName();
                final ingredientCalories = ingredient.getEnergy().toInt();

                return Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                        ingredientName,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold
                          ),
                        )
                      ),

                    Text(
                      ingredientCalories.toString() + " kcal",
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.grayTextColor,
                        fontWeight: FontWeight.bold
                      ),
                    ),

                    IconButton(
                      iconSize: 30.0,
                      padding: EdgeInsets.all(8.0),
                      icon: Icon(Icons.delete, color: AppColors.cancelButtonColor),
                      onPressed: () => _onDeleteProduct(context, ingredient.getId()),
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

  Future<void> _deleteEntry(BuildContext context, String entryId) async {
    try {
      DishProvider dishProvider = await Provider.of<DishProvider>(context, listen: false);
      await dishProvider.deleteDishData(entryId);
      dishProvider.fetchDataConnectedWithDish(selectedDay, null);
  
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete entry: $e')),
      );
    }
  }
  
}

