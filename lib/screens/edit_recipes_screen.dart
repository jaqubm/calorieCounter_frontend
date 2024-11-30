import 'package:caloriecounter/models/recipe.dart';
import 'package:caloriecounter/providers/recipe_provider.dart';
import 'package:caloriecounter/services/recipe_service.dart';
import 'package:caloriecounter/utils/eatable.dart';
import 'package:caloriecounter/widgets/recipe_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditRecipeScreen extends StatelessWidget {
  final Eatable recipe;

  EditRecipeScreen({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Product')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: RecipeForm(
          initialRecipe: recipe as Recipe,
          onRecipeSaved: (updatedRecipe) async {
            final recipeService = RecipeService();
            await recipeService.updateRecipe(updatedRecipe);
            Provider.of<RecipeProvider>(context, listen: false).fetchRecipes();
            Navigator.pop(context, true);
          },
        ),
      ),
    );
  }
}
