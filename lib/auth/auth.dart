import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:assignment_2/utils/urls.dart';
import 'package:http/http.dart';

Future<Map<String, dynamic>> registerUser(String firstname, String lastname, String nickname, String email, String password) async {
  final Map<String, dynamic> registrationData = {
    "firstname": firstname,
    "lastname": lastname,
    "nickname": nickname,
    "email": email,
    "password": password
  };
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
    result = {
      'status': true,
      'message': 'Successfully registered'
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

onError(error) {
  return {
    'status': false,
    'message': 'Unsuccessful Request - ${error}',
  };
}