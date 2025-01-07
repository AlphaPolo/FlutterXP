import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_xp/extensions/context_extension.dart';
import 'package:flutter_xp/util/my_print.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/my_menu_bar.dart';
import '../../constant/window_constant.dart';
import '../../notifications/window_activity_notification.dart';
import '../../util/maybe.dart';
import 'window_activity.dart';

MenuGetter getNotepadMenu = (context, activity, previousEntry) {
  final List<MenuEntry> result = <MenuEntry>[
    MenuEntry(
      label: 'File',
      menuChildren: <MenuEntry>[
        const MenuEntry(label: 'New'),
        const MenuEntry(label: 'Open...'),
        const MenuEntry(label: 'Save'),
        const MenuEntry(label: 'Save As...'),
        const MenuEntry.divider(),
        const MenuEntry(label: 'Page Setup...'),
        const MenuEntry(label: 'Print...'),
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
        const MenuEntry(label: 'Undo...'),
        const MenuEntry.divider(),
        const MenuEntry(label: 'Cut'),
        const MenuEntry(label: 'Copy'),
        const MenuEntry(label: 'Paste'),
        const MenuEntry(label: 'Delete'),
        const MenuEntry.divider(),
        const MenuEntry(label: 'Find...'),
        const MenuEntry(label: 'Find Next'),
        const MenuEntry(label: 'Replace...'),
        const MenuEntry(label: 'Go To...'),
        const MenuEntry.divider(),
        const MenuEntry(label: 'Select All'),
        MenuEntry(
          label: 'Time/Date',
          onPressed: () {},
        ),

        MenuEntry(
          label: 'Markdown',
          isChecked: activity.extras?['Markdown'] ?? false,
          onPressed: () {
            myPrint('onMarkdown');
            activity.onCustomAction('Markdown');
            context.forceRebuild();
          },
          // shortcut: const SingleActivator(LogicalKeyboardKey.keyQ, control: true),
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

//我是 AlphaPolo
//
//github:
//https://github.com/AlphaPolo


class NotepadScreen extends StatefulWidget {
  final String initialValue;
  final bool isMarkdown;

  const NotepadScreen({
    super.key,
    String? initialValue,
    bool? isMarkdown,
  }): initialValue = initialValue ?? '',
      isMarkdown = isMarkdown ?? false;

  static WindowActivity createInternetExplorerActivity({
  String? title,
  String? initialValue,
  bool? isMarkdown,
}) {
    final combineTitle = [title, 'Notepad'].whereType<String>().join(' - ');

    return WindowActivity(
      activityId: WindowConstant.idGenerator.nextId().toString(),
      title: combineTitle,
      iconAsset: 'assets/images/icon_notepad_16.png',
      content: NotepadScreen(initialValue: initialValue, isMarkdown: isMarkdown),
      menuGetter: getNotepadMenu,
      extras: {
        if(isMarkdown != null)
        'Markdown' : isMarkdown,
      },
    );
  }

  @override
  State<NotepadScreen> createState() => _NotepadScreenState();
}

class _NotepadScreenState extends State<NotepadScreen> {
  late final TextEditingController controller = TextEditingController(text: widget.initialValue);
  late bool isMarkdown = widget.isMarkdown;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final activity = context.read<WindowActivity>();
      activity.customAction = (action) {
        isMarkdown ^= true;
        (activity.extras ??= {})['Markdown'] = isMarkdown;
        setState(() {});
      };
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(isMarkdown) {
      return buildMarkdown();
    }
    else {
      return buildNotepad();
    }
  }

  Widget buildMarkdown() {
    return ColoredBox(
      color: Colors.white,
      child: Markdown(
        data: controller.text,
        onTapLink: (text, href, title) async {
          final url = Maybe.ofNullable(href)
              .map(Uri.tryParse)
              .getOrElse(null);
          print('onTapLink: ${url.toString()}');
          if(url != null && await canLaunchUrl(url)) {
            await launchUrl(url);
          }
        },
      ),
    );
  }

  Widget buildNotepad() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 8, left: 4),
      child: TextField(
        controller: controller,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        style: const TextStyle(fontSize: 13, height: 14 / 13),
        cursorHeight: 13,
        decoration: const InputDecoration(

          isCollapsed: true,
          isDense: true,
          filled: false,
          border: InputBorder.none,
          constraints: BoxConstraints.expand(),
        ),
      ),
    );
  }
}
