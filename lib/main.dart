import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'just_eat_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustEatIt.initFirebase();
  runApp(
    JustEatIt(
      auth: FirebaseAuth.instance,
      store: FirebaseFirestore.instance
    )
  );
}
