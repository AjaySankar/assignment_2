// Upload new post submitted by user
import 'dart:async';
import 'dart:convert';
import 'package:assignment_2/utils/urls.dart';
import 'package:http/http.dart';
import 'package:assignment_2/user/user.dart';
import 'package:assignment_2/network/postRequestBase.dart';
import 'package:assignment_2/utils/sharedPref.dart';
import 'package:assignment_2/utils/request_states.dart';
import 'package:assignment_2/network/deviceOfflineCheck.dart';
import 'package:assignment_2/network/addImageToPost.dart';
import 'dart:math';

final Random random = new Random();
const String NEW_POST_SHARED_PREF_KEY_PREFIX = "NewInstaPost-";
const String NEW_POST_IDS_SHARED_PREF_KEY = "NewInstaPostIdList";
const int MAX_NEW_OFFLINE_POSTS = 1000;

class AddInstaPost extends InstaPostRequest {
  AddInstaPost(Function _setRquestorState): super(_setRquestorState);

  Future<Map<String, dynamic>> createInstaPost(String postDescription, List<String> hashTags) async {

    setRequestInProgressState();
    bool isOffline = await isDeviceOffline();
    if(isOffline) {
      // If device is offline, save new posts to shared preferences.
      return await saveNewPostsSharedPref(postDescription, hashTags);
    }

    User user = User();
    final Map<String, dynamic> postData = {
      "email": user.email,
      "password": user.password,
      "text": postDescription,
      "hashtags": hashTags
    };
    // await Future.delayed(Duration(seconds: 2));
    return await post(Urls.addPost,
        body: json.encode(postData),
        headers: {'Content-Type': 'application/json'})
        .then(onValue)
        .catchError(onError);
  }

  int generateNewInstaPostId() {
    return random.nextInt(MAX_NEW_OFFLINE_POSTS)+1;
  }

  String getSharedPrefKeyForNewInstaPost(int postId) {
    return '$NEW_POST_SHARED_PREF_KEY_PREFIX$postId';
  }

  List<int> dynamicListToIntList(List<dynamic> dList) {
    return dList.map((s) => s as int).toList();
  }

  List<String> dynamicListToStringList(List<dynamic> dList) {
    List<String> sList = [];
    dList.forEach((hashTag) => sList.add(hashTag.toString()));
    return sList;
  }

  Future<Map<String, dynamic>> saveNewPostsSharedPref(String postDescription, List<String> hashTags) async {

    int newPostId = generateNewInstaPostId();
    Map<String, dynamic> newPostData = {
      "text": postDescription,
      "hashtags": hashTags,
      "localPostId": newPostId,
      "imageString": ''
    };

    Map<String, dynamic> response = {
      'status': true,
      'body': {
        'id': newPostId
      }
    };

    try {
      // Add new post id to list of post ids that has to pushed when device goes online
      String savedPostIdsString = await readFromSharedPref(NEW_POST_IDS_SHARED_PREF_KEY);
      List<int> savedPostIdList = [];
      if(savedPostIdsString.length > 0) {
        savedPostIdList = dynamicListToIntList(jsonDecode(savedPostIdsString));
      }
      savedPostIdList.add(newPostId);
      await saveToSharedPref(NEW_POST_IDS_SHARED_PREF_KEY, json.encode(savedPostIdList));

      // Save new post to shared preferences.
      String newPostString = json.encode(newPostData);
      await saveToSharedPref(
          getSharedPrefKeyForNewInstaPost(newPostId), newPostString);
    }
    catch(e) {
      setRquestorState(Status.RequestFailed);
      response = {
        'status': false,
        'body': {
          'id': -1
        }
      };
      return response;
    }

    setRquestorState(Status.RequestSuccessful);
    return response;
  }


  Future<bool> uploadOfflinePost(int postId) async {
    String newPostSharedPrefKey = getSharedPrefKeyForNewInstaPost(postId);
    String postData = await readFromSharedPref(newPostSharedPrefKey);
    Map<String, dynamic> newPostData = json.decode(postData);
    List<String> hashTags = dynamicListToStringList(newPostData['hashtags']);
    String postDescription = newPostData['text'].toString();
    Map<String, dynamic> response = await createInstaPost(postDescription, hashTags);
    if(response['status']) {
      // Save post image now..
      int uploadedPostId = response['body']['id'];
      AddImageToPost addImageToPostHandle = AddImageToPost(super.setRquestorState);
      bool imageUploadStatus = await addImageToPostHandle.uploadOfflinePostImage(uploadedPostId, postId);
      print("Upload status for $uploadedPostId, $postId - $imageUploadStatus");
      return true;
    }
    return false;
  }

  deleteUploadedOfflinePosts(List<String> successfulPostUploads) async {
    List<String> successPosts = successfulPostUploads
        .map(int.parse)
        .map(getSharedPrefKeyForNewInstaPost).toList();
    await deleteListOfSharedPrefs(successPosts);
    AddImageToPost addImageToPostHandle = AddImageToPost(super.setRquestorState);
    List<String> successPostImages = successfulPostUploads
        .map(int.parse)
        .map(addImageToPostHandle.getSharedPrefKeyForNewInstaPostImage)
        .toList();
    await deleteListOfSharedPrefs(successPostImages);
  }

  updateNewPostIdsList(List<String> failedPostUploads) async {
    String failedPostsList = json.encode(failedPostUploads);
    await saveToSharedPref(NEW_POST_IDS_SHARED_PREF_KEY, failedPostsList);
  }

  processOfflinePosts() async {
    // await clearAllSharedPref();
    String savedPostIdsString = await readFromSharedPref(NEW_POST_IDS_SHARED_PREF_KEY);
    if(savedPostIdsString.length == 0) {
      // If the shared preference does not exist then initialize empty array and do nothing.
      await saveToSharedPref(NEW_POST_IDS_SHARED_PREF_KEY, json.encode([]));
      return;
    }
    List<String> savedPostIds = dynamicListToStringList(json.decode(savedPostIdsString));
    List<String> successfulPostUploads = [];
    List<String> failedPostUploads = [];
    for(String postId in savedPostIds) {
      bool isUploadSuccessful = await uploadOfflinePost(int.parse(postId));
      // await uploadOfflinePost(int.parse(postId));
      if(isUploadSuccessful) {
        successfulPostUploads.add(postId);
      }
      else {
        failedPostUploads.add(postId);
      }
    }
    deleteUploadedOfflinePosts(successfulPostUploads);
    updateNewPostIdsList(failedPostUploads);
  }
}