import 'package:caloriecounter/models/product.dart';

class DishProductsService {
  List<Product> searchProducts(String query, List<Product> ingredients){
    return ingredients.where((ingredient) {
      return ingredient.getName().contains(query);
    }).toList();
  }
}