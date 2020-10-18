// InstaPost request base class.
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:assignment_2/utils/request_states.dart';

class InstaPostRequest {
  Function setRquestorState = () => {};
  InstaPostRequest(this.setRquestorState);

  setRequestInProgressState() {
    setRquestorState(Status.RequestInProcess);
  }

  Future<FutureOr> onValue(Response response) async {
    final Map<String, dynamic> responseData = json.decode(response.body);
    var result;
    if (response.statusCode == 200 && responseData["result"] == "success") {
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

  onError(error) {
    setRquestorState(Status.RequestFailed);
    return {
      'status': false,
      'message': 'Unsuccessful Request - $error',
    };
  }
}