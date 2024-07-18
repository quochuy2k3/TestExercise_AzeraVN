class Mode {
  final int _id;
  final String _name;
  late int _values;

  Mode({required int id, required String name, int values = 0})
      : _id = id,
        _name = name,
        _values = values;

//Private -> get and set
  int get values => _values;

  set values(int newTime) {
    _values = newTime;
  }

  String get name => _name;
  int get id => _id;

  void displayInfo() {
    print('Mode: $_name, Values: $values');
  }
}
