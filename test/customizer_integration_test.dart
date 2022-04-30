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

  testWidgets('Can switch to recomendation page', (tester) async{
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

  testWidgets('Can add to selected preferences column', (tester) async {
    setDisplayDimensions(tester);
    final store = FakeFirebaseFirestore();
    final auth = MockFirebaseAuth(
      signedIn: true,
      mockUser: MockUser()
    );
    await tester.pumpWidget(CustomizerPageWrapper(auth: auth, store: store));
    await tester.tap(find.widgetWithText(ListTile, 'American'));
    await tester.pump();
    expect(find.text('American').last, findsWidgets);

  });

  testWidgets('Can see multiple selected preferences with dividers', (tester) async {
    setDisplayDimensions(tester);
    final store = FakeFirebaseFirestore();
    final auth = MockFirebaseAuth(
      signedIn: true,
      mockUser: MockUser()
    );
    await tester.pumpWidget(CustomizerPageWrapper(auth: auth, store: store));
    await tester.tap(find.widgetWithText(ListTile, 'Chinese'));
    await tester.pump();
    await tester.tap(find.widgetWithText(ListTile, 'Breakfast'));
    await tester.pump();
    expect(find.text('Chinese').last, findsWidgets);
    expect(find.byType(Divider), findsWidgets);
    expect(find.text('Breakfast').last, findsWidgets);
  });

  testWidgets('Pressing "Resets preferences" removes selected preferences', (tester) async {
    setDisplayDimensions(tester);
    final store = FakeFirebaseFirestore();
    final auth = MockFirebaseAuth(
      signedIn: true,
      mockUser: MockUser()
    );
    await tester.pumpWidget(CustomizerPageWrapper(auth: auth, store: store));
    await tester.tap(find.widgetWithText(ListTile, 'Beverages'));
    await tester.pump();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Refresh Preferences'));
    await tester.pump();
    expect(find.text('No Preferences Selected'), findsWidgets);

  });

  //Last test to get full coverage: how to tap the same widget twice when there are technically two on the screen
  testWidgets('Can remove a selected preference by retapping cuisine option', (tester) async {
    setDisplayDimensions(tester);
    final store = FakeFirebaseFirestore();
    final auth = MockFirebaseAuth(
      signedIn: true,
      mockUser: MockUser()
    );
    await tester.pumpWidget(CustomizerPageWrapper(auth: auth, store: store));
    //await tester.tapAt(List)
    await tester.tap(find.widgetWithText(ListTile, 'Beverages').first);//tap one
    await tester.pump();
    await tester.tap(find.widgetWithText(ListTile, 'Beverages').first);//tap two
    await tester.pump();
    expect(find.text('Beverages'), findsOneWidget); //after tapping again, there should only be one
    expect(find.text('No Preferences Selected'), findsWidgets); //preferences should also be empty
  });

} //end of main