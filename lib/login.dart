import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// The login page.
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

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
      appBar: AppBar(
        title: const Text('Log In To Your Account'),
        centerTitle: true,
      ),
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
                  autofocus: true,
                  autocorrect: false,
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    )
                  ),
                  validator: (email) {
                    if (email == null || email.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
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
                        onPressed: () => setState(() {
                          passwordHidden = !passwordHidden;
                        }),
                      ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))
                  ),
                  validator: (password) {
                    if (password == null || password.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
                const Divider(color: Colors.transparent, height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text,
                        );
                        Navigator.popAndPushNamed(context, '/restaurants');
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'invalid-email') {
                          setState(() => formError = 'Looks like ${emailController.text} isn\'t a valid email. Please try again with a different email.');
                        } else if (e.code == 'user-disabled') {
                          setState(() => formError = 'This account has been disabled. Contact the administrators if you feel there has been an error.');
                        } else if (e.code == 'user-not-found' || e.code == 'wrong-password') {
                          setState(() => formError = 'Invalid email/password combination. Double check and try again.');
                        } else if (e.code == 'too-many-requests') {
                          setState(() => formError = 'You have made too many requests. Please wait a few minutes before trying again.');
                        } else {
                          setState(() => formError = e.code);
                        }
                      } catch(e) {
                        setState(() => formError = 'An error occurred. Sorry about that.');
                      }
                    }
                  },
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
                Row(children: [
                  const Text('Don\'t have an account?'),
                  TextButton(
                    onPressed: () => Navigator.popAndPushNamed(context, '/signup'),
                    child: const Text('Create one now!',
                      style: TextStyle(decoration: TextDecoration.underline)
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
}