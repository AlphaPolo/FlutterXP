import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xp/constant/window_constant.dart';
import 'package:flutter_xp/extensions/color_extension.dart';
import 'package:flutter_xp/extensions/context_extension.dart';
import 'package:flutter_xp/model/desktop/desktop_models.dart';
import 'package:flutter_xp/notifications/window_activity_notification.dart';
import 'package:flutter_xp/providers/selection_provider.dart';
import 'package:flutter_xp/util/my_print.dart';

import '../model/activity/my_computer_content.dart';
import '../model/activity/window_activity.dart';
import 'window_expansion_panel.dart';

class ExplorerViewer extends StatelessWidget {
  final List<(String, List<DeskTopModel>)> models;

  const ExplorerViewer({
    super.key,
    required this.models,
  });


  @override
  Widget build(BuildContext context) {
    myPrint('ExplorerViewer rebuild');
    return Row(
      children: [
        buildLeftCol(),

        Expanded(
          child: buildRightCol(),
        ),
      ],
    );
  }

  Widget buildLeftCol() {
    return Container(
      width: 180,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF748AFF),
            Color(0xFF4057D3),
          ],
          stops: [0.0, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.all(10),
        itemCount: computerPanelList.length,
        itemBuilder: (BuildContext context, int index) {
          final model = computerPanelList[index];
          if (model case [final String title, final List<PanelListItemData> list]) {
            return WindowExpansionPanel(title: title, list: list);
          }
          return null;
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 12.0);
        },
      ),
    );
  }

  Widget buildRightCol() {
    return ColoredBox(
      color: Colors.white,
      child: LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 200,
              maxWidth: max(200, constraints.maxWidth),
            ),
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 15),
              itemCount: models.length,
              itemBuilder: (BuildContext context, int index) {
                final (title, list) = models[index];
                return buildSection(title, list);
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 15.0);
              },
            ),
          ),
        );
      },
        ),
    );
  }

  Widget buildSection(String title, List<DeskTopModel> list) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeader(title),
        Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
          child: Wrap(
            runSpacing: 15,
            children: list.map(buildItem).toList(growable: false),
          ),
        ),
      ],
    );
  }

  Widget buildHeader(String title) {
    return SizedBox(
      width: 300,
      height: 22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2, right: 0, bottom: 3, left: 12),
            child: Text(
              title,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          Container(
            width: double.infinity,
            height: 1,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color.fromRGBO(112, 191, 255, 1),
                  Color.fromRGBO(255, 255, 255, 1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem(DeskTopModel model) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 200,
        maxHeight: 45,
      ),
      child: ExplorerItemWidget(model: model),
    );
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 200,
        maxHeight: 45,
      ),
      child: Row(
        children: [
          Image(
            image: AssetImage(model.iconAsset),
            width: 45,
            height: 45,
            fit: BoxFit.fill,
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(model.label, overflow: TextOverflow.ellipsis, maxLines: 2),
              ],
            ),
          )

        ],
      ),
    );
  }
}

class ExplorerItemWidget extends StatefulWidget {
  final DeskTopModel model;
  final ValueVoidCallback<WindowActivity?>? onDoubleTap;

  const ExplorerItemWidget({super.key, required this.model, this.onDoubleTap});

  @override
  State<ExplorerItemWidget> createState() => _ExplorerItemWidgetState();
}

class _ExplorerItemWidgetState extends State<ExplorerItemWidget> {

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
      width: 45,
      height: 45,
      // opacity: const AlwaysStoppedAnimation(0.5),
    );

    /// 修正RWD不會回彈的問題
    Widget text = LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.0),
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textWidthBasis: constraints.maxWidth == 150 ? TextWidthBasis.longestLine : null,
          ),
        );
      }
    );

    if(isFocus) {
      icon = ColorFiltered(
        colorFilter: ColorFilter.mode(const Color.fromRGBO(11, 97, 255, 0.9).lighten(0.3), BlendMode.modulate),
        child: icon,
      );

      text = DecoratedBox(
        position: DecorationPosition.background,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(11, 97, 255, 0.9).lighten(0.3),
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
          OpenWindowActivityNotification(context: context, activity: createActivity?.call()).dispatch(context);
        }
      },
      child: Focus(
        focusNode: focusNode,
        onFocusChange: (focus) {
          if(isFocus != focus) {
            setState(() => isFocus = focus);
            context.maybeRead<SelectionProvider>()?.setSelectedModel(widget.model);
          }
        },
        child: Row(
          children: [
            icon,
            const SizedBox(width: 5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  text,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isDoubleTap(DateTime? previous, DateTime now) {
    if(previous == null) return false;
    return now.difference(previous) <= kDoubleTapTimeout;
  }
}