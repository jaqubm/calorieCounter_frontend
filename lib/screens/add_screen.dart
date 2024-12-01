import 'package:caloriecounter/providers/dish_provider.dart';
import 'package:caloriecounter/screens/products_screen.dart';
import 'package:caloriecounter/screens/recipes_screen.dart';
import 'package:caloriecounter/widgets/found_items_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddScreen extends StatefulWidget {
  final String dishName;
  final DateTime selectedDay;

  AddScreen({
    required this.dishName,
    required this.selectedDay
  });

  @override
  State<StatefulWidget> createState() {
     return _AddScreenState(this.dishName, this.selectedDay);
  }
  
}

class _AddScreenState extends State<AddScreen> {
  final String dishName;
  final DateTime selectedDay;
  final TextEditingController _searchController = TextEditingController();

  _AddScreenState(this.dishName, this.selectedDay);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dishRecipeProvider = Provider.of<DishProvider>(context, listen: false);
      dishRecipeProvider.fetchDataConnectedWithDish(selectedDay, dishName);
    });
  }

  void _onAddRecipe() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RecipesScreen(title: 'Add recipe to ${dishName}', context: RecipesScreen.dishContext, selectedDay: selectedDay, dishName: dishName)),
    );
  }

  void _onAddProduct() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductsScreen(title: 'Add product to ${dishName}', context: ProductsScreen.dishContext, selectedDay: selectedDay, dishName: dishName)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dishProvider = Provider.of<DishProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(dishName),
      ),
      body: Column(
        children: [
          Text('Recipes'),
          FoundItemsList(dishProvider.isLoading, dishProvider.recipes, (_) {}),
          Text('Products'),
          FoundItemsList(dishProvider.isLoading, dishProvider.products, (_) {})
          
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton(
              heroTag: 'fab1',
              onPressed: () {
                _onAddProduct();
              },
              child: Image.asset
              (
                'assets/dish.png',
                fit: BoxFit.cover
              ),  
              shape: CircleBorder(),
            ),
            FloatingActionButton(
              heroTag: 'fab2',
              onPressed: () {
                _onAddRecipe();
              },
              child: Image.asset
              (
                'assets/recipe.png',
                fit: BoxFit.cover
              ),  
              shape: CircleBorder(),
            ),
          ],
        ),
      ),
      
    );
  }

}