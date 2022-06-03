///Export File

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
import 'package:horizontal_data_table/refresh/hdt_refresh_controller.dart';
import 'package:horizontal_data_table/refresh/pull_to_refresh/pull_to_refresh.dart';
import 'package:horizontal_data_table/scroll/scroll_bar_style.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

import 'package:provider/provider.dart';

import 'delegate/base_layout_view_delegate.dart';
import 'delegate/list_view_layout_delegate.dart';
import 'scroll/custom_scroll_bar.dart';
import 'scroll/sync_horizontal_scroll_controller_manager.dart';

///
/// For sorting issue, will based on the header fixed widget for flexible handling, suggest using [Button] to control the data sorting
///
///
class HorizontalDataTable extends StatefulWidget {
  final double fixedSideColumnWidth;
  final double bidirectionalSideColumnWidth;

  ///tableHeight is the whole table widget height, including header and table body. This is for those want a shrinkWrap widget to input the calculated table height. If the tableHeight is smaller than the widget available height, the tableHeight is used instead. If the tableHeight is larger than the available height, available height is used.
  ///Default set to null, use up all available space. tableHeight must > 0.
  final double? tableHeight;

  ///if headerWidgets==true,
  ///HorizontalDataTable.headerWidgets[0] as the fixed side header
  ///
  /// if headerWidgets==false
  /// header handling will handle by the itembuilder or the first child -> index == 0
  ///
  /// if no header needed, just ignore this, start data from index ==0
  ///
  final bool isFixedHeader;
  final List<Widget>? headerWidgets;

  ///Direct create children
  final List<Widget>? fixedSideChildren;
  final List<Widget>? bidirectionalSideChildren;

  ///Suggest use builder for easier manage, like data update
  final int itemCount;
  final IndexedWidgetBuilder? fixedSideItemBuilder;
  final IndexedWidgetBuilder? bidirectionalSideItemBuilder;

  ///Row Divider

  ///This is apply to all remaining data row of the list view
  final Widget rowSeparatorWidget;

  ///Elevation for the shadow of header row and first column after scroll
  ///If don't want to show the shadow, please set it to 0.0
  final double elevation;
  final Color elevationColor;

  final Color fixedSideColBackgroundColor;
  final Color bidirectionalSideColBackgroundColor;

  ///Deprecated
  ///Vertical scroll controller, expose for allowing manually jump to specific offset position. Please aware this may conflict with the pull to refresh action.
  ///final ScrollController? verticalScrollController;

  ///TODO: add return vertical scroll controller function
  final Function(ScrollController)? onVerticalScrollReady;

  ///Horizontal scroll controller, expose for allowing manually jump to specific offset position.
  final ScrollController? horizontalScrollController;

  ///Vertical Scrollbar Style. Default the scrollbar is using that platform's system setting.
  final ScrollbarStyle? verticalScrollbarStyle;

  ///Horizontal Scrollbar Style. Default the scrollbar is using that platform's system setting.
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

  ///Flag to indicate whether enable the pull_to_load function
  ///Default is false
  final bool enablePullToLoadNewData;

  ///Support using pull-to-refresh's load indicator
  final LoadIndicator? loadIndicator;

  ///Callback for pulled to load more.
  ///Call HDTRefreshController.loadComplete() for finished loading.
  ///Call HDTRefreshController.loadFailed() for error loading.
  ///Call HDTRefreshController.loadNoData() for no more data.
  final Function? onLoad;

  ///Vertical scroll physics of the data table
  final ScrollPhysics? scrollPhysics;

  ///Horizontal Scroll physics of the data table
  final ScrollPhysics? horizontalScrollPhysics;

  ///This is a wrapper controller for limiting using the available refresh and load new data controller function. Currently only refresh and load fail and complete are implemented.
  final HDTRefreshController? htdRefreshController;

  final bool enableRTL;

