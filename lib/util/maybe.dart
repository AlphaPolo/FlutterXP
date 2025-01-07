import 'package:flutter/foundation.dart';

class Maybe<T> {
  final T? _value;

  const Maybe(this._value);

  factory Maybe.of(T value) => Maybe(value);

  factory Maybe.ofNullable(T? value) => Maybe(value);

  T? get value => _value;

  bool get isPresent => _value != null;

  bool get isAbsent => _value == null;

  Maybe<R> map<R>(R Function(T value) mapper) {
    return isPresent ? Maybe.ofNullable(mapper(_value as T)) : Maybe.ofNullable(null);
  }

  Maybe<R> flatMap<R>(Maybe<R> Function(T value) mapper) {
    return isPresent ? mapper(_value as T) : Maybe.ofNullable(null);
  }

  Maybe<T> where(bool Function(T value) filter) {
    if(isPresent && filter(_value as T)) {
      return Maybe.of(value as T);
    }
    else {
      return Maybe.ofNullable(null);
    }
  }

  void whenPresent(void Function(T value) runnable) {
    if(isPresent) {
      runnable(value as T);
    }
  }

  T getOrElse(T defaultValue) {
    return isPresent ? _value! : defaultValue;
  }

  T getOrLazyElse(ValueGetter<T> defaultValueGetter) {
    return isPresent ? _value! : defaultValueGetter();
  }
}