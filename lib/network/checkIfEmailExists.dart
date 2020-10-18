// Check if a email is available.
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:assignment_2/utils/urls.dart';

Future<bool> doesEmailExist(String email) async {
  return await get('${Urls.checkIfEmailExists}?email=$email')
      .then(onValue)
      .catchError(onError);
}

bool onValue(Response response) {
  final Map<String, dynamic> responseData = json.decode(response.body);
  bool doesEmailExist = false;
  if (response.statusCode == 200 && responseData["result"] == true) {
    doesEmailExist = true;
  }
  return doesEmailExist;
}

bool onError(error) {
  print("Failed to check if email exists");
  // Since this an expensive call on every focus out event,
  // Lazy ignore and say that the nickname does not exist. Handle it later when user clicks on 'Register'
  return false;
}