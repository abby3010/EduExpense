import 'package:eduexpense/authentication/auth_service.dart';
import 'package:eduexpense/homepage.dart';
import 'package:eduexpense/screens/loginPage.dart';
import 'package:eduexpense/utils/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of<AuthService>(context);
    return StreamBuilder<UserCredentials>(
        stream: auth.onAuthStateChanged,
        builder: (_, AsyncSnapshot<UserCredentials> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            final user = snapshot.data;
            return user == null ? LoginPage() : HomePage();
          }
        });
  }
}
