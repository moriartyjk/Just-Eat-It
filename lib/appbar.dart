import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class JustEatItAppBar extends StatefulWidget {
  const JustEatItAppBar({ Key? key }) : super(key: key);

  @override
  State<JustEatItAppBar> createState() => JustEatItAppBarState();

  static PreferredSizeWidget create(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return PreferredSize(
      preferredSize: Size(size.width, 60),
      child: const JustEatItAppBar()
    );
  }
}

class JustEatItAppBarState extends State<JustEatItAppBar> {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 2,
          child: Container(
            color: Colors.green.shade900,
            padding: const EdgeInsets.all(1),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 2,
                    child: TextButton(
                      child: Text('Just Eat It!',
                        style: TextStyle(color: Colors.grey[100], fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false)
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: TextButton(
                      child: Text('About',
                        style: TextStyle(color: Colors.grey[100], fontSize: 18),
                      ),
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/about', (_) => false)
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: TextButton(
                      child: Text(
                        auth.currentUser == null ? 'Log In' : 'Log Out',
                        style: TextStyle(color: Colors.grey[100], fontSize: 18),
                      ),
                      onPressed: () {
                        if (auth.currentUser == null) {
                          Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
                        } else {
                          FirebaseAuth.instance.signOut();
                          Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                        }
                      }
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    //if user isn't signed in, empty text, if user is signed in, create pop up
                    child: auth.currentUser == null ? const Text("") : PopupMenuButton(
                      child: Text(
                        "Options",
                        style: TextStyle(color: Colors.grey[100], fontSize: 18),
                        ),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          child: Text("Cuisine Preferences"),
                          value: '/preferences',
                        ),
                        const PopupMenuItem(
                          child: Text("See All Restaurants"),
                          value: '/list',
                        ),
                      ],
                      onSelected: (value) {
                        Navigator.pushNamedAndRemoveUntil(context, value.toString(), (_) => false);
                      },
                    ),
                    /*
                    child: TextButton(
                      child: Text(
                        auth.currentUser == null ? '' : 'Options',
                        style: TextStyle(color: Colors.grey[100], fontSize: 18),
                      ),
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/pref_nav', (_) => false)
                    ), */
                  ),
                  Flexible(flex: 2, child: Container())
                ],
              ),
            )
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: const Alignment(-0.7, 2),
                tileMode: TileMode.repeated,
                stops: const [ 0, 0.5, 0.5, 1 ],
                colors: [
                  Colors.green.shade900,
                  Colors.green.shade900,
                  Colors.amber.shade800,
                  Colors.amber.shade800,
                ]
              )
            ),
          )
        ),
      ],
    );
  }
}