  const HorizontalDataTable({
    required double leftHandSideColumnWidth,
    required double rightHandSideColumnWidth,
    this.tableHeight,
    this.isFixedHeader = false,
    this.headerWidgets,
    Widget Function(BuildContext, int)? leftSideItemBuilder,
    Widget Function(BuildContext, int)? rightSideItemBuilder,
    this.itemCount = 0,
    List<Widget>? leftSideChildren,
    List<Widget>? rightSideChildren,
    this.rowSeparatorWidget = const Divider(
      color: Colors.transparent,
      height: 0.0,
      thickness: 0.0,
    ),
    this.elevation = 3.0,
    this.elevationColor = Colors.black54,
    Color leftHandSideColBackgroundColor = Colors.white,
    Color rightHandSideColBackgroundColor = Colors.white,
    this.horizontalScrollController,
    this.onVerticalScrollReady,
    this.verticalScrollbarStyle,
    this.horizontalScrollbarStyle,
    this.enablePullToRefresh = false,
    this.refreshIndicatorHeight = 60.0,
    this.htdRefreshController,
    this.onRefresh,
    this.refreshIndicator,
    this.enablePullToLoadNewData = false,
    this.onLoad,
    this.loadIndicator,
    this.scrollPhysics,
    this.horizontalScrollPhysics,
    this.enableRTL = false,
  })  : this.fixedSideColumnWidth = leftHandSideColumnWidth,
        this.bidirectionalSideColumnWidth = rightHandSideColumnWidth,
        this.fixedSideChildren = leftSideChildren,
        this.bidirectionalSideChildren = rightSideChildren,
        this.fixedSideItemBuilder = leftSideItemBuilder,
        this.bidirectionalSideItemBuilder = rightSideItemBuilder,
        this.fixedSideColBackgroundColor = leftHandSideColBackgroundColor,
        this.bidirectionalSideColBackgroundColor =
            rightHandSideColBackgroundColor,
        assert(
            (leftSideChildren == null && leftSideItemBuilder != null) ||
                (leftSideChildren != null),
            'Either using itemBuilder or children to assign fixed side widgets'),
        assert(
            (rightSideChildren == null && rightSideItemBuilder != null) ||
                (rightSideChildren != null),
            'Either using itemBuilder or children to assign bi-directional side widgets'),
        assert((isFixedHeader && headerWidgets != null) || !isFixedHeader,
            'If use fixed top row header, isFixedHeader==true, headerWidgets must not be null'),
        assert(tableHeight == null || tableHeight > 0.0,
            'tableHeight can only be null or > 0.0'),
        assert(itemCount >= 0, 'itemCount must >= 0'),
        assert(elevation >= 0.0, 'elevation must >= 0.0'),
        assert(
            (enablePullToRefresh && refreshIndicatorHeight >= 0.0) ||
                !enablePullToRefresh,
            'refreshIndicator must >= 0 if pull to refresh is enabled'),
        assert(
            (enablePullToRefresh && refreshIndicator != null) ||
                !enablePullToRefresh,
            'refreshIndicator must not be null if pull to refresh is enabled'),
        assert(
            ((enablePullToRefresh || enablePullToLoadNewData) &&
                    htdRefreshController != null) ||
                !(enablePullToRefresh || enablePullToLoadNewData),
            'htdRefreshController must not be null if pull to refresh or load is enabled'),
        assert(
            (enablePullToRefresh && onRefresh != null) || !enablePullToRefresh,
            'onRefresh must not be null if pull to refresh is enabled'),
        assert(
            (enablePullToLoadNewData && onLoad != null) ||
                !enablePullToLoadNewData,
            'onLoad must not be null if pull to load is enabled'),
        assert(
            (enablePullToLoadNewData && loadIndicator != null) ||
                !enablePullToLoadNewData,
            'loadIndicator must not be null if pull to load is enabled');

