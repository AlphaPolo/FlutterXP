import 'dart:math';

import 'package:flutter/material.dart';

import '../../../r.g.dart';

List<AssetImage> _assetDigits = [
  R.image.digit0(),
  R.image.digit1(),
  R.image.digit2(),
  R.image.digit3(),
  R.image.digit4(),
  R.image.digit5(),
  R.image.digit6(),
  R.image.digit7(),
  R.image.digit8(),
  R.image.digit9(),
];

class SevenSegmentDisplay extends StatelessWidget {
  final int width;
  final int value;

  const SevenSegmentDisplay({
    super.key,
    required this.width,
    required this.value,
  }) : assert(width >= 0);


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: getDigitImages().map<Widget>((e) {
        return Image(
          image: e,
          // width: MinesweeperConstant.segmentPerDigitalWidth,
          // height: MinesweeperConstant.segmentPerDigitalHeight,
        );
      }).toList(),
    );
  }

  Iterable<AssetImage> getDigitImages() {
    int value = this.value.clamp(0, pow(10, width).toInt() - 1);
    return value.toString()
        .padLeft(width, '0')
        .split('')
        .map(int.parse)
        .map((i) => _assetDigits[i]);
  }
}
