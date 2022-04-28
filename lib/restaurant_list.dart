import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'appbar.dart';

class RestaurantListPage extends StatefulWidget {
  final FirebaseAuth auth;

  const RestaurantListPage({ Key? key, required this.auth }) : super(key: key);

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {

    CollectionReference restaurants = FirebaseFirestore.instance.collection("restaurants");
    return Scaffold(
      appBar: JustEatItAppBar.create(context, widget.auth),
      //body of list view
        //created a custom scrolling list with adjustable length
      body: Center(
        child: SizedBox(
          width: 1000,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, int index) {
                    return Container(
                      alignment: Alignment.center,
                      //color: Colors.yellow.shade700,
                      height: 150,
                      child: FutureBuilder<DocumentSnapshot>(
                        future: restaurants.doc(index.toString()).get(),
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
                              "${data["name"]} - ${data["location"]}", 
                              style: TextStyle(
                                fontSize: 30, 
                                color: Colors.green.shade900,
                              ),
                            );
                          }
                          return const Text("loading"); //appears while firestore is retrieving data
                        },
                      ),
                    );
                  },
                  childCount: 25, //adjusts the current length of the list
                  )
                )
            ],
          ),
        ),
        
        
      ),
      
    );
  }
}