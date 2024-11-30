import 'package:caloriecounter/colors.dart';
import 'package:caloriecounter/models/ingridient.dart';
import 'package:caloriecounter/models/recipe.dart';
import 'package:caloriecounter/screens/add_ingridient_screen.dart';
import 'package:caloriecounter/widgets/input_row.dart';
import 'package:flutter/material.dart';

class RecipeForm extends StatefulWidget {
  final Recipe? initialRecipe;
  final Function(Recipe) onRecipeSaved;

  RecipeForm({this.initialRecipe, required this.onRecipeSaved});

  @override
  _RecipeFormState createState() => _RecipeFormState();
}

class _RecipeFormState extends State<RecipeForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Ingredient> ingredients = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialRecipe != null) {
      _nameController.text = widget.initialRecipe!.getName();
      _instructionsController.text = widget.initialRecipe!.getInstructions();
      ingredients = widget.initialRecipe!.getIngredients();
    }
  }

  void _removeIngredient(int index) {
    setState(() {
      ingredients.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          InputRow(
            'Name',
            _nameController,
            '',
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Name is required';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Ingredients',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20),
          Column(
            children: ingredients.map((ingredient) {
              int index = ingredients.indexOf(ingredient);
              return ListTile(
                title: Text(ingredient.name),
                subtitle: Text('${ingredient.weight} g'),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.black),
                  onPressed: () => _removeIngredient(index),
                ),
              );
            }).toList(),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddIngredientScreen(
                          onIngredientAdded: (ingredient) {
                            setState(() {
                              ingredients.add(ingredient);
                            });
                          },
                        )),
              );
            },
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Icon(
                    Icons.add_circle_outline,
                    color: Colors.green,
                    size: 24.0,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'Add Ingredient',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40),
          TextFormField(
            controller: _instructionsController,
            maxLines: 4,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              hintText: 'Enter instructions',
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Instructions are required';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _handleSave(context),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              backgroundColor: AppColors.saveButtonColor,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.save,
                  color: Colors.black,
                ),
                SizedBox(width: 8),
                Text(
                  'Save Recipe',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleSave(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please add at least one ingredient')),
      );
      return;
    }

    final recipe = widget.initialRecipe ?? Recipe();

    recipe.setName(_nameController.text);
    recipe.setInstructions(_instructionsController.text);
    recipe.setIngredients(ingredients);

    widget.onRecipeSaved(recipe);
  }
}
