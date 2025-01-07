import 'dart:ui';

import 'package:flutter_drawing_board/paint_extension.dart';
import 'package:flutter_drawing_board/path_steps.dart';
import 'package:flutter_xp/components/painter/tools/painter_paint_content.dart';

class PainterSimpleLine extends PainterPaintContent {
  PainterSimpleLine();

  PainterSimpleLine.data({
    required this.path,
    required Paint paint,
  }) : super.paint(paint);

  factory PainterSimpleLine.fromJson(Map<String, dynamic> data) {
    return PainterSimpleLine.data(
      path: DrawPath.fromJson(data['path'] as Map<String, dynamic>),
      paint: jsonToPaint(data['paint'] as Map<String, dynamic>),
    );
  }

  /// 绘制路径
  DrawPath path = DrawPath();

  @override
  void startDraw(Offset startPoint) =>
      path.moveTo(startPoint.dx, startPoint.dy);

  @override
  void drawing(Offset nowPoint) => path.lineTo(nowPoint.dx, nowPoint.dy);

  @override
  void draw(Canvas canvas, Size size, bool deeper) =>
      canvas.drawPath(path.path, paint);

  @override
  PainterSimpleLine copy() => PainterSimpleLine();

  @override
  Map<String, dynamic> toContentJson() {
    return <String, dynamic>{
      'path': path.toJson(),
      'paint': paint.toJson(),
    };
  }
}
