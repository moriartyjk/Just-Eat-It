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

  final _saved = <String> []; //list of selected preferences 

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
    var userPref = FirebaseFirestore.instance.collection('users').doc(user?.uid);

    return Scaffold(
      appBar: JustEatItAppBar.create(context),
      //body of list view
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //==========SELECTION VIEW==========
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: <Widget>[
                //----------CHINESE----------
                _buildSelection("Chinese", userPref, context),
                //----------JAPANESE----------
                _buildSelection("Japanese", userPref, context),
                //----------MEXICAN----------
                _buildSelection("Mexican", userPref, context),
                //----------MEDITERANIAN----------
                _buildSelection("Mediteranian", userPref, context),
                //----------BREAKFAST----------
                _buildSelection("Breakfast", userPref, context),
                //----------BEVERAGES----------
                _buildSelection("Beverages", userPref, context),
                //----------AMERICAN----------
                _buildSelection("American", userPref, context),
                //----------HEALTH----------
                _buildSelection("Health", userPref, context),
                //----------RESET PREFERENCES----------
                _clearPreferences(userPref, context),
              ],
            ),
          ),
          //==========SELECTED PREFERENCES VIEW==========
          Expanded(
            child: _saved.isNotEmpty //if preferences list is not empty, create a listveiw builder otherwise, show text
              ? _buildSelected(context) 
              : Container(
                alignment: Alignment.center,
                height: 150,
                child: const Text("No Preferences Selected"),
              ),
          ),
        ], //end of Row children
      ),
    );
  }

/*----------HELPER FUNCTIONS----------*/

  //Helper method to build each 
  Widget _buildSelection(String name,  DocumentReference<Map<String, dynamic>> userPref, BuildContext context){

    final alreadySaved = _saved.contains(name);

    //name -> restaurant name in upper case
    return ListTile(
      minVerticalPadding: 20,
      leading: Icon(
        alreadySaved ? Icons.circle : Icons.circle_outlined,
        color: Colors.amber.shade800,
        semanticLabel: alreadySaved ? 'Remove from Selected' : 'Select',
      ),
      title: Text(
        name,
        style: TextStyle(
          color: Colors.green.shade800,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
        setState(() {
          if(alreadySaved){
            _saved.remove(name);
            //add code here to update the users preference list in data base based on current _saved array
            //userPref.update({'preferences': _saved});
          } else{
            _saved.add(name);
            //add code here to update the users preference list in data base based on current _saved array
            //userPref.update({'preferences': _saved});
          }
          userPref.update({'preferences': _saved});
        });
      },
    );
  }

  //Widget that shows what has been selected
  Widget _buildSelected(BuildContext context){

    //return a buildable list that displays what has been favorited by the user
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(color: Colors.green.shade900),
      itemCount: _saved.length, //number of tiles equals length of preferences list
      itemBuilder: (context, int index) {
        return ListTile(
          title: Text(_saved.elementAt(index)),
        );
      }
    );
  }

  //Clear preferences
  Widget _clearPreferences(DocumentReference<Map<String, dynamic>> userPref, BuildContext context){

    //maybe turn this into a floating button

    return Container(
      alignment: Alignment.center,
      height: 200,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            //clear _saved
            removeAll();
            userPref.update({'preferences': []}); //set preferences to be an empty array
          });
          //clear _saved
          removeAll();
          userPref.update({'preferences': []}); //set preferences to be an empty array
        },
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(
            fontSize: 30,
            color:Color.fromARGB(255, 18, 119, 21), 
            ),
        ),
        child: const Text(
          "Reset Preferences",
        ),
      ),
    );
  }

  void removeAll(){
    while(_saved.isNotEmpty){
      _saved.removeAt(0); //remove the first index of the list until its empty
    }
  }

} //==========CustomizerPage END==========

