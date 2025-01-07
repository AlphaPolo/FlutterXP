import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_xp/extensions/iterable_extension.dart';

class WindowExpansionPanel extends StatefulWidget {
  final String title;
  final List<PanelListItemData> list;

  const WindowExpansionPanel({super.key, required this.title, this.list = const []});

  @override
  State<WindowExpansionPanel> createState() => _WindowExpansionPanelState();
}

class _WindowExpansionPanelState extends State<WindowExpansionPanel> {

  bool isExpand = true;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: const TextStyle(fontSize: 11),
      child: AnimatedSize(
        alignment: Alignment.topCenter,
        duration: 250.ms,
        curve: Curves.easeOutQuart,
        child: Column(
          children: [
            buildHeader(),
            if(isExpand)
              buildContent(),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    return InkWell(
      onTap: togglePanel,
      child: Container(
        height: 23,
        padding: const EdgeInsets.only(left: 11, right: 4),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF0F0FF),
              Color(0xFFF0F0FF),
              Color(0xFFA8BCFF),
            ],
            stops: [0.0, 0.3, 1.0],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(3.0)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: const TextStyle(color: Color.fromRGBO(12, 50, 125, 1), fontWeight: FontWeight.w700),
            ),

            SizedBox.square(
              dimension: 14,
              child: PhysicalModel(
                color: Colors.white,
                shape: BoxShape.circle,
                elevation: 5,
                child: AnimatedSwitcher(
                  duration: 50.ms,
                  child: isExpand
                      ? const Icon(key: ValueKey(true), Icons.keyboard_arrow_up, size: 12)
                      : const Icon(key: ValueKey(false), Icons.keyboard_arrow_down, size: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContent() {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color.fromRGBO(180, 200, 251, 1),
            Color.fromRGBO(164, 185, 251, 1),
            Color.fromRGBO(180, 200, 251, 1),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
        color: Color.fromRGBO(198, 211, 255, 0.87),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          children: widget.list.map<Widget>((item) {
            return Row(
              children: [
                SizedBox.square(
                  dimension: 14,
                  child: Image(image: AssetImage(item.iconAsset), fit: BoxFit.fill),
                ),
                const SizedBox(width: 5),
                Flexible(child: Text(item.label, style: const TextStyle(fontSize: 10, color: Color.fromRGBO(12, 50, 125, 1)))),
              ],
            );
          }).joinElement(const SizedBox(height: 2.0)).toList(),
        ),
      ),
    );
  }

  void togglePanel() {
    setState(() => isExpand ^= true);
  }
}

class PanelListItemData {
  final String iconAsset;
  final String label;

  const PanelListItemData({
    required this.iconAsset,
    required this.label,
  });
}
