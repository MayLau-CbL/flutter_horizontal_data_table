///Exxport File

///Wrapper Controller
export 'package:horizontal_data_table/refresh/hdt_refresh_controller.dart';

///Available Refresh Header
export 'package:horizontal_data_table/refresh/pull_to_refresh/src/indicator/classic_indicator.dart';
export 'package:horizontal_data_table/refresh/pull_to_refresh/src/indicator/waterdrop_header.dart';
export 'package:horizontal_data_table/refresh/pull_to_refresh/src/indicator/custom_indicator.dart';
export 'package:horizontal_data_table/refresh/pull_to_refresh/src/indicator/link_indicator.dart';
export 'package:horizontal_data_table/refresh/pull_to_refresh/src/indicator/material_indicator.dart';
export 'package:horizontal_data_table/refresh/pull_to_refresh/src/indicator/material_indicator.dart';
export 'package:horizontal_data_table/refresh/pull_to_refresh/src/indicator/bezier_indicator.dart';

///Main File
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/model/scroll_shadow_model.dart';
import 'package:horizontal_data_table/refresh/non_bounce_back_scroll_physics.dart';
import 'package:horizontal_data_table/refresh/hdt_refresh_controller.dart';
import 'package:horizontal_data_table/refresh/pull_to_refresh/src/smart_refresher.dart';

import 'package:provider/provider.dart';

///
/// For sorting issue, will based on the header fixed widget for flexible handling, suggest using [FlatButton] to control the data sorting
///
///
class HorizontalDataTable extends StatefulWidget {
  final double leftHandSideColumnWidth;
  final double rightHandSideColumnWidth;

  ///if headerWidgets==true,
  ///HorizontalDataTable.headerWidgets[0] as the left hand side header
  ///
  /// if headerWidgets==false
  /// header handling will handle by the itembuilder or the first child -> index == 0
  ///
  /// if no header needed, just ignore this, start data from index ==0
  ///
  final bool isFixedHeader;
  final List<Widget> headerWidgets;

  ///Direct create children
  final List<Widget> leftSideChildren;
  final List<Widget> rightSideChildren;

  ///Suggest use builder for easier manage, like data update
  final int itemCount;
  final IndexedWidgetBuilder leftSideItemBuilder;
  final IndexedWidgetBuilder rightSideItemBuilder;

  ///Row Divider

  ///This is apply to all remaining data row of the list view
  final Widget rowSeparatorWidget;

  ///Elevation for the shadow of header row and first column after scroll
  ///If don't want to show the shadow, please set it to 0.0
  final double elevation;
  final Color elevationColor;

  final Color leftHandSideColBackgroundColor;
  final Color rightHandSideColBackgroundColor;

  ///Flag to indicate whether enable the pull_to_refresh function
  ///Default is false
  final bool enablePullToRefresh;

  ///Support using pull-to-refresh's refresh indicator
  ///Please update the indicator height in order to sync the height when loading.
  final double refreshIndicatorHeight;

  ///Support using pull-to-refresh's refresh indicator
  final Widget refreshIndicator;

  ///Callback for pulled to refresh.
  ///Call HDTRefreshController.refreshCompleted() for finished refresh loading.
  ///Call HDTRefreshController.refreshFailed() for error refresh loading.
  final Function onRefresh;

  ///This is a wrapper controller for limilating using the available refresh controller function. Currently only refresh fail and complete is implemented.
  final HDTRefreshController htdRefreshController;

