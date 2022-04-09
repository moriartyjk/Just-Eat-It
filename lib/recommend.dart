import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Stores the data of a recommended restaurant.
class Restaurant {
  /// The name of the restaurant
  String name;
  /// A few sentences describing the restaurant. TODO.
  String description;
  /// The location of the restaurant, i.e. Johnson Center.
  String location;
  /// A 7-element array of the hours of the restaurant. Each element is for a specific
  /// day of the week.
  List<String> hours;
  /// The dietary options provided by the restaurant, i.e. gluten-free, vegan.
  List<String> dietary;

  /// Initialize a new `Restaurant` with the given data.
  Restaurant(this.name, this.location, this.description, this.hours, this.dietary);

  /// Create a new restaurant from the given Firestore record. This handles all the
  /// necessary `dynamic` -> `String` or `dynamic` ->` List<String>` conversions and throws
  /// exceptions if unable to convert.
  static Restaurant fromRecord(QueryDocumentSnapshot<Map<String, dynamic>> record) {
    var data = record.data();
    // default description value, since this isn't yet provided
    data['description'] = 'Craving a warm, steaming burrito? Or crunchy chips topped with cold guacamole? Chipotle is the go-to spot on campus for mexican food. With four different kinds of meat and dozens of options, Chipotle is certain to have something for everyone, even if you\'re vegan, or gluten free! But be sure to come a few minutes early, there\'s always a line.';

    // runtime type checks
    if (data['name'] is! String) {
      throw Exception('invalid name for restaurants/${record.id}');
    } else if (data['location'] is! String) {
      throw Exception('invalid location for restaurants/${record.id}');
    } else if (data['description'] is! String) {
      throw Exception('invalid description for restaurants/${record.id}');
    } else if (data['hours'] is! List) {
      throw Exception('invalid hours for restaurants/${record.id}');
    } else if (data['dietary'] is! List) {
      throw Exception('invalid dietary for restaurants/${record.id}');
    }

    return Restaurant(data['name'],
                      data['location'],
                      data['description'],
                      List<String>.from(data['hours']),
                      List<String>.from(data['dietary']));
  }
}

/// A class to recommend determine which restaurant to recommend, given user
/// history, preferences, and a list of qualifying restaurants. A lot of the
/// calculations are actually done at init time, inside `forUser`.
class RestaurantRecommender {
  /// The user's preferences
  List<QueryDocumentSnapshot<Map<String, dynamic>>> preferences;
  /// The user's restaurant history
  List<QueryDocumentSnapshot<Map<String, dynamic>>> history;
  /// A list of possible restaurants that could be recommended to the user.
  /// This could be all restaurants, but will usually be filtered by dietary
  /// or culinary preferences.
  List<QueryDocumentSnapshot<Map<String, dynamic>>> restaurants;
  /// A list of all past recommendations. This is used to ensure that a restaurant
  /// isn't re-recommended when trying again.
  List<Restaurant> recommendations = [];

  /// Initialize a `RestaurantRecommender` with the given data.
  RestaurantRecommender(this.preferences, this.history, this.restaurants);

  /// Initialize a `RestaurantRecommender`, fetching the data for the given user.
  /// This should fail if the given user is not currently logged in.
  static Future<RestaurantRecommender> forUser(User user) async {
    var firestore = FirebaseFirestore.instance;
    var preferencesFuture = firestore.collection('preferences')
                                     .where('user', isEqualTo: user.uid)
                                     .get();
    var historyFuture = firestore.collection('history')
                                 .where('user', isEqualTo: user.uid)
                                 .get();
    // separating xFuture from x allows us to load them faster
    var preferences = await preferencesFuture;
    var history = await historyFuture;
    var restaurantsFuture = firestore.collection('restaurants')
                                     .get(); // todo check preferences and history

    return RestaurantRecommender(preferences.docs, history.docs, (await restaurantsFuture).docs);
  }

  /// Actually recommend a restaurant.
  Restaurant recommend() {
    var random = Random(DateTime.now().millisecondsSinceEpoch).nextInt(restaurants.length);
    random = 0;
    return Restaurant.fromRecord(restaurants[random]);
  }
}