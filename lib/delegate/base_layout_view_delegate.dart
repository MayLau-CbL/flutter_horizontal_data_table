import 'package:flutter/material.dart';

class TableBaseLayoutDelegate extends MultiChildLayoutDelegate {
  final bool isRTL;
  final double widgetHeight;
  final double widgetWidth;
  final double headerWidth;
  final double middleShadowWidth;

  TableBaseLayoutDelegate(
    this.widgetHeight,
    this.widgetWidth,
    this.headerWidth,
    this.middleShadowWidth, [
    this.isRTL = false,
  ]);

  @override
  void performLayout(Size size) {
    if (isRTL) {
      _performRTLLayout(size);
    } else {
      _performLTRLayout(size);
    }
  }

  void _performLTRLayout(Size size) {
    Size fixedSideListViewSize = Size.zero;

    if (hasChild(BaseLayoutView.FixedColumnListView)) {
      fixedSideListViewSize = layoutChild(
        BaseLayoutView.FixedColumnListView,
        BoxConstraints(
          maxHeight: this.widgetHeight,
          maxWidth: this.headerWidth,
        ),
      );

      positionChild(
        BaseLayoutView.FixedColumnListView,
        Offset(0, 0),
      );
    }

    if (hasChild(BaseLayoutView.BiDirectionScrollListView)) {
      layoutChild(
        BaseLayoutView.BiDirectionScrollListView,
        BoxConstraints(
          maxHeight: this.widgetHeight,
          maxWidth: this.widgetWidth - fixedSideListViewSize.width,
        ),
      );

      positionChild(
        BaseLayoutView.BiDirectionScrollListView,
        Offset(fixedSideListViewSize.width, 0),
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
        Offset(fixedSideListViewSize.width, 0),
      );
    }
  }

  void _performRTLLayout(Size size) {
    Size fixedSideListViewSize = Size.zero;
    Size bidirectionalSideListViewSize = Size.zero;

    if (hasChild(BaseLayoutView.FixedColumnListView)) {
      fixedSideListViewSize = layoutChild(
        BaseLayoutView.FixedColumnListView,
        BoxConstraints(
          maxHeight: this.widgetHeight,
          maxWidth: this.headerWidth,
        ),
      );

      positionChild(
        BaseLayoutView.FixedColumnListView,
        Offset(this.widgetWidth - fixedSideListViewSize.width, 0),
      );
    }

    if (hasChild(BaseLayoutView.BiDirectionScrollListView)) {
      bidirectionalSideListViewSize = layoutChild(
        BaseLayoutView.BiDirectionScrollListView,
        BoxConstraints(
          maxHeight: this.widgetHeight,
          maxWidth: this.widgetWidth - fixedSideListViewSize.width,
        ),
      );

      positionChild(
        BaseLayoutView.BiDirectionScrollListView,
        Offset(0, 0),
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
        Offset(bidirectionalSideListViewSize.width - this.middleShadowWidth, 0),
      );
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return this != oldDelegate;
  }
}

enum BaseLayoutView {
  FixedColumnListView,
  BiDirectionScrollListView,
  MiddleShadow,
  Divider
}
