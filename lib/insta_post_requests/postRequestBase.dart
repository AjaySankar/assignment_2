import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:assignment_2/utils/request_states.dart';

class InstaPostRequest {
  Function _setRquestorState = () => {};
  InstaPostRequest(this._setRquestorState);

  setRequestInProgressState() {
    _setRquestorState(Status.RequestInProcess);
  }

  Future<FutureOr> onValue(Response response) async {
    final Map<String, dynamic> responseData = json.decode(response.body);
    var result;
    if (response.statusCode == 200 && responseData["result"] == "success") {
      _setRquestorState(Status.RequestSuccessful);
      result = {
        'status': true,
        'message': 'Successfully registered'
      };
    }
    else {
      _setRquestorState(Status.RequestFailed);
      result = {
        'status': false,
        'message': responseData['errors']
      };
    }
    return result;
  }

  onError(error) {
    _setRquestorState(Status.RequestFailed);
    return {
      'status': false,
      'message': 'Unsuccessful Request - ${error}',
    };
  }
}