import 'dart:async';
import 'package:assignment_2/utils/urls.dart';
import 'package:http/http.dart';
import 'package:assignment_2/insta_post_requests/postRequestBase.dart';
import 'dart:convert';

class GetPost extends InstaPostRequest {
  GetPost(Function _setRquestorState): super(_setRquestorState);

  Future<Map<String, dynamic>> getInstaPost(int postId) async {
    await Future.delayed(Duration(seconds: 2));
    return await get('${Urls.getPost}?post-id=${postId}')
        .then(onValue)
        .catchError(onError);
  }
}