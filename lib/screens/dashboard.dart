import 'package:flutter/material.dart';
import 'package:assignment_2/utils/theme.dart';
import 'package:assignment_2/screens/nicknames.dart';
import 'package:assignment_2/screens/hashtag_tab.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
              Tab(icon: Icon(FontAwesomeIcons.userFriends), text: "Nick names",),
              Tab(icon: Icon(FontAwesomeIcons.hashtag), text: "Hash tags"),
            ],
          ),
          title: Text('InstaPost'),
          backgroundColor: getThemeColor(),
        ),
        body: TabBarView(
          children: [
            NickNames(),
            HashTags(),
          ],
        ),
      ),
    );
  }
}