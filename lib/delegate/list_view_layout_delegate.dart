import 'package:flutter/material.dart';

class ListViewLayoutDelegate extends MultiChildLayoutDelegate {
  final double widgetHeight;
  final double widgetWidth;
  final double shadowHeight;

  ListViewLayoutDelegate(
      this.widgetHeight, this.widgetWidth, this.shadowHeight);

  @override
  void performLayout(Size size) {
    Size headerSize = Size.zero;
    Size dividerSize = Size.zero;
    if (hasChild(ListViewLayout.Header)) {
      headerSize = layoutChild(
        ListViewLayout.Header,
        BoxConstraints(
            maxWidth: this.widgetWidth, maxHeight: this.widgetHeight),
      );

      positionChild(
        ListViewLayout.Header,
        Offset(0, 0),
      );
    }

    if (hasChild(ListViewLayout.Divider)) {
      dividerSize = layoutChild(
        ListViewLayout.Divider,
        BoxConstraints(
          maxWidth: this.widgetWidth,
        ),
      );

      positionChild(
        ListViewLayout.Divider,
        Offset(0, headerSize.height),
      );
    }

    if (hasChild(ListViewLayout.ListView)) {
      layoutChild(
        ListViewLayout.ListView,
        BoxConstraints(
          maxHeight: this.widgetHeight - headerSize.height,
          maxWidth: this.widgetWidth,
        ),
      );

      positionChild(
        ListViewLayout.ListView,
        Offset(0, headerSize.height + dividerSize.height),
      );
    }

    if (hasChild(ListViewLayout.Shadow)) {
      layoutChild(
        ListViewLayout.Shadow,
        BoxConstraints(
          maxHeight: this.shadowHeight,
          maxWidth: this.widgetWidth,
        ),
      );

      positionChild(
        ListViewLayout.Shadow,
        Offset(0, headerSize.height + dividerSize.height),
      );
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return this != oldDelegate;
  }
}

enum ListViewLayout { Header, ListView, Shadow, Divider }
