import 'package:caloriecounter/models/product.dart';
import 'package:caloriecounter/providers/product_provider.dart';
import 'package:caloriecounter/services/product_service.dart';
import 'package:caloriecounter/utils/eatable.dart';
import 'package:caloriecounter/widgets/product_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatelessWidget {
  final Eatable product;

  const EditProductScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.getIsOwner() ?   'Edit Product' : "Product")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: ProductForm(
          isReadOnly: !product.getIsOwner(),
          isEditMode: true,
          initialProduct: product as Product,
          onSave: (updatedProduct) async {
            final productService = ProductService();
            await productService.updateProduct(updatedProduct);
            Provider.of<ProductProvider>(context, listen: false).fetchProducts();
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
