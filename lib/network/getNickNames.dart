import 'dart:async';
import 'package:assignment_2/utils/urls.dart';
import 'package:http/http.dart';
import 'package:assignment_2/network/postRequestBase.dart';
import 'dart:convert';
import 'package:assignment_2/utils/request_states.dart';
import 'package:assignment_2/shared_pref_utils/sharedPref.dart';
import 'package:assignment_2/network/deviceOfflineCheck.dart';

const String NICKNAMES_LIST_SHARED_PREF_KEY_PREFIX = "Nicknames";

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

    bool isOffline = await isDeviceOffline();
    if(isOffline) {
      // If device is offline, read nicknames from shared preferences.
      // print("Got nicknames from offline");
      return await readNickNamesFromSharedPref();
    }

    Map response = await _getNickNames();
    List<String> nickNames = [];
    if(response['status']) {
      setRquestorState(Status.RequestSuccessful);
      response['body']['nicknames']
          .forEach((name) => nickNames.add(name.toString()));
      saveNickNamesToSharedPref(nickNames);
    }
    else {
      setRquestorState(Status.RequestFailed);
    }
    return nickNames;
  }

  // Store fetched nicknames in shared preferences
  Future<void> saveNickNamesToSharedPref(List<String> nickNames) async {
    String nickNamesString = nickNames.join(',');
    await saveToSharedPref(NICKNAMES_LIST_SHARED_PREF_KEY_PREFIX, nickNamesString);
  }

  // Read nicknames from shared preferences
  Future<List<String>> readNickNamesFromSharedPref() async {
    setRquestorState(Status.RequestInProcess);
    final String nickNamesString = await readFromSharedPref(NICKNAMES_LIST_SHARED_PREF_KEY_PREFIX);
    setRquestorState(Status.RequestSuccessful);
    return nickNamesString.split(',');
  }
}