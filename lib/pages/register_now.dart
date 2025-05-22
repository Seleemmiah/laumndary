import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:taste_app/pages/home_page.dart';
import 'package:taste_app/pages/login_page.dart';
import '../components/my_buttons.dart';
import '../components/square_tile.dart';
import '../components/text_field.dart';

class RegisterNow extends StatefulWidget {
  const RegisterNow({super.key});

  @override
  State<RegisterNow> createState() => _RegisterNowState();
}

class _RegisterNowState extends State<RegisterNow> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String passwordStrength = ""; //  For showing password strength
  Color strengthColor = Colors.transparent; //  Color for strength text

  // google sign in
  signInWithGoogle() async {
// begin witth interractive sign in process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    if (gUser == null) {
      return;
    }
// obtain auth details from the request
    final GoogleSignInAuthentication gAuth = await gUser.authentication;
    // user cancels google sign in pop up
// create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // This is where you can use the credential to sign in with Firebase
    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  void initState() {
    super.initState();
    //  Listen to password changes to update strength
    passwordController.addListener(updatePasswordStrength);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // 🔍 Function to check password strength
  void updatePasswordStrength() {
    final password = passwordController.text;

    setState(() {
      if (password.isEmpty) {
        passwordStrength = "";
        strengthColor = Colors.transparent;
      } else if (password.length < 6) {
        passwordStrength = "Weak";
        strengthColor = Colors.red;
      } else if (RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]{6,}$')
          .hasMatch(password)) {
        passwordStrength = "Medium";
        strengthColor = Colors.orange;
      }
      if (RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$')
          .hasMatch(password)) {
        passwordStrength = "Strong";
        strengthColor = Colors.green;
      }
    });
  }

  bool validateInputs() {
    final name = nameController.text.trim();
    final password = passwordController.text.trim();

    if (name.length < 3) {
      Navigator.pop(context);
      showMessage('Full name must be at least 3 characters.');
      return false;
    }

    final passwordRegex =
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$');

    if (!passwordRegex.hasMatch(password)) {
      Navigator.pop(context);
      showMessage(
          'Password must be at least 8 characters long and include uppercase, lowercase, number, and special character.');
      return false;
    }

    return true;
  }

  void showMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Invalid Input'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  void registerUserIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      Navigator.pop(context);
      showMessage('Please fill in all fields.');
      return;
    }

    if (password != confirmPassword) {
      Navigator.pop(context);
      showMessage('Passwords do not match.');
      return;
    }

    if (!validateInputs()) return;

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Update the user's display name
      await FirebaseAuth.instance.currentUser!
          .updateDisplayName(nameController.text.trim());
      await FirebaseAuth.instance.currentUser!.reload();

      Navigator.pop(context); // close loading dialog

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      String errorMessage;

      if (e.code == 'email-already-in-use') {
        errorMessage = 'This email is already registered.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email format.';
      } else {
        errorMessage = e.message ?? 'An unexpected error occurred.';
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Registration Failed'),
          content: Text(errorMessage),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              Center(
                child: Container(
                  color: Colors.grey,
                  child: Image.asset(
                    'lib/images/logo4.png',
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              const SizedBox(height: 25),

              MyTextField(
                controller: nameController,
                hintText: 'Full Name',
                obscureText: false,
                prefixIcon: const Icon(Icons.person),
              ),

              const SizedBox(height: 10),

              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
                prefixIcon: const Icon(Icons.email),
              ),

              const SizedBox(height: 10),

              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),

              //  Password Strength Indicator Below Password Field
              if (passwordStrength.isNotEmpty)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25.0, vertical: 4),
                  child: Row(
                    children: [
                      Text(
                        'Password Strength: ',
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        passwordStrength,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: strengthColor,
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 10),

              MyTextField(
                controller: confirmPasswordController,
                hintText: 'Confirm Password',
                obscureText: true,
              ),

              const SizedBox(height: 25),

              MyButton(text: "Sign Up", onTap: registerUserIn),

              const SizedBox(height: 40),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                        child:
                            Divider(thickness: 0.5, color: Colors.grey[400])),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        "or continue with",
                        style: TextStyle(color: Colors.grey[700], fontSize: 12),
                      ),
                    ),
                    Expanded(
                        child:
                            Divider(thickness: 0.5, color: Colors.grey[400])),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: signInWithGoogle,
                    child: SquareTile(imagePath: 'lib/images/google.PNG'),
                  ),
                  const SizedBox(width: 25),
                  SquareTile(imagePath: 'lib/images/apple.PNG'),
                ],
              ),

              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(color: Colors.grey[700], fontSize: 12),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: Text(
                      'Login now',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
