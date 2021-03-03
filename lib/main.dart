import 'package:eduexpense/authentication/auth_service.dart';
import 'package:eduexpense/screens/feedbackScreen.dart';
import 'package:eduexpense/screens/loginPage.dart';
import 'package:eduexpense/screens/myProfileScreen.dart';
import 'package:eduexpense/utils/landingPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eduexpense/authentication/firebase_auth_service.dart';
import 'homepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of application.
  @override
  Widget build(BuildContext context) {
    return Provider<AuthService>(
      create: (_) => FirebaseAuthService(),
      dispose: (_, AuthService authService) => authService.dispose(),
      child: MaterialApp(
        title: 'EduExpense',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        debugShowCheckedModeBanner: false,
        // initialRoute: initialScreen(),
        initialRoute: "/",
        routes: {
          "/": (context) => LandingPage(),
          "/home": (context) => HomePage(),
          "/login": (context) => LoginPage(),
          "/myProfile": (context) => MyProfileScreen(),
          "/feedback": (context) => FeedbackScreen(),
        },
      ),
    );
  }
}
