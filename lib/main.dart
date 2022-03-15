import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'dart:math';

Map<String, dynamic> doc = {};
//CollectionReference<Map<String, dynamic>> col = {};
//Map<int, QueryDocumentSnapshot<Map<String, dynamic>>> docs = {};
int randIndex = 0;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  try {
    UserCredential cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: "user@example.com",
      password: "***"
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
  }
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  doc = (await firestore.collection("restaurants").get()).docs.first.data();
  //doc = (await firestore.collection("restaurants").get()).docs.elementAt(randIndex).data();
  //docs = (await firestore.collection("restaurants").get()).docs.asMap();
  //doc = (await firestore.collection("restaurants").get()).docs.elementAt(35).data();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Just Eat It',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green, //figure out better green
      ),
      home: const MyHomePage(title: 'Just Eat It'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //int _counter = 0;

  //int _randIndex = 0;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

    /*
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

  void _getRandIndex(){
    setState(() {
      randIndex = Random().nextInt(30); //random number [0, 37]
      //print(randIndex);
      _getRestaurant();
    });
  }

  void _getRestaurant() async{
    doc = (await firestore.collection("restaurants").get()).docs.elementAt(randIndex).data(); 
  }

  @override
  Widget build(BuildContext context) {

    String name = doc["name"];
    //String location = doc["location"];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$randIndex',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text("Name: $name"),
            //Text("Location: $location"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getRandIndex, //trigger random number generation
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}