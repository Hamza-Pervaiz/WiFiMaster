import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserProvider with ChangeNotifier {
  GoogleSignInAccount? _userCredential;

  GoogleSignInAccount? get userCredential => _userCredential;

  void setUserCredential(GoogleSignInAccount userCredential) {
    _userCredential = userCredential;
    notifyListeners();
  }
}
