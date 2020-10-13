import 'package:flutter/material.dart';

Widget getEmptyFeedScreen([emptyFeedDialogue = 'Empty Feed', icon = Icons.filter_none, iconColor = const Color(0xfff4267B2)]) {
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
        child: Text(emptyFeedDialogue),
      )
    ],
  );
}