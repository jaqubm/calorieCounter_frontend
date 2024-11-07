import 'package:caloriecounter/colors.dart';
import 'package:caloriecounter/providers/product_provider.dart';
import 'package:caloriecounter/screens/add_product_screen.dart';
import 'package:caloriecounter/utils/formatters.dart';
import 'package:caloriecounter/widgets/search_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
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

  void _onAddProduct() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddProductScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        ),
      body: Column(
        children: [
          SearchInput(
            hintText: 'Search products...',
            controller: _searchController,
            onChanged: (query) => productProvider.searchProducts(query),
          ),
          Expanded(
            child: productProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.separated(
                    itemCount: productProvider.products.length,
                    itemBuilder: (context, index) {
                      final product = productProvider.products[index];
                      return ListTile(
                        title: Text(product.name),
                        subtitle: Text(
                          Formatters.formatDouble(product.valuesPer) + "g",
                          style: TextStyle(color: Colors.grey),
                        ),
                        trailing: Text(
                          Formatters.formatDouble(product.energy) + " kcal",
                          textAlign: TextAlign.right,
                          style: TextStyle(fontSize: 14),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                          height: 1,
                          color: const Color.fromARGB(255, 209, 209, 209));
                    },
                  ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: FloatingActionButton(
          onPressed: _onAddProduct,
          backgroundColor: AppColors.FABColor,
          child: Icon(Icons.add, color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
    );
  }
}
