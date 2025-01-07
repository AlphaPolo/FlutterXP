import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constant/window_constant.dart';
import '../../model/activity/window_activity.dart';
import 'base_decorated_frame.dart';
import 'resizable_window.dart';
import 'strategy_positioned_window_frame.dart';

class WindowFrame extends StatelessWidget {

  final VoidCallback onFocus;
  final ValueVoidCallback<WindowActivity> onDelete;
  final WindowActivity activity;

  const WindowFrame({
    super.key,
    required this.onFocus,
    required this.onDelete,
    required this.activity,
  });


  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: activity,
      child: StrategyPositionedWindowFrame(
        child: Focus(
          focusNode: activity.focusNode,
          onFocusChange: (value) {
            if(value) {
              onFocus.call();
            }
          },
          child: GestureDetector(
            onTap: () => activity.focusNode.requestFocus(),
            child: ResizableWindow(
              child: BaseDecoratedFrame(
                onDelete: onDelete,
                child: activity.content,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
