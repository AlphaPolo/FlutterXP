import 'package:flutter/material.dart';

import '../flutter_xp.dart';
import '../model/start_menu/start_menu_models.dart';
import '../r.g.dart';
import '../util/my_print.dart';

class TaskWindow extends StatelessWidget {
  final FocusScopeNode focusScopeNode;
  final VoidCallback? onUnFocus;

  const TaskWindow({super.key, required this.focusScopeNode, this.onUnFocus});


  @override
  Widget build(BuildContext context) {
    focusScopeNode.requestFocus();
    return FocusScope(
      node: focusScopeNode,
      onFocusChange: (focus) {
        myPrint('TaskWindow is focus: $focus');

        if(!focus) {
          onUnFocus?.call();
        }
      },
      canRequestFocus: true,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(5.0)),
        child: Container(
          color: const Color.fromARGB(255, 66, 130, 214),
          width: 384,
          child: Column(
            children: [
              buildHeader(),
              buildOrangeSeparator(),
              buildContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    return SizedBox(
      height: 54,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(5, 6, 5, 5),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(24, 104, 206, 1.0),
                  Color.fromRGBO(14, 96, 203, 1.0),
                  Color.fromRGBO(14, 96, 203, 1.0),
                  Color.fromRGBO(17, 100, 207, 1.0),
                  Color.fromRGBO(22, 103, 207, 1.0),
                  Color.fromRGBO(27, 108, 211, 1.0),
                  Color.fromRGBO(30, 112, 217, 1.0),
                  Color.fromRGBO(36, 118, 220, 1.0),
                  Color.fromRGBO(41, 122, 224, 1.0),
                  Color.fromRGBO(52, 130, 227, 1.0),
                  Color.fromRGBO(55, 134, 229, 1.0),
                  Color.fromRGBO(66, 142, 233, 1.0),
                  Color.fromRGBO(71, 145, 235, 1.0),
                ],
                stops: [0.0, 0.12, 0.2, 0.32, 0.33, 0.47, 0.54, 0.6, 0.65, 0.77, 0.79, 0.9, 1.0],
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DecoratedBox(
                  position: DecorationPosition.foreground,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color.fromRGBO(222, 222, 222, 0.8), width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                  ),
                  child: SizedBox.square(
                    dimension: 42,
                    child: Image(image: R.image.icon_user_32(), fit: BoxFit.fill),
                  ),
                ),
                const SizedBox(width: 5),
                const Text(
                  'AlphaCostankion',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    shadows: [
                      BoxShadow(
                        color: Colors.black,
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
              top: 1.2,
              left: 3,
              right: 3,
              height: 1.5,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0, 0.01, 0.02, 0.95, 0.98, 0.99, 1],
                    colors: [
                      Colors.transparent,
                      Color.fromRGBO(255, 255, 255, 0.3),
                      Color.fromRGBO(255, 255, 255, 0.5),
                      Color.fromRGBO(255, 255, 255, 0.5),
                      Color.fromRGBO(255, 255, 255, 0.3),
                      Color.fromRGBO(255, 255, 255, 0.2),
                      Colors.transparent,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(14, 96, 203, 1),
                      offset: Offset(0, -1),
                      blurRadius: 1,
                      spreadRadius: 0,
                    ),
                  ],
                ),
              )
          ),
        ],
      ),
    );
  }

  Widget buildOrangeSeparator() {
    return Container(
      width: double.infinity,
      height: 2,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.transparent,
            Color.fromRGBO(218, 136, 74, 1.0),
            Colors.transparent,
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
    );
  }

  Widget buildContent() {
    const leftMenu = startMenuModels;
    const rightMenu = rightSideMenuModels;

    return Container(
      child: Row(
        children: [
          buildLeftMenu(leftMenu),
          buildRightMenu(rightMenu),
        ],
      ),
    );

  }

  Widget buildRightMenu(List<StartMenuModel> rightMenu) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 203, 227, 255),
        border: Border(left: BorderSide(color: Color.fromRGBO(58, 58, 255, 0.37))),
      ),
      padding: const EdgeInsets.only(top: 6, left: 5, right: 5),
      width: 190,
      height: 386,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ...rightMenu.map((model) {
              return buildRightMenuItem(model);
            }),
          ],
        ),
      ),
    );
  }

  Widget buildLeftMenu(List<StartMenuModel> list) {
    return Container(
      color: Colors.white,
      width: 190,
      height: 386,
      padding: const EdgeInsets.only(top: 6, left: 5, right: 5),
      child: Column(
        children: [
          ...list.map((model) {
            return buildMenuItem(model);
          }),
        ],
      ),
    );
  }

  Widget buildMenuItem(StartMenuModel model) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: HoverBuilder(
        builder: (context, isHover, child) {
          return Container(
            margin: const EdgeInsets.all(1),
            decoration: isHover ? const BoxDecoration(color: Color.fromRGBO(66, 130, 214, 1)) : null,
            height: 32,
            child: DefaultTextStyle.merge(
              style: isHover ? const TextStyle(color: Colors.white) : null,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox.square(
                    dimension: 30,
                    child: Image(image: AssetImage(model.iconAsset), fit: BoxFit.fill),
                  ),
                  const SizedBox(width: 3),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(model.label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11)),
                        if(model.subLabel != null)
                          Text(model.subLabel!,
                            style: TextStyle(color: isHover ? Colors.white : const Color.fromRGBO(0, 0, 0, 0.4), fontSize: 11),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildRightMenuItem(StartMenuModel model) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: HoverBuilder(
        builder: (context, isHover, child) {
          return Container(
            margin: const EdgeInsets.all(1),
            padding: const EdgeInsets.all(1),
            decoration: isHover ? const BoxDecoration(color: Color.fromRGBO(66, 130, 214, 1)) : null,
            height: 28,
            child: DefaultTextStyle.merge(
              style: isHover ? const TextStyle(color: Colors.white) : null,
              child: child!,
            ),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox.square(
              dimension: 22,
              child: Image(image: AssetImage(model.iconAsset), fit: BoxFit.fill),
            ),
            const SizedBox(width: 3),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(model.label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11, height: 13/11)),
                  if(model.subLabel != null)
                    Text(model.subLabel!,
                        style: const TextStyle(color: Color.fromRGBO(0, 0, 0, 0.4), fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
