import 'package:caloriecounter/colors.dart';
import 'package:caloriecounter/services/product_service.dart';
import 'package:caloriecounter/widgets/search_input.dart';
import 'package:flutter/material.dart';
import 'package:caloriecounter/models/product.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ProductService _productService = ProductService();

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

    Future<void> _fetchProducts() async {
    try {
      final products = await _productService.fetchProducts();
      setState(() {
        _allProducts = products;
        _filteredProducts = products;
      });
    } catch (e) {
      print('Failed to load products: $e');
    }
  }


void _filterProducts(String query) async {
  if (query.isEmpty) {
    setState(() {
      _filteredProducts = _allProducts;
    });
  } else {
    try {
      final response = await _productService.searchProducts(query);
      setState(() {
        _filteredProducts = response;
      });
    } catch (e) {
      print('Failed to search products: $e');
    }
  }
}


    void _onAddProduct() {
    print('Add Product pressed');
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
                    product.valuesPer.toString(),
                    style: TextStyle(color: Colors.grey),
                  ),
                  trailing: Text(product.energy.toString(), textAlign: TextAlign.right, style: TextStyle(fontSize: 14)),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(height: 1, color: const Color.fromARGB(255, 209, 209, 209));
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
