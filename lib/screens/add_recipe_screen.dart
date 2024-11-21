import 'package:caloriecounter/colors.dart';
import 'package:caloriecounter/models/recipe.dart';
import 'package:caloriecounter/providers/ingridient_provider.dart';
import 'package:caloriecounter/providers/recipe_provider.dart';
import 'package:caloriecounter/screens/add_ingridient_screen.dart';
import 'package:caloriecounter/services/recipe_service.dart';

import 'package:caloriecounter/widgets/input_row.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddRecipeScreen extends StatefulWidget {
  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _navigateToAddIngredientScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddIngredientScreen()),
    );
  }
  
  @override
  void dispose() {
    // Wywołanie metody clear z IngredientProvider
    Provider.of<IngredientProvider>(context, listen: false).clearIngredients();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Center(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 100.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Text(
                      'Add Recipe',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                InputRow('Name', _nameController, ''),
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
                Consumer<IngredientProvider>(
                  builder: (context, provider, child) {
                    return Column(
                      children: provider.ingredients.map((ingredient) {
                        return ListTile(
                          title: Text(ingredient.name),
                          subtitle: Text('${ingredient.weight} g'),
                        );
                      }).toList(),
                    );
                  },
                ),
                GestureDetector(
                  onTap: () => _navigateToAddIngredientScreen(context),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white, // White background
                        ),
                        child: Icon(
                          Icons.add_circle_outline,
                          color: Colors.green, // Green icon color
                          size: 24.0,
                        ),
                      ),
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
                TextFormField(
                  controller: _instructionsController,
                  maxLines: 4, // Allows for multiline input
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter instructions here...',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter instructions';
                    }
                    return null;
                  },
                ),
                SizedBox(width: 8),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _addRecipe(context),
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
          ),
        ),
      ),
    );
  }

  Future<void> _addRecipe(BuildContext context) async {
    // if(_nameController.text.isEmpty || _instructionsController.text.isEmpty)
    final recipe = Recipe();
    final ingredientProvider =
        Provider.of<IngredientProvider>(context, listen: false);

    recipe.setName(_nameController.text);
    recipe.setInstructions(_instructionsController.text);
    recipe.setIngredients(ingredientProvider.ingredients);
    print("skladniki" + ingredientProvider.ingredients.toString());
    final recipeService = RecipeService();
    try {
      await recipeService.addRecipe(recipe);
      ingredientProvider.clearIngredients();

      Provider.of<RecipeProvider>(context, listen: false).fetchRecipes();
      FocusScope.of(context).unfocus();

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add recipe: $e')),
      );
    }
  }
}
