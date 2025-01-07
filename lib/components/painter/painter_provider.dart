import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:flutter_xp/components/painter/tools/painter_oval.dart';
import 'package:flutter_xp/components/painter/tools/painter_paint_content.dart';
import 'package:flutter_xp/components/painter/tools/painter_rectangle.dart';
import 'package:flutter_xp/components/painter/tools/painter_rrectangle.dart';
import 'package:flutter_xp/components/painter/tools/painter_straw_picker.dart';
import 'package:flutter_xp/widget/grid/auto_grid.dart';
import 'package:provider/provider.dart';

import '../../util/my_print.dart';
import 'tools/painter_simple_line.dart';
import 'tools/painter_straight_line.dart';
import 'tools/painter_tool_model.dart';

Widget rectangleParameterIconBuilder(RectangleParameter parameter, bool isSelected) {
  return Container(
    color: isSelected ? const Color(0xFF00007F) : null,
    alignment: Alignment.center,
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        border: parameter != RectangleParameter.fill ? Border.fromBorderSide(
          BorderSide(
            width: 1,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ) : null,
        color: parameter != RectangleParameter.stroke ? const Color(0xFF7F7F7F) : null,
      ),
      width: double.infinity,
      height: double.infinity,
    ),
  );
}

Widget brushParameterIconBuilder() {

  Widget buildCircle(double size) {
    return Center(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ),
        width: size,
        height: size,
      ),
    );
  }

  Widget buildSquare(double size) {
    return Center(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        width: size,
        height: size,
      ),
    );
  }


  return AutoGridView(
    row: 4,
    col: 3,
    children: [
      for(int i=3; i>0; i--)
        buildCircle(i * 2.0),
      for(int i=3; i>0; i--)
        buildSquare(i * 2.5),
      for(int i=3; i>0; i--)
        buildSquare(i * 2.0),
      for(int i=3; i>0; i--)
        buildSquare(i * 2.0),
    ],
  );
}


class PainterProvider extends ChangeNotifier {
  Color primary = Colors.black;
  Color secondary = Colors.white;

  late PaintContent currentContentType;

  double currentSizeScaleFactor = 2.0;

