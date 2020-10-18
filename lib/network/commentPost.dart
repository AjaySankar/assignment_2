// Upload comment to a post.
import 'dart:async';
import 'dart:convert';
import 'package:assignment_2/utils/urls.dart';
import 'package:http/http.dart';
import 'package:assignment_2/user/user.dart';
import 'package:assignment_2/network/postRequestBase.dart';

class CommentPost  extends InstaPostRequest {
  CommentPost(Function _setRquestorState): super(_setRquestorState);

  Future<Map<String, dynamic>> comment(int postId, String comment) async {
    User user = User();
    final Map<String, dynamic> postData = {
      "email": user.email,
      "password": user.password,
      "comment": comment,
      "post-id": postId
    };
    setRequestInProgressState();
    // await Future.delayed(Duration(seconds: 2));
    return await post(Urls.commentPost,
        body: json.encode(postData),
        headers: {'Content-Type': 'application/json'})
        .then(onValue)
        .catchError(onError);
  }
}