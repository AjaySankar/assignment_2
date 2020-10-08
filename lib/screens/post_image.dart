import 'package:flutter/material.dart';

class PostImage extends StatefulWidget {
  PostImage(this.postId);
  final int postId;

  @override
  _PostImageState createState() => _PostImageState();
}

class _PostImageState extends State<PostImage> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FittedBox(
        fit: BoxFit.fitWidth, // otherwise the logo will be tiny
        child: const FlutterLogo(),
      ),
    );
  }
}