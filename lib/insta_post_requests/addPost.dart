import 'dart:async';
import 'dart:convert';
import 'package:assignment_2/utils/urls.dart';
import 'package:http/http.dart';
import 'package:assignment_2/user/user.dart';
import 'package:assignment_2/insta_post_requests/postRequestBase.dart';

class AddInstaPost extends InstaPostRequest {
  AddInstaPost(Function _setRquestorState): super(_setRquestorState);

  Future<Map<String, dynamic>> createInstaPost(String postDescription, List<String> hashTags) async {
    User user = User();
    final Map<String, dynamic> postData = {
      "email": user.email,
      "password": user.password,
      "text": postDescription,
      "hashtags": hashTags
    };
    setRequestInProgressState();
    await Future.delayed(Duration(seconds: 2));
    return await post(Urls.register,
        body: json.encode(postData),
        headers: {'Content-Type': 'application/json'})
        .then(onValue)
        .catchError(onError);
  }
}