import 'package:eduexpense/authentication/auth_service.dart';
import 'package:eduexpense/homepage.dart';
import 'package:eduexpense/utils/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

enum FormType { login, register, forgetPassword }

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  FormType _formType = FormType.login;
  bool emailSent = false;

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
                    // creating empty "urls" array in FireStore to store Storage urls
                    "urls": [],
                    // creating empty "file_names" array in FireStore to store title of the file from user for above urls.
                    "file_names": [],
                  })
                  .then((value) => print("User's Document Added"))
                  .catchError((error) => print(
                      "Failed to add user: $error")) // create the document
            }
        });
  }

  // logging In
  void validateAndSubmit(BuildContext _context) async {
    final authServiceProvider =
        Provider.of<AuthService>(_context, listen: false);
    final authService = authServiceProvider.getCurrentUser();
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          await authService.signInWithEmailPassword(
              emailController.text, passwordController.text);
          print("Sign In Successful!");
          Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
        } else if (_formType == FormType.register) {
          var authUser = await authService.createUser(emailController.text,
              passwordController.text, nameController.text);
          print("User Name:::::::::::::_${authUser.displayName}_");
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(authUser.email)
              .set({
                "name": nameController.text,
                "email": emailController.text,
                // creating empty "urls" array in FireStore to store Storage urls
                "urls": [],
                // creating empty "file_names" array in FireStore to store title of the file from user for above urls.
                "file_names": [],
                // create an empty datetime field:
                "datetime": [],
              })
              .then((value) => print("User Added"))
              .catchError((error) => print("Failed to add user: $error"));

          await FirebaseFirestore.instance
              .collection("Users List")
              .doc("list_of_users")
              .update({
            "users_list": FieldValue.arrayUnion([emailController.text]),
          });
          print("User added to Global User List");
          Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
          print("Sign In Successful!");
        } else {
          await authService.sendPasswordResetEmail(emailController.text);
        }
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

  // Redirecting to register page
  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  void moveToForgetPassword() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.forgetPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _formType == FormType.forgetPassword
              ? "Reset Password"
              : "Login/SignUp",
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: formKey,
              child: Column(
                children: (buildTextInputs() + buildSubmitButtons()),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: RaisedButton(
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(
              context, "/home", (Route<dynamic> route) => false);
        },
        padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Text(
          "Skip",
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        color: Theme.of(context).accentColor,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
        ),
      ),
    );
  }

  List<Widget> buildTextInputs() {
    if (_formType == FormType.forgetPassword) {
      return [
        TextFormField(
          controller: emailController,
          decoration: InputDecoration(
              labelText: "Email", hintText: "Email with which you login"),
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
      ];
    }
    return [
      Text(
        "EduExpense",
        style: TextStyle(
          color: Theme.of(context).accentColor,
          fontSize: 35,
          fontWeight: FontWeight.w800,
        ),
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
      _formType == FormType.login
          ? TextButton(
              child: Text("Forget Password?"),
              onPressed: moveToForgetPassword,
            )
          : SizedBox(),

      _formType == FormType.register
          ? TextFormField(
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
            )
          : SizedBox(
              height: 10,
            ),
      SizedBox(height: 10),
    ];
  }

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return [
        // Login Button
        RaisedButton(
          onPressed: () => validateAndSubmit(context),
          padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
          child: Text(
            "Login",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
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
                final authUser = await authServiceProvider.signInWithGoogle();
                await _createFirebaseDocument(
                  authUser,
                );
                print("Users Document Added");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_context) => HomePage()),
                );
                print("login successful");
              } catch (signUpError) {
                print(signUpError);
              }
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            highlightElevation: 0,
            borderSide: BorderSide(color: Colors.grey),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                      image: AssetImage("assets/images/google_logo.png"),
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
        FlatButton(
          child: Text(
            "Create an Account",
            style: TextStyle(fontSize: 20.0),
          ),
          onPressed: moveToRegister,
        ),
      ];
    } else if (_formType == FormType.forgetPassword) {
      return [
        RaisedButton(
          onPressed: () {
            setState(() {
              emailSent = true;
            });
            validateAndSubmit(context);
          },
          padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
          child: Text(
            "Submit",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
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
        emailSent
            ? Text(
                "A password reset link has been sent to ${emailController.text}\n\nAfter resetting your password, enter updated password in the login screen",
                textAlign: TextAlign.center,
              )
            : SizedBox(height: 10),
        FlatButton(
          child: Text(
            "Return Back",
            style: TextStyle(fontSize: 20.0),
          ),
          onPressed: moveToLogin,
        ),
      ];
    } else {
      return [
        // Sign Up Button
        RaisedButton(
          onPressed: () => validateAndSubmit(context),
          padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
          child: Text(
            "Sign Up",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
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
                final authUser = await authServiceProvider.signInWithGoogle();
                await _createFirebaseDocument(authUser);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_context) => HomePage()),
                );
                print("Login successful");
              } catch (signUpError) {
                print(signUpError);
              }
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            highlightElevation: 0,
            borderSide: BorderSide(color: Colors.grey),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                      image: AssetImage("assets/images/google_logo.png"),
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
        FlatButton(
          child: Text(
            "Have an Account? Login",
            style: TextStyle(fontSize: 20.0),
          ),
          onPressed: moveToLogin,
        ),
      ];
    }
  }
}
