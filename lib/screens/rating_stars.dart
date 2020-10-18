//https://pub.dev/packages/smooth_star_rating

import 'package:assignment_2/network/ratePost.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:assignment_2/utils/theme.dart';
import 'package:assignment_2/utils/request_states.dart';
import 'package:assignment_2/utils/snackBar.dart';
import 'package:assignment_2/post/post_provider.dart';
import 'package:provider/provider.dart';
import 'package:assignment_2/network/deviceOfflineCheck.dart';

class RatingStars extends StatefulWidget {
  RatingStars();

  @override
  _RatingStarsState createState() => _RatingStarsState();
}

class _RatingStarsState extends State<RatingStars> {

  RatePost ratePostHandle;

  @override
  void initState() {
    super.initState();
    ratePostHandle = RatePost((Status requestState) => {});
  }

  @override
  Widget build(BuildContext context) {

    var afterRating = (Map<String, dynamic> response, PostModel postModel, int rating) {
      // print(response);
      if(!response['status']) {
        showSnackBar(response['message']??'Failed to rate post. Try again !!', context);
      }
      else {
        postModel.setUserRating(rating);
      }
    };

    void ratePost(PostModel postModel, int rating, BuildContext context) async{
      bool isOffline = await isDeviceOffline();
      if(isOffline) {
        showSnackBar('You are offline!! Connect to internet to rate a post', context);
        return;
      }
      ratePostHandle.rate(postModel.postId, rating)
          .then((Map response) => afterRating(response, postModel, rating));
    }

    return Consumer<PostModel>(
      builder: (context, post, child) {
        return SmoothStarRating(
          color: post.userRating > 0 ? Color(0xfffffce00) : getThemeColor(),
          borderColor: post.userRating > 0 ? Color(0xfffffce00) : getThemeColor(),
          rating: post.userRating.toDouble(),
          isReadOnly: post.userRating > 0,
          size: 30,
          filledIconData: Icons.star,
          halfFilledIconData: Icons.star_half,
          defaultIconData: Icons.star_border,
          starCount: 5,
          allowHalfRating: false,
          spacing: 2.0,
          onRated: (value) => ratePost(post, value.round(), context),
        );
    });
  }
}