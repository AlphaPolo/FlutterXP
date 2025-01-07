import 'package:flutter/material.dart';

class MinesweeperConstant {
  static const int rows = 9;
  static const int cols = 9;

  static const double cellSide = 16;
  static const double iconSize = 12;

  static const Size size = Size(cellSide * cols, cellSide * rows);

  static const Color borderColorLight = Color.fromRGBO(245, 245, 245, 1);
  static const Color borderColorDark = Color.fromRGBO(128, 128, 128, 1);

  static const defaultDecoration = BoxDecoration(
    color: Color.fromRGBO(197, 197, 197, 1.0),
    border: Border(
      top: BorderSide(width: 2, color: borderColorLight),
      right: BorderSide(width: 2, color: borderColorDark),
      bottom: BorderSide(width: 2, color: borderColorDark),
      left: BorderSide(width: 2, color: borderColorLight),
    ),
  );

  static const innerDecoration = BoxDecoration(
    color: Color.fromRGBO(197, 197, 197, 1.0),
    border: Border(
      top: BorderSide(width: 2, color: borderColorDark),
      right: BorderSide(width: 2, color: borderColorLight),
      bottom: BorderSide(width: 2, color: borderColorLight),
      left: BorderSide(width: 2, color: borderColorDark),
    ),
  );

  static const Widget defaultPrototypeCell = DecoratedBox(
    decoration: defaultDecoration,
  );

  static const Widget defaultFlagCell = DecoratedBox(
    decoration: defaultDecoration,
    child: Center(child: Icon(Icons.flag, color: Colors.red, size: iconSize)),
  );

  // static const double segmentPerDigitalWidth = 13*13/23 - 3;
  static const double segmentPerDigitalWidth = 13;
  static const double segmentPerDigitalHeight = 23;


}