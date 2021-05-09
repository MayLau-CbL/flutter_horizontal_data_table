import 'package:flutter/material.dart';

const String topScrollControllerLabel = 'Top';
const String bottomScrollControllerLabel = 'Bottom';

class SyncHorizontalScrollControllerManager {
  SyncHorizontalScrollControllerManager();
  List<ScrollController> _registeredScrollControllers = [];
  ScrollController? _scrollingController;
  bool _scrollingActive = false;

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
                controller.jumpTo(_scrollingController?.offset ?? 0);
              }
            }
          },
        );
        return;
      }
    }
  }
}
