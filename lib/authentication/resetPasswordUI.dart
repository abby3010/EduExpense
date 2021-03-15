import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';

class ResetPasswordUI extends StatefulWidget {
  @override
  _ResetPasswordUIState createState() => _ResetPasswordUIState();
}

class _ResetPasswordUIState extends State<ResetPasswordUI> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "We will send you an email\nto reset your password",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                        labelText: "Email",
                        hintText: "Email with which you login"),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Enter Registered Email";
                      } else if (!value.contains(RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
                        return "Enter valid email address";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  RaisedButton(
                    onPressed: () {
                      validateAndSubmit(context);
                    },
                    padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                    child: Text(
                      "Submit",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    color: Theme.of(context).accentColor,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20.0),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FlatButton(
                    child: Text(
                      "Return Back",
                      style: TextStyle(fontSize: 20.0),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
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

  void validateAndSubmit(BuildContext context) async {
    final authServiceProvider =
        Provider.of<AuthService>(context, listen: false);
    final authService = authServiceProvider.getCurrentUser();
    if (validateAndSave()) {
      try {
        await authService.sendPasswordResetEmail(emailController.text);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Email Sent"),
              content: Text(
                  "A password reset link has been sent to ${emailController.text}\n\nAfter resetting your password, enter updated password in the login screen"),
              actions: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                  child: FlatButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            );
          },
        );
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
                  child: FlatButton(
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

// await authService.sendPasswordResetEmail(emailController.text);
