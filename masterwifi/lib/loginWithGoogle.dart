import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:masterwifi/moreScreen.dart';
import 'package:provider/provider.dart';
import 'package:masterwifi/user_provider.dart';

class LoginScreen extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final userCredential = await _googleSignIn.signIn();
      if (userCredential != null) {
        // Successfully signed in
        // Update the provider with the whole userCredential object
        Provider.of<UserProvider>(context, listen: false)
            .setUserCredential(userCredential);
        Navigator.of(context).pop();

        // You can now navigate to another screen or handle the user's information
      }
    } catch (e) {
      print('Error signing in with Google: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login with Google')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _signInWithGoogle(context);

            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => MoreScreen()),
            // );
          },
          child: Text('Sign in with Google'),
        ),
      ),
    );
  }
}
