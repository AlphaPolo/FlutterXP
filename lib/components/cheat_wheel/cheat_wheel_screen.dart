import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_xp/model/activity/window_activity.dart';
import 'package:flutter_xp/util/my_print.dart';
import 'package:provider/provider.dart';

import '../../widget/chip/chips_input.dart';

class CheatWheelScreen extends StatefulWidget {
  const CheatWheelScreen({super.key});

  @override
  State<CheatWheelScreen> createState() => _CheatWheelScreenState();
}

class _CheatWheelScreenState extends State<CheatWheelScreen> {
  final Random random = Random();
  final CheatWheelProvider provider = CheatWheelProvider();
  final TextEditingController itemInputController = TextEditingController();

  bool isRotating = false;
  double angle = 0.0;
  WheelItem? item;


  @override
  void dispose() {
    itemInputController.dispose();
    provider.dispose();
    super.dispose();
  }


  (WheelItem?, double) calculateRotation(List<(WheelItem, double)> weights, [Random? random]) {
    random ??= Random();
    final totalWeight = weights.map((e) => e.$2).sum;
    final length = weights.length;

    final randomNumber = random.nextDouble() * totalWeight;
    final double sweepAngle = 2 * pi / length;

    myPrint('roll: $randomNumber, total: $totalWeight');
    double currentWeight = 0;

    for(int i=0; i<length; i++) {
      final (item, weight) = weights[i];
      currentWeight += weight;
      if (randomNumber < currentWeight) {
        final startAngle = sweepAngle * i;
        final randomAngle = random.nextDouble() * sweepAngle;
        return (item, startAngle + randomAngle);
      }
    }

    // 這行不應該被執行到，但為了完整性添加它
    return (null, 0);
  }


  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Scaffold(
        body: IgnorePointer(
          ignoring: isRotating,
          child: ChangeNotifierProvider.value(
            value: provider,
            builder: (context, _) {
              final list = <Widget>[
                InkWell(
                  onTap: () => onSpinStart(context),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: buildWheel(),
                  ),
                ),
                // ConstrainedBox(
                //   constraints: BoxConstraints(
                //     minHeight: 0,
                //     minWidth: 0,
                //     maxHeight: 48,
                //     maxWidth: 48,
                //   ),
                //   child: const SizedBox.square(dimension: 48),
                // ),
                Container(
                  constraints: const BoxConstraints(
                    minWidth: 0,
                    maxWidth: 400,
                  ),
                  alignment: Alignment.center,
                  // width: 400,
                  child: buildInputArea(),
                ),
              ];


              return Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black87,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Wrap(
                      spacing: 48,
                      runSpacing: 48,
                      runAlignment: WrapAlignment.center,
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: list,
                    ),
                  ),
                ),
                // child: LayoutBuilder(
                //   builder: (context, constraints) {
                //
                //     final axis = constraints.maxWidth <= 848 ?
                //       Axis.vertical :
                //       Axis.horizontal;
                //     return Padding(
                //       key: inputAreaKey,
                //       padding: const EdgeInsets.all(48.0),
                //       child: Flex(
                //         direction: axis,
                //         crossAxisAlignment: CrossAxisAlignment.center,
                //         children: list,
                //       ),
                //     );
                //   },
                // ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildInputArea() {
    return Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 400,
            maxWidth: 400,
            minHeight: 200,
            maxHeight: 320,
          ),
          child: Card(
            elevation: 10,
            shadowColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: itemInputController,
                    maxLines: 1,
                    decoration: const InputDecoration(
                      labelText: '項目名稱',
                      border: OutlineInputBorder(),
                      hintText: '餐廳名稱、人名、組別',
                    ),
                    onSubmitted: _onSubmitted,
                  ),

