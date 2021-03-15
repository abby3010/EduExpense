import 'package:eduexpense/authentication/resetPasswordUI.dart';
import 'package:eduexpense/authentication/signupPageUI.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../homepage.dart';
import 'auth_service.dart';

class LoginPageUI extends StatefulWidget {
  @override
  _LoginPageUIState createState() => _LoginPageUIState();
}

class _LoginPageUIState extends State<LoginPageUI> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
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

                    // Image(
                    //   height: MediaQuery.of(context).size.height * 0.3,
                    //   image: AssetImage('assets/images/login1.jpg'),
                    // ),
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
                      controller: passwordController,
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
                    TextButton(
                      child: Text("Forget Password?"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ResetPasswordUI()),
                        );
                      },
                    ),

                    // Login Button
                    RaisedButton(
                      onPressed: () => validateAndSubmit(context),
                      padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                      child: Text(
                        "Login",
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
                            await authServiceProvider.signInWithGoogle();
                            print("Users Logged In");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_context) => HomePage()),
                            );
                            print("login successful");
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
                                  image: AssetImage(
                                      "assets/images/google_logo.png"),
                                  height: 35.0),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  'Sign in with Google',
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
                        "Create an Account",
                        style: TextStyle(fontSize: 20.0, color: Colors.purple),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  SignUpPageUI()),
                        );
                      },
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

  // logging In
  void validateAndSubmit(BuildContext _context) async {
    final authServiceProvider =
        Provider.of<AuthService>(_context, listen: false);
    final authService = authServiceProvider.getCurrentUser();
    if (validateAndSave()) {
      try {
        await authService.signInWithEmailPassword(
            emailController.text, passwordController.text);
        print("Sign In Successful!");
        Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
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
