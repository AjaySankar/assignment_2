//https://pub.dev/packages/smooth_star_rating

import 'package:assignment_2/insta_post_requests/ratePost.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:assignment_2/utils/theme.dart';
import 'package:assignment_2/utils/request_states.dart';
import 'package:assignment_2/utils/snackBar.dart';

class RatingStars extends StatefulWidget {
  RatingStars(this.postId);
  final int postId;

  @override
  _RatingStarsState createState() => _RatingStarsState();
}

class _RatingStarsState extends State<RatingStars> {

  RatePost ratePostHandle;
  var rating = 0.0;
  bool isReadOnly = false; // Enabled user rating initially.

  @override
  void initState() {
    ratePostHandle = RatePost((Status requestState) => {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var afterRating = (Map<String, dynamic> response) {
      print(response);
      if(!response['status']) {
        showSnackBar(response['message']??'Failed to rate post. Try again !!', context);
      }
      else {
        // Disable rating once user has successfully rated.
        setState(() {
          isReadOnly = true;
        });
      }
    };

    return SmoothStarRating(
      color: isReadOnly ? Colors.green : getThemeColor(),
      borderColor: isReadOnly ? Colors.green : getThemeColor(),
      rating: rating,
      isReadOnly: isReadOnly,
      size: 20,
      filledIconData: Icons.star,
      halfFilledIconData: Icons.star_half,
      defaultIconData: Icons.star_border,
      starCount: 5,
      allowHalfRating: false,
      spacing: 2.0,
      onRated: (value) {
        print("rating value -> ${value.round()}");
        ratePostHandle.rate(widget.postId, value.round())
            .then(afterRating);
      },
    );
  }
}