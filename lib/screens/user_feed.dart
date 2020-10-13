import 'package:flutter/material.dart';
import 'package:assignment_2/screens/feed.dart';
import 'package:assignment_2/screens/create_post.dart';
import 'package:assignment_2/network/getFriendPosts.dart';
import 'package:assignment_2/utils/request_states.dart';
import 'package:assignment_2/utils/theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:assignment_2/user/user.dart';

class UserFeed extends StatelessWidget {
  final GetFriendPosts getFriendPostsHandle = GetFriendPosts((Status requestState) => {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Feed (
          getFriendPostsHandle.getFriendPostIds(User().nickName)
        )
      ),
      floatingActionButton: FloatingActionButton(
          heroTag: "User feed fab",
          backgroundColor: getThemeColor(),
          child: Icon(
            FontAwesomeIcons.plus,
            semanticLabel: 'Create a new post',
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostForm(),
                )
            );
          }
      )
    );
  }
}