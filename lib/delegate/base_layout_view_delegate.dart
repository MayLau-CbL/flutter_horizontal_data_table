import 'package:flutter/material.dart';

class TableBaseLayoutDelegate extends MultiChildLayoutDelegate {
  final double widgetHeight;
  final double widgetWidth;
  final double headerWidth;
  final double middleShadowWidth;

  TableBaseLayoutDelegate(
    this.widgetHeight,
    this.widgetWidth,
    this.headerWidth,
    this.middleShadowWidth,
  );

  @override
  void performLayout(Size size) {
    Size leftListViewSize = Size.zero;

    if (hasChild(BaseLayoutView.LeftListView)) {
      leftListViewSize = layoutChild(
        BaseLayoutView.LeftListView,
        BoxConstraints(
          maxHeight: this.widgetHeight,
          maxWidth: this.headerWidth,
        ),
      );

      positionChild(
        BaseLayoutView.LeftListView,
        Offset(0, 0),
      );
    }

    if (hasChild(BaseLayoutView.RightListView)) {
      layoutChild(
        BaseLayoutView.RightListView,
        BoxConstraints(
          maxHeight: this.widgetHeight,
          maxWidth: this.widgetWidth - leftListViewSize.width,
        ),
      );

      positionChild(
        BaseLayoutView.RightListView,
        Offset(leftListViewSize.width, 0),
      );
    }

    if (hasChild(BaseLayoutView.MiddleShadow)) {
      layoutChild(
        BaseLayoutView.MiddleShadow,
        BoxConstraints(
          maxHeight: this.widgetHeight,
          maxWidth: this.middleShadowWidth,
        ),
      );

      positionChild(
        BaseLayoutView.MiddleShadow,
        Offset(leftListViewSize.width, 0),
      );
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return this != oldDelegate;
  }
}

enum BaseLayoutView { LeftListView, RightListView, MiddleShadow, Divider }
