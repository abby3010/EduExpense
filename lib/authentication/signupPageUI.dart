import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduexpense/utils/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../homepage.dart';
import 'auth_service.dart';
import 'loginPageUI.dart';

class SignUpPageUI extends StatefulWidget {
  @override
  _SignUpPageUIState createState() => _SignUpPageUIState();
}

class _SignUpPageUIState extends State<SignUpPageUI> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController1 = TextEditingController();
  TextEditingController passwordController2 = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Text(
                    "EduExpense",
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 35,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  // Name Textfield
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Your Name",
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Enter your name";
                      }
                      return null;
                    },
                  ),

                  // Email TextField
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Enter Email";
                      } else if (!value.contains(RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
                        return "Enter valid email address";
                      }
                      return null;
                    },
                  ),

                  // Password TextField
                  TextFormField(
                    controller: passwordController1,
                    decoration: InputDecoration(
                      labelText: "Password",
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Enter Password!";
                      } else if (value.length < 6) {
                        return "Password should be atleast 6 characters!";
                      }
                      return null;
                    },
                    obscureText: true,
                  ),

                  // Confirm Password
                  TextFormField(
                    controller: passwordController2,
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Enter Confirm Password!";
                      } else if (value != passwordController1.text) {
                        return "Password is not same!";
                      }
                      return null;
                    },
                    obscureText: true,
                  ),

                  SizedBox(
                    height: 10,
                  ), // Sign Up Button
                  RaisedButton(
                    onPressed: () => validateAndSubmit(context),
                    padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    color: Theme.of(context).accentColor,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20.0),
                    ),
                  ),

                  // Google SignIn Button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                    child: OutlineButton(
                      splashColor: Colors.grey,
                      onPressed: () async {
                        final authServiceProvider =
                            Provider.of<AuthService>(context, listen: false);
                        try {
                          final authUser =
                              await authServiceProvider.signInWithGoogle();
                          await _createFirebaseDocument(authUser);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_context) => HomePage()),
                          );
                          print("Login successful");
                        } catch (signUpError) {
                          print(signUpError);
                        }
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      highlightElevation: 0,
                      borderSide: BorderSide(color: Colors.grey),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image(
                                image:
                                    AssetImage("assets/images/google_logo.png"),
                                height: 35.0),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                'Sign Up with Google',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Create an Account Panel
                  TextButton(
                    child: Text(
                      "Have an Account? Login",
                      style:
                          TextStyle(fontSize: 20.0, color: Colors.deepPurple),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_context) => LoginPageUI()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _createFirebaseDocument(UserCredentials authUser) async {
    final usersRef =
        FirebaseFirestore.instance.collection('Users').doc(authUser.email);
    usersRef.get().then((docSnapshot) => {
          if (!docSnapshot.exists)
            {
              usersRef
                  .set({
                    "name": authUser.displayName,
                    "email": authUser.email,
                  })
                  .then((value) => print("User's Document Added"))
                  .catchError((error) => print(
                      "Failed to add user: $error")) // create the document
            }
        });
  }

  // Checking Submission from the Form
  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmit(BuildContext _context) async {
    final authServiceProvider =
        Provider.of<AuthService>(_context, listen: false);
    final authService = authServiceProvider.getCurrentUser();
    if (validateAndSave()) {
      try {
        var authUser = await authService.createUser(emailController.text,
            passwordController2.text, nameController.text);
        print("User Name:::::::::::::_${authUser.displayName}_");
        await _createFirebaseDocument(authUser);
        Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
        print("Sign In Successful!");
      } catch (e) {
        print(e);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Some error occured!\nPlease Try Again!"),
              actions: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                  child: TextButton(
                    child: Text("Try Again"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            );
          },
        );
      }
    }
  }
}
