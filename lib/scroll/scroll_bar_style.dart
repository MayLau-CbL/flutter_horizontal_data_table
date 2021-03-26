import 'dart:ui';

import 'package:flutter/material.dart';

///Customizing scroll bar style. If not set thumbColor, other configuration will applied with the plaform system style scroll bar. If a specific Color is set for the thumb, all platform will use the [RawScrollbar] with the config set in this class.
class ScrollbarStyle {
  ///Set whether always display thumb
  final bool isAlwaysShown;

  ///Set the thickness of thumb. If thickness is null, the default value is platform dependent.
  final double? thickness;

  ///Set raius of the thumb. If radius is null, the default value is platform dependent.
  final Radius? radius;

  ///Set customized thumb color. If thumbColor is null, the default value is platform dependent.
  final Color? thumbColor;

  const ScrollbarStyle({
    this.isAlwaysShown = false,
    this.thickness,
    this.radius,
    this.thumbColor,
  });
}
