import 'package:caloriecounter/providers/recipe_provider.dart';
import 'package:caloriecounter/screens/add_recipe_screen.dart';
import 'package:caloriecounter/widgets/floating_button.dart';
import 'package:caloriecounter/widgets/found_items_list.dart';
import 'package:caloriecounter/widgets/search_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipesScreen extends StatefulWidget {
  @override
  _RecipesScreenState createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<RecipeProvider>(context, listen: false).fetchRecipes();
      });
      _isInitialized = true;
    }
  }

  void _onAddRecipe() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddRecipeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes'),
        ),
      body: Column(
        children: [
          SearchInput(
            hintText: 'Search recipes...',
            controller: _searchController,
            // onChanged: (query) => recipeProvider.searchRecipes(query),
          ),
          FoundItemsList(recipeProvider.isLoading, recipeProvider.recipes, (_) {})
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: FloatingButton(onPressed: _onAddRecipe),
      ),
    );
  }
}
