import 'package:flutter/material.dart';
import 'package:assignment_2/utils/theme.dart';
import 'package:assignment_2/screens/nicknames.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.contacts), text: "Nick names",),
              Tab(icon: Icon(Icons.directions_transit), text: "Hash tags"),
            ],
          ),
          title: Text('InstaPost'),
          backgroundColor: getThemeColor(),
        ),
        body: TabBarView(
          children: [
            NickNames(),
            Center( child: Text("Page 2")),
          ],
        ),
      ),
    );
  }
}