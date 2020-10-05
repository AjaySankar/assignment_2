import 'package:flutter/material.dart';
import 'package:assignment_2/utils/input_decoration.dart';
import 'package:assignment_2/utils/login_register_buttons.dart';
import 'package:assignment_2/utils/validators.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = new GlobalKey<FormState>();

  String _userName, _password, _confirmPassword, _nickName, _email;
  TextEditingController nickNameController = TextEditingController(text: '');
  TextEditingController userNameController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');
  TextEditingController confirmPasswordController = TextEditingController(text: '');
  TextEditingController emailController = TextEditingController(text: '');

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    userNameController.dispose();
    nickNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var register = () {
      final form = formKey.currentState;
      if (form.validate()) {
        print("All good");
      }
    };

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
                                  "Register",
                                  style: TextStyle(
                                      fontSize: 40,
                                      color: Color(0xfff063057)
                                  )
                              ),
                            ),
                            SizedBox(height: 25.0),
                            TextFormField(
                              autofocus: false,
                              validator: (value) => value.isEmpty ? "Please enter name" : null,
                              onSaved: (value) => setState(() { _userName = userNameController.text; }),
                              decoration: buildInputDecoration("Name", Icons.account_circle),
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              controller: nickNameController,
                              validator: (value) => value.isEmpty ? "Please enter nickname" : null,
                              autofocus: false,
                              onSaved: (value) => setState(() { _nickName = nickNameController.text; }),
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
                            TextFormField(
                              controller: emailController,
                              autofocus: false,
                              validator: validateEmail,
                              onSaved: (value) => setState(() { _email = emailController.text; }),
                              decoration: buildInputDecoration("Email", Icons.email),
                            ),
                            SizedBox(height: 20.0),
                            longButtons("Register", register)
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