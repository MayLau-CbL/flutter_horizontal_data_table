import 'package:horizontal_data_table/refresh/pull_to_refresh/src/smart_refresher.dart';

class HDTRefreshController {
  List<RefreshController> _refreshControllers = [];
  List<RefreshController> get refreshControllers => _refreshControllers;

  void setRefreshController(RefreshController? refreshController) {
    if (refreshController != null &&
        !_refreshControllers.contains(refreshController)) {
      _refreshControllers.add(refreshController);
    }
  }

  void requestRefresh([
    RefreshController? skipThisController,
  ]) {
    _refreshControllers.forEach((element) {
      if (element != skipThisController) {
        element.requestRefresh();
      }
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

  void requestLoading([RefreshController? skipThisController]) {
    _refreshControllers.forEach((element) {
      if (element != skipThisController) {
        element.requestLoading();
      }
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
