import 'package:flutter/material.dart';
import 'package:assignment_2/utils/theme.dart';

class UploadImage extends StatefulWidget {
  final int postId;

  UploadImage(@required this.postId);

  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("InstaPost"),
        backgroundColor: getThemeColor(),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(child: Text("Upload image here for Post with id ${widget.postId}")),
              ],
            ),
          ),
        ),
      )
    );
  }
}