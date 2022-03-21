import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'dart:math';

// Global Variables
int randIndex = 0;


class RestaurantsPage extends StatefulWidget {
  const RestaurantsPage({ Key? key }) : super(key: key);

  @override
  State<RestaurantsPage> createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage> {

  // Create the restaurant suggestion page
  
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void _randGen(){
    setState(() {
      randIndex = Random().nextInt(37); // random num [0, 37)
    });
  }

  @override
  Widget build(BuildContext context) {

    CollectionReference restaurants = FirebaseFirestore.instance.collection("restaurants");

    String docID = randIndex.toString(); //cast index to string to access documents in database

    return Scaffold(
      appBar: AppBar(
        title: Text("Restaurant Suggestions"),
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
      ),
    );   
  }
}