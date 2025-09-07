import 'dart:io';

import 'package:example/data/user.dart';
import 'package:example/simple_rtl_table.dart';
import 'package:example/simple_table.dart';
import 'package:example/simple_table_keepalive_image.dart';
import 'package:example/simple_table_refresh_load.dart';
import 'package:example/simple_table_refresh_load_desktop.dart';
import 'package:example/simple_table_scroll_style.dart';
import 'package:example/simple_table_sort.dart';
import 'package:example/title_reorder_table.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final User _user = User();
  @override
  void initState() {
    _user.initData(100);
    super.initState();
  }

  bool get isDesktopOrWeb {
    if (kIsWeb) {
      return true;
    }
    return Platform.isLinux || Platform.isMacOS || Platform.isWindows;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          children: [
            _getRouteButton('Simple Table', SimpleTablePage(user: _user)),
            _getRouteButton('RTL Table', SimpleTableRTLPage(user: _user)),
            _getRouteButton(
              'Reorderable Header/Footer Table',
              TitleReorderTablePage(user: _user),
            ),
            _getRouteButton(
              'Pull-to-refresh Table',
              isDesktopOrWeb
                  ? SimpleTableDesktopRefreshLoadPage(user: _user)
                  : SimpleTableRefreshLoadPage(user: _user),
            ),
            _getRouteButton(
              'Customize Scroll Related Table',
              SimpleTableScrollStylePage(user: _user),
            ),
            _getRouteButton('Sortable Table', SimpleTableSortPage(user: _user)),
            _getRouteButton(
              'Keep Alive Image Table',
              SimpleTableKeepAliveImagePage(user: _user),
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
        child: Text(label),
      ),
    );
  }
}
