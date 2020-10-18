// Show logged in user feed.
import 'package:flutter/material.dart';
import 'package:assignment_2/screens/feed.dart';
import 'package:assignment_2/network/getFriendPosts.dart';
import 'package:assignment_2/utils/request_states.dart';
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
    );
  }
}