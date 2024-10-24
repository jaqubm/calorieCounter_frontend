import 'package:caloriecounter/widgets/search_input.dart';
import 'package:flutter/material.dart';
import 'package:caloriecounter/models/product.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<Product> _allProducts = [
    Product(name: 'Apple', valuesPer: '100g', energy: '52 kcal'),
    Product(name: 'Banana', valuesPer: '100g', energy: '89 kcal'),
    Product(name: 'Orange', valuesPer: '100g', energy: '47 kcal'),
    Product(name: 'Mango', valuesPer: '100g', energy: '60 kcal'),
    Product(name: 'Grapes', valuesPer: '100g', energy: '69 kcal'),
  ];
  
  List<Product> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _filteredProducts = _allProducts;
  }

  void _filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts = _allProducts
            .where((product) =>
                product.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchInput(
              hintText: 'Search products...',
              controller: _searchController,
              onChanged: _filterProducts,
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final product = _filteredProducts[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text(
                    product.valuesPer,
                    style: TextStyle(color: Colors.grey),
                  ),
                  trailing: Text(product.energy, textAlign: TextAlign.right, style: TextStyle(fontSize: 14)),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(height: 1, color: const Color.fromARGB(255, 209, 209, 209)); // Divider line between items
              },
            ),
          ),
        ],
      ),
    );
  }
}
