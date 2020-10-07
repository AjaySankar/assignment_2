import 'dart:async';
import 'dart:convert';
import 'package:assignment_2/utils/urls.dart';
import 'package:http/http.dart';
import 'package:assignment_2/user/user.dart';
import 'package:assignment_2/insta_post_requests/postRequestBase.dart';

class AddImageToPost extends InstaPostRequest {
  AddImageToPost(Function _setRquestorState): super(_setRquestorState);

  Future<Map<String, dynamic>> uploadImage(String image, int postId) async {
    User user = User();
    user.setUserProfile({
      "firstName": "Test",
      "lastName": "User",
      "nickname": "ajaytest",
      "email": "ajaytest@gmail.com",
      "password": "testuser"
    });
    final Map<String, dynamic> postData = {
      "email": user.email,
      "password": user.password,
      "image": image,
      "post-id": postId
    };
    setRequestInProgressState();
    // await Future.delayed(Duration(seconds: 2));
    return await post(Urls.addPost,
        body: json.encode(postData),
        headers: {'Content-Type': 'application/json'})
        .then(onValue)
        .catchError(onError);
  }
}