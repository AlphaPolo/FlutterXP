
import 'package:flutter/material.dart';

class PlatformLogic {
  static final PlatformLogic _instance = PlatformLogic._();

  String Function(BuildContext context)? languageGetter;

  static PlatformLogic get instance => _instance;

  PlatformLogic._();

  String getLocaleLanguage(BuildContext context) => languageGetter!.call(context);
}