import 'package:flutter/material.dart';
import 'package:flutter_xp/components/my_menu_bar.dart';
import 'package:flutter_xp/model/activity/window_activity.dart';
import 'package:flutter_xp/util/id_generator.dart';

class WindowConstant {

  static final IdGenerator idGenerator = IdGenerator.from(0);

  static const double toolbarHeight = 30;

  static const double windowHeaderHeight = 28;
  static const double windowMenuHeight = 24;
  static const double windowActionBarHeight = 36;

  static const double minimumSide = 200;
  static const double defaultWidth = 660;
  static const double defaultHeight = 500;
  static const double defaultX = 250;
  static const double defaultY = 40;
  static const Offset defaultOffset = Offset(defaultX, defaultY);
  static const Size defaultSize = Size(defaultWidth, defaultHeight);
  static const Rect defaultRect = Rect.fromLTWH(defaultX, defaultY, defaultWidth, defaultHeight);

  static const BoxDecoration headerFocusDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0, 0.04, 0.06, 0.08, 0.1, 0.14, 0.2, 0.24, 0.56, 0.66, 0.76, 0.86, 0.92, 0.94, 1],
      colors: [
        Color.fromRGBO(0, 88, 238, 1),
        Color.fromRGBO(53, 147, 255, 1),
        Color.fromRGBO(40, 142, 255, 1),
        Color.fromRGBO(18, 125, 255, 1),
        Color.fromRGBO(3, 111, 252, 1),
        Color.fromRGBO(2, 98, 238, 1),
        Color.fromRGBO(0, 87, 229, 1),
        Color.fromRGBO(0, 84, 227, 1),
        Color.fromRGBO(0, 85, 235, 1),
        Color.fromRGBO(0, 91, 245, 1),
        Color.fromRGBO(2, 106, 254, 1),
        Color.fromRGBO(0, 98, 239, 1),
        Color.fromRGBO(0, 82, 214, 1),
        Color.fromRGBO(0, 64, 171, 1),
        Color.fromRGBO(0, 48, 146, 1),
      ],
    ),
    borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
  );
  static const BoxDecoration headerUnfocusDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color.fromRGBO(118, 151, 231, 1.0),
        Color.fromRGBO(126, 158, 227, 1.0),
        Color.fromRGBO(148, 175, 232, 1.0),
        Color.fromRGBO(151, 180, 233, 1.0),
        Color.fromRGBO(130, 165, 228, 1.0),
        Color.fromRGBO(124, 159, 226, 1.0),
        Color.fromRGBO(121, 150, 222, 1.0),
        Color.fromRGBO(123, 153, 225, 1.0),
        Color.fromRGBO(130, 169, 233, 1.0),
        Color.fromRGBO(128, 165, 231, 1.0),
        Color.fromRGBO(123, 150, 225, 1.0),
        Color.fromRGBO(122, 147, 223, 1.0),
        Color.fromRGBO(171, 186, 227, 1.0),
      ],
      stops: [
        0.0,
        0.03,
        0.06,
        0.08,
        0.14,
        0.17,
        0.25,
        0.56,
        0.81,
        0.89,
        0.94,
        0.97,
        1.0,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
  );

  const WindowConstant._();
}

typedef MenuGetter = (ShortcutRegistryEntry?, List<MenuEntry>) Function(
  BuildContext context,
  WindowActivity activity,
  ShortcutRegistryEntry? previousRegistryEntry,
);

typedef ActivityGetter = WindowActivity Function();

typedef ValueVoidCallback<T> = void Function(T);