import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'customizer.dart';
import 'restaurant_list.dart';
import 'appbar.dart';
import 'restaurants.dart';
import 'firebase_options.dart';
import 'signup.dart';
import 'login.dart';

class JustEatIt extends StatelessWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore store;

  const JustEatIt({Key? key, required this.auth, required this.store})
      : super(key: key);

  static Future initFirebase() {
    return Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Widget build(BuildContext context) {
    const darkGreen = MaterialColor(
      0xFF1B5E20,
      <int, Color>{
        50: Color(0xFF66BB6A),
        100: Color(0xFF4CAF50),
        200: Color(0xFF43A047),
        300: Color(0xFF388E3C),
        400: Color(0xFF2E7D32),
        500: Color(0xFF1B5E20),
        600: Color(0xFF165814),
        700: Color(0xFF10500E),
        800: Color(0xFF10500E),
        900: Color(0xFF10500E),
      },
    );

    return MaterialApp(
      title: 'Just Eat It',
      theme: ThemeData(primarySwatch: darkGreen),
      routes: {
        '/': (context) => MyHomePage(title: 'Just Eat It', auth: auth),
        '/signup': (context) => SignupPage(auth: auth, store: store),
        '/login': (context) => LoginPage(auth: auth),
        '/restaurants': (context) => RestaurantsPage(auth: auth, store: store),
        '/preferences': (context) => CustomizerPage(auth: auth),
        '/list': (context) => RestaurantListPage(auth: auth, store: store),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final FirebaseAuth auth;
  const MyHomePage({Key? key, required this.title, required this.auth})
      : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    double screen_width = MediaQuery.of(context).size.width;
    double screen_height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: JustEatItAppBar.create(context, widget.auth),
      body: Stack(alignment: Alignment.center, children: <Widget>[
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/image17.png'),
                  fit: BoxFit.scaleDown,
                  repeat: ImageRepeat.repeat)),
        ),
        Container(
          height: 0.70 * screen_height,
          width: 0.80 * screen_width,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [BoxShadow(blurRadius: 10)]),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(children: <Widget>[
              Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Welcome to Just Eat It",
                            style: TextStyle(
                                color: Colors.green[800],
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Righteous')),
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          "About Us",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Righteous',
                          ),
                        ),
                        Text(
                          """Just-Eat-It is a mason student project. It was developed with the purpose of making the mason experience more fun, and dynamic for students, faculty, and visitors.
                                \n If youre looking for something new and interesting to eat then we got you covered, our algorithm takes into account all local restaurants, your tastes and preferences, and location to give you  the best new thing to try out. 
                            """,
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Customize your preferences",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Righteous')),
                        Text(
                          "We allow you to set cusine types, your favorite picks,and avoid allergic foods",
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                  )),
              VerticalDivider(width: 10, color: Colors.grey, thickness: 1),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Container(
                  color: Colors.white60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(fontSize: 20),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.amberAccent,
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Lets Eat!",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                            Icon(Icons.navigate_next_outlined)
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Want to Try us?",
                        style: TextStyle(fontSize: 20),
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.greenAccent,
                            padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Create an Account",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                              Icon(Icons.navigate_next_rounded)
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}
