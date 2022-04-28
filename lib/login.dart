import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'appbar.dart';

// The login page.
class LoginPage extends StatefulWidget {
  final FirebaseAuth auth;

  const LoginPage({Key? key, required this.auth}) : super(key: key);

  @override
  LoginPageState createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  /// For form validation
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool passwordHidden = true;
  /// Used to display Firebase auth errors
  String formError = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: JustEatItAppBar.create(context, widget.auth),
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
                const Text('Log In',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Divider(color: Colors.grey[300], height: 40),
                TextFormField(
                  validator: validateEmail,
                  autofocus: true,
                  autocorrect: false,
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))
                  ),
                ),
                const Divider(color: Colors.transparent, height: 30),
                TextFormField(
                  validator: validatePassword,
                  obscureText: passwordHidden,
                  enableSuggestions: false,
                  autocorrect: false,
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(passwordHidden ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                        onPressed: () => setState(() {
                          passwordHidden = !passwordHidden;
                        }),
                      ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))
                  ),
                ),
                const Divider(color: Colors.transparent, height: 20),
                ElevatedButton(
                  onPressed: handleSubmitPress,
                  child: Container(
                    width: 350,
                    padding: const EdgeInsets.all(10),
                    child: const Text('Log In',
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
                    const Flexible(child: Text('Don\'t have an account?')),
                    Flexible(
                      child: TextButton(
                        onPressed: () => Navigator.popAndPushNamed(context, '/signup'),
                        child: const Text('Create one now!',
                          style: TextStyle(decoration: TextDecoration.underline)
                        )
                      ),
                    )
                  ]
                ),
              ],
            ),
          ),
        )
      )
    );
  }

  /// Ensure that the given email is present. We don't need to actually check that
  /// it's a valid email because Firebase will do that.
  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Please enter your email';
    } else {
      return null;
    }
  }

  /// Ensure that the given password is present.
  String? validatePassword(String? password) {
   if (password == null || password.isEmpty) {
      return 'Please enter a password';
    } else {
      return null;
    }
  }

  /// Check form validation, then try to sign in and redirect to the preferences page.
  /// If sign in fails, displays an error.
  void handleSubmitPress() async {
    if (formKey.currentState!.validate()) {
      try {
        await widget.auth.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        Navigator.popAndPushNamed(context, '/restaurants');
      } on FirebaseAuthException catch (e) {
        setState(() => handleFirebaseAuthError(e));
      }
    }
  }

  /// Display an appropriate message for the given error.
  /// Handles `invalid-email`, `user-disabled`, `user-not-found`, `wrong-password`,
  /// and `too-many-requests` nicely, and gives a vague message for other errors.
  void handleFirebaseAuthError(FirebaseAuthException e) {
    if (e.code == 'invalid-email') {
      formError = 'Looks like ${emailController.text} isn\'t a valid email. Please try again with a different email.';
    } else if (e.code == 'user-disabled') {
      formError = 'This account has been disabled. Contact the administrators if you feel there has been an error.';
    } else if (e.code == 'user-not-found' || e.code == 'wrong-password') {
      formError = 'Invalid email/password combination. Double check and try again.';
    } else if (e.code == 'too-many-requests') {
      formError = 'You have made too many requests. Please wait a few minutes before trying again.';
    } else {
      formError = 'An error occurred (${e.code}). Sorry about that.';
    }
  }
}