import 'package:assignment_2/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:assignment_2/utils/request_states.dart';
import 'package:assignment_2/network/getFriendPosts.dart';
import 'package:assignment_2/utils/circularProgress.dart';
import 'package:assignment_2/utils/errorScreen.dart';
import 'package:assignment_2/screens/insta_post.dart';
import 'package:assignment_2/screens/feed.dart';

class FriendFeed extends StatefulWidget {
  final String nickName; // Friend's nickname
  FriendFeed(this.nickName);
  @override
  _FriendFeedState createState() => _FriendFeedState();
}

class _FriendFeedState extends State<FriendFeed> {
  GetFriendPosts getFriendPostsHandle;

  @override
  void initState() {
    getFriendPostsHandle = GetFriendPosts((Status requestState) => {});
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
          // return no posts screen..
        }
        return Feed(items: getInstaPosts(postIds));
      }
      return getErrorScreen(response['message']);
    };

    var getAppBar = () {
      return AppBar(
        title: Text("${widget.nickName} 's posts"),
        backgroundColor: getThemeColor(),
      );
    };

    Future<Map<String, dynamic>> _fetchFriendPostIds = getFriendPostsHandle.getFriendPostIds(widget.nickName);
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchFriendPostIds,
      builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        Widget widget;
        if(snapshot.hasData) {
          widget = buildFeed(snapshot.data);
        }
        else if(snapshot.hasError) {
          widget = getErrorScreen(snapshot.error);
        }
        else {
          widget = getCircularProgress();
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