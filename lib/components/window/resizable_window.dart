import 'package:flutter/material.dart';
import 'package:flutter_xp/extensions/rect_extension.dart';
import 'package:flutter_xp/model/activity/window_activity.dart';
import 'package:flutter_xp/widget/custom/multi_value_listenable_builder.dart';
import 'package:provider/provider.dart';

import '../../constant/window_constant.dart';
import '../window_widget.dart';

/// 處理拉伸大小的邏輯
class ResizableWindow extends StatefulWidget {
  final Widget child;

  const ResizableWindow({
    super.key,
    required this.child,
  });

  @override
  State<ResizableWindow> createState() => _ResizableWindowState();
}

class _ResizableWindowState extends State<ResizableWindow> {
  (Offset, Rect)? origin;

  @override
  Widget build(BuildContext context) {
    final activity = context.read<WindowActivity>();

    return ValueListenableBuilder2<bool, bool>(
      first: activity.resizeable,
      second: activity.isFullScreen,
      builder: (context, value, child) {
        final (isResizable, isFullScreen) = value;

        if(!isResizable || isFullScreen) {
          return Stack(
            children: [
              widget.child,
            ],
          );
        }

        return Stack(
          children: [
            widget.child,
            ...buildScaleControls(),
          ],
        );
      },
    );


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

    return controls;
  }


  void resizePanDown(DragStartDetails detail, ResizeDirection direction) {
    final provider = context.read<WindowActivity>();
    provider.focusNode.requestFocus();
    origin = (detail.globalPosition, provider.rect.value);
  }

  void resizePanUpdate(DragUpdateDetails detail, ResizeDirection direction) {
    final provider = context.read<WindowActivity>();
    final origin = this.origin;
    if (origin == null) return;
    final originRect = origin.$2;
    final offset = detail.globalPosition - origin.$1;

    final previousRect = provider.rect.value;

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

    provider.rect.value = newRect;
  }

  void resizePanEnd(DragEndDetails detail, ResizeDirection direction) {
    final provider = context.read<WindowActivity>();
    provider.focusNode.requestFocus();
    origin = null;
  }
}