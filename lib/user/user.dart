class User {
  static final _user = User._internal();
  String _firstName = '', _lastName = '', _password = '', _nickName = '', _email = '';

  String get firstName => _firstName;
  String get lastName => _lastName;
  String get password => _password;
  String get nickName => _nickName;
  String get email => _email;

  factory User() {
    return _user;
  }
  User._internal() {
    // Singleton constructor
  }
  void setUserProfile(Map<String, String> userProfile) {
    _firstName = userProfile['firstName'];
    _lastName = userProfile['lastName'];
    _password = userProfile['password'];
    _nickName = userProfile['_nickName'];
    _email = userProfile['email'];
  }
}