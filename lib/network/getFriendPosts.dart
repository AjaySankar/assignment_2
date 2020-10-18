import 'dart:async';
import 'package:assignment_2/utils/urls.dart';
import 'package:http/http.dart';
import 'package:assignment_2/network/postRequestBase.dart';
import 'dart:convert';
import 'package:assignment_2/shared_pref_utils/sharedPref.dart';
import 'package:assignment_2/network/deviceOfflineCheck.dart';

const String NICKNAME_SHARED_PREF_KEY_PREFIX = "Nickname-";

class GetFriendPosts extends InstaPostRequest {
  GetFriendPosts(Function _setRquestorState): super(_setRquestorState);

  Future<Map<String, dynamic>> getFriendPostIds(String nickName) async {

    bool isOffline = await isDeviceOffline();
    if(isOffline) {
      // print("Got post ids from offline");
      // If device is offline, fetch post ids associated with a nickname.
      return await readPostIdsFromSharedPref(nickName);
    }

    // await Future.delayed(Duration(seconds: 2));
    return await get('${Urls.getFriendPostIds}?nickname=$nickName')
        .then((Response response) => onResponse(response, nickName))
        .catchError(onError);
  }

  String getNickNameSharedPrefKey(String nickName) {
    return "$NICKNAME_SHARED_PREF_KEY_PREFIX$nickName";
  }

  Future<FutureOr> onResponse(Response response, String nickName) async {
    Map result = await onValue(response);
    if(result['status']) {
      // Save post ids associated with a nickname in shared preferences.
      await savePostIdsToSharedPref(result['body']['ids'], nickName);
    }
    return result;
  }

  Future<void> savePostIdsToSharedPref(List<dynamic> postIds, String nickName) async {
    String postDataString = json.encode(postIds);
    await saveToSharedPref(getNickNameSharedPrefKey(nickName), postDataString);
  }

  // Read post ids of a friend from shared preferences when device is offline
  Future<Map<String, dynamic>> readPostIdsFromSharedPref(String nickName) async {
    Map<String, dynamic> result = {
      'status': false,
      'message': 'Failed to fetch post from preferences',
      'body': {}
    };

    final String postIdsString = await readFromSharedPref(getNickNameSharedPrefKey(nickName));
    if(postIdsString.length > 0) {
      result['status'] = true;
      result['message'] = 'Successfully got post ids from shared preferences';
      result['body'] = {
        'ids': json.decode(postIdsString)
      };
    }
    return result;
  }
}