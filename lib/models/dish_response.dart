class DishResponse {
  final String _id;
  final String _entryType;
  final String _entryId;
  final String _entryName;
  final String _date;
  final String _mealType;
  final double _weight;

  DishResponse(this._id, this._entryType, this._entryId, this._entryName, this._date, this._mealType, this._weight);

  DishResponse.full(
    this._id,
    this._entryType,
    this._entryId,
    this._entryName,
    this._date,
    this._mealType,
    this._weight,
  );

  String get id => _id;
  String get entryId => _entryId;
  String get mealType => _mealType;
}