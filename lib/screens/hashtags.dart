import 'package:flutter/material.dart';
import 'package:assignment_2/utils/theme.dart';

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
              text: '${hashTag} ',
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