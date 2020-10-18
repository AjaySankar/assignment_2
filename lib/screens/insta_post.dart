import 'package:assignment_2/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:assignment_2/screens/post_image.dart';
import 'package:assignment_2/screens/rating_stars.dart';
import 'package:assignment_2/screens/comments.dart';
import 'package:assignment_2/utils/request_states.dart';
import 'package:assignment_2/network/getPost.dart';
import 'package:assignment_2/post/post.dart';
import 'package:assignment_2/post/post_provider.dart';
import 'package:provider/provider.dart';

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

    Widget getErrorCardContents([IconData icon = Icons.broken_image, Color iconColor = Colors.red, errorMsg = 'Failed to fetch post']) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            color: iconColor,
            size: 60,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text('Error: $errorMsg'),
          )
        ],
      );
    }

    Widget buildInstaPostCardContents() {
      return Column (
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          PostImage(),
          SizedBox(height: 10.0),
          RatingStars(),
          SizedBox(height: 10.0),
          PostDescription(),
          SizedBox(height: 10.0),
          HashTags(),
          Comments()
        ],
      );
    }

    Widget buildCard(Widget cardContents) {
      return Card(
        child: Container(
          alignment: Alignment.center,
          child: cardContents,
        ),
      );
    }

    Widget buildPostChangeNotifierProvider(BuildContext context, Post initPostData, Widget cardContents) {
      return ChangeNotifierProvider(
        create: (context) => PostModel(initPostData),
        child: buildCard(cardContents)
      );
    }

    Future<Map<String, dynamic>> _fetchPost = getPostHandle.getInstaPost(widget.postId);
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchPost,
      builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        Widget instaPost;
        if(snapshot.hasData) {
          // print(snapshot.data);
          Map response = snapshot.data;
          Widget cardContents;
          if(response['status']) {
            Post fetchedPost = Post.fromJSON(response['body']['post']);
            fetchedPost.setPostId(widget.postId);
            cardContents = buildInstaPostCardContents();
            instaPost = buildPostChangeNotifierProvider(context, fetchedPost, cardContents);
          }
          else {
            cardContents = getErrorCardContents();
            instaPost = buildCard(cardContents);
          }
        }
        else if(snapshot.hasError) {
          Widget cardContents = getErrorCardContents(Icons.error_outline, getThemeColor());
          instaPost = buildCard(cardContents);
        }
        else {
          Widget cardContents = SizedBox(
              child: CircularProgressIndicator(),
              width: 60,
              height: 60,
            );
          instaPost = buildCard(cardContents);
        }
        return instaPost;
      },
    );
  }
}


class HashTags extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostModel>(context, listen: false);
    return Text.rich(
      TextSpan(
          children: [
            ...postProvider.hashTags.map((hashTag) {
              return TextSpan(
                  text: hashTag,
                  style: TextStyle(
                      color: getThemeColor(),
                  )
              );
            }).toList()
          ]
      ),
    );
  }
}

class PostDescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostModel>(context, listen: false);
    return Text(
        postProvider.description,
      style: TextStyle(
        fontSize: 15
      ),
    );
  }
}