import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AutoGridView extends StatelessWidget {
  /// 行數
  final int row;

  /// 欄數
  final int col;
  final NullableIndexedWidgetBuilder builder;

  const AutoGridView.builder({
    super.key,
    required this.row,
    required this.col,
    required this.builder,
  }) : assert(row > 0 && col > 0);

  factory AutoGridView({
    required int row,
    required int col,
    required List<Widget> children,
  }) {
    final length = children.length;
    return AutoGridView.builder(
      row: row,
      col: col,
      builder: (context, index) {
        return index > length ? null : children[index];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        row,
        (y) => buildRow(context, y),
      ),
    );
  }

  Widget buildRow(BuildContext context, int y) {
    return Expanded(
      child: Row(
        children: List.generate(
          col,
          (x) => buildCol(context, y, x),
        ),
      ),
    );
  }

  Widget buildCol(BuildContext context, int y, int x) {
    return Expanded(
      child: builder.call(context, y * col + x) ?? const SizedBox.shrink(),
    );
  }
}
