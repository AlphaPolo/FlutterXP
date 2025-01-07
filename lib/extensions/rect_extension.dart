import 'dart:ui';

extension RectExtension on Rect {

  Rect copyWith({
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return Rect.fromLTRB(
      left ?? this.left,
      top ?? this.top,
      right ?? this.right,
      bottom ?? this.bottom,
    );
  }


  Rect expand({
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    if(left != null) left = this.left + left;
    if(top != null) top = this.top + top;
    if(right != null) right = this.right + right;
    if(bottom != null) bottom = this.bottom + bottom;

    return copyWith(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
    );
  }
}