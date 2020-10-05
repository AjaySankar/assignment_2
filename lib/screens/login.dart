import 'package:flutter/material.dart';
import 'package:assignment_2/utils/input_decoration.dart';
import 'package:assignment_2/utils/login_register_buttons.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = new GlobalKey<FormState>();

  String _nickname, _password;
  TextEditingController nickNameController;
  TextEditingController passwordController;

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    nickNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
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
                    longButtons("Login", () => {}),
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
                          // Navigator.pushReplacementNamed(context, '/register');
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