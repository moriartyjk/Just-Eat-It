import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:justeatit/customizer.dart';
import 'package:justeatit/just_eat_it.dart';
import 'package:justeatit/login.dart';
import 'package:justeatit/restaurants.dart';
import 'package:justeatit/signup.dart';

import 'helpers.dart';

class SignupPageWrapper extends StatelessWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore store = FakeFirebaseFirestore();

  SignupPageWrapper({Key? key, required this.auth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignupPage(auth: auth, store: store),
      routes: {
        '/restaurants': (context) => RestaurantsPage(auth: auth, store: store),
        '/login': (context) => LoginPage(auth: auth),
        '/preferences': (context) => CustomizerPage(auth: auth),
      },
    );
  }
}

void main() {
  setUpAll(() async {
    setupAllFirebaseMocks();
    await JustEatIt.initFirebase();
  });

  testWidgets('Signup page has correct elements', (tester) async {
    setDisplayDimensions(tester);
    await tester.pumpWidget(SignupPageWrapper(auth: MockFirebaseAuth()));
    expect(find.text('Sign Up'), findsWidgets);
    expect(find.text('Email'), findsWidgets);
    expect(find.text('Password'), findsWidgets);
    expect(find.text('Already have an account?'), findsWidgets);
  });

  testWidgets('Gives errors on bad inputs', (tester) async {
    setDisplayDimensions(tester);
    var auth = MockFirebaseAuth(
      authExceptions: AuthExceptions(
        createUserWithEmailAndPassword: FirebaseAuthException(code: 'email-already-in-use')
      )
    );
    await tester.pumpWidget(SignupPageWrapper(auth: auth));
    await tester.enterText(find.byType(TextField).first, '');
    await tester.enterText(find.byType(TextField).last, '');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Submit'));
    await tester.pump();
    expect(find.text('Please enter a valid email'), findsOneWidget);
    expect(find.text('Please enter a password'), findsOneWidget);
    expect(auth.currentUser, isNull);

    await tester.enterText(find.byType(TextField).first, 'mickey@yankees.com');
    await tester.enterText(find.byType(TextField).last, 'test1234');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Submit'));
    await tester.pump();
    expect(find.textContaining('account already exists'), findsOneWidget);
    expect(auth.currentUser, isNull);
  });

  testWidgets('Show/hide password works', (tester) async {
    setDisplayDimensions(tester);
    await tester.pumpWidget(SignupPageWrapper(auth: MockFirebaseAuth()));
    final passwordFinder = find.byType(TextField).last;
    await tester.enterText(passwordFinder, 'test1234');
    await tester.tap(find.byIcon(Icons.visibility_off_outlined));
    await tester.pump();
    expect((tester.widget(passwordFinder) as TextField).obscureText, isFalse);
    await tester.tap(find.byIcon(Icons.visibility_outlined));
    await tester.pump();
    expect((tester.widget(passwordFinder) as TextField).obscureText, isTrue);
  });

   testWidgets('Succeeds if inputs are valid', (tester) async {
    setDisplayDimensions(tester);
    final auth = MockFirebaseAuth();
    await tester.pumpWidget(SignupPageWrapper(auth: auth));
    await tester.enterText(find.byType(TextField).first, 'yogi@yankees.com');
    await tester.enterText(find.byType(TextField).last, 'test1234');
    expect(auth.currentUser, isNull);
    await tester.tap(find.widgetWithText(ElevatedButton, 'Submit'));
    await tester.pump();
    expect(auth.currentUser, isNotNull);
    expect(auth.currentUser!.email, equals('yogi@yankees.com'));
  });

  testWidgets('Can switch to login page', (tester) async {
    setDisplayDimensions(tester);
    await tester.pumpWidget(SignupPageWrapper(auth: MockFirebaseAuth()));
    await tester.tap(find.widgetWithText(TextButton, 'Log in'));
    await tester.pump();
    expect(find.textContaining('Log In'), findsWidgets);
  });
}
