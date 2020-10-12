import 'package:flutter/material.dart';
import 'package:assignment_2/screens/insta_post.dart';
import 'package:assignment_2/utils/errorScreen.dart';
import 'package:assignment_2/utils/emptyFeedScreen.dart';

class _FeedListBuilder extends StatelessWidget {
  final List<InstaPost> items;

  _FeedListBuilder({Key key, @required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = 'Long List';

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return items[index];
      },
    );
  }
}

class Feed extends StatefulWidget {
  final Future<Map<String, dynamic>> _fetchPostsFuture;
  Feed(@required this._fetchPostsFuture);
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
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
          return getEmptyFeedScreen("Feed is empty");
        }
        return _FeedListBuilder(items: getInstaPosts(postIds));
      }
      return getErrorScreen(response['message']);
    };

    return FutureBuilder<Map<String, dynamic>>(
        future: widget._fetchPostsFuture,
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
          return Center(
            child: widget,
          );
        }
    );
  }
}