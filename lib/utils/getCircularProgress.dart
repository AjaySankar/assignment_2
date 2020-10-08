import 'package:flutter/material.dart';

var getCircularProgress = ([width = 60, height = 60]) {
  return SizedBox(
    child: CircularProgressIndicator(),
    width: width,
    height: height,
  );
};