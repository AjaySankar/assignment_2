import 'package:flutter/material.dart';
import 'package:assignment_2/utils/theme.dart';
import 'package:assignment_2/screens/nicknames.dart';
import 'package:assignment_2/screens/hashtag_tab.dart';
import 'package:assignment_2/screens/user_feed.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:assignment_2/screens/create_post.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(FontAwesomeIcons.user), text: "Your feed",),
              Tab(icon: Icon(FontAwesomeIcons.userFriends), text: "Nick names",),
              Tab(icon: Icon(FontAwesomeIcons.hashtag), text: "Hash tags"),
              Tab(icon: Icon(FontAwesomeIcons.plus), text: "New post"),
            ],
          ),
          title: Text('InstaPost'),
          backgroundColor: getThemeColor(),
        ),
        body: TabBarView(
          children: [
            UserFeed(),
            NickNames(),
            HashTagsTab(),
            PostForm()
          ],
        ),
      ),
    );
  }
}