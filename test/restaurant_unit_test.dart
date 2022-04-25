import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:justeatit/recommend.dart';

Future<DocumentSnapshot<Map<String, dynamic>>> addRestaurant(FirebaseFirestore firestore, Map<String, dynamic> data) async {
  return await (await firestore.collection('restaurants').add(data)).get();
}

dynamic throwsRestaurantFormatError([String substr = '']) {
  return throwsA((item) =>
    item is RestaurantFormatError && item.toString().contains(substr)
  );
}

void main() {
  test('Restaurant.fromRecord converts a record to a Restaurant', () async {
    var doc = await addRestaurant(FakeFirebaseFirestore(), {
          'name': 'Chipotle',
          'location': '123 Main Street',
          'hours': ['10 AM - 10 PM'],
          'dietary': [],
          'description': 'Mexican food.'
        }),
        restaurant = Restaurant.fromRecord(doc);

    expect(restaurant.name, equals('Chipotle'));
    expect(restaurant.location, equals('123 Main Street'));
    expect(restaurant.hours, equals(['10 AM - 10 PM']));
    expect(restaurant.dietary, equals([]));
    expect(restaurant.description, equals('Mexican food.'));

  });

  test('Restaurant.fromRecord checks type errors', () async {
    var doc1 = await addRestaurant(FakeFirebaseFirestore(), {}),
        doc2 = await addRestaurant(FakeFirebaseFirestore(), { 'name': null, 'location': '123', 'hours': [], 'dietary': [], 'description': 'hi' }),
        doc3 = await addRestaurant(FakeFirebaseFirestore(), { 'name': 'abc', 'location': null, 'hours': [], 'dietary': [], 'description': 'hi' }),
        doc4 = await addRestaurant(FakeFirebaseFirestore(), { 'name': 'abc', 'location': '123', 'hours': null, 'dietary': [], 'description': 'hi' }),
        doc5 = await addRestaurant(FakeFirebaseFirestore(), { 'name': 'abc', 'location': '123', 'hours': [], 'dietary': null, 'description': 'hi' }),
        doc6 = await addRestaurant(FakeFirebaseFirestore(), { 'name': 'abc', 'location': '123', 'hours': [], 'dietary': [], 'description': null });

    expect(() => Restaurant.fromRecord(doc1), throwsRestaurantFormatError('unable to fetch'));
    expect(() => Restaurant.fromRecord(doc2), throwsRestaurantFormatError('invalid name'));
    expect(() => Restaurant.fromRecord(doc3), throwsRestaurantFormatError('invalid location'));
    expect(() => Restaurant.fromRecord(doc4), throwsRestaurantFormatError('invalid hours'));
    expect(() => Restaurant.fromRecord(doc5), throwsRestaurantFormatError('invalid dietary'));
    expect(() => Restaurant.fromRecord(doc6), throwsRestaurantFormatError('invalid description'));
  });
}
