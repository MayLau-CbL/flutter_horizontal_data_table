export 'package:horizontal_data_table/scroll/scroll_bar_style.dart';
export 'package:horizontal_data_table/refresh/hdt_refresh_controller.dart';
export 'package:horizontal_data_table/refresh/pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/model/scroll_shadow_model.dart';
import 'package:horizontal_data_table/refresh/hdt_refresh_controller.dart';
import 'package:horizontal_data_table/refresh/pull_to_refresh/pull_to_refresh.dart';
import 'package:horizontal_data_table/scroll/scroll_bar_style.dart';
import 'package:horizontal_data_table/scroll/table_controllers.dart';

import 'package:provider/provider.dart';

import 'delegate/base_layout_view_delegate.dart';
import 'delegate/list_view_layout_delegate.dart';
import 'scroll/custom_scroll_bar.dart';

typedef OnScrollControllerReady = void Function(
    ScrollController verticalController, ScrollController horizontalController);

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

  ///if isFixedHeader==true,
  ///HorizontalDataTable.headerWidgets[0] as the fixed side header
  ///
  /// if isFixedHeader==false
  /// header handling will handle by the itembuilder or the first child -> index == 0
  ///
  /// if no header needed, just ignore this, start data from index ==0
  ///
  final bool isFixedHeader;
  final List<Widget>? headerWidgets;

  ///if isFixedFooter==true,
  ///HorizontalDataTable.footerWidgets[0] as the fixed side footer
  ///
  /// if no footer needed, just ignore this
  ///
  final bool isFixedFooter;
  final List<Widget>? footerWidgets;

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

  ///Deprecated, use [onScrollControllerReady] return instead
  ///Vertical scroll controller, expose for allowing manually jump to specific offset position. Please aware this may conflict with the pull to refresh action.
  ///final ScrollController? verticalScrollController;

  ///Deprecated, use [onScrollControllerReady] return instead
  ///Horizontal scroll controller, expose for allowing manually jump to specific offset position.
  // final ScrollController? horizontalScrollController;

  ///Returning the vertical controller for external usage
  final OnScrollControllerReady? onScrollControllerReady;

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

  ///Fixed column side refresh indicator, default using [PlaceholderHeader]
  ///This will also trigger the onRefresh callback and the bi-directional side refresh action/ui
  final Widget? fixedSidePlaceHolderRefreshIndicator;

  ///Callback for pulled to refresh.
  ///Call HDTRefreshController.refreshCompleted() for finished refresh loading.
  ///Call HDTRefreshController.refreshFailed() for error refresh loading.
  final Function? onRefresh;

  ///Flag to indicate whether enable the pull_to_load function
  ///Default is false
  final bool enablePullToLoadNewData;

  ///Support using pull-to-refresh's load indicator
  final LoadIndicator? loadIndicator;

  ///Fixed column side load indicator, default using [PlaceholderFooter]
  ///This will also trigger the onLoad callback and the bi-directional side load action/ui
  final Widget? fixedSidePlaceHolderLoadIndicator;

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

  ///Enable Right to Left mode
  final bool enableRTL;

  ///[ListView] itemExtent. Specifying an itemExtent is more efficient than letting the children determine their own extent because the scrolling machinery can make use of the foreknowledge of the children's extent to save work, for example when the scroll position changes drastically.
  ///When it is non-null, SliverFixedExtentList is used in [ListView].
  final double? itemExtent;

  const HorizontalDataTable({
    required double leftHandSideColumnWidth,
    required double rightHandSideColumnWidth,
    this.tableHeight,
    this.isFixedHeader = false,
    this.headerWidgets,
    this.isFixedFooter = false,
    this.footerWidgets,
    IndexedWidgetBuilder? leftSideItemBuilder,
    IndexedWidgetBuilder? rightSideItemBuilder,
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
    this.onScrollControllerReady,
    this.verticalScrollbarStyle,
    this.horizontalScrollbarStyle,
    this.enablePullToRefresh = false,
    this.refreshIndicatorHeight = 60.0,
    this.htdRefreshController,
    this.onRefresh,
    this.refreshIndicator,
    this.fixedSidePlaceHolderRefreshIndicator,
    this.enablePullToLoadNewData = false,
    this.onLoad,
    this.loadIndicator,
    this.fixedSidePlaceHolderLoadIndicator,
    this.scrollPhysics,
    this.horizontalScrollPhysics,
    this.enableRTL = false,
    this.itemExtent,
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
    bool isFixedFooter = false,
    List<Widget>? footerWidgets,
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
    OnScrollControllerReady? onScrollControllerReady,
    ScrollbarStyle? verticalScrollbarStyle,
    ScrollbarStyle? horizontalScrollbarStyle,
    bool enablePullToRefresh = false,
    double refreshIndicatorHeight = 60.0,
    HDTRefreshController? htdRefreshController,
    Function? onRefresh,
    Widget? refreshIndicator,
    Widget? fixedSidePlaceHolderRefreshIndicator,
    bool enablePullToLoadNewData = false,
    Function? onLoad,
    LoadIndicator? loadIndicator,
    LoadIndicator? fixedSidePlaceHolderLoadIndicator,
    ScrollPhysics? scrollPhysics,
    ScrollPhysics? horizontalScrollPhysics,
    double? itemExtent,
  }) : this(
          leftHandSideColumnWidth: rightHandSideColumnWidth,
          rightHandSideColumnWidth: leftHandSideColumnWidth,
          tableHeight: tableHeight,
          isFixedHeader: isFixedHeader,
          headerWidgets: headerWidgets,
          isFixedFooter: isFixedFooter,
          footerWidgets: footerWidgets,
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
          onScrollControllerReady: onScrollControllerReady,
          verticalScrollbarStyle: verticalScrollbarStyle,
          horizontalScrollbarStyle: horizontalScrollbarStyle,
          enablePullToRefresh: enablePullToRefresh,
          refreshIndicatorHeight: refreshIndicatorHeight,
          htdRefreshController: htdRefreshController,
          onRefresh: onRefresh,
          refreshIndicator: refreshIndicator,
          fixedSidePlaceHolderRefreshIndicator:
              fixedSidePlaceHolderRefreshIndicator,
          enablePullToLoadNewData: enablePullToLoadNewData,
          onLoad: onLoad,
          loadIndicator: loadIndicator,
          fixedSidePlaceHolderLoadIndicator: fixedSidePlaceHolderLoadIndicator,
          scrollPhysics: scrollPhysics,
          horizontalScrollPhysics: horizontalScrollPhysics,
          enableRTL: true,
          itemExtent: itemExtent,
        );

  @override
  State<StatefulWidget> createState() {
    return _HorizontalDataTableState();
  }
}

