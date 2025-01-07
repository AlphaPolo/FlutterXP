
import 'package:flutter/material.dart';

class PainterConstant {

  const PainterConstant._();

  static const Color borderColorLight = Color.fromRGBO(245, 245, 245, 1);

  static const Color borderColorDark = Color.fromRGBO(128, 128, 128, 1);

  static const defaultDecoration = BoxDecoration(
    color: Color.fromRGBO(197, 197, 197, 1.0),
    border: Border(
      top: BorderSide(width: 1, color: borderColorLight),
      right: BorderSide(width: 1, color: borderColorDark),
      bottom: BorderSide(width: 1, color: borderColorDark),
      left: BorderSide(width: 1, color: borderColorLight),
    ),
  );

  static const innerDecoration = BoxDecoration(
    // color: Color.fromRGBO(197, 197, 197, 1.0),
    border: Border(
      top: BorderSide(width: 1, color: borderColorDark),
      right: BorderSide(width: 1, color: borderColorLight),
      bottom: BorderSide(width: 1, color: borderColorLight),
      left: BorderSide(width: 1, color: borderColorDark),
    ),
  );

  static final innerBackgroundDecoration = innerDecoration.copyWith(
    image: const DecorationImage(
      repeat: ImageRepeat.repeat,
      image: AssetImage('assets/images/transparent_background.jpg'),
    ),
  );
}