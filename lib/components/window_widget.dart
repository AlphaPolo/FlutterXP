import 'package:flutter/material.dart';
import 'package:flutter_xp/components/window_menu.dart';
import 'package:flutter_xp/constant/window_constant.dart';
import 'package:flutter_xp/extensions/rect_extension.dart';
import 'package:flutter_xp/model/activity/window_activity.dart';

import '../util/my_print.dart';

class WindowWrapper extends StatefulWidget {
  final WindowActivity activity;

  final VoidCallback onFocus;
  final ValueVoidCallback<WindowActivity> onDelete;

  const WindowWrapper({
    super.key,
    required this.activity,
    required this.onFocus,
    required this.onDelete,
  });

  @override
  State<WindowWrapper> createState() => _WindowWrapperState();
}

class _WindowWrapperState extends State<WindowWrapper> {
  late final WindowActivity activity;

  (Offset, Rect)? origin;

  // GlobalKey windowKey = GlobalKey();

  bool get isFullScreen => activity.isFullScreen.value;
  set isFullScreen(bool value) => activity.isFullScreen.value = value;

  Rect get rect => activity.rect.value;
  set rect(Rect rect) => activity.rect.value = rect;


  @override
  void initState() {
    activity = widget.activity;
    myPrint('window ${activity.activityId} create at ${activity.rect.value.topLeft}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildStrategyContent();
  }

  Widget buildStrategyContent() {
    return ValueListenableBuilder(
      valueListenable: activity.isFullScreen,
      builder: (context, isFullScreen, content) {
        if(activity.sizeStrategy == WindowSizeStrategy.wrapContent) {
          return buildWrapSizeWindow(content!);
        }
        if(isFullScreen) {
          return buildFullScreen(content!);
        }
        else {
          return buildWindow(content!);
        }
      },
      child: ValueListenableBuilder(
        valueListenable: activity.isMinimized,
        builder: (context, isMinimized, content) {
          return Opacity(
            opacity: isMinimized ? 0 : 1,
            child: content,
          );
        },
        child: buildContent(),
      ),
    );
  }

  Widget buildWrapSizeWindow(Widget content) {
    return ValueListenableBuilder(

      valueListenable: activity.rect,
      builder: (context, rect, _) {
        return Positioned(
          left: rect.left,
          top: rect.top,
          child: _!,
        );
      },
      child: Container(
        // key: windowKey,
        decoration: BoxDecoration(
          color: activity.focusNode.hasFocus
              ? const Color.fromRGBO(8, 49, 217, 1): const Color.fromRGBO(101, 130, 245, 1),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0)),
        ),
        child: AnimatedBuilder(
          animation: activity.focusNode,
          builder: (context, child) {
            return Container(
              // key: windowKey,
              decoration: BoxDecoration(
                color: activity.focusNode.hasFocus
                    ? const Color.fromRGBO(8, 49, 217, 1)
                    : const Color.fromRGBO(101, 130, 245, 1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0)),
              ),
              // padding: const EdgeInsets.all(3),
              child: IntrinsicWidth(
                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    buildWindowHeader(activity.focusNode.hasFocus),
                    child!,
                  ],
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(3, 0, 3, 3),
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFFEDEDE5),
                    Color(0xFFEDE8CD),
                  ],
                  stops: [0.0, 1.0],
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  myPrint('mineSweeper focus');
                  activity.focusNode.requestFocus();
                },
                child: IntrinsicWidth(
                  child: Column(
                    children: [
                      buildMenuBar(),
                      buildActionBar(),
                      activity.content,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget buildFullScreen(Widget content) {
    return Positioned.fill(
      child: content,
    );
  }

  Widget buildWindow(Widget content) {
    return ValueListenableBuilder(
      valueListenable: activity.rect,
      builder: (context, rect, child) {
        return Positioned.fromRect(
          rect: rect,
          child: child!,
        );
      },
      child: ValueListenableBuilder(
        valueListenable: activity.resizeable,
        builder: (context, resizeable, _) {
          return Stack(
            children: [
              content,
              if(resizeable && activity.sizeStrategy != WindowSizeStrategy.wrapContent)
              ...buildScaleControls(),
            ],
          );
        },
      ),
    );
  }

  Widget buildContent() {
    myPrint('rebuild');
    return Focus(
      focusNode: activity.focusNode,
      onFocusChange: (focus) {
        if(focus) {
          widget.onFocus.call();
        }

        myPrint('window${activity.activityId} is focus: $focus');
      },
      child: AnimatedBuilder(
        animation: activity.focusNode,
        builder: (context, child) {
          return Container(
            // key: windowKey,
            decoration: BoxDecoration(
              color: activity.focusNode.hasFocus
                  ? const Color.fromRGBO(8, 49, 217, 1)
                  : const Color.fromRGBO(101, 130, 245, 1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0)),
            ),
            // padding: const EdgeInsets.all(3),
            child: Column(
              children: [
                buildWindowHeader(activity.focusNode.hasFocus),
                child!,
              ],
            ),
          );
        },
        child: Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(3, 0, 3, 3),
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFFEDEDE5),
                    Color(0xFFEDE8CD),
                  ],
                  stops: [0.0, 1.0],
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  activity.focusNode.requestFocus();
                },
                child: Column(
                  children: [
                    buildMenuBar(),
                    buildActionBar(),
                    Expanded(child: activity.content),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildWindowHeader(bool hasFocus) {
    return Container(
      height: WindowConstant.windowHeaderHeight,
      decoration: hasFocus ? WindowConstant.headerFocusDecoration : WindowConstant.headerUnfocusDecoration,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onDoubleTap: toggleFullScreen,
              onPanDown: (detail) {
                activity.focusNode.requestFocus();

                // if(isFull) return;
                origin = (detail.globalPosition, rect);
              },
              // onPanStart: (detail) {
              //
              // },

              onPanUpdate: (detail) {
                activity.focusNode.requestFocus();

                // if(isFull) return;
                final origin = this.origin;
                if(origin == null) return;

                if(isFullScreen) {
                  isFullScreen = false;
                }

                final offset = detail.globalPosition - origin.$1;
                final newRect = origin.$2.shift(offset);

                rect = newRect;
              },

              onPanEnd: (detail) {
                activity.focusNode.requestFocus();

                // if(isFull) return;
                origin = null;
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4, right: 3),
                    child: SizedBox.square(dimension: 15, child: Image(image: AssetImage(activity.iconAsset.value), fit: BoxFit.fill)),
                  ),
                  Flexible(
                    child: Text(
                      activity.title.value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            offset: Offset(1, 1),
                          ),
                        ],
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          buildButtonsPack(hasFocus),
        ],
      ),
    );
  }

  Widget buildMenuBar() {
    return WindowMenu(activity: activity);
  }

  Widget buildButtonsPack(bool hasFocus) {
    final decoration = BoxDecoration(
      border: Border.all(width: 1, color: Colors.white),
      borderRadius: const BorderRadius.all(Radius.circular(3)),
      boxShadow: const [
        BoxShadow(
          color: Color.fromRGBO(70, 70, 255, 1),
          offset: Offset(0, -1),
          blurRadius: 2,
          spreadRadius: 1,
        ),
      ],
      gradient: const RadialGradient(
        radius: 1,
        center: Alignment(0.5, 0.5),
        colors: [
          Color.fromRGBO(0, 84, 233, 1),
          Color.fromRGBO(34, 99, 213, 1),
          Color.fromRGBO(68, 121, 228, 1),
          Color.fromRGBO(163, 187, 236, 1),
          Colors.white,
        ],
        stops: [0.0, 0.55, 0.7, 0.9, 1.0],
      ),
    );

    final closeDecoration = BoxDecoration(
      border: Border.all(width: 1, color: Colors.white),
      borderRadius: const BorderRadius.all(Radius.circular(3)),
      gradient: const RadialGradient(
        radius: 1,
        center: Alignment(0.5, 0.5),
        colors: [
          Color.fromRGBO(204, 70, 0, 1),
          Color.fromRGBO(220, 101, 39, 1),
          Color.fromRGBO(205, 117, 70, 1),
          Color.fromRGBO(255, 204, 178, 1),
          Colors.white,
        ],
        stops: [0.0, 0.55, 0.7, 0.9, 1.0],
      ),
    );
    return Opacity(
      opacity: hasFocus ? 1 : 0.5,
      child: Padding(
        padding: const EdgeInsets.only(left: 1, right: 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () => activity.isMinimized.value = true,
              child: Container(
                width: 22,
                height: 22,
                decoration: decoration,
                child: const Icon(Icons.minimize, size: 16, color: Colors.white),
              ),
            ),
            const SizedBox(width: 1.0),
            InkWell(
              onTap: toggleFullScreen,
              child: Container(
                width: 22,
                height: 22,
                decoration: decoration,
                child: const Icon(Icons.maximize, size: 16, color: Colors.white),
              ),
            ),
            const SizedBox(width: 1.0),
            InkWell(
              onTap: () => widget.onDelete(activity),
              child: Container(
                width: 22,
                height: 22,
                decoration: closeDecoration,
                child: const Icon(Icons.close, size: 16, color: Colors.white),
              ),
            ),
            const SizedBox(width: 1.0),
          ],
        ),
      ),
    );
  }