  const HorizontalDataTable({
    @required this.leftHandSideColumnWidth,
    @required this.rightHandSideColumnWidth,
    this.isFixedHeader = false,
    this.headerWidgets,
    this.leftSideItemBuilder,
    this.rightSideItemBuilder,
    this.itemCount = 0,
    this.leftSideChildren,
    this.rightSideChildren,
    this.rowSeparatorWidget = const Divider(
      color: Colors.transparent,
      height: 0.0,
      thickness: 0.0,
    ),
    this.elevation = 3.0,
    this.elevationColor = Colors.black54,
    this.leftHandSideColBackgroundColor = Colors.white,
    this.rightHandSideColBackgroundColor = Colors.white,
    this.enablePullToRefresh = false,
    this.refreshIndicatorHeight = 60.0,
    this.htdRefreshController,
    this.onRefresh,
    this.refreshIndicator,
  })  : assert(
            (leftSideChildren == null && leftSideItemBuilder != null) ||
                (leftSideChildren != null),
            'Either using itemBuilder or children to assign left side widgets'),
        assert(
            (rightSideChildren == null && rightSideItemBuilder != null) ||
                (rightSideChildren != null),
            'Either using itemBuilder or children to assign right side widgets'),
        assert((isFixedHeader && headerWidgets != null) || !isFixedHeader,
            'If use fixed top row header, isFixedHeader==true, headerWidgets must not be null'),
        assert(itemCount >= 0, 'itemCount must >= 0'),
        assert(elevation >= 0.0, 'elevation must >= 0.0'),
        assert(elevationColor != null, 'elevationColor must not be null'),
        assert(
            (enablePullToRefresh && refreshIndicatorHeight >= 0.0) ||
                !enablePullToRefresh,
            'refreshIndicator must >= 0 if pull to refresh is enabled'),
        assert(
            (enablePullToRefresh && refreshIndicator != null) ||
                !enablePullToRefresh,
            'refreshIndicator must not be null if pull to refresh is enabled'),
        assert(
            (enablePullToRefresh && htdRefreshController != null) ||
                !enablePullToRefresh,
            'htdRefreshController must not be null if pull to refresh is enabled'),
        assert(
            (enablePullToRefresh && onRefresh != null) || !enablePullToRefresh,
            'onRefresh must not be null if pull to refresh is enabled');

  @override
  State<StatefulWidget> createState() {
    return _HorizontalDataTableState();
  }
}

class _HorizontalDataTableState extends State<HorizontalDataTable> {
  ScrollController _leftHandSideListViewScrollController =
      ScrollController(debugLabel: 'Left');
  ScrollController _rightHandSideListViewScrollController =
      ScrollController(debugLabel: 'Right');
  ScrollController _rightHorizontalScrollController = ScrollController();

  ScrollShadowModel _scrollShadowModel = ScrollShadowModel();

  _SyncScrollControllerManager _syncScroller;
  RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    if (widget.enablePullToRefresh) {
      _refreshController = RefreshController(initialRefresh: false);
      widget.htdRefreshController.setRefreshController(_refreshController);
      _syncScroller = _SyncScrollControllerManager(
          _refreshController, widget.refreshIndicatorHeight);
    } else {
      _syncScroller = _SyncScrollControllerManager(_refreshController);
    }

