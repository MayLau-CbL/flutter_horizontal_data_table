import 'package:flutter/material.dart';

import 'scroll_bar_style.dart';

class CustomScrollBar extends StatelessWidget {
  final ScrollController controller;
  final ScrollbarStyle? scrollbarStyle;
  final Widget child;
  final ScrollNotificationPredicate notificationPredicate;

  const CustomScrollBar({
    Key? key,
    required this.controller,
    this.scrollbarStyle,
    required this.child,
    this.notificationPredicate = defaultScrollNotificationPredicate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (this.scrollbarStyle?.thumbColor != null) {
      return RawScrollbar(
        controller: this.controller,
        isAlwaysShown: this.scrollbarStyle?.isAlwaysShown ?? false,
        thickness: this.scrollbarStyle?.thickness,
        radius: this.scrollbarStyle?.radius,
        thumbColor: this.scrollbarStyle?.thumbColor,
        child: this.child,
        notificationPredicate: notificationPredicate,
      );
    }

    return Scrollbar(
      controller: this.controller,
      isAlwaysShown: this.scrollbarStyle?.isAlwaysShown ?? false,
      thickness: this.scrollbarStyle?.thickness,
      radius: this.scrollbarStyle?.radius,
      child: this.child,
      notificationPredicate: notificationPredicate,
    );
  }
}