  HorizontalDataTable.rtl({
    required double leftHandSideColumnWidth,
    required double rightHandSideColumnWidth,
    double? tableHeight,
    bool isFixedHeader = false,
    List<Widget>? headerWidgets,
    Widget Function(BuildContext, int)? leftSideItemBuilder,
    Widget Function(BuildContext, int)? rightSideItemBuilder,
    int itemCount = 0,
    List<Widget>? leftSideChildren,
    List<Widget>? rightSideChildren,
    Widget rowSeparatorWidget = const Divider(
      color: Colors.transparent,
      height: 0.0,
      thickness: 0.0,
    ),
    double elevation = 3.0,
    Color elevationColor = Colors.black54,
    Color leftHandSideColBackgroundColor = Colors.white,
    Color rightHandSideColBackgroundColor = Colors.white,
    ScrollController? horizontalScrollController,
    Function(ScrollController)? onVerticalScrollReady,
    ScrollbarStyle? verticalScrollbarStyle,
    ScrollbarStyle? horizontalScrollbarStyle,
    bool enablePullToRefresh = false,
    double refreshIndicatorHeight = 60.0,
    HDTRefreshController? htdRefreshController,
    Function? onRefresh,
    Widget? refreshIndicator,
    bool enablePullToLoadNewData = false,
    Function? onLoad,
    LoadIndicator? loadIndicator,
    ScrollPhysics? scrollPhysics,
    ScrollPhysics? horizontalScrollPhysics,
  }) : this(
          leftHandSideColumnWidth: rightHandSideColumnWidth,
          rightHandSideColumnWidth: leftHandSideColumnWidth,
          tableHeight: tableHeight,
          isFixedHeader: isFixedHeader,
          headerWidgets: headerWidgets,
          leftSideItemBuilder: rightSideItemBuilder,
          rightSideItemBuilder: leftSideItemBuilder,
          itemCount: itemCount,
          leftSideChildren: rightSideChildren,
          rightSideChildren: leftSideChildren,
          rowSeparatorWidget: rowSeparatorWidget,
          elevation: elevation,
          elevationColor: elevationColor,
          leftHandSideColBackgroundColor: rightHandSideColBackgroundColor,
          rightHandSideColBackgroundColor: leftHandSideColBackgroundColor,
          horizontalScrollController: horizontalScrollController,
          onVerticalScrollReady: onVerticalScrollReady,
          verticalScrollbarStyle: verticalScrollbarStyle,
          horizontalScrollbarStyle: horizontalScrollbarStyle,
          enablePullToRefresh: enablePullToRefresh,
          refreshIndicatorHeight: refreshIndicatorHeight,
          htdRefreshController: htdRefreshController,
          onRefresh: onRefresh,
          refreshIndicator: refreshIndicator,
          enablePullToLoadNewData: enablePullToLoadNewData,
          onLoad: onLoad,
          loadIndicator: loadIndicator,
          scrollPhysics: scrollPhysics,
          horizontalScrollPhysics: horizontalScrollPhysics,
          enableRTL: true,
        );

  @override
  State<StatefulWidget> createState() {
    return _HorizontalDataTableState();
  }
}

class _HorizontalDataTableState extends State<HorizontalDataTable> {
  late ScrollController _fixedSideListViewScrollController;
  late ScrollController _bidirectionalSideListViewScrollController;
  late LinkedScrollControllerGroup _controllersGroup;

  late ScrollController _bidirectionalSideHorizontalScrollController;
  SyncHorizontalScrollControllerManager? _syncHorizontalScrollControllerManager;
  ScrollController? _bidirectionalSideHeaderHorizontalScrollController;

  ScrollShadowModel _scrollShadowModel = ScrollShadowModel();

  RefreshController? _refreshController;
  RefreshController? _fixedSideRefreshController;

