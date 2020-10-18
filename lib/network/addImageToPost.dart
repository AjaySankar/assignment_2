// Upload image associated to a post.
import 'dart:async';
import 'dart:convert';
import 'package:assignment_2/utils/urls.dart';
import 'package:http/http.dart';
import 'package:assignment_2/user/user.dart';
import 'package:assignment_2/network/postRequestBase.dart';

class AddImageToPost extends InstaPostRequest {
  AddImageToPost(Function _setRquestorState): super(_setRquestorState);

  Future<Map<String, dynamic>> uploadImage(String image, int postId) async {
    User user = User();
    final Map<String, dynamic> postData = {
      "email": user.email,
      "password": user.password,
      "image": image,
      "post-id": postId
    };
    setRequestInProgressState();
    // await Future.delayed(Duration(seconds: 2));
    return await post(Urls.uploadImage,
        body: json.encode(postData),
        headers: {'Content-Type': 'application/json'})
        .then(onValue)
        .catchError(onError);
  }
}