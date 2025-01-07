import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:flutter_xp/components/painter/painter_constant.dart';
import 'package:flutter_xp/components/painter/painter_provider.dart';
import 'package:flutter_xp/components/painter/resize_panel.dart';
import 'package:flutter_xp/components/painter/tools/painter_paint_content.dart';
import 'package:flutter_xp/components/painter/tools/painter_simple_line.dart';
import 'package:provider/provider.dart';

import 'tools/painter_tool_model.dart';

class PainterScreen extends StatefulWidget {
  const PainterScreen({super.key});

  @override
  State<PainterScreen> createState() => _PainterScreenState();
}

class _PainterScreenState extends State<PainterScreen> {
  final PainterProvider provider = PainterProvider();

  @override
  void dispose() {
    provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: provider),
        ChangeNotifierProvider(
          create: (context) {
            final records = provider.tools
                .map((tool) => (tool.type, tool.parameters?.first))
                .whereType<(Type, ToolModelParameter)>();
            final toolsParameterMap = {
              /// 不應該要有parameters為[]的情況
              for (final (type, parameter) in records) type: parameter,
            };

            final defaultTool = PainterSimpleLine();

            provider.currentContentType = defaultTool;

            return PainterDrawingController(
              config: DrawConfig.def(
                contentType: defaultTool.runtimeType,
                primaryColor: provider.primary,
                strokeWidth: 1,
              ),
              content: defaultTool,
              toolsParameterMap: toolsParameterMap,
            );
          },
          lazy: false,
        ),
      ],
      child: Container(
        color: const Color(0xFFC0C0C0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                // color: Colors.red,
                child: Row(
                  children: [
                    buildLeftTools(),
                    buildPaintBoard(),
                  ],
                ),
              ),
            ),
            buildBottomTools(),
            Container(
              color: const Color.fromRGBO(197, 197, 197, 1.0),
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPaintBoard() {
    return Expanded(
      child: Container(
        color: Colors.grey[600],
        padding: const EdgeInsets.all(1),
        child: const SizedBox.expand(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ResizePanel(),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLeftTools() {
    return Builder(builder: (context) {
      final controller = context.read<PainterDrawingController>();

      return Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(197, 197, 197, 1.0),
          border: Border(right: BorderSide(width: 1, color: Colors.grey)),
        ),
        width: 60,
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            /// 讓工具列不會在拖拉大小時顯示OVERFLOW的錯誤
            Flexible(
              child: Container(
                color: const Color.fromARGB(120, 7, 2, 2),
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  // Create a grid with 2 columns. If you change the scrollDirection to
                  // horizontal, this produces 2 rows.
                  crossAxisCount: 2,
                  children: provider.tools.map(
                    (e) {
                      return IgnorePointer(
                        ignoring: e.type == EmptyContent,
                        child: InkWell(
                          onTap: () => e.onTap(context),
                          child: ValueListenableBuilder(
                            valueListenable: controller.drawConfig,
                            builder: (context, config, icon) {
                              // if(e.type == PainterSimpleLine) {
                              //   myPrint('PainterSimpleLine: ${config.contentType}');
                              // }

                              return Container(
                                decoration: switch(config.contentType) {
                                  // EmptyContent => PainterConstant.defaultDecoration,
                                  final Type type when type == e.type && type != EmptyContent => PainterConstant.innerBackgroundDecoration,
                                  _ when e.type == EmptyContent => PainterConstant.defaultDecoration.copyWith(color: Color.fromRGBO(247, 139, 139, 1)),
                                  _ => PainterConstant.defaultDecoration,
                                },
                                child: icon,
                              );
                            },
                            child: Image.asset(e.iconAsset),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              decoration: PainterConstant.innerDecoration,
              width: 40,
              height: 64,
              child: ValueListenableBuilder(
                valueListenable: controller.drawConfig,
                builder: (BuildContext context, DrawConfig value, Widget? child) {

                  final selectedTool = provider.tools.firstWhereOrNull((tool) => tool.type == value.contentType);
                  final parameters = selectedTool?.parameters;
                  final currentParameter = context.select<PainterDrawingController, ToolModelParameter?>((controller) => controller.toolsParameterMap[selectedTool?.type]);
                  final builder = selectedTool?.parametersBuilder;

                  if(parameters == null || currentParameter == null || builder == null) {
                    return const SizedBox.shrink();
                  }

                  return builder.call(context, parameters, currentParameter);
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget buildBottomTools() {
    return Builder(
      builder: (context) {

        return Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(197, 197, 197, 1.0),
            border: Border(top: BorderSide(color: Colors.white, width: 1)),
          ),
          height: 50,
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                decoration: PainterConstant.innerBackgroundDecoration,
                height: 30,
                width: 30,
                child: InkWell(
                  onTap: () {
                    provider.swapColor(context.read<PainterDrawingController>());
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        right: 4,
                        bottom: 4,
                        width: 14,
                        height: 14,
                        child: Selector<PainterProvider, Color>(
                          selector: (context, provider) => provider.secondary,
                          builder: (context, color, _) {
                            return Container(
                              decoration: PainterConstant.defaultDecoration,
                              padding: const EdgeInsets.all(0.45),
                              child: Container(
                                  color: color,
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        left: 4,
                        top: 4,
                        width: 14,
                        height: 14,
                        child: Selector<PainterProvider, Color>(
                          selector: (context, provider) => provider.primary,
                          builder: (context, color, _) {
                            return Container(
                              decoration: PainterConstant.defaultDecoration,
                              padding: const EdgeInsets.all(0.45),
                              child: Container(
                                  color: color,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Flexible(
                child: SizedBox(
                  height: 30,
                  child: GridView.count(
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                    crossAxisCount: 2,
                    scrollDirection: Axis.horizontal,
                    children: provider.paintColors.map(
                      (e) {
                        return InkWell(
                          onTap: () {
                            provider.setPrimaryColor(context.read(), e.paintColor);
                            // e.onTap(context);
                          },
                          onSecondaryTap: () {
                            provider.setSecondaryColor(context.read(), e.paintColor);
                          },
                          child: Container(
                            decoration:
                                PainterConstant.innerDecoration.copyWith(
                              color: Colors.black,
                            ),
                            padding: const EdgeInsets.only(left: 0.45, top: 0.45),
                            child: Container(color: e.paintColor),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
