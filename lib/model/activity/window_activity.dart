import 'package:flutter/material.dart';
import 'package:flutter_xp/constant/window_constant.dart';

enum WindowSizeStrategy {
  interactiveSize,
  wrapContent,
}

/// window 活動
class WindowActivity {
  /// 一個activity只會有一個id
  final String activityId;
  /// 標題
  late final ValueNotifier<String> title;
  late final ValueNotifier<String> iconAsset;
  final WindowSizeStrategy sizeStrategy;


  /// 最小化
  late final ValueNotifier<bool> isMinimized;

  /// 全螢幕
  late final ValueNotifier<bool> isFullScreen;

  /// 可拉伸
  late final ValueNotifier<bool> resizeable;

  /// 可返回上一頁
  late final ValueNotifier<bool> canGoBack;

  final FocusNode focusNode = FocusNode();

  /// 目前的顯示區域
  /// 當全螢幕的時候此參數失效
  late final ValueNotifier<Rect> rect;

  MenuGetter? menuGetter;
  Widget content;
  Widget? actionBar;

  VoidCallback? backAction;
  VoidCallback? refreshAction;
  ValueVoidCallback<String>? customAction;

  /// 用來放activity的客製化參數
  Map<String, dynamic>? extras;


  WindowActivity({
    required this.activityId,
    required String title,
    required String iconAsset,
    required this.content,
    this.actionBar,
    this.sizeStrategy = WindowSizeStrategy.interactiveSize,
    Rect rect = WindowConstant.defaultRect,
    bool isMinimized = false,
    bool isFullScreen = false,
    bool resizeable = true,
    this.menuGetter,
    this.extras,
  }) {
    this.title = ValueNotifier<String>(title);
    this.iconAsset = ValueNotifier<String>(iconAsset);
    this.isMinimized = ValueNotifier<bool>(isMinimized);
    this.isFullScreen = ValueNotifier<bool>(isFullScreen);
    this.resizeable = ValueNotifier<bool>(resizeable);
    this.rect = ValueNotifier<Rect>(rect);
    canGoBack = ValueNotifier(false);
  }

  void dispose() {
    // super.dispose();
    title.dispose();
    isMinimized.dispose();
    isFullScreen.dispose();
    resizeable.dispose();
    rect.dispose();
    focusNode.dispose();
    canGoBack.dispose();
    backAction = null;
    refreshAction = null;
    customAction = null;
  }

  void updateNavigation(bool canGoBack) {
    this.canGoBack.value = canGoBack;
  }

  void onBackPress() {
    backAction?.call();
  }

  void onRefresh() {
    refreshAction?.call();
  }

  /// ActionBar觸發的客製化Action，用來處理menuEntry點擊的事件
  void onCustomAction(String action) {
    customAction?.call(action);
  }
}