  @override
  void initState() {
    super.initState();

    ///init vertical scroll controller
    _controllersGroup = LinkedScrollControllerGroup();
    _fixedSideListViewScrollController = _controllersGroup.addAndGet();
    _bidirectionalSideListViewScrollController = _controllersGroup.addAndGet();
    if (widget.onVerticalScrollReady != null) {
      widget.onVerticalScrollReady!(_bidirectionalSideListViewScrollController);
    }

    ///init pull to refresh controller
    if (widget.enablePullToRefresh) {
      _refreshController = RefreshController(initialRefresh: false);
      _fixedSideRefreshController = RefreshController(initialRefresh: false);
      widget.htdRefreshController?.setRefreshController(_refreshController);
      widget.htdRefreshController
          ?.setRefreshController(_fixedSideRefreshController);
    }

    ///init bi-directional side horizontal scroll
    _bidirectionalSideHorizontalScrollController =
        widget.horizontalScrollController ?? ScrollController();
    _bidirectionalSideHorizontalScrollController.addListener(() {
      _scrollShadowModel.horizontalOffset =
          _bidirectionalSideHorizontalScrollController.offset;
      setState(() {});
    });

    ///init fixed header horizontal scroll controller
    if (widget.isFixedHeader) {
      _bidirectionalSideHeaderHorizontalScrollController = ScrollController();
      _syncHorizontalScrollControllerManager =
          SyncHorizontalScrollControllerManager();
      _syncHorizontalScrollControllerManager?.registerScrollController(
          _bidirectionalSideHorizontalScrollController);
      _syncHorizontalScrollControllerManager?.registerScrollController(
          _bidirectionalSideHeaderHorizontalScrollController!);
    }
  }

