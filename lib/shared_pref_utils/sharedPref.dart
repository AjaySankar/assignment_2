import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveToSharedPref(String key, String value) async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  sp.setString(key, value);
}


Future<String> readFromSharedPref(String key) async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  return sp.getString(key) ?? '';
}

Future<void> clearAllSharedPref() async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  await sp.clear();
}