    _syncScroller
        .registerScrollController(_leftHandSideListViewScrollController);
    _syncScroller
        .registerScrollController(_rightHandSideListViewScrollController);
    _leftHandSideListViewScrollController.addListener(() {
      _scrollShadowModel.verticalOffset =
          _leftHandSideListViewScrollController.offset;
      setState(() {});
    });
    _rightHorizontalScrollController.addListener(() {
      _scrollShadowModel.horizontalOffset =
          _rightHorizontalScrollController.offset;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _syncScroller
        .unregisterScrollController(_leftHandSideListViewScrollController);
    _syncScroller
        .unregisterScrollController(_rightHandSideListViewScrollController);
    _leftHandSideListViewScrollController.dispose();
    _rightHandSideListViewScrollController.dispose();
    _rightHorizontalScrollController.dispose();
    widget.htdRefreshController.setRefreshController(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ScrollShadowModel>(
      create: (context) => _scrollShadowModel,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, boxConstraint) {
            return _getParallelListView(
                boxConstraint.maxWidth, boxConstraint.maxHeight);
          },
        ),
      ),
    );
  }

  Widget _getParallelListView(double width, double height) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: widget.leftHandSideColumnWidth,
          height: height,
          width: width - widget.leftHandSideColumnWidth,
          child: SingleChildScrollView(
            controller: _rightHorizontalScrollController,
            child: Container(
              color: widget.rightHandSideColBackgroundColor,
              child: _getRightSideHeaderScrollColumn(),
              width: widget.rightHandSideColumnWidth,
            ),
            scrollDirection: Axis.horizontal,
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          height: height,
          width: widget.leftHandSideColumnWidth,
          child: Selector<ScrollShadowModel, double>(
            selector: (context, scrollShadowModel) {
              return scrollShadowModel?.horizontalOffset ?? 0;
            },
            child: Container(
              width: widget.leftHandSideColumnWidth,
              child: _getLeftSideFixedHeaderScrollColumn(),
            ),
            builder: (context, horizontalOffset, child) {
              return Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Container(
                        //force table background to be transaparent to adopt the color behide this table
//                      color: widget.leftHandSideColBackgroundColor,
//                      child: child,
//                      elevation: _getElevation(horizontalOffset),
                        decoration: BoxDecoration(
                      color: widget.rightHandSideColBackgroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: widget.elevationColor.withAlpha(
                              _getShadowAlpha(_getElevation(horizontalOffset),
                                  widget.elevation)),
                          blurRadius: 0.0,
                          // has the effect of softening the shadow
                          spreadRadius: 0.0,
                          // has the effect of extending the shadow
                          offset: Offset(
                            _getElevation(horizontalOffset),
                            // horizontal, move right 10
                            0.0, // vertical, move down 10
                          ),
                        )
                      ],
                    )),
                  ),
                  child
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _getLeftSideFixedHeaderScrollColumn() {
    if (widget.isFixedHeader) {
      return Column(
        children: <Widget>[
          Selector<ScrollShadowModel, double>(
            selector: (context, scrollShadowModel) {
              return scrollShadowModel?.verticalOffset ?? 0;
            },
            child: widget.headerWidgets[0],
            builder: (context, verticalOffset, child) {
              return Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.leftHandSideColBackgroundColor,
                        boxShadow: [
                          BoxShadow(
                            color: widget.elevationColor.withAlpha(
                                _getShadowAlpha(_getElevation(verticalOffset),
                                    widget.elevation)),
                            blurRadius: 0.0,
                            // has the effect of softening the shadow
                            spreadRadius: 0.0,
                            // has the effect of extending the shadow
                            offset: Offset(
                              0.0, // horizontal, move right 10
                              _getElevation(
                                  verticalOffset), // vertical, move down 10
                            ),
                          )
                        ],
                      ),
//                    child: child,
//                elevation: _getElevation(verticalOffset),
                    ),
                  ),
                  child
                ],
              );
            },
          ),
          widget.rowSeparatorWidget,
          Expanded(
              child: _getScrollColumn(_getLeftHandSideListView(),
                  this._leftHandSideListViewScrollController)),
        ],
      );
    } else {
      return _getScrollColumn(_getLeftHandSideListView(),
          this._leftHandSideListViewScrollController);
    }
  }

  Widget _getRightSideHeaderScrollColumn() {
    if (widget.isFixedHeader) {
      List<Widget> widgetList = [];
      //headers
      widgetList.add(Selector<ScrollShadowModel, double>(
          selector: (context, scrollShadowModel) {
            return scrollShadowModel?.verticalOffset ?? 0;
          },
          builder: (context, verticalOffset, child) {
            return Container(
              decoration: BoxDecoration(
                color: widget.rightHandSideColBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: widget.elevationColor.withAlpha(_getShadowAlpha(
                        _getElevation(verticalOffset), widget.elevation)),
                    blurRadius: 0.0,
                    // has the effect of softening the shadow
                    spreadRadius: 0.0,
                    // has the effect of extending the shadow
                    offset: Offset(
                      0.0, // horizontal, move right 10
                      _getElevation(verticalOffset), // vertical, move down 10
                    ),
                  )
                ],
              ),
              child: child,
//                elevation: _getElevation(verticalOffset)
            );
          },
          child: Row(children: widget.headerWidgets.sublist(1))));
      widgetList.add(
        widget.rowSeparatorWidget,
      );
      //ListView
      widgetList.add(Expanded(
        child: _getScrollColumn(_getRightHandSideListView(),
            this._rightHandSideListViewScrollController),
      ));
      return Column(
        children: widgetList,
      );
    } else {
      return _getScrollColumn(_getRightHandSideListView(),
          this._rightHandSideListViewScrollController);
    }
  }

  Widget _getScrollColumn(Widget child, ScrollController scrollController) {
    return NotificationListener<ScrollNotification>(
      child: child,
      onNotification: (ScrollNotification scrollInfo) {
        _syncScroller.processNotification(scrollInfo, scrollController);
        return false;
      },
    );
  }

  Widget _getRightHandSideListView() {
    if (widget.enablePullToRefresh) {
      return _getPullToRefreshRightListView(
          _rightHandSideListViewScrollController,
          widget.rightSideItemBuilder,
          widget.itemCount,
          widget.rightSideChildren);
    } else {
      return _getListView(
          _rightHandSideListViewScrollController,
          widget.rightSideItemBuilder,
          widget.itemCount,
          widget.rightSideChildren);
    }
  }

  Widget _getLeftHandSideListView() {
    if (widget.enablePullToRefresh) {
      return _getPullToRefreshLeftListView(
          _leftHandSideListViewScrollController,
          widget.leftSideItemBuilder,
          widget.itemCount,
          widget.leftSideChildren);
    } else {
      return _getListView(
          _leftHandSideListViewScrollController,
          widget.leftSideItemBuilder,
          widget.itemCount,
          widget.leftSideChildren);
    }
  }

  Widget _getListView(ScrollController scrollController,
      IndexedWidgetBuilder indexedWidgetBuilder, int itemCount,
      [List<Widget> children]) {
    if (indexedWidgetBuilder != null) {
      return ListView.separated(
        controller: scrollController,
        itemBuilder: indexedWidgetBuilder,
        itemCount: itemCount,
        separatorBuilder: (context, index) {
          return widget.rowSeparatorWidget;
        },
      );
    } else {
      return ListView(
        controller: scrollController,
        children: children,
      );
    }
  }

  Widget _getPullToRefreshRightListView(ScrollController scrollController,
      IndexedWidgetBuilder indexedWidgetBuilder, int itemCount,
      [List<Widget> children]) {
    if (indexedWidgetBuilder != null) {
      return SmartRefresher(
        controller: _refreshController,
        onRefresh: widget.onRefresh,
        header: widget.refreshIndicator,
        child: ListView.separated(
          controller: scrollController,
          itemBuilder: indexedWidgetBuilder,
          itemCount: itemCount,
          separatorBuilder: (context, index) {
            return widget.rowSeparatorWidget;
          },
        ),
      );
    } else {
      return SmartRefresher(
        controller: _refreshController,
        onRefresh: widget.onRefresh,
        header: widget.refreshIndicator,
        child: ListView(
          controller: scrollController,
          children: children,
        ),
      );
    }
  }

  Widget _getPullToRefreshLeftListView(ScrollController scrollController,
      IndexedWidgetBuilder indexedWidgetBuilder, int itemCount,
      [List<Widget> children]) {
    if (indexedWidgetBuilder != null) {
      return ListView.separated(
        physics: const NonBounceBackScrollPhysics(),
        controller: scrollController,
        itemBuilder: indexedWidgetBuilder,
        itemCount: itemCount,
        separatorBuilder: (context, index) {
          return widget.rowSeparatorWidget;
        },
      );
    } else {
      return ListView(
        physics: const NonBounceBackScrollPhysics(),
        controller: scrollController,
        children: children,
      );
    }
  }

  double _getElevation(double offset) {
    if (offset != null) {
      double elevation = offset > widget.elevation ? widget.elevation : offset;
      if (elevation >= 0) {
        return elevation;
      }
    }
    return 0.0;
  }

  int _getShadowAlpha(double calculatedElevation, double widgetElevation) {
    if (widgetElevation > 0) {
      return 10 * calculatedElevation ~/ widgetElevation;
    }
    return 0;
  }
}

