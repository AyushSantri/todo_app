import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_app/screens/home.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();
  var _email = ' ';
  var _password = ' ';
  var _username = ' ';
  bool isLoginPage = false;

  startAuthentication() {
    final validity = _formkey.currentState!.validate();

    if (validity) {
      _formkey.currentState!.save();
      submitForm(_email, _password, _username);
    }
  }

  submitForm(String email, String password, String username) async {
    final auth = FirebaseAuth.instance;
    UserCredential userCredential;

    try {
      if (isLoginPage) {
        userCredential = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        userCredential = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String uid = userCredential.user!.uid;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set({'username': username, 'email': email});
      }
    } catch (err) {
      Fluttertoast.showToast(msg: err.toString());
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isLoginPage)
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      key: const ValueKey('username'),
                      validator: (value) {
                        if (value?.isEmpty == true) {
                          return 'Incorrect name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _username = value!;
                      },
                      decoration: InputDecoration(
                        labelText: "Enter Username",
                        hintText: "John Doe",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide()),
                      ),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    key: const ValueKey('email'),
                    validator: (value) {
                      if (value?.isEmpty == true ||
                          value?.contains('@') == false) {
                        return 'Incorrect Email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                    decoration: InputDecoration(
                      labelText: "Enter email",
                      hintText: "john123@gmail.com",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide()),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    key: const ValueKey('password'),
                    validator: (value) {
                      if (value?.isEmpty == true) {
                        return 'password empty';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value!;
                    },
                    decoration: InputDecoration(
                      labelText: "Enter password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide()),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      padding: const EdgeInsets.all(5),
                      width: double.infinity,
                      height: 70,
                      child: RaisedButton(
                          child: isLoginPage
                              ? const Text('Login')
                              : const Text('SignUp'),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            setState(() {
                              startAuthentication();
                            });
                          })),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          isLoginPage = !isLoginPage;
                        });
                      },
                      child: isLoginPage
                          ? const Text('Not a member?')
                          : const Text('Already a member?'),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
