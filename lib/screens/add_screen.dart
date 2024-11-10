

import 'package:caloriecounter/colors.dart';
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
  Widget build(BuildContext context) {
    final dishProductProvider = Provider.of<DishProductProvider>(context);
    dishProductProvider.searchProducts('', ingredients);

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
      
    );
  }

}