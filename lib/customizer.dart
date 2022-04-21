import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'appbar.dart';

//Globals

class CustomizerPage extends StatefulWidget {
  const CustomizerPage({ Key? key }) : super(key: key);

  @override
  State<CustomizerPage> createState() => _CustomizerPageState();
}

class _CustomizerPageState extends State<CustomizerPage> {
  //class globals
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  //helping functions

//build layout
  @override
  Widget build(BuildContext context) {

    //build globals
    final user = FirebaseAuth.instance.currentUser;
    
    //reference to the cuisine collection
    //CollectionReference cuisine = FirebaseFirestore.instance.collection("cuisine");
    //get the document reference for the user currently logged in
    
    //TODO: Add check for whether a valid user is signed in before changing preferences
    //TODO: When user logs out, clear preferences
    var userPref = FirebaseFirestore.instance.collection('users').doc(user?.uid);
    //var restNameList = ['chinese', 'japanese', 'mexican', 'mediteranian'];

    return Scaffold(
      appBar: JustEatItAppBar.create(context),
      //body of list view
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            //----------CHINESE----------
            Container(
              alignment: Alignment.center,
              height: 150,
              child: TextButton(
                onPressed: () {
                  //set user preference
                  var chin = ['chinese']; //needs to be of  List<String> type
                  userPref.update({'preferences': FieldValue.arrayUnion(chin)});
                  //userPref.set({'preferences': 'chinese'});
                  Navigator.popAndPushNamed(context, '/restaurants');
                },
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(
                    fontSize: 30,
                    color:Color.fromARGB(255, 18, 119, 21), 
                    ),
                ),
                child: const Text(
                  "Chinese", 
                ),
              ),
            ),
            //----------JAPANESE----------
            Container(
              alignment: Alignment.center,
              height: 150,
              child: TextButton(
                onPressed: () {
                  //set user preference
                  var jap = ['japanese'];
                  //userPref.
                  userPref.update({'preferences': FieldValue.arrayUnion(jap)});
                  //userPref.set({'preferences': 'japanese'});
                  Navigator.popAndPushNamed(context, '/restaurants');
                },
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(
                    fontSize: 30,
                    color:Color.fromARGB(255, 18, 119, 21), 
                    ),
                ),
                child: const Text(
                  "Japanese", 
                ),
              ),
            ),
            //----------MEXICAN----------
            Container(
              alignment: Alignment.center,
              height: 150,
              child: TextButton(
                onPressed: () {
                  //set user preference
                  var mex = ['mexican'];
                  userPref.update({'preferences': FieldValue.arrayUnion(mex)});
                  Navigator.popAndPushNamed(context, '/restaurants');
                },
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(
                    fontSize: 30,
                    color:Color.fromARGB(255, 18, 119, 21), 
                    ),
                ),
                child: const Text(
                  "Mexican", 
                ),
              ),
            ),
            //----------MEDITERANIAN----------
            Container(
              alignment: Alignment.center,
              height: 150,
              child: TextButton(
                onPressed: () {
                  //set user preference
                  var med = ['mediteranian'];
                  userPref.update({'preferences': FieldValue.arrayUnion(med)});
                  Navigator.popAndPushNamed(context, '/restaurants');
                },
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(
                    fontSize: 30,
                    color:Color.fromARGB(255, 18, 119, 21), 
                    ),
                ),
                child: const Text(
                  "Mediteranian", 
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}//class end