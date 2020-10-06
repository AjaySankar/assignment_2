class User {
  static final _user = User._internal();
  static String _firstName = '', _lastName = '', _password = '', _nickName = '', _email = '';
  factory User() {
    return _user;
  }
  User._internal() {
    // Singleton constructor
  }
  static void setUserProfile(Map<String, String> userProfile) {
    _firstName = userProfile['firstName'];
    _lastName = userProfile['lastName'];
    _password = userProfile['password'];
    _nickName = userProfile['_nickName'];
    _email = userProfile['email'];
  }
}