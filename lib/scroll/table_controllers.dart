import 'package:flutter/material.dart';
import 'package:horizontal_data_table/refresh/hdt_refresh_controller.dart';
import 'package:horizontal_data_table/refresh/pull_to_refresh/src/smart_refresher.dart';
import 'package:horizontal_data_table/scroll/linked_scroll_controller/linked_scroll_controller.dart';

class TableControllers {
  late LinkedScrollControllerGroup _controllersGroup;
  late ScrollController fixedSideListViewScrollController;
  late ScrollController bidirectionalSideListViewScrollController;

  late LinkedScrollControllerGroup _horizontalControllersGroup;
  late ScrollController bidirectionalSideHorizontalScrollController;
  ScrollController? bidirectionalSideHeaderHorizontalScrollController;
  ScrollController? bidirectionalSideFooterHorizontalScrollController;

  late RefreshController bidirectionalSideRefreshController;
  late RefreshController fixedSideRefreshController;

  final HDTRefreshController? htdRefreshController;
  final bool isFixedHeader;
  final bool isFixedFooter;
  final bool enablePullToRefresh;

  TableControllers({
    required this.isFixedHeader,
    required this.isFixedFooter,
    required this.enablePullToRefresh,
    this.htdRefreshController,
  });

  void init() {
    _initVerticalControllers();
    _initBidirectionalSideHorizontalScrollController();
    _initBidirectionalSideHorizontalHeaderScrollController();
    _initBidirectionalSideHorizontalFooterScrollController();
    _initRefreshController();
  }

  void dispose() {
    removeHorizontalShadowListener();
    fixedSideListViewScrollController.dispose();
    bidirectionalSideListViewScrollController.dispose();
    bidirectionalSideHorizontalScrollController.dispose();
    if (isFixedHeader) {
      bidirectionalSideHeaderHorizontalScrollController?.dispose();
    }
    if (isFixedFooter) {
      bidirectionalSideFooterHorizontalScrollController?.dispose();
    }
  }

  void _initVerticalControllers() {
    _controllersGroup = LinkedScrollControllerGroup();
    fixedSideListViewScrollController = _controllersGroup.addAndGet();
    bidirectionalSideListViewScrollController = _controllersGroup.addAndGet();
  }

  void _initBidirectionalSideHorizontalScrollController() {
    _horizontalControllersGroup = LinkedScrollControllerGroup();
    bidirectionalSideHorizontalScrollController =
        _horizontalControllersGroup.addAndGet();
  }

  void _initBidirectionalSideHorizontalHeaderScrollController() {
    if (isFixedHeader) {
      bidirectionalSideHeaderHorizontalScrollController =
          _horizontalControllersGroup.addAndGet();
    }
  }

  void _initBidirectionalSideHorizontalFooterScrollController() {
    if (isFixedFooter) {
      bidirectionalSideFooterHorizontalScrollController =
          _horizontalControllersGroup.addAndGet();
    }
  }

  void _initRefreshController() {
    bidirectionalSideRefreshController =
        RefreshController(initialRefresh: false);
    fixedSideRefreshController = RefreshController(initialRefresh: false);
    htdRefreshController
        ?.setRefreshController(bidirectionalSideRefreshController);
    htdRefreshController?.setRefreshController(fixedSideRefreshController);
  }

  Function()? _horizontalShadowListener;

  void addHorizontalShadowListener(Function() horizontalShadowListener) {
    _horizontalShadowListener = horizontalShadowListener;
    bidirectionalSideHorizontalScrollController
        .addListener(_horizontalShadowListener!);
  }

  void removeHorizontalShadowListener() {
    if (_horizontalShadowListener != null) {
      bidirectionalSideHorizontalScrollController
          .removeListener(_horizontalShadowListener!);
    }
  }

  Function()? _verticalShadowListener;

  void addVerticalShadowListener(Function() verticalShadowListener) {
    _verticalShadowListener = verticalShadowListener;
    bidirectionalSideListViewScrollController
        .addListener(_verticalShadowListener!);
  }

  void removeVerticalShadowListener() {
    if (_verticalShadowListener != null) {
      bidirectionalSideListViewScrollController
          .removeListener(_verticalShadowListener!);
    }
  }
}
