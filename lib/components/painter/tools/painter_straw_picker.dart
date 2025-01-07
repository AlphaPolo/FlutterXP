import 'dart:ui';

import 'painter_paint_content.dart';

class PainterStrawPicker extends CustomPainterContent {

  Function(bool, Color?)? onColorPick;

  PainterStrawPicker({
    this.onColorPick,
  });

  @override
  void onPaintDown(PainterDrawingController controller, bool isPrimary, Offset offset) {
    _getColorAt(controller, offset).then((color) {
      // if(isPrimary) {
      //   controller.setStyle(
      //     primaryColor: color,
      //   );
      // }
      // else {
      //   controller.setStyle(
      //     secondaryColor: color,
      //   );
      // }

      onColorPick?.call(isPrimary, color);
    });
  }

  @override
  void onPaintUp(Offset offset) {
    // TODO: implement onPaintUp
  }

  @override
  void onPaintUpdate(Offset offset) {
    // TODO: implement onPaintUpdate
  }

  Future<Color?> _getColorAt(PainterDrawingController controller, Offset position) async {
    final image = controller.cachedImage;
    if (image == null) return null;

    final byteData = await image.toByteData(format: ImageByteFormat.rawRgba);
    if (byteData == null) return null;

    final width = image.width;
    final pixelOffset = (position.dy.toInt() * width + position.dx.toInt()) * 4;

    final r = byteData.getUint8(pixelOffset);
    final g = byteData.getUint8(pixelOffset + 1);
    final b = byteData.getUint8(pixelOffset + 2);
    final a = byteData.getUint8(pixelOffset + 3);

    return Color.fromARGB(a, r, g, b);
  }

}