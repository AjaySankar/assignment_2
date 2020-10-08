import 'package:flutter/material.dart';

var showSnackBar = (text, context) => {
  Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('${text}'),
        duration: Duration(seconds: 3),
      )
  )
};