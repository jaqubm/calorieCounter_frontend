class Goals {
  double _energy;
  double _protein;
  double _carbohydrates;
  double _fat;
  String? _email;

  Goals(this._energy, this._protein, this._carbohydrates, this._fat);

  factory Goals.fromJson(Map<String, dynamic> json) {
    return Goals(
      json['energy']?.toDouble() ?? 0.0,
      json['protein']?.toDouble() ?? 0.0,
      json['carbohydrates']?.toDouble() ?? 0.0,
      json['fat']?.toDouble() ?? 0.0,
    )..email = json['email'];
  }

  Map<String, dynamic> toJson() {
    return {
      'energy': _energy,
      'protein': _protein,
      'carbohydrates': _carbohydrates,
      'fat': _fat,
      'email': _email,
    };
  }

  set energy(double energy){
    _energy = energy;
  }

  set protein(double protein){
    _protein = protein;
  }

  set carbohydrates(double carbohydrates){
    _carbohydrates = carbohydrates;
  }

  set fat(double fat){
    _fat = fat;
  }

  set email(String? email){
    _email = email;
  }

  double get energy => _energy;
  double get protein => _protein;
  double get carbohydrates => _carbohydrates;
  double get fat => _fat;
  String? get email => _email;
}