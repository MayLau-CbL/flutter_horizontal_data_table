import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:horizontal_data_table/refresh/pull_to_refresh/src/smart_refresher.dart';

class HDTRefreshController {
  List<RefreshController> _refreshControllers = [];
  List<RefreshController> get refreshControllers => _refreshControllers;

  /// lock requesting avoid multiple call when internal function is delaying
  bool _isRequestingRefresh = false;

  void setRefreshController(RefreshController? refreshController) {
    if (refreshController != null &&
        !_refreshControllers.contains(refreshController)) {
      registerRefreshController(refreshController);
      _refreshControllers.add(refreshController);
    }
  }

  void registerRefreshController(RefreshController? refreshController) {
    refreshController?.headerMode?.addListener(_applyUnfollowRefresh);

    ///Since the canLoading status is not always reflecting,
    ///keep using the existing way to trigger the load function
    // refreshController?.footerMode?.addListener(_applyUnfollowLoad);
  }

  void unregisterRefreshControllerListener() {
    _refreshControllers.forEach((element) {
      element.headerMode?.removeListener(_applyUnfollowRefresh);
      // element.footerMode?.removeListener(_applyUnfollowLoad);
    });
  }

  void _applyUnfollowRefresh() {
    ///after 0.0001 is for NestedScrollView of smart refresher
    Future.delayed(const Duration(milliseconds: 60), () {
      bool isAllowRefreshArea = _refreshControllers.any(
          (element) => element.headerMode?.value == RefreshStatus.canRefresh);
      bool isAllRefreshArea = _refreshControllers.every(
          (element) => element.headerMode?.value == RefreshStatus.refreshing);

      if (isAllowRefreshArea && !isAllRefreshArea) {
        if (!_isRequestingRefresh) {
          _isRequestingRefresh = true;
          requestRefresh();
        }
      } else {
        _isRequestingRefresh = false;
      }
    });
  }

  // void _applyUnfollowLoad() {
  //   bool isAllowLoadArea = _refreshControllers
  //       .any((element) => element.footerMode?.value == LoadStatus.canLoading);
  //   bool isAllLoading = _refreshControllers
  //       .every((element) => element.footerMode?.value == LoadStatus.loading);
  //   if (isAllowLoadArea && !isAllLoading) {
  //     requestLoading();
  //   }
  // }

  void requestRefresh() {
    debugPrint('requestRefresh');
    _refreshControllers.forEach((element) {
      element.requestRefresh();
    });
  }

  void refreshCompleted() {
    _refreshControllers.forEach((element) {
      element.refreshCompleted();
    });
  }

  void refreshFailed() {
    _refreshControllers.forEach((element) {
      element.refreshFailed();
    });
  }

  void requestLoading() {
    _refreshControllers.forEach((element) {
      element.requestLoading();
    });
  }

  void loadComplete() {
    _refreshControllers.forEach((element) {
      element.loadComplete();
    });
  }

  void loadNoData() {
    _refreshControllers.forEach((element) {
      element.loadNoData();
    });
  }

  void loadFailed() {
    _refreshControllers.forEach((element) {
      element.loadFailed();
    });
  }
}
