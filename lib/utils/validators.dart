// Reference - https://medium.com/@aslamanver/email-validation-in-dart-flutter-e1f3264ab59d

const int MIN_HASH_TAG_LEN = 2; // Including # symbol

String validateEmail(String value) {
  String _msg;
  if (value.isEmpty) {
    _msg = "Your email is required";
  } else if (!isEmailValidFormat(value)) {
    _msg = "Please provide a valid emal address";
  }
  return _msg;
}

bool isEmailValidFormat(String email) {
  if (email.length == 0) {
    return false;
  }
  RegExp regex = new RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  return regex.hasMatch(email);
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

String validatePost(String post) {
  String _msg;
  List<String> hashTags = getHashTags(post);
  List<String> invalidHashTags = getInValidHashTags(getHashTags(post));
  if(post.isEmpty) {
    _msg = "Post description is required";
  }
  else if(hashTags.length == 0) {
    _msg = "Please add some hashtags";
  }
  else if(invalidHashTags.length > 0) {
    _msg = "Please remove empty hashtags";
  }
  return _msg;
}


List<String> getHashTags(String post) {
  RegExp exp = new RegExp(r"\B#\w*");
  List<String> hashTags = [];
  exp.allMatches(post).forEach((match){
    hashTags.add(match.group(0));
  });
  return hashTags;
}

List<String> getInValidHashTags(List<String> hashTags) {
  return hashTags.where((element) => element.length < MIN_HASH_TAG_LEN).toList();
}