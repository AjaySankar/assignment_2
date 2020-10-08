import 'package:flutter/material.dart';

var getCircularProgress = ([double width = 60, double height = 60]) {
  return SizedBox(
    child: CircularProgressIndicator(),
    width: width,
    height: height,
  );
};