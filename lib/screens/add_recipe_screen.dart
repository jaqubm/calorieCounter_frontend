import 'package:caloriecounter/providers/recipe_provider.dart';
import 'package:caloriecounter/services/recipe_service.dart';
import 'package:caloriecounter/widgets/recipe_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddRecipeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Product')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: RecipeForm(
          isReadOnly: false,
          isEditMode: false,
          onRecipeSaved: (recipe) async {
            final recipeService = RecipeService();
            await recipeService.addRecipe(recipe);
            Provider.of<RecipeProvider>(context, listen: false).fetchRecipes();
            Navigator.pop(context, true);
          },
        ),
      ),
    );
  }
}
