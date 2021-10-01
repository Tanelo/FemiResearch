import 'package:dotted_border/dotted_border.dart';
import 'package:fetch_voice_data/constants.dart';
import 'package:fetch_voice_data/explication.dart';
import 'package:fetch_voice_data/firebase/firbase_api.dart';
import 'package:fetch_voice_data/record/record_home.dart';
import 'package:fetch_voice_data/utils/utils_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MyHomePage extends StatefulWidget {
  final String userId;
  final double height;
  final double width;
  const MyHomePage({
    required this.userId,
    required this.height,
    required this.width,
    Key? key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  String profileImageUrl =
      "https://i.pinimg.com/736x/68/16/3e/68163efb3c2201721d8e681cde6aef2b.jpg";

  late AnimationController animationControllerSize;
  late Animation shadowAnimation;
  late AnimationController animationControllerShadow;

  List<String> imagesUrls = [
    "https://www.macobserver.com/wp-content/uploads/2019/09/workfeatured-iOS-13-memoji.png",
    "http://andc-scale.livewallcampaigns.com/imageScaled/scale?site=andc&w=1200&h=630&cropped=1&file=1537355257_animoji-header.jpg",
    "https://i.pinimg.com/originals/2d/9c/f1/2d9cf10d9a21f2c704b3c64f5b838705.jpg",
    "https://cdn131.picsart.com/318342880280201.jpg?type=webp&to=crop&r=256",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTcrE0PW5HgoZSUsvbReIhaTG51xFGKfGcCBQ&usqp=CAU",
    "https://cdn141.picsart.com/350586194089201.jpg",
    "https://www.the-sun.com/wp-content/uploads/sites/6/2020/02/DD-COMPOSITE-EYE-ROLL-EMOJI-2.jpg?strip=all&quality=100&w=1200&h=800&crop=1",
  ];

  List<Widget> widgets = [];
  List<Map<String, double>> coords = [];

  @override
  void dispose() {
    animationControllerSize.dispose();
    animationControllerShadow.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    double height = widget.height;
    double width = widget.width;
    Future.delayed(const Duration(seconds: 4), () {
      if (pc.isAttached) {
        pc.open();
      }
    });

    animationControllerShadow = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        setState(() {});
      });
    shadowAnimation = MaterialPointArcTween(
      begin: const Offset(5, 5),
      end: const Offset(-5, -5),
    ).animate(
      CurvedAnimation(
          parent: animationControllerShadow, curve: Curves.easeInOutQuart),
    );
    animationControllerSize = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    animationControllerSize.repeat();

    int n = imagesUrls.length;
    double d = 1 / (n + 1);
    List<double> delays = List.generate(n, (index) => d * index);
    double dmax = 80;
    double padding = 20;
    List<double> radii = [2 * (dmax + padding), 4 * dmax + 2 * padding];
    coords = NodeDisposition.defineCoords(
        imagesUrls.length, height, width, dmax, padding);
    List<Widget> circles = radii
        .map(
          (radius) => Center(
            child: DottedBorder(
              borderType: BorderType.Circle,
              color: Colors.white,
              dashPattern: const [10, 5],
              strokeWidth: 1,
              child: Container(
                height: radius,
                width: radius,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
        )
        .toList();
    List<Widget> storyCards = coords
        .asMap()
        .map((index, coord) {
          return MapEntry(
            index,
            Positioned(
              bottom: coord["y"]! - (coord["size"]! ~/ 2),
              left: coord["x"]! - (coord["size"]! ~/ 2),
              child: ScaleTransition(
                scale: BackAndForthTween(
                        begin: 0.90, end: 1.00, delay: delays.elementAt(index))
                    .animate(animationControllerSize),
                child: Container(
                  height: coord["size"]!,
                  width: coord["size"]!,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.purple[100]!.withOpacity(0.92),
                          offset: const Offset(0.0, 3.0),
                          blurRadius: 25)
                    ],
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(imagesUrls.elementAt(index)),
                    ),
                  ),
                ),
              ),
            ),
          );
        })
        .values
        .toList();
    widgets.addAll(circles);
    widgets.addAll(storyCards);
  }

  PanelController pc = PanelController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // print(height);
    // print(width);
    return Scaffold(
      body: SlidingUpPanel(
        controller: pc,
        minHeight: 0,
        maxHeight: height * 0.5,
        backdropEnabled: true,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        panel: panel(),
        body: Container(
          height: Constants.height,
          width: Constants.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.pink[400]!.withOpacity(0.800),
              Colors.blue[300]!.withOpacity(0.800),
            ],
          )),
          child: Stack(
            children: [
              Stack(
                children: widgets,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 100, left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Bienvenue sur Femi",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "MuseoSans700",
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // GestureDetector(
                        //   onTap: () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => AddMessagePage(
                        //                 myUser: widget.myUser,
                        //                 relationships: widget.relationships,
                        //                 friends: friends)));
                        //   },
                        //   child: Row(
                        //     children: [
                        //       Icon(
                        //         Icons.message_rounded,
                        //         color: Colors.grey[750],
                        //         size: 30,
                        //       ),
                        //       Icon(
                        //         Icons.person_search_outlined,
                        //         size: 30,
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),

                  // } else {
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget panel() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Hi! We are thrilled to have you here",
            style: TextStyle(
              // fontFamily: "MuseoSans700",
              fontSize: 20,
              color: Colors.deepPurple[300]!,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          Text(
            "We are FEMI, a soon to be vocal experience where you will be connected to content you might like and on which you will be able to discuss with other people. \n\nIn order for us to launch this experience, we need you to record your voice with different moods. This will allow us to give you the content you want according to your mood.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              // fontFamily: "MuseoSans700",
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.deepPurple[200]!,
            ),
          ),
          const SizedBox(height: 30),
          Align(
            alignment: Alignment.center,
            child: RawMaterialButton(
              elevation: 2.0,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ExplicationPage(
                              userId: widget.userId,
                              width: widget.width,
                              height: widget.height,
                            )));
                // MaterialPageRoute(
                //     builder: (context) => RecordHome(
                //           userId: widget.userId,
                //           width: widget.width,
                //           height: widget.height,
                //         )));
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              fillColor: Colors.deepPurple[300]!,
              child: const SizedBox(
                width: 120,
                child: Center(
                  child: Text(
                    "Let's go",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      // fontFamily: "MuseoSans700"),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
