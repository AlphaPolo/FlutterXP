import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_xp/components/explorer_viewer.dart';
import 'package:flutter_xp/components/minesweeper/minesweeper_game_screen.dart';
import 'package:flutter_xp/model/desktop/desktop_models.dart';
import 'package:flutter_xp/providers/selection_provider.dart';
import 'package:flutter_xp/util/my_print.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/window_action_bar.dart';
import '../../constant/window_constant.dart';
import '../../helper/analytics_helper.dart';
import '../../util/maybe.dart';
import '../../util/my_localization.dart';
import 'internet_explorer_content.dart';
import 'my_computer_content.dart';
import 'window_activity.dart';

final List<(String, List<DeskTopModel>)> documentContent = [
  (
    S().myProjects,
    [
      ProjectModel(
        label: 'Hexagon TOS',
        iconAsset: 'assets/images/icon_hexagon_tos_48.png',
        createActivity: () {
          AnalyticsHelper.logApplicationOpen('HexagonTos').ignore();
          return InAppBrowserExampleScreen.createInternetExplorerActivity('https://only-hexagon-tos.web.app/#/');
        },
        assetsMD: 'assets/markdown/hexagon_tos.md',
      ),
      const ProjectModel(
        label: 'Hexagon Jubeat',
        iconAsset: 'assets/images/icon_hexagon_jubeat_48.png',
        assetsMD: 'assets/markdown/hexagon_jubeat.md',
      ),
      ProjectModel(
        label: 'Hexagon Tower Defense',
        iconAsset: 'assets/images/icon_hexagon_defense_48.png',
        createActivity: () {
          AnalyticsHelper.logApplicationOpen('FlutterTowerDefense').ignore();
          return InAppBrowserExampleScreen.createInternetExplorerActivity('https://fluttertowerdefense.web.app/');
        },
        assetsMD: 'assets/markdown/hexagon_tower_defense.md',
      ),
      ProjectModel(
        label: 'Tetris & Puyo',
        iconAsset: 'assets/images/icon_tetris_puyo_48.png',
        createActivity: () {
          AnalyticsHelper.logApplicationOpen('PuyoTetris').ignore();
          return InAppBrowserExampleScreen.createInternetExplorerActivity('https://puyotetris.web.app/#/');
        },
        assetsMD: 'assets/markdown/tetris_puyo.md',
      ),
      ProjectModel(
        label: '踩地雷',
        iconAsset: 'assets/images/minesweeper/icon_mine_32.png',
        createActivity: () {
          return MinesweeperGameScreen.createActivity();
        },
        assetsMD: 'assets/markdown/minesweeper.md',
      ),
      ProjectModel(
        label: 'Uno',
        iconAsset: 'assets/images/icon_uno_48.png',
        createActivity: () {
          AnalyticsHelper.logApplicationOpen('Uno').ignore();
          return InAppBrowserExampleScreen.createInternetExplorerActivity('https://flutter-uno-82015.web.app/#/');
        },
        assetsMD: 'assets/markdown/uno.md',
      ),
    ],
  ),
].map((e) {
  e.$2.removeWhere((element) => element.createActivity == null);
  return e;
}).toList();

class ProjectModel extends DeskTopModel {
  final String? assetsMD;

  const ProjectModel({
    required super.label,
    required super.iconAsset,
    super.createActivity,
    this.assetsMD,
  });

}

class MyDocumentScreen extends StatelessWidget {
  final List<(String, List<DeskTopModel>)> models;

  const MyDocumentScreen({
    super.key,
    required this.models,
  });

  static const double showInfoBreakPoint = 180.0 + 430.0;

  static WindowActivity createActivity() {
    return WindowActivity(
      activityId: WindowConstant.idGenerator.nextId().toString(),
      title: 'My Documents',
      iconAsset: 'assets/images/icon_my_documents_16.png',
      content: MyDocumentScreen(models: documentContent),
      menuGetter: getComputerMenu,
      actionBar: const WindowActionBar(),
    );
  }

  @override
  Widget build(BuildContext context) {

    final leftCol = Flexible(
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 380,
          maxWidth: 180+430.0,
        ),
        child: ExplorerViewer(models: models),
      ),
    );

    return ChangeNotifierProvider(
      create: (context) => SelectionProvider(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              leftCol,
              if (constraints.maxWidth >= showInfoBreakPoint)
                infoRightCol(constraints),
            ],
          );
        },
      ),
    );
  }

  Widget infoRightCol(BoxConstraints constraints) {
    final rightColTotalWidth = constraints.maxWidth - showInfoBreakPoint;

    return Container(
      color: Colors.white,
      width: rightColTotalWidth,
      child: ProxyProvider<SelectionProvider, (String, Future<String>)?>(
        update: (context, provider, previous) {
          return switch (provider.selectedModel) {
            ProjectModel(:final assetsMD?) when previous?.$1 == assetsMD => previous,
            ProjectModel(:final assetsMD?) => (assetsMD, _loadContent(assetsMD)),
            _ => null,
          };
        },
        child: const ProjectInfoViewer(),
      ),
    );
  }

  Future<String> _loadContent(String assetPath) async {
    return await rootBundle.loadString(assetPath);
  }
}

class ProjectInfoViewer extends StatelessWidget {
  const ProjectInfoViewer({
    super.key,
  });

  static const double showInfo = 200.0;

  @override
  Widget build(BuildContext context) {
    final child = buildViewer();


    return Container(
      decoration: const BoxDecoration(),
      clipBehavior: Clip.hardEdge,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return TweenAnimationBuilder(
            duration: 700.ms,
            tween: Tween<Offset>(end: constraints.maxWidth >= showInfo ? Offset.zero : const Offset(1, 0)),
            curve: Curves.easeOutQuart,
            builder: (context, value, innerChild) {
              return FractionalTranslation(
                translation: value,
                child: innerChild,
              );
            },
            child: child,
          );
        },
      ),
    );
  }

  Widget buildViewer() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(left: BorderSide(width: 2, color: Colors.grey)),
      ),
      child: Consumer<(String, Future<String>)?>(
        builder: (context, record, _) {
          final contentFuture = record?.$2;
          myPrint('rebuild');

          return FutureBuilder(
            future: contentFuture,
            builder: (context, snapshot) {
              final data = snapshot.data;
              return Markdown(
                data: data ?? '',
                onTapLink: (text, href, title) async {
                  final url = Maybe.ofNullable(href).map(Uri.tryParse).getOrElse(null);

                  if (url != null && await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
                imageBuilder: (uri, title, alt) {
                  return _MarkdownInnerImage(url: alt ?? '');
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _MarkdownInnerImage extends StatelessWidget {
  final String url;

  const _MarkdownInnerImage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 400,
          ),
          child: Image.network(
            url,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (frame == null) {
                return child; // or display a placeholder
              } else {
                return child; // the image is loaded
              }
            },
            loadingBuilder: (context, child, loadingProgress) {
              if(loadingProgress == null) {
                return child;
              }
              return AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ).animate(onPlay: (controller) => controller.loop()).shimmer(delay: 2.seconds, duration: 1.seconds),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 50,
                    color: Colors.red,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Failed to load GIF',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}