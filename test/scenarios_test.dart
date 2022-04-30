import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:justeatit/just_eat_it.dart';
import 'package:justeatit/restaurants.dart';

import 'helpers.dart';
import 'recommend_unit_test.dart';

void main() {
  setUpAll(() async {
    setupAllFirebaseMocks();
    RestaurantsPage.ignoreVideoProgress = true;
    await JustEatIt.initFirebase();
  });

  testWidgets('Customer signs up, edits preferences, and gets a recommendation', (tester) async {
    setDisplayDimensions(tester);
    final auth = MockFirebaseAuth(signedIn: false);
    final store = FakeFirebaseFirestore();
    final starbucks = {
      'location': 'Northern Neck',
      'description': 'Starbucks serves coffee.',
      'hours': [ '7:00 AM - 9:00 PM', '7:00 AM - 9:00 PM', '7:00 AM - 9:00 PM', '7:00 AM - 9:00 PM', '7:00 AM - 9:00 PM', '9:00 AM - 9:00 PM', '9:00 AM - 9:00 PM' ],
      'name': 'Starbucks',
      'cuisine': 'Beverages',
      'dietary': [ 'dairy-free', 'gluten-free', 'vegan' ],
    };
    await addRestaurant(store, starbucks);
    await tester.pumpWidget(JustEatIt(auth: auth, store: store));
    await tester.tap(find.text('Log In'));
    await tester.pumpAndSettle();
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    await tester.tap(find.text('Create one now!'));
    await tester.pumpAndSettle();
    expect(find.text('Sign Up'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'mickey.mantle@yankees.com');
    await tester.enterText(find.byType(TextField).last, 'test1234');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Submit'));
    await tester.pumpAndSettle();
    expect(auth.currentUser, isNotNull);
    expect(auth.currentUser!.email, equals('mickey.mantle@yankees.com'));
    await tester.tap(find.text('Options'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('See All Restaurants'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Options'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cuisine Preferences'));
    await tester.pumpAndSettle();
    expect(find.text('Cuisine Options'), findsOneWidget);
    await tester.tap(find.text('Beverages'));
    await tester.pumpAndSettle();
    expect(find.text('Beverages'), findsNWidgets(2));
    await tester.tap(find.text('Get Recommendation'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Go!'));
    await tester.pumpAndSettle();
    expect(find.text('Starbucks'), findsWidgets);
  });

   testWidgets('Customer logs in, gets a recommendation, then gets another recommendation', (tester) async {
    setDisplayDimensions(tester);
    final auth = MockFirebaseAuth(
      mockUser: MockUser(email: 'mickey.mantle@yankees.com')
    );
    final store = FakeFirebaseFirestore();
    final starbucks = {
      'location': 'Northern Neck',
      'description': 'Starbucks serves coffee.',
      'hours': [ '7:00 AM - 9:00 PM', '7:00 AM - 9:00 PM', '7:00 AM - 9:00 PM', '7:00 AM - 9:00 PM', '7:00 AM - 9:00 PM', '9:00 AM - 9:00 PM', '9:00 AM - 9:00 PM' ],
      'name': 'Starbucks',
      'cuisine': 'Beverages',
      'dietary': [ 'dairy-free', 'gluten-free', 'vegan' ],
    };
    final chipotle = {
      'description': 'Chipotle serves burritos.',
      'dietary': ['gluten-free', 'vegan' ],
      'name': 'Chipotle',
      'cuisine': 'Mexican',
      'hours': [ '10:45 AM - 10:00 PM', '10:45 AM - 10:00 PM', '10:45 AM - 10:00 PM', '10:45 AM - 10:0 0PM', '10:45 AM - 10:00 PM', '10:45 AM - 10:00 PM', '10:45 AM - 10:00 PM' ],
      'location': 'Johnson Center'
    };
    await addRestaurant(store, starbucks);
    await addRestaurant(store, chipotle);
    await tester.pumpWidget(JustEatIt(auth: auth, store: store));
    await tester.tap(find.text('Log In'));
    await tester.pumpAndSettle();
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'mickey.mantle@yankees.com');
    await tester.enterText(find.byType(TextField).last, 'test1234');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Log In'));
    await tester.pumpAndSettle();
    expect(auth.currentUser, isNotNull);
    expect(auth.currentUser!.email, equals('mickey.mantle@yankees.com'));
    await tester.tap(find.text('Go!'));
    await tester.pumpAndSettle();
    final chipotleFirst = find.text(chipotle['name']!.toString()).evaluate().isNotEmpty;
    if (chipotleFirst) {
      expect(find.text(chipotle['name']!.toString()), findsOneWidget);
    }
    await tester.tap(find.text('Something else, please'));
    await tester.pumpAndSettle();
    if (chipotleFirst) {
      expect(find.text(starbucks['name']!.toString()), findsOneWidget);
    } else {
      expect(find.text(chipotle['name']!.toString()), findsOneWidget);
    }
  });
}
