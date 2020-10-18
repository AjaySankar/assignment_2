import 'package:assignment_2/utils/sharedPref.dart';

// Store and fetch utilities for user credentials.
const String NICK_NAME_KEY = "InstaPostNickName";
const String EMAIL_KEY = "InstaPostEmail";
const String PASSWORD_KEY = "InstaPostPassword";

void saveUserLoginInSharedPref(Map authInput) async {
  print(authInput);
  await saveToSharedPref(NICK_NAME_KEY, authInput['nickname'] ?? '');
  await saveToSharedPref(EMAIL_KEY, authInput['email'] ?? '');
  await saveToSharedPref(PASSWORD_KEY, authInput['password'] ?? '');
}

Future<String> getNickNameFromSharedPref() async {
  return await readFromSharedPref(NICK_NAME_KEY);
}

Future<String> getEmailFromSharedPref() async {
  return await readFromSharedPref(EMAIL_KEY);
}

Future<String> getPasswordFromSharedPref() async {
  return await readFromSharedPref(PASSWORD_KEY);
}