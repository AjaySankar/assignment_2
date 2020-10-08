import 'package:assignment_2/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:assignment_2/network/commentPost.dart';
import 'package:assignment_2/utils/request_states.dart';
import 'package:assignment_2/utils/snackBar.dart';

class Comments extends StatefulWidget {
  final int postId;
  final List<String> comments;
  Comments(this.postId, this.comments);
  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final TextEditingController _commentController = TextEditingController();
  List<String> comments;
  CommentPost commentPostHandle;
  @override
  void initState() {
    comments = widget.comments;
    commentPostHandle = CommentPost((Status requestState) => {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var addComment = (newComment) {
      if(newComment.length == 0) {
        return;
      }
      _commentController.clear();
      commentPostHandle.comment(widget.postId, newComment).then((Map<String, dynamic> response) {
        print(response);
        if(!response['status']) {
          showSnackBar(response['message']??'Failed to rate post. Try again !!', context);
        }
        else {
          setState(() {
            comments = [...comments, newComment];
          });
        }
      });
    };

    return Column(
      children: [
        CommentsList(comments),
        Divider(),
        ListTile(
          title: TextFormField(
            controller: _commentController,
            decoration: InputDecoration(labelText: 'Write a comment...'),
            onFieldSubmitted: addComment,
          ),
          trailing: FlatButton(
            onPressed: (){addComment(_commentController.text);},
            color: getThemeColor(),
            textColor: Colors.white,
            child: Text("Post"),
          ),
        )
      ],
    );
  }
}

class CommentsList extends StatelessWidget {
  final List<String> comments;
  const CommentsList(this.comments);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ExpansionTile(
        leading: Icon(Icons.comment),
        trailing: Text(comments.length.toString()),
        title: Text("Click to see comments"),
        children: List<Widget>.generate(
          comments.length,
              (int index) => SingleComment(comments[index]),
        ),
      ),
    );
  }
}

class SingleComment extends StatelessWidget {
  final String comment;

  const SingleComment(@required this.comment);

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            comment,
            textAlign: TextAlign.left,
          ),
          Divider(
            color: Colors.black45,
          ),
        ],
      ),
    );
  }
}