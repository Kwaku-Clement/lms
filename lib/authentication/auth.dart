import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class Auth {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signOut() async {
    String retVal = "error";

    try {
      await _auth.signOut();
      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<String> loginUserWithEmail({String email, String password}) async {
    //await Firebase.initializeApp();
    String retVal = "error";

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      retVal = e.message;
    } catch (e) {}

    return retVal;
  }
}