class _HorizontalDataTableState extends State<HorizontalDataTable> {
  late TableControllers _tableControllers;
  ScrollShadowModel _scrollShadowModel = ScrollShadowModel();

  @override
  void initState() {
    super.initState();

    _tableControllers = TableControllers(
      isFixedHeader: widget.isFixedHeader,
      isFixedFooter: widget.isFixedFooter,
      enablePullToRefresh: widget.enablePullToRefresh,
      htdRefreshController: widget.htdRefreshController,
    );

    _tableControllers.init();

    _tableControllers.addHorizontalShadowListener(() {
      _scrollShadowModel.horizontalOffset =
          _tableControllers.bidirectionalSideHorizontalScrollController.offset;
    });

    _tableControllers.addVerticalShadowListener(() {
      _scrollShadowModel.verticalOffset =
          _tableControllers.bidirectionalSideListViewScrollController.offset;
    });

    if (widget.onScrollControllerReady != null) {
      widget.onScrollControllerReady!(
          _tableControllers.bidirectionalSideListViewScrollController,
          _tableControllers.bidirectionalSideHorizontalScrollController);
    }
  }

  @override
  void dispose() {
    _tableControllers.dispose();
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
              footer: widget.footerWidgets?.first,
              listView: _getPullToRefreshFixedSideListView(
                  _tableControllers.fixedSideListViewScrollController,
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
              footer: Row(
                mainAxisSize: MainAxisSize.min,
                children: widget.footerWidgets?.sublist(1).toList() ?? [],
              ),
              listView: _getPullToRefreshBidirectionalSideListView(
                  _tableControllers.bidirectionalSideListViewScrollController,
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
              width: ScrollShadowModel.getElevation(
                  horizontalOffset, widget.elevation),
              height: height,
              color: widget.elevationColor.withAlpha(
                ScrollShadowModel.getShadowAlpha(
                    ScrollShadowModel.getElevation(
                        horizontalOffset, widget.elevation),
                    widget.elevation),
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
    Widget? footer,
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
        if (widget.isFixedFooter)
          LayoutId(
            id: ListViewLayout.FooterDivider,
            child: widget.rowSeparatorWidget,
          ),
        LayoutId(
          id: ListViewLayout.ListView,
          child: listView,
        ),
        if (widget.isFixedFooter)
          LayoutId(
            id: ListViewLayout.Footer,
            child: footer!,
          ),
        LayoutId(
          id: ListViewLayout.Shadow,
          child: Selector<ScrollShadowModel, double>(
            selector: (context, scrollShadowModel) {
              return scrollShadowModel.verticalOffset;
            },
            builder: (context, verticalOffset, child) {
              double elevation = ScrollShadowModel.getElevation(
                  verticalOffset, widget.elevation);
              return Container(
                color: widget.elevationColor.withAlpha(
                    ScrollShadowModel.getShadowAlpha(
                        elevation, widget.elevation)),
                height: elevation,
              );
            },
          ),
        ),
        LayoutId(
          id: ListViewLayout.FooterShadow,
          child: Selector<ScrollShadowModel, double>(
            selector: (context, scrollShadowModel) {
              return scrollShadowModel.verticalOffset;
            },
            builder: (context, verticalOffset, child) {
              double elevation = 0;
              if (_tableControllers
                  .fixedSideListViewScrollController.positions.isNotEmpty) {
                elevation = ScrollShadowModel.getElevation(
                    _tableControllers.fixedSideListViewScrollController.position
                            .maxScrollExtent -
                        verticalOffset,
                    widget.elevation);
              }
              return Container(
                color: widget.elevationColor.withAlpha(
                    ScrollShadowModel.getShadowAlpha(
                        elevation, widget.elevation)),
                height: elevation,
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
    Widget? footer,
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
            child: SingleChildScrollView(
              physics: widget.horizontalScrollPhysics,
              controller: _tableControllers
                  .bidirectionalSideHeaderHorizontalScrollController!,
              scrollDirection: Axis.horizontal,
              child: header!,
            ),
          ),
        if (widget.isFixedHeader)
          LayoutId(
            id: ListViewLayout.Divider,
            child: widget.rowSeparatorWidget,
          ),
        if (widget.isFixedFooter)
          LayoutId(
            id: ListViewLayout.FooterDivider,
            child: widget.rowSeparatorWidget,
          ),
        LayoutId(
          id: ListViewLayout.ListView,
          child: CustomScrollBar(
            controller:
                _tableControllers.bidirectionalSideListViewScrollController,
            scrollbarStyle: widget.verticalScrollbarStyle,
            notificationPredicate: (ScrollNotification notification) {
              return notification.depth == 1;
            },
            child: CustomScrollBar(
              controller: this
                  ._tableControllers
                  .bidirectionalSideHorizontalScrollController,
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
              child: SingleChildScrollView(
                physics: widget.horizontalScrollPhysics,
                controller: _tableControllers
                    .bidirectionalSideHorizontalScrollController,
                scrollDirection: Axis.horizontal,
                child: Container(
                  width: widget.bidirectionalSideColumnWidth,
                  child: listView,
                ),
              ),
            ),
          ),
        ),
        if (widget.isFixedFooter)
          LayoutId(
            id: ListViewLayout.Footer,
            child: SingleChildScrollView(
              physics: widget.horizontalScrollPhysics,
              controller: _tableControllers
                  .bidirectionalSideFooterHorizontalScrollController!,
              scrollDirection: Axis.horizontal,
              child: footer!,
            ),
          ),
        LayoutId(
          id: ListViewLayout.Shadow,
          child: Selector<ScrollShadowModel, double>(
            selector: (context, scrollShadowModel) {
              return scrollShadowModel.verticalOffset;
            },
            builder: (context, verticalOffset, child) {
              double elevation = ScrollShadowModel.getElevation(
                  verticalOffset, widget.elevation);
              return Container(
                color: widget.elevationColor.withAlpha(
                    ScrollShadowModel.getShadowAlpha(
                        elevation, widget.elevation)),
                height: elevation,
              );
            },
          ),
        ),
        LayoutId(
          id: ListViewLayout.FooterShadow,
          child: Selector<ScrollShadowModel, double>(
            selector: (context, scrollShadowModel) {
              return scrollShadowModel.verticalOffset;
            },
            builder: (context, verticalOffset, child) {
              double elevation = 0;
              if (_tableControllers.bidirectionalSideListViewScrollController
                  .positions.isNotEmpty) {
                elevation = ScrollShadowModel.getElevation(
                    _tableControllers.bidirectionalSideListViewScrollController
                            .position.maxScrollExtent -
                        verticalOffset,
                    widget.elevation);
              }
              return Container(
                color: widget.elevationColor.withAlpha(
                    ScrollShadowModel.getShadowAlpha(
                        elevation, widget.elevation)),
                height: elevation,
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
      return ListView.builder(
        physics: widget.scrollPhysics,
        controller: scrollController,
        itemBuilder: (context, index) {
          return Column(
            children: [
              indexedWidgetBuilder(context, index),
              widget.rowSeparatorWidget,
            ],
          );
        },
        itemCount: itemCount,
        itemExtent: widget.itemExtent,
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
      controller: _tableControllers.bidirectionalSideRefreshController,
      enablePullDown: widget.enablePullToRefresh,
      enablePullUp: widget.enablePullToLoadNewData,
      onRefresh: () async {
        if (widget.onRefresh != null) {
          widget.htdRefreshController?.requestRefresh(
              _tableControllers.bidirectionalSideRefreshController);

          /// i have no choice, since the status of load and refresh not so reliable
          /// the 100ms is for
          /// [1] waiting the 50ms of pull-to-refresh package nestscrollview handling
          /// [2] ensure 2 refresh controller status is stable
          await Future.delayed(const Duration(milliseconds: 100), () {
            widget.onRefresh!();
          });
        }
      },
      onLoading: () async {
        if (widget.onLoad != null) {
          widget.htdRefreshController?.requestLoading(
              _tableControllers.bidirectionalSideRefreshController);

          /// same reason as the onRefresh 100ms delay
          await Future.delayed(const Duration(milliseconds: 100), () {
            widget.onLoad!();
          });
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
      controller: _tableControllers.fixedSideRefreshController,
      enablePullDown: widget.enablePullToRefresh,
      enablePullUp: widget.enablePullToLoadNewData,
      header: widget.fixedSidePlaceHolderRefreshIndicator ??
          PlaceholderHeader(
            height: widget.refreshIndicatorHeight,
          ),
      footer: widget.fixedSidePlaceHolderLoadIndicator ??
          PlaceholderFooter(
            height: widget.loadIndicator?.height ?? 60.0,
          ),
      onRefresh: () {
        if (widget.onRefresh != null) {
          widget.htdRefreshController?.requestRefresh(
            _tableControllers.fixedSideRefreshController,
          );
        }
      },
      onLoading: () {
        if (widget.onLoad != null) {
          widget.htdRefreshController?.requestLoading(
            _tableControllers.fixedSideRefreshController,
          );
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
}
