import 'package:flutter/material.dart';
import 'package:flutter_xp/model/activity/window_activity.dart';
import 'package:flutter_xp/widget/custom/multi_value_listenable_builder.dart';
import 'package:provider/provider.dart';

/// 處理全螢幕、最小化、視窗化的邏輯
class StrategyPositionedWindowFrame extends StatelessWidget {
  final Widget child;

  const StrategyPositionedWindowFrame({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final activity = context.read<WindowActivity>();
    return ValueListenableBuilder3<bool, bool, Rect>(
      first: activity.isMinimized,
      second: activity.isFullScreen,
      third: activity.rect,
      builder: (context, value, _) {
        /// (isMinimized, isFullScreen, rect)
        switch(value) {
          case (true, _, _): return Positioned(
            child: wrapChild(true),
          );
          case (_, true, _):
            return Positioned.fill(
              child: wrapChild(false),
            );
          case (_, _, final rect):
            if(activity.sizeStrategy == WindowSizeStrategy.wrapContent) {
              return Positioned(
                top: rect.topLeft.dy,
                left: rect.topLeft.dx,
                child: wrapChild(false),
              );
            }

            return Positioned.fromRect(
              rect: rect,
              child: wrapChild(false),
            );
        }
      },
    );
  }

  Widget wrapChild(bool hide) {
    return Offstage(
      offstage: hide,
      // opacity: hide ? 0 : 1,
      child: IgnorePointer(
        ignoring: hide,
        child: child,
      ),
    );
  }
}
