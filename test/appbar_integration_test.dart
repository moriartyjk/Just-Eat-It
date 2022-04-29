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
import 'package:justeatit/signup.dart';

import 'helpers.dart';

class AppBarWrapper extends StatelessWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore store = FakeFirebaseFirestore();

  AppBarWrapper({Key? key, required this.auth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: JustEatItAppBar(auth: auth)),
      routes: {
         //'/pref_nav': (context) => CustomizerNav(auth: auth),
         '/preferences': (context) => CustomizerPage(auth: auth),         
         '/login' : (context) => LoginPage(auth : auth),
         '/signup': (context) => SignupPage(auth: auth, store: store),
         '/about' : (context) => LoginPage(auth : auth),
      },
    );
  }
}

void main() {
  setUpAll(() async {
    setupAllFirebaseMocks();
    await JustEatIt.initFirebase();
  });

  testWidgets('Appbar has correct elements', (tester) async {
    setDisplayDimensions(tester);
    await tester.pumpWidget(AppBarWrapper(auth: MockFirebaseAuth()));
    expect(find.text('Just Eat It!'), findsWidgets);
    expect(find.text('About'), findsWidgets);
    //expect(find.text('Preferences'), findsWidgets);
    expect(find.text('Log In'), findsWidgets);

  });

testWidgets('Appbar maintains state after clicking JustEatIt', (tester) async {
    setDisplayDimensions(tester);
    await tester.pumpWidget(AppBarWrapper(auth: MockFirebaseAuth()));
    await tester.tap(find.widgetWithText(TextButton, 'Just Eat It!'));
    expect(find.text('Just Eat It!'), findsWidgets);
    expect(find.text('About'), findsWidgets);
    //expect(find.text('Preferences'), findsWidgets);
    expect(find.text('Log In'), findsWidgets);
  });

  testWidgets('Appbar maintains state after clicking Log In', (tester) async {
    setDisplayDimensions(tester);
    await tester.pumpWidget(AppBarWrapper(auth: MockFirebaseAuth()));
    await tester.tap(find.widgetWithText(TextButton, 'Log In'));
    expect(find.text('Just Eat It!'), findsWidgets);
    expect(find.text('About'), findsWidgets);
    //expect(find.text('Preferences'), findsWidgets);
    expect(find.text('Log In'), findsWidgets);
  });

  testWidgets('Appbar maintains state after clicking About', (tester) async {
    setDisplayDimensions(tester);
    await tester.pumpWidget(AppBarWrapper(auth: MockFirebaseAuth()));
    await tester.tap(find.widgetWithText(TextButton, 'About'));
    expect(find.text('Just Eat It!'), findsWidgets);
    expect(find.text('About'), findsWidgets);
    //expect(find.text('Preferences'), findsWidgets);
    expect(find.text('Log In'), findsWidgets);
  });

   testWidgets('Appbar allows you to logout after logging in', (tester) async {
    setDisplayDimensions(tester);
    MockUser test = MockUser(email :'jonny@jonny.com');
    final jonny = MockFirebaseAuth(signedIn : true, mockUser : test);
    await tester.pumpWidget(AppBarWrapper(auth: jonny));
    expect(find.text('Just Eat It!'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);
    expect(find.text('Options'), findsOneWidget);
    expect(find.text('Log Out'), findsOneWidget);
    await tester.tap(find.text("Log Out"));
    expect(jonny.currentUser, isNull);
  });

   testWidgets('Can customers click customize preferences', (tester) async {
    setDisplayDimensions(tester);
    MockUser test = MockUser(email :'jonny@jonny.com');
    final jonny = MockFirebaseAuth(signedIn : true, mockUser : test);
    await tester.pumpWidget(AppBarWrapper(auth: jonny));
    expect(find.text('Just Eat It!'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);
    expect(find.text('Options'), findsOneWidget);
    expect(find.text('Log Out'), findsOneWidget);
    await tester.tap(find.text("Options"));
    await tester.pumpAndSettle(Duration(milliseconds : 100));
    await tester.tap(find.text("Cuisine Preferences"));
    await tester.pumpAndSettle(Duration(milliseconds : 100));
    expect (find.text('Cuisine Options'), findsOneWidget);
    expect (find.text('Applied Preferences'), findsOneWidget);
    expect (find.text('Refresh Preferences'), findsOneWidget);
    expect (find.text('Get Recommendation'), findsOneWidget);
   });
  // testWidgets('Gives errors on bad inputs', (tester) async {
  //   setDisplayDimensions(tester);
  //   var auth = MockFirebaseAuth(
  //     authExceptions: AuthExceptions(
  //       signInWithEmailAndPassword: FirebaseAuthException(code: 'invalid-email')
  //     )
  //   );
  //   await tester.pumpWidget(LoginPageWrapper(auth: auth));
  //   await tester.enterText(find.byType(TextField).first, '');
  //   await tester.enterText(find.byType(TextField).last, '');
  //   await tester.tap(find.widgetWithText(ElevatedButton, 'Log In'));
  //   await tester.pump();
  //   expect(find.text('Please enter your email'), findsOneWidget);
  //   expect(find.text('Please enter a password'), findsOneWidget);
  //   expect(auth.currentUser, isNull);

  //   await tester.enterText(find.byType(TextField).first, 'bad');
  //   await tester.enterText(find.byType(TextField).last, '123');
  //   await tester.tap(find.widgetWithText(ElevatedButton, 'Log In'));
  //   await tester.pump();
  //   expect(find.textContaining('isn\'t a valid email'), findsOneWidget);
  //   expect(auth.currentUser, isNull);
  // });
}
