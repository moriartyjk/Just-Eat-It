import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'dart:math';

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

  @override
  Widget build(BuildContext context) {

    //build globals
    CollectionReference restaurants = FirebaseFirestore.instance.collection("restaurants");

    return Scaffold(
      appBar: AppBar(
        title: const Text('Selection Customization'),
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions(){
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, i) {
        if(i.isOdd){
          return const Divider();
        }


        return _buildRow();
      },
    );
  }

  //This is where the restaurant suggestions are pulled from
  Widget _buildRow(){
    return const ListTile(
      title: Text("Tile"),
      trailing: Icon(
        Icons.favorite,
        color: Colors.red,
        semanticLabel: 'Favorited',
      ),
    );

  }
}