// Tab view for user home, nicknames, hashtags and create post form.
import 'package:flutter/material.dart';
import 'package:assignment_2/utils/theme.dart';
import 'package:assignment_2/screens/nicknames.dart';
import 'package:assignment_2/screens/hashtag_tab.dart';
import 'package:assignment_2/screens/user_feed.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:assignment_2/screens/create_post.dart';
import 'package:assignment_2/network/addPost.dart';
import 'package:assignment_2/utils/request_states.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {

  Status _uploadOfflinePostStatus = Status.NotRequested;

  @override
  void initState() {
    AddInstaPost addPostHandle = AddInstaPost((Status requestState) {
      setState(() {
        _uploadOfflinePostStatus = requestState;
      });
    });
    addPostHandle.processOfflinePosts();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(FontAwesomeIcons.home)),
              Tab(icon: Icon(FontAwesomeIcons.userFriends)),
              Tab(icon: Icon(FontAwesomeIcons.hashtag)),
              Tab(icon: Icon(FontAwesomeIcons.plusCircle)),
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