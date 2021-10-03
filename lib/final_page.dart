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

class FinalPage extends StatefulWidget {
  final double height;
  final double width;
  const FinalPage({
    required this.height,
    required this.width,
    Key? key,
  }) : super(key: key);

  @override
  _FinalPageState createState() => _FinalPageState();
}

class _FinalPageState extends State<FinalPage> with TickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // print(height);
    // print(width);
    return Scaffold(
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
              padding: const EdgeInsets.only(
                  top: 70, left: 20, right: 20, bottom: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Merci pour ta participation !",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          // fontFamily: "Nunito",
                          color: Colors.white,
                          fontSize: 24,
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

                  // } else {
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}