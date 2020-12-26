import 'package:pull_to_refresh/pull_to_refresh.dart';

class HDTRefreshController {
  RefreshController _refreshController;

  void setRefreshController(RefreshController refreshController) {
    _refreshController = refreshController;
  }

  void refreshCompleted() {
    _refreshController?.refreshCompleted();
  }

  void refreshFailed() {
    _refreshController?.refreshFailed();
  }
}
