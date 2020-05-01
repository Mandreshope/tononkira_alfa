import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthBloc with ChangeNotifier {

  AuthBloc() : _firebaseAuth = FirebaseAuth.instance {
    _firebaseAuth.onAuthStateChanged.listen(_onAuthStateChanged);
  }

  FirebaseUser user;
  FirebaseAuth _firebaseAuth;
  String _messageCodeException;
  bool forgotPasswordLoader = false;
  set setforgotPasswordLoader(bool v) {
    forgotPasswordLoader = v;
    notifyListeners();
  }

  Status _status = Status.Uninitialized;
  Status get status => _status;
  set status(Status v) {
    _status = v;
    notifyListeners();
  }

  Future<void> _onAuthStateChanged(FirebaseUser firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      user = firebaseUser;
      _status = Status.Authenticated;
    }
    notifyListeners();
  }

  Future<String> signIn(String email, String password) async {
    _messageCodeException = null;
    try {
      status = Status.Authenticating;
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      _messageCodeException = "SUCCESS";
    } catch (e) {
      status = Status.Unauthenticated;
      _messageCodeException = e.code;
    }
    return _messageCodeException;
  }

  Future<void> signOut() {
    _firebaseAuth.signOut();
    status = Status.Unauthenticated;
    print("User Sign Out");
    return Future.delayed(Duration.zero);
  }
  
  Future<void> resetPassword({String email}) {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }