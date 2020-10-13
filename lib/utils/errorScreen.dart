import 'package:flutter/material.dart';

Widget getErrorScreen([error = 'Failed to load', icon = Icons.error_outline, iconColor = Colors.red]) {
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
        child: Text('Error: $error'),
      )
    ],
  );
}