import 'package:flutter/material.dart'
    hide RefreshIndicator, RefreshIndicatorState;
import '../../pull_to_refresh.dart';

/// use at the first fixed column refresh or load part,
/// mainly fill the action area
class PlaceholderHeader extends RefreshIndicator {
  final Color backgroundColor;
  const PlaceholderHeader({
    Key? key,
    RefreshStyle refreshStyle = RefreshStyle.Follow,
    double height = 60.0,
    Duration completeDuration = const Duration(milliseconds: 600),
    this.backgroundColor = Colors.transparent,
  }) : super(
          key: key,
          refreshStyle: refreshStyle,
          completeDuration: completeDuration,
          height: height,
        );

  @override
  State createState() {
    return _PlaceholderHeaderState();
  }
}

class _PlaceholderHeaderState extends RefreshIndicatorState<PlaceholderHeader> {
  @override
  bool needReverseAll() {
    return false;
  }

  @override
  Widget buildContent(BuildContext context, RefreshStatus? mode) {
    return Container(
      color: widget.backgroundColor,
      height: widget.height,
    );
  }
}

/// same reason as [PlaceholderHeader]
class PlaceholderFooter extends LoadIndicator {
  final Color backgroundColor;

  /// notice that ,this attrs only works for LoadStyle.ShowWhenLoading
  final Duration completeDuration;

  const PlaceholderFooter({
    Key? key,
    VoidCallback? onClick,
    LoadStyle loadStyle = LoadStyle.ShowAlways,
    double height = 60.0,
    this.backgroundColor = Colors.transparent,
    this.completeDuration = const Duration(milliseconds: 300),
  }) : super(
          key: key,
          loadStyle: loadStyle,
          height: height,
          onClick: onClick,
        );

  @override
  State<StatefulWidget> createState() {
    return _PlaceholderFooterState();
  }
}

class _PlaceholderFooterState extends LoadIndicatorState<PlaceholderFooter> {
  @override
  Future endLoading() {
    return Future.delayed(widget.completeDuration);
  }

  @override
  Widget buildContent(BuildContext context, LoadStatus? mode) {
    return Container(
      color: widget.backgroundColor,
      height: widget.height,
    );
  }
}
