import 'dart:async';
import 'package:assignment_2/utils/urls.dart';
import 'package:http/http.dart';
import 'package:assignment_2/network/postRequestBase.dart';
import 'package:assignment_2/utils/request_states.dart';
import 'dart:convert';
import 'package:assignment_2/shared_pref_utils/sharedPref.dart';
import 'package:assignment_2/network/deviceOfflineCheck.dart';

const String HASHTAGS_LIST_SHARED_PREF_KEY_PREFIX = "HashTags";

class HashTagGetter extends InstaPostRequest {
  HashTagGetter(Function setRquestorState): super(setRquestorState);

  Future<Map<String, dynamic>> _getHashTagBatch(int startIndex, int endIndex) async {
    // await Future.delayed(Duration(seconds: 2));
    return await get('${Urls.getHashTagsBatch}?start-index=$startIndex&end-index=$endIndex')
        .then(onValue)
        .catchError(onError);
  }

  Future<List<String>> fetchHashTags(int startIndex, int endIndex) async {
    setRequestInProgressState();

    bool isOffline = await isDeviceOffline();
    if(isOffline) {
      return await readHashTagsFromSharedPref(startIndex, endIndex);
    }

    Map response = await _getHashTagBatch(startIndex, endIndex);
    List<String> hashTags = [];
    if(response['status']) {
      setRquestorState(Status.RequestSuccessful);
      response['body']['hashtags']
          .where((hashTag) => hashTag.toString().length > 0)
          .forEach((name) => hashTags.add(name.toString()));
      // await saveToSharedPref(HASHTAGS_LIST_SHARED_PREF_KEY_PREFIX, '');
      int currentSavedHashTagCount = await getNumberOfHashTagsSaved();
      if(startIndex >= currentSavedHashTagCount) {
        // print("Save newly fetched hashtags");
        saveHashTagsToSharedPref(hashTags);
      }
    }
    else {
      setRquestorState(Status.RequestFailed);
    }
    return hashTags;
  }

  List<String> dynamicToStringList(List<dynamic> dList) {
    List<String> sList = [];
    dList.forEach((hashTag) => sList.add(hashTag.toString()));
    return sList;
  }

  Future<void> saveHashTagsToSharedPref(List<String> fetchedHashTags) async {
    final String currentHashTagsString = await readFromSharedPref(HASHTAGS_LIST_SHARED_PREF_KEY_PREFIX);
    List<String> currentHashTagsList = [];
    if(currentHashTagsString.length > 0) {
      currentHashTagsList = dynamicToStringList(json.decode(currentHashTagsString));
    }
    currentHashTagsList.addAll(fetchedHashTags);
    await saveToSharedPref(HASHTAGS_LIST_SHARED_PREF_KEY_PREFIX, json.encode(currentHashTagsList));
  }

  Future<int> onHashCountValue(Response response) async {
    final Map<String, dynamic> responseData = json.decode(response.body);
    int hashTagCount = -1;
    if (response.statusCode == 200) {
      hashTagCount = responseData['hashtag-count'] ?? hashTagCount;
    }
    return hashTagCount;
  }

  Future<List<String>> readHashTagsFromSharedPref(int startIndex, int endIndex) async {
    // print("Got hashtag from offline");
    final String hashTagsString = await readFromSharedPref(HASHTAGS_LIST_SHARED_PREF_KEY_PREFIX);
    List<String> hashTags = dynamicToStringList(json.decode(hashTagsString));
    setRquestorState(Status.RequestSuccessful);
    return hashTags.sublist(startIndex, endIndex);
  }

  Future<int> fetchHashTagCount() async {
    bool isOffline = await isDeviceOffline();
    if(isOffline) {
      // print("Got hashtag count from offline");
      return await getNumberOfHashTagsSaved();
    }
    return await get(Urls.getHashTagCount).then(onHashCountValue);
  }

  Future<int> getNumberOfHashTagsSaved() async {
    final String currentHashTagsString = await readFromSharedPref(HASHTAGS_LIST_SHARED_PREF_KEY_PREFIX);
    if(currentHashTagsString.length > 0) {
      return json.decode(currentHashTagsString).length;
    }
    return 0;
  }
}