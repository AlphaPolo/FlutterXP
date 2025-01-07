import 'package:flutter/material.dart';

class PainterToolModel {
  final String iconAsset;
  final Type type;
  final void Function(BuildContext) onTap;

  final Widget Function(
    BuildContext context,
    List<ToolModelParameter> parameters,
    ToolModelParameter currentParameter,
  )? parametersBuilder;

  final List<ToolModelParameter>? parameters;

  const PainterToolModel({
    required this.type,
    required this.iconAsset,
    required this.onTap,
    this.parameters,
    this.parametersBuilder,
  });
}

class ToolModelParameter {
  final double? strokeWidth;
  final RectangleParameter? rectangleParameter;

  const ToolModelParameter({
    this.strokeWidth,
    this.rectangleParameter,
  });
}


enum RectangleParameter {
  stroke,
  strokeAndFill,
  fill,
}