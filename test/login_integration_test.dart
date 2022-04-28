import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:justeatit/custom_nav.dart';
import 'package:justeatit/just_eat_it.dart';
import 'package:justeatit/login.dart';
import 'package:justeatit/restaurants.dart';
import 'package:justeatit/signup.dart';

import 'helpers.dart';

class LoginPageWrapper extends StatelessWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore store = FakeFirebaseFirestore();

  LoginPageWrapper({Key? key, required this.auth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(auth: auth),
      routes: {
        '/restaurants': (context) => RestaurantsPage(auth: auth, store: store),
        '/signup': (context) => SignupPage(auth: auth, store: store),
      },
    );
  }
}

void main() {
  setUpAll(() async {
    setupAllFirebaseMocks();
    await JustEatIt.initFirebase();
  });

  testWidgets('Login page has correct elements', (tester) async {
    setDisplayDimensions(tester);
    await tester.pumpWidget(LoginPageWrapper(auth: MockFirebaseAuth()));
    expect(find.text('Log In'), findsWidgets);
    expect(find.text('Email'), findsWidgets);
    expect(find.text('Password'), findsWidgets);
    expect(find.text('Create one now!'), findsWidgets);
  });

  testWidgets('Gives errors on bad inputs', (tester) async {
    setDisplayDimensions(tester);
    var auth = MockFirebaseAuth(
      authExceptions: AuthExceptions(
        signInWithEmailAndPassword: FirebaseAuthException(code: 'invalid-email')
      )
    );
    await tester.pumpWidget(LoginPageWrapper(auth: auth));
    await tester.enterText(find.byType(TextField).first, '');
    await tester.enterText(find.byType(TextField).last, '');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Log In'));
    await tester.pump();
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter a password'), findsOneWidget);
    expect(auth.currentUser, isNull);

    await tester.enterText(find.byType(TextField).first, 'bad');
    await tester.enterText(find.byType(TextField).last, '123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Log In'));
    await tester.pump();
    expect(find.textContaining('isn\'t a valid email'), findsOneWidget);
    expect(auth.currentUser, isNull);
  });

  testWidgets('Show/hide password works', (tester) async {
    setDisplayDimensions(tester);
    await tester.pumpWidget(LoginPageWrapper(auth: MockFirebaseAuth()));
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
    final auth = MockFirebaseAuth(
      mockUser: MockUser(email: 'test@gmu.edu'),
      signedIn: false,
    );
    await tester.pumpWidget(LoginPageWrapper(auth: auth));
    await tester.enterText(find.byType(TextField).first, 'test@gmu.edu');
    await tester.enterText(find.byType(TextField).last, '123');
    expect(auth.currentUser, isNull);
    await tester.tap(find.widgetWithText(ElevatedButton, 'Log In'));
    await tester.pump();
    expect(auth.currentUser, isNotNull);
    expect(auth.currentUser!.email, equals('test@gmu.edu'));
  });

  testWidgets('Can switch to signup page', (tester) async {
    setDisplayDimensions(tester);
    await tester.pumpWidget(LoginPageWrapper(auth: MockFirebaseAuth()));
    await tester.tap(find.widgetWithText(TextButton, 'Create one now!'));
    await tester.pump();
    expect(find.textContaining('Sign Up'), findsWidgets);
  });
}
