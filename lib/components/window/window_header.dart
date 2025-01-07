import 'package:flutter/material.dart';
import 'package:flutter_xp/model/activity/window_activity.dart';
import 'package:provider/provider.dart';

import '../../constant/window_constant.dart';
import '../../widget/custom/multi_value_listenable_builder.dart';

/// 視窗最上方的標題，也處理移動的邏輯
class WindowHeader extends StatefulWidget {
  final ValueVoidCallback<WindowActivity> onDelete;

  const WindowHeader({
    super.key,
    required this.onDelete,
  });

  @override
  State<WindowHeader> createState() => _WindowHeaderState();


}

class _WindowHeaderState extends State<WindowHeader> {
  (Offset, Rect)? origin;

  @override
  Widget build(BuildContext context) {
    final activity = context.read<WindowActivity>();
    // final (title, iconAsset, hasFocus) = context.select<WindowPropertyProvider, (String, String, bool)>(
    //   (provider) => (provider.title, provider.iconAsset, provider.isFocus),
    // );

    return AnimatedBuilder(
      animation: activity.focusNode,
      builder: (context, header) {
        final hasFocus = activity.focusNode.hasFocus;

        return Container(
          height: WindowConstant.windowHeaderHeight,
          decoration: hasFocus ? WindowConstant.headerFocusDecoration : WindowConstant.headerUnfocusDecoration,
          child: Row(
            children: [
              Expanded(child: header!),
              buildButtonsPack(activity, hasFocus),
            ],
          ),
        );
      },
      child: buildHeader(activity),
    );
  }

  Widget buildHeader(WindowActivity activity) {
    return ValueListenableBuilder2(
      first: activity.title,
      second: activity.iconAsset,
      builder: (context, (String, String) value, _) {
        final (title, iconAsset) = value;

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onDoubleTap: toggleFullScreen,
          onPanDown: onPanDown,
          onPanUpdate: onPanUpdate,
          onPanEnd: onPanEnd,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4, right: 3),
                child: SizedBox.square(dimension: 15, child: Image(image: AssetImage(iconAsset), fit: BoxFit.fill)),
              ),
              Flexible(
                child: Text(
                  title,
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
        );
      }
    );
  }

  Widget buildButtonsPack(WindowActivity activity, bool hasFocus) {
    const decoration = BoxDecoration(
      border: Border.fromBorderSide(BorderSide(width: 1, color: Colors.white)),
      borderRadius: BorderRadius.all(Radius.circular(3)),
      boxShadow: [
        BoxShadow(
          color: Color.fromRGBO(70, 70, 255, 1),
          offset: Offset(0, -1),
          blurRadius: 2,
          spreadRadius: 1,
        ),
      ],
      gradient: RadialGradient(
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

    const closeDecoration = BoxDecoration(
      border: Border.fromBorderSide(BorderSide(width: 1, color: Colors.white)),
      borderRadius: BorderRadius.all(Radius.circular(3)),
      gradient: RadialGradient(
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
              onTap: minimizedWindow,
              child: Container(
                width: 22,
                height: 22,
                decoration: decoration,
                child: const Icon(Icons.minimize, size: 16, color: Colors.white),
              ),
            ),
            const SizedBox(width: 1.0),
            ValueListenableBuilder2<bool, bool>(
              first: activity.resizeable,
              second: activity.isFullScreen,
              builder: (context, value, _) {
                final (isResizable, isFullScreen) = value;
                Widget child = InkWell(
                  onTap: isResizable ? toggleFullScreen : null,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: decoration,
                    alignment: Alignment.center,
                    child: isFullScreen ? const _MaximizedIcon(size: 16) : const _MaximizeIcon(size: 16),
                  ),
                );

                if(!isResizable) {
                  child = Opacity(opacity: 0.5, child: child);
                }

                return child;
              },
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

  void onPanDown(DragDownDetails details) {
    final provider = context.read<WindowActivity>();
    provider.focusNode.requestFocus();
    if(provider.isFullScreen.value) {
      return;
    }
    origin = (details.globalPosition, provider.rect.value);
  }

  void onPanUpdate(DragUpdateDetails details) {
    final provider = context.read<WindowActivity>();
    final origin = this.origin;
    if(origin == null) return;

    final offset = details.globalPosition - origin.$1;
    final newRect = origin.$2.shift(offset);

    provider.rect.value = newRect;
  }

  void onPanEnd(DragEndDetails details) {
    final provider = context.read<WindowActivity>();
    origin = null;
    provider.focusNode.requestFocus();
  }

  void toggleFullScreen() {
    final provider = context.read<WindowActivity>();
    if(!provider.resizeable.value) return;
    provider.isFullScreen.value ^= true;
  }

  void minimizedWindow() {
    final provider = context.read<WindowActivity>();
    provider.isMinimized.value = true;
  }
}


class _MaximizeIcon extends StatelessWidget {
  final double size;

  const _MaximizeIcon({
    super.key,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,

      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(width: 3, strokeAlign: BorderSide.strokeAlignInside, color: Colors.white),
              left: BorderSide(width: 1, strokeAlign: BorderSide.strokeAlignInside, color: Colors.white),
              right: BorderSide(width: 1, strokeAlign: BorderSide.strokeAlignInside, color: Colors.white),
              bottom: BorderSide(width: 1, strokeAlign: BorderSide.strokeAlignInside, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}


class _MaximizedIcon extends StatelessWidget {
  final double size;

  const _MaximizedIcon({
    super.key,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,

      child: FittedBox(
        fit: BoxFit.fill,
        child: SizedBox.square(
          dimension: 16,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Stack(
              children: [
                Positioned(
                  left: 3,
                  top: 0,
                  width: 9,
                  height: 9,
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 2, strokeAlign: BorderSide.strokeAlignInside, color: Colors.white),
                        left: BorderSide(width: 1, strokeAlign: BorderSide.strokeAlignInside, color: Colors.white),
                        right: BorderSide(width: 1, strokeAlign: BorderSide.strokeAlignInside, color: Colors.white),
                        bottom: BorderSide(width: 1, strokeAlign: BorderSide.strokeAlignInside, color: Colors.white),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  left: 0,
                  top: 3,
                  width: 9,
                  height: 9,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(19, 109, 255, 1),
                      border: Border(
                        top: BorderSide(width: 2, strokeAlign: BorderSide.strokeAlignInside, color: Colors.white),
                        left: BorderSide(width: 1, strokeAlign: BorderSide.strokeAlignInside, color: Colors.white),
                        right: BorderSide(width: 1, strokeAlign: BorderSide.strokeAlignInside, color: Colors.white),
                        bottom: BorderSide(width: 1, strokeAlign: BorderSide.strokeAlignInside, color: Colors.white),
                      ),
                    ),
                  ),
                ),

                const Positioned(
                  top: 2,
                  left: 0,
                  height: 1,
                  width: 9,
                  child: ColoredBox(color: Color.fromRGBO(19, 109, 255, 1)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
