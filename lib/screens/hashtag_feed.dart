import 'package:assignment_2/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:assignment_2/utils/request_states.dart';
import 'package:assignment_2/network/getHashTagPosts.dart';
import 'package:assignment_2/utils/errorScreen.dart';
import 'package:assignment_2/utils/emptyFeedScreen.dart';
import 'package:assignment_2/screens/insta_post.dart';
import 'package:assignment_2/screens/feed.dart';

class HashTagFeed extends StatefulWidget {
  final String hashTag; // Hashtag to find posts
  HashTagFeed(this.hashTag);
  @override
  _HashTagFeedState createState() => _HashTagFeedState();
}

class _HashTagFeedState extends State<HashTagFeed> {
  GetHashTagPosts getHashTagPostsHandle;

  @override
  void initState() {
    super.initState();
    getHashTagPostsHandle = GetHashTagPosts((Status requestState) => {});
  }

  @override
  Widget build(BuildContext context) {

    List<InstaPost> getInstaPosts(List<int> postIds) {
      return postIds.map((postId) => InstaPost(postId)).toList();
    };

    var buildFeed = (response) {
      if(response['status']) {
        List<int> postIds = [];
        response['body']['ids'].forEach((id) => postIds.add(id));
        if(postIds.length == 0){
          return getEmptyFeedScreen("HashTag's feed is empty");
        }
        return Feed(items: getInstaPosts(postIds));
      }
      return getErrorScreen(response['message']);
    };

    var getAppBar = () {
      return AppBar(
        title: Text("${widget.hashTag} 's posts"),
        backgroundColor: getThemeColor(),
      );
    };

    Future<Map<String, dynamic>> _fetchHashTagPostIds = getHashTagPostsHandle.getHashTagPostIds(widget.hashTag);
    return FutureBuilder<Map<String, dynamic>>(
        future: _fetchHashTagPostIds,
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          Widget widget;
          if(snapshot.hasData) {
            widget = buildFeed(snapshot.data);
          }
          else if(snapshot.hasError) {
            widget = getErrorScreen(snapshot.error);
          }
          else {
            widget = CircularProgressIndicator();
          }
          return Scaffold(
            appBar: getAppBar(),
            body: Center(
              child: widget,
            ),
          );
        }
    );
  }
}