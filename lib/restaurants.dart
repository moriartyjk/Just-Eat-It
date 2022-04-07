import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';
import 'appbar.dart';

class RestaurantsPage extends StatefulWidget {
  const RestaurantsPage({ Key? key }) : super(key: key);

  @override
  State<RestaurantsPage> createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage> {

  final double videoWidth = 600;

  final scrollController = ScrollController();
  final videoController = VideoPlayerController.asset('slot_machine.mp4');
  final firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    videoController.initialize().then((_) => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    videoController.pause();
    videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        child: ListView(
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
                    child: Text('Go!', style: TextStyle(fontSize: 25)),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green.shade900,
                      padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                      shadowColor: Colors.black
                    ),
                    onPressed: () {
                      videoController.play();
                    },)
                ]),
                Container()
              ]
            ),
          ]
        ),
      )
    );

    // Actual algorithm:
    // CollectionReference restaurants = FirebaseFirestore.instance.collection("restaurants");


    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text("Restaurant Suggestions"),
    //   ),
    //   body: Center(
    //     //This is based on implementation from Flutter docs in https://firebase.flutter.dev/docs/firestore/usage/
    //     child: FutureBuilder<DocumentSnapshot>(
    //       future: restaurants.doc(docID).get(),
    //       builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    //         if(snapshot.hasError){
    //           return const Text("Something went wrong");
    //         }

    //         if(snapshot.hasData && !snapshot.data!.exists){
    //           return const Text("Document does not exist",);
    //         }

    //         if(snapshot.connectionState == ConnectionState.done) {
    //           Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
    //           return Text(
    //             "Document Id: $docID\nName: ${data["name"]}",
    //             style: const TextStyle(fontSize: 40),
    //           );
    //         }
    //         return const Text("loading"); //appears while firestore is retrieving data
    //       },
    //     ),
    //     ),
    //     floatingActionButton: FloatingActionButton(
    //     onPressed: _randGen, //trigger random number generation
    //     tooltip: 'Retry',
    //     child: const Icon(Icons.refresh),
    //   ),
    // );
  }
}