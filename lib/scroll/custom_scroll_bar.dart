import 'package:flutter/material.dart';

import 'scroll_bar_style.dart';

class CustomScrollBar extends StatelessWidget {
  final ScrollController controller;
  final ScrollbarStyle? scrollbarStyle;
  final Widget child;
  final ScrollNotificationPredicate? scrollNotificationPredicate;

  const CustomScrollBar({
    Key? key,
    required this.controller,
    this.scrollbarStyle,
    required this.child,
    this.scrollNotificationPredicate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScrollNotificationPredicate snp = scrollNotificationPredicate ??
        (scrollNotification) {
          return scrollNotification.depth == 0;
        };
    if (this.scrollbarStyle?.thumbColor != null) {
      return RawScrollbar(
        controller: this.controller,
        isAlwaysShown: this.scrollbarStyle?.isAlwaysShown ?? false,
        thickness: this.scrollbarStyle?.thickness,
        radius: this.scrollbarStyle?.radius,
        thumbColor: this.scrollbarStyle?.thumbColor,
        notificationPredicate: snp,
        child: this.child,
      );
    }

    return Scrollbar(
      controller: this.controller,
      isAlwaysShown: this.scrollbarStyle?.isAlwaysShown ?? false,
      thickness: this.scrollbarStyle?.thickness,
      radius: this.scrollbarStyle?.radius,
      notificationPredicate: snp,
      child: this.child,
    );
  }
}
