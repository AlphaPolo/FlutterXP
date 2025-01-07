import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xp/components/bottom_window.dart';
import 'package:flutter_xp/components/desktop_item_widget.dart';
import 'package:flutter_xp/components/window/window_frame.dart';
import 'package:flutter_xp/components/window_action_bar.dart';
import 'package:flutter_xp/constant/window_constant.dart';
import 'package:flutter_xp/model/activity/my_computer_content.dart';
import 'package:flutter_xp/model/desktop/desktop_models.dart';
import 'package:flutter_xp/notifications/window_activity_notification.dart';
import 'package:intl/intl.dart';

import 'components/minesweeper/minesweeper_game_screen.dart';
import 'components/task_window.dart';
import 'model/activity/minesweeper_content.dart';
import 'model/activity/window_activity.dart';
import 'r.g.dart';
import 'util/my_print.dart';

class FlutterXP extends StatefulWidget {
  const FlutterXP({Key? key}) : super(key: key);

  @override
  State<FlutterXP> createState() => _FlutterXPState();
}

class _FlutterXPState extends State<FlutterXP> {

  static const double toolbarHeight = WindowConstant.toolbarHeight;

  final DateFormat formatter = DateFormat('hh:mm a');
  final Stream<DateTime> datetimeStream = Stream.periodic(const Duration(seconds: 15), (_) => DateTime.now());

  final ValueNotifier<bool> openTaskBar = ValueNotifier(false);

  final List<WindowActivity> activities = [
    WindowActivity(
      activityId: WindowConstant.idGenerator.nextId().toString(),
      title: 'My Computer',
      iconAsset: 'assets/images/icon_computer_16.png',
      content: myComputerContent,
      menuGetter: getComputerMenu,
      actionBar: const WindowActionBar(),
    ),

    WindowActivity(
      activityId: WindowConstant.idGenerator.nextId().toString(),
      title: 'Minesweeper',
      iconAsset: 'assets/images/minesweeper/icon_mine_32.png',
      content: const MinesweeperGameScreen(),
      resizeable: false,
      rect: WindowConstant.defaultRect.shift(const Offset(20, 20)),
      sizeStrategy: WindowSizeStrategy.wrapContent,
      menuGetter: getMinesweeperMenu,
    ),
    // WindowActivity(
    //   activityId: WindowConstant.idGenerator.nextId().toString(),
    //   title: 'My Computer',
    //   iconAsset: 'assets/images/icon_computer_16.png',
    //   rect: WindowConstant.defaultRect.shift(const Offset(20, 20)),
    //   content: myComputerContent,
    //   menuGetter: getComputerMenu,
    // ),
  ];

  final QueueList<WindowActivity> focusOrder = QueueList<WindowActivity>();
  final ValueNotifier<List<WindowActivity>> focusActivitiesNotifier = ValueNotifier([]);

  final FocusScopeNode desktopNode = FocusScopeNode();
  final FocusScopeNode taskNode = FocusScopeNode();

  @override
  void initState() {
    super.initState();
    focusOrder.addAll(activities);
    focusActivitiesNotifier.value = [...focusOrder];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusOrder.lastOrNull?.focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    for(final activity in activities) {
      activity.dispose();
    }
    focusActivitiesNotifier.dispose();
    desktopNode.dispose();
    taskNode.dispose();
    openTaskBar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    myPrint('build');
    return NotificationListener<WindowActivityNotification>(
      onNotification: onNotification,
      child: Scaffold(
        body: FocusScope(
          node: desktopNode,
          canRequestFocus: true,
          child: Stack(
            fit: StackFit.expand,
            children: [
              buildBackground(),
              buildDesktop(),
              buildAppWindows(),
              buildTaskWindow(),
              buildToolbar(),
            ],
          ),
        )
      ),
    );
  }

  Widget buildBackground() {
    return Image(
      image: R.image.img_windowsXP(),
      fit: BoxFit.cover,
    );
  }

