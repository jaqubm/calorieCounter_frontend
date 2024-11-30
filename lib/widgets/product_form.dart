import 'package:caloriecounter/utils/formatters.dart';
import 'package:flutter/material.dart';
import 'package:caloriecounter/colors.dart';
import 'package:caloriecounter/widgets/input_row.dart';
import 'package:caloriecounter/models/product.dart';

class ProductForm extends StatelessWidget {
  final bool isReadOnly;
  final bool isEditMode;
  final Product? initialProduct;
  final void Function(Product product) onSave;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _valuesPerController = TextEditingController();
  final TextEditingController _energyController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _carbohydratesController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();

  ProductForm({
    Key? key,
    required this.isReadOnly,
    required this.isEditMode,
    required this.onSave,
    this.initialProduct,
  }) : super(key: key) {
    if (initialProduct != null) {
      _nameController.text = initialProduct!.getName();
      _valuesPerController.text = Formatters.formatDouble(initialProduct!.getValuePer());
      _energyController.text = Formatters.formatDouble(initialProduct!.getEnergy());
      _proteinController.text = Formatters.formatDouble(initialProduct!.getProtein());
      _carbohydratesController.text = Formatters.formatDouble(initialProduct!.getCarbohydrates());
      _fatController.text = Formatters.formatDouble(initialProduct!.getFat());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          InputRow(
            'Name',
            _nameController,
            '',
            isReadOnly: isReadOnly,
            validator: (value) => validateRequiredField(value, isNumeric: false),
          ),
          InputRow(
            'Values Per',
            _valuesPerController,
            'g',
            isReadOnly: isReadOnly,
            validator: (value) => validateRequiredField(value, isNumeric: true),
          ),
          InputRow(
            'Energy',
            _energyController,
            'kcal',
            isReadOnly: isReadOnly,
            validator: (value) => validateRequiredField(value, isNumeric: true),
          ),
          InputRow(
            'Protein',
            _proteinController,
            'g',
            isReadOnly: isReadOnly,
            validator: (value) => validateRequiredField(value, isNumeric: true),
          ),
          InputRow(
            'Carbohydrates',
            _carbohydratesController,
            'g',
            isReadOnly: isReadOnly,
            validator: (value) => validateRequiredField(value, isNumeric: true),
          ),
          InputRow(
            'Fat',
            _fatController,
            'g',
            isReadOnly: isReadOnly,
            validator: (value) => validateRequiredField(value, isNumeric: true),
          ),
          if (!isReadOnly)
            SizedBox(height: 20),
          if (!isReadOnly)
            ElevatedButton(
              onPressed: () => _handleSave(context),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                backgroundColor: AppColors.saveButtonColor,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.save, color: Colors.black),
                  SizedBox(width: 8),
                  Text(
                    isEditMode ? 'Update Product' : 'Save Product',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _handleSave(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final product = initialProduct ?? Product();

    product.setName(_nameController.text);
    product.setValuesPer(double.tryParse(_valuesPerController.text) ?? 0.0);
    product.setEnergy(double.tryParse(_energyController.text) ?? 0.0);
    product.setProtein(double.tryParse(_proteinController.text) ?? 0.0);
    product.setCarbohydrates(double.tryParse(_carbohydratesController.text) ?? 0.0);
    product.setFat(double.tryParse(_fatController.text) ?? 0.0);

    onSave(product);
  }

  String? validateRequiredField(String? value, {bool isNumeric = false}) {
    if (value == null || value.trim().isEmpty) return "This field is required";
    if (isNumeric && double.tryParse(value) == null) return "Please enter a valid number";
    return null;
  }
}
