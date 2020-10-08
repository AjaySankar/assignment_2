//https://pub.dev/packages/smooth_star_rating

import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:assignment_2/utils/theme.dart';

class RatingStars extends StatefulWidget {
  RatingStars(this.postId);
  final int postId;

  @override
  _RatingStarsState createState() => _RatingStarsState();
}

class _RatingStarsState extends State<RatingStars> {
  var rating = 3.0;

  @override
  Widget build(BuildContext context) {
    return SmoothStarRating(
      color: getThemeColor(),
      borderColor: getThemeColor(),
      rating: rating,
      isReadOnly: false,
      size: 20,
      filledIconData: Icons.star,
      halfFilledIconData: Icons.star_half,
      defaultIconData: Icons.star_border,
      starCount: 5,
      allowHalfRating: false,
      spacing: 2.0,
      onRated: (value) {
        print("rating value -> $value");
        // print("rating value dd -> ${value.truncate()}");
      },
    );
  }
}