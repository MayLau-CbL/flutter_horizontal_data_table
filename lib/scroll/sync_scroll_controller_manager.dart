import 'package:flutter/material.dart';

import '../refresh/pull_to_refresh/pull_to_refresh.dart';

const String leftScrollControllerLabel = 'Left';
const String rightScrollControllerLabel = 'Right';

class SyncScrollControllerManager {
  SyncScrollControllerManager(RefreshController? refreshController,
      [double refreshIndicatorHeight = 0.0]) {
    _refreshController = refreshController;
    _refreshIndicatorHeight = refreshIndicatorHeight;
  }
  List<ScrollController> _registeredScrollControllers = [];
  ScrollController? _scrollingController;
  bool _scrollingActive = false;

  ///Refresh related
  RefreshController? _refreshController;
  double _refreshIndicatorHeight = 0.0;

  void registerScrollController(ScrollController controller) {
    _registeredScrollControllers.add(controller);
  }

  void unregisterScrollController(ScrollController controller) {
    _registeredScrollControllers.remove(controller);
  }

  void processNotification(
      ScrollNotification notification, ScrollController sender, String label) {
    if (notification is ScrollStartNotification && !_scrollingActive) {
      _scrollingController = sender;
      _scrollingActive = true;
      return;
    }

    if (identical(sender, _scrollingController) && _scrollingActive) {
      if (notification is ScrollEndNotification) {
        _scrollingController = null;
        _scrollingActive = false;
        return;
      }

      if (notification is ScrollUpdateNotification) {
        _registeredScrollControllers.forEach(
          (controller) {
            if (!identical(_scrollingController, controller)) {
              if (controller.hasClients) {
                if (_refreshController != null) {
                  switch (label) {
                    case leftScrollControllerLabel:
                      {
                        if (_scrollingController != null) {
                          _syncRightListViewScrollVontroller(
                              _scrollingController!, controller);
                        }
                        break;
                      }
                    case rightScrollControllerLabel:
                      {
                        if (_scrollingController != null) {
                          _syncLeftListViewScrollVontroller(
                              _scrollingController!, controller);
                        }
                        break;
                      }
                  }
                } else {
                  controller.jumpTo(_scrollingController?.offset ?? 0);
                }
              }
            }
          },
        );
        return;
      }
    }
  }

  void _syncLeftListViewScrollVontroller(
      ScrollController _scrollingController, ScrollController controller) {
    if (_refreshController?.headerStatus != null) {
      switch (_refreshController?.headerStatus) {
        case RefreshStatus.canRefresh:
          {
            controller.jumpTo(_scrollingController.offset);
            break;
          }
        case RefreshStatus.refreshing:
          {
            controller.jumpTo(_refreshIndicatorHeight * -1);
            break;
          }
        default:
          {
            if (_scrollingController.offset < (_refreshIndicatorHeight * -1)) {
              controller.jumpTo(_refreshIndicatorHeight * -1);
            } else {
              controller.jumpTo(_scrollingController.offset);
            }
            break;
          }
      }
    } else {
      controller.jumpTo(_scrollingController.offset);
    }
  }

  void _syncRightListViewScrollVontroller(
      ScrollController _scrollingController, ScrollController controller) {
    if (_refreshController?.headerStatus != null) {
      switch (_refreshController?.headerStatus) {
        case RefreshStatus.idle:
          {
            if (!_scrollingController.position.outOfRange) {
              controller.jumpTo(_scrollingController.offset);
            } else {
              if (_scrollingController.offset <= 0.0) {
                _scrollingController
                    .jumpTo(_scrollingController.position.minScrollExtent);
              } else {
                _scrollingController
                    .jumpTo(_scrollingController.position.maxScrollExtent);
              }
            }
            break;
          }
        default:
          {
            break;
          }
      }
    } else {
      controller.jumpTo(_scrollingController.offset);
    }
  }
}
