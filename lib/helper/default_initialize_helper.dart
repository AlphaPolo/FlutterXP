import 'dart:html' as htmlfile;
import 'package:flutter/material.dart';
import 'package:flutter_xp/helper/platform_logic.dart';

import 'initialize_helper.dart';


PlatformInit createStrategyInit() => DefaultPlatformInit();

class DefaultPlatformInit implements PlatformInit {
  @override
  Future<void> init() async {
    htmlfile.window.document.onContextMenu.listen((evt) => evt.preventDefault());
    PlatformLogic.instance.languageGetter = (context) => htmlfile.window.navigator.language;
    WidgetsFlutterBinding.ensureInitialized();
  }
}
