import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';
import 'appbar.dart';
import 'login.dart';
import 'recommend.dart';

class RestaurantsPage extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore store;

  const RestaurantsPage({ Key? key, required this.auth, required this.store }) : super(key: key);

  @override
  State<RestaurantsPage> createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage> {
  /// width of the slot machine animation
  final double videoWidth = 600;
  /// used to scroll down automatically
  final pageController = PageController();
  /// used to play the animation
  final videoController = VideoPlayerController.asset('assets/slot_machine.mp4');
  /// actually does the recommendation
  RestaurantRecommender? recommender;
  /// currently recommended restaurant
  Restaurant? recommended;
  /// current rating of the current restaurant (0 - unrated)
  int rating = 0;

  @override
  void initState() {
    super.initState();
    videoController.initialize().then((_) => setState(() {}));

    final user = widget.auth.currentUser;
    if (user != null) {
      RestaurantRecommender.forUser(widget.store, user).then((r) => recommender = r);
    }
  }

  /// clean up the videoController
  @override
  void dispose() {
    super.dispose();
    videoController.pause();
    videoController.dispose();
  }

  /// wait until the animation ends, then scroll down
  void waitForVideoEnd() {
    if (videoController.value.position.inMilliseconds >= 6000) {
      videoController.removeListener(waitForVideoEnd);
      setState(() => recommended = recommender!.recommend());
      pageController.animateTo(1000, duration: const Duration(milliseconds: 1000), curve: Curves.easeIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.auth.currentUser == null) {
      /// soft redirect to the login page
      return LoginPage(auth: widget.auth);
    } else {
      final placeholder = SizedBox(width: videoWidth, height: videoWidth/2);
      final size = MediaQuery.of(context).size;
      final video = SizedBox(
          width: videoWidth,
          child: AspectRatio(
            aspectRatio: videoController.value.aspectRatio,
            child: VideoPlayer(videoController)
        ),
      );

      return Scaffold(
        appBar: JustEatItAppBar.create(context),
        body: Center(
          child: PageView(
            scrollDirection: Axis.vertical,
            controller: pageController,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(children: [
                    Divider(height: size.height/30),
                    videoController.value.isInitialized ? video : placeholder,
                    Divider(height: size.height/10),
                    ElevatedButton(
                      onPressed: getRecommendation,
                      child: const Text('Go!', style: TextStyle(fontSize: 25)),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green.shade900,
                        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                        shadowColor: Colors.black
                      ),
                    )
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

  /// Render the current recommendation or the "scroll up to get a recommendation" message.
  Widget buildRecommendationView(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (recommended != null) {
      return Column(
        children: [
          Container(height: size.height/5),
          buildRecommendationHeader(),
          Container(height: size.height/40),
          SizedBox(
            width: size.width/2,
            child: Column(
              children: [
                Text(recommended!.description, style: const TextStyle(fontSize: 18)),
                Container(height: size.height/20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      const Icon(Icons.location_pin),
                      Text(recommended!.location),
                    ]),
                    buildDietaryList(),
                    Row(children: [
                      const Icon(Icons.access_time),
                      Text(recommended!.hours[DateTime.now().weekday-1]), //subtract 1 to align with database array
                    ]),
                  ],
                ),
                Container(height: size.height/20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildRatingView(context),
                    ElevatedButton.icon(
                      onPressed: refreshRecommendation,
                      icon: const Icon(Icons.replay_outlined),
                      label: const Text('Something else, please'),
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 15),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20)
                      ),
                    )
                  ]
                )
              ]
            )
          ),
        ],
      );
    } else {
      /// This is only visible if the user scrolls down before getting a recommendation.
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Press Go! to get a recommendation!', style: TextStyle(fontSize: 20)),
          IconButton(
            color: Colors.green.shade900,
            splashRadius: 20,
            icon: const Icon(Icons.arrow_upward_rounded),
            onPressed: () => pageController.animateTo(0, duration: const Duration(milliseconds: 250), curve: Curves.linear))
        ],
      );
    }
  }

  /// get and display a recommendation
  void getRecommendation() {
    videoController.play();
    videoController.addListener(waitForVideoEnd);
  }

  /// clear recommendation state and get another recommendation
  void refreshRecommendation() {
    rating = 0;
    recommended = null;
    pageController.animateTo(0, duration: const Duration(milliseconds: 400), curve: Curves.linear);
    getRecommendation();
  }

  /// Render recommendation header. The message is determined based on the current time, to vary things.
  Widget buildRecommendationHeader() {
    final headers = [
      ['How about ', ' ?'],
      ['Ever tried ', '?'],
      ['We recommend ', ''],
      ['Why not ', '?'],
      ['Try ', '!'],
      ['Eat at ', '!'],
      ['Care for some ', '?']
    ];
    final header = headers[DateTime.now().hour % headers.length];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(header[0], style: const TextStyle(fontSize: 30)),
        Text(recommended!.name, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        Text(header[1], style: const TextStyle(fontSize: 30)),
      ],
    );
  }

  /// Render a Row listing the various dietary options available for the recommendation.
  Widget buildDietaryList() {
    final map = {
      'gluten-free': ['GF', 'Has gluten free options (maybe contamination)'],
      'dairy-free': ['DF', 'Has dairy free options (maybe contamination)'],
      'vegan': ['Vegan', 'Has vegan options'],
      'halal': ['HL', 'Has halal options'],
    };

    var icons = recommended!.dietary.map((diet) {
      var val = map[diet];
      if (val != null) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Container(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Tooltip(
                  child: Text(val[0], style: const TextStyle(color: Colors.black)),
                  message: val[1]
                ),
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1.5),
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.shade100
              ),
            ),
        );
      }
    });

    return Row(children: icons.whereType<Widget>().toList());
  }

  /// Render the rating widgets.
  Widget buildRatingView(BuildContext context) {
    var stars = List<IconButton>.generate(5, (i) {
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