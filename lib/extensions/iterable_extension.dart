import 'dart:math';

import 'package:collection/collection.dart' as collection;

extension IterableExtension<E> on Iterable<E>{

  E randomTake() {
    return elementAt(Random().nextInt(length));
  }

  E firstOrElse(E Function() orElse) {
    // return firstOrNull ?? orElse();
    Iterator<E> it = iterator;
    if (!it.moveNext()) {
      return orElse();
    }
    return it.current;
  }

  List<E> joinElement(E separator) {
    final list = <E>[];
    Iterator<E> iterator = this.iterator;
    if (!iterator.moveNext()) return list;
    if (separator == null) {
      do {
        list.add(iterator.current);
      } while (iterator.moveNext());
    } else {
      list.add(iterator.current);
      while (iterator.moveNext()) {
        list.add(separator);
        list.add(iterator.current);
      }
    }
    return list;
  }

  Iterable<T> compactMap<T>(T? Function(E) toElement) {
    return map(toElement).whereType<T>();
  }

  E? minBy<T>(T Function(E) orderBy, {int Function(T, T)? compare}) {
    return collection.minBy(this, orderBy, compare: compare);
  }

}