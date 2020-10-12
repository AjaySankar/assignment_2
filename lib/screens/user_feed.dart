import 'package:flutter/material.dart';
import 'package:assignment_2/screens/friend_feed.dart';

class UserFeed extends StatelessWidget {
  final String nickName;

  UserFeed({Key key, @required this.nickName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FriendFeed("ajaytest");
  }
}