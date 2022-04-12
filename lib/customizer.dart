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
    
    //reference to the cuisine collection
    CollectionReference cuisine = FirebaseFirestore.instance.collection("cuisine");

    return Scaffold(
      appBar: JustEatItAppBar.create(context),
      //body of list view
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, int index) {
                return Container(
                  alignment: Alignment.center,
                  //color: const Color.fromARGB(255, 18, 119, 21),
                  height: 150,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 30),
                    ),
                    //when pressed, send data and move to reccomendation page
                    onPressed: () {
                      //does not update suggestion pool at the moment
                      Navigator.popAndPushNamed(context, '/restaurants');
                    },
                    child: FutureBuilder<DocumentSnapshot>(
                      future: cuisine.doc(index.toString()).get(),
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
                            "${data["name"]}", 
                            style: const TextStyle(
                              fontSize: 40,
                              color: Color.fromARGB(255, 18, 119, 21),
                              ),
                          );
                        }
                        return const Text("loading"); //appears while firestore is retrieving data
                      },
                    ), 
                  ),
                );
              },
              childCount: 4, //adjusts the current length of the list
              )
            )
        ],
      ),
    );
  }

}//class end