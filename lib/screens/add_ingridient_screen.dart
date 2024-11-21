import 'package:caloriecounter/models/ingridient.dart';
import 'package:caloriecounter/utils/eatable.dart';
import 'package:caloriecounter/widgets/search_input.dart';
import 'package:flutter/material.dart';
import 'package:caloriecounter/providers/product_provider.dart';
import 'package:caloriecounter/widgets/found_items_list.dart';
import 'package:provider/provider.dart';

class AddIngredientScreen extends StatefulWidget {
  final Function(Ingredient) onIngredientAdded;

  AddIngredientScreen({required this.onIngredientAdded});

  @override
  AddIngredientScreenState createState() => AddIngredientScreenState();
}

class AddIngredientScreenState extends State<AddIngredientScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<ProductProvider>(context, listen: false).fetchProducts();
      });
      _isInitialized = true;
    }
  }

  void _showGramsModal(BuildContext context, Eatable eatable) {
    final TextEditingController gramsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(eatable.getName()),
          content: TextField(
            controller: gramsController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Enter grams',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final grams = double.tryParse(gramsController.text) ?? 0;

                if (grams > 0) {
                  widget.onIngredientAdded(Ingredient(
                      name: eatable.getName(),
                      weight: grams,
                      productId: eatable.getId()));
                }

                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add ingridents'),
      ),
      body: Column(
        children: [
          SearchInput(
            hintText: 'Search products...',
            controller: _searchController,
            onChanged: (query) => productProvider.searchProducts(query),
          ),
          FoundItemsList(productProvider.isLoading, productProvider.products,
              (eatable) => _showGramsModal(context, eatable))
        ],
      ),
    );
  }
}
