// Upload image associated to a post.
import 'dart:async';
import 'dart:convert';
import 'package:assignment_2/utils/urls.dart';
import 'package:http/http.dart';
import 'package:assignment_2/user/user.dart';
import 'package:assignment_2/network/postRequestBase.dart';
import 'package:assignment_2/utils/request_states.dart';
import 'package:assignment_2/network/deviceOfflineCheck.dart';
import 'package:assignment_2/utils/sharedPref.dart';

// Shared preference key for an offline post's image.
// If the offline post has id - "NewInstaPost-1234" (generated by device when saving it), the image associated with it has id - "NewInstaPostImage-1234"
const String NEW_POST_IMAGE_SHARED_PREF_KEY_PREFIX = "NewInstaPostImage-";

class AddImageToPost extends InstaPostRequest {
  AddImageToPost(Function _setRquestorState): super(_setRquestorState);

  Future<Map<String, dynamic>> uploadImage(String image, int postId) async {

    setRequestInProgressState();

    bool isOffline = await isDeviceOffline();
    if(isOffline) {
      // If device is offline, save new post image to shared preferences.
      return await saveNewPostImageToSharedPref(image, postId);
    }

    User user = User();
    final Map<String, dynamic> postData = {
      "email": user.email,
      "password": user.password,
      "image": image,
      "post-id": postId
    };
    // await Future.delayed(Duration(seconds: 2));
    return await post(Urls.uploadImage,
        body: json.encode(postData),
        headers: {'Content-Type': 'application/json'})
        .then(onValue)
        .catchError(onError);
  }

  // postId is the offline post's id associated with this image.
  String getSharedPrefKeyForNewInstaPostImage(int postId) {
    return '$NEW_POST_IMAGE_SHARED_PREF_KEY_PREFIX$postId';
  }

  // Get postid generated by device when it is offline and save the image locally.
  Future<Map<String, dynamic>> saveNewPostImageToSharedPref(String image, int postId) async {
    String newPostImageSpKey = getSharedPrefKeyForNewInstaPostImage(postId);
    try {
      await saveToSharedPref(newPostImageSpKey, image);
    }
    catch(e) {
      setRquestorState(Status.RequestFailed);
      return {
        'status': false,
        'errors': 'Failed to save image to shared pref'
      };
    }
    setRquestorState(Status.RequestSuccessful);
    return {
      'status': true,
      'errors': ''
    };
  }

  // Upload image associated with a post when device goes online.
  // Returns if the upload is successful.
  Future<bool> uploadOfflinePostImage(int fetchedPostId, int localPostId) async {
    String newPostImageSpKey = getSharedPrefKeyForNewInstaPostImage(localPostId);

    // If user has not uploaded an image when creating post offline.
    bool hasUserCreatedAnImage = await hasSpKey(newPostImageSpKey);
    if(!hasUserCreatedAnImage) {
      return true;
    }

    try {
      String postImage = await readFromSharedPref(newPostImageSpKey);
      Map<String, dynamic> response = await uploadImage(postImage, fetchedPostId);
      return response['status'];
    }
    catch(e) {
      return false;
    }
  }
}