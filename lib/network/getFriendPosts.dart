import 'dart:async';
import 'package:assignment_2/utils/urls.dart';
import 'package:http/http.dart';
import 'package:assignment_2/network/postRequestBase.dart';

class GetFriendPosts extends InstaPostRequest {
  GetFriendPosts(Function _setRquestorState): super(_setRquestorState);

  Future<Map<String, dynamic>> getFriendPostIds(String nickName) async {
    // await Future.delayed(Duration(seconds: 2));
    return await get('${Urls.getFriendPostIds}?nickname=$nickName')
        .then(onValue)
        .catchError(onError);
  }
}