class _SyncScrollControllerManager {
  _SyncScrollControllerManager(RefreshController refreshController,
      [double refreshIndicatorHeight = 0.0]) {
    _refreshController = refreshController;
    _refreshIndicatorHeight = refreshIndicatorHeight;
  }
  List<ScrollController> _registeredScrollControllers = [];
  ScrollController _scrollingController;
  bool _scrollingActive = false;

  ///Refresh related
  RefreshController _refreshController;
  double _refreshIndicatorHeight = 0.0;
  double _cacheScrollOffset = 0.0;

  void registerScrollController(ScrollController controller) {
    _registeredScrollControllers.add(controller);
  }

  void unregisterScrollController(ScrollController controller) {
    _registeredScrollControllers.remove(controller);
  }

  void processNotification(
      ScrollNotification notification, ScrollController sender) {
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
                  switch (controller.debugLabel) {
                    case 'Left':
                      _syncLeftListViewScrollVontroller(
                          _scrollingController, controller);
                      break;
                    case 'Right':
                      _syncRightListViewScrollVontroller(
                          _scrollingController, controller);
                      break;
                  }
                } else {
                  controller.jumpTo(_scrollingController.offset);
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
    // debugPrint(
    //     'offset: ${_scrollingController.offset}; cached $_cacheScrollOffset');
    // debugPrint('status: ${_refreshController.headerStatus}');
    switch (_refreshController.headerStatus) {
      case RefreshStatus.canRefresh:
        {
          if (_cacheScrollOffset < _scrollingController.offset) {
            controller.jumpTo(_refreshIndicatorHeight * -1);
            return;
          } else {
            _cacheScrollOffset = _scrollingController.offset;
          }
          break;
        }
      case RefreshStatus.refreshing:
        {
          return;
        }
      default:
        {
          _cacheScrollOffset = 0.0;
          break;
        }
    }
    controller.jumpTo(_scrollingController.offset);
  }

  void _syncRightListViewScrollVontroller(
      ScrollController _scrollingController, ScrollController controller) {
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
  }
}
