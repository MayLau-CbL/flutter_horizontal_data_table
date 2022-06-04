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

  static double getElevation(double? offset, double maxElevation) {
    if (offset != null) {
      double elevation =
          (offset * 1) > maxElevation ? maxElevation : (offset * 1);
      if (elevation >= 0) {
        return elevation;
      }
    }
    return 0.0;
  }

  static int getShadowAlpha(
      double calculatedElevation, double widgetElevation) {
    if (widgetElevation > 0) {
      return 10 * calculatedElevation ~/ widgetElevation;
    }
    return 0;
  }
}
