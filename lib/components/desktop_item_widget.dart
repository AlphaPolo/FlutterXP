import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xp/model/activity/window_activity.dart';
import 'package:flutter_xp/model/desktop/desktop_models.dart';

class DesktopItemWidget extends StatefulWidget {
  final DeskTopModel model;
  final void Function(WindowActivity?)? onDoubleTap;

  const DesktopItemWidget({super.key, required this.model, this.onDoubleTap});

  @override
  State<DesktopItemWidget> createState() => _DesktopItemWidgetState();
}

class _DesktopItemWidgetState extends State<DesktopItemWidget> {

  bool isFocus = false;
  final FocusNode focusNode = FocusNode();

  DateTime? previousTimeStamp;

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DeskTopModel(:label, :iconAsset, :createActivity) = widget.model;

    Widget icon = Image(
      image: AssetImage(iconAsset),
      fit: BoxFit.fill,
      width: 30,
      height: 30,
      // opacity: const AlwaysStoppedAnimation(0.5),
    );

    Widget text = Padding(
      padding: const EdgeInsets.only(left: 3, right: 3, bottom: 0, top: 2),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          shadows: [
            BoxShadow(
              color: Colors.black,
              spreadRadius: 0,
              blurRadius: 0,
              offset: Offset(1, 1),
            ),
          ],
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
    );

    if(isFocus) {
      icon = ColorFiltered(
        colorFilter: const ColorFilter.mode(Color.fromRGBO(11, 97, 255, 0.75), BlendMode.modulate),
        child: icon,
      );

      text = DecoratedBox(
        position: DecorationPosition.background,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(11, 97, 255, 0.75),
        ),
        child: text,
      );
    }

    return GestureDetector(
      onTap: () {
        final now = DateTime.now();

        if(!isDoubleTap(previousTimeStamp, now)) {
          previousTimeStamp = now;
          focusNode.requestFocus();
        } else {
          /// consume event
          previousTimeStamp = null;
          focusNode.requestFocus();
          widget.onDoubleTap?.call(createActivity?.call());
        }
      },
      child: Focus(
        focusNode: focusNode,
        onFocusChange: (focus) {
          if(isFocus != focus) {
            setState(() {
              isFocus = focus;
            });
          }
        },
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              icon,
              const SizedBox(height: 5),
              text,
            ],
          ),
        ),
      ),
    );
  }

  bool isDoubleTap(DateTime? previous, DateTime now) {
    if(previous == null) return false;
    return now.difference(previous) <= kDoubleTapTimeout;
  }
}
