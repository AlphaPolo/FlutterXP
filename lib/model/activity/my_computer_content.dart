import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_xp/components/explorer_viewer.dart';
import 'package:flutter_xp/components/window_expansion_panel.dart';
import 'package:flutter_xp/constant/window_constant.dart';

import '../../components/my_menu_bar.dart';
import '../../notifications/window_activity_notification.dart';
import '../desktop/desktop_models.dart';

final Widget myComputerContent = ExplorerViewer(models: explorerModels);

final computerPanelList = [
  [
    'System Tasks',
    [
      const PanelListItemData(iconAsset: 'assets/images/icon_view_info_16.png', label: 'View system information'),
      const PanelListItemData(iconAsset: 'assets/images/icon_programs_manager_16.png', label: 'Add or remove programs'),
      const PanelListItemData(iconAsset: 'assets/images/icon_control_panel_16.png', label: 'Change a setting'),
    ]
  ],
  [
    'Other Places',
    [
      const PanelListItemData(iconAsset: 'assets/images/icon_my_network_16.png', label: 'My Network Places'),
      const PanelListItemData(iconAsset: 'assets/images/icon_my_documents_16.png', label: 'My Documents'),
      const PanelListItemData(iconAsset: 'assets/images/icon_share_documents_16.png', label: 'Share Documents'),
      const PanelListItemData(iconAsset: 'assets/images/icon_control_panel_16.png', label: 'Control Panel'),
    ]
  ],
];

MenuGetter getComputerMenu = (context, activity, previousEntry) {
  final List<MenuEntry> result = <MenuEntry>[
    MenuEntry(
      label: 'File',
      menuChildren: <MenuEntry>[
        const MenuEntry(
          label: 'Create Shortcut',
        ),
        const MenuEntry(
          label: 'Delete',
        ),
        const MenuEntry(
          label: 'Rename',
        ),
        const MenuEntry(
          label: 'Properties',
        ),
        const MenuEntry.divider(),
        MenuEntry(
          label: 'Close',
          onPressed: () {
            DeleteWindowActivityNotification(context: context, activity: activity).dispatch(context);
          },
        ),
      ],
    ),
    MenuEntry(
      label: 'Edit',
      menuChildren: [
        const MenuEntry(
          label: 'Undo',
        ),
        const MenuEntry.divider(),
        const MenuEntry(
          label: 'Cut',
        ),
        const MenuEntry(
          label: 'Copy',
        ),
        const MenuEntry(
          label: 'Paste',
        ),
        const MenuEntry(
          label: 'Paste Shortcut',
        ),
        const MenuEntry.divider(),
        const MenuEntry(
          label: 'Copy to Folder...',
        ),
        const MenuEntry(
          label: 'Move to Folder...',
        ),
        const MenuEntry.divider(),
        MenuEntry(
            label: 'Select All',
            onPressed: () {},
            shortcut: const SingleActivator(LogicalKeyboardKey.keyA, control: true)
        ),
        MenuEntry(
          label: 'Invert Selection',
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

/// (header, folders)
List<(String, List<DeskTopModel>)> explorerModels = [
  (
    'Files Stored on This Computer',
    [
      const DeskTopModel(
        label: 'Shared Documents',
        iconAsset: 'assets/images/icon_folder_48.png',
      ),
      const DeskTopModel(
        label: "User's Documents",
        iconAsset: 'assets/images/icon_folder_48.png',
      ),
    ],
  ),
  (
    'Hard Disk Drives',
    [
      const DeskTopModel(
        label: 'Local Disk (C:)',
        iconAsset: 'assets/images/icon_disk_48.png',
      ),
      const DeskTopModel(
        label: "Local Disk (E:)",
        iconAsset: 'assets/images/icon_disk_48.png',
      ),
      const DeskTopModel(
        label: "Local Disk (F:)",
        iconAsset: 'assets/images/icon_disk_48.png',
      ),
      const DeskTopModel(
        label: "Local Disk (G:)",
        iconAsset: 'assets/images/icon_disk_48.png',
      ),
      const DeskTopModel(
        label: "Local Disk (H:)",
        iconAsset: 'assets/images/icon_disk_48.png',
      ),
    ],
  ),
  (
    'Devices with Removable Storage',
    [
      const DeskTopModel(
        label: 'CD Drive (D:)',
        iconAsset: 'assets/images/icon_cd_48.png',
      ),
    ],
  ),


];