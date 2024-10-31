import 'package:caloriecounter/colors.dart';
import 'package:caloriecounter/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:caloriecounter/models/product.dart';

class AddProductScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _valuesPerController = TextEditingController();
  final TextEditingController _energyController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _carbohydratesController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 100.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Text(
                  'Add Product',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildInputRow('Product Name', _nameController, ''),
            _buildInputRow('Values Per', _valuesPerController, ''),
            _buildInputRow('Energy', _energyController, 'kcal'),
            _buildInputRow('Protein', _proteinController, 'g'),
            _buildInputRow('Carbohydrates', _carbohydratesController, 'g'),
            _buildInputRow('Fat', _fatController, 'g'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _addProduct(context),
              child: Text('Save Product'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addProduct(BuildContext context) async {
    final product = Provider.of<Product>(context, listen: false);

    product.setName(_nameController.text);
    product.setValuesPer(double.tryParse(_valuesPerController.text) ?? 0.0);
    product.setEnergy(double.tryParse(_energyController.text) ?? 0.0);
    product.setProtein(double.tryParse(_proteinController.text) ?? 0.0);
    product.setCarbohydrates(double.tryParse(_carbohydratesController.text) ?? 0.0);
    product.setFat(double.tryParse(_fatController.text) ?? 0.0);

    final productService = ProductService();
    try {
      await productService.addProduct(product);
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add product: $e')),
      );
    }
  }

  Widget _buildInputRow(String label, TextEditingController controller, String unit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 100,
          child: Text(label),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ),
        ),
        SizedBox(
          width: 50,
          child: Text(unit),
        ),
      ],
    );
  }
}
