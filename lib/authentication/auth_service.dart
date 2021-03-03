import 'package:eduexpense/authentication/firebase_auth_service.dart';
import 'package:eduexpense/utils/user.dart';

abstract class AuthService {
  FirebaseAuthService getCurrentUser();
  Stream<UserCredentials> get onAuthStateChanged;
  Future<UserCredentials> createUser(String email, String password,String displayName);
  Future<UserCredentials> signInWithEmailPassword(
      String email, String password);
  Future<UserCredentials> signInWithGoogle();
  Future<void> sendPasswordResetEmail(String email);
  Future signOutUser();
  UserCredentials currentUser();
  void dispose();
}
