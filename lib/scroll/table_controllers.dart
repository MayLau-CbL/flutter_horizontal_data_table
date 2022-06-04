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

  RefreshController? bidirectionalSideRefreshController;
  RefreshController? fixedSideRefreshController;

  final HDTRefreshController? htdRefreshController;
  final bool isFixedHeader;
  final bool enablePullToRefresh;

  TableControllers({
    required this.isFixedHeader,
    required this.enablePullToRefresh,
    this.htdRefreshController,
  });

  void init() {
    _initVerticalControllers();
    _initBidirectionalSideHorizontalScrollController();
    _initBidirectionalSideHorizontalHeaderScrollController();
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

  void _initRefreshController() {
    if (enablePullToRefresh) {
      bidirectionalSideRefreshController =
          RefreshController(initialRefresh: false);
      fixedSideRefreshController = RefreshController(initialRefresh: false);
      htdRefreshController
          ?.setRefreshController(bidirectionalSideRefreshController);
      htdRefreshController?.setRefreshController(fixedSideRefreshController);
    }
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
