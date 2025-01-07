import 'package:flutter/material.dart';
import 'package:flutter_xp/model/activity/window_activity.dart';

import '../constant/window_constant.dart';
import 'my_menu_bar.dart';

const MenuBarThemeData menuBarThemeData = MenuBarThemeData(
  style: MenuStyle(
    padding: MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.only(left: 2, bottom: 1)),
    shape: MaterialStatePropertyAll<OutlinedBorder>(RoundedRectangleBorder()),
    maximumSize: MaterialStatePropertyAll<Size?>(Size.fromHeight(23)),
    // fixedSize: MaterialStatePropertyAll<Size?>(Size.fromHeight(23)),
    minimumSize: MaterialStatePropertyAll<Size?>(Size(0, 23)),
    backgroundColor: MaterialStatePropertyAll<Color>(Colors.transparent),
    elevation: MaterialStatePropertyAll<double?>(0),
  ),
);

class WindowMenu extends StatefulWidget {
  final WindowActivity activity;
  const WindowMenu({super.key, required this.activity});

  @override
  State<WindowMenu> createState() => _WindowMenuState();
}

class _WindowMenuState extends State<WindowMenu> {

  ShortcutRegistryEntry? _shortcutsEntry;


  @override
  void dispose() {
    _shortcutsEntry?.dispose();
    super.dispose();
  }


  List<MenuEntry> _getMenus() {
    final menuGetter = widget.activity.menuGetter;

    if(menuGetter == null) return [];
    final (shortcutsEntry, result) = menuGetter.call(context, widget.activity, _shortcutsEntry);
    _shortcutsEntry = shortcutsEntry;
    return result;
  }

  @override
  Widget build(BuildContext context) {

    final menu = _getMenus();

    if(menu.isEmpty) return const SizedBox.shrink();


    return SizedBox(
      height: WindowConstant.windowMenuHeight,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              width: 1,
            ),
            right: BorderSide(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: MenuBarTheme(
                data: menuBarThemeData,
                child: MenuButtonTheme(
                  data: MenuButtonThemeData(
                    style: MenuItemButton.styleFrom(
                      surfaceTintColor: Colors.black,
                      minimumSize: const Size(0, 32),
                      maximumSize: const Size(double.infinity, 48),
                      textStyle: const TextStyle(fontSize: 11),
                      shape: const RoundedRectangleBorder(),
                    ),
                  ),
                  child: MenuBar(
                    children: MenuEntry.build(menu),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
