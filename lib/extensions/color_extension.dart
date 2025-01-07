import 'package:flutter/material.dart';

extension ColorExtension on Color {

  Color lighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hslColor = HSLColor.fromColor(this);
    final lightness = (hslColor.lightness + amount).clamp(0, 1.0).toDouble();
    return hslColor.withLightness(lightness).toColor();
  }

  bool isBrightness() {
    return computeLuminance() >= 0.5;
  }

}