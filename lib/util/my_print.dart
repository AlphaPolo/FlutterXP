import 'package:flutter/foundation.dart';

void myPrint(Object? object) {
  if(kDebugMode) {
    print(object);
  }
}