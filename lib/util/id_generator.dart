class IdGenerator {

  late final Iterator<int> _generator;

  static Iterable<int> _createIterable(int from) sync* {
    while(true) {
      yield from++;
    }
  }

  IdGenerator.from(int value) {
    _generator = _createIterable(value).iterator;
  }

  int nextId() {
    _generator.moveNext();
    return _generator.current;
  }

}