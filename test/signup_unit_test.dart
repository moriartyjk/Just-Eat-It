import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:justeatit/signup.dart';

void main() {
  test('SignupPageState#validateEmail checks for empty and invalid emails', () {
    final state = SignupPageState();
    expect(state.validateEmail(null), equals('Please enter a valid email'));
    expect(state.validateEmail('hello'), equals('Please enter a valid email'));
    expect(state.validateEmail('jeter@yankees.com'), isNull);
  });

  test('SignupPageState#isValidEmail check for email-ness', () {
    final state = SignupPageState();
    expect(state.isValidEmail('@.com'), isFalse);
    expect(state.isValidEmail('jeter@yankees'), isTrue);
    expect(state.isValidEmail('jeter@yankees.com'), isTrue);
  });

  test('SignupPageState#validatePassword checks for empty and short passwords', () {
    final state = SignupPageState();
    expect(state.validatePassword(null), equals('Please enter a password'));
    expect(state.validatePassword('test'), equals('Please enter a password at least eight characters long'));
    expect(state.validatePassword('test1234'), isNull);
  });

  test('SignupPageState#handleFirebaseAuthError handles errors', () {
    final state = SignupPageState();
    state.handleFirebaseAuthError(FirebaseAuthException(code: 'email-already-in-use'));
    expect(state.formError, contains('An account already exists'));
    state.handleFirebaseAuthError(FirebaseAuthException(code: 'invalid-email'));
    expect(state.formError, contains('Please enter a valid email.'));
    state.handleFirebaseAuthError(FirebaseAuthException(code: 'operation-not-allowed'));
    expect(state.formError, contains('Not allowed'));
    state.handleFirebaseAuthError(FirebaseAuthException(code: 'weak-password'));
    expect(state.formError, contains('Please enter a stronger password.'));
    state.handleFirebaseAuthError(FirebaseAuthException(code: 'unknown-error'));
    expect(state.formError, contains('An error occurred (unknown-error)'));
  });
}