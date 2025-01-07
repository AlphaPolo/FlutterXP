import 'package:flutter/material.dart';
import 'package:flutter_xp/constant/window_constant.dart';
import 'package:flutter_xp/flutter_xp.dart';
import 'package:flutter_xp/model/activity/window_activity.dart';
import 'package:provider/provider.dart';

import '../r.g.dart';
import '../util/my_print.dart';

class WindowActionBar extends StatelessWidget {

  final bool isInternet;

  const WindowActionBar({super.key}): isInternet = false;
  const WindowActionBar.internet({super.key}): isInternet = true;



  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: WindowConstant.windowActionBarHeight,
          padding: const EdgeInsets.only(top: 1, left: 3, right: 3),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(width: 1, color: Color.fromRGBO(0, 0, 0, 0.1))),
          ),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                buildNavigatorButtons(),
                divider(),
                buildMiddle(),
                divider(),
                buildTrail(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget divider() {
    return Container(
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 36 * 0.05),
      color: const Color.fromRGBO(0, 0, 0, 0.2),
    );
  }

  Widget buildNavigatorButtons() {
    return Builder(
      builder: (context) {
        final activity = context.read<WindowActivity>();
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            NavigatorButton(
              label: 'Back',
              icon: SizedBox.square(
                dimension: 30,
                child: Image(image: R.image.btn_back(), fit: BoxFit.fill),
              ),
              action: switch (isInternet) {
                false => null,
                true => activity.onBackPress,
              },
              hasTrail: true,
            ),

            NavigatorButton(
              icon: SizedBox.square(
                dimension: 30,
                child: Image(image: R.image.btn_forward(), fit: BoxFit.fill),
              ),
              hasTrail: true,
            ),
            if (isInternet) ...[
              NavigatorButton(
                icon: SizedBox.square(
                  dimension: 30,
                  child: Image.asset('assets/images/icon_stop_32.png', fit: BoxFit.fill),
                ),
                trailPadding: 2.0,
                action: () {},
              ),
              NavigatorButton(
                icon: SizedBox.square(
                  dimension: 30,
                  child: Image.asset('assets/images/icon_refresh_32.png', fit: BoxFit.fill),
                ),
                trailPadding: 2.0,
                action: activity.onRefresh,
              ),
              NavigatorButton(
                icon: SizedBox.square(
                  dimension: 30,
                  child: Image.asset('assets/images/icon_home_32.png', fit: BoxFit.fill),
                ),
                trailPadding: 2.0,
                action: () {},
              ),
            ] else
              NavigatorButton(
                icon: SizedBox.square(
                  dimension: 22,
                  child: Image(image: R.image.icon_folder_up(), fit: BoxFit.fill),
                ),
                action: () {},
              ),
          ],
        );
      }
    );
  }

  Widget buildMiddle() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        NavigatorButton(
          label: 'Search',
          icon: Padding(
            padding: const EdgeInsets.only(left: 1.0, right: 4.0),
            child: SizedBox.square(
              dimension: 22,
              child: Image(image: R.image.icon_search_32(), fit: BoxFit.fill),
            ),
          ),
          action: () {},
        ),

        NavigatorButton(
          label: 'Folders',
          icon: Padding(
            padding: const EdgeInsets.only(left: 1.0, right: 4.0),
            child: SizedBox.square(
              dimension: 22,
              child: Image(image: R.image.icon_folder_32(), fit: BoxFit.fill),
            ),
          ),
          action: () {},
        ),
      ],
    );
  }

  Widget buildTrail() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        NavigatorButton(
          icon: Padding(
            padding: const EdgeInsets.only(left: 2.0, right: 1.0),
            child: SizedBox.square(
              dimension: 22,
              child: Image(image: R.image.icon_checklist_32(), fit: BoxFit.fill),
            ),
          ),
          hasTrail: true,
          action: () {},
        ),
      ],
    );
  }
}

class NavigatorButton extends StatelessWidget {
  final String? label;
  final Widget? icon;
  final VoidCallback? action;
  final bool hasTrail;
  final double trailPadding;

  const NavigatorButton({
    super.key,
    this.label,
    this.icon,
    this.action,
    this.hasTrail = false,
    this.trailPadding = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDisable = action == null;
    if(isDisable) {
      return buildDisable();
    }
    else {
      return buildNormal();
    }
  }

  Widget buildNormal() {
    return HoverBuilder(
      builder: (context, isHover, child) {
        return Container(
          height: double.infinity,
          margin: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            border: isHover ? Border.all(color: const Color(0xFFB9B9B9), width: 1) : Border.all(color: Colors.transparent, width: 1),
            color: isHover ? const Color(0xDEDEDEDE) : Colors.transparent,
            boxShadow: isHover ? [
              BoxShadow(
                color: const Color(0x00ffffff).withOpacity(0.7),
                offset: const Offset(0, -1),
                blurRadius: 1,
                spreadRadius: 0,
              ),
            ] : [],
            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
          ),

          child: child,
        );
      },
      child: InkWell(
        onTap: action,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if(icon != null)
              icon!,
            if(label != null)
              Text(label!, style: const TextStyle(fontSize: 11)),
            if(hasTrail)
              Padding(
                padding: EdgeInsets.only(left: 4, right: trailPadding),
                child: const Icon(Icons.arrow_drop_down, size: 16),
              )
            else
              SizedBox(width: trailPadding),
          ],
        ),
      ),
    );
  }

  Widget buildDisable() {
    return InkWell(
      onTap: action,
      child: DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: const BoxDecoration(
          color: Colors.grey,
          backgroundBlendMode: BlendMode.saturation,
        ),
        child: Opacity(
          opacity: 0.7,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if(icon != null)
                icon!,
              if(label != null)
                Text(label!, style: const TextStyle(fontSize: 11)),
              if(hasTrail)
                const Padding(
                  padding: EdgeInsets.only(left: 4, right: 4),
                  child: Icon(Icons.arrow_drop_down, size: 16),
                )
              else
                const SizedBox(width: 4.0),
            ],
          ),
        ),
      ),
    );
  }
}

class HoverBorder extends RoundedRectangleBorder
    implements MaterialStateOutlinedBorder {
  const HoverBorder();

  @override
  OutlinedBorder? resolve(Set<MaterialState> states) {
    myPrint(states);
    if (states.contains(MaterialState.hovered)) {
      return const RoundedRectangleBorder(
        side: BorderSide(width: 1, color: Colors.black),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      );
    }
    return null; // Defer to default value on the theme or widget.
  }
}
