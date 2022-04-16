import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';
import 'appbar.dart';
import 'login.dart';
import 'recommend.dart';

class RestaurantsPage extends StatefulWidget {
  final FirebaseAuth auth;

  const RestaurantsPage({ Key? key, required this.auth }) : super(key: key);

  @override
  State<RestaurantsPage> createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage> {

  final double videoWidth = 600;

  final scrollController = PageController();
  final videoController = VideoPlayerController.asset('assets/slot_machine.mp4');
  final firestore = FirebaseFirestore.instance;

  RestaurantRecommender? recommender;
  Restaurant? recommended;
  int rating = 0;

  @override
  void initState() {
    super.initState();
    videoController.initialize().then((_) => setState(() {}));

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      RestaurantRecommender.forUser(user).then((r) => recommender = r);
    }
  }

  @override
  void dispose() {
    super.dispose();
    videoController.pause();
    videoController.dispose();
  }

  void waitForVideoEnd() {
    if (videoController.value.position.inMilliseconds >= 6000) {
      videoController.removeListener(waitForVideoEnd);
      setState(() => recommended = recommender!.recommend());
      scrollController.animateTo(1000, duration: const Duration(milliseconds: 1000), curve: Curves.easeIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.auth.currentUser;
    if (user == null) {
      return LoginPage(auth: widget.auth);
    } else {
      final video = SizedBox(
          width: videoWidth,
          child: AspectRatio(
            aspectRatio: videoController.value.aspectRatio,
            child: VideoPlayer(videoController)
        ),
      );
      final placeholder = SizedBox(width: videoWidth, height: videoWidth);
      final size = MediaQuery.of(context).size;

      return Scaffold(
        appBar: JustEatItAppBar.create(context),
        body: Center(
          child: PageView(
            scrollDirection: Axis.vertical,
            controller: scrollController,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(children: [
                    Divider(height: size.height/30),
                    videoController.value.isInitialized ? video : placeholder,
                    Divider(height: size.height/10),
                    ElevatedButton(
                      child: const Text('Go!', style: TextStyle(fontSize: 25)),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green.shade900,
                        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                        shadowColor: Colors.black
                      ),
                      onPressed: () {
                        videoController.play();
                        videoController.addListener(waitForVideoEnd);
                      },)
                  ]),
                  Container()
                ]
              ),
              buildRecommendationView(context),
            ]
          ),
        )
      );
    }
  }

  Widget buildRecommendationView(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (recommended != null) {
      return Column(
        children: [
          Container(height: size.height/5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'How about ',
                style: TextStyle(fontSize: 30),
              ),
              Text(
                recommended!.name,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold
                )
              ),
              const Text(
                '?',
                style: TextStyle(fontSize: 30)
              ),
            ],
          ),
          Container(height: size.height/40),
          Container(
            width: size.width/2,
            child: Column(
              children: [
                Text(
                  recommended!.description,
                  style: const TextStyle(fontSize: 18)
                ),
                Container(height: size.height/20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      const Icon(Icons.location_pin),
                      Text(recommended!.location),
                    ]),
                    Row(children: [
                      const Icon(Icons.access_time),
                      Text(recommended!.hours[DateTime.now().weekday]),
                    ]),
                  ],
                ),
                Container(height: size.height/20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildRatingView(context),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.replay_outlined),
                      label: const Text('Something else, please'),
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 15),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20)
                      ),
                      onPressed: () {
                        setState(() {
                          rating = 0;
                          recommended = null;
                          scrollController.animateTo(0, duration: const Duration(milliseconds: 400), curve: Curves.linear);
                          videoController.play();
                          videoController.addListener(waitForVideoEnd);
                        });
                      },
                    )
                  ]
                )
              ]
            )
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Press Go! to get a recommendation!',
            style: TextStyle(fontSize: 20),
          ),
          IconButton(
            color: Colors.green.shade900,
            splashRadius: 20,
            icon: const Icon(Icons.arrow_upward_rounded),
            onPressed: () => scrollController.animateTo(0, duration: const Duration(milliseconds: 250), curve: Curves.linear))
        ],
      );
    }
  }

  Widget buildRatingView(BuildContext context) {
    var stars = List<IconButton>.generate(3, (i) {
      return IconButton(
        icon: Icon(rating > i ? Icons.star : Icons.star_border),
        onPressed: () => setState(() => rating = (i+1)),
        splashRadius: 25,
        color: Colors.amber.shade800,
        iconSize: 40,
      );
    });

    return Row(children: stars);
  }
}