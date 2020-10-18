// Show a nickname's feed.
import 'package:assignment_2/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:assignment_2/utils/request_states.dart';
import 'package:assignment_2/network/getFriendPosts.dart';
import 'package:assignment_2/screens/feed.dart';

class FriendFeed extends StatelessWidget {
  final String nickName; // Friend's nickname
  FriendFeed(this.nickName);
  final GetFriendPosts getFriendPostsHandle = GetFriendPosts((Status requestState) => {});

  @override
  Widget build(BuildContext context) {
    var getAppBar = () {
      return AppBar(
        title: Text("$nickName 's posts"),
        backgroundColor: getThemeColor(),
      );
    };

    return Scaffold(
      appBar: getAppBar(),
      body: Center(
        child: Feed(
            getFriendPostsHandle.getFriendPostIds(nickName)
        ),
      ),
    );
  }
}