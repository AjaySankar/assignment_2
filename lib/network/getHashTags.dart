import 'dart:async';
import 'package:assignment_2/utils/urls.dart';
import 'package:http/http.dart';
import 'package:assignment_2/network/postRequestBase.dart';
import 'package:assignment_2/utils/request_states.dart';
import 'dart:convert';

class HashTagGetter extends InstaPostRequest {
  HashTagGetter(Function setRquestorState): super(setRquestorState);

  Future<Map<String, dynamic>> _getHashTagBatch(int startIndex, int endIndex) async {
    // await Future.delayed(Duration(seconds: 2));
    return await get('${Urls.getHashTagsBatch}?start-index=$startIndex&end-index=$endIndex')
        .then(onValue)
        .catchError(onError);
  }

  Future<List<String>> fetchHashTags(startIndex, int endIndex) async {
    setRequestInProgressState();
    Map response = await _getHashTagBatch(startIndex, endIndex);
    List<String> hashTags = [];
    if(response['status']) {
      setRquestorState(Status.RequestSuccessful);
      response['body']['hashtags']
          .where((hashTag) => hashTag.toString().length > 0)
          .forEach((name) => hashTags.add(name.toString()));
    }
    else {
      setRquestorState(Status.RequestFailed);
    }
    return hashTags;
  }

  Future<int> onHashCountValue(Response response) async {
    final Map<String, dynamic> responseData = json.decode(response.body);
    int hashTagCount = -1;
    if (response.statusCode == 200) {
      hashTagCount = responseData['hashtag-count'] ?? hashTagCount;
    }
    return hashTagCount;
  }

  Future<int> fetchHashTagCount() async {
    return await get(Urls.getHashTagCount).then(onHashCountValue);
  }
}