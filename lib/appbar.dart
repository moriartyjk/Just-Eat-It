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
    final size = MediaQuery.of(context).size;

    return Row(
      children: [
        Container(
          width: 2*size.width/3,
          color: Colors.green.shade900,
          padding: const EdgeInsets.all(1),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
            child: Row(
              children: [
                TextButton(
                  child: Text('Just Eat It!',
                    style: TextStyle(color: Colors.grey[100], fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false)
                ),
                const SizedBox(width: 100),
                TextButton(
                  child: Text('About',
                    style: TextStyle(color: Colors.grey[100], fontSize: 18),
                  ),
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/about', (_) => false)
                ),
                const SizedBox(width: 60),
                TextButton(
                  child: Text('Preferences',
                    style: TextStyle(color: Colors.grey[100], fontSize: 18),
                  ),
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/preferences', (_) => false)
                ),
                const SizedBox(width: 60),
                TextButton(
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
              ],
            ),
          )
        ),
        Container(
          width: size.width/3,
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
        ),
      ],
    );
  }
}
