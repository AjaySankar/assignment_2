// Show a hashtag's feed.
import 'package:assignment_2/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:assignment_2/utils/request_states.dart';
import 'package:assignment_2/network/getHashTagPosts.dart';
import 'package:assignment_2/screens/feed.dart';

class HashTagFeed extends StatelessWidget {
  final String hashTag; // Hashtag to find posts
  HashTagFeed(this.hashTag);
  final GetHashTagPosts getHashTagPostsHandle = GetHashTagPosts((Status requestState) => {});

  @override
  Widget build(BuildContext context) {
    var getAppBar = () {
      return AppBar(
        title: Text("$hashTag posts"),
        backgroundColor: getThemeColor(),
      );
    };

    return Scaffold(
      appBar: getAppBar(),
      body: Center(
        child: Feed(
            getHashTagPostsHandle.getHashTagPostIds(hashTag)
        ),
      ),
    );
  }
}