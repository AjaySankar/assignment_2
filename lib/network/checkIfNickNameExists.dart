import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:assignment_2/utils/urls.dart';

Future<bool> doesNickNameExist(String nickName) async {
  return await get('${Urls.checkIfNickNamesExists}?nickname=$nickName')
      .then(onValue)
      .catchError(onError);
}

bool onValue(Response response) {
  final Map<String, dynamic> responseData = json.decode(response.body);
  bool doesNickNameExist = false;
  if (response.statusCode == 200 && responseData["result"] == true) {
    doesNickNameExist = true;
  }
  return doesNickNameExist;
}

bool onError(error) {
  print("Failed to check if nickName exists");
  // Since this an expensive call on every focus out event,
  // Lazy ignore and say that the nickname does not exist. Handle it later when user clicks on 'Register'
  return false;
}