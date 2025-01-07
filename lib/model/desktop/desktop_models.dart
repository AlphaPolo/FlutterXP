import 'dart:ui';

import 'package:flutter_xp/components/cheat_wheel/cheat_wheel_screen.dart';
import 'package:flutter_xp/components/explorer_viewer.dart';
import 'package:flutter_xp/components/minesweeper/minesweeper_game_screen.dart';
import 'package:flutter_xp/components/solitaire/solitaire.dart';
import 'package:flutter_xp/components/window_action_bar.dart';
import 'package:flutter_xp/constant/window_constant.dart';
import 'package:flutter_xp/helper/analytics_helper.dart';
import 'package:flutter_xp/model/activity/internet_explorer_content.dart';
import 'package:flutter_xp/model/activity/notepad_content.dart';

import '../../components/minesweeper/constant/minesweeper_constant.dart';
import '../../components/painter/painter.dart';
import '../../util/my_localization.dart';
import '../activity/document_content.dart';
import '../activity/my_computer_content.dart';
import '../activity/window_activity.dart';

final mineSweeperSize = MinesweeperConstant.size +
    const Offset(0, WindowConstant.windowHeaderHeight) +
    const Offset(0, WindowConstant.windowMenuHeight) +
    const Offset(0, WindowConstant.windowActionBarHeight);

class DeskTopModel {
  final String label;
  final String iconAsset;
  final ActivityGetter? createActivity;

  const DeskTopModel({
    required this.label,
    required this.iconAsset,
    this.createActivity,
  });
}

List<DeskTopModel> desktopModels = [
  DeskTopModel(
    label: 'Computer',
    iconAsset: 'assets/images/icon_computer_32.png',
    createActivity: () {
      return WindowActivity(
        activityId: WindowConstant.idGenerator.nextId().toString(),
        title: 'My Computer',
        iconAsset: 'assets/images/icon_computer_16.png',
        content: myComputerContent,
        menuGetter: getComputerMenu,
        actionBar: const WindowActionBar(),
      );
    },
  ),
  DeskTopModel(
    label: 'Document',
    iconAsset: 'assets/images/icon_document_32.png',
    createActivity: () {
      return MyDocumentScreen.createActivity();
      return WindowActivity(
        activityId: WindowConstant.idGenerator.nextId().toString(),
        title: 'My Documents',
        iconAsset: 'assets/images/icon_my_documents_16.png',
        content: ExplorerViewer(models: documentContent),
        menuGetter: getComputerMenu,
        actionBar: const WindowActionBar(),
      );
    },
  ),
  DeskTopModel(
    label: 'Internet Explorer',
    iconAsset: 'assets/images/icon_internet_32.png',
    createActivity: () {
      return InAppBrowserExampleScreen.createInternetExplorerActivity();
    },
  ),
  DeskTopModel(
    label: 'Minesweeper',
    iconAsset: 'assets/images/minesweeper/icon_mine_32.png',
    createActivity: () {
      return MinesweeperGameScreen.createActivity();
    },
  ),
  DeskTopModel(
    label: 'README',
    iconAsset: 'assets/images/icon_notepad_32.png',
    createActivity: () {
      return NotepadScreen.createInternetExplorerActivity(
        title: 'README',
        initialValue: S().readmeContent,
        isMarkdown: true,
      );
    },
  ),
  DeskTopModel(
    label: 'Fortune Wheel',
    iconAsset: 'assets/images/icon_fortune_wheel_48.png',
    createActivity: () {
      return WindowActivity(
        activityId: WindowConstant.idGenerator.nextId().toString(),
        title: 'Fortune Wheel',
        iconAsset: 'assets/images/icon_fortune_wheel_48.png',
        content: const CheatWheelScreen(),
        // resizeable: false,
        rect: WindowConstant.defaultOffset & const Size(902, 472),
        // menuGetter: getMinesweeperMenu,
      );
    },
  ),
  DeskTopModel(
    label: 'Painter (WIP)',
    iconAsset: 'assets/images/icon_paint_32.png',
    createActivity: () {
      AnalyticsHelper.logApplicationOpen('Painter').ignore();
      return WindowActivity(
        activityId: WindowConstant.idGenerator.nextId().toString(),
        title: 'Painter (WIP)',
        iconAsset: 'assets/images/icon_paint_32.png',
        content: const PainterScreen(),
        // resizeable: false,
        // rect: WindowConstant.defaultOffset & const Size(902, 472),
        // menuGetter: getMinesweeperMenu,
      );
    },
  ),
  DeskTopModel(
    label: 'Solitaire',
    iconAsset: 'assets/images/icon_solitaire_32.png',
    createActivity: () {
      AnalyticsHelper.logApplicationOpen('Solitaire').ignore();
      return SolitaireScreen.createActivity();
    },
  ),
];