                  const SizedBox(height: 8.0),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Selector<CheatWheelProvider, List<WheelItem>>(
                        selector: (context, provider) => provider.items,
                        builder: (context, items, _) {
                          return Wrap(
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            runSpacing: 4,
                            children: items
                                .map((item) => _chipBuilder(context, item))
                                .toList(),
                          );
                          return ChipsInput<WheelItem>(
                            values: provider.items,
                            minLines: 1,
                            maxLines: 10,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.local_pizza_rounded),
                              hintText: 'Search for toppings',
                            ),
                            strutStyle: const StrutStyle(fontSize: 15),
                            onChanged: _onChanged,
                            onSubmitted: _onSubmitted,
                            chipBuilder: _chipBuilder,
                            onTextChanged: _onSearchChanged,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () {
              showSettingDialog(context, provider);
            },
            child: const Text('設定權重'),
          ),
        ),
      ],
    );
  }

  Widget buildWheel() {
    return Container(
      width: 400,
      height: 400,
      // decoration: BoxDecoration(
      // ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Selector<CheatWheelProvider, List<WheelItem>>(
            selector: (context, provider) {
              return provider.items;
            },
            builder: (context, items, _) {
              final length = items.length;

              return TweenAnimationBuilder(
                tween: Tween(end: angle),
                duration: 5000.ms,
                curve: Curves.fastLinearToSlowEaseIn,
                onEnd: () => onSpinEnd(context),
                builder: (context, angle, child) {
                  return Transform.rotate(
                    angle: angle,
                    child: child,
                  );
                },
                child: Transform.rotate(
                  /// 補正 180 度
                  angle: pi,
                  child: Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.center,
                    children: [
                      WheelWidget(numberOfSections: length),
                      for(int i=0; i<length; i++)
                        createItem(items[i], i, length),
                    ],
                  ),
                ),
              );
            },
          ),

          const Positioned(
            left: -22,
            child: Icon(
              Icons.play_arrow_sharp,
              color: Colors.grey,
              size: 48,
            ),
          ),
        ],
      ),
    );
  }


  Widget createItem(WheelItem item, int index, int numberOfSections) {
    final double sweepAngle = 2 * pi / numberOfSections;
    final centerAngle = (index+0.5) * sweepAngle;

    return Center(
      child: FractionalTranslation(
        translation: const Offset(0.5, 0),
        child: Container(
          width: 200,
          alignment: Alignment.center,
          transform: Matrix4.rotationZ(centerAngle),
          transformAlignment: Alignment.centerLeft,
          child: Text(
            item.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }

  void _onChanged(List<WheelItem> value) {
    provider.setItems(value);
  }

  void _onSubmitted(String value) {
    myPrint('onSubmit: $value');
    if (value.trim().isNotEmpty) {
      final node = FocusManager.instance.primaryFocus;
      provider.addWheelItem(value);
      itemInputController.clear();
      node?.requestFocus();
    } else {
      final node = FocusManager.instance.primaryFocus;
      node?.requestFocus();

      // provider.setItems([]);
      // _chipFocusNode.unfocus();
      // setState(() {
      //   _toppings = <String>[];
      // });
    }
  }

  Widget _chipBuilder(BuildContext context, WheelItem data) {
    return ToppingInputChip<WheelItem>(
      topping: data,
      title: data.name,
      onDeleted: _onChipDeleted,
      onSelected: _onChipTapped,
    );
  }

  void _onChipDeleted(WheelItem value) {
    provider.removeWheelItem(value);
    context.read<WindowActivity?>()?.focusNode.requestFocus();
  }

  void _onChipTapped(WheelItem value) {
    context.read<WindowActivity?>()?.focusNode.requestFocus();
  }

  void _onSearchChanged(String value) {
  }

  void onSpinStart(BuildContext context) {
    if (provider.items.isEmpty) {
      return;
    }

    final (item, angle) = calculateRotation(
        provider.items.map((e) => (e, provider.weightMap[e] ?? 0)).toList());

    setState(() {
      /// 起碼要轉50圈
      final baseSpinAngle =
          (random.nextInt(10) + 50 + (this.angle ~/ (pi * 2))) * pi * 2;
      this.angle = -angle + baseSpinAngle;
      this.item = item;
      isRotating = true;
    });
    myPrint(angle * 180 / pi);
  }


  void onSpinEnd(BuildContext context) {
    if(item case WheelItem(:final name)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('恭喜 $name', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.w900))),
      );
    }

    setState(
      () => isRotating = false,
    );
  }
}

class WheelItem {

  final String name;

  const WheelItem(this.name);
}

class CheatWheelProvider extends ChangeNotifier {

  List<WheelItem> items = [
    WheelItem('Alice'),
    WheelItem('Bob'),
    WheelItem('Craig'),
    WheelItem('David'),
    WheelItem('Eve'),
  ];
  Map<WheelItem, double> weightMap = {};

  double totalWeight = 0;

  CheatWheelProvider() {
    weightMap = {
      for(final item in items)
        item: 1.0,
    };
  }


  void addWheelItem(String name) {
    if(items.length >= 10) {
      return;
    }

    final newItem = WheelItem(name);
    items = [...items, newItem];
    weightMap[newItem] = 1.0;
    normalizeWeightMap();
  }

  void removeWheelItem(WheelItem item) {
    // items.remove(item);
    items = items.whereNot((element) => element == item).toList();
    // items = [...items];
    normalizeWeightMap();
  }

  void setWeight(WheelItem item, double weight) {
    weightMap[item] = weight;
    weightMap = { ...weightMap };
    notifyListeners();
  }

  void normalizeWeightMap() {
    weightMap.removeWhere((key, value) => !items.contains(key));
    weightMap = { ...weightMap };
    totalWeight = weightMap.values.sum;
    if(totalWeight == 0) {
      weightMap.updateAll((key, value) => 1.0);
    }
    notifyListeners();
  }

  void setItems(List<WheelItem> value) {
    items = value;
    normalizeWeightMap();
    notifyListeners();
  }

  void setWeights(Map<WheelItem, double> newWeights) {
    weightMap = newWeights;
    normalizeWeightMap();
    notifyListeners();
  }

}

class WheelWidget extends StatelessWidget {

  final int numberOfSections;
  final List<Color>? colors;

