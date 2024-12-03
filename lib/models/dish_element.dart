class DishElement {
  String _entryType;
  String _entryId;
  String _date;
  String _mealType;
  double _weight;

  DishElement(this._entryType, this._entryId, this._date, this._mealType, this._weight);

  set entryType(String entryType){
    _entryType = entryType;
  }

  set entryId(String entryId){
    _entryId = entryId;
  }

  set date(String date){
    _date = date;
  }

  set mealType(String mealType){
    _mealType = mealType;
  }

  set weight(double weight){
    _weight = weight;
  }

  String get entryType => _entryType;
  String get entryId => _entryId;
  String get date => _date;
  String get mealType => _mealType;
  double get weight => _weight;

}