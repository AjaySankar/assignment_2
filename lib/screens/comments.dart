import 'package:flutter/material.dart';

class Comments extends StatefulWidget {
  Comments(this.postId);
  final int postId;

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  var rating = 3.0;

  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}