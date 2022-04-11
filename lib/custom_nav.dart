import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'appbar.dart';

class CustomizerNav extends StatefulWidget {
  const CustomizerNav({ Key? key }) : super(key: key);

  @override
  State<CustomizerNav> createState() => _CustomizerNavState();
}

class _CustomizerNavState extends State<CustomizerNav> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: JustEatItAppBar.create(context),
      body: Center(
        child: SizedBox(
          width: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //add customization to reccomendations
              Padding(
                padding: EdgeInsets.fromLTRB(0, size.height/8, 0, 30),
                  child: ElevatedButton(
                    child: const Text("Customize Selection",
                    style: TextStyle(fontSize: 25),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green.shade900,
                      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                      shadowColor: Colors.black
                    ),
                    onPressed: () {
                      Navigator.popAndPushNamed(context, '/preferences');
                    },
                  ),
              ),
              //ability to view full list of restaurants
              Padding(
                padding: EdgeInsets.fromLTRB(0, size.height/8, 0, 30),
                child: ElevatedButton(
                  child: const Text("View All Restaurants",
                  style: TextStyle(fontSize: 25, ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green.shade900,
                    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                    shadowColor: Colors.black
                  ),
                  onPressed: () {
                    Navigator.popAndPushNamed(context, '/list');
                  },
                ),
              ),
              //skip customization and go straight to preferences
              Padding(
                padding: EdgeInsets.fromLTRB(0, size.height/8, 0, 30),
                child: ElevatedButton(
                  child: const Text("Get Recommendation",
                  style: TextStyle(fontSize: 25, ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green.shade900,
                    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                    shadowColor: Colors.black
                  ),
                  onPressed: () {
                    Navigator.popAndPushNamed(context, '/restaurants');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}