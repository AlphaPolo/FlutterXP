import 'package:flutter/material.dart';
import 'package:flutter_xp/helper/platform_logic.dart';

// import 'package:window_manager/window_manager.dart';

import 'initialize_helper.dart';

PlatformInit createStrategyInit() => WindowsPlatformInit();

class WindowsPlatformInit implements PlatformInit {
  @override
  Future<void> init() async {
    PlatformLogic.instance.languageGetter = (context) => Localizations.localeOf(context).languageCode;
    WidgetsFlutterBinding.ensureInitialized();

    // await windowManager.ensureInitialized();
    //
    // WindowOptions windowOptions = const WindowOptions(
    //   size: Size(800, 600),
    //   maximumSize: Size(800, 600),
    //   minimumSize: Size(800, 600),
    //   center: true,
    //   backgroundColor: Colors.transparent,
    //   skipTaskbar: false,
    //   titleBarStyle: TitleBarStyle.hidden,
    // );
    // windowManager.waitUntilReadyToShow(windowOptions, () async {
    //   await windowManager.show();
    //   await windowManager.focus();
    // });
  }
}
