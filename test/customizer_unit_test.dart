import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:justeatit/customizer.dart';

import 'recommend_unit_test.dart';

void main(){

  //these will be about checking whether the data base is updated correctly and stuff like that...

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

  test('removeAll() empties the _saved list', () async {
    final firestore = FakeFirebaseFirestore();
    final auth = MockFirebaseAuth();
    final user = await addUserWithPrefs(firestore, auth, 'bb8@tochestation.com', ['Mexican', 'Beverages']);
    await addRestaurant(firestore, chipotle);
    await addRestaurant(firestore, starbucks);
   



  });

} //end of main