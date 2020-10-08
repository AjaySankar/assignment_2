import 'package:flutter/material.dart';
import 'package:assignment_2/screens/insta_post.dart';

class Feed extends StatelessWidget {
  final List<InstaPost> items;

  Feed({Key key, @required this.items}) : super(key: key);

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