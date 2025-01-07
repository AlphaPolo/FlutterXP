import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../components/my_menu_bar.dart';
import '../../constant/window_constant.dart';
import '../../notifications/window_activity_notification.dart';

MenuGetter getSolitaireMenu = (context, activity, previousEntry) {
  final List<MenuEntry> result = <MenuEntry>[
    MenuEntry(
      label: 'Game',
      menuChildren: <MenuEntry>[
        MenuEntry(
          label: 'Deal',
          onPressed: () {
            activity.onCustomAction('NewGame');
          },
          shortcut: const SingleActivator(LogicalKeyboardKey.f2),
        ),


        const MenuEntry.divider(),

        MenuEntry(
          label: 'Undo',
          onPressed: () {
            activity.onCustomAction('Undo');
          },
        ),
        MenuEntry(
          label: 'Deck...',
          onPressed: () {},
        ),
        MenuEntry(
          label: 'Cheat',
          onPressed: () {
            activity.onCustomAction('Cheat');
          },
        ),
        MenuEntry(
          label: 'Specify',
          onPressed: () {
            activity.onCustomAction('Specify');
          },
        ),
        MenuEntry(
          label: 'Options',
          onPressed: () {},
        ),


        const MenuEntry.divider(),

        MenuEntry(
          label: 'Exit',
          onPressed: () {
            DeleteWindowActivityNotification(context: context, activity: activity).dispatch(context);
          },
        ),
      ],
    ),
    MenuEntry(
      label: 'Help',
      menuChildren: <MenuEntry>[
        MenuEntry(
          label: 'Content',
          onPressed: () {},
          shortcut: const SingleActivator(LogicalKeyboardKey.f1),
        ),
        MenuEntry(
          label: 'Search for help on...',
          onPressed: () {},
        ),

        const MenuEntry.divider(),

        MenuEntry(
          label: 'About Solitaire',
          onPressed: () {},
        ),
      ],
    ),
  ];

  // (Re-)register the shortcuts with the ShortcutRegistry so that they are
  // available to the entire application, and update them if they've changed.
  previousEntry?.dispose();
  // final shortcutEntry = ShortcutRegistry.of(context).addAll(MenuEntry.shortcuts(result));
  // final shortcutEntry = ShortcutRegistryEntry.of(context).addAll({});
  return (previousEntry, result);
};