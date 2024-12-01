import 'package:caloriecounter/providers/product_provider.dart';
import 'package:caloriecounter/services/product_service.dart';
import 'package:caloriecounter/widgets/product_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Product')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: ProductForm(
          isReadOnly: false,
          isEditMode: false,
          onSave: (product) async {
            final productService = ProductService();
            await productService.addProduct(product);
            Provider.of<ProductProvider>(context, listen: false).fetchProducts();
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
