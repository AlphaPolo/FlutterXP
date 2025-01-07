import 'package:flutter/foundation.dart';
import 'package:flutter_xp/model/desktop/desktop_models.dart';

class SelectionProvider extends ChangeNotifier {

  DeskTopModel? selectedModel;


  void setSelectedModel(DeskTopModel? model) {
    selectedModel = model;
    notifyListeners();
  }
}