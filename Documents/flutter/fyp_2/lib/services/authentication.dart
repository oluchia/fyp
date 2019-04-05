import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp/services/rest_calls.dart';

//In Dart, every class defines an implicit interface
//Use an abstract class to define an interface that cannot be instantiated
abstract class BaseAuth {
  Future<String> signIn(String email, String password);
  Future<String> signUp(String email, String password);
  Future<void> passwordReset(String email);
  Future<FirebaseUser> getCurrentUser();
  Future<String> getCurrentUserEmail();
  Future<void> signOut();
  Future<void> deleteAccount();
  Future<void> reAuthenticate(String email, String password);
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password
    );

    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password
    );

    await addUserToFirebaseCollection(user);

    return user.uid;
  }

  Future<void> passwordReset(String email) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<String> getCurrentUserEmail() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.email;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> deleteAccount() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.delete();
  }

  Future<void> reAuthenticate(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    AuthCredential credential = EmailAuthProvider.getCredential(email: email, password: password );
    return user.reauthenticateWithCredential(credential);
  }
}