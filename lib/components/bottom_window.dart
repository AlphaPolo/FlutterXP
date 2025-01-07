import 'package:flutter/material.dart';
import 'package:flutter_xp/model/activity/window_activity.dart';

class BottomWindow extends StatelessWidget {
  final WindowActivity activity;

  const BottomWindow({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([activity.focusNode, activity.isMinimized]),
      builder: (context, child) {
        return Container(
          constraints: const BoxConstraints(maxWidth: 150),
          margin: const EdgeInsets.only(top: 2, right: 2),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          height: 22,
          decoration: getDecoration(activity.focusNode.hasFocus, activity.isMinimized.value),
          child: child,
        );
      },
      child: GestureDetector(
        onTap: () {

          /// 如果當前視窗是縮小模式
          /// 進行回到視窗模式並且取得focus
          if(activity.isMinimized.value) {
            activity.isMinimized.value = false;
            activity.focusNode.requestFocus();
          }
          /// 如果不是縮小模式則看是不是正在focus
          /// 如果正在focus就縮小
          else if(activity.focusNode.hasFocus){
            activity.isMinimized.value = true;
          }
          else {
            activity.focusNode.requestFocus();
          }

        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image(image: AssetImage(activity.iconAsset.value), width: 15, height: 15),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                activity.title.value,
                style: const TextStyle(color: Colors.white, fontSize: 11),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );


  }

  BoxDecoration getDecoration(bool isFocus, bool isMinimized) {
    return switch ((isFocus, isMinimized)) {
      /// isFocus 然後不等於最小化
      (true, false) => BoxDecoration(
          color: const Color.fromRGBO(30, 82, 183, 1.0),
          borderRadius: const BorderRadius.all(Radius.circular(2)),
          border: Border.all(width: 0.5, color: const Color.fromRGBO(0, 0, 0, 0.7)),
        ),
      /// 其他視同 unfocus樣式
      (_, _) => BoxDecoration(
          color: const Color.fromRGBO(60, 129, 243, 1.0),
          borderRadius: const BorderRadius.all(Radius.circular(2)),
          border: Border.all(width: 0.5, color: const Color.fromRGBO(0, 0, 0, 0.2)),
        ),
    };
  }
}
