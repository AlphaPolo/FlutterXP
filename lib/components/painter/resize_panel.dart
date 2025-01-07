import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:flutter_drawing_board/path_steps.dart';
import 'package:flutter_xp/components/painter/painter_provider.dart';
import 'package:flutter_xp/components/painter/tools/painter_paint_content.dart';
import 'package:flutter_xp/util/my_print.dart';
import 'package:provider/provider.dart';

import '../window_widget.dart';

class ResizePanel extends StatefulWidget {
  const ResizePanel({super.key});

  @override
  State<ResizePanel> createState() => _ResizePanelState();
}

class _ResizePanelState extends State<ResizePanel> {

  late final PainterDrawingController controller = context.read<PainterDrawingController>();

  final ValueNotifier<Size> size = ValueNotifier(const Size(480, 300));
  final ValueNotifier<Size?> scalingSize = ValueNotifier(null);

  (Offset, Size)? origin;

  GlobalKey panelKey = GlobalKey();

  // @override
  // void dispose() {
  //   controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ..._createEdgesControls(),
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 4, 24, 24),
          child: ValueListenableBuilder(
            valueListenable: size,
            builder: (context, size, board) {
              return Selector<PainterProvider, PaintContent>(
                selector: (context, provider) => provider.currentContentType,
                builder: (context, contentType, child) {



                  if(contentType case CustomPainterContent content) {
                    return Listener(
                      behavior: HitTestBehavior.translucent,
                      onPointerDown: (details) {
                        if(details.buttons != 1 && details.buttons != 2) return;
                        content.onPaintDown(controller, details.buttons == 1, details.localPosition);
                        myPrint('intercept onPanDown');
                      },
                      onPointerMove: (details) {
                        content.onPaintUpdate(details.localPosition);
                        myPrint('intercept onPanUpdate');
                      },
                      onPointerUp: (details) {
                        content.onPaintUp(details.localPosition);
                        myPrint('intercept onPanEnd');
                      },
                      onPointerCancel: (_) {
                        myPrint('intercept cancel');
                      },
                      child: IgnorePointer(
                        ignoring: true,
                        child: child,
                      ),
                    );
                  }
                  else {
                    return GestureDetector(
                      child: IgnorePointer(
                        ignoring: false,
                        child: child,
                      ),
                    );
                  }

                },
                child: Container(
                  key: panelKey,
                  width: size.width,
                  height: size.height,
                  color: Colors.white,
                  child: DrawingBoard(
                    showDefaultActions: false,
                    showDefaultTools: false,
                    boardPanEnabled: false,
                    boardScaleEnabled: false,
                    controller: controller,
                    background: SizedBox.fromSize(size: size),
                  ),
                ),
              );
            },
          ),
        ),
        ValueListenableBuilder(
          valueListenable: scalingSize,
          builder: (context, scalingSize, _) {
            if (scalingSize == null) return const SizedBox.shrink();

            return IgnorePointer(
              child: Padding(
                padding: const EdgeInsets.only(top: 4, left: 4),
                child: DottedBorder(
                  color: Colors.grey[900]!,
                  strokeWidth: 0.5,
                  child: SizedBox(
                    width: max(0, scalingSize.width - 2),
                    height: max(0, scalingSize.height - 2),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  List<Widget> _createEdgesControls() {
    return [
      /// 右側
      ValueListenableBuilder(
        valueListenable: size,
        builder: (BuildContext context, Size value, Widget? child) {
          const tapAreaSize = Size(24, 24);

          final centerRight = value.centerRight(Offset.zero).translate(4, 4);
          // .translate(tapAreaSize.width/2, 0);

          return Positioned.fromRect(
            rect: Rect.fromCenter(
              center: centerRight,
              width: tapAreaSize.width,
              height: tapAreaSize.height,
            ),
            child: child!,
          );
        },
        child: MouseRegion(
          hitTestBehavior: HitTestBehavior.translucent,
          cursor: SystemMouseCursors.resizeRight,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanStart: (detail) =>
                resizePanDown(detail, ResizeDirection.right),
            onPanUpdate: (detail) =>
                resizePanUpdate(detail, ResizeDirection.right),
            onPanEnd: (detail) => resizePanEnd(detail, ResizeDirection.right),
            child: Center(
              child: FractionalTranslation(
                translation: const Offset(0.5, 0),
                child: Container(
                  height: 3,
                  width: 3,
                  color: Colors.indigo,
                ),
              ),
            ),
          ),
        ),
      ),

      /// 下側
      ValueListenableBuilder(
        valueListenable: size,
        builder: (BuildContext context, Size value, Widget? child) {
          const tapAreaSize = Size(24, 24);

          final bottomCenter = value.bottomCenter(Offset.zero).translate(4, 4);

          return Positioned.fromRect(
            rect: Rect.fromCenter(
              center: bottomCenter,
              width: tapAreaSize.width,
              height: tapAreaSize.height,
            ),
            child: child!,
          );
        },
        child: MouseRegion(
          hitTestBehavior: HitTestBehavior.translucent,
          cursor: SystemMouseCursors.resizeDown,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanStart: (detail) =>
                resizePanDown(detail, ResizeDirection.bottom),
            onPanUpdate: (detail) =>
                resizePanUpdate(detail, ResizeDirection.bottom),
            onPanEnd: (detail) => resizePanEnd(detail, ResizeDirection.bottom),
            child: Center(
              child: FractionalTranslation(
                translation: const Offset(0, 0.5),
                child: Container(
                  height: 3,
                  width: 3,
                  color: Colors.indigo,
                ),
              ),
            ),
          ),
        ),
      ),

      /// 右下側
      ValueListenableBuilder(
        valueListenable: size,
        builder: (BuildContext context, Size value, Widget? child) {
          const tapAreaSize = Size(24, 24);

          final bottomCenter = value.bottomRight(Offset.zero).translate(4, 4);

          return Positioned.fromRect(
            rect: Rect.fromCenter(
              center: bottomCenter,
              width: tapAreaSize.width,
              height: tapAreaSize.height,
            ),
            child: child!,
          );
        },
        child: MouseRegion(
          hitTestBehavior: HitTestBehavior.translucent,
          cursor: SystemMouseCursors.resizeDownRight,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanStart: (detail) =>
                resizePanDown(detail, ResizeDirection.bottomRight),
            onPanUpdate: (detail) =>
                resizePanUpdate(detail, ResizeDirection.bottomRight),
            onPanEnd: (detail) => resizePanEnd(detail, ResizeDirection.bottomRight),
            child: Center(
              child: FractionalTranslation(
                translation: const Offset(0.5, 0.5),
                child: Container(
                  height: 3,
                  width: 3,
                  color: Colors.indigo,
                ),
              ),
            ),
          ),
        ),
      ),
    ];
  }

  void resizePanDown(DragStartDetails detail, ResizeDirection direction) {
    // activity.focusNode.requestFocus();

    // if(isFullScreen) return;

    final size = this.size.value;
    origin = (detail.globalPosition, size);
    scalingSize.value = size;
  }

  void resizePanUpdate(DragUpdateDetails detail, ResizeDirection direction) {
    final origin = this.origin;
    final previousSize = scalingSize.value;
    if (origin == null) return;
    if (previousSize == null) return;
    final Size originSize = origin.$2;


    final renderBox = panelKey.currentContext?.findRenderObject() as RenderBox?;
    final topLeft = renderBox!.localToGlobal(Offset.zero);
    final globalOffset = detail.globalPosition - topLeft;

    Size newSize = switch (direction) {
      ResizeDirection.left => Size.zero,
      ResizeDirection.top => Size.zero,
      ResizeDirection.right =>
          Size(globalOffset.dx, originSize.height),
      ResizeDirection.bottom =>
          Size(originSize.width, globalOffset.dy),
      ResizeDirection.topLeft => Size.zero,
      ResizeDirection.topRight => Size.zero,
      ResizeDirection.bottomRight =>
          Size(globalOffset.dx, globalOffset.dy),
      ResizeDirection.bottomLeft => Size.zero,
    };

    // final offset = detail.globalPosition - origin.$1;
    // Size newSize = switch (direction) {
    //   ResizeDirection.left => Size.zero,
    //   ResizeDirection.top => Size.zero,
    //   ResizeDirection.right =>
    //     Size(originSize.width + offset.dx, originSize.height),
    //   ResizeDirection.bottom =>
    //     Size(originSize.width, originSize.height + offset.dy),
    //   ResizeDirection.topLeft => Size.zero,
    //   ResizeDirection.topRight => Size.zero,
    //   ResizeDirection.bottomRight =>
    //     Size(originSize.width + offset.dx, originSize.height + offset.dy),
    //   ResizeDirection.bottomLeft => Size.zero,
    // };

    newSize = Size(
      max(newSize.width, 1),
      max(newSize.height, 1),
    );

    scalingSize.value = Size(newSize.width, newSize.height);
  }

  void resizePanEnd(DragEndDetails detail, ResizeDirection direction) {
    final newSize = scalingSize.value;

    if (newSize != null) {
      // Step 1: Define the new canvas area
      final oldRect = Offset.zero & size.value;
      final newRect = Offset.zero & newSize; // This is the new canvas size

      eraseOutside(oldRect);
      // Update the size and apply the erasePath
      size.value = newSize; // Update the size of the canvas to the new size

      eraseOutside(newRect);
      controller.setBoardSize(
          newSize); // Update the board size to the new canvas size
    }

    origin = null;
    scalingSize.value = null;
  }

  void eraseOutside(Rect rect) {
    // Define a very large canvas to ensure we can erase everything outside the new canvas
    final biggest = (Offset.zero & const Size.square(10000))
        .expandToInclude(rect); // A very large area for everything

    final erasePath = Path.combine(
      PathOperation.difference,
      Path()..addRect(biggest),
      Path()..addRect(rect),
    );
    controller.addContent(Eraser.data(
        drawPath: DrawPath(path: erasePath),
        paint: Paint())); // Erase the area outside size
  }

}

