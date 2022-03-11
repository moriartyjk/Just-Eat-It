import 'package:flutter/material.dart';

// The sign up page.
class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

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

  /// Create the sign up page.
  ///
  /// This consists of two text fields, one for the email and the
  /// other for the password. Both have some basic validation. Below
  /// them is a 'Submit' button that tries to create and login with
  /// a new account.
  ///
  /// Maybe in the future we'll have Google/Facebook/etc login too,
  /// it seems pretty easy with Firebase.
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create an Account'),
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
                  validator: (email) {
                    if (email == null || !isValidEmail(email)) {
                      return 'Please enter a valid email';
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
                    } else if (password.length < 8) {
                      return 'Please enter a password more than eight letters long';
                    }
                    return null;
                  },
                ),
                const Divider(color: Colors.transparent, height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // TODO: actually create the account and log in
                      print("email: ${emailController.text}, password: ${passwordController.text}");
                    }
                  },
                  child: Container(
                    width: 350,
                    padding: const EdgeInsets.all(10),
                    child: const Text('Submit',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16)
                    ),
                  )
                ),
                const Divider(color: Colors.transparent, height: 10),
                Row(children: [
                  const Text('Already have an account?'),
                  TextButton(
                    onPressed: () => Navigator.popAndPushNamed(context, '/login'),
                    child: const Text('Log in',
                      style: TextStyle(decoration: TextDecoration.underline)
                    )
                  )
                ]),
                Divider(color: Colors.grey[300], height: 40),
              ],
            ),
          ),
        )
      )
    );
  }

  /// Return whether the given string is a valid email.
  bool isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(email);
  }
}