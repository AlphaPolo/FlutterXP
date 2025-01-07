import 'package:flutter/material.dart';
import 'package:flutter_xp/constant/window_constant.dart';
import 'package:provider/provider.dart';

import '../../model/activity/window_activity.dart';
import '../window_menu.dart';
import 'window_header.dart';

/// 基本的視窗裝飾框架
class BaseDecoratedFrame extends StatelessWidget {
  final Widget child;
  final ValueVoidCallback<WindowActivity> onDelete;

  const BaseDecoratedFrame({
    super.key,
    required this.child,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final activity = context.read<WindowActivity>();
    final node = activity.focusNode;
    return AnimatedBuilder(
      animation: node,
      builder: (context, content) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: node.hasFocus
                ? const Color.fromRGBO(8, 49, 217, 1)
                : const Color.fromRGBO(101, 130, 245, 1),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0)),
          ),
          child: content,
        );
      },
      child: buildContent(activity),
    );
  }

  Widget buildContent(WindowActivity activity) {
    final actionBar = activity.actionBar;
    if(activity.sizeStrategy == WindowSizeStrategy.wrapContent) {
      return IntrinsicWidth(
        child: Column(
          children: [
            WindowHeader(
              onDelete: onDelete,
            ),
            Padding(
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
                child: Column(
                  children: [
                    WindowMenu(activity: activity),
                    if(actionBar != null)
                      actionBar,
                    child,
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
    else {
      return Column(
        children: [
          WindowHeader(
            onDelete: onDelete,
          ),
          Expanded(
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
                child: Column(
                  children: [
                    WindowMenu(activity: activity),
                    if(actionBar != null)
                      actionBar,
                    Expanded(child: child),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}