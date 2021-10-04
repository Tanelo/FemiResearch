import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:fetch_voice_data/constants.dart';
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
  late Animation<double> rotationAnimation;
  late AnimationController rotationController;
  late Animation<Offset> slideAnimation;
  late Animation<Offset> slideAnimation2;
  bool isPanelOpen = false;

  @override
  void dispose() {
    animationControllerSize.dispose();
    animationControllerShadow.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    isPanelOpen = false;
    double height = widget.height;
    double width = widget.width;
    rotationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..addListener(() {
        setState(() {});
      });
    rotationAnimation = Tween<double>(begin: -pi / 2, end: pi / 2).animate(
      CurvedAnimation(parent: rotationController, curve: Curves.easeInOutQuart),
    );
    slideAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0, 5.2)).animate(
      CurvedAnimation(parent: rotationController, curve: Curves.linear),
    );
    slideAnimation2 =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0, -0.2)).animate(
      CurvedAnimation(parent: rotationController, curve: Curves.linear),
    );
    // Future.delayed(const Duration(seconds: 4), () {
    //   if (pc.isAttached) {
    //     pc.open();
    //   }
    // });

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
    double dmax = height * 0.09;
    double padding = widget.height * 0.03;
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
                          blurRadius: 20)
                    ],
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      // image: NetworkImage(imagesUrls.elementAt(index)),
                      image: index == 0
                          ? const AssetImage("assets/logo_femi_rounded.jpg")
                              as ImageProvider<Object>
                          : NetworkImage(imagesUrls.elementAt(index)),
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
        snapPoint: 0.6,
        // isDraggable: false,
        controller: pc,
        minHeight: 0,
        maxHeight: height * 0.95,
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
            ),
          ),
          child: Stack(
            children: [
              Stack(
                children: widgets,
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: height * 0.1,
                    left: height * 0.03,
                    right: height * 0.03,
                    bottom: height * 0.06),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Bienvenue sur Femi",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            // fontFamily: "Nunito",
                            color: Colors.white,
                            fontSize: height * 0.03,
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
                    const Spacer(),

                    Align(
                      alignment: Alignment.center,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(height * 0.045),
                          ),
                          side: const BorderSide(color: Colors.white, width: 1),
                        ),
                        onPressed: () {
                          pc.animatePanelToSnapPoint();
                        },
                        child: SizedBox(
                          width: height * 0.15,
                          child: Center(
                            child: Text(
                              "Commencer",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: height * 0.024,
                                fontWeight: FontWeight.bold,
                                // fontFamily: "MuseoSans700"),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // } else {
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget panel() {
    return Padding(
      padding: EdgeInsets.only(
          left: widget.height * 0.03,
          right: widget.height * 0.03,
          top: widget.height * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Bienvenue",
            style: TextStyle(
              // fontFamily: "Nunito",
              fontSize: widget.height * 0.03,
              color: Colors.deepPurple[300]!,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: widget.height * 0.045),
          SizedBox(
            height: widget.height * 0.3,
            width: widget.width,
            child: AutoSizeText(
              "Nous sommes l'équipe de FEMI.\n\nNous avons besoin de toi pour lancer notre projet !\n\nDans cette application, on te propose de réciter des textes en association avec une certaine émotion (tu peux également improviser). Il y a une dizaine de textes à réciter. Tu peux toujours décider de passer au suivant.\n\nAlors c'est parti, sors nous ton meilleur jeu d'acteur !",
              textAlign: TextAlign.justify,
              style: TextStyle(
                // fontFamily: "MuseoSans700",
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.deepPurple[200]!,
              ),
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              if (!isPanelOpen) {
                rotationController.forward();
                pc.animatePanelToPosition(1,
                    duration: const Duration(milliseconds: 300));
              } else {
                rotationController.reverse();
                pc.animatePanelToSnapPoint(
                    duration: const Duration(milliseconds: 300));
              }

              setState(() {
                isPanelOpen = !isPanelOpen;
              });
            },
            child: Row(
              children: [
                Text(
                  "En savoir plus",
                  style: TextStyle(
                    color: Colors.deepPurple[300]!,
                    fontSize: widget.height * 0.025,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: widget.height * 0.025),
                Transform(
                  origin: const Offset(8, 8),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: widget.height * 0.032,
                    color: Colors.deepPurple[300]!,
                  ),
                  transform: Matrix4.identity()
                    ..rotateZ(-rotationAnimation.value),
                ),
              ],
            ),
          ),
          SizedBox(
            height: widget.height * 0.03,
          ),
          Expanded(
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 30),
                  left: 0,
                  right: 0,
                  bottom:
                      widget.height * 0.35 * (1 - rotationController.value) +
                          widget.height * 0.07,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: RawMaterialButton(
                      elevation: 2.0,
                      onPressed: () async {
                        await pc.close();
                        rotationController.reset();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecordHome(
                              userId: widget.userId,
                              width: widget.width,
                              height: widget.height,
                            ),
                          ),
                        );
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
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: rotationController.value,
                  child: SizedBox(
                    height: widget.height * 0.37,
                    width: widget.width,
                    child: AutoSizeText(
                      "Nous sommes Samuel Lerman et Tanel Petelot, étudiants à CentraleSupélec et travaillons sur un projet reliant la voix avec les émotions.\n\nNous avons besoin de toi pour entraîner des réseaux de neurones profonds, dont l'objectif est de détecter les émotions directement avec le ton, le timbre, les fréquences de la voix.\n\nRassure toi les enregistrements audio ne seronts ni diffusés ni utilisés à des fins commerciales.\n\n En cliquant sur le bouton ci-dessous, tu acceptes que l'on utilise tes enregistrements à ces activités de recherche.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        // fontFamily: "MuseoSans700",
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.deepPurple[200]!,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
