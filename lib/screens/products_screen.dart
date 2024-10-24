import 'package:caloriecounter/widgets/search_input.dart';
import 'package:flutter/material.dart';


import 'package:flutter/material.dart';
import '../widgets/search_input.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _allProducts = ['Apple', 'Banana', 'Orange', 'Mango', 'Grapes'];
  List<String> _filteredProducts = [];

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
                product.toLowerCase().contains(query.toLowerCase()))
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
              onSubmitted: _filterProducts,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_filteredProducts[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}