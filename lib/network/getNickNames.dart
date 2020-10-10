import 'dart:async';
import 'package:assignment_2/utils/urls.dart';
import 'package:http/http.dart';
import 'package:assignment_2/network/postRequestBase.dart';
import 'dart:convert';
import 'package:assignment_2/utils/request_states.dart';

class GetNickNames extends InstaPostRequest {
  GetNickNames(Function _setRquestorState): super(_setRquestorState);

  Future<Map<String, dynamic>> _getNickNames() async {
    // await Future.delayed(Duration(seconds: 2));
    return await get('${Urls.getNickNames}')
        .then(onValue)
        .catchError(onError);
  }

  @override
  Future<FutureOr> onValue(Response response) async {
    final Map<String, dynamic> responseData = json.decode(response.body);
    var result;
    if (response.statusCode == 200) {
      result = {
        'status': true,
        'message': 'Successfully registered',
        'body': responseData
      };
    }
    else {
      result = {
        'status': false,
        'message': responseData['errors']
      };
    }
    return result;
  }

  Future<List<String>> fetchNickNames() async {
    Map response = await _getNickNames();
    List<String> nickNames = [];
    if(response['status']) {
      setRquestorState(Status.RequestSuccessful);
      response['body']['nicknames']
          .forEach((name) => nickNames.add(name.toString()));
    }
    else {
      setRquestorState(Status.RequestFailed);
    }
    return nickNames;
  }
}