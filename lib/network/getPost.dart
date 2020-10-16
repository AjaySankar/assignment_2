import 'dart:async';
import 'package:assignment_2/utils/urls.dart';
import 'package:http/http.dart';
import 'package:assignment_2/network/postRequestBase.dart';
import 'package:assignment_2/network/deviceOfflineCheck.dart';
import 'package:assignment_2/shared_pref_utils/sharedPref.dart';
import 'dart:convert';

const String POST_SHARED_PREF_KEY_PREFIX = "InstaPost-";

class GetPost extends InstaPostRequest {
  GetPost(Function _setRquestorState): super(_setRquestorState);

  Future<Map<String, dynamic>> getInstaPost(int postId) async {

    bool isOffline = await isDeviceOffline();
    if(isOffline) {
      print("Got post from offline");
      return await readPostFromSharedPref(postId);
    }

    // await Future.delayed(Duration(seconds: 2));
    return await get('${Urls.getPost}?post-id=$postId')
        .then((Response response) => onResponse(response, postId))
        .catchError(onError);
  }

  String getPostSharedPrefKey(int postId) {
    return "$POST_SHARED_PREF_KEY_PREFIX$postId";
  }

  Future<FutureOr> onResponse(Response response, int postId) async {
    Map result = await onValue(response);
    if(result['status']) {
      await savePostToSharedPref(result['body']['post'], postId);
    }
    return result;
  }

  Future<void> savePostToSharedPref(Map postData, int postId) async {
    String postDataString = json.encode(postData);
    await saveToSharedPref(postDataString, getPostSharedPrefKey(postId));
  }

  Future<Map<String, dynamic>> readPostFromSharedPref(int postId) async {
    Map<String, dynamic> result = {
      'status': false,
      'message': 'Failed to fetch post from preferences',
      'body': {}
    };

    final String postString = await readFromSharedPref(getPostSharedPrefKey(postId));
    if(postString.length > 0) {
      result['status'] = true;
      result['message'] = 'Successfully got post from shared preferences';
      result['body'] = {
        'post': json.decode(postString)
      };
    }
    return result;
  }
}