  @override
  void dispose() {
    widget.htdRefreshController?.unregisterRefreshControllerListener();
    _fixedSideListViewScrollController.dispose();
    _bidirectionalSideListViewScrollController.dispose();
    _bidirectionalSideHorizontalScrollController.dispose();
    if (widget.isFixedHeader) {
      _bidirectionalSideHeaderHorizontalScrollController?.dispose();
      _syncHorizontalScrollControllerManager?.unregisterScrollController(
          _bidirectionalSideHorizontalScrollController);
      _syncHorizontalScrollControllerManager?.unregisterScrollController(
          _bidirectionalSideHeaderHorizontalScrollController!);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.enableRTL ? TextDirection.rtl : TextDirection.ltr,
      child: ChangeNotifierProvider<ScrollShadowModel>(
        create: (context) => _scrollShadowModel,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, boxConstraint) {
              late double maxHeight;
              if (widget.tableHeight != null) {
                maxHeight = (boxConstraint.maxHeight > widget.tableHeight!
                    ? widget.tableHeight
                    : boxConstraint.maxHeight)!;
              } else {
                maxHeight = boxConstraint.maxHeight;
              }
              return _getParallelListView(
                boxConstraint.maxWidth,
                maxHeight,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _getParallelListView(double width, double height) {
    return CustomMultiChildLayout(
      delegate: TableBaseLayoutDelegate(height, width,
          widget.fixedSideColumnWidth, widget.elevation, widget.enableRTL),
      children: [
        LayoutId(
          id: BaseLayoutView.FixedColumnListView,
          child: Container(
            color: widget.fixedSideColBackgroundColor,
            child: _getFixedSideHeaderScrollColumn(
              height: height,
              listViewWidth: widget.fixedSideColumnWidth,
              header: widget.headerWidgets?.first,
              listView: _getPullToRefreshFixedSideListView(
                  _fixedSideListViewScrollController,
                  widget.fixedSideItemBuilder,
                  widget.itemCount,
                  widget.fixedSideChildren),
            ),
          ),
        ),
        LayoutId(
          id: BaseLayoutView.BiDirectionScrollListView,
          child: Container(
            color: widget.bidirectionalSideColBackgroundColor,
            child: _getBidirectionalSideHeaderScrollColumn(
              height: height,
              listViewWidth: width - widget.fixedSideColumnWidth,
              header: Row(
                mainAxisSize: MainAxisSize.min,
                children: widget.headerWidgets?.sublist(1).toList() ?? [],
              ),
              listView: _getPullToRefreshBidirectionalSideListView(
                  _bidirectionalSideListViewScrollController,
                  widget.bidirectionalSideItemBuilder,
                  widget.itemCount,
                  widget.bidirectionalSideChildren),
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

  Widget _getFixedSideHeaderScrollColumn({
    required double height,
    required double listViewWidth,
    Widget? header,
    required Widget listView,
  }) {
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

  Widget _getBidirectionalSideHeaderScrollColumn({
    required double height,
    required double listViewWidth,
    Widget? header,
    required Widget listView,
  }) {
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
                  _bidirectionalSideHeaderHorizontalScrollController!,
                  topScrollControllerLabel,
                );
                return false;
              },
              child: SingleChildScrollView(
                physics: widget.horizontalScrollPhysics,
                controller: _bidirectionalSideHeaderHorizontalScrollController!,
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
            controller: this._bidirectionalSideListViewScrollController,
            scrollbarStyle: widget.verticalScrollbarStyle,
            notificationPredicate: (ScrollNotification notification) {
              return notification.depth == 1;
            },
            child: CustomScrollBar(
              controller: this._bidirectionalSideHorizontalScrollController,
              scrollbarStyle: widget.horizontalScrollbarStyle,
              notificationPredicate: (notification) {
                // For some reason, on  _web only_, the scrollbar catches
                // notifications from a vertical scrollable with depth: 0.
                // This causes issues with the horizontal scrollbar disappearing
                // as soon as vertical scrolling starts, and not obeying the fade
                // logic or `isShownAlways` styling.
                //
                // No idea what the source is. As a workaround, we can just
                // check the axis of the source scrollable.
                if (notification.depth == 0 &&
                    notification.metrics.axis == Axis.horizontal) {
                  return true;
                }

                return false;
              },
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  _syncHorizontalScrollControllerManager?.processNotification(
                    scrollInfo,
                    _bidirectionalSideHorizontalScrollController,
                    bottomScrollControllerLabel,
                  );
                  return false;
                },
                child: SingleChildScrollView(
                  physics: widget.horizontalScrollPhysics,
                  controller: _bidirectionalSideHorizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    width: widget.bidirectionalSideColumnWidth,
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

  Widget _getPullToRefreshBidirectionalSideListView(
      ScrollController scrollController,
      IndexedWidgetBuilder? indexedWidgetBuilder,
      int itemCount,
      [List<Widget>? children]) {
    return SmartRefresher(
      controller: _refreshController!,
      enablePullDown: widget.enablePullToRefresh,
      enablePullUp: widget.enablePullToLoadNewData,
      onRefresh: () {
        if (widget.onRefresh != null) {
          widget.onRefresh!();
        }
      },
      onLoading: () {
        if (widget.onLoad != null) {
          widget.htdRefreshController?.requestLoading();
          widget.onLoad!();
        }
      },
      header: widget.refreshIndicator,
      footer: widget.loadIndicator,
      child: _getListView(
        scrollController,
        indexedWidgetBuilder,
        itemCount,
        children,
      ),
    );
  }

  Widget _getPullToRefreshFixedSideListView(ScrollController scrollController,
      IndexedWidgetBuilder? indexedWidgetBuilder, int itemCount,
      [List<Widget>? children]) {
    return SmartRefresher(
      controller: _fixedSideRefreshController!,
      enablePullDown: widget.enablePullToRefresh,
      enablePullUp: widget.enablePullToLoadNewData,

      ///TODO: allow people customize the fixed side refresh indicator
      header: PlaceholderHeader(
        height: widget.refreshIndicatorHeight,
      ),

      ///TODO: allow people customize the fixed side load indicator
      footer: PlaceholderFooter(
        height: widget.loadIndicator?.height ?? 60.0,
      ),
      onLoading: () {
        if (widget.onLoad != null) {
          widget.htdRefreshController?.requestLoading();
        }
      },
      child: _getListView(
        scrollController,
        indexedWidgetBuilder,
        itemCount,
        children,
      ),
    );
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
