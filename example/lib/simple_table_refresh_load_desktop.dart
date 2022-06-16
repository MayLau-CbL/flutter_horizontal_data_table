import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

import 'data/user.dart';

class SimpleTableDesktopRefreshLoadPage extends StatefulWidget {
  SimpleTableDesktopRefreshLoadPage({
    Key? key,
    required this.user,
  }) : super(key: key);
  final User user;

  @override
  _SimpleTableDesktopRefreshLoadPageState createState() =>
      _SimpleTableDesktopRefreshLoadPageState();
}

class _SimpleTableDesktopRefreshLoadPageState
    extends State<SimpleTableDesktopRefreshLoadPage> {
  HDTRefreshController _hdtRefreshController = HDTRefreshController();

  @override
  void initState() {
    widget.user.initData(100);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pull-to-refresh Table')),
      body: ScrollConfiguration(
        ///since pull to refresh only works on drag action
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
        ),
        child: HorizontalDataTable(
          leftHandSideColumnWidth: 100,
          rightHandSideColumnWidth: 600,
          isFixedHeader: true,
          headerWidgets: _getTitleWidget(),
          leftSideItemBuilder: _generateFirstColumnRow,
          rightSideItemBuilder: _generateRightHandSideColumnRow,
          itemCount: widget.user.userInfo.length,
          rowSeparatorWidget: const Divider(
            color: Colors.black54,
            height: 1.0,
            thickness: 0.0,
          ),
          leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
          rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
          enablePullToRefresh: true,
          refreshIndicator: const ClassicHeader(),
          fixedSidePlaceHolderRefreshIndicator: PlaceholderHeader(),
          refreshIndicatorHeight: 60,
          onRefresh: () async {
            debugPrint('onRefresh');
            //Do sth
            await Future.delayed(const Duration(milliseconds: 500));
            _hdtRefreshController.refreshCompleted();
          },
          enablePullToLoadNewData: true,
          loadIndicator: const ClassicFooter(),
          fixedSidePlaceHolderLoadIndicator: PlaceholderFooter(),
          onLoad: () async {
            debugPrint('onLoad');
            //Do sth
            await Future.delayed(const Duration(milliseconds: 500));
            _hdtRefreshController.loadComplete();
          },
          htdRefreshController: _hdtRefreshController,
        ),
      ),
    );
  }

  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget('Name', 100),
      _getTitleItemWidget('Status', 100),
      _getTitleItemWidget('Phone', 200),
      _getTitleItemWidget('Register', 100),
      _getTitleItemWidget('Termination', 200),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
      width: width,
      height: 56,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      child: Text(widget.user.userInfo[index].name),
      width: 100,
      height: 52,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Row(
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Icon(
                  widget.user.userInfo[index].status
                      ? Icons.notifications_off
                      : Icons.notifications_active,
                  color: widget.user.userInfo[index].status
                      ? Colors.red
                      : Colors.green),
              Text(widget.user.userInfo[index].status ? 'Disabled' : 'Active')
            ],
          ),
          width: 100,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(widget.user.userInfo[index].phone),
          width: 200,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(widget.user.userInfo[index].registerDate),
          width: 100,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(widget.user.userInfo[index].terminationDate),
          width: 200,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
      ],
    );
  }
}
