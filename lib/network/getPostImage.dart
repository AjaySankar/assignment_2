import 'dart:async';
import 'package:assignment_2/utils/urls.dart';
import 'package:http/http.dart';
import 'package:assignment_2/network/postRequestBase.dart';
import 'package:assignment_2/network/deviceOfflineCheck.dart';
import 'package:assignment_2/shared_pref_utils/sharedPref.dart';

const String POST_IMAGE_SHARED_PREF_KEY_PREFIX = "InstaPostImage-";

class GetPostImage extends InstaPostRequest {
  GetPostImage(Function _setRquestorState): super(_setRquestorState);

  Future<Map<String, dynamic>> getInstaPostImage(int imageId) async {

    bool isOffline = await isDeviceOffline();
    if(isOffline) {
      print("Got image from offline");
      return await readPostImageFromSharedPref(imageId);
    }

    print("Get image from web");
    // await Future.delayed(Duration(seconds: 2));
    return await get('${Urls.getImage}?id=$imageId')
        .then((Response response) => onResponse(response, imageId))
        .catchError(onError);
  }

  String getPostImageSharedPrefKey(int imageId) {
    return "$POST_IMAGE_SHARED_PREF_KEY_PREFIX$imageId";
  }

  Future<FutureOr> onResponse(Response response, int imageId) async {
    Map result = await onValue(response);
    if(result['status']) {
      await savePostImageToSharedPref(result['body']['image'], imageId);
    }
    return result;
  }

  Future<void> savePostImageToSharedPref(String encodedImage, int imageId) async {
    await saveToSharedPref(getPostImageSharedPrefKey(imageId), encodedImage);
  }

  Future<Map<String, dynamic>> readPostImageFromSharedPref(int imageId) async {
    Map<String, dynamic> result = {
      'status': false,
      'message': 'Failed to fetch post from preferences',
      'body': {}
    };

    final String encodedImage = await readFromSharedPref(getPostImageSharedPrefKey(imageId));
    if(encodedImage.length > 0) {
      result['status'] = true;
      result['message'] = 'Successfully got post from shared preferences';
      result['body'] = {
        'image': encodedImage
      };
    }
    return result;
  }
}