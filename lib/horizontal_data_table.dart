///Exxport File

///Scrollbar Style
export 'package:horizontal_data_table/scroll/scroll_bar_style.dart';

///Wrapper Controller
export 'package:horizontal_data_table/refresh/hdt_refresh_controller.dart';

///Available Refresh Header
export 'package:horizontal_data_table/refresh/pull_to_refresh/src/indicator/classic_indicator.dart';
export 'package:horizontal_data_table/refresh/pull_to_refresh/src/indicator/waterdrop_header.dart';
export 'package:horizontal_data_table/refresh/pull_to_refresh/src/indicator/custom_indicator.dart';
export 'package:horizontal_data_table/refresh/pull_to_refresh/src/indicator/link_indicator.dart';
export 'package:horizontal_data_table/refresh/pull_to_refresh/src/indicator/material_indicator.dart';
export 'package:horizontal_data_table/refresh/pull_to_refresh/src/indicator/bezier_indicator.dart';
export 'package:horizontal_data_table/refresh/pull_to_refresh/src/smart_refresher.dart';

///Main File
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/model/scroll_shadow_model.dart';
import 'package:horizontal_data_table/refresh/non_bounce_back_scroll_physics.dart';
import 'package:horizontal_data_table/refresh/hdt_refresh_controller.dart';
import 'package:horizontal_data_table/refresh/pull_to_refresh/src/smart_refresher.dart';
import 'package:horizontal_data_table/scroll/scroll_bar_style.dart';

import 'package:provider/provider.dart';

import 'delegate/base_layout_view_delegate.dart';
import 'delegate/list_view_layout_delegate.dart';
import 'scroll/custom_scroll_bar.dart';
import 'scroll/sync_horizontal_scroll_controller_manager.dart';
import 'scroll/sync_scroll_controller_manager.dart';

///
/// For sorting issue, will based on the header fixed widget for flexible handling, suggest using [Button] to control the data sorting
///
///
class HorizontalDataTable extends StatefulWidget {
  final double leftHandSideColumnWidth;
  final double rightHandSideColumnWidth;

  ///tableHeight is the whole table widget height, including header and table body. This is for those want a shrinkWrap widget to input the calculated table height. If the tableHeight is smaller than the widget available height, the tableHeight is used instead. If the tableHeight is larger than the available height, available height is used.
  ///Default set to null, use up all available space. tableHeight must > 0.
  final double? tableHeight;

  ///if headerWidgets==true,
  ///HorizontalDataTable.headerWidgets[0] as the left hand side header
  ///
  /// if headerWidgets==false
  /// header handling will handle by the itembuilder or the first child -> index == 0
  ///
  /// if no header needed, just ignore this, start data from index ==0
  ///
  final bool isFixedHeader;
  final List<Widget>? headerWidgets;

  ///Direct create children
  final List<Widget>? leftSideChildren;
  final List<Widget>? rightSideChildren;

  ///Suggest use builder for easier manage, like data update
  final int itemCount;
  final IndexedWidgetBuilder? leftSideItemBuilder;
  final IndexedWidgetBuilder? rightSideItemBuilder;

  ///Row Divider

  ///This is apply to all remaining data row of the list view
  final Widget rowSeparatorWidget;

  ///Elevation for the shadow of header row and first column after scroll
  ///If don't want to show the shadow, please set it to 0.0
  final double elevation;
  final Color elevationColor;

  final Color leftHandSideColBackgroundColor;
  final Color rightHandSideColBackgroundColor;

  ///Vertical scroll controller, expose for allowing maunally jump to specific offset position. Please aware this may conflict with the pull to refresh action.
  final ScrollController? verticalScrollController;

  ///Horizontal scroll controller, expose for allowing maunally jump to specific offset position.
  final ScrollController? horizontalScrollController;

  ///Vertical Scrollbar Style. Default the scrollbar is using that platform's sysmtem setting.
  final ScrollbarStyle? verticalScrollbarStyle;

