import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:assignment_2/utils/urls.dart';
import 'package:http/http.dart';
import 'package:assignment_2/utils/registration_states.dart';

class Auth {
  Function _setRquestorState = () => {};
  Auth(this._setRquestorState);

  Future<Map<String, dynamic>> registerUser(String firstname, String lastname, String nickname, String email, String password) async {
    final Map<String, dynamic> registrationData = {
      "firstname": firstname,
      "lastname": lastname,
      "nickname": nickname,
      "email": email,
      "password": password
    };
    _setRquestorState(Status.Registering);
    await Future.delayed(Duration(seconds: 2));
    return await post(Urls.register,
        body: json.encode(registrationData),
        headers: {'Content-Type': 'application/json'})
        .then(onValue)
        .catchError(onError);
  }

  Future<FutureOr> onValue(Response response) async {
    final Map<String, dynamic> responseData = json.decode(response.body);
    var result;
    if (response.statusCode == 200 && responseData["result"] == "success") {
      // Save user model
      _setRquestorState(Status.Registered);
      result = {
        'status': true,
        'message': 'Successfully registered'
      };
    }
    else {
      _setRquestorState(Status.RegistrationFailed);
      result = {
        'status': false,
        'message': responseData['errors']
      };
    }
    return result;
  }

  onError(error) {
    _setRquestorState(Status.RegistrationFailed);
    return {
      'status': false,
      'message': 'Unsuccessful Request - ${error}',
    };
  }
}