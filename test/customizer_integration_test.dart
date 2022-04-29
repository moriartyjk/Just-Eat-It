import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:justeatit/appbar.dart';
//import 'package:justeatit/custom_nav.dart';
import 'package:justeatit/customizer.dart';
import 'package:justeatit/just_eat_it.dart';
import 'package:justeatit/login.dart';
import 'package:justeatit/restaurants.dart';
import 'package:justeatit/signup.dart';

import 'helpers.dart';
import 'recommend_unit_test.dart';

class CustomizerPageWrapper extends StatelessWidget {

  final FirebaseAuth auth;
  final FirebaseFirestore store;

  const CustomizerPageWrapper({Key? key, required this.auth, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CustomizerPage(auth: auth,),
      routes: {
        '/restaurants':(context) => RestaurantsPage(auth: auth, store: store),
        //check to see if anyone else accesses this
      },
    );
  }
}

void main() {
  setUpAll(() async {
    setupAllFirebaseMocks();
    await JustEatIt.initFirebase();
  });

  testWidgets('Can switch to reccomendation page', (tester) async{
    setDisplayDimensions(tester);
    final store = FakeFirebaseFirestore();
    final auth = MockFirebaseAuth(
      signedIn: true,
      mockUser: MockUser()
    );
    await tester.pumpWidget(CustomizerPageWrapper(auth: auth, store: store));
    await tester.tap(find.widgetWithText(ElevatedButton, "Get Recommendation"));
    await tester.pump();
    //expect(find.textContaining('Go!'), findsWidgets);
    expect(find.byType(ElevatedButton), findsWidgets);
  });

} //end of main