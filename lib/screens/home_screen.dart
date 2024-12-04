import 'package:caloriecounter/colors.dart';
import 'package:caloriecounter/models/dish_element.dart';
import 'package:caloriecounter/models/product.dart';
import 'package:caloriecounter/providers/dish_provider.dart';
import 'package:caloriecounter/services/dish_service.dart';
import 'package:caloriecounter/widgets/input_row.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  late TextEditingController _dishNameController;

  void _selectPrevioiusDay() {
    final dishProvider = Provider.of<DishProvider>(context, listen: false);
    if (!dishProvider.isLoading) {
      setState(() {
        selectedDay = selectedDay.subtract(Duration(days: 1));
      });
      dishProvider.fetchDataConnectedWithDish(selectedDay, null).then((_) {
        setState(() {});
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
        setState(() {});
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dishProvider = Provider.of<DishProvider>(context, listen: false);
      dishProvider.fetchDataConnectedWithDish(selectedDay, null);
    });
  }

  @override
  Widget build(BuildContext context) {
  _dishNameController = TextEditingController();
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

        ...dishProvider.dishesData.entries.map((entry) {
          final String mealType = entry.key;
          final List<Product> mealProducts = entry.value;

          return Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: MealCard(
                  mealType: mealType,
                  totalCalories: mealProducts.fold(
                    0,
                    (sum, product) => sum + product.getEnergy().toInt(),
                  ),
                  ingredients: mealProducts,
                  selectedDay: selectedDay,
                ),
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
                      InputRow(
                        'Dish name',
                        _dishNameController,
                        '',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Dish name is required';
                          }
                          return null;
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
                        onPressed: () => _saveDish(context),
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

  Future<void> _saveDish(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      String formattedDate = selectedDay.toUtc().toIso8601String();
      final dishElement = DishElement("Recipe", "123", formattedDate, _dishNameController.text, 0);

      SharedPreferences prefs = await SharedPreferences.getInstance();

      final dishService = DishService();
      try {
        await dishService.addDishData(dishElement);
        Provider.of<DishProvider>(context, listen: false).fetchDataConnectedWithDish(selectedDay, null);
        FocusScope.of(context).unfocus();

        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save dish: $e')),
        );
      }
    }
  }

}