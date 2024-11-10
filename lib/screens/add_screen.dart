import 'package:caloriecounter/models/product.dart';
import 'package:caloriecounter/providers/dish_products_provider.dart';
import 'package:caloriecounter/widgets/found_items_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/search_input.dart';

class AddScreen extends StatefulWidget {
  final String dishName;
  final List<Product> ingredients;

  AddScreen({
    required this.dishName,
    required this.ingredients
  });

  @override
  State<StatefulWidget> createState() {
     return _AddScreenState(this.dishName, this.ingredients);
  }
  
}

class _AddScreenState extends State<AddScreen> {
  final String dishName;
  final List<Product> ingredients;
  final TextEditingController _searchController = TextEditingController();

  _AddScreenState(this.dishName, this.ingredients);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dishProductProvider = Provider.of<DishProductProvider>(context, listen: false);
      dishProductProvider.searchProducts('', ingredients);
    });
  }

  @override
  Widget build(BuildContext context) {
    final dishProductProvider = Provider.of<DishProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(dishName),
      ),
      body: Column(
        children: [
          SearchInput(
            hintText: 'Search products...',
            controller: _searchController,
            onChanged: (query) => dishProductProvider.searchProducts(query, ingredients),
          ),
          FoundItemsList(dishProductProvider.isLoading, dishProductProvider.ingredients)
          
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton(
              onPressed: () {

              },
              child: Image.asset
              (
                'assets/dish.png',
                fit: BoxFit.cover
              ),
              shape: CircleBorder(),
            ),
            FloatingActionButton(
              onPressed: () {

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