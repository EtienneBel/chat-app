import 'package:chat_app/modal/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModal _userFromFirebase(User user) {
    return user != null ? UserModal(userId: user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      User firebaseUser = (await _auth.signInWithEmailAndPassword(
          email: email, password: password)).user;
      return _userFromFirebase(firebaseUser);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try{
      User firebaseUser = (await _auth.createUserWithEmailAndPassword
        (email: email, password: password)).user;
      return _userFromFirebase(firebaseUser);
    } catch(e){
      print(e.toString());
    }
  }

  Future resetPass(String email) async {
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    } catch(e){
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e){

    }
  }
}
