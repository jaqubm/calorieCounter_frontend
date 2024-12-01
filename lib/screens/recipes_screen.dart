import 'package:caloriecounter/models/dish_recipe.dart';
import 'package:caloriecounter/models/recipe.dart';
import 'package:caloriecounter/providers/dish_recipes_provider.dart';
import 'package:caloriecounter/providers/recipe_provider.dart';
import 'package:caloriecounter/screens/add_recipe_screen.dart';
import 'package:caloriecounter/services/dish_recipes_service.dart';
import 'package:caloriecounter/utils/eatable.dart';
import 'package:caloriecounter/widgets/floating_button.dart';
import 'package:caloriecounter/widgets/found_items_list.dart';
import 'package:caloriecounter/widgets/search_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecipesScreen extends StatefulWidget {
  static final String defaultContext = 'default';
  static final String dishContext = 'dish';

  final String title;
  final String context;
  final DateTime? selectedDay;
  final String? dishName;

  RecipesScreen({required this.title, required this.context, this.selectedDay, this.dishName});

  @override
  _RecipesScreenState createState() => _RecipesScreenState(title, context, selectedDay, dishName);
}

class _RecipesScreenState extends State<RecipesScreen> {
  Map<String, bool> contexts = {
    RecipesScreen.defaultContext: false,
    RecipesScreen.dishContext: true,
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  final DateTime? _selectedDay;
  final String? _dishName;
  bool _isInitialized = false;
  String _title;
  String _context;

  _RecipesScreenState(this._title, this._context, this._selectedDay, this._dishName);

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
        title: Text(_title),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            SearchInput(
              hintText: 'Search recipes...',
              controller: _searchController,
              onChanged: (query) => recipeProvider.searchRecipes(query),
            ),
            FoundItemsList(
              recipeProvider.isLoading, 
              recipeProvider.recipes, 
              contexts[_context] == true ? _onAssignRecipeToDish : (_) {},
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: FloatingButton(onPressed: _onAddRecipe),
      ),
    );
  }

  void _onAssignRecipeToDish(Eatable recipe){
    _saveRecipeToDish(context, (recipe as Recipe));
  }

  Future<void> _saveRecipeToDish(BuildContext context, Recipe recipe) async {
    if (_formKey.currentState?.validate() ?? false) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String formattedDate = _selectedDay!.toUtc().toIso8601String();
      DishRecipe dishRecipe = DishRecipe('Recipe', recipe.getId(), formattedDate, _dishName!, recipe.getIngredients().fold(0.0, (sum, ingredient) => sum + ingredient.weight));

      final dishRecipeService = DishRecipesService();
      try {
        await dishRecipeService.addRecipe(dishRecipe);
        Provider.of<DishRecipeProvider>(context, listen: false).fetchRecipesConnectedWithDish(_selectedDay, _dishName);
        FocusScope.of(context).unfocus();

        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add recipe to dish: $e')),
        );
      }
    }
  }

}
