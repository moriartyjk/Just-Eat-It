import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:justeatit/just_eat_it.dart';
import 'package:justeatit/restaurants.dart';

import 'helpers.dart';
import 'recommend_unit_test.dart';

class RestaurantsPageWrapper extends StatelessWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore store;

  const RestaurantsPageWrapper({Key? key, required this.auth, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RestaurantsPage(auth: auth, store: store),
    );
  }
}

void main() {
  setUpAll(() async {
    setupAllFirebaseMocks();
    TestWidgetsFlutterBinding.ensureInitialized();
    await JustEatIt.initFirebase();
  });

  testWidgets('redirects to login if not logged in', (tester) async {
    setDisplayDimensions(tester);
    final store = FakeFirebaseFirestore();
    final auth = MockFirebaseAuth();
    await tester.pumpWidget(RestaurantsPageWrapper(auth: auth, store: store));
    expect(find.text('Log In'), findsWidgets);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });

  testWidgets('Restaurant recommendation page has the correct elements', (tester) async {
    setDisplayDimensions(tester);
    final store = FakeFirebaseFirestore();
    final auth = MockFirebaseAuth(
      signedIn: true,
      mockUser: MockUser()
    );
    await tester.pumpWidget(RestaurantsPageWrapper(auth: auth, store: store));
    expect(find.text('Go!'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Press Go! to get a recommendation!'), 100);
  });

  testWidgets('Pressing the up button scrolls up', (tester) async {
    setDisplayDimensions(tester);
    final store = FakeFirebaseFirestore();
    final auth = MockFirebaseAuth(
      signedIn: true,
      mockUser: MockUser()
    );
    await tester.pumpWidget(RestaurantsPageWrapper(auth: auth, store: store));
    await tester.scrollUntilVisible(find.text('Press Go! to get a recommendation!'), 1000);
    expect(find.text('Go!'), findsNothing);
    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    expect(find.text('Go!'), findsOneWidget);
  });

  testWidgets('Pressing Go! gives a recommendation', (tester) async {
    setDisplayDimensions(tester);
    RestaurantsPage.ignoreVideoProgress = true;
    final store = FakeFirebaseFirestore();
    final auth = MockFirebaseAuth();
    final chipotle = {
      'description': 'Chipotle serves burritos.',
      'dietary': ['gluten-free', 'vegan' ],
      'name': 'Chipotle',
      'cuisine': 'Mexican',
      'hours': [ '10:45 AM - 10:00 PM', '10:45 AM - 10:00 PM', '10:45 AM - 10:00 PM', '10:45 AM - 10:0 0PM', '10:45 AM - 10:00 PM', '10:45 AM - 10:00 PM', '10:45 AM - 10:00 PM' ],
      'location': 'Johnson Center'
    };
    final starbucks = {
      'location': 'Northern Neck',
      'description': 'Starbucks serves coffee.',
      'hours': [ '7:00 AM - 9:00 PM', '7:00 AM - 9:00 PM', '7:00 AM - 9:00 PM', '7:00 AM - 9:00 PM', '7:00 AM - 9:00 PM', '9:00 AM - 9:00 PM', '9:00 AM - 9:00 PM' ],
      'name': 'Starbucks',
      'cuisine': 'Beverages',
      'dietary': [ 'dairy-free', 'gluten-free', 'vegan' ],
    };
    addUserWithPrefs(store, auth, 'dimaggio@yankees.com', []);
    addRestaurant(store, chipotle);
    addRestaurant(store, starbucks);
    await tester.pumpWidget(RestaurantsPageWrapper(auth: auth, store: store));
    await tester.tap(find.byType(ElevatedButton).first);
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    final chipotleFirst = find.text(chipotle['name']!.toString()).evaluate().isNotEmpty;
    if (chipotleFirst) {
      expect(find.text(chipotle['description']!.toString()), findsOneWidget);
      expect(find.text(chipotle['location']!.toString()), findsOneWidget);
    } else {
      expect(find.text(starbucks['name']!.toString()), findsOneWidget);
      expect(find.text(starbucks['description']!.toString()), findsOneWidget);
      expect(find.text(starbucks['location']!.toString()), findsOneWidget);
    }
    await tester.tap(find.byType(IconButton).last);
    await tester.tap(find.text('Something else, please'));
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    if (chipotleFirst) {
      expect(find.text(starbucks['name']!.toString()), findsOneWidget);
      expect(find.text(starbucks['description']!.toString()), findsOneWidget);
      expect(find.text(starbucks['location']!.toString()), findsOneWidget);
    } else {
      expect(find.text(chipotle['name']!.toString()), findsOneWidget);
      expect(find.text(chipotle['description']!.toString()), findsOneWidget);
      expect(find.text(chipotle['location']!.toString()), findsOneWidget);
    }
    RestaurantsPage.ignoreVideoProgress = false;
  });
}
