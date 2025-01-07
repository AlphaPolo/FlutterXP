import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

extension ContextExtension on BuildContext {
  void forceRebuild() => (this as Element?)?.markNeedsBuild();


  T? maybeRead<T extends Object>() {
    return read<T?>();
  }
}