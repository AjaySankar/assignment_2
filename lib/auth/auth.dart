import 'dart:async';
import 'dart:convert';
import 'package:assignment_2/utils/urls.dart';
import 'package:http/http.dart';
import 'package:assignment_2/utils/request_states.dart';
import 'package:assignment_2/user/user.dart';

class Auth {
  Function _setRquestorState = () => {};
  Auth(this._setRquestorState);

  Future<Map<String, dynamic>> registerUser(String firstname, String lastname, String nickname, String email, String password) async {
    final Map<String, String> registrationData = {
      "firstname": firstname,
      "lastname": lastname,
      "nickname": nickname,
      "email": email,
      "password": password
    };
    _setRquestorState(Status.RequestInProcess);
    // await Future.delayed(Duration(seconds: 2));
    return await post(Urls.register,
        body: json.encode(registrationData),
        headers: {'Content-Type': 'application/json'})
        .then((Response response) => onValue(response, registrationData))
        .catchError(onError);
  }

  Future<FutureOr> onValue(Response response, Map<String, String> authInput) async {
    final Map<String, dynamic> responseData = json.decode(response.body);
    var result;
    if (response.statusCode == 200 && responseData["result"] == "success") {
      User().setUserProfile(authInput);
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