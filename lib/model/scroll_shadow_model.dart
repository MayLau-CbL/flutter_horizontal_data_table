import 'package:flutter/material.dart';

class ScrollShadowModel extends ChangeNotifier {
  double _verticalOffset = 0.0;
  double _horizontalOffset = 0.0;

  double get verticalOffset => _verticalOffset;

  set verticalOffset(double value) {
    _verticalOffset = value;
    notifyListeners();
  }

  double get horizontalOffset => _horizontalOffset;

  set horizontalOffset(double value) {
    _horizontalOffset = value;
    notifyListeners();
  }
}
