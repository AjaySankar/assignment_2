// Fetch post ids associated with a hashtag.
import 'dart:async';
import 'package:assignment_2/utils/urls.dart';
import 'package:http/http.dart';
import 'package:assignment_2/network/postRequestBase.dart';

class GetHashTagPosts extends InstaPostRequest {
  GetHashTagPosts(Function _setRquestorState): super(_setRquestorState);

  Future<Map<String, dynamic>> getHashTagPostIds(String hashTag) async {
    // await Future.delayed(Duration(seconds: 2));
    final encodeHashTag = Uri.encodeComponent(hashTag);
    return await get('${Urls.getHashTagPostIds}?hashtag=$encodeHashTag')
        .then(onValue)
        .catchError(onError);
  }
}