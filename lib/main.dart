import 'package:flutter/material.dart';
import 'package:flutter_xp/util/my_print.dart';

import 'flutter_xp.dart';
import 'helper/initialize_helper.dart'
if(dart.library.io) 'helper/windows_initialize_helper.dart'
if(dart.library.html) 'helper/default_initialize_helper.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey();

void main() async {
  await createStrategyInit().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      onNavigationNotification:  (notification) {
        myPrint('onNavigationNotification: $notification');
        return false;
      },
      debugShowCheckedModeBanner: false,
      title: 'FlutterXP',
      home: const FlutterXP(),
    );
  }
}