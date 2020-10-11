import 'dart:async';
import 'package:assignment_2/utils/urls.dart';
import 'package:http/http.dart';
import 'package:assignment_2/network/postRequestBase.dart';
import 'package:assignment_2/utils/request_states.dart';
import 'dart:convert';

class HashTagGetter extends InstaPostRequest {
  HashTagGetter(Function setRquestorState): super(setRquestorState);

  Future<Map<String, dynamic>> _getHashTagCount() async {
    return await get(Urls.getHashTagCount)
        .then(onHashCountValue)
        .catchError(onError);
  }

  Future<Map<String, dynamic>> _getHashTagBatch(startIndex, int endIndex) async {
    // await Future.delayed(Duration(seconds: 2));
    return await get('${Urls.getHashTagsBatch}?start-index=${startIndex}&end-index=${endIndex}')
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
          .forEach((name) => hashTags.add(name.toString()));
    }
    else {
      setRquestorState(Status.RequestFailed);
    }
    return hashTags;
  }

  Future<FutureOr> onHashCountValue(Response response) async {
    final Map<String, dynamic> responseData = json.decode(response.body);
    var result;
    if (response.statusCode == 200) {
      setRquestorState(Status.RequestSuccessful);
      result = {
        'status': true,
        'message': 'Successfully registered',
        'body': responseData
      };
    }
    else {
      setRquestorState(Status.RequestFailed);
      result = {
        'status': false,
        'message': responseData['errors']
      };
    }
    return result;
  }

  Future<int> fetchHashTagCount() async {
    Map response = await _getHashTagCount();
    int hashTagCount = 0;
    if(response['status']) {
      setRquestorState(Status.RequestSuccessful);
      hashTagCount = response['body']['hashtag-count'] ?? 0;
    }
    else {
      setRquestorState(Status.RequestFailed);
    }
    return hashTagCount;
  }
}