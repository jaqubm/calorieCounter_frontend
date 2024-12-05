import 'package:caloriecounter/colors.dart';
import 'package:caloriecounter/models/goals.dart';
import 'package:caloriecounter/providers/dish_provider.dart';
import 'package:caloriecounter/providers/nutritient_bar_provider.dart';
import 'package:caloriecounter/services/nutritient_bar_service.dart';
import 'package:caloriecounter/widgets/input_row.dart';
import 'package:caloriecounter/widgets/nutritient_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NutritientBar extends StatefulWidget {
  @override
  _NutritientBarState createState() => _NutritientBarState();
}

class _NutritientBarState extends State<NutritientBar> {
  late TextEditingController _caloriesController;
  late TextEditingController _proteinController;
  late TextEditingController _fatController;
  late TextEditingController _carbsController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  

  @override
  Widget build(BuildContext context) {
    final nutritientProvider = Provider.of<NutritientProvider>(context);
    final dishProvider = Provider.of<DishProvider>(context);

    if (nutritientProvider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    final dishes = dishProvider.fetchDataConnectedWithDish();

    final goals = nutritientProvider.goals;
    _caloriesController = TextEditingController(text: goals.energy.toString());
    _proteinController = TextEditingController(text: goals.protein.toString());
    _fatController = TextEditingController(text: goals.fat.toString());
    _carbsController = TextEditingController(text: goals.carbohydrates.toString());

    return GestureDetector(
      onTap: () {
        _showEditModal(context, goals);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NutritientChart(
                achieved: 2000,
                goal: goals.energy,
                color: const Color.fromARGB(255, 0, 0, 0),
                size: 70,
                achievedPostfix: '',
                additionalText: 'kcal',
              ),
              NutritientChart(
                achieved: 63,
                goal: goals.protein,
                color: AppColors.dontuPieColor2,
                size: 70,
                achievedPostfix: 'g',
                additionalText: 'Protein',
              ),
              NutritientChart(
                achieved: 150,
                goal: goals.fat,
                color: AppColors.dontuPieColor3,
                size: 70,
                achievedPostfix: 'g',
                additionalText: 'Fat',
              ),
              NutritientChart(
                achieved: 100,
                goal: goals.carbohydrates,
                color: AppColors.dontuPieColor4,
                size: 70,
                achievedPostfix: 'g',
                additionalText: 'Carbs',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditModal(BuildContext context, Goals goals) {
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
                        'Calories (kcal)',
                        _caloriesController,
                        '',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Calories are required';
                          }
                          return null;
                        },
                      ),
                      InputRow(
                        'Protein (g)',
                        _proteinController,
                        '',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Protein is required';
                          }
                          return null;
                        },
                      ),
                      InputRow(
                        'Fat (g)',
                        _fatController,
                        '',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Fat is required';
                          }
                          return null;
                        },
                      ),
                      InputRow(
                        'Carbs (g)',
                        _carbsController,
                        '',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Carbs are required';
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
                        onPressed: () => _saveGoals(context),
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
                              'Update Goals',
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

  Future<void> _saveGoals(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      final goals = Goals(0, 0, 0, 0);

      goals.energy = double.tryParse(_caloriesController.text) ?? 0.0;
      goals.protein = double.tryParse(_proteinController.text) ?? 0.0;
      goals.carbohydrates = double.tryParse(_carbsController.text) ?? 0.0;
      goals.fat = double.tryParse(_fatController.text) ?? 0.0;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      goals.email = prefs.getString('email') ?? "";

      final nutritientBarService = NutritientBarService();
      try {
        await nutritientBarService.editGoals(goals);
        Provider.of<NutritientProvider>(context, listen: false).fetchGoals();
        FocusScope.of(context).unfocus();

        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save goals: $e')),
        );
      }
    }
  }
}
