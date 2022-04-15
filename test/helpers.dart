import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:justeatit/firebase_options.dart';

void setupAllFirebaseMocks() {
  setupFirebaseAuthMocks();
}

// Based on https://github.com/firebase/flutterfire/blob/master/packages/firebase_auth/firebase_auth/test/mock.dart
void setupFirebaseAuthMocks() {
   MethodChannelFirebase.channel.setMockMethodCallHandler((call) async {
    if (call.method == 'Firebase#initializeCore') {
      return [
        {
          'name': 'Just-Eat-It',
          'options': {
            'apiKey': DefaultFirebaseOptions.currentPlatform.apiKey,
            'appId': DefaultFirebaseOptions.currentPlatform.appId,
            'messagingSenderId': DefaultFirebaseOptions.currentPlatform.messagingSenderId,
            'projectId': DefaultFirebaseOptions.currentPlatform.projectId,
          },
          'pluginConstants': {},
        }
      ];
    } else if (call.method == 'Firebase#initializeApp') {
      return {
        'name': call.arguments['appName'],
        'options': call.arguments['options'],
        'pluginConstants': {},
      };
    }

    return null;
  });
}

void setDisplayDimensions(WidgetTester tester, { width=1366, height=768}) {
    tester.binding.window.physicalSizeTestValue = const Size(1366, 768);
    tester.binding.window.devicePixelRatioTestValue = 1;
}