  const WheelWidget({
    super.key,
    required this.numberOfSections,
    this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: WheelPainter(
          numberOfSections: numberOfSections,
          colors: colors ?? [],
        ),
      ),
    );
  }
}



class WheelPainter extends CustomPainter {
  final int numberOfSections;
  final List<Color> colors;

  static const List<MaterialColor> defaultColors = Colors.primaries;

  const WheelPainter({
    required this.numberOfSections,
    required this.colors,
  }) : assert(numberOfSections >= 0);

  @override
  void paint(Canvas canvas, Size size) {
    final colors = this.colors.isEmpty ? defaultColors : this.colors;

    final paint = Paint()..style = PaintingStyle.fill;
    final double radius = size.width / 2;
    final center = Offset(radius, radius);

    if(numberOfSections == 0) {
      paint.color = colors.first;
      canvas.drawCircle(center, radius, paint);
      return;
    }


    final double sweepAngle = 2 * pi / numberOfSections;

    for (int i = 0; i < numberOfSections; i++) {
      paint.color = colors[i % colors.length];
      final startAngle = i * sweepAngle;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant WheelPainter oldDelegate) {
    return oldDelegate.numberOfSections != numberOfSections || oldDelegate.colors != colors;
  }
}



class WeightSettingDialog extends StatefulWidget {
  final Map<WheelItem, double> weightMap;

  const WeightSettingDialog({super.key, required this.weightMap});

  @override
  State<WeightSettingDialog> createState() => _WeightSettingDialogState();
}

class _WeightSettingDialogState extends State<WeightSettingDialog> {

  Map<WheelItem, double> weightMap = {};

  @override
  void initState() {
    weightMap = {...widget.weightMap};
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 10,
      backgroundColor: Colors.black87,
      shadowColor: Colors.grey.withOpacity(0.7),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        side: BorderSide(width: 4, color: Colors.white),
      ),
      child: DefaultTextStyle.merge(
        style: const TextStyle(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: AnimatedSize(
            duration: 200.ms,
            curve: Curves.easeOutQuart,
            child: IntrinsicWidth(
              child: buildBody(),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [

        /// title
        const Text('權重調整', style: TextStyle(fontSize: 20)),
        const SizedBox(height: 16.0),
        buildTable(weightMap),
        buildSubmitRow(context),
      ],
    );
  }

  Widget buildSubmitRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(weightMap),
            child: const Text('DONE', style: TextStyle(color: Colors.green)),
          ),
        ),
        Expanded(
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CANCEL', style: TextStyle(color: Colors.red)),
          ),
        ),
      ],
    );
  }

  Widget buildTable(Map<WheelItem, double> config) {

    return StatefulBuilder(
      builder: (context, setState) {
        final totalWeight = config.values.sum;

        return Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {
            0: IntrinsicColumnWidth(),
            1: IntrinsicColumnWidth(),
            2: FixedColumnWidth(200),
            3: IntrinsicColumnWidth(),
            4: IntrinsicColumnWidth(),
          },
          children: [
            const TableRow(
              children: [
                Center(child: Text('名稱')),
                Center(child: Text('權重')),
                Center(child: Text('')),
                Center(child: Text('百分比')),
              ],
            ),
            ...config.entries.map(
                  (entry) {
                final isValidTotalWeight = totalWeight > 0;
                final (weight, percentage) = switch (isValidTotalWeight) {
                  false => ('0.0', '0%'),
                  _ => () {
                    final result = entry.value / totalWeight * 100;
                    return (entry.value.toStringAsFixed(2), '${result.toStringAsFixed(2)}%');
                  }(),
                };

                return TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      child: Text(entry.key.name),
                    ),
                    Slider(
                      value: entry.value,
                      onChanged: (value) {
                        setState(() {
                          config.update(entry.key, (oldEntry) => value);
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(weight),
                    ),
                    Text(percentage),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }
}


Future<void> showSettingDialog(BuildContext context, CheatWheelProvider provider) async {

  if(provider.weightMap.isEmpty) {
    return;
  }

  final newConfig = await showGeneralDialog<Map<WheelItem, double>?>(
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) {
      return WeightSettingDialog(weightMap: provider.weightMap);
    },
    transitionBuilder: _buildMaterialDialogTransitions,
  );

  if(newConfig != null) {
    if(newConfig.values.none((value) => value > 0)) {
      if(context.mounted) {
        return showSimpleDialog(context);
      }
      return;
    }

    provider.setWeights(
      newConfig,
    );
  }
}

Future<void> showSimpleDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('錯誤', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 16.0),
              Text('起碼需要一個權重大於0的項目', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildMaterialDialogTransitions(
    BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
  final curveAnimation = CurvedAnimation(
    parent: animation.drive(Tween(begin: 0.3, end: 1)),
    curve: Curves.easeOutBack,
  );
  // 使用缩放动画
  return FadeTransition(
    opacity: animation,
    child: ScaleTransition(
      scale: curveAnimation,
      child: child,
    ),
  );
}