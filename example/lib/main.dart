import 'dart:io';

import 'package:example/data/user.dart';
import 'package:example/simple_rtl_table.dart';
import 'package:example/simple_table.dart';
import 'package:example/simple_table_refresh_load.dart';
import 'package:example/simple_table_refresh_load_desktop.dart';
import 'package:example/simple_table_scroll_style.dart';
import 'package:example/simple_table_sort.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  User _user = User();
  @override
  void initState() {
    _user.initData(100);
    super.initState();
  }

  bool get isDesktop =>
      Platform.isLinux || Platform.isMacOS || Platform.isWindows;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            _getRouteButton(
              'Simple Table',
              SimpleTablePage(
                user: _user,
              ),
            ),
            _getRouteButton(
              'RTL Table',
              SimpleTableRTLPage(
                user: _user,
              ),
            ),
            _getRouteButton(
              'Pull-to-refresh Table',
              isDesktop
                  ? SimpleTableDesktopRefreshLoadPage(
                      user: _user,
                    )
                  : SimpleTableRefreshLoadPage(
                      user: _user,
                    ),
            ),
            _getRouteButton(
              'Customize Scroll Related Table',
              SimpleTableScrollStylePage(
                user: _user,
              ),
            ),
            _getRouteButton(
              'Sortable Table',
              SimpleTableSortPage(
                user: _user,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getRouteButton(String label, Widget page) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return page;
              },
            ),
          );
        },
        child: Text(
          label,
        ),
      ),
    );
  }
}
