import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:justeatit/appbar.dart';
import 'package:justeatit/customizer.dart';
import 'package:justeatit/just_eat_it.dart';
import 'package:justeatit/login.dart';
import 'package:justeatit/restaurants.dart';
import 'package:justeatit/signup.dart';

import 'helpers.dart';
import 'recommend_unit_test.dart';

class JustEatItWrapper extends StatelessWidget {

  final FirebaseAuth auth;
  final FirebaseFirestore store;

  const JustEatItWrapper({Key? key, required this.auth, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: JustEatIt(auth: auth, store: store,),
      routes: {
        '/login' : (context) => LoginPage(auth: auth),
        '/signup' :(context) => SignupPage(auth: auth, store: store),
      },
    );
  }
}
void main() {
  setUpAll(() async {
    setupAllFirebaseMocks();
    await JustEatIt.initFirebase();
  });
  
  testWidgets('Navigate to login page', (tester) async{
    setDisplayDimensions(tester);
    final store = FakeFirebaseFirestore();
    final auth = MockFirebaseAuth(
      signedIn: true,
      mockUser: MockUser()
    );
    await tester.pumpWidget(JustEatItWrapper(auth: auth, store: store));
    await tester.tap(find.widgetWithText(ElevatedButton, 'Lets Eat!'));
    await tester.pumpAndSettle();
    expect(find.text('Log In').first, findsWidgets);
  });

  testWidgets('Navigate to sign in page', (tester) async {
     setDisplayDimensions(tester);
    final store = FakeFirebaseFirestore();
    final auth = MockFirebaseAuth(
      signedIn: true,
      mockUser: MockUser()
    );
    await tester.pumpWidget(JustEatItWrapper(auth: auth, store: store));
    await tester.tap(find.widgetWithText(ElevatedButton, 'Create Account'));
    await tester.pumpAndSettle();
    expect(find.text('Sign Up').first, findsWidgets);

  });
}
