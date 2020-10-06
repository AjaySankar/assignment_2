// Reference - https://medium.com/@aslamanver/email-validation-in-dart-flutter-e1f3264ab59d

String validateEmail(String value) {
  String _msg;
  RegExp regex = new RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  if (value.isEmpty) {
    _msg = "Your email is required";
  } else if (!regex.hasMatch(value)) {
    _msg = "Please provide a valid emal address";
  }
  return _msg;
}

String validatePassword(String value) {
  String _msg;
  if (value.isEmpty) {
    _msg = "Your password is required";
  } else if (value.length < 3) {
    _msg = "Password should be at least 3 characters";
  }
  return _msg;
}