import 'package:eduexpense/utils/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth_service.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // UserCredentials is a custom Class which we made in user.dart
  // User is a firebase Auth class which comes inbuilt with firebase_auth package.
  UserCredentials _userFromFirebase(User user) {
    if (user == null) {
      return null;
    }
    return UserCredentials(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }

  @override
  FirebaseAuthService getCurrentUser() {
    return this;
  }

  @override
  UserCredentials currentUser() {
    final User user = _firebaseAuth.currentUser;
    return _userFromFirebase(user);
  }

  @override
  Stream<UserCredentials> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  @override
  Future<UserCredentials> createUser(
      String email, String password, String displayName) async {
    await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((result) {
      return result.user.updateProfile(displayName: displayName);
    });
    return _userFromFirebase(_firebaseAuth.currentUser);
  }

  @override
  Future<UserCredentials> signInWithEmailPassword(
      String email, String password) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<UserCredentials> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final authResult = await _firebaseAuth.signInWithCredential(credential);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async{
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future signOutUser() async {
    return _firebaseAuth.signOut();
  }

  @override
  void dispose() {}
}
