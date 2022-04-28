import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:justeatit/appbar.dart';
import 'package:justeatit/custom_nav.dart';
import 'package:justeatit/customizer.dart';
import 'package:justeatit/just_eat_it.dart';
import 'package:justeatit/login.dart';
import 'package:justeatit/restaurant_list.dart';
import 'package:justeatit/signup.dart';

import 'helpers.dart';
import 'restaurant_unit_test.dart';

class AppBarWrapper extends StatelessWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore store;

  AppBarWrapper({Key? key, required this.auth, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: JustEatItAppBar(auth: auth)),
      routes: {
         '/pref_nav': (context) => CustomizerNav(auth: auth),
         '/preferences': (context) => CustomizerPage(auth: auth),         
         '/login' : (context) => LoginPage(auth : auth),
         '/signup': (context) => SignupPage(auth: auth, store: store),
         '/about' : (context) => LoginPage(auth : auth),
         '/list':        (context) => RestaurantListPage(auth: auth, store: store),
      },
    );
  }
}

void main() {
  setUpAll(() async {
    setupAllFirebaseMocks();
    await JustEatIt.initFirebase();
  });

   testWidgets('Appbar allows you login and check the restaurant list', (tester) async {
    setDisplayDimensions(tester);
    MockUser test = MockUser(email :'jonny@jonny.com');
    final jonny = MockFirebaseAuth(signedIn : true, mockUser : test);
    final store = FakeFirebaseFirestore();
    await addRestaurant(store, {
          'name': 'Chipotle',
          'location': '123 Main Street',
          'hours': ['10 AM - 10 PM'],
          'dietary': [],
          'cuisine': 'Mexican',
          'description': 'Mexican food.'    
          });
    await tester.pumpWidget(AppBarWrapper(auth: jonny ,store: store));
    expect(find.text('Just Eat It!'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);
    expect(find.text('Options'), findsOneWidget);
    expect(find.text('Log Out'), findsOneWidget);
    await tester.tap(find.text('Options'));
    await tester.pumpAndSettle(Duration(milliseconds : 100));
    await tester.tap(find.text("See All Restaurants"));
    await tester.pumpAndSettle(Duration(milliseconds : 100)); 
    await tester.idle();
    await tester.pump(Duration(milliseconds : 10000)); 

    // expect (find.text("Chipotle - 123 Main Street"), findsOneWidget); 
    });
}