  ///Horizontal Scrollbar Style. Default the scrollbar is using that platform's sysmtem setting.
  final ScrollbarStyle? horizontalScrollbarStyle;

  ///Flag to indicate whether enable the pull_to_refresh function
  ///Default is false
  final bool enablePullToRefresh;

  ///Support using pull-to-refresh's refresh indicator
  ///Please update the indicator height in order to sync the height when loading.
  final double refreshIndicatorHeight;

  ///Support using pull-to-refresh's refresh indicator
  final Widget? refreshIndicator;

  ///Callback for pulled to refresh.
  ///Call HDTRefreshController.refreshCompleted() for finished refresh loading.
  ///Call HDTRefreshController.refreshFailed() for error refresh loading.
  final Function? onRefresh;

  ///Vertical scroll physics of the data table
  final ScrollPhysics? scrollPhysics;

  ///Horizontal Scroll physics of the data table
  final ScrollPhysics? horizontalScrollPhysics;

  ///This is a wrapper controller for limilating using the available refresh controller function. Currently only refresh fail and complete is implemented.
  final HDTRefreshController? htdRefreshController;

  const HorizontalDataTable({
    required this.leftHandSideColumnWidth,
    required this.rightHandSideColumnWidth,
    this.tableHeight,
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
    this.horizontalScrollController,
    this.verticalScrollController,
    this.verticalScrollbarStyle,
    this.horizontalScrollbarStyle,
    this.enablePullToRefresh = false,
    this.refreshIndicatorHeight = 60.0,
    this.htdRefreshController,
    this.onRefresh,
    this.refreshIndicator,
    this.scrollPhysics,
    this.horizontalScrollPhysics,
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
        assert(tableHeight == null || tableHeight > 0.0,
            'tableHeight can only be null or > 0.0'),
        assert(itemCount >= 0, 'itemCount must >= 0'),
        assert(elevation >= 0.0, 'elevation must >= 0.0'),
        // assert(elevationColor != null, 'elevationColor must not be null'),
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
  ScrollController _leftHandSideListViewScrollController = ScrollController();
  late ScrollController _rightHandSideListViewScrollController;
  late ScrollController _rightHorizontalScrollController;
  SyncHorizontalScrollControllerManager? _syncHorizontalScrollControllerManager;
  ScrollController? _rightHeaderHorizontalScrollController;

  ScrollShadowModel _scrollShadowModel = ScrollShadowModel();

  late SyncScrollControllerManager _syncScroller;
  RefreshController? _refreshController;

  @override
  void initState() {
    super.initState();
    _rightHandSideListViewScrollController =
        widget.verticalScrollController ?? ScrollController();

    if (widget.enablePullToRefresh) {
      _refreshController = RefreshController(initialRefresh: false);
      widget.htdRefreshController?.setRefreshController(_refreshController);
      _syncScroller = SyncScrollControllerManager(
          _refreshController, widget.refreshIndicatorHeight);
    } else {
      _syncScroller = SyncScrollControllerManager(_refreshController);
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

    //horizontal scroll
    _rightHorizontalScrollController =
        widget.horizontalScrollController ?? ScrollController();
    _rightHorizontalScrollController.addListener(() {
      _scrollShadowModel.horizontalOffset =
          _rightHorizontalScrollController.offset;
      setState(() {});
    });
    if (widget.isFixedHeader) {
      _rightHeaderHorizontalScrollController = ScrollController();
      _syncHorizontalScrollControllerManager =
          SyncHorizontalScrollControllerManager();
      _syncHorizontalScrollControllerManager
          ?.registerScrollController(_rightHorizontalScrollController);
      _syncHorizontalScrollControllerManager
          ?.registerScrollController(_rightHeaderHorizontalScrollController!);
    }
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
    if (widget.isFixedHeader) {
      _rightHeaderHorizontalScrollController?.dispose();
      _syncHorizontalScrollControllerManager
          ?.unregisterScrollController(_rightHorizontalScrollController);
      _syncHorizontalScrollControllerManager
          ?.unregisterScrollController(_rightHeaderHorizontalScrollController!);
    }
    widget.htdRefreshController?.setRefreshController(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ScrollShadowModel>(
      create: (context) => _scrollShadowModel,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, boxConstraint) {
            if (widget.tableHeight != null) {
              return _getParallelListView(
                boxConstraint.maxWidth,
                (boxConstraint.maxHeight > widget.tableHeight!
                    ? widget.tableHeight
                    : boxConstraint.maxHeight)!,
              );
            } else {
              return _getParallelListView(
                boxConstraint.maxWidth,
                boxConstraint.maxHeight,
              );
            }
          },
        ),
      ),
    );
  }

  Widget _getParallelListView(double width, double height) {
    return CustomMultiChildLayout(
      delegate: TableBaseLayoutDelegate(
          height, width, widget.leftHandSideColumnWidth, widget.elevation),
      children: [
        LayoutId(
          id: BaseLayoutView.LeftListView,
          child: Container(
            color: widget.leftHandSideColBackgroundColor,
            child: _getLeftFixedHeaderScrollColumn(
              height: height,
              listViewWidth: widget.leftHandSideColumnWidth,
              header: widget.headerWidgets?.first,
              listView: _getScrollColumn(
                _getLeftHandSideListView(),
                this._leftHandSideListViewScrollController,
                leftScrollControllerLabel,
              ),
            ),
          ),
        ),
        LayoutId(
          id: BaseLayoutView.RightListView,
          child: Container(
            color: widget.rightHandSideColBackgroundColor,
            child: _getRightFixedHeaderScrollColumn(
              height: height,
              listViewWidth: width - widget.leftHandSideColumnWidth,
              header: Row(
                mainAxisSize: MainAxisSize.min,
                children: widget.headerWidgets?.sublist(1).toList() ?? [],
              ),
              listView: _getScrollColumn(
                _getRightHandSideListView(),
                this._rightHandSideListViewScrollController,
                rightScrollControllerLabel,
              ),
            ),
          ),
        ),
        LayoutId(
          id: BaseLayoutView.MiddleShadow,
          child: Selector<ScrollShadowModel, double>(
              selector: (context, scrollShadowModel) {
            return scrollShadowModel.horizontalOffset;
          }, builder: (context, horizontalOffset, child) {
            return Container(
              width: _getElevation(horizontalOffset),
              height: height,
              color: widget.elevationColor.withAlpha(
                _getShadowAlpha(
                    _getElevation(horizontalOffset), widget.elevation),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _getLeftFixedHeaderScrollColumn(
      {required double height,
      required double listViewWidth,
      Widget? header,
      required Widget listView}) {
    return CustomMultiChildLayout(
      delegate: ListViewLayoutDelegate(
        height,
        listViewWidth,
        widget.elevation,
      ),
      children: [
        if (widget.isFixedHeader)
          LayoutId(
            id: ListViewLayout.Header,
            child: header!,
          ),
        if (widget.isFixedHeader)
          LayoutId(
            id: ListViewLayout.Divider,
            child: widget.rowSeparatorWidget,
          ),
        LayoutId(
          id: ListViewLayout.ListView,
          child: listView,
        ),
        LayoutId(
          id: ListViewLayout.Shadow,
          child: Selector<ScrollShadowModel, double>(
            selector: (context, scrollShadowModel) {
              return scrollShadowModel.verticalOffset;
            },
            builder: (context, verticalOffset, child) {
              return Container(
                color: widget.elevationColor.withAlpha(_getShadowAlpha(
                    _getElevation(verticalOffset), widget.elevation)),
                height: _getElevation(widget.elevation),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _getRightFixedHeaderScrollColumn(
      {required double height,
      required double listViewWidth,
      Widget? header,
      required Widget listView}) {
    return CustomMultiChildLayout(
      delegate: ListViewLayoutDelegate(
        height,
        listViewWidth,
        widget.elevation,
      ),
      children: [
        if (widget.isFixedHeader)
          LayoutId(
            id: ListViewLayout.Header,
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                _syncHorizontalScrollControllerManager?.processNotification(
                  scrollInfo,
                  _rightHeaderHorizontalScrollController!,
                  topScrollControllerLabel,
                );
                return false;
              },
              child: SingleChildScrollView(
                physics: widget.horizontalScrollPhysics,
                controller: _rightHeaderHorizontalScrollController!,
                scrollDirection: Axis.horizontal,
                child: header!,
              ),
            ),
          ),
        if (widget.isFixedHeader)
          LayoutId(
            id: ListViewLayout.Divider,
            child: widget.rowSeparatorWidget,
          ),
        LayoutId(
          id: ListViewLayout.ListView,
          child: CustomScrollBar(
            controller: this._rightHandSideListViewScrollController,
            scrollbarStyle: widget.verticalScrollbarStyle,
            notificationPredicate: (ScrollNotification notification) {
              return notification.depth == 1;
            },
            child: CustomScrollBar(
              controller: this._rightHorizontalScrollController,
              scrollbarStyle: widget.horizontalScrollbarStyle,
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  _syncHorizontalScrollControllerManager?.processNotification(
                    scrollInfo,
                    _rightHorizontalScrollController,
                    bottomScrollControllerLabel,
                  );
                  return false;
                },
                child: SingleChildScrollView(
                  physics: widget.horizontalScrollPhysics,
                  controller: _rightHorizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    width: widget.rightHandSideColumnWidth,
                    child: listView,
                  ),
                ),
              ),
            ),
          ),
        ),
        LayoutId(
          id: ListViewLayout.Shadow,
          child: Selector<ScrollShadowModel, double>(
            selector: (context, scrollShadowModel) {
              return scrollShadowModel.verticalOffset;
            },
            builder: (context, verticalOffset, child) {
              return Container(
                color: widget.elevationColor.withAlpha(_getShadowAlpha(
                    _getElevation(verticalOffset), widget.elevation)),
                height: _getElevation(widget.elevation),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _getScrollColumn(
      Widget child, ScrollController scrollController, String label) {
    return NotificationListener<ScrollNotification>(
      child: child,
      onNotification: (ScrollNotification scrollInfo) {
        _syncScroller.processNotification(scrollInfo, scrollController, label);
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
      IndexedWidgetBuilder? indexedWidgetBuilder, int itemCount,
      [List<Widget>? children]) {
    if (indexedWidgetBuilder != null) {
      return ListView.separated(
        physics: widget.scrollPhysics,
        controller: scrollController,
        itemBuilder: indexedWidgetBuilder,
        itemCount: itemCount,
        separatorBuilder: (context, index) {
          return widget.rowSeparatorWidget;
        },
      );
    } else {
      return ListView.builder(
        physics: widget.scrollPhysics,
        controller: scrollController,
        itemCount: children?.length,
        itemBuilder: (context, index) {
          return children![index];
        },
      );
    }
  }

  Widget _getPullToRefreshRightListView(ScrollController scrollController,
      IndexedWidgetBuilder? indexedWidgetBuilder, int itemCount,
      [List<Widget>? children]) {
    return SmartRefresher(
      controller: _refreshController!,
      onRefresh: () {
        if (widget.onRefresh != null) {
          widget.onRefresh!();
        }
      },
      header: widget.refreshIndicator,
      child: _getListView(
        scrollController,
        indexedWidgetBuilder,
        itemCount,
        children,
      ),
    );
  }

  Widget _getPullToRefreshLeftListView(ScrollController scrollController,
      IndexedWidgetBuilder? indexedWidgetBuilder, int itemCount,
      [List<Widget>? children]) {
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
        children: children!,
      );
    }
  }

  double _getElevation(double? offset) {
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
