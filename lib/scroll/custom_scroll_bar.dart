import 'package:flutter/material.dart';

import 'scroll_bar_style.dart';

class CustomScrollBar extends StatelessWidget {
  final ScrollController controller;
  final ScrollbarStyle scrollbarStyle;
  final Widget child;

  const CustomScrollBar({
    Key key,
    this.controller,
    this.scrollbarStyle,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (this.scrollbarStyle?.thumbColor != null) {
      return RawScrollbar(
        controller: this.controller,
        isAlwaysShown: this.scrollbarStyle.isAlwaysShown,
        thickness: this.scrollbarStyle.thickness,
        radius: this.scrollbarStyle.radius,
        thumbColor: this.scrollbarStyle.thumbColor,
        child: this.child,
      );
    }

    return Scrollbar(
      controller: this.controller,
      isAlwaysShown: this.scrollbarStyle.isAlwaysShown,
      thickness: this.scrollbarStyle.thickness,
      radius: this.scrollbarStyle.radius,
      child: this.child,
    );
  }
}
