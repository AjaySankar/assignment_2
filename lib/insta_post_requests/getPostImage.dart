import 'dart:async';
import 'package:assignment_2/utils/urls.dart';
import 'package:http/http.dart';
import 'package:assignment_2/insta_post_requests/postRequestBase.dart';
import 'dart:convert';

class GetPostImage extends InstaPostRequest {
  GetPostImage(Function _setRquestorState): super(_setRquestorState);

  Future<Map<String, dynamic>> getInstaPost(int imageId) async {
    // await Future.delayed(Duration(seconds: 2));
    return await get('${Urls.getImage}?id=${imageId}')
        .then(onValue)
        .catchError(onError);
  }
}