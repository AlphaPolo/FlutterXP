import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_xp/helper/analytics_helper.dart';
import 'package:flutter_xp/model/activity/minesweeper_content.dart';
import 'package:flutter_xp/model/activity/window_activity.dart';
import 'package:provider/provider.dart';

import '../../constant/window_constant.dart';
import '../../r.g.dart';
import '../../util/my_print.dart';
import 'constant/minesweeper_constant.dart';
import 'minesweeper_game_core.dart';
import 'widget/minesweeper_cell_factory.dart';
import 'widget/seven_segment_display.dart';


enum MinesweeperDifficulty {
  beginner(9, 9, 10),
  intermediate(16, 16, 40),
  expert(30, 16, 99);

  const MinesweeperDifficulty(this.col, this.row, this.mine);

  final int col;
  final int row;
  final int mine;

}

class MinesweeperGameScreen extends StatefulWidget {
  const MinesweeperGameScreen({super.key});

  static WindowActivity createActivity() {
    return WindowActivity(
      activityId: WindowConstant.idGenerator.nextId().toString(),
      title: 'Minesweeper',
      iconAsset: 'assets/images/minesweeper/icon_mine_32.png',
      content: const MinesweeperGameScreen(),
      resizeable: false,
      sizeStrategy: WindowSizeStrategy.wrapContent,
      menuGetter: getMinesweeperMenu,
    );
  }


  @override
  State<MinesweeperGameScreen> createState() => _MinesweeperGameScreenState();
}

class _MinesweeperGameScreenState extends State<MinesweeperGameScreen> {


  final MinesweeperViewModel viewModel = MinesweeperViewModel();
  final TextEditingController seedInputController = TextEditingController();
  late final FocusNode focusNode = FocusNode();
  final ValueNotifier<bool> settingSeed = ValueNotifier(false);


