import 'package:flutter/material.dart';
import 'package:assignment_2/utils/input_decoration.dart';
import 'package:assignment_2/utils/login_register_buttons.dart';
import 'package:assignment_2/utils/validators.dart';
import 'package:assignment_2/auth/auth.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = new GlobalKey<FormState>();

  String _firstName, _lastName, _password, _nickName, _email;
  TextEditingController nickNameController = TextEditingController(text: '');
  TextEditingController firstNameController = TextEditingController(text: '');
  TextEditingController lastNameController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');
  TextEditingController confirmPasswordController = TextEditingController(text: '');
  TextEditingController emailController = TextEditingController(text: '');

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var register = () {
      final form = formKey.currentState;
      if (form.validate()) {
        form.save();
        print("All good");
        registerUser(_firstName, _lastName, _nickName, _email, _password).then((response) {
          print(response);
        });
      }
    };

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("InstaPost"),
            ),
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