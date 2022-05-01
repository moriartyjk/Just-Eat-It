import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'appbar.dart';
import 'recommend.dart';

class RestaurantListPage extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore store;

  const RestaurantListPage({ Key? key, required this.auth, required this.store }) : super(key: key);

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  @override
  Widget build(BuildContext context) {
    var restaurants = widget.store.collection("restaurants");

    return Scaffold(
      appBar: JustEatItAppBar.create(context, widget.auth),
      //body of list view
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            color: Colors.green.shade50,
            height: 80,
            width: MediaQuery.of(context).size.width,
            child: Text("Restaurant List",
              style: TextStyle(
                    color: Colors.green.shade800,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Expanded(
            child: FractionallySizedBox(
              widthFactor: 0.8,
              child: StreamBuilder<QuerySnapshot>(
                stream: restaurants.snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Text('Loading...');
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (_, index) {
                      final data = snapshot.data!.docs[index];
                      return ListTile(
                        title: Text(
                          '${data['name']} (${data['location']})',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.green.shade900,
                          ),
                        ),
                        subtitle: Text(
                          data['description'],
                          textAlign: TextAlign.justify,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            color: Colors.green.shade50,
            height: 75,
            width: MediaQuery.of(context).size.width,
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
    );
  }
} // RESTAURANTLISTPAGE CLASS END