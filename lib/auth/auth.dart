import 'dart:async';
import 'dart:convert';
import 'package:assignment_2/auth/authInfoUtils.dart';
import 'package:assignment_2/utils/urls.dart';
import 'package:http/http.dart';
import 'package:assignment_2/utils/request_states.dart';
import 'package:assignment_2/user/user.dart';
import 'package:assignment_2/network/deviceOfflineCheck.dart';

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

  Future<Map<String, dynamic>> login(String email, String password, String nickname) async {
    final Map<String, String> loginData = {
      "nickname": nickname,
      "email": email,
      "password": password
    };
    _setRquestorState(Status.RequestInProcess);
    bool isOffline = await isDeviceOffline();
    if(isOffline) {
      return await doOfflineLogin(loginData);
    }

    // await Future.delayed(Duration(seconds: 2));
    return await get('${Urls.login}?email=$email&password=$password')
        .then((Response response) => onValue(response, loginData))
        .catchError(onError);
  }

  Future<FutureOr> onValue(Response response, Map<String, String> authInput) async {
    final Map<String, dynamic> responseData = json.decode(response.body);
    var result;
    if (response.statusCode == 200 && (responseData["result"] == "success" || responseData["result"] == true)) {
      // On successful login, store user info in memory and shared preferences.
      User().setUserProfile(authInput);
      saveUserLoginInSharedPref(authInput);
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
      'message': 'Unsuccessful Request - $error',
    };
  }

  // offline login to authenticate against stored credentials in shared preferences.
  Future<Map<String, dynamic>> doOfflineLogin(Map<String, String> loginData) async {
    Map<String, dynamic> loginResult;
    String nickNamePref = await getNickNameFromSharedPref();
    String emailPref = await getEmailFromSharedPref();
    String passwordPref = await getPasswordFromSharedPref();
    if(loginData['nickname'] == nickNamePref &&
        loginData['email'] == emailPref &&
        loginData['password'] == passwordPref) {
      loginResult = {
        'status': true,
        'message': 'Login successful'
      };
      _setRquestorState(Status.RequestSuccessful);
      // On successful login, store user info in memory and shared preferences.
      User().setUserProfile(loginData);
      saveUserLoginInSharedPref(loginData);
    }
    else {
      loginResult = onError('Failed to login!!');
    }
    return loginResult;
  }
}