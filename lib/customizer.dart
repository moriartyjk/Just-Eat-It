import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'appbar.dart';

//Globals

/// a wrapper class to hold all the cuisine values
class Cuisines {
  static const american = 'American';
  static const beverages = 'Beverages';
  static const breakfast = 'Breakfast';
  static const chinese = 'Chinese';
  static const health = 'Health';
  static const japanese = 'Japanese';
  static const mediterranean = 'Mediterranean';
  static const mexican = 'Mexican';
  static const thai = 'Thai';

  static const all = [american, beverages, breakfast, chinese, health, japanese, mediterranean, mexican, thai];
}

class CustomizerPage extends StatefulWidget {
  final FirebaseAuth auth;
  const CustomizerPage({ Key? key, required this.auth }) : super(key: key);

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
    final user = widget.auth.currentUser;

    //reference to the cuisine collection
    //CollectionReference cuisine = FirebaseFirestore.instance.collection("cuisine");
    //get the document reference for the user currently logged in

    //TODO: Add check for whether a valid user is signed in before changing preferences
    var userPref = FirebaseFirestore.instance.collection('users').doc(user?.uid);

    return Scaffold(
      appBar: JustEatItAppBar.create(context, widget.auth),
      //body of list view
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start, //press to top of page
        children: [
          Container( //title header
            height: 100,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Cuisine Options",
                  style: TextStyle(
                    color: Colors.green.shade800,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                //VerticalDivider(),
                Text("Applied Preferences",
                  style: TextStyle(
                    color: Colors.green.shade800,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]
            ),
          ),
          SizedBox( //turn this into body
            height: MediaQuery.of(context).size.height-260, //account for containers aboce, below, and app bar
            width:  MediaQuery.of(context).size.width,
            //color: Colors.yellow.shade100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                //Icon(Icons.star, color: Colors.red,), //turning this into cuisine options side
                Expanded(
                  flex: 1,
                  child: ListView(
                    padding: const EdgeInsets.all(18),
                    children: <Widget>[
                      //----------AMERICAN----------
                      _buildSelection(Cuisines.american, userPref, context),
                      const Divider(),
                      //----------BEVERAGES----------
                      _buildSelection(Cuisines.beverages, userPref, context),
                      const Divider(),
                      //----------BREAKFAST----------
                      _buildSelection(Cuisines.breakfast, userPref, context),
                      const Divider(),
                      //----------CHINESE----------
                      _buildSelection(Cuisines.chinese, userPref, context),
                      const Divider(),
                      //----------HEALTH----------
                      _buildSelection(Cuisines.health, userPref, context),
                      const Divider(),
                      //----------JAPANESE----------
                      _buildSelection(Cuisines.japanese, userPref, context),
                      const Divider(),
                      //----------MEDITERANIAN----------
                      _buildSelection(Cuisines.mediterranean, userPref, context),
                      const Divider(),
                      //----------MEXICAN----------
                      _buildSelection(Cuisines.mexican, userPref, context),
                      const Divider(),
                      //----------THAI----------
                      _buildSelection(Cuisines.thai, userPref, context),
                    ],
                  ),
                ),
              //const VerticalDivider(),
                //const Icon(Icons.star, color: Colors.red,),
               Expanded(
                child: _saved.isNotEmpty //if preferences list is not empty, create a listveiw builder otherwise, show text
                  ? _buildSelected(context)
                  : Container(
                    alignment: Alignment.center,
                    height: 150,
                    child: const Text("No Preferences Selected"),
                    //color: Colors.yellow.shade100,
                  ),
              ),
              ],
            ),
          ),
          Container( //turn this into reset and go to reccomnend buttons
            height: 100,
            width:  MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /*Refresh preferences button*/
                Container(
                  //alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(20),
                  child: _clearPreferences(userPref, context),
                ),
                //const VerticalDivider(),
                /*Go to reccommendation page button*/
                Container(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    child: const Text(
                      "Get Recommendation",
                    ),
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context, '/restaurants', (_) => false);
                    },
                  ),
                ), 
              ],
            ),
          ),
        ],
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
      tileColor: Colors.green.shade100,
      selectedTileColor: Colors.green,
      //leading: Icon(
      //  alreadySaved ? Icons.star : Icons.star_border,
      //  color: Colors.amber.shade800,
      //  semanticLabel: alreadySaved ? 'Remove from Selected' : 'Select',
      //),
      title: Text(
        name, //name of restaurant
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
          } else{
            _saved.add(name);
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
      padding: const EdgeInsets.all(15),
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

    return ElevatedButton(
      child: const Text(
        "Refresh Preferences",
      ),
      onPressed: () {
        setState(() {
          removeAll();
          userPref.update({'preferences': []}); //set preferences to be an empty array
        });
      }
    );
  }

  //helper method that removes all
  void removeAll(){
    while(_saved.isNotEmpty){
      _saved.removeAt(0); //remove the first index of the list until its empty
    }
  }

} //==========CustomizerPage Class END==========

