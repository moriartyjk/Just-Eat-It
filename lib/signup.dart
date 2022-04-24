import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'appbar.dart';

// The sign up page.
class SignupPage extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore store;

  const SignupPage({Key? key, required this.auth, required this.store}) : super(key: key);

  @override
  SignupPageState createState() {
    return SignupPageState();
  }
}

class SignupPageState extends State<SignupPage> {
  /// For form validation
  final formKey = GlobalKey<FormState>();
  /// Used to read the email from the text field.
  final emailController = TextEditingController();
  /// Used to read the password from the text field.
  final passwordController = TextEditingController();
  /// Whether the password is hidden or not. This also controls
  /// the visible/invisible icon.
  bool passwordHidden = true;
  /// Used to display Firebase auth errors
  String formError = '';

  /// Create the sign up page.
  ///
  /// This consists of two text fields, one for the email and the
  /// other for the password. Both have some basic validation. Below
  /// them is a 'Submit' button that tries to create and login with
  /// a new account.
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: JustEatItAppBar.create(context),
      body: Form(
        key: formKey,
        child: Center(
          child: SizedBox(
            width: 350,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  child: const Icon(Icons.restaurant, size: 100),
                  padding: EdgeInsets.fromLTRB(0, size.height/8, 0, 30)
                ),
                const Text('Sign Up',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Divider(color: Colors.grey[300], height: 40),
                TextFormField(
                  autofocus: true,
                  autocorrect: false,
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    )
                  ),
                  validator: validateEmail
                ),
                const Divider(color: Colors.transparent, height: 30),
                TextFormField(
                  obscureText: passwordHidden,
                  enableSuggestions: false,
                  autocorrect: false,
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(passwordHidden ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                      onPressed: togglePasswordVisibility
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))
                  ),
                  validator: validatePassword
                ),
                const Divider(color: Colors.transparent, height: 20),
                ElevatedButton(
                  onPressed: handleSubmitPress,
                  child: Container(
                    width: 350,
                    padding: const EdgeInsets.all(10),
                    child: const Text('Submit',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16)
                    ),
                  )
                ),
                Container(
                  width: 350,
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: (formError.isEmpty ? 0 : 10)),
                  child: Text(formError, style: const TextStyle(color: Colors.red), textAlign: TextAlign.left),
                ),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                  const Flexible(child: Text('Already have an account?')),
                  Flexible(
                    child: TextButton(
                      onPressed: () => Navigator.popAndPushNamed(context, '/login'),
                      child: const Text('Log in',
                        style: TextStyle(decoration: TextDecoration.underline)
                      )
                    )
                  )
                ])
              ],
            ),
          ),
        )
      )
    );
  }

  /// Ensure that the given email is actually an email.
  String? validateEmail(String? email) {
    if (email == null || !isValidEmail(email)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  /// Return whether the given string is a valid email.
  bool isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(email);
  }

  /// Ensure that the given password is at least 8 characters long.
  String? validatePassword(String? password) {
   if (password == null || password.isEmpty) {
      return 'Please enter a password';
    } else if (password.length < 8) {
      return 'Please enter a password at least eight characters long';
    }
    return null;
  }

  // Make the password hidden if it's shown, and vice versa.
  void togglePasswordVisibility() {
    setState(() => passwordHidden = !passwordHidden);
  }

  // Handle the signup form submission. Check input validation, then
  // actually tries to create an account.
  void handleSubmitPress() async {
    if (formKey.currentState!.validate()) {
      try {
        await widget.auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        final user = widget.auth.currentUser;
        widget.store.collection('users').doc(user!.uid).set({'email': user.email, 'preferences': ''});
        Navigator.popAndPushNamed(context, '/preferences');
      } on FirebaseAuthException catch (e) {
        setState(() => handleFirebaseAuthError(e));
      }
    }
  }

  // Display a human-readable message corresponding to the given exception.
  void handleFirebaseAuthError(FirebaseAuthException e) {
    if (e.code == 'email-already-in-use') {
     formError = 'An account already exists for ${emailController.text}. Please try again with a different email.';
    } else if (e.code == 'invalid-email') {
     formError = 'Please enter a valid email.';
    } else if (e.code == 'operation-not-allowed') {
      formError = 'Not allowed.';
    } else if (e.code == 'weak-password') {
      formError = 'Please enter a stronger password. Try to include letters, numbers, and special characters.';
    } else {
      formError = 'An error occurred (${e.code}). Sorry about that!';
    }
  }
}