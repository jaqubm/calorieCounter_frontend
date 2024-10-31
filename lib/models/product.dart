class Product {
  final String name;
  final double valuesPer;
  final double energy;
  final double protein;
  final double carbohydrates;
  final double fat;
  final String ownerEmail;

  Product({
    required this.name,
    required this.valuesPer,
    required this.energy,
    required this.protein,
    required this.carbohydrates,
    required this.fat,
    required this.ownerEmail,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
    name: json['name'] ?? '', 
    valuesPer: (json['valuesPer'] as num?)?.toDouble() ?? 0.0,
    energy: (json['energy'] as num?)?.toDouble() ?? 0.0,
    protein: (json['protein'] as num?)?.toDouble() ?? 0.0,
    carbohydrates: (json['carbohydrates'] as num?)?.toDouble() ?? 0.0,
    fat: (json['fat'] as num?)?.toDouble() ?? 0.0,
    ownerEmail: json['ownerEmail'] ?? '',
    );
  }

}