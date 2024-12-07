import 'package:caloriecounter/colors.dart';
import 'package:caloriecounter/providers/dish_provider.dart';
import 'package:caloriecounter/utils/eatable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _dishNameController;

  Map<String, List<Eatable>> meals = {};

  void _selectPrevioiusDay() {
    final dishProvider = Provider.of<DishProvider>(context, listen: false);
    if (!dishProvider.isLoading) {
      setState(() {
        selectedDay = selectedDay.subtract(Duration(days: 1));
      });
      dishProvider.fetchDataConnectedWithDish(selectedDay, null).then((_) {
        setState(() {
          meals.clear();
          meals.addAll(dishProvider.dishesData.map((key, value) => MapEntry(key, value)));
        });
      });
    }
  }

  void _selectNextDay() {
    final dishProvider = Provider.of<DishProvider>(context, listen: false);
    if (!dishProvider.isLoading) {
      setState(() {
        selectedDay = selectedDay.add(Duration(days: 1));
      });
      dishProvider.fetchDataConnectedWithDish(selectedDay, null).then((_) {
        setState(() {
          meals.clear();
          meals.addAll(dishProvider.dishesData.map((key, value) => MapEntry(key, value)));
        });
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final dishProvider = Provider.of<DishProvider>(context, listen: false);
    
    if (!dishProvider.isLoading) {
      setState(() {
        meals.clear();
        meals.addAll(dishProvider.dishesData.map((key, value) => MapEntry(key, value)));
      });
    }
  }


  void _addNewMeal(String mealName) {
    setState(() {
      meals[mealName] = [];
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dishProvider = Provider.of<DishProvider>(context, listen: false);
      dishProvider.fetchDataConnectedWithDish(selectedDay, null).then((_) {
        setState(() {
          meals.clear();
          meals.addAll(dishProvider.dishesData.map((key, value) => MapEntry(key, value)));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
  final dishProvider = Provider.of<DishProvider>(context, listen: true);

  return dishProvider.isLoading
  ? Center(child: CircularProgressIndicator())
  : Scaffold(
      appBar: AppBar(
        title: Text(DateFormat('EEEE, MMM d').format(selectedDay)),
        centerTitle: true,
        leading: IconButton(
          onPressed: _selectPrevioiusDay,
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: _selectNextDay,
            icon: Icon(Icons.arrow_forward),
          ),
        ],
      ),
      body: SingleChildScrollView(
      child: Column(
      children: [
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.saveButtonColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ElevatedButton(
              onPressed: () {
                _showAddDishModal(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: Text(
                'Add dish',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 16.0), 

      ...meals.entries.map((entry) {
        final mealName = entry.key;
        final ingredients = entry.value;

        return Column(
          children: [
            MealCard(
              mealType: mealName,
              totalCalories: ingredients.fold(
                  0,
                  (sum, product) =>
                      sum + product.getEnergy().toInt()),
              ingredients: ingredients,
              selectedDay: selectedDay,
            ),
            SizedBox(height: 16.0),
          ],
        );
      }).toList(),
    ],
    ),

    ),

    );
  }

  void _showAddDishModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: _dishNameController,
                        decoration: InputDecoration(
                          labelText: 'Dish type',
                          border: OutlineInputBorder(),
                        ),
                        items: ['Breakfast', 'Lunch', 'Dessert', 'Dinner']
                            .map((type) => DropdownMenuItem<String>(
                                  value: type,
                                  child: Text(type),
                                ))
                            .toList(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a dish type';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _dishNameController = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _addNewMeal(_dishNameController!.trim());
                            Navigator.of(context).pop();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                          backgroundColor: AppColors.saveButtonColor,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.save,
                              color: Colors.black,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Add dish',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                          backgroundColor: AppColors.cancelButtonColor,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.cancel,
                              color: Colors.black,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Cancel',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

}