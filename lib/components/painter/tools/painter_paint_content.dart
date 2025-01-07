import 'dart:ui';

import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:flutter_drawing_board/paint_extension.dart';
import 'package:flutter_xp/components/painter/tools/painter_tool_model.dart';

abstract class PainterPaintContent extends PaintContent {

  PainterPaintContent();

  PainterPaintContent.paint(Paint paint): super.paint(paint);

  @override
  void setIsPrimary(bool isPrimary, DrawingController controller) {
    super.setIsPrimary(isPrimary, controller);
    if(controller case PainterDrawingController(:final toolsParameterMap)) {
      if(toolsParameterMap[runtimeType] case final toolParameter?) {
        onToolsModelParameterSetting(isPrimary, controller, toolParameter);
      }
    }
  }

  void onToolsModelParameterSetting(
    bool isPrimary,
    PainterDrawingController controller,
    ToolModelParameter toolParameter,
  ) {
    paint = paint.copyWith(
      strokeWidth: toolParameter.strokeWidth,
    );
  }

}

abstract class CustomPainterContent extends PaintContent {

  @override
  PaintContent copy() {throw UnimplementedError();}

  @override
  void startDraw(Offset startPoint) {}

  @override
  void drawing(Offset nowPoint) {}

  @override
  void draw(Canvas canvas, Size size, bool deeper) {}

  @override
  Map<String, dynamic> toContentJson() {
    return {};
  }



  void onPaintDown(PainterDrawingController controller, bool isPrimary, Offset offset);
  void onPaintUpdate(Offset offset);
  void onPaintUp(Offset offset);
}

class PainterDrawingController extends DrawingController {
  Map<Type, ToolModelParameter> toolsParameterMap;
  bool isShiftPressed = false;

  PainterDrawingController({
    super.config,
    super.content,
    required this.toolsParameterMap,
  });

  void setTool(Type type, ToolModelParameter parameter) {
    toolsParameterMap = {
      ...toolsParameterMap,
      type: parameter,
    };
    notifyListeners();
  }

  void setIsShiftPressed(bool value) {
    isShiftPressed = value;
    notifyListeners();
  }

}