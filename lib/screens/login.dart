import 'package:flutter/material.dart';
import 'package:assignment_2/utils/input_decoration.dart';
import 'package:assignment_2/utils/login_register_buttons.dart';
import 'package:assignment_2/utils/theme.dart';
import 'package:assignment_2/auth/auth.dart';
import 'package:assignment_2/auth/authInfoUtils.dart';
import 'package:assignment_2/utils/request_states.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>(); // Hack to show snack bar -> https://bit.ly/2SslerY

  String _email, _nickname, _password;
  TextEditingController emailController;
  TextEditingController nickNameController;
  TextEditingController passwordController;

  Status _loginStatus = Status.NotRequested;
  Auth authHandle;

  Future<void> initializeLoginForm() async {
    String nickName = await getNickNameFromSharedPref();
    String email = await getEmailFromSharedPref();
    String password = await getPasswordFromSharedPref();
    setState(() {
      emailController = TextEditingController(text: email);
      nickNameController = TextEditingController(text: nickName);
      passwordController = TextEditingController(text: password);
    });
  }

  @override
  void initState() {
    super.initState();
    authHandle = Auth((Status registrationState) {
      setState(() {
        _loginStatus = registrationState;
      });
    });
    initializeLoginForm();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    emailController.dispose();
    nickNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var showSnackBar = (text) => {
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(text),
            duration: Duration(seconds: 3),
          )
      )
    };

    var login = () {
      final form = formKey.currentState;
      if (form.validate()) {
        form.save();
        authHandle.login(_email, _password, _nickname).then((Map response) {
          if(!response['status']) {
            print(response);
            showSnackBar('Failed to login. Invalid credentials!!');
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
        Text(" Logging in... Please wait")
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
                        "Login",
                        style: TextStyle(
                            fontSize: 40,
                            color: Color(0xfff063057)
                        )
                      ),
                    ),
                    SizedBox(height: 25.0),
                    TextFormField(
                      controller: emailController,
                      validator: (value) => value.isEmpty ? "Please enter email" : null,
                      autofocus: false,
                      onSaved: (value) => setState(() { _email = emailController.text; }),
                      decoration: buildInputDecoration("Email", Icons.email),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: nickNameController,
                      validator: (value) => value.isEmpty ? "Please enter nickname" : null,
                      autofocus: false,
                      onSaved: (value) => setState(() { _nickname = nickNameController.text; }),
                      decoration: buildInputDecoration("Nick Name", Icons.account_circle),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: passwordController,
                      autofocus: false,
                      obscureText: true,
                      validator: (value) => value.isEmpty ? "Please enter password" : null,
                      onSaved: (value) => setState(() { _password = passwordController.text; }),
                      decoration: buildInputDecoration("Password", Icons.lock),
                    ),
                    SizedBox(height: 20.0),
                    _loginStatus == Status.RequestInProcess
                        ? loading
                        : longButtons("Login", login),
                    SizedBox(height: 30.0),
                    Center(
                      child: FlatButton(
                        padding: EdgeInsets.only(left: 0.0),
                        child: Text(
                            "Sign up",
                            style: TextStyle(
                                fontSize: 20,
                                color: Color(0xfff063057)
                            )
                        ),
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/register');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}