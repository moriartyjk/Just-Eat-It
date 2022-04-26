import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:justeatit/recommend.dart';

Future<DocumentSnapshot<Map<String, dynamic>>> addRestaurant(FirebaseFirestore firestore, Map<String, dynamic> data) async {
  return await (await firestore.collection('restaurants').add(data)).get();
}

Future<User> addUserWithPrefs(FirebaseFirestore store, FirebaseAuth auth, String email, List<String> preferences) async {
  var user = (await auth.createUserWithEmailAndPassword(email: email, password: '1234')).user;
  if (user == null) {
    throw FirebaseAuthException(code: 'fail');
  }

  await store.collection('users').doc(user.uid).set({'email': user.email, 'preferences': preferences});
  return user;
}

void main() {
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

  test('Doesn\'t recommend the same restaurant twice in a row', () async {
    final firestore = FakeFirebaseFirestore();
    final auth = MockFirebaseAuth();
    final user = await addUserWithPrefs(firestore, auth, 'yogi@yankees.com', ['Mexican', 'Beverages']);
    await addRestaurant(firestore, chipotle);
    await addRestaurant(firestore, starbucks);
    final recommend = await RestaurantRecommender.forUser(firestore, user);

    // run it a few times just to be sure
    for (var i = 0; i < 10; i++) {
      var first = recommend.recommend(),
          second = recommend.recommend();
      expect(first, isNotNull);
      expect(second, isNotNull);
      expect(first, isNot(equals(second)));
    }
  });

  test('Empty preferences result in everything allowed', () async {
    final firestore = FakeFirebaseFirestore();
    final auth = MockFirebaseAuth();
    final user = await addUserWithPrefs(firestore, auth, 'yogi@yankees.com', []);
    await addRestaurant(firestore, chipotle);
    await addRestaurant(firestore, starbucks);
    final recommend = await RestaurantRecommender.forUser(firestore, user);

    var first = recommend.recommend(),
        last = recommend.recommend();

    if (first.name == 'Chipotle') {
      expect(last.name, equals('Starbucks'));
    } else {
      expect(last.name, equals('Chipotle'));
    }
  });

  test('Recommendations match preferences', () async {
    final firestore = FakeFirebaseFirestore();
    final auth = MockFirebaseAuth();
    final user1 = await addUserWithPrefs(firestore, auth, 'yogi@yankees.com', ['Mexican']);
    await addRestaurant(firestore, chipotle);
    await addRestaurant(firestore, starbucks);
    final recommend1 = await RestaurantRecommender.forUser(firestore, user1);
    for (var i = 0; i < 10; i++) {
      expect(recommend1.recommend().name, equals('Chipotle'));
    }

    final user2 = await addUserWithPrefs(firestore, auth, 'jeter@yankees.com', ['Beverages']);
    final recommend2 = await RestaurantRecommender.forUser(firestore, user2);
    for (var i = 0; i < 10; i++) {
      expect(recommend2.recommend().name, equals('Starbucks'));
    }
  });
}