  final ValueNotifier<(Point<int>?, bool)> mouseState = ValueNotifier((null, false));
  Stream<int>? timer;

  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WindowActivity>().customAction = onCustomAction;
      precacheImages(context);
    });

    focusNode.addListener(() {
      if(!focusNode.hasFocus) {
        settingSeed.value = false;
      }
    });
    super.initState();
  }

  void onCustomAction(action) {
    switch(action) {
      case 'NewGame':
        viewModel.reset();
      case 'Using Help':
        final activity = context.read<WindowActivity>();
        viewModel.toggleAnalytic();
        (activity.extras ??= <String, dynamic>{})['Using Help'] = viewModel.isAnalytics;
        myPrint('Using Help: ${ activity.extras?['Using Help']}');
      case 'Beginner':
        viewModel.setDifficulty(MinesweeperDifficulty.beginner);
      case 'Intermediate':
        viewModel.setDifficulty(MinesweeperDifficulty.intermediate);
      case 'Expert':
        viewModel.setDifficulty(MinesweeperDifficulty.expert);
    }
  }

  Future<void> precacheImages(BuildContext context) {
    return Future.wait([
      precacheImage(R.image.open1(), context),
      precacheImage(R.image.open2(), context),
      precacheImage(R.image.open3(), context),
      precacheImage(R.image.open4(), context),
      precacheImage(R.image.open5(), context),
      precacheImage(R.image.open6(), context),
      precacheImage(R.image.open7(), context),
      precacheImage(R.image.open8(), context),
      precacheImage(R.image.digit0(), context),
      precacheImage(R.image.digit0(), context),
      precacheImage(R.image.digit2(), context),
      precacheImage(R.image.digit3(), context),
      precacheImage(R.image.digit4(), context),
      precacheImage(R.image.digit5(), context),
      precacheImage(R.image.digit6(), context),
      precacheImage(R.image.digit7(), context),
      precacheImage(R.image.digit8(), context),
      precacheImage(R.image.digit9(), context),
      precacheImage(R.image.digit0(), context),
      precacheImage(R.image.dead(), context),
      precacheImage(R.image.smile(), context),
      precacheImage(R.image.win(), context),
      precacheImage(R.image.mine_ceil(), context),
      precacheImage(R.image.mine_death(), context),
      precacheImage(R.image.misflagged(), context),
    ]);
  }

  @override
  void dispose() {
    seedInputController.dispose();
    settingSeed.dispose();
    focusNode.dispose();
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(192, 192, 192, 1),
          border: Border(
            top: BorderSide(width: 3.0, color: MinesweeperConstant.borderColorLight),
            left: BorderSide(width: 3.0, color: MinesweeperConstant.borderColorLight),
          ),
        ),
        padding: const EdgeInsets.all(5.0),
        child: Center(
          child: Consumer<MinesweeperViewModel>(
            builder: (context, viewModel, _) {
              return FittedBox(
                fit: BoxFit.scaleDown,
                child: IntrinsicWidth(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// hide
                      if(false)
                      buildSeed(viewModel),
                      buildTopRow(viewModel),
                      const SizedBox(height: 5.0),
                      Container(
                        decoration: MinesweeperConstant.innerDecoration,
                        child: buildCells(viewModel),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildTopRow(MinesweeperViewModel viewModel) {
    // const width = MinesweeperConstant.segmentPerDigitalWidth*3;
    // const height = MinesweeperConstant.segmentPerDigitalHeight;

    return DecoratedBox(
      decoration: MinesweeperConstant.innerDecoration,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                decoration: MinesweeperConstant.innerDecoration.copyWith(color: Colors.black),
                // width: width,
                height: 27,
                padding: const EdgeInsets.only(left: 2, top: 2, bottom: 2, right: 2),
                alignment: Alignment.center,
                child: SevenSegmentDisplay(
                  width: 3,
                  value: viewModel.mineCount - viewModel.flagCount,
                ),
              ),
              Expanded(
                child: Center(
                  child: DecoratedBox(
                    decoration: MinesweeperConstant.defaultDecoration,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: InkWell(
                        radius: MinesweeperConstant.cellSide,
                        borderRadius: const BorderRadius.all(Radius.circular(MinesweeperConstant.cellSide)),
                        onTap: () {
                          mouseState.value = (null, false);
                          viewModel.reset();
                        },
                        onSecondaryTapDown: (_) {
                          mouseState.value = (null, false);
                          viewModel.reset(viewModel.seed);
                        },
                        child: switch ((viewModel.isGameOver, viewModel.isGameWin)) {
                          (true, _) => Image(
                            image: R.image.dead(),
                            fit: BoxFit.fill,
                          ),
                          (false, true) => Image(
                              image: R.image.win(),
                              fit: BoxFit.fill,
                            ),
                          _ => Image(
                            image: R.image.smile(),
                            fit: BoxFit.fill,
                          ),
                        },
                      ),
                    ),
                  ),
                ),
              ),
              /// timer
              Container(
                decoration: MinesweeperConstant.innerDecoration.copyWith(color: Colors.black),
                // width: width,
                height: 27,
                padding: const EdgeInsets.only(left: 2, top: 2, bottom: 2, right: 2),
                child: StreamBuilder<int>(
                  stream: getTimer(viewModel),
                  builder: (context, snapshot) {
                    return SevenSegmentDisplay(
                      width: 3,
                      value: snapshot.data ?? 0,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Stream<int> getTimer(MinesweeperViewModel viewModel) {
    if (viewModel.isGameOver || viewModel.isGameWin) {
      timer = null;
      return Stream<int>.value(viewModel.lastCount ?? 0);
    }

    if (viewModel.startTimestamp case DateTime timestamp) {
      return timer ??= Stream.periodic(const Duration(seconds: 1), (count) {
        final elapsed = DateTime
            .now()
            .difference(timestamp)
            .inSeconds;
        viewModel.lastCount = elapsed;
        return elapsed;
      });
    } else {
      timer = null;
      return Stream<int>.value(0);
    }
  }

  Widget buildCells(MinesweeperViewModel viewModel) {
    final boardState = viewModel.boardState;

    if (boardState == null) {
      return Listener(
        onPointerDown: onPointerDown,
        onPointerMove: onPointerMove,
        onPointerCancel: onPointerCancel,
        onPointerUp: onPointerUp,
        child: ColoredBox(
          color: const Color.fromRGBO(197, 197, 197, 1.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              viewModel.row,
              (y) => Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  viewModel.col,
                  (x) {
                    return unStartBuildCell(viewModel, x, y);
                  },
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Listener(
      onPointerDown: onPointerDown,
      onPointerMove: onPointerMove,
      onPointerCancel: onPointerCancel,
      onPointerUp: onPointerUp,
      child: ColoredBox(
        color: const Color.fromRGBO(197, 197, 197, 1.0),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: boardState.mapIndexed((y, row) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: row.mapIndexed((x, state) {
                    return SizedBox.square(
                      dimension: MinesweeperConstant.cellSide,
                      child: getCellWidget(viewModel, state, Point<int>(x, y)),
                    );
                  }).toList(),
                );
              }).toList(),
            ),
            Positioned.fill(
              child: buildAnalyticsOverlay(),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox unStartBuildCell(MinesweeperViewModel viewModel, int x, int y) {
    return SizedBox.square(
      dimension: MinesweeperConstant.cellSide,
      child: viewModel.hasFlag(Point<int>(x, y))
          ? MinesweeperConstant.defaultFlagCell
          : ValueListenableBuilder(
              valueListenable: mouseState,
              builder: (context, record, _) {
                if (record
                    case (
                      final point?,
                      _,
                    ) when point == Point<int>(x, y)) {
                  return AnimatedContainer(
                    duration: 300.ms,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(197, 197, 197, 1.0),
                      border: Border(
                        left: BorderSide(width: 1.2, color: Color.fromRGBO(128, 128, 128, 1)),
                        top: BorderSide(width: 1.2, color: Color.fromRGBO(128, 128, 128, 1)),
                      ),
                    ),
                  );
                } else {
                  return MinesweeperConstant.defaultPrototypeCell;
                }
              },
            ),
    );
  }

  Point<int> getCellPosition(Offset offset) {
    final position = offset ~/ MinesweeperConstant.cellSide;
    final click = Point<int>(position.dx.toInt(), position.dy.toInt());
    return click;
  }

  void onPointerDown(PointerDownEvent event) {
    if(viewModel.isGameOver || viewModel.isGameWin) return;

    myPrint('down event.buttons: ${event.buttons}');


    if(event.buttons == kPrimaryMouseButton) {
      mouseState.value = (getCellPosition(event.localPosition), false);
    }
    else if(event.buttons == kSecondaryMouseButton) {
      Point<int> click = getCellPosition(event.localPosition);

      myPrint('toggle flag: $click');
      if(viewModel.isValid(click)) {
        viewModel.toggleFlag(click);
      }
      mouseState.value = (null, false);
    }

  }

  void onPointerMove(PointerMoveEvent event) {
    if(viewModel.isGameOver || viewModel.isGameWin) return;
    switch(mouseState.value) {
      case (null, _): return;
      case (final _?, false) when event.buttons == 3:
        final newPoint = getCellPosition(event.localPosition);
        mouseState.value = (newPoint, true);
      case (final _?, true) when event.buttons != 3:
        final newPoint = getCellPosition(event.localPosition);
        /// release any one
        /// check multi open
        myPrint('release at: $newPoint');

        viewModel.revealAroundCell(newPoint);

        mouseState.value = (null, false);
      default:
        final newPoint = getCellPosition(event.localPosition);
        mouseState.value = (newPoint, mouseState.value.$2);
    }
  }

  void onPointerCancel(PointerCancelEvent event) {
    myPrint('cancel event.buttons: ${event.buttons}');

    if(event.buttons == kPrimaryMouseButton) {

    }
    else if(event.buttons == kSecondaryMouseButton) {

    }
  }

  void onPointerUp(PointerUpEvent event) {
    if(viewModel.isGameOver || viewModel.isGameWin) return;
    if(mouseState.value case (null, _)) return;

    final newPoint = getCellPosition(event.localPosition);
    if(viewModel.isValid(newPoint)) {
      viewModel.clickAtPosition(newPoint);
    }
    mouseState.value = (null, false);
  }

  Widget getCellWidget(MinesweeperViewModel viewModel, MinesweeperCellState state, Point<int> position) {
    return ValueListenableBuilder(
      valueListenable: mouseState,
      builder: (context, record, child) {
        final (click, isRightPressing) = record;
        if(click != null && isRightPressing) {
          return MinesweeperCellFactory(
            viewModel: viewModel,
            state: state,
            position: position,
            isPressed: click.distanceTo(position) < 2,
          );
        }

        return MinesweeperCellFactory(
          viewModel: viewModel,
          state: state,
          position: position,
          isPressed: position == click,
        );
      },
    );
  }

  Widget buildSeed(MinesweeperViewModel viewModel) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ValueListenableBuilder(
              valueListenable: settingSeed,
              builder: (context, isSettingSeed, _) {

                const textStyle = TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                );

                if(isSettingSeed) {
                  return Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    alignment: Alignment.center,
                    child: TextField(
                      autofillHints: [
                        'minesweeperAutoFill'
                        // '358101',
                        // '731911',
                      ],
                      autofocus: true,
                      maxLines: 1,
                      maxLength: 6,
                      focusNode: focusNode,
                      controller: seedInputController,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textAlignVertical: TextAlignVertical.center,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'seed',
                      ),
                      buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                      style: textStyle.copyWith(color: Colors.black),
                      onSubmitted: (String input) {
                        if(int.tryParse(input) case final seed? when seed >= 0) {
                          TextInput.finishAutofillContext();
                          viewModel.reset(seed);
                        }
                      },
                      expands: false,
                    ),
                  ).animate()
                  .fadeIn(duration: 700.ms);
                }
                else {
                  return InkWell(
                    onTap: () {
                      seedInputController.text = viewModel.seed.toString();
                      settingSeed.value = true;
                      // focusNode.requestFocus();
                    },
                    child: Text(
                      viewModel.seed.toString(),
                      style: textStyle,
                    ),
                  ).animate()
                      .fadeIn();

                }
              },
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: CupertinoSwitch(value: viewModel.isAnalytics, onChanged: (value) => viewModel.toggleAnalytic()),
        ),
      ],
    );

  }

  Widget buildAnalyticsOverlay() {
    final map = viewModel.gameCore.analyticsMap ?? {};
    return IgnorePointer(
      child: Stack(
        children: map.entries.map((e) {
          return Positioned(
            top: MinesweeperConstant.cellSide * e.key.y,
            left: MinesweeperConstant.cellSide * e.key.x,
            width: MinesweeperConstant.cellSide,
            height: MinesweeperConstant.cellSide,
            child: switch(e.value) {
              100.0 => Container(color: Colors.red.withOpacity(0.2)),
              0.0 => Container(color: Colors.green.withOpacity(0.2)),
              // final percent => Container(
              //   alignment: Alignment.center,
              //   child: FittedBox(child: Text(percent.toInt().toString())),
              // ),
              _ => const SizedBox.shrink(),
            },
          );
        }).toList(),
      ),
    );
  }

}


class MinesweeperViewModel extends ChangeNotifier {

  late final MinesweeperGameCore gameCore = MinesweeperGameCore(
    onWin: () => AnalyticsHelper.logMinesweeperWin(
      '$seed',
      DateTime.now()
          .difference(startTimestamp ?? DateTime.now())
          .abs()
          .inSeconds,
    ).ignore(),
    onLose: () => AnalyticsHelper.logMinesweeperLose(
      '$seed',
      DateTime.now()
          .difference(startTimestamp ?? DateTime.now())
          .abs()
          .inSeconds,
    ).ignore(),
  );

  DateTime? startTimestamp;
  int? lastCount;


  int get row => gameCore.row;
  int get col => gameCore.col;

  late int seed = generateNewSeed();

  List<List<MinesweeperCellState>>? get boardState {
    if(gameCore.isNotHasBoardState) return null;
    return List.unmodifiable(gameCore.boardState!);
  }

  bool get isAnalytics => gameCore.analytics;
  bool get isGameOver => gameCore.isGameOver;
  bool get isGameWin => gameCore.isGameWin;

  bool isValid(Point<int> click) => (click.x >= 0 && click.x < col) && (click.y >= 0 && click.y < row);
  int get flagCount => gameCore.flagMap.length;
  int get mineCount => gameCore.mine;

  void clickAtPosition(Point<int> click) {
    if(gameCore.isNotHasBoardState) {
      gameCore.init(click.x, click.y, seed);
      setTimestamp();
    }
    else {
      gameCore.interactivePoint(click);
    }
    notifyListeners();
  }

  void revealAroundCell(Point<int> newPoint) {
    if(isValid(newPoint)) {
      gameCore.revealAroundCell(newPoint);
      notifyListeners();
      // viewModel.clickAtPosition(newPoint);
    }
  }

  void toggleFlag(Point<int> position) {
    if(gameCore.isNotHasBoardState) {
      gameCore.toggleFlag(position);
    }
    else {
      myPrint(gameCore.boardState![position.y][position.x]);
      if(gameCore.boardState![position.y][position.x] case MinesweeperCellState.mine || MinesweeperCellState.empty) {
        gameCore.toggleFlag(position);
      }
    }
    setTimestamp();
    notifyListeners();
  }

  void toggleAnalytic() {
    gameCore.toggleAnalytics();
    notifyListeners();
  }

  void setTimestamp() {
    startTimestamp ??= DateTime.now();
  }

  void clearTimestamp() {
    startTimestamp = null;
  }

  bool hasFlag(Point<int> position) {
    return gameCore.flagMap.contains(position);
  }

  void reset([int? seed]) {
    this.seed = seed ?? generateNewSeed();
    myPrint('reset: $seed');
    gameCore.reset();
    clearTimestamp();
    notifyListeners();
  }

  int generateNewSeed() => Random().nextInt(1000000);

  void setDifficulty(MinesweeperDifficulty difficulty) {
    gameCore.setBoardSizeAndMines(difficulty.col, difficulty.row, difficulty.mine);
    notifyListeners();
  }


}
