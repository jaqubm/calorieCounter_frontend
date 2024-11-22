class Ingredient {
  final String name;
  final double weight;
  final String productId;

  Ingredient({
    required this.name,
    required this.weight,
    required this.productId,
  });

    Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'weight': weight,
    };
  }
}
