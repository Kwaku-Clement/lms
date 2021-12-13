import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lms/service/database.dart';
import 'package:lms/widget/responsive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lms/constants/constants.dart';
import 'package:lms/constants/extension.dart';
import 'package:lms/constants/rounded_button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../../constants/colors.dart';
import 'login_screen.dart';

class SignUp extends StatefulWidget {
  static const String id = 'signUp_screen';

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPass = TextEditingController();
  final _auth = FirebaseAuth.instance;

  static const values = <String>['Student', 'Tutor'];
  String selectedValue = values.first;
  final selectedColor = Colors.black;
  final unSelectedColor = Colors.grey;

  final _formKey = GlobalKey<FormState>();
  bool _isHidden = true;
  bool _spinner = false;
  final bool login = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: Responsive.isMobile(context)
                  ? MediaQuery.of(context).size.width
                  : 400,
              child: Form(
                  key: _formKey,
                  child: ModalProgressHUD(
                      inAsyncCall: _spinner,
                        child: Center(
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 12.0, bottom: 12),
                                child: Container(
                                  child: TextFormField(
                                    key: ValueKey('username'),
                                    autocorrect: false,
                                    controller: _usernameController,
                                    keyboardType: TextInputType.name,
                                    validator: (value) {
                                      if (value.isValidName) {
                                        return null;
                                      } else {
                                        return 'Please, enter your full namee';
                                      }
                                    },
                                    decoration: kInputTextFieldDecoration
                                        .copyWith(labelText: 'Full Name'),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 12.0, bottom: 12),
                                child: Container(
                                  child: TextFormField(
                                    key: ValueKey('email'),
                                    autocorrect: false,
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value.isValidEmail) {
                                        return null;
                                      } else {
                                        return 'Please, enter a valid email';
                                      }
                                    },
                                    decoration: kInputTextFieldDecoration
                                        .copyWith(labelText: 'Email'),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 12.0, bottom: 12),
                                child: Container(
                                  child: TextFormField(
                                    key: ValueKey('password'),
                                    autocorrect: false,
                                    obscureText: _isHidden,
                                    controller: _passwordController,
                                    keyboardType: TextInputType.visiblePassword,
                                    validator: (value) {
                                      if (value.length >= 8) {
                                        return null;
                                      } else {
                                        return 'Password should not be less than 8 characters ';
                                      }
                                    },
                                    decoration:
                                        kInputTextFieldDecoration.copyWith(
                                      prefixIcon: Icon(Icons.lock),
                                      labelText: 'Password',
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _isHidden = !_isHidden;
                                          });
                                        },
                                        child: Icon(_isHidden
                                            ? Icons.visibility
                                            : Icons.visibility_off),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(top: 12.0, bottom: 12),
                                  child: TextFormField(
                                    key: ValueKey('confirmPassword'),
                                    controller: _confirmPass,
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: _isHidden,
                                    decoration:
                                        kInputTextFieldDecoration.copyWith(
                                      prefixIcon: Icon(Icons.lock),
                                      labelText: 'Confirm Password',
                                    ),
                                    validator: (value) {
                                      FocusScope.of(context).unfocus();

                                      if (value != _passwordController.text) {
                                        return 'Password do not match';
                                      }
                                      if (value.isValidPassword) {
                                        return null;
                                      }
                                      return null;
                                    },
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(top: 12.0, bottom: 12),
                                  child: Container(
                                    child: Column(
                                      children: values.map(
                                        (value) {
                                          final selected =
                                              this.selectedValue == value;
                                          final color = selected
                                              ? selectedColor
                                              : unSelectedColor;
                                          return RadioListTile(
                                            title: Text(
                                              value,
                                              style: TextStyle(color: color),
                                            ),
                                            activeColor: selectedColor,
                                            value: value,
                                            groupValue: selectedValue,
                                            onChanged: (value) => setState(
                                                () => this.selectedValue = value),
                                          );
                                        },
                                      ).toList(),
                                    ),
                                  )),
                             Container(
                               height: 75,
                               child: RoundedButton(
                                onPressed: () async {
                                  //await Firebase.initializeApp();
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      _spinner = true;
                                    });
                                  } else {
                                    setState(() {
                                      _spinner = false;
                                    });
                                  }
                                  try {
                                    final newUser = await _auth
                                        .createUserWithEmailAndPassword(
                                            email: _emailController.text,
                                            password: _passwordController.text)
                                        .then((value) => {
                                              userCollection
                                                  .doc(value.user.uid)
                                                  .set({
                                                'username':
                                                    _usernameController.text,
                                                'email': _emailController.text,
                                                'password':
                                                    _passwordController.text,
                                                'uid': value.user.uid,
                                                'role': selectedValue,
                                                'courseIds': [],
                                                'courseNames': [],
                                                'overview': [],
                                                'createdAt': Timestamp.now(),
                                              })
                                            });

                                    if (newUser != null) {
                                      Navigator.pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            SignIn(
                                                         
                                                        ),
                                                      ),
                                                      (Route<dynamic> route) =>
                                                          false);
                                     
                                    }
                                    setState(() {
                                      _spinner = false;
                                    });
                                  } catch (e) {
                                    print(e);
                                    var snackbar = SnackBar(
                                        content: Text(
                                      e.toString(),
                                    ));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackbar);
                                    setState(() {
                                      _spinner = false;
                                    });
                                  }
                                },
                                title: 'SIGN UP',
                                colour: Colors.blueAccent,
                              )),
                              Divider(height: 2, color: Colors.grey[700]),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    login
                                        ? "Already have an Account? "
                                        : "Don’t have an Account? ",
                                    style: TextStyle(color: kPrimaryColor),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return SignIn();
                                          },
                                        ),
                                      );
                                    },
                                    child: Text(
                                      login ? "Sign In" : "Sign Up",
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      )),
            ),
          ),
        ),
      ),
    );
  }
}
