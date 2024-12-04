import 'package:caloriecounter/models/dish_element.dart';
import 'package:caloriecounter/models/product.dart';
import 'package:caloriecounter/providers/dish_provider.dart';
import 'package:caloriecounter/providers/product_provider.dart';
import 'package:caloriecounter/screens/add_product_screen.dart';
import 'package:caloriecounter/services/dish_service.dart';
import 'package:caloriecounter/screens/edit_product_screen.dart';
import 'package:caloriecounter/utils/eatable.dart';
import 'package:caloriecounter/widgets/floating_button.dart';
import 'package:caloriecounter/widgets/found_items_list.dart';
import 'package:caloriecounter/widgets/search_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductsScreen extends StatefulWidget {
  static final String defaultContext = 'default';
  static final String dishContext = 'dish';

  final String title;
  final String context;
  final DateTime? selectedDay;
  final String? dishName;

  ProductsScreen({required this.title, required this.context, this.selectedDay, this.dishName});

  @override
  _ProductsScreenState createState() => _ProductsScreenState(title, context, selectedDay, dishName);
}

class _ProductsScreenState extends State<ProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isInitialized = false;

   Map<String, bool> contexts = {
    ProductsScreen.defaultContext: false,
    ProductsScreen.dishContext: true,
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DateTime? _selectedDay;
  final String? _dishName;
  String _title;
  String _context;

  _ProductsScreenState(this._title, this._context, this._selectedDay, this._dishName);

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

  void _onAssignProductToDish(Eatable product){
    _saveProductToDish(context, (product as Product));
  }

    void _onEditProduct(Eatable product) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductScreen(product: product),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        ),
        body: Form(
        key: _formKey,
        child: Column(
          children: [
            SearchInput(
            hintText: 'Search products...',
            controller: _searchController,
            onChanged: (query) => productProvider.searchProducts(query),
           ),
            FoundItemsList(
              productProvider.isLoading, 
              productProvider.products, 
              contexts[_context] == true ? _onAssignProductToDish : _onEditProduct,
            ),
          ],
        ),
      ),
    
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: FloatingButton(onPressed: _onAddProduct),
      ),
    );
  }

  Future<void> _saveProductToDish(BuildContext context, Product product) async {
    if (_formKey.currentState?.validate() ?? false) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String formattedDate = _selectedDay!.toUtc().toIso8601String();
      DishElement dishElement = DishElement('Product', product.getId(), formattedDate, _dishName!, product.getValuePer());

      final dishElementService = DishService();
      try {
        await dishElementService.addDishData(dishElement);
        await Provider.of<DishProvider>(context, listen: false).fetchDataConnectedWithDish(_selectedDay, _dishName);
     
        FocusScope.of(context).unfocus();

        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add product to dish: $e')),
        );
      }
    }
  }
}
