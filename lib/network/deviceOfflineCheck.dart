import 'dart:async';
import 'package:assignment_2/utils/urls.dart';
import 'package:http/http.dart';
import 'dart:convert';

Future<bool> isDeviceOffline() async {
  bool isOffline = true;
  await get('${Urls.ping}')
      .then((Response response) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (response.statusCode == 200 && responseData["message"] == "pong") {
          print("Device is online");
          isOffline = false;
        }
      })
      .catchError((error) {
        print("Device is offline");
      });
  return isOffline;
}
