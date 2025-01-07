
import 'package:flutter/material.dart';
import 'package:flutter_xp/model/activity/window_activity.dart';

class WindowActivityNotification extends Notification {
  final BuildContext context;
  final WindowActivity? activity;

  const WindowActivityNotification({
    required this.context,
    required this.activity,
  });
}

class OpenWindowActivityNotification extends WindowActivityNotification {
  const OpenWindowActivityNotification({
    required super.context,
    required super.activity,
  });
}

class DeleteWindowActivityNotification extends WindowActivityNotification {
  const DeleteWindowActivityNotification({
    required super.context,
    required super.activity,
  });
}