  late final List<PainterToolModel> tools = [
    PainterToolModel(
      type: EmptyContent,
      iconAsset: 'assets/images/painter/print_tools_0.png',
      onTap: (context) {
        myPrint('框選工具');
        setPaintContent(context.read(), EmptyContent, EmptyContent());
      },
    ),
    PainterToolModel(
      type: EmptyContent,
      iconAsset: 'assets/images/painter/print_tools_1.png',
      onTap: (context) {
        myPrint('選擇工具');
        setPaintContent(context.read(), EmptyContent, EmptyContent());
      },
    ),
    PainterToolModel(
      type: Eraser,
      iconAsset: 'assets/images/painter/print_tools_2.png',
      parameters: [
        const ToolModelParameter(strokeWidth: 1),
        const ToolModelParameter(strokeWidth: 2),
        const ToolModelParameter(strokeWidth: 3),
        const ToolModelParameter(strokeWidth: 4),
      ],
      parametersBuilder: (context, parameters, currentParameter) {
        Widget buildItem(ToolModelParameter parameter) {
          final isSelected = parameter == currentParameter;
          final size = ((parameter.strokeWidth ?? 1) - 1) * 2 + 4;
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              final painterDrawingController = context.read<PainterDrawingController>();
              painterDrawingController.setTool(Eraser, parameter);
              painterDrawingController.setStyle(strokeWidth: size);
            },
            child: Container(
              color: isSelected ? const Color(0xFF00007F) : null,
              alignment: Alignment.center,
              child: Container(
                color: isSelected ? Colors.white : Colors.black,
                width: size,
                height: size,
              ),
            ),
          );
        }
        return Column(
          children: parameters.map((parameter) =>
              Expanded(child: buildItem(parameter))
          ).toList(),
        );
      },
      onTap: (context) {
        myPrint('像擦工具');
        final painterDrawingController = context.read<PainterDrawingController>();
        final parameter = painterDrawingController.toolsParameterMap[Eraser];
        final size = ((parameter?.strokeWidth ?? 1) - 1) * 2 + 4;
        painterDrawingController.setStyle(strokeWidth: size);
        setPaintContent(painterDrawingController, Eraser, Eraser());
      },
    ),
    PainterToolModel(
      type: EmptyContent,
      iconAsset: 'assets/images/painter/print_tools_3.png',
      onTap: (context) {
        myPrint('塗色工具');
        setPaintContent(context.read(), EmptyContent, EmptyContent());
      },
    ),
    PainterToolModel(
      type: PainterStrawPicker,
      iconAsset: 'assets/images/painter/print_tools_4.png',
      onTap: (context) {
        myPrint('取色工具');
        setPaintContent(context.read(), PainterStrawPicker, PainterStrawPicker(onColorPick: (isPrimary, color) {
          if(color == null) return;

          if(color == const Color(0x00000000)) {
            color = Colors.white;
          }

          if(isPrimary) {
            setPrimaryColor(context.read(), color);
          }
          else {
            setSecondaryColor(context.read(), color);
          }
          myPrint(color);
        }));
      },
    ),
    PainterToolModel(
      type: EmptyContent,
      iconAsset: 'assets/images/painter/print_tools_5.png',
      onTap: (context) {
        myPrint('放大工具');
        setPaintContent(context.read(), EmptyContent, EmptyContent());
      },
    ),
    PainterToolModel(
      type: PainterSimpleLine,
      iconAsset: 'assets/images/painter/print_tools_6.png',
      parameters: [
        const ToolModelParameter(strokeWidth: 1),
      ],
      onTap: (context) {
        myPrint('鉛筆工具');
        setPaintContent(context.read(), PainterSimpleLine, PainterSimpleLine());
      },
    ),
    PainterToolModel(
      type: SmoothLine,
      iconAsset: 'assets/images/painter/print_tools_7.png',
      parameters: [
        const ToolModelParameter(strokeWidth: 1),
      ],
      // parametersBuilder: (context, parameters, parameter) {
      //   return brushParameterIconBuilder();
      // },
      onTap: (context) {
        myPrint('筆刷工具');
        setPaintContent(context.read(), SmoothLine, SmoothLine());

      },
    ),
    PainterToolModel(
      type: EmptyContent,
      iconAsset: 'assets/images/painter/print_tools_8.png',
      onTap: (context) {
        myPrint('噴漆工具');
        setPaintContent(context.read(), EmptyContent, EmptyContent());
      },
    ),
    PainterToolModel(
      type: EmptyContent,
      iconAsset: 'assets/images/painter/print_tools_9.png',
      onTap: (context) {
        myPrint('文字工具');
        setPaintContent(context.read(), EmptyContent, EmptyContent());
      },
    ),
    PainterToolModel(
      type: PainterStraightLine,
      iconAsset: 'assets/images/painter/print_tools_10.png',
      parameters: [
        const ToolModelParameter(strokeWidth: 1),
        const ToolModelParameter(strokeWidth: 2),
        const ToolModelParameter(strokeWidth: 3),
        const ToolModelParameter(strokeWidth: 4),
        const ToolModelParameter(strokeWidth: 5),
      ],
      parametersBuilder: (context, parameters, currentParameter) {
        Widget buildItem(ToolModelParameter parameter) {
          final isSelected = parameter == currentParameter;
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              context.read<PainterDrawingController>().setTool(PainterStraightLine, parameter);
            },
            child: Container(
              color: isSelected ? const Color(0xFF00007F) : null,
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                color: isSelected ? Colors.white : Colors.black,
                width: double.infinity,
                height: parameter.strokeWidth,
              ),
            ),
          );
        }
        return Column(
          children: parameters.map((parameter) =>
            Expanded(child: buildItem(parameter))
          ).toList(),
        );
      },
      onTap: (context) {
        myPrint('直線工具');
        setPaintContent(context.read(), PainterStraightLine, PainterStraightLine());

      },
    ),
    PainterToolModel(
      type: EmptyContent,
      iconAsset: 'assets/images/painter/print_tools_11.png',
      onTap: (context) {
        myPrint('曲線工具');
        setPaintContent(context.read(), EmptyContent, EmptyContent());
      },
    ),
    PainterToolModel(
      type: PainterRectangle,
      iconAsset: 'assets/images/painter/print_tools_12.png',
      parameters: [
        const ToolModelParameter(strokeWidth: 1, rectangleParameter: RectangleParameter.stroke),
        const ToolModelParameter(strokeWidth: 1, rectangleParameter: RectangleParameter.strokeAndFill),
        const ToolModelParameter(strokeWidth: 1, rectangleParameter: RectangleParameter.fill),
      ],
      parametersBuilder: (context, parameters, currentParameter) {
        Widget buildItem(ToolModelParameter parameter) {
          final isSelected = currentParameter == parameter;
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              context.read<PainterDrawingController>().setTool(PainterRectangle, parameter);
            },
            child: rectangleParameterIconBuilder(parameter.rectangleParameter!, isSelected),
          );
        }

        return Column(
          children: parameters
              .map((parameter) => Expanded(child: buildItem(parameter)))
              .toList(),
        );
      },
      onTap: (context) {
        myPrint('矩形工具');
        setPaintContent(context.read(), PainterRectangle, PainterRectangle());
      },
    ),
    PainterToolModel(
      type: EmptyContent,
      iconAsset: 'assets/images/painter/print_tools_13.png',
      onTap: (context) {
        myPrint('多邊形工具');
        setPaintContent(context.read(), EmptyContent, EmptyContent());
      },
    ),
    PainterToolModel(
      type: PainterOval,
      iconAsset: 'assets/images/painter/print_tools_14.png',
      parameters: [
        const ToolModelParameter(strokeWidth: 1, rectangleParameter: RectangleParameter.stroke),
        const ToolModelParameter(strokeWidth: 1, rectangleParameter: RectangleParameter.strokeAndFill),
        const ToolModelParameter(strokeWidth: 1, rectangleParameter: RectangleParameter.fill),
      ],
      parametersBuilder: (context, parameters, currentParameter) {
        Widget buildItem(ToolModelParameter parameter) {
          final isSelected = currentParameter == parameter;
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              context.read<PainterDrawingController>().setTool(PainterOval, parameter);
            },
            child: rectangleParameterIconBuilder(parameter.rectangleParameter!, isSelected),
          );
        }

        return Column(
          children: parameters
              .map((parameter) => Expanded(child: buildItem(parameter)))
              .toList(),
        );
      },
      onTap: (context) {
        myPrint('橢圓形工具');
        setPaintContent(context.read(), PainterOval, PainterOval());
      },
    ),
    PainterToolModel(
      type: PainterRRectangle,
      iconAsset: 'assets/images/painter/print_tools_15.png',
      parameters: [
        const ToolModelParameter(
            strokeWidth: 1, rectangleParameter: RectangleParameter.stroke),
        const ToolModelParameter(
            strokeWidth: 1,
            rectangleParameter: RectangleParameter.strokeAndFill),
        const ToolModelParameter(
            strokeWidth: 1, rectangleParameter: RectangleParameter.fill),
      ],
      parametersBuilder: (context, parameters, currentParameter) {
        Widget buildItem(ToolModelParameter parameter) {
          final isSelected = currentParameter == parameter;
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              context
                  .read<PainterDrawingController>()
                  .setTool(PainterRRectangle, parameter);
            },
            child: rectangleParameterIconBuilder(
                parameter.rectangleParameter!, isSelected),
          );
        }

        return Column(
          children: parameters
              .map((parameter) => Expanded(child: buildItem(parameter)))
              .toList(),
        );
      },
      onTap: (context) {
        myPrint('圓角矩形工具');
        setPaintContent(context.read(), PainterRRectangle, PainterRRectangle());
      },
    ),
  ];

  final List<PainterColorModel> paintColors = const [
    PainterColorModel(
      paintColor: Color.fromRGBO(0, 0, 0, 1),
    ),
    PainterColorModel(
      paintColor: Color.fromRGBO(255, 255, 255, 1),
    ),
    PainterColorModel(
      paintColor: Color.fromRGBO(128, 128, 128, 1),
    ),
    PainterColorModel(
      paintColor: Color.fromRGBO(192, 192, 192, 1),
    ),
    PainterColorModel(
      paintColor: Color.fromRGBO(128, 0, 0, 1),
    ),
    PainterColorModel(
      paintColor: Color.fromRGBO(255, 0, 0, 1),
    ),
    PainterColorModel(
      paintColor: Color.fromRGBO(128, 128, 0, 1),
    ),
    PainterColorModel(
      paintColor: Color.fromRGBO(255, 255, 0, 1),
    ),
    PainterColorModel(
      paintColor: Color.fromRGBO(0, 128, 0, 1),
    ),
    PainterColorModel(
      paintColor: Color.fromRGBO(0, 255, 0, 1),
    ),
    PainterColorModel(
      paintColor: Color.fromRGBO(0, 128, 128, 1),
    ),
    PainterColorModel(
      paintColor: Color.fromRGBO(0, 255, 255, 1),
    ),
    PainterColorModel(
      paintColor: Color.fromRGBO(0, 0, 128, 1),
    ),
    PainterColorModel(
      paintColor: Color.fromRGBO(0, 0, 255, 1),
    ),
    PainterColorModel(
      paintColor: Color.fromRGBO(128, 0, 128, 1),
    ),
    PainterColorModel(
      paintColor: Color.fromRGBO(255, 0, 255, 1),
    ),
    PainterColorModel(
      paintColor: Color.fromRGBO(128, 128, 64, 1),
    ),
    PainterColorModel(
      paintColor: Color.fromRGBO(255, 255, 128, 1),
    ),
    PainterColorModel(
      paintColor: Color.fromRGBO(0, 64, 64, 1),
    ),
    PainterColorModel(
      paintColor: Color.fromRGBO(0, 255, 128, 1),
    ),
    PainterColorModel(
      paintColor: Color.fromRGBO(0, 128, 255, 1),
    ),
    PainterColorModel(
      paintColor: Color.fromRGBO(128, 255, 255, 1),
    ),
    PainterColorModel(
      paintColor: Color.fromRGBO(0, 64, 128, 1),
    ),
    PainterColorModel(
      paintColor: Color.fromRGBO(128, 128, 255, 1),
    ),
    PainterColorModel(
      paintColor: Color.fromRGBO(64, 0, 255, 1),
    ),
    PainterColorModel(
      paintColor: Color.fromRGBO(255, 0, 128, 1),
    ),
    PainterColorModel(
      paintColor: Color.fromRGBO(128, 64, 0, 1),
    ),
    PainterColorModel(
      paintColor: Color.fromRGBO(255, 128, 64, 1),
    ),
  ];

  PainterProvider();

  void setPaintContent(PainterDrawingController controller, Type type, PaintContent content) {
    controller.setPaintContent(content);
    currentContentType = content;
    notifyListeners();
  }

  // void _applyToolParameter(PainterDrawingController controller, Type type, ToolModelParameter parameter) {
  //   toolsParameterMap[type] = parameter;
  //   controller.setToolsParameter();
  // }

  void setPrimaryColor(PainterDrawingController controller, Color color) {
    primary = color;
    _setControllerColor(controller);
    notifyListeners();
  }

  void _setControllerColor(PainterDrawingController controller) {
    controller.setStyle(
      primaryColor: primary,
      secondaryColor: secondary,
    );
  }

  void setSecondaryColor(PainterDrawingController controller, Color color) {
    secondary = color;
    _setControllerColor(controller);
    notifyListeners();
  }

  void swapColor(PainterDrawingController controller) {
    final temp = primary;
    primary = secondary;
    secondary = temp;
    _setControllerColor(controller);
    notifyListeners();
  }


}


class PainterColorModel {
  final Color paintColor;

  const PainterColorModel({
    required this.paintColor,
  });
}