import 'package:caloriecounter/colors.dart';
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
      appBar: AppBar(
        title: Text(recipe.getIsOwner() ? 'Edit Recipe' : recipe.getName()),
        backgroundColor: AppColors.saveButtonColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 10),
            RecipeForm(
              isReadOnly: !recipe.getIsOwner(),
              isEditMode: true,
              initialRecipe: recipe as Recipe,
              onRecipeSaved: (updatedRecipe) async {
                final recipeService = RecipeService();
                await recipeService.updateRecipe(updatedRecipe);
                Provider.of<RecipeProvider>(context, listen: false)
                    .fetchRecipes();
                Navigator.pop(context, true);
              },
            ),
          ],
        ),
      ),
    );
  }
}
