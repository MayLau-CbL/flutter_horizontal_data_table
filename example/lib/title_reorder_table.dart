import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

import 'data/user.dart';

class TitleReorderTablePage extends StatefulWidget {
  const TitleReorderTablePage({
    Key? key,
    required this.user,
  }) : super(key: key);
  final User user;

  @override
  State<TitleReorderTablePage> createState() => _TitleReorderTablePageState();
}

class _TitleReorderTablePageState extends State<TitleReorderTablePage> {
  late List<UserColumnInfo> _colInfos;
  double get _sumOfRightColumnWidth {
    return _colInfos
        .sublist(1)
        .map((e) => e.width)
        .fold(0, (previousValue, element) => previousValue + element);
  }

  @override
  void initState() {
    super.initState();
    widget.user.initData(100);
    _colInfos = [
      const UserColumnInfo('Name', 100),
      const UserColumnInfo('Status', 100),
      const UserColumnInfo('Phone', 200),
      const UserColumnInfo('Register', 100),
      const UserColumnInfo('Termination', 200),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reorderable Header/Footer Table')),
      body: HorizontalDataTable(
        leftHandSideColumnWidth: _colInfos.first.width,
        rightHandSideColumnWidth: _sumOfRightColumnWidth,
        isFixedHeader: true,
        headerWidgets: _getTitleWidget(),
        isFixedFooter: true,
        footerWidgets: _getTitleWidget(),
        leftSideItemBuilder: _generateFirstColumnRow,
        rightSideItemBuilder: _generateRightHandSideColumnRow,
        itemCount: widget.user.userInfo.length,
        rowSeparatorWidget: const Divider(
          color: Colors.black38,
          height: 1.0,
          thickness: 0.0,
        ),
        leftHandSideColBackgroundColor: const Color(0xFFFFFFFF),
        rightHandSideColBackgroundColor: const Color(0xFFFFFFFF),
      ),
    );
  }

  List<Widget> _getTitleWidget() {
    return _colInfos
        .map((e) => DragTarget(
              builder: (context, candidateData, rejectedData) {
                return Draggable<String>(
                  data: e.name,
                  feedback:
                      Material(child: _getTitleItemWidget(e.name, e.width)),
                  child: _getTitleItemWidget(e.name, e.width),
                );
              },
              onWillAccept: (value) {
                return value != e.name;
              },
              onAccept: (value) {
                int oldIndex =
                    _colInfos.indexWhere((element) => element.name == value);
                int newIndex =
                    _colInfos.indexWhere((element) => element.name == e.name);
                UserColumnInfo temp = _colInfos.removeAt(oldIndex);
                _colInfos.insert(newIndex, temp);
                setState(() {});
              },
            ))
        .toList();
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      width: width,
      height: 56,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _generateGeneralColumnCell(
      BuildContext context, int rowIndex, int colIndex) {
    return Container(
      width: _colInfos[colIndex].width,
      height: 52,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
      child: Text(widget.user.userInfo[rowIndex].get(_colInfos[colIndex].name)),
    );
  }

  Widget _generateIconColumnCell(
      BuildContext context, int rowIndex, int colIndex) {
    return Container(
      width: 100,
      height: 52,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          Icon(
              widget.user.userInfo[rowIndex].status
                  ? Icons.notifications_off
                  : Icons.notifications_active,
              color: widget.user.userInfo[rowIndex].status
                  ? Colors.red
                  : Colors.green),
          Text(widget.user.userInfo[rowIndex].status ? 'Disabled' : 'Active')
        ],
      ),
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int rowIndex) {
    if (_colInfos.first.name == 'Status') {
      return _generateIconColumnCell(context, rowIndex, 0);
    } else {
      return _generateGeneralColumnCell(context, rowIndex, 0);
    }
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int rowIndex) {
    return Row(
      children: _colInfos.sublist(1).map((e) {
        if (e.name == 'Status') {
          return _generateIconColumnCell(
              context, rowIndex, _colInfos.indexOf(e));
        } else {
          return _generateGeneralColumnCell(
              context, rowIndex, _colInfos.indexOf(e));
        }
      }).toList(),
    );
  }
}
