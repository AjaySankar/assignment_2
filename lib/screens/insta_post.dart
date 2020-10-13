import 'package:assignment_2/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:assignment_2/screens/post_image.dart';
import 'package:assignment_2/screens/rating_stars.dart';
import 'package:assignment_2/screens/comments.dart';
import 'package:assignment_2/utils/request_states.dart';
import 'package:assignment_2/network/getPost.dart';
import 'package:assignment_2/post/post.dart';

class InstaPost extends StatefulWidget {
  InstaPost(this.postId);
  final int postId;

  @override
  InstaPostState createState() => InstaPostState();
}

class InstaPostState extends State<InstaPost> with AutomaticKeepAliveClientMixin {
  GetPost getPostHandle;

  @override
  void initState() {
    super.initState();
    getPostHandle = GetPost((Status requestState) => {});
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var getCardContents = (response) {
      if(response['status']) {
        Post post = Post.fromJSON(response['body']['post']);
        return Column (
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            PostImage(post.image),
            SizedBox(height: 10.0),
            RatingStars(widget.postId),
            SizedBox(height: 10.0),
            Text(post.description),
            SizedBox(height: 10.0),
            HashTags(post.hashTags),
            Comments(widget.postId, post.comments)
          ],
        );
      }
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.broken_image,
            color: Colors.red,
            size: 60,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text('Error: ${response['message']}'),
          )
        ],
      );
    };

    Future<Map<String, dynamic>> _fetchPost = getPostHandle.getInstaPost(widget.postId);
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchPost,
      builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        Widget cardChild;
        if(snapshot.hasData) {
          // print(snapshot.data);
          cardChild = getCardContents(snapshot.data);
        }
        else if(snapshot.hasError) {
          cardChild = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.error_outline,
                color: getThemeColor(),
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ],
          );
        }
        else {
          cardChild = SizedBox(
              child: CircularProgressIndicator(),
              width: 60,
              height: 60,
            );
        }
        return Card(
          child: Container(
            alignment: Alignment.center,
            child: cardChild,
          ),
        );
      },
    );
  }
}


class HashTags extends StatelessWidget {
  HashTags(this.hashTags);
  final List<String> hashTags;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
          children: [
            ...hashTags.map((hashTag) {
              return TextSpan(
                  text: hashTag,
                  style: TextStyle(
                      color: getThemeColor()
                  )
              );
            }).toList()
          ]
      ),
    );
  }
}