import 'dart:ui';

import 'package:flutter_drawing_board/paint_extension.dart';
import 'package:flutter_xp/components/painter/tools/painter_paint_content.dart';
import 'package:flutter_xp/util/maybe.dart';

import 'painter_tool_model.dart';

class PainterRRectangle extends PainterPaintContent {
  PainterRRectangle();

  PainterRRectangle.data({
    required this.startPoint,
    required this.endPoint,
    required Paint paint,
    required Paint? secondaryPaint,
  }) : super.paint(paint);

  factory PainterRRectangle.fromJson(Map<String, dynamic> data) {
    return PainterRRectangle.data(
      startPoint: jsonToOffset(data['startPoint'] as Map<String, dynamic>),
      endPoint: jsonToOffset(data['endPoint'] as Map<String, dynamic>),
      paint: jsonToPaint(data['paint'] as Map<String, dynamic>),
      secondaryPaint: Maybe.ofNullable(data['secondaryPaint'] as Map<String, dynamic>?)
          .map((paint) => jsonToPaint(paint)).value,
    );
  }

  Paint? secondaryPaint;

  /// 起始点
  Offset? startPoint;

  /// 结束点
  Offset? endPoint;

  @override
  void startDraw(Offset startPoint) => this.startPoint = startPoint;

  @override
  void drawing(Offset nowPoint) => endPoint = nowPoint;

  @override
  void draw(Canvas canvas, Size size, bool deeper) {

    final startPoint = this.startPoint;
    final endPoint = this.endPoint;
    final secondaryPaint = this.secondaryPaint;

    if (startPoint == null || endPoint == null) {
      return;
    }

    final rrect = RRect.fromRectAndRadius(Rect.fromPoints(startPoint, endPoint), const Radius.circular(8));

    if(secondaryPaint != null) {
      canvas.drawRRect(rrect, secondaryPaint);
    }

    canvas.drawRRect(rrect, paint);
  }

  @override
  PainterRRectangle copy() => PainterRRectangle();

  @override
  Map<String, dynamic> toContentJson() {
    return <String, dynamic>{
      'startPoint': startPoint?.toJson(),
      'endPoint': endPoint?.toJson(),
      'paint': paint.toJson(),
      'secondaryPaint': secondaryPaint?.toJson(),
    };
  }

  @override
  void onToolsModelParameterSetting(
      bool isPrimary,
      PainterDrawingController controller,
      ToolModelParameter toolParameter,
      ) {
    super.onToolsModelParameterSetting(isPrimary, controller, toolParameter);
    switch (toolParameter.rectangleParameter) {
      case null:
        break;
      case RectangleParameter.stroke:
        paint.style = PaintingStyle.stroke;
      case RectangleParameter.strokeAndFill:
        paint.style = PaintingStyle.stroke;
        secondaryPaint = Paint()
          ..style = PaintingStyle.fill
          ..color = isPrimary ? controller.getSecondaryColor : controller.getPrimaryColor;

      case RectangleParameter.fill:
        paint.style = PaintingStyle.fill;
    }

    paint.isAntiAlias = false;
    secondaryPaint?.isAntiAlias = false;
  }
}
