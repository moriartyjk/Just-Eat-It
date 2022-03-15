import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'dart:math';

int randIndex = 0; //global index

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
        primarySwatch: Colors.green, //figure out better green
      ),
      home: const MyHomePage(title: 'Just Eat It'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void _randGen(){
    //allows for realtime update of randIndex
    setState(() {
      randIndex = Random().nextInt(37); // random num [0, 37)
    });
  }
  @override
  Widget build(BuildContext context) {

    CollectionReference restaurants = FirebaseFirestore.instance.collection("restaurants");

    String docID = randIndex.toString(); //cast index to string because documents are stored by "numerical" indexes
    //print("Document Id: $docID");
  
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        //This is based on implementation from Flutter docs in https://firebase.flutter.dev/docs/firestore/usage/
        child: FutureBuilder<DocumentSnapshot>(
          future: restaurants.doc(docID).get(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if(snapshot.hasError){
              return const Text("Something went wrong");
            }

            if(snapshot.hasData && !snapshot.data!.exists){
              return const Text("Document does not exist",);
            }

            if(snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
              return Text(
                "Document Id: $docID\nName: ${data["name"]}", 
                style: const TextStyle(fontSize: 40),
              );
            }
            return const Text("loading"); //appears while firestore is retrieving data
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _randGen, //trigger random number generation
        tooltip: 'Retry',
        child: const Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}