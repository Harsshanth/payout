class Note {
  int? _id;
  late String _amount;
  late String _date;
  late String _description;

  Note(this._amount, this._date, this._description);
  Note.withId(this._id, this._amount, this._date, this._description);
  //getter
  int? get id => _id;
  String get amount => _amount;
  String get date => _date;
  String get description => _description;

  // setter
  set amount(String newAmount) {
    this._amount = newAmount;
  }

  set date(String newDate) {
    this._date = newDate;
  }

  set description(String newDescription) {
    this._description = newDescription;
  }

  String toString() {
    return '''{
      id: $_id,
      amount: $_amount,
      date: $_date,
      description: $_description
    }''';
  }

  // Convert a Note object into Map Object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map['id'] = _id;
    }

    map['amount'] = _amount;
    map['date'] = _date;
    map['description'] = _description;
    return map;
  }

  // Extract Note object from Map object

  static fromMapObject(Map<String, dynamic> map) {
    return Note.withId(
        map['id'], map['amount'], map['date'], map['description']);
  }
}
