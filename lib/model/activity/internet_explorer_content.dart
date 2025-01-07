import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_xp/model/activity/window_activity.dart';
import 'package:flutter_xp/notifications/window_activity_notification.dart';
import 'package:flutter_xp/util/my_print.dart';
import 'package:provider/provider.dart';

import '../../components/my_menu_bar.dart';
import '../../components/window_action_bar.dart';
import '../../constant/window_constant.dart';

MenuGetter getInternetExplorerMenu = (context, activity, previousEntry) {

  final List<MenuEntry> result = <MenuEntry>[
    MenuEntry(
      label: 'File',
      menuChildren: <MenuEntry>[
        MenuEntry(
          label: 'New',
          menuChildren: [
            MenuEntry(
              label: 'Window',
              onPressed: () {},
              shortcut: const SingleActivator(LogicalKeyboardKey.keyN, control: true),
            ),
            const MenuEntry.divider(),
            MenuEntry(
              label: 'Message',
              onPressed: () {},
            ),
            MenuEntry(
              label: 'Post',
              onPressed: () {},
            ),
            MenuEntry(
              label: 'Contact',
              onPressed: () {},
            ),
            MenuEntry(
              label: 'Internet Call',
              onPressed: () {},
            ),
          ],
        ),
        MenuEntry(
          label: 'Open...',
          onPressed: () {},
          shortcut: const SingleActivator(LogicalKeyboardKey.keyO, control: true),
        ),
        const MenuEntry(
          label: 'Edit',
        ),
        const MenuEntry(
          label: 'Save',
        ),
        const MenuEntry(
          label: 'Save As...',
        ),
        const MenuEntry.divider(),
        const MenuEntry(
          label: 'Page Setup...',
        ),
        const MenuEntry(
          label: 'Print...',
        ),
        const MenuEntry(
          label: 'Print Preview...',
        ),
        const MenuEntry.divider(),
        MenuEntry(
          label: 'Send',
          menuChildren: [
            MenuEntry(
              label: 'Page by E-mail...',
              onPressed: () {},
            ),
            MenuEntry(
              label: 'Link by E-mail...',
              onPressed: () {},
            ),
            MenuEntry(
              label: 'Shortcut to Desktop',
              onPressed: () {},
            ),
          ],
        ),
        const MenuEntry(
          label: 'Import and Export...',
        ),
        const MenuEntry.divider(),
        const MenuEntry(
          label: 'Properties',
        ),
        const MenuEntry(
          label: 'Work Offline',
        ),
        MenuEntry(
          label: 'Close',
          onPressed: () {
            DeleteWindowActivityNotification(context: context, activity: activity).dispatch(context);
          },
        ),
      ],
    ),
    MenuEntry(
      label: 'Edit',
      menuChildren: [
        const MenuEntry(
          label: 'Cut',
          shortcut: SingleActivator(LogicalKeyboardKey.keyX, control: true),
        ),
        const MenuEntry(
          label: 'Copy',
          shortcut: SingleActivator(LogicalKeyboardKey.keyC, control: true),
        ),
        const MenuEntry(
          label: 'Paste',
          shortcut: SingleActivator(LogicalKeyboardKey.keyV, control: true),
        ),
        const MenuEntry.divider(),
        MenuEntry(
          label: 'Select All',
          onPressed: () {},
          shortcut: const SingleActivator(LogicalKeyboardKey.keyA, control: true),
        ),
        const MenuEntry.divider(),
        const MenuEntry(
          label: 'Find (on This Page)...',
          shortcut: SingleActivator(LogicalKeyboardKey.keyF, control: true),
        ),
      ],
    ),

    MenuEntry(
      label: 'View',
      menuChildren: [
        MenuEntry(
          label: 'Toolbars',
          menuChildren: [
            MenuEntry(
              label: 'Standard Buttons',
              onPressed: () {},
            ),
            MenuEntry(
              label: 'Address Bar',
              onPressed: () {},
            ),
            MenuEntry(
              label: 'Links',
              onPressed: () {},
            ),
            const MenuEntry.divider(),
            MenuEntry(
              label: 'Lock the Toolbars',
              onPressed: () {},
            ),
            MenuEntry(
              label: 'Customize...',
              onPressed: () {},
            ),
          ],
        ),
        MenuEntry(
          label: 'Status Bar',
          onPressed: () {},
        ),
        MenuEntry(
          label: 'Explorer Bar',
          menuChildren: [
            MenuEntry(
              label: 'Search',
              onPressed: () {},
              shortcut: const SingleActivator(LogicalKeyboardKey.keyE, control: true),
            ),
            MenuEntry(
              label: 'Favorites',
              onPressed: () {},
              shortcut: const SingleActivator(LogicalKeyboardKey.keyI, control: true),
            ),
            MenuEntry(
              label: 'History',
              onPressed: () {},
              shortcut: const SingleActivator(LogicalKeyboardKey.keyH, control: true),
            ),
            MenuEntry(
              label: 'Folders',
              onPressed: () {},
            ),
            const MenuEntry.divider(),
            MenuEntry(
              label: 'Tip of the Day',
              onPressed: () {},
            ),
          ],
        ),
        const MenuEntry.divider(),
        MenuEntry(
          label: 'Go to',
          menuChildren: [
            const MenuEntry(
              label: 'Back',
              shortcut: SingleActivator(LogicalKeyboardKey.arrowLeft, alt: true),
            ),
            const MenuEntry(
              label: 'Forward',
              shortcut: SingleActivator(LogicalKeyboardKey.arrowRight, alt: true),
            ),
            const MenuEntry.divider(),
            MenuEntry(
              label: 'Home Page',
              onPressed: () {},
              shortcut: const SingleActivator(LogicalKeyboardKey.home, alt: true),
            ),
            const MenuEntry.divider(),
            MenuEntry(
              label: 'Cannot find Server',
              onPressed: () {},
            ),
          ],
        ),
        MenuEntry(
          label: 'Stop',
          onPressed: () {},
        ),
        MenuEntry(
          label: 'Refresh',
          onPressed: () {},
          shortcut: const SingleActivator(LogicalKeyboardKey.f5),
        ),
        const MenuEntry.divider(),
        MenuEntry(
          label: 'Source',
          onPressed: () {},
        ),
        MenuEntry(
          label: 'Full Screen',
          onPressed: () {},
          shortcut: const SingleActivator(LogicalKeyboardKey.f11),
        ),
      ],
    ),

    MenuEntry(
      label: 'Favorites',
      menuChildren: [
        MenuEntry(
          label: 'Add to Favorites...',
          onPressed: () {},
        ),

        MenuEntry(
          label: 'Organize Favorites...',
          onPressed: () {},
        ),
      ],
    ),

    MenuEntry(
      label: 'Tools',
      menuChildren: [
        MenuEntry(
          label: 'Mail and News',
          menuChildren: [
            MenuEntry(
              label: 'Read Mail',
              onPressed: () {},
            ),
            MenuEntry(
              label: 'New Message...',
              onPressed: () {},
            ),
            MenuEntry(
              label: 'Send a Link...',
              onPressed: () {},
            ),
            MenuEntry(
              label: 'Send Page...',
              onPressed: () {},
            ),
            const MenuEntry.divider(),
            MenuEntry(
              label: 'Read News',
              onPressed: () {},
            ),
          ],
        ),
        MenuEntry(
          label: 'Pop-up Blocker',
          menuChildren: [
            MenuEntry(
              label: 'Turn Off Pop-up Blocker',
              onPressed: () {},
            ),
            MenuEntry(
              label: 'Pop-up Blocker Settings...',
              onPressed: () {},
            ),
          ],
        ),
        MenuEntry(
          label: 'Manage Add-ons...',
          onPressed: () {},
        ),
        MenuEntry(
          label: 'Synchronize...',
          onPressed: () {},
        ),
        MenuEntry(
          label: 'Windows Update',
          onPressed: () {},
        ),
        const MenuEntry.divider(),
        MenuEntry(
          label: 'Windows Messenger',
          onPressed: () {},
        ),
        MenuEntry(
          label: 'Diagnose Connection Problems...',
          onPressed: () {},
        ),
        const MenuEntry.divider(),
        MenuEntry(
          label: 'Internet Options...',
          onPressed: () {},
        ),
      ],
    ),

    MenuEntry(
      label: 'Help',
      menuChildren: [
        MenuEntry(
          label: 'Contents and Index',
          onPressed: () {},
        ),
        MenuEntry(
          label: 'Tip of the Day',
          onPressed: () {},
        ),
        MenuEntry(
          label: 'For Netscape Users',
          onPressed: () {},
        ),
        MenuEntry(
          label: 'Online Support',
          onPressed: () {},
        ),
        MenuEntry(
          label: 'Send Feedback',
          onPressed: () {},
        ),
        const MenuEntry.divider(),
        MenuEntry(
          label: 'About Internet Explorer',
          onPressed: () {},
        ),
      ],
    ),
  ];

  // (Re-)register the shortcuts with the ShortcutRegistry so that they are
  // available to the entire application, and update them if they've changed.
  previousEntry?.dispose();
  // final shortcutEntry = ShortcutRegistry.of(context).addAll(MenuEntry.shortcuts(result));
  // final shortcutEntry = ShortcutRegistryEntry.of(context).addAll({});
  return (previousEntry, result);
};