  Widget buildToolbar() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1F2F86),
              Color(0xFF3165C4),
              Color(0xFF3682E5),
              Color(0xFF448AE6),
              Color(0xFF3883E5),
              Color(0xFF2B71E0),
              Color(0xFF2663DA),
              Color(0xFF235BE6),
              Color(0xFF2257D6),
              Color(0xFF2157D6),
              Color(0xFF245DDB),
              Color(0xFF2562DF),
              Color(0xFF245FDC),
              Color(0xFF2158D4),
              Color(0xFF1941A5),
              Color(0xFF1941A5),
            ],
            stops: [0.0, 0.03, 0.06, 0.1, 0.12, 0.15, 0.18, 0.2, 0.23, 0.38, 0.54, 0.86, 0.89, 0.92, 0.95, 0.98],
          ),
        ),
        height: toolbarHeight,
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                if(openTaskBar.value) {
                  // desktopNode.requestFocus();
                  openTaskBar.value = false;
                }
                else {
                  openTaskBar.value = true;
                }
              },
              child: Image(
                image: R.image.btn_start(),
                fit: BoxFit.fitHeight,
                alignment: Alignment.centerLeft,
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(child: buildActivitiesAtToolbar()),
            buildFooterClock(),
          ],
        ),
      ),
    );
  }

  Widget buildFooterClock() {
    return StreamBuilder<DateTime>(
      stream: datetimeStream,
      initialData: DateTime.now(),
      builder: (context, snapshot) {
        final datetime = snapshot.data;
        if (!snapshot.hasData || datetime == null) return const SizedBox.shrink();

        return Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0C59B9),
                Color(0xFF139EE9),
                Color(0xFF18B5F2),
                Color(0xFF139BEB),
                Color(0xFF1290E8),
                Color(0xFF0D8DEA),
                Color(0xFF0D9FF1),
                Color(0xFF0F9EED),
                Color(0xFF119BE9),
                Color(0xFF1392E2),
                Color(0xFF1381D7),
                Color(0xFF095BC9),
              ],
              stops: [0.01, 0.06, 0.1, 0.14, 0.19, 0.63, 0.81, 0.88, 0.91, 0.94, 0.97, 1.0],
            ),
            border: Border(
              left: BorderSide(
                color: Color(0xFF1042AF),
                width: 1.0,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF18BBFF),
                offset: Offset(1.0, 0.0),
                blurRadius: 1.0,
                spreadRadius: 0.0,
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          margin: const EdgeInsets.only(left: 10.0),
          alignment: Alignment.center,
          child: Row(
            children: [
              Image(image: R.image.icon_audio_16(), width: 15, height: 15, fit: BoxFit.fill),
              Image(image: R.image.icon_usb_16(), width: 15, height: 15, fit: BoxFit.fill),
              Image(image: R.image.icon_dangerous_16(), width: 15, height: 15, fit: BoxFit.fill),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(formatter.format(datetime), style: const TextStyle(color: Colors.white, fontSize: 11)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildDesktop() {
    final desktopPrograms = desktopModels;

    return Stack(
      fit: StackFit.expand,
      children: [
        ...desktopPrograms.mapIndexed(
          (index, model) {
            return Positioned(
              top: 48.0 + (49 * index) + 30 * index,
              left: 48.0,
              width: 70,
              child: DesktopItemWidget(
                model: model,
                onDoubleTap: (activity) {
                  if (activity == null) return;
                  addActivity(activity);
                },
              ),
            );
          },
        ).toList(),
      ],
    );

  }

  Widget buildTaskWindow() {
    return ValueListenableBuilder(
      valueListenable: openTaskBar,
      builder: (context, isOpen, _) {
        if(!isOpen) return const SizedBox.shrink();
        return Positioned(
          left: 0,
          bottom: toolbarHeight,
          child: TaskWindow(focusScopeNode: taskNode, onUnFocus: () {
            openTaskBar.value = false;
          })
        );
      }
    );
  }

  Widget buildAppWindows() {
    return Positioned.fill(
      bottom: toolbarHeight,
      child: ValueListenableBuilder(
        valueListenable: focusActivitiesNotifier,
        builder: (context, queue, child) {
          (child as Stack);
          return Stack(
            fit: StackFit.expand,
            children: child.children.sortedByCompare(
              (element) => focusOrder.indexOf((element.key as ObjectKey).value),
              (a, b) => a.compareTo(b),
            ),
          );
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            for(final activity in activities)
              WindowFrame(
              // WindowWrapper(
                key: ObjectKey(activity),
                activity: activity,
                onFocus: () => bringToFront(activity),
                onDelete: deleteActivity,
              ),
          ],
        ),
      ),
    );
  }

  Widget buildActivitiesAtToolbar() {
    return Row(
      children: [
        for(final activity in activities)
          Flexible(
            child: BottomWindow(activity: activity),
          ),
      ],
    );
  }

  void bringToFront(WindowActivity activity) {
    /// already at front
    if(focusOrder.lastOrNull == activity) return;

    final isRemove = focusOrder.remove(activity);
    /// remove failure
    if(!isRemove) return;

    focusOrder.addLast(activity);
    focusActivitiesNotifier.value = [...focusOrder];
  }

  void addActivity(WindowActivity windowActivity) {
    final rect = windowActivity.rect.value;
    final offset = calcWindowOffset(rect.topLeft);
    windowActivity.rect.value = rect.shift(offset);

    activities.add(windowActivity);

    setState(() {
      focusOrder.addLast(windowActivity);
      focusActivitiesNotifier.value = [...focusOrder];
      windowActivity.focusNode.requestFocus();
    });
  }

  void deleteActivity(WindowActivity windowActivity) {
    final isRemove = activities.remove(windowActivity);

    if(!isRemove) return;
    /// remove failure

    focusOrder.remove(windowActivity);

    setState(() {
      windowActivity.dispose();
      focusActivitiesNotifier.value = [...focusOrder];
    });
  }

  /// 重疊偏移量
  Offset calcWindowOffset(Offset initialOffset) {
    myPrint('initialOffset: $initialOffset');
    final lastPosition = focusOrder.lastOrNull?.rect.value.topLeft;

    if(lastPosition == null) return initialOffset;

    return lastPosition.translate(20, 20) - initialOffset;
  }

  bool onNotification(WindowActivityNotification notification) {
    switch(notification) {
      case OpenWindowActivityNotification(:final activity?): addActivity(activity);
      case DeleteWindowActivityNotification(:final activity?): deleteActivity(activity);
    }
    return true;
  }
}

typedef HoverWidgetBuilder = Widget Function(BuildContext context, bool isHover, Widget? child);

class HoverBuilder extends StatelessWidget {
  final Widget? child;

  final HoverWidgetBuilder builder;

  const HoverBuilder({super.key, this.child, required this.builder});

  @override
  Widget build(BuildContext context) {
    bool isHovering = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (event) {
            isHovering = true;
            setState(() {});
          },
          onExit: (event) {
            isHovering = false;
            setState(() {});
          },
          child: builder.call(context, isHovering, child),
        );
      }
    );
  }
}
//
// class SelectHoverWrapper extends StatelessWidget {
//   const SelectHoverWrapper({super.key});
//
//
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
