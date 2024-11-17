import 'package:caloriecounter/models/recipe.dart';
import 'package:caloriecounter/models/product.dart';

class RecipeService {
  Future<List<Recipe>> fetchRecipes() async {
    // Symulacja opóźnienia jak w prawdziwym żądaniu HTTP
    await Future.delayed(Duration(seconds: 1));

    // Przykładowe produkty
    Product product1 = Product.basic('Apple', 52.0, 100.0);
    Product product2 = Product.basic('Banana', 89.0, 100.0);
    Product product3 = Product.basic('Oats', 389.0, 100.0);

    // Przykładowe przepisy
    return [
      Recipe.basic(
        'Fruit Salad',
        'Mix apples and bananas together.',
        'user1@example.com',
      )..products.addAll([product1, product2]),
      Recipe.basic(
        'Oatmeal Breakfast',
        'Cook oats with milk and add bananas.',
        'user2@example.com',
      )..products.addAll([product2, product3]),
      Recipe.basic(
        'Banana Smoothie',
        'Blend bananas with milk and a hint of honey.',
        'user3@example.com',
      )..products.add(product2),
    ];
  }
}
