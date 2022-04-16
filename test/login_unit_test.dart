import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:justeatit/login.dart';

void main() {
  test('LoginPageState#validateEmail checks for empty emails', () {
    final state = LoginPageState();
    expect(state.validateEmail(null), equals('Please enter your email'));
    expect(state.validateEmail(''), equals('Please enter your email'));
    expect(state.validateEmail('jeter@example.com'), isNull);

  });

  test('LoginPageState#validatePassword checks for empty passwords', () {
    final state = LoginPageState();
    expect(state.validatePassword(null), equals('Please enter a password'));
    expect(state.validatePassword(''), equals('Please enter a password'));
    expect(state.validatePassword('test'), isNull);
  });

  test('LoginPageState#handleFirebaseAuthError handles errors', () {
    final state = LoginPageState();
    state.handleFirebaseAuthError(FirebaseAuthException(code: 'invalid-email'));
    expect(state.formError, contains('isn\'t a valid email'));
    state.handleFirebaseAuthError(FirebaseAuthException(code: 'user-disabled'));
    expect(state.formError, contains('This account has been disabled.'));
    state.handleFirebaseAuthError(FirebaseAuthException(code: 'user-not-found'));
    expect(state.formError, contains('Invalid email/password combination'));
    state.handleFirebaseAuthError(FirebaseAuthException(code: 'wrong-password'));
    expect(state.formError, contains('Invalid email/password combination'));
    state.handleFirebaseAuthError(FirebaseAuthException(code: 'too-many-requests'));
    expect(state.formError, contains('You have made too many requests.'));
    state.handleFirebaseAuthError(FirebaseAuthException(code: 'unknown-error'));
    expect(state.formError, contains('An error occurred (unknown-error)'));
  });
}