import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, GoogleAuthProvider, User;
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:taste_app/pages/home_page.dart';
import 'package:taste_app/pages/login_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

// google sign in
  signInWithGoogle() async {
// begin witth interractive sign in process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

// obtain auth details from the request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

// create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // This is where you can use the credential to sign in with Firebase
    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // Check if the user is logged in
            if (snapshot.hasData) {
              return HomePage();
            }

            // If the user is logged in, navigate to the home page
            else {
              return LoginPage();
            }
          }),
    );
  }
}
