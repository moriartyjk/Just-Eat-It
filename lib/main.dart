import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:justeatit/customizer.dart';
import 'package:justeatit/restaurant_list.dart';
import 'package:justeatit/restaurants.dart';
import 'firebase_options.dart';
import 'restaurants.dart';
import 'signup.dart';
import 'login.dart';

int randIndex = 0; //global index

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print(FirebaseAuth.instance.currentUser);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Just Eat It',
      theme: ThemeData(
        primarySwatch: Colors.blue, //figure out better green
      ),
      //home: const MyHomePage(title: 'Just Eat It'),
      routes: {
        '/' :(context) => const MyHomePage(title: 'Just Eat It'),
        '/signup' : (context) => const SignupPage(),
        '/login' : (context) => const LoginPage(),
        '/restaurants' :(context) => const RestaurantsPage(),
        '/cuisine' :(context) => const CustomizerPage(),
        '/list' :(context) => const RestaurantListPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

    @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            TextButton(onPressed: () => {
              Navigator.pushNamed(context, '/signup')
            }, child: const Text("Sign Up")),
            TextButton(onPressed: () => {
              Navigator.pushNamed(context, '/login')
            }, child: const Text("Log in")),
            TextButton(onPressed: () => {
              Navigator.pushNamed(context, '/restaurants')
            }, child: const Text("Restaurant Suggestion")),
             TextButton(onPressed: () => {
              Navigator.pushNamed(context, '/list')
            }, child: const Text("Restaurant List")),
            TextButton(onPressed: () => {
              Navigator.pushNamed(context, '/cuisine')
            }, child: const Text("Cuisine Selection")),
            TextButton(onPressed: () => {
              FirebaseAuth.instance.signOut()
            }, child: const Text("Log out")),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}