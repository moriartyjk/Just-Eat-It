import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'custom_nav.dart';
import 'customizer.dart';
import 'restaurant_list.dart';
import 'appbar.dart';
import 'restaurants.dart';
import 'firebase_options.dart';
import 'signup.dart';
import 'login.dart';

class JustEatIt extends StatelessWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore store;

  const JustEatIt({Key? key, required this.auth, required this.store}) : super(key: key);

  static Future initFirebase() {
    return Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Widget build(BuildContext context) {
    const darkGreen = MaterialColor(
      0xFF1B5E20,
      <int, Color>{
        50: Color(0xFF66BB6A),
        100: Color(0xFF4CAF50),
        200: Color(0xFF43A047),
        300: Color(0xFF388E3C),
        400: Color(0xFF2E7D32),
        500: Color(0xFF1B5E20),
        600: Color(0xFF165814),
        700: Color(0xFF10500E),
        800: Color(0xFF10500E),
        900: Color(0xFF10500E),
      },
    );

    return MaterialApp(
      title: 'Just Eat It',
      theme: ThemeData(primarySwatch: darkGreen),
      routes: {
        '/': (context) => MyHomePage(title: 'Just Eat It', auth: auth),
        '/signup': (context) => SignupPage(auth: auth, store: store),
        '/login': (context) => LoginPage(auth: auth),
        '/restaurants': (context) => RestaurantsPage(auth: auth, store: store),
        '/preferences': (context) => CustomizerPage(auth: auth),
        '/list':        (context) => RestaurantListPage(auth: auth, store: store),
        '/pref_nav':    (context) => CustomizerNav(auth: auth),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final FirebaseAuth auth;
  const MyHomePage({Key? key, required this.title, required this.auth}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /*
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: JustEatItAppBar.create(context, widget.auth),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Welcome to Just Eat It!",
              style: TextStyle(
                fontSize: 40,
                color: Color.fromARGB(255, 18, 119, 21)),
              ),
            /*TextButton(onPressed: () => {
              Navigator.pushNamed(context, '/signup')
            }, child: const Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 30,
                  color: Color.fromARGB(255, 18, 119, 21),
                ),
              )
              ),*/
            TextButton(onPressed: () => {
              Navigator.pushNamed(context, '/login')
            }, child: const Text(
              "Log in",
              style: TextStyle(
                  fontSize: 30,
                  color: Color.fromARGB(255, 18, 119, 21),
                ),
              )
              ),
            /*TextButton(onPressed: () => {
              Navigator.pushNamed(context, '/restaurants')
            }, child: const Text(
                "Get Suggestion!",
                style: TextStyle(
                  fontSize: 30,
                  color: Color.fromARGB(255, 18, 119, 21),
                ),
              )
              ),
             TextButton(onPressed: () => {
              Navigator.pushNamed(context, '/list')
            }, child: const Text(
                "View Full Restaurant Selection",
                style: TextStyle(
                  fontSize: 30,
                  color: Color.fromARGB(255, 18, 119, 21),
                ),
                )
              ),*/
            TextButton(onPressed: () => {
              FirebaseAuth.instance.signOut()
            }, child: const Text(
                "Log out",
                style: TextStyle(
                  fontSize: 30,
                  color: Color.fromARGB(255, 18, 119, 21),
                ),
                )
              ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
