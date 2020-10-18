import 'package:flutter/material.dart';
import 'package:assignment_2/utils/input_decoration.dart';
import 'package:assignment_2/utils/login_register_buttons.dart';
import 'package:assignment_2/utils/validators.dart';
import 'package:assignment_2/utils/theme.dart';
import 'package:assignment_2/auth/auth.dart';
import 'package:assignment_2/utils/request_states.dart';
import 'package:assignment_2/network/checkIfNickNameExists.dart';
import 'package:assignment_2/network/checkIfEmailExists.dart';
import 'package:assignment_2/network/deviceOfflineCheck.dart';


class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>(); // Hack to show snack bar -> https://bit.ly/2SslerY
  Status _registeredInStatus = Status.NotRequested;
  Auth authHandle;
  FocusNode _focusNickName = new FocusNode();
  FocusNode _focusEmail = new FocusNode();
  String _firstName, _lastName, _password, _nickName, _email;
  TextEditingController nickNameController = TextEditingController(text: '');
  TextEditingController firstNameController = TextEditingController(text: '');
  TextEditingController lastNameController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');
  TextEditingController confirmPasswordController = TextEditingController(text: '');
  TextEditingController emailController = TextEditingController(text: '');


  @override
  void initState() {
    super.initState();
    showOfflineWarning();
    _focusNickName.addListener(() {
      if(!_focusNickName.hasFocus) {
        _showIfNickNameAvailable();
      }
    });
    _focusEmail.addListener(() {
      if(!_focusEmail.hasFocus) {
        _showIfEmailAvailable();
      }
    });
    authHandle = Auth((Status registrationState) {
      setState(() {
        _registeredInStatus = registrationState;
      });
    });
  }

  void _showIfNickNameAvailable() {
    String currentNickNameEntered = nickNameController.text;
    if(currentNickNameEntered.length > 0) {
      doesNickNameExist(currentNickNameEntered).then((isNickNameAlreadyUsed) {
        if(isNickNameAlreadyUsed) {
          showSnackBar('$currentNickNameEntered is already in use!! Try some other nickname.');
        }
      });
    }
  }

  void _showIfEmailAvailable() {
    String currentEmailEntered = emailController.text;
    if(isEmailValidFormat(currentEmailEntered)) {
      print(currentEmailEntered);
      doesEmailExist(currentEmailEntered).then((isEmailAlreadyUsed) {
        if(isEmailAlreadyUsed) {
          showSnackBar('$currentEmailEntered is already in use!! Try some other email.');
        }
      });
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    firstNameController.dispose();
    nickNameController.dispose();
    lastNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    emailController.dispose();
    _focusEmail.removeListener(() { });
    _focusNickName.removeListener(() { });
    super.dispose();
  }

  void showSnackBar(text) {
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(text),
          duration: Duration(seconds: 3),
        )
    );
  }

  Future<void> showOfflineWarning() async {
    bool isOffline = await isDeviceOffline();
    if(isOffline) {
      showSnackBar('Please connect to internet to register!!');
    }
  }

  @override
  Widget build(BuildContext context) {

    var register = () async {
      final form = formKey.currentState;
      if (form.validate()) {
        form.save();
        authHandle.registerUser(_firstName, _lastName, _nickName, _email, _password).then((response) async {
          bool isOffline = await isDeviceOffline();
          if(isOffline) {
            showSnackBar('Please connect to internet to register!!');
            return;
          }
          else if(!response['status']) {
            showSnackBar(response['message']??'Failed to register!!');
          }
          else {
            Navigator.pushReplacementNamed(context, '/dashboard');
          }
        });
      }
    };

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Registering... Please wait")
      ],
    );

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text('InstaPost'),
              backgroundColor: getThemeColor(),
            ),
            key: _scaffoldKey,
            body: Center(
              child: SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.all(40.0),
                    child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                  "Register",
                                  style: TextStyle(
                                      fontSize: 40,
                                      color: Color(0xfff063057)
                                  )
                              ),
                            ),
                            SizedBox(height: 25.0),
                            TextFormField(
                              controller: firstNameController,
                              autofocus: false,
                              validator: (value) => value.isEmpty ? "Please enter first name" : null,
                              onSaved: (value) => setState(() { _firstName = firstNameController.text; }),
                              decoration: buildInputDecoration("Name", Icons.account_circle),
                            ),
                            SizedBox(height: 10.0),
                            TextFormField(
                              controller: lastNameController,
                              autofocus: false,
                              validator: (value) => value.isEmpty ? "Please enter last name" : null,
                              onSaved: (value) => setState(() { _lastName = lastNameController.text; }),
                              decoration: buildInputDecoration("Last Name", Icons.account_circle),
                            ),
                            SizedBox(height: 10.0),
                            TextFormField(
                              controller: nickNameController,
                              validator: (value) => value.isEmpty ? "Please enter nickname" : null,
                              autofocus: false,
                              onSaved: (value) => setState(() { _nickName = nickNameController.text; }),
                              decoration: buildInputDecoration("Nick Name", Icons.account_circle),
                              focusNode: _focusNickName,
                            ),
                            SizedBox(height: 10.0),
                            TextFormField(
                              controller: passwordController,
                              autofocus: false,
                              obscureText: true,
                              validator: validatePassword,
                              onSaved: (value) => setState(() { _password = passwordController.text; }),
                              decoration: buildInputDecoration("Password", Icons.lock),
                            ),
                            SizedBox(height: 10.0),
                            TextFormField(
                              controller: emailController,
                              autofocus: false,
                              validator: validateEmail,
                              onSaved: (value) => setState(() { _email = emailController.text; }),
                              decoration: buildInputDecoration("Email", Icons.email),
                              focusNode: _focusEmail,
                            ),
                            SizedBox(height: 20.0),
                            _registeredInStatus == Status.RequestInProcess
                                ? loading
                                : longButtons("Register", register),
                          ],
                        )
                    )
                ),
              ),
            )
        )
    );
  }
}