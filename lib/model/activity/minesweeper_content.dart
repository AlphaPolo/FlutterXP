import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_xp/extensions/context_extension.dart';
import 'package:flutter_xp/util/my_print.dart';

import '../../components/my_menu_bar.dart';
import '../../constant/window_constant.dart';
import '../../notifications/window_activity_notification.dart';

MenuGetter getMinesweeperMenu = (context, activity, previousEntry) {
  myPrint('rebuildGetter');
  final List<MenuEntry> result = <MenuEntry>[
    MenuEntry(
      label: 'Game',
      menuChildren: <MenuEntry>[
        MenuEntry(
          label: 'NewGame',
          onPressed: () {
            activity.onCustomAction('NewGame');
          },
          shortcut: const SingleActivator(LogicalKeyboardKey.f2),
        ),

        const MenuEntry.divider(),

        MenuEntry(
          label: 'Beginner',
          onPressed: () {
            activity.onCustomAction('Beginner');
          },
        ),
        MenuEntry(
          label: 'Intermediate',
          onPressed: () {
            activity.onCustomAction('Intermediate');
          },
        ),
        MenuEntry(
          label: 'Expert',
          onPressed: () {
            // activity.onCustomAction('Expert');
          },
        ),
        MenuEntry(
          label: 'Custom',
          onPressed: () {},
        ),

        const MenuEntry.divider(),

        MenuEntry(
          label: 'Marks (?)',
          onPressed: () {},
        ),
        MenuEntry(
          label: 'Color',
          onPressed: () {},
        ),
        MenuEntry(
          label: 'Sound',
          onPressed: () {},
        ),

        const MenuEntry.divider(),

        MenuEntry(
          label: 'BestTimes',
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
        MenuEntry(
          label: 'Using Help (BETA)',
          isChecked: activity.extras?['Using Help'] ?? false,
          onPressed: () {
            activity.onCustomAction('Using Help');
            context.forceRebuild();
          },
        ),

        const MenuEntry.divider(),

        MenuEntry(
          label: 'About Minesweeper',
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