  void toggleFullScreen() {
    activity.focusNode.requestFocus();

    isFullScreen ^= true;
  }

  List<Widget> buildScaleControls() {
    const double side = 4;

    List<Widget> controls = [
      /// left
      Positioned(
        left: 0,
        top: side,
        bottom: side,
        width: side,
        child: MouseRegion(
          hitTestBehavior: HitTestBehavior.translucent,
          cursor: SystemMouseCursors.resizeLeft,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanStart: (detail) => resizePanDown(detail, ResizeDirection.left),
            onPanUpdate: (detail) => resizePanUpdate(detail, ResizeDirection.left),
            onPanEnd: (detail) => resizePanEnd(detail, ResizeDirection.left),
          ),
        ),
      ),

      /// left-top
      Positioned(
        left: 0,
        top: 0,
        width: side,
        height: side,
        child: MouseRegion(
          hitTestBehavior: HitTestBehavior.translucent,
          cursor: SystemMouseCursors.resizeUpLeft,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanStart: (detail) => resizePanDown(detail, ResizeDirection.topLeft),
            onPanUpdate: (detail) => resizePanUpdate(detail, ResizeDirection.topLeft),
            onPanEnd: (detail) => resizePanEnd(detail, ResizeDirection.topLeft),
          ),
        ),
      ),

      /// top
      Positioned(
        top: 0,
        left: side,
        right: side,
        height: side,
        child: MouseRegion(
          hitTestBehavior: HitTestBehavior.translucent,
          cursor: SystemMouseCursors.resizeUp,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanStart: (detail) => resizePanDown(detail, ResizeDirection.top),
            onPanUpdate: (detail) => resizePanUpdate(detail, ResizeDirection.top),
            onPanEnd: (detail) => resizePanEnd(detail, ResizeDirection.top),
          ),
        ),
      ),

      /// top-right
      Positioned(
        right: 0,
        top: 0,
        width: side,
        height: side,
        child: MouseRegion(
          hitTestBehavior: HitTestBehavior.translucent,
          cursor: SystemMouseCursors.resizeUpRight,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanStart: (detail) => resizePanDown(detail, ResizeDirection.topRight),
            onPanUpdate: (detail) => resizePanUpdate(detail, ResizeDirection.topRight),
            onPanEnd: (detail) => resizePanEnd(detail, ResizeDirection.topRight),
          ),
        ),
      ),

      /// right
      Positioned(
        right: 0,
        top: side,
        bottom: side,
        width: side,
        child: MouseRegion(
          hitTestBehavior: HitTestBehavior.translucent,
          cursor: SystemMouseCursors.resizeRight,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanStart: (detail) => resizePanDown(detail, ResizeDirection.right),
            onPanUpdate: (detail) => resizePanUpdate(detail, ResizeDirection.right),
            onPanEnd: (detail) => resizePanEnd(detail, ResizeDirection.right),
          ),
        ),
      ),

      /// right-bottom
      Positioned(
        right: 0,
        bottom: 0,
        width: side,
        height: side,
        child: MouseRegion(
          hitTestBehavior: HitTestBehavior.translucent,
          cursor: SystemMouseCursors.resizeDownRight,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanStart: (detail) => resizePanDown(detail, ResizeDirection.bottomRight),
            onPanUpdate: (detail) => resizePanUpdate(detail, ResizeDirection.bottomRight),
            onPanEnd: (detail) => resizePanEnd(detail, ResizeDirection.bottomRight),
          ),
        ),
      ),

      /// bottom
      Positioned(
        bottom: 0,
        left: side,
        right: side,
        height: side,
        child: MouseRegion(
          hitTestBehavior: HitTestBehavior.translucent,
          cursor: SystemMouseCursors.resizeDown,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanStart: (detail) => resizePanDown(detail, ResizeDirection.bottom),
            onPanUpdate: (detail) => resizePanUpdate(detail, ResizeDirection.bottom),
            onPanEnd: (detail) => resizePanEnd(detail, ResizeDirection.bottom),
          ),
        ),
      ),

      /// left-bottom
      Positioned(
        left: 0,
        bottom: 0,
        width: side,
        height: side,
        child: MouseRegion(
          hitTestBehavior: HitTestBehavior.translucent,
          cursor: SystemMouseCursors.resizeDownLeft,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanStart: (detail) => resizePanDown(detail, ResizeDirection.bottomLeft),
            onPanUpdate: (detail) => resizePanUpdate(detail, ResizeDirection.bottomLeft),
            onPanEnd: (detail) => resizePanEnd(detail, ResizeDirection.bottomLeft),
          ),
        ),
      ),
    ];

    if(isFullScreen) {
      return controls.map((e) => IgnorePointer(child: e)).toList();
    }

    return controls;
  }

  void resizePanDown(DragStartDetails detail, ResizeDirection direction) {
    activity.focusNode.requestFocus();

    if(isFullScreen) return;
    origin = (detail.globalPosition, rect);
  }

  void resizePanUpdate(DragUpdateDetails detail, ResizeDirection direction) {
    activity.focusNode.requestFocus();

    if(isFullScreen) return;
    final origin = this.origin;
    if (origin == null) return;
    final originRect = origin.$2;
    final offset = detail.globalPosition - origin.$1;

    final previousRect = rect;

    Rect newRect = switch(direction) {
      ResizeDirection.left => originRect.expand(left: offset.dx),
      ResizeDirection.top => originRect.expand(top: offset.dy),
      ResizeDirection.right => originRect.expand(right: offset.dx),
      ResizeDirection.bottom => originRect.expand(bottom: offset.dy),

      ResizeDirection.topLeft => originRect.expand(left: offset.dx, top: offset.dy),
      ResizeDirection.topRight => originRect.expand(right: offset.dx, top: offset.dy),
      ResizeDirection.bottomRight => originRect.expand(right: offset.dx, bottom: offset.dy),
      ResizeDirection.bottomLeft => originRect.expand(left: offset.dx, bottom: offset.dy),
    };

    if (newRect.width < WindowConstant.minimumSide) {
      newRect = newRect.copyWith(left: previousRect.left, right: previousRect.right);
    }

    if (newRect.height < WindowConstant.minimumSide) {
      newRect = newRect.copyWith(top: previousRect.top, bottom: previousRect.bottom);
    }

    rect = newRect;
  }

  void resizePanEnd(DragEndDetails detail, ResizeDirection direction) {
    activity.focusNode.requestFocus();

    if(isFullScreen) return;
    origin = null;
  }


  Widget buildActionBar() {
    return activity.actionBar ?? const SizedBox.shrink();
    // return const WindowActionBar();
  }


}

enum ResizeDirection {
  top,
  topRight,
  right,
  bottomRight,
  bottom,
  bottomLeft,
  left,
  topLeft,
}