class InAppBrowserExampleScreen extends StatefulWidget {
  final String url;

  const InAppBrowserExampleScreen({
    super.key,
    String? url,
  }): url = url ?? 'https://flutterxp-9c43a.web.app/#/';

  static WindowActivity createInternetExplorerActivity(
    [String? url]
  ) {
    return WindowActivity(
      activityId: WindowConstant.idGenerator.nextId().toString(),
      title: 'Internet Explorer',
      iconAsset: 'assets/images/icon_internet_32.png',
      content: InAppBrowserExampleScreen(url: url),
      actionBar: const WindowActionBar.internet(),
      menuGetter: getInternetExplorerMenu,
    );
  }

  @override
  State<InAppBrowserExampleScreen> createState() => _InAppBrowserExampleScreenState();
}

class _InAppBrowserExampleScreenState extends State<InAppBrowserExampleScreen> {

  static const double addressHeight = 22.0;

  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
    isInspectable: kDebugMode,
    mediaPlaybackRequiresUserGesture: false,
    allowsInlineMediaPlayback: true,
    iframeAllow: "camera; microphone",
    iframeAllowFullscreen: true,

  );

  PullToRefreshController? pullToRefreshController;
  late String url = widget.url;
  double progress = 0;

  late final urlController = TextEditingController(text: url);

  @override
  void initState() {
    super.initState();
    myPrint('initState');

    WidgetsBinding.instance.addPostFrameCallback((_) {
        final activity = context.read<WindowActivity>();
        activity.backAction = onBackPress;
        activity.refreshAction = onRefresh;
    });

    pullToRefreshController = kIsWeb
        ? null
        : PullToRefreshController(
            settings: PullToRefreshSettings(
              color: Colors.blue,
            ),
            onRefresh: () async {
              if (defaultTargetPlatform == TargetPlatform.android) {
                webViewController?.reload();
              } else if (defaultTargetPlatform == TargetPlatform.iOS) {
                webViewController?.loadUrl(
                  urlRequest: URLRequest(url: await webViewController?.getUrl()),
                );
              }
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    final activity = context.read<WindowActivity>();
    return AnimatedBuilder(
      animation: activity.focusNode,
      builder: (context, child) {
        final ignore = !activity.focusNode.hasFocus;
        // myPrint(ignore);
        return IgnorePointer(
          ignoring: ignore,
          child: child,
        );
      },
      child: buildWebView(),
    );
  }

  Widget buildWebView() {
    InputDecoration;
    return Column(
      children: <Widget>[
        buildAddressRow(),
        Expanded(
          child: InAppWebView(
            key: webViewKey,
            initialUrlRequest: URLRequest(url: WebUri(url)),
            initialSettings: settings,
            pullToRefreshController: pullToRefreshController,

            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            onLoadStart: (controller, url) {
              setState(() {
                this.url = url.toString();
                urlController.text = this.url;
              });

              _updateCanGoBack();
            },
            onPermissionRequest: (controller, request) async {
              return PermissionResponse(resources: request.resources, action: PermissionResponseAction.GRANT);
            },
            // shouldOverrideUrlLoading: (controller, navigationAction) async {
            //   var uri = navigationAction.request.url!;
            //
            //   if (!["http", "https", "file", "chrome", "data", "javascript", "about"].contains(uri.scheme)) {
            //     if (await canLaunchUrl(uri)) {
            //       // Launch the App
            //       await launchUrl(
            //         uri,
            //       );
            //       // and cancel the request
            //       return NavigationActionPolicy.CANCEL;
            //     }
            //   }
            //
            //   return NavigationActionPolicy.ALLOW;
            // },
            onLoadStop: (controller, url) async {
              pullToRefreshController?.endRefreshing();
              setState(() {
                this.url = url.toString();
                urlController.text = this.url;
              });

              _updateCanGoBack();
            },
            onReceivedError: (controller, request, error) {
              pullToRefreshController?.endRefreshing();
            },
            // onProgressChanged: (controller, progress) {
            //   if (progress == 100) {
            //     pullToRefreshController?.endRefreshing();
            //   }
            //   setState(() {
            //     this.progress = progress / 100;
            //     urlController.text = url;
            //   });
            // },
            onConsoleMessage: (controller, consoleMessage) {
              myPrint(consoleMessage);
            },
          ),
        ),
      ],
    );
  }

  Future<void> _updateCanGoBack() async {
    bool canGoBack = await webViewController?.canGoBack() ?? false;
    myPrint('_updateCanGoBack: $canGoBack');
    if(mounted) {
      context.read<WindowActivity?>()?.updateNavigation(canGoBack);
    }

  }

  void onBackPress() async {

    if(webViewController case final controller?) {
      myPrint('onBackPress: $controller');
    }

  }

  void onRefresh() {
    myPrint('onRefresh');
    // html.window.location.reload();
    // webViewController?.reload();
  }

  Widget buildAddressRow() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(width: 1, color: Colors.white70),
          bottom: BorderSide(
            width: 1,
            color: Color.fromRGBO(45, 45, 45, 1.0),
          ),
        ),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFEDEDE5),
            Color(0xFFEDE8CD),
          ],
          stops: [0.0, 1.0],
        ),
      ),
      padding: const EdgeInsets.only(left: 2, right: 2),
      child: SizedBox(
        height: addressHeight,
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text('Address', style: TextStyle(color: Colors.black54, fontSize: 11)),
                  ),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border.fromBorderSide(BorderSide(color: Color.fromRGBO(122, 122, 255, 0.6), width: 1)),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          const SizedBox(width: 1.0),
                          Image.asset('assets/images/icon_ie_paper_16.png', width: 14, height: 14),
                          const SizedBox(width: 3.0),
                          Expanded(
                            child: SizedBox(
                              height: double.infinity,
                              child: SelectionArea(
                                child: TextField(
                                  readOnly: true,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 11,
                                    height: 1,
                                    textBaseline: TextBaseline.ideographic,
                                  ),
                                  textAlignVertical: TextAlignVertical.center,
                                  scrollPadding: EdgeInsets.zero,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    isCollapsed: true,
                                    border: InputBorder.none,
                                  ),
                                  controller: urlController,
                                  keyboardType: TextInputType.url,
                                  onSubmitted: (value) {
                                    var url = WebUri(value);
                                    if (url.scheme.isEmpty) {
                                      url = WebUri(value);
                                    }
                                    webViewController?.loadUrl(urlRequest: URLRequest(url: url));
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 3.0),
                          Image.asset('assets/images/icon_dropdown_16.png', width: 14, height: 14, fit: BoxFit.fill),
                          const SizedBox(width: 1.0),
                        ],
                      ),
                    ),
                  ),


                ],
              ),
            ),

            Transform.translate(
              offset: const Offset(0, 0.5),
              child: Container(
                height: 0.5,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(45, 45